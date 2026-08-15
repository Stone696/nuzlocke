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
        -- Install regardless of current save-editor state. The wrapper itself
        -- re-checks that runtime state on every title-menu open, so leaving the
        -- editor in the same process can restore SETUP without lucky event timing.
        local ok, TitleState = pcall(require, "src.ui.TitleState")
        if not ok or type(TitleState) ~= "table"
            or type(TitleState.openMenu) ~= "function" then return false end

        -- 2.1.19+: keep one stable wrapper and refresh its mutable dependencies
        -- on every mod reload. This avoids both wrapper re-stacking and stale
        -- openSetup/String closures from an older mod instance. The state may
        -- remain below another mod's wrapper; refreshing it is still safe.
        local state = TitleState.__nuzlockeSetupFallbackState
        if type(state) == "table" and type(state.wrapper) == "function" then
            state.Strings = Strings
            state.openSetup = openSetup
            state.isSaveEditorSession = isSaveEditorSession
            state.hasSetupRow = hasSetupRow
            state.hasContinueRow = hasContinueRow
            state.insertBeforeNew = insertBeforeNew
            state.ownerId = mod.id or "nuzlocke"
            return true
        end

        -- Migrate the exact 2.1.18 legacy wrapper when it is still the top
        -- TitleState.openMenu function. If another mod already wrapped above
        -- that legacy function, leave the foreign chain intact and add one
        -- stable outer wrapper; it rewires any legacy SETUP row to the current
        -- openSetup callback after the previous chain has finished.
        local previous = TitleState.openMenu
        local legacy = TitleState.__nuzlockeSetupFallbackFunction
        local legacyPrevious = TitleState.__nuzlockeSetupFallbackPrevious
        if previous == legacy and type(legacyPrevious) == "function" then
            previous = legacyPrevious
        end

        state = {
            Strings = Strings,
            openSetup = openSetup,
            isSaveEditorSession = isSaveEditorSession,
            hasSetupRow = hasSetupRow,
            hasContinueRow = hasContinueRow,
            insertBeforeNew = insertBeforeNew,
            ownerId = mod.id or "nuzlocke",
            previous = previous,
        }

        local function currentSetupRow(items)
            if type(items) ~= "table" then return nil end
            for _, item in ipairs(items) do
                if type(item) == "table" and (item.nuzlockeSetup == true
                    or item.value == "nuzlocke_setup") then
                    return item
                end
            end
            return nil
        end

        local wrapper
        wrapper = function(self, ...)
            local result = state.previous(self, ...)
            local stack = self.game and self.game.stack
            local menu = stack and stack.top and stack:top() or nil
            local items = menu and menu.items

            -- Save-editor status is session/runtime state, not an install-time
            -- invariant. Re-check on every title-menu open before touching the
            -- final vanilla row list. During the one-time 2.1.18 migration a
            -- foreign wrapper may still leave the legacy Nuzlocke wrapper lower
            -- in the chain; remove only Nuzlocke-owned SETUP rows in editor mode
            -- so that stale legacy closure cannot defeat current suppression.
            if state.isSaveEditorSession() then
                if type(items) == "table" then
                    local removed = 0
                    for i = #items, 1, -1 do
                        local item = items[i]
                        if type(item) == "table" and (item.nuzlockeSetup == true
                            or item.value == "nuzlocke_setup") then
                            table.remove(items, i)
                            removed = removed + 1
                        end
                    end
                    if removed > 0 then
                        if type(menu.th) == "number" then
                            menu.th = math.max(0, menu.th - removed * 2)
                        end
                        if type(menu.titleUiBox) == "table"
                            and type(menu.titleUiBox[4]) == "number" then
                            menu.titleUiBox[4] = math.max(0,
                                menu.titleUiBox[4] - removed * 2)
                        end
                    end
                end
                return result
            end
            if type(items) ~= "table" then return result end

            -- A 2.1.18 wrapper left below another mod may already have inserted
            -- SETUP using a stale closure. Rebind that row to this reload's
            -- openSetup instead of adding a duplicate.
            local existing = currentSetupRow(items)
            if existing then
                existing.label = state.Strings("SETUP")
                existing.nuzlockeSetup = true
                existing.onSelect = function()
                    state.openSetup(self.game, false)
                end
                return result
            end

            if not state.hasContinueRow(items) and not state.hasSetupRow(items) then
                local inserted = state.insertBeforeNew(items, {
                    label = state.Strings("SETUP"),
                    nuzlockeSetup = true,
                    onSelect = function() state.openSetup(self.game, false) end,
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
        state.wrapper = wrapper
        TitleState.openMenu = wrapper
        TitleState.__nuzlockeSetupFallbackState = state
        -- Retain these fields for safe recognition/migration by older tooling.
        TitleState.__nuzlockeSetupFallbackOwner = state.ownerId
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
