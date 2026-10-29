-- Tests the next three Gen 3 CORE mechanics without a ROM.
local Extra = assert(loadfile("gen3_extra_core.lua"))()()
local function mon(id, personality, hp, nickname)
    return { species = id, personality = personality, hp = hp, maxHp = 25,
        nickname = nickname, level = 5 }
end
local display = { speciesName = function(p)
    return ({ [25] = "Pikachu", [16] = "Pidgey", [1] = "Bulbasaur" })[p.species]
        or "Unknown"
end }

assert(Extra.openingRival({ kind = "trainer", trainerId = 326,
    battle = { earlyRival = true } }, { version = "firered" }))
assert(not Extra.openingRival({ kind = "trainer", trainerId = 326,
    battle = {} }, { version = "firered" }))
assert(not Extra.openingRival({ kind = "trainer", trainerId = 329,
    battle = { earlyRival = true } }, { version = "firered" }))
for _, v in ipairs({ "ruby", "sapphire", "emerald" }) do
    assert(Extra.openingRival({ kind = "trainer", trainerId = 520,
        battle = {} }, { version = v }), v .. " opening rival")
    assert(not Extra.openingRival({ kind = "trainer", trainerId = 521,
        battle = {} }, { version = v }), v .. " later rival")
end
assert(not Extra.openingRival({ kind = "trainer", trainerId = 520,
    battle = {} }, { version = "firered" }))
assert(not Extra.openingRival({ kind = "wild", trainerId = 520,
    battle = {} }, { version = "emerald" }))

assert(Extra.customName("Spark", "Pikachu"))
assert(not Extra.customName("  pikachu ", "PIKACHU"))
assert(not Extra.customName("  ", "Pikachu"))
assert(not Extra.customName("EGG", "Pikachu"))
local unnamed = mon(25, 11, 20, "")
local named = mon(16, 12, 20, "Birdy")
local boxUnnamed = mon(16, 13, 20, "Pidgey")
local sess = { party = { unnamed, named },
    storage = { boxes = { { mons = { [2] = boxUnnamed,
        [3] = { species = 25, isEgg = true } } } } } }
local state = { graveyard = {} }
local pending = Extra.auditNicknames(state, sess, display)
assert(#pending == 2 and pending[1].mon == unnamed
    and pending[2].mon == boxUnnamed, "audit party and sparse PC")
unnamed.nickname, boxUnnamed.nickname = "Sparky", "Wings"
assert(#Extra.auditNicknames(state, sess, display) == 0
    and next(state.nicknamePending) == nil,
    "resolved names disappear from save-local pending list")

local dead = mon(25, 99, 0, "Dead")
local archived = mon(16, 555, 15, "Old")
local survivor = mon(16, 777, 25, "Hope")
local pc = { party = {}, storage = { boxes = {
    { mons = { [1] = { species = 1, isEgg = true, hp = 12 },
               [2] = dead, [3] = archived, [4] = survivor } },
} } }
local policy = { graveyard = { { archive = {
    species = archived.species, personality = archived.personality } } } }
assert(Extra.rescueFromPc(policy, pc), "eligible reserve can continue")
assert(pc.party[1] == survivor and pc.storage.boxes[1].mons[4] == nil,
    "move original PC Pokemon, do not clone or revive")
