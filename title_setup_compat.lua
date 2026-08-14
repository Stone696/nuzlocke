-- Nuzlocke title/setup compatibility adapter.
--
-- Intentionally split from main.lua in 2.0.0-beta.30.0.0.15 with explicit
-- project approval. Gen1Recomp 0.1.86's Sandbox documents load(mod:read(...))
-- as the supported multi-file pattern for a mod's own source. This module owns
-- ONLY the fresh-game title SETUP fallback introduced in 30.0.0.13.
--
-- Runtime impact expectation: title/menu startup only. It must not change core
-- Nuzlocke rules, saves, encounters, battles, tracker, randomizers, provider
-- compatibility, or Gold gameplay after title selection. Those expectations
-- remain RETEST REQUIRED until Blue and Gold runtime smoke tests pass.

local M = {}

function M.install(mod, deps)
    deps = deps or {}
    local Strings = assert(deps.Strings, "title setup compat requires Strings")
    local openSetup = assert(deps.openSetup, "title setup compat requires openSetup")
    local isSaveEditorSession = deps.isSaveEditorSession or function() return false end

    local function rowLabel(item)
        if type(item) ~= "table" then return nil end
        local label = item.label
        if type(label) == "table" then
            label = label.source or label.text or label.label
        end
        return type(label) == "string" and label:upper() or nil
    end

    local function hasSetupRow(items)
        if type(items) ~= "table" then return false end
        for _, item in ipairs(items) do
            if type(item) == "table" and (item.nuzlockeSetup == true
                or item.value == "nuzlocke_setup"
                or rowLabel(item) == "SETUP") then
                return true
            end
        end
        return false
    end

    local function hasContinueRow(items)
        if type(items) ~= "table" then return false end
        for _, item in ipairs(items) do
            if type(item) == "table" and (item.value == "continue"
                or rowLabel(item) == "CONTINUE") then
                return true
            end
        end
        return false
    end

    local function insertBeforeNew(items, row)
        if type(items) ~= "table" then return false end
        for i, item in ipairs(items) do
            if type(item) == "table" and (item.value == "new"
                or rowLabel(item) == "NEW GAME") then
                table.insert(items, i, row)
                return true
            end
        end
        return false
    end

    local function installRby()
        if isSaveEditorSession() then return true end
        local ok, TitleState = pcall(require, "src.ui.TitleState")
        if not ok or type(TitleState) ~= "table"
            or type(TitleState.openMenu) ~= "function" then return false end
        if TitleState.__nuzlockeSetupFallbackOwner == mod
            and TitleState.openMenu == TitleState.__nuzlockeSetupFallbackFunction then
            return true
        end

        local previous = TitleState.openMenu
        local wrapper
        wrapper = function(self, ...)
            local result = previous(self, ...)
            local stack = self.game and self.game.stack
            local menu = stack and stack.top and stack:top() or nil
            local items = menu and menu.items
            if type(items) == "table" and not hasContinueRow(items)
                and not hasSetupRow(items) then
                local inserted = insertBeforeNew(items, {
                    label = Strings("SETUP"),
                    nuzlockeSetup = true,
                    onSelect = function() openSetup(self.game, false) end,
                })
                if inserted then
                    if type(menu.th) == "number" then menu.th = menu.th + 2 end
                    if type(menu.titleUiBox) == "table"
                        and type(menu.titleUiBox[4]) == "number" then
                        menu.titleUiBox[4] = menu.titleUiBox[4] + 2
                    end
                end
            end
            return result
        end
        TitleState.openMenu = wrapper
        TitleState.__nuzlockeSetupFallbackOwner = mod
        TitleState.__nuzlockeSetupFallbackPrevious = previous
        TitleState.__nuzlockeSetupFallbackFunction = wrapper
        return true
    end

    -------------------------------------------------------------------------
    -- GOLD FALLBACK DISABLED IN 2.0.0-beta.30.1.1
    --
    -- Runtime test: selecting NEW GAME -> SETUP on Gold crashed in the
    -- promoted 30.1.0 candidate.
    --
    -- Comparison against the last published 2.0.0-beta.29.1.0 confirmed that
    -- the older/runtime-PASS Gold design already consists of:
    --   1) shared ui.title_menu.items row injection in main.lua
    --   2) the small src.ui.gen2.MainMenu:choose() adapter in main.lua
    --
    -- The buildList() fallback below was added later during 0.1.86 startup
    -- compatibility work. It is therefore the Gold delta being withdrawn.
    --
    -- DO NOT DELETE: preserved verbatim for future diagnosis/recovery.
    -------------------------------------------------------------------------
    --[[
    local function installGold()
        if isSaveEditorSession() then return true end
        local ok, MainMenu = pcall(require, "src.ui.gen2.MainMenu")
        if not ok or type(MainMenu) ~= "table"
            or type(MainMenu.buildList) ~= "function" then return false end
        if MainMenu.__nuzlockeSetupListFallbackOwner == mod
            and MainMenu.buildList == MainMenu.__nuzlockeSetupListFallbackFunction then
            return true
        end

        local previous = MainMenu.buildList
        local wrapper
        wrapper = function(self, ...)
            local result = previous(self, ...)
            local list = self.list
            local items = list and list.items
            if self.hasSave ~= true and type(items) == "table"
                and not hasSetupRow(items) then
                insertBeforeNew(items, {
                    label = Strings("SETUP"),
                    value = "nuzlocke_setup",
                    nuzlockeSetup = true,
                })
            end
            return result
        end
        MainMenu.buildList = wrapper
        MainMenu.__nuzlockeSetupListFallbackOwner = mod
        MainMenu.__nuzlockeSetupListFallbackPrevious = previous
        MainMenu.__nuzlockeSetupListFallbackFunction = wrapper
        return true
    end
    ]]

    local function installGold()
        -- Intentionally dormant. Gold uses the previously published/shared
        -- title hook + MainMenu:choose() path only.
        return true
    end

    local function installAll()
        pcall(installRby)
        pcall(installGold)
    end

    installAll()
    mod.events:on("mods.loaded", installAll)
    mod.events:on("game.ready", installAll)
    return true
end

return M
