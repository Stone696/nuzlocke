-- Optional Gen1 Modern UI presentation adapter for Nuzlocke.
--
-- Nuzlocke remains the source of truth for every row and semantic action.
-- This module never changes challenge rules, encounters, saves, or input state.
-- If the provider is absent/unsupported, native Nuzlocke screens remain intact.

return function(mod, deps)
    deps = deps or {}
    local Strings = deps.translate or function(v) return tostring(v) end


    ---------------------------------------------------------------------
    -- GEN1 VARIABLE-WIDTH TILE-FONT PRESENTATION
    --
    -- Inspired by the compatibility review of SliferDaG/TextKerningGen1Recomp.
    -- This is an independent Nuzlocke implementation: presentation only,
    -- generation-gated on every call, and deliberately inert on Gold/Gen2.
    ---------------------------------------------------------------------
    mod.exports.__beta26 = mod.exports.__beta26 or {}
    mod.exports.__beta26.Gen1Kerning =
        mod.exports.__beta26.Gen1Kerning or {}
    local kerning = mod.exports.__beta26.Gen1Kerning

    local glyphAdvance = {
        [0xA8] = 3, -- i
        [0xAB] = 3, -- l
        [0xA9] = 6, -- j
        [0x7F] = 6, -- space
        [0xE8] = 4, -- .
        [0xE0] = 6, -- '\''
        [0xF4] = 4, -- ,
        [0xB3] = 7, -- t
        [0xB4] = 7, -- u
        [0xB5] = 7, -- v
        [0xA7] = 7, -- h
        [0xAD] = 7, -- n
        [0xB8] = 7, -- y
        [0xBC] = 7, -- apostrophe-l ligature
    }
    local glyphShift = {
        [0xA8] = -2, -- i
        [0xAB] = -2, -- l
        [0xA9] = -1, -- j
        [0xAD] = -1, -- n
    }

    local function confirmedGen1(game)
        if not game or type(deps.isGold) ~= "function" then return false end
        local ok, gold = pcall(deps.isGold, game)
        return ok and gold == false
    end

    local function activeGame()
        if type(deps.getCurrentGame) == "function" then
            local ok, game = pcall(deps.getCurrentGame)
            if ok and game then return game end
        end
        return mod.game
    end

    local function kerningEnabled()
        return confirmedGen1(activeGame())
    end

    function kerning.install()
        local ok, Font = pcall(require, "src.render.Font")
        if not ok or type(Font) ~= "table"
            or type(Font.advanceOf) ~= "function" then
            kerning.lastError = "Font module unavailable"
            return false, kerning.lastError
        end

        -- Font is a require() singleton and can outlive a Nuzlocke reload.
        -- A marker left on that singleton is therefore not proof that the
        -- wrapper belongs to THIS copy of the mod. Keep the same
        -- owner/previous/wrapper identity used by the other direct wrappers.
        local session = Font._nuzlockeKerningSession
        local function sessionIsLive(row)
            return type(row) == "table"
                and type(row.advanceWrapper) == "function"
                and Font.advanceOf == row.advanceWrapper
                and (row.drawWrapper == nil or Font.drawCode == row.drawWrapper)
        end
        local function sessionIsAlreadyUnwrapped(row)
            return type(row) == "table"
                and type(row.previousAdvance) == "function"
                and Font.advanceOf == row.previousAdvance
                and (row.drawWrapper == nil or Font.drawCode == row.previousDraw)
        end
        local function clearSessionMarkers(row)
            if type(row) == "table" then
                if Font._nuzlockeAdvanceOf == row.previousAdvance then
                    Font._nuzlockeAdvanceOf = nil
                end
                if Font._nuzlockeDrawCode == row.previousDraw then
                    Font._nuzlockeDrawCode = nil
                end
            end
            Font._nuzlockeKerningSession = nil
        end

        if type(session) == "table" then
            if session.token == kerning and sessionIsLive(session) then
                kerning.installed = true
                kerning.externalProvider = false
                kerning.reloadBlocked = nil
                kerning.lastError = nil
                return true
            end
            if sessionIsLive(session) then
                -- Exact stale Nuzlocke wrappers are still top-level, so they
                -- can be removed without disturbing a wrapper owned by another
                -- mod. Rebind below against the now-live predecessor.
                Font.advanceOf = session.previousAdvance
                if session.drawWrapper ~= nil then
                    Font.drawCode = session.previousDraw
                end
                clearSessionMarkers(session)
            elseif sessionIsAlreadyUnwrapped(session) then
                -- Another owner restored our predecessor exactly. The stale
                -- record can be discarded safely before normal installation.
                clearSessionMarkers(session)
            else
                -- A foreign wrapper may sit above the old Nuzlocke closure.
                -- Reaching through it would risk deleting another mod's work
                -- or double-applying kerning. A fresh process is the safe
                -- migration boundary for this ambiguous chain.
                kerning.installed = false
                kerning.externalProvider = false
                kerning.reloadBlocked = true
                kerning.lastError = "stale kerning wrapper is not top-level; restart required"
                return false, kerning.lastError
            end
        elseif Font._nuzlockeAdvanceOf ~= nil
            or Font._nuzlockeDrawCode ~= nil then
            -- <=2.5.21 stored only predecessor markers, not wrapper identity.
            -- If the live methods ARE those predecessors the markers are just
            -- stale and can be cleared. Otherwise we cannot prove whether an
            -- old Nuzlocke wrapper is top-level or buried under a foreign one,
            -- so do not guess: one fresh process establishes the new session.
            local previousAdvance = Font._nuzlockeAdvanceOf
            local previousDraw = Font._nuzlockeDrawCode
            if Font.advanceOf == previousAdvance
                and (previousDraw == nil or Font.drawCode == previousDraw) then
                Font._nuzlockeAdvanceOf = nil
                Font._nuzlockeDrawCode = nil
            else
                kerning.installed = false
                kerning.externalProvider = false
                kerning.reloadBlocked = true
                kerning.lastError = "legacy kerning wrapper detected; restart required"
                return false, kerning.lastError
            end
        end

        -- The reviewed standalone kerning mod publishes _origAdvanceOf. If it
        -- already owns the surface, do not stack another width transform.
        if Font._origAdvanceOf ~= nil then
            kerning.externalProvider = true
            kerning.reloadBlocked = nil
            kerning.lastError = nil
            return false, "existing kerning provider"
        end

        local baseAdvance = Font.advanceOf
        local advanceWrapper
        advanceWrapper = function(code, ...)
            if kerningEnabled() then
                local width = glyphAdvance[code]
                if width ~= nil then return width end
            end
            return baseAdvance(code, ...)
        end

        local baseDraw, drawWrapper
        if type(Font.drawCode) == "function" then
            baseDraw = Font.drawCode
            drawWrapper = function(code, x, y, ...)
                if kerningEnabled() then
                    local dx = glyphShift[code]
                    if dx ~= nil then x = x + dx end
                end
                return baseDraw(code, x, y, ...)
            end
        end

        Font._nuzlockeAdvanceOf = baseAdvance
        Font.advanceOf = advanceWrapper
        if drawWrapper ~= nil then
            Font._nuzlockeDrawCode = baseDraw
            Font.drawCode = drawWrapper
        end
        Font._nuzlockeKerningSession = {
            owner = mod,
            token = kerning,
            previousAdvance = baseAdvance,
            advanceWrapper = advanceWrapper,
            previousDraw = baseDraw,
            drawWrapper = drawWrapper,
        }

        kerning.installed = true
        kerning.externalProvider = false
        kerning.reloadBlocked = nil
        kerning.lastError = nil
        return true
    end

    -- Font may not be loaded yet when this split module is evaluated. Retry
    -- after lifecycle events without coupling installation to the active game.
    -- The wrappers themselves remain Gen1-only through kerningEnabled().
    -- 2.3.12: do not import/patch Font during the mod load phase.
    -- game.ready/save.loaded listeners below perform the first safe install.

    local function provider()
        if type(mod.find) ~= "function" then return nil end
        local ok, handle = pcall(mod.find, "gen1_modern_ui")
        if not ok or type(handle) ~= "table" then return nil end
        local exports = handle.exports
        if type(exports) ~= "table"
            or type(exports.registerAdapter) ~= "function" then
            return nil
        end
        return handle
    end

    local function model(game, state)
        if not confirmedGen1(game or mod.game) then return nil end
        if type(state) ~= "table"
            or type(state.nuzlockeModernUiModel) ~= "function" then
            return nil
        end
        local ok, result = pcall(state.nuzlockeModernUiModel, state)
        if not ok or type(result) ~= "table" then return nil end
        return result
    end

    local function action(name)
        return function(game, state, payload)
            if not confirmedGen1(game or mod.game) then return false end
            if type(state) ~= "table"
                or type(state.nuzlockeModernUiAction) ~= "function" then
                return false
            end
            local ok, result = pcall(
                state.nuzlockeModernUiAction, state, name, payload)
            return ok and result == true
        end
    end

    local sharedActions = {
        up = action("up"),
        down = action("down"),
        left = action("left"),
        right = action("right"),
        select = action("select"),
        back = action("back"),
        start = action("start"),
    }

    mod.exports.gen1ModernUi = {
        apiVersion = 1,
        screens = {
            NuzlockeTrackerScreen = {
                match = function(state)
                    return type(state) == "table"
                        and state.screenId == "NuzlockeTrackerScreen"
                end,
                model = model,
                actions = sharedActions,
                layer = "screen",
                canSuppressNative = true,
            },
            NuzlockeCatchInfoScreen = {
                match = function(state)
                    return type(state) == "table"
                        and state.screenId == "NuzlockeCatchInfoScreen"
                end,
                model = model,
                actions = sharedActions,
                layer = "screen",
                canSuppressNative = true,
            },
            NuzlockeTrainerCardScreen = {
                match = function(state)
                    return type(state) == "table"
                        and state.screenId == "NuzlockeTrainerCardScreen"
                end,
                model = model,
                actions = sharedActions,
                layer = "screen",
                canSuppressNative = true,
            },
        },
    }

    mod.exports.__beta26.ModernUiIntegration =
        mod.exports.__beta26.ModernUiIntegration or {}
    local state = mod.exports.__beta26.ModernUiIntegration
    state.contract = mod.exports.gen1ModernUi

    function state.tryRegister(gameHint)
        local game = mod.game
        if type(gameHint) == "table" then
            if type(gameHint.game) == "table" then
                game = gameHint.game
            elseif gameHint.save ~= nil and gameHint.input ~= nil then
                game = gameHint
            end
        end

        -- Unknown generation is never permission to register a Gen1-only
        -- adapter. Lifecycle events retry once the active game is known.
        if not game then
            state.active = false
            state.lastError = "game not ready"
            return false, state.lastError
        end
        if type(deps.isGold) ~= "function" then
            state.active = false
            state.lastError = "generation resolver unavailable"
            return false, state.lastError
        end
        local okGold, gold = pcall(deps.isGold, game)
        if not okGold then
            state.active = false
            state.lastError = "generation unresolved"
            return false, state.lastError
        end
        if gold == true then
            -- The provider may not expose an unregister contract. Keep the
            -- historical registration marker, but make every adapter callback
            -- inert while Gold/Gen2 is active.
            state.active = false
            state.lastError = "gen1 only"
            return false, state.lastError
        end

        -- Retry until successful, then never register the same adapter twice.
        if state.registered then
            state.active = true
            state.lastError = nil
            return true
        end

        local ui = provider()
        if not ui then
            state.active = false
            state.lastError = "provider unavailable"
            return false, state.lastError
        end

        local ok, registered, reason = pcall(
            ui.exports.registerAdapter, {
                owner = mod.id or "nuzlocke",
                contract = mod.exports.gen1ModernUi,
            })
        if not ok then
            state.active = false
            state.providerId = nil
            state.lastError = tostring(registered)
            return false, state.lastError
        end
        -- The provider's released contract returns explicit true on success
        -- and false, reason on refusal. Treat nil/other values as failure so a
        -- provider-side early return cannot leave us reporting a phantom link.
        if registered ~= true then
            state.registered = false
            state.active = false
            state.providerId = nil
            state.lastError = tostring(reason or "registration refused")
            return false, state.lastError
        end
        state.registered = true
        state.active = true
        state.providerId = "gen1_modern_ui"
        state.lastError = nil
        return true
    end

    -- Retry because load order is intentionally not a dependency. Registration
    -- itself is one-shot; later lifecycle calls only refresh current activity.
    -- 2.3.12: provider registration begins at lifecycle events below.
    if mod.events and type(mod.events.on) == "function" then
        -- 2.3.12: do not patch Font during game.ready because that event fires
        -- before the first screen. The first kerning install waits for a real
        -- save load; native fixed-width rendering remains the safe fallback.
        mod.events:on("save.loaded", function()
            if not kerning.installed and not kerning.externalProvider
                and not kerning.reloadBlocked then
                pcall(kerning.install)
            end
        end)
        mod.events:on("mods.loaded", function(ev) pcall(state.tryRegister, ev) end)
        mod.events:on("game.ready", function(ev) pcall(state.tryRegister, ev) end)
        mod.events:on("save.loaded", function(ev) pcall(state.tryRegister, ev) end)
    end
end
