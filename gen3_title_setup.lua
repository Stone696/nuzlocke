-- Gen 3 native boot/title adapter.
-- Uses the existing Boot and BootModules seams without modifying Gen1Recomp.
-- FRLG enters new game through Boot's deferred fade action; RSE/RS dispatch
-- through BootModules.startNewGame. Neither starts before the user confirms.
return function(mod, deps)
    local menu = assert(deps.menu, "title setup needs menu")
    local beginSetup = assert(deps.beginSetup, "title setup needs callback")
    local okBoot, Boot = pcall(require, "src.ui.game3.boot")
    if not okBoot or type(Boot) ~= "table"
        or type(Boot.update) ~= "function"
        or type(Boot.draw) ~= "function" then return false end

    local okModules, Modules = pcall(require, "src.ui.game3.boot_modules")
    local state = Boot.__nuzlockeNewRunSetup
    if type(state) == "table" then
        state.menu = menu
        state.beginSetup = beginSetup
        return true
    end

    state = { menu = menu, beginSetup = beginSetup }
    local previousUpdate, previousDraw = Boot.update, Boot.draw
    local previousStart = okModules and Modules and Modules.startNewGame

    local function open(done)
        if state.menu.isSetupOpen() then return true end
        return state.beginSetup(done)
    end

    Boot.update = function(boot, input, dt)
        if state.menu.isSetupOpen() then
            state.menu.handleInput(input)
            return nil
        end

        -- FireRed / LeafGreen vanilla title: intercept the already-accepted
        -- NEW GAME fade before it launches the native intro.
        local fade = boot and boot.menuFade
        local fadeActive = fade and type(fade.fadeActive) == "function"
            and fade:fadeActive()
        if boot and not boot.custom
            and boot.phase == Boot.PHASE.MENU
            and boot.fadeThen == "new_game"
            and not fadeActive then
            boot.fadeThen = nil
            if open(function(accepted)
                if accepted then
                    boot.fadeThen = "new_game"
                    -- Consume the deferred vanilla action exactly once.
                    previousUpdate(boot, nil, 0)
                end
            end) then
                return nil
            end
            -- Failure to open the setup must not strand the title menu.
            boot.fadeThen = "new_game"
        end
        return previousUpdate(boot, input, dt)
    end

    Boot.draw = function(boot, ...)
        if state.menu.isSetupOpen() then
            state.menu.draw()
            return
        end
        return previousDraw(boot, ...)
    end

    if type(previousStart) == "function" then
        Modules.startNewGame = function(bootModule, boot, ...)
            if state.menu.isSetupOpen() then return end
            local args = { ... }
            local function resume(accepted)
                if accepted then
                    return previousStart(bootModule, boot,
                        (table.unpack or unpack)(args))
                end
                -- Ruby / Sapphire / Emerald: rebuild the title menu on cancel.
                if type(Modules.startMenu) == "function" then
                    Modules.startMenu(bootModule, boot)
                end
            end
            if open(resume) then return end
            return previousStart(bootModule, boot,
                (table.unpack or unpack)(args))
        end
    end

    Boot.__nuzlockeNewRunSetup = state
    return true
end
