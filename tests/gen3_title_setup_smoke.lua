-- Native boot interception test: no ROM or game installation.
local Boot = { PHASE = { MENU = "menu" } }
local nativeClassic, nativeCustom = 0, 0
Boot.update = function(boot)
    if boot.fadeThen == "new_game" then
        nativeClassic = nativeClassic + 1
        boot.fadeThen = nil
    end
end
Boot.draw = function() end
local Modules = {
    startNewGame = function(_, boot)
        nativeCustom = nativeCustom + 1
        boot.started = true
    end,
    startMenu = function(_, boot) boot.cancelled = true end,
}
package.loaded["src.ui.game3.boot"] = Boot
package.loaded["src.ui.game3.boot_modules"] = Modules

local pending
local menu = {
    isSetupOpen = function() return pending ~= nil end,
    handleInput = function() end,
    draw = function() end,
}
local function install()
    local f = assert(loadfile("gen3_title_setup.lua"))()
    assert(f({}, {
        menu = menu,
        beginSetup = function(done) pending = done; return true end,
    }))
end
install()
local classic = { phase = "menu", fadeThen = "new_game",
    menuFade = { fadeActive = function() return false end } }
Boot.update(classic)
assert(pending and nativeClassic == 0,
    "FRLG must open setup before the native game intro")
local done = pending
pending = nil
done(false)
assert(nativeClassic == 0, "B/cancel cannot create a new run")
Boot.update(classic)
assert(nativeClassic == 0, "cancellation must not replay the fade action")
classic.fadeThen = "new_game"
Boot.update(classic)
assert(pending and nativeClassic == 0)
done = pending
pending = nil
done(true)
assert(nativeClassic == 1,
    "confirmed FRLG setup resumes exactly one native intro")

local rse = { phase = "menu", custom = true }
Modules.startNewGame(Modules, rse)
assert(pending and nativeCustom == 0,
    "Emerald/RS must open setup before starting new-game scene")
done = pending
pending = nil
done(true)
assert(nativeCustom == 1 and rse.started,
    "confirmed Emerald/RS setup enters the native intro once")

local cancelled = { phase = "menu", custom = true }
Modules.startNewGame(Modules, cancelled)
done = pending
pending = nil
done(false)
assert(nativeCustom == 1 and cancelled.cancelled,
    "RSE cancellation restores the title menu without creating a save")

-- A mod reload should refresh its callback without stacking wrappers.
install()
local again = { phase = "menu", custom = true }
Modules.startNewGame(Modules, again)
assert(pending and nativeCustom == 1)
done = pending
pending = nil
done(true)
assert(nativeCustom == 2)
print("Gen 3 title setup smoke PASS")