assert(policy.pcRescues == 1 and policy.lastPcRescue.slot == 4)
assert(not Extra.rescueFromPc(policy, pc), "cannot rescue nonempty party")
local allDead = { party = {}, storage = { boxes = {
    { mons = { dead, archived, { species = 25, hp = 0 } } },
} } }
assert(not Extra.rescueFromPc(policy, allDead)
    and #allDead.party == 0, "dead PC entries cannot recover a wipe")

-- Runtime wiring: battle events, save state and native naming flow.
local events, hooks, values = {}, {}, {}
package.loaded["src.core.game3.pokemon"] = {
    speciesOf = function(p) return p.species end,
    name = function(id) return ({ [25] = "PIKACHU", [16] = "PIDGEY",
        [1] = "BULBASAUR" })[id] or "?????" end,
    isShiny = function() return false end,
}
local engineBattle = { _phase = "command" }
package.loaded["src.core.game3.battle"] = engineBattle
local originalAsks = 0
local nativeUi = {
    askYesNo = function() originalAsks = originalAsks + 1 end
}
package.loaded["src.core.game3.battle.ui"] = nativeUi
local originalChoices = 0
local nativeChoice = {
    yesNo = function(cb)
        originalChoices = originalChoices + 1
        if cb then cb(false) end
    end,
}
package.loaded["src.ui.game3.choice"] = nativeChoice
local nativeNaming = { opened = 0 }
function nativeNaming.open(opts)
    nativeNaming.opened = nativeNaming.opened + 1
    nativeNaming.last = opts
end
-- Simulate naming UI not ready when the mod first installs its battle
-- prompt guard (the old code skipped both hooks in that situation).
package.loaded["src.ui.game3.naming"] = false
local game = { generation = 3, session = { version = "firered",
    map = "FR_ROUTE_1", party = { mon(25, 123, 20, "Spark") } } }
local mod = { game = game, exports = {},
    save = {
        get = function(_, key, default) return values[key] or default end,
        set = function(_, key, value) values[key] = value end,
    },
    events = { on = function(_, name, fn) events[name] = fn end },
    hooks = { wrap = function(_, name, fn) hooks[name] = fn end },
    read = function(_, path)
        local h = assert(io.open(path, "rb"))
        local source = h:read("*a")
        h:close()
        return source
    end,
}
-- Gen1Recomp's real mod sandbox has no 'package' global, unlike tests
-- run directly with Lua. Exercise the runtime + mod:read modules under an
-- equivalent environment to catch accidental package.loaded usage.
local sandbox = {}
for key, value in pairs(_G) do
    if key ~= "package" and key ~= "io" and key ~= "debug"
        and key ~= "loadfile" and key ~= "dofile" then
        sandbox[key] = value
    end
end
sandbox._G = sandbox
local sourceLoader = loadstring
sandbox.loadstring = function(source, name)
    local chunk, err = sourceLoader(source, name)
    if chunk then setfenv(chunk, sandbox) end
    return chunk, err
end
sandbox.load = sandbox.loadstring
local runtimeChunk = assert(loadfile("gen3_runtime.lua"))
setfenv(runtimeChunk, sandbox)
assert(runtimeChunk()(mod) == nil)
assert(sandbox.package == nil,
    "runtime smoke test must mirror the sandbox's missing package global")
local fire = function(event, data) assert(events[event], event)(data) end
assert(mod.exports.gen3_core.setRule("nuzlocke_enabled", true))
local requiredHook = assert(hooks["battle.catch.nickname_required"])
local function nativeMandatory(ctx)
    return requiredHook(function() return false end,ctx)
end
assert(nativeMandatory({source="gen3",mon=mon(25,51,20,"")}),
    "native post-catch hook must force a nickname")
assert(not nativeMandatory({source="gen2"}),
    "Gen 2 is unaffected by the Gen 3 nickname hook")
assert(mod.exports.gen3_core.setRule("nickname_rule",false))
assert(not nativeMandatory({source="gen3"}),
    "disabling Nickname restores native optional capture names")
assert(mod.exports.gen3_core.setRule("nickname_rule",true))

local openingCopy = mon(25, 123, 0, "Spark")
local opening = { earlyRival = true, trainerId = 326,
    playerParty = { openingCopy } }
fire("battle.started", { battle = opening, trainerId = 326, kind = "trainer" })
assert(values.gen3_classic_v1.firstRivalMercyConsumed == true,
    "once-only rival mercy consumed on battle start")
fire("battle.fainted", { battle = opening, sideName = "player",
    battler = { side = "player", partyIndex = 1, mon = openingCopy } })
assert(#values.gen3_classic_v1.graveyard == 0, "rival mercy prevents death")
game.session.party[1].hp = 0
fire("battle.ended", { battle = opening, result = "lose" })
assert(not values.gen3_classic_v1.failed and #game.session.party == 1,
    "opening rival loss does not retire or fail run")
-- The hook must be active without Naming installed; once the UI loads,
-- map entry installs name validation for capture and PC task screens.
package.loaded["src.ui.game3.naming"] = nativeNaming
fire("map.entered", { mapId = "FR_ROUTE_1" })
engineBattle._phase = "catch_nickname_prompt"
local responded = nil
nativeUi.askYesNo("NAME?", function(v) responded = v end)
assert(responded == true and originalAsks == 0,
    "catch must force native Naming even if the Yes/No UI was unavailable at battle start")
local chosen
nativeChoice.yesNo(function(v) chosen=v end)
assert(chosen == true and originalChoices == 0,
    "legacy native Choice must not deliver No during capture")
engineBattle._phase = "command"
nativeChoice.yesNo(function(v) chosen=v end)
assert(chosen == false and originalChoices == 1,
    "other native Yes/No choices remain unchanged")
engineBattle._phase = "catch_nickname_prompt"
local namedValue = nil
nativeNaming.open({ template = "CAUGHT_MON", species = 25,
    onDone = function(v) namedValue = v end })
assert(nativeNaming.opened == 1)
nativeNaming.last.onDone("PIKACHU")
assert(nativeNaming.opened == 2 and namedValue == nil,
    "default species nickname reopens native naming")
nativeNaming.last.onDone("Bolt")
assert(namedValue == "Bolt", "custom nickname completes native flow")

-- Simulate the native post-catch decision for a Pokémon whose destination
-- is the PC: the engine hook must skip the old No-to-PC exit entirely,
-- wait for a custom name, and then let the native completion proceed.
local pcCaught = {species=25,nickname="PIKACHU"}
local pcComplete,optionalPrompt = false,false
local function decision(yes)
    if not yes then
        pcComplete = true -- native No would finish without a nickname
        return
    end
    nativeNaming.open({template="CAUGHT_MON",species=25,
        onDone=function(name)
            pcCaught.nickname=name
            pcComplete=true
        end})
end
if nativeMandatory({source="gen3",mon=pcCaught,catch={location="pc"}}) then
    decision(true)
else
    optionalPrompt=true
    nativeUi.askYesNo("NAME?",decision)
end
assert(not optionalPrompt and not pcComplete,
    "PC-bound catch must enter naming without optional No")
nativeNaming.last.onDone("PIKACHU")
assert(not pcComplete,"default species name must not finish PC catch")
nativeNaming.last.onDone(nil)
assert(not pcComplete,"cancelled nickname must not finish PC catch")
nativeNaming.last.onDone("Sparky")
assert(pcComplete and pcCaught.nickname=="Sparky",
    "PC destination only finishes after a real nickname")


-- The battle module can be imported as .init, with the plain path absent.
-- Capture must still skip the YES/NO dialog entirely.
package.loaded["src.core.game3.battle"] = nil
package.loaded["src.core.game3.battle.init"] = engineBattle
engineBattle._phase = "catch_nickname_prompt"
local promptResponded
nativeUi.askYesNo("NAME?", function(v) promptResponded = v end)
assert(promptResponded == true and originalAsks == 0,
    "native .init alias must not expose the No choice")
-- Other confirmations remain fully usable.
engineBattle._phase = "command"
nativeUi.askYesNo("OTHER?", function() end)
assert(originalAsks == 1,"unrelated Yes/No dialogs are unchanged")

-- If another mod replaces the UI functions after battle start, the
-- capture event reasserts both validation and forced-YES hooks.
local overwrittenCalls = 0
nativeUi.askYesNo = function(prompt, cb)
    overwrittenCalls = overwrittenCalls + 1
    if cb then cb(false) end
end
nativeNaming.open = function(opts)
    nativeNaming.opened = nativeNaming.opened + 1
    nativeNaming.last = opts
end
fire("pokemon.caught", {})
engineBattle._phase = "catch_nickname_prompt"
promptResponded = nil
nativeUi.askYesNo("NAME?", function(v) promptResponded = v end)
assert(promptResponded == true and overwrittenCalls == 0,
    "a late UI wrapper must not restore the decline option")
local forcedName
nativeNaming.open({template="CAUGHT_MON",species=25,
    onDone=function(n) forcedName=n end})
local attempts=nativeNaming.opened
nativeNaming.last.onDone(nil)
assert(nativeNaming.opened == attempts+1 and forcedName == nil,
    "cancel/empty nickname must reopen the naming modal")
nativeNaming.last.onDone("  ")
assert(nativeNaming.opened == attempts+2 and forcedName == nil,
    "whitespace nickname is prohibited")
nativeNaming.last.onDone("PIKACHU")
assert(nativeNaming.opened == attempts+3 and forcedName == nil,
    "species-default nickname is prohibited")
nativeNaming.last.onDone("Sparky")
assert(forcedName == "Sparky","only a custom nickname completes capture")

-- Nickname OFF restores the regular native decision, even mid-run.
assert(mod.exports.gen3_core.setRule("nickname_rule",false))
engineBattle._phase = "catch_nickname_prompt"
promptResponded = nil
nativeUi.askYesNo("NAME?",function(v) promptResponded=v end)
assert(promptResponded == false and overwrittenCalls == 1,
    "native No is legal when nickname rule is disabled")
assert(mod.exports.gen3_core.setRule("nickname_rule",true))
package.loaded["src.core.game3.battle"] = engineBattle

game.session.party[1].hp = 21
local secondCopy = mon(25, 123, 0, "Spark")
local second = { earlyRival = true, trainerId = 326,
    playerParty = { secondCopy } }
fire("battle.started", { battle = second, trainerId = 326, kind = "trainer" })
fire("battle.fainted", { battle = second, sideName = "player",
    battler = { side = "player", partyIndex = 1, mon = secondCopy } })
assert(#values.gen3_classic_v1.graveyard == 1,
    "rival mercy is not granted twice")
fire("battle.ended", { battle = second, result = "lose" })
assert(values.gen3_classic_v1.failed)

values.gen3_classic_v1 = {
    enabled = true, rules = { whiteout_ends_run = false,
        pc_survivors_allowed = true }, graveyard = {}, areas = {},
}
local partyMon = mon(25, 200, 0, "Ash")
local boxed = mon(16, 201, 22, "Reserve")
game.session.party = { partyMon }
game.session.storage = { boxes = { { mons = {
    [1] = { species = 25, isEgg = true, hp = 10 }, [2] = boxed,
} } } }
local wipe = { playerParty = { mon(25, 200, 0, "Ash") } }
fire("battle.started", { battle = wipe, kind = "trainer", trainerId = 77 })
fire("battle.fainted", { battle = wipe, sideName = "player",
    battler = { side = "player", partyIndex = 1, mon = wipe.playerParty[1] } })
fire("battle.ended", { battle = wipe, result = "lose" })
assert(not values.gen3_classic_v1.failed and game.session.party[1] == boxed,
    "PC rescue prevents empty party failure when whiteout is OFF")
assert(game.session.storage.boxes[1].mons[2] == nil)
assert(values.gen3_classic_v1.pcRescues == 1)

values.gen3_classic_v1 = {
    enabled = true, rules = { whiteout_ends_run = true,
        pc_survivors_allowed = true }, graveyard = {}, areas = {},
}
game.session.party = { mon(25, 300, 15, "Lead") }
game.session.storage.boxes[1].mons[2] = boxed
local loss = {}
fire("battle.started", { battle = loss, kind = "trainer", trainerId = 77 })
fire("battle.ended", { battle = loss, result = "lose" })
assert(values.gen3_classic_v1.failed
    and game.session.storage.boxes[1].mons[2] == boxed,
    "whiteout priority overrides PC survivors and does not move PC mon")

print("Gen 3 nickname, first-rival mercy and PC survivors: PASS")
