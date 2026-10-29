-- Mocked Gen 3 event/API smoke: no ROM or Gen1Recomp installation required.
local events, hooks, values = {}, {}, {}
local nativeBattleMessages = {}
package.loaded["src.core.game3.battle.ui"] = {
    push = function(message)
        nativeBattleMessages[#nativeBattleMessages + 1] = message
    end,
}
-- ROM-backed native name resolver stubs: assert UI does not print numeric IDs.
package.loaded["src.core.game3.pokemon"] = {
    speciesOf = function(mon) return tonumber(mon.species or mon.speciesId) end,
    isShiny = function(mon) return mon.isShiny == true end,
    name = function(species)
        local names = { [16] = "PIDGEY", [25] = "PIKACHU" }
        return assert(names[tonumber(species)], "unknown mocked species")
    end,
}
package.loaded["src.import.gba.map_sections_extract"] = {
    getInfo = function(_, mapId)
        local n = type(mapId) == "string" and
            mapId:match("^FR_ROUTE_(%d+)$") or nil
        if n then
            return { resolved = true, rawName = "ROUTE " .. n,
                name = "ROUTE " .. n }
        end
        return { resolved = false, rawName = "PALLET TOWN" }
    end,
}
local uiStack = { top = nil }
package.loaded["src.ui.game3.stack"] = {
    push = function(id, module) uiStack.top = { id = id, module = module } end,
    pop = function(id)
        assert(uiStack.top and uiStack.top.id == id, "wrong menu popped")
        uiStack.top = nil
    end,
}
local fakeBattleItems = {
    canUseOn = function() return true end,
    use = function() return "heal", {}, true, false end,
}
-- The actual engine uses these internal modules to resolve battle items.
-- The test supplies their narrow contracts without loading a GBA ROM.
package.loaded["src.core.game3.battle.items"] = fakeBattleItems
package.loaded["src.core.game3.items_data"] = {
    medicineKind = function(id) return id == "REVIVE" and "revive" or "heal" end,
}
package.loaded["src.core.game3.item_use"] = {
    fieldUseKind = function(id)
        return id == "REVIVE" and "revive" or "heal"
    end,
}
local game = { generation = 3, session = { map = "FR_ROUTE_1",
    bag = { pockets = { POKE_BALLS = { { id = 4, qty = 0 } } } },
    party = {
    { species = 25, personality = 7421, hp = 21, level = 5, nickname = "Starter" },
} } }
local mod = {
    game = game,
    save = {
        get = function(_, k, default) return values[k] or default end,
        set = function(_, k, v) values[k] = v end,
    },
    events = { on = function(_, n, f) events[n] = f end },
    hooks = { wrap = function(_, n, f) hooks[n] = f end },
    exports = {},
    read = function(_, path)
        local handle = io.open(path, "rb")
        if not handle then return nil, "file missing: " .. path end
        local text = handle:read("*a")
        handle:close()
        return text
    end,
}
assert(loadfile("gen3_runtime.lua")()(mod) == nil)
local function fire(n, v) assert(events[n], n)(v) end
local function throw(battle)
    local invoked = false
    local caught, shakes = hooks["catch.rate"](function()
        invoked = true
        return true, 4
    end, "POKE_BALL", {}, {}, { battle = battle })
    return caught, shakes, invoked
end
assert(not mod.exports.gen3_classic.state().enabled, "opt in is required")
local function press(key)
    assert(uiStack.top, "menu stack empty")
    uiStack.top.module.handleInput({
        wasPressed = function(_, button) return key == button end
    })
end
local function openMenu()
    local rows = hooks["ui.start_menu.items"](function(_, items) return items end, game, {})
    assert(rows[#rows].label == "NUZ MENU", "one unified Gen 3 Start entry")
    rows[#rows].onSelect()
    local model = mod.exports.gen3_menu.model()
    assert(model.title == "NUZ MENU", "menu opens home")
    assert(model.rows[1] == "NUZ RULES", "implemented rules have no WIP label")
    assert(model.rows[3] == "RUN JOURNAL",
        "run recap and messages share one clear destination")
    assert(model.rows[5] == "MOD SUPPORT",
        "compatibility is an active read-only diagnostic screen")
    for _,label in ipairs(model.rows) do
        assert(label~="NUZ DEV",
            "developer tools must never appear in normal home navigation")
        assert(label~="NUZ NOTICES" and not label:find("ALMANAC",1,true)
            and label~="NUZ STATUS",
            "old duplicate navigation rows must be removed")
    end
end
local function toggle(expectBefore, expectAfter)
    openMenu()
    press("a") -- NUZ RULES
    assert(mod.exports.gen3_menu.model().title == "NUZ RULES")
    press("a") -- CORE category
    local core = mod.exports.gen3_menu.model()
    assert(core.title == "CORE" and core.rows[1] == expectBefore,
        "unexpected Gen 3 CORE rule state")
    press("a") -- toggle Nuzlocke
    assert(mod.exports.gen3_menu.model().rows[1] == expectAfter,
        "Gen 3 menu toggle must update immediately")
    press("b") -- CORE -> RULES
    press("b") -- RULES -> HOME
    press("b") -- HOME -> START
    assert(uiStack.top == nil, "menu should close cleanly")
end
toggle("NUZLOCKE: OFF", "NUZLOCKE: ON")
assert(mod.exports.gen3_classic.state().enabled)
-- Mod Support does not change rules or save state, and never treats
-- an unknown provider as confirmed compatible.
local beforeSupport=values.gen3_classic_v1
openMenu()
for _=1,4 do press("down") end
press("a")
assert(mod.exports.gen3_menu.model().title=="MOD SUPPORT")
assert(mod.exports.gen3_menu.model().rows[1]=="UNTAMED: UNKNOWN"
    and mod.exports.gen3_menu.model().rows[2]=="SHINY ODDS: NUZLOCKE"
    and mod.exports.gen3_menu.model().rows[3]=="OTHER RNG: UNKNOWN")
assert(mod.exports.gen3_menu.model().rows[4]=="NAT DEX: UNKNOWN"
    and mod.exports.gen3_menu.model().rows[5]=="G9 SPRITES: UNKNOWN"
    and mod.exports.gen3_menu.model().rows[6]=="MOD SPAWNS: UNKNOWN"
    and mod.exports.gen3_menu.model().rows[7]=="HD SPRITES: UNKNOWN",
    "missing mod discovery must not be labelled as tested or absent")
press("a")
assert(mod.exports.gen3_menu.model().title=="UNTAMED SUPPORT")
press("b");press("b");press("b")
assert(values.gen3_classic_v1==beforeSupport,
    "opening mod support must not change the saved run")
local shinyProvider={
    id="SHINY_POKEMON",
    exports={shiny_compat={isShiny=function() return false end}},
}
mod.find=function(_,id)
    if id=="untamed_advanced" then return {id=id} end
    if id=="pokemon_randomizer" then return {id=id} end
    if id=="SHINY_POKEMON" then return shinyProvider end
end
openMenu()
for _=1,4 do press("down") end
press("a")
assert(mod.exports.gen3_menu.model().rows[1]=="UNTAMED: DETECTED"
    and mod.exports.gen3_menu.model().rows[2]=="SHINY ODDS: EXTERNAL"
    and mod.exports.gen3_menu.model().rows[3]=="OTHER RNG: DETECTED",
    "the support screen must re-evaluate live mod providers")
assert(mod.exports.gen3_menu.model().rows[4]=="NAT DEX: NOT FOUND"
    and mod.exports.gen3_menu.model().rows[5]=="G9 SPRITES: NOT FOUND"
    and mod.exports.gen3_menu.model().rows[6]=="MOD SPAWNS: NOT FOUND"
    and mod.exports.gen3_menu.model().rows[7]=="HD SPRITES: NOT FOUND")
for _=1,3 do press("down") end
press("a")
assert(mod.exports.gen3_menu.model().title=="NAT DEX SUPPORT")
assert(mod.exports.gen3_menu.model().rows[1]=="DETECTION: NOT FOUND"
    and mod.exports.gen3_menu.model().rows[2]=="PUBLIC API: N/A"
    and mod.exports.gen3_menu.model().rows[4]=="COMBINED TEST: NOT"
    and mod.exports.gen3_menu.model().rows[5]=="VERIFIED")
press("b");press("b");press("b")
mod.find=nil
-- A pre-Poké Ball scripted battle cannot claim Route 1, including with
-- Failed Encounters ON. Native PC Balls do not count as carried Balls.
game.session.storage = { items = { { id = 4, qty = 99 } } }
local premature = {}
fire("battle.started", { battle = premature, kind = "wild",
    species = "PIDGEY", speciesId = 16 })
assert(not values.gen3_classic_v1.areas.FR_ROUTE_1,
    "pre-Ball wild battle must not spend or register any route")
fire("battle.ended")
game.session.bag.pockets.POKE_BALLS[1].qty = 5
local first = { enemy = { mon = {
    species = 16, level = 4, personality = 991 } } }
fire("battle.started", { battle = first, kind = "wild", species = "PIDGEY", speciesId = 16 })
local firstNotice = mod.exports.gen3_notices.history()
firstNotice = firstNotice[#firstNotice]
assert(firstNotice.code == "FIRST_ENCOUNTER"
    and firstNotice.text:find("First encounter", 1, true)
    and firstNotice.text:find("fleeing or fainting", 1, true)
    and not firstNotice.text:find("Failed Encounters", 1, true),
    "first encounter notice should describe the chance, not announce a failure")
local caught, shakes, invoked = throw(first)
assert(caught and shakes == 4 and invoked, "first battle may catch")
local justCaught = { species = 16, level = 4, personality = 991 }
fire("pokemon.caught", { battle = first, speciesId = 16, mon = justCaught })
assert(values.gen3_classic_v1.areas.FR_ROUTE_1.caught == true)
assert(values.gen3_classic_v1.areas.FR_ROUTE_1.caughtLevel == 4
    and values.gen3_classic_v1.areas.FR_ROUTE_1.caughtSpeciesId == 16,
    "capture-time species and level must be persisted")
fire("battle.ended")
-- Native naming happens after the caught event. Tracker follows the
-- individual through PC and retains the level from the original capture.
game.session.storage.boxes = { { mons = { [1] = justCaught } } }
justCaught.nickname = "Skye"
justCaught.level = 22
openMenu()
press("down"); press("a") -- ENC TRACKER
local tracked = mod.exports.gen3_menu.model()
assert(tracked.title == "ENC TRACKER"
    and tracked.rows[2]:find("Skye", 1, true),
    "tracker ledger should show the new nickname, not the battle slot")
press("down"); press("a")
local details = mod.exports.gen3_menu.model()
local detailText = table.concat(details.rows, "\n")
assert(detailText:find("NAME: Skye", 1, true)
    and detailText:find("SPECIES: Pidgey", 1, true)
    and detailText:find("LEVEL CAUGHT: 4", 1, true),
    "tracker detail must show nickname, species and capture-time level")
press("b"); press("b"); press("b")
game.session.storage.boxes = nil
local repeatBattle = {}
fire("battle.started", { battle = repeatBattle, kind = "wild" })
caught, shakes, invoked = throw(repeatBattle)
assert(caught == false and shakes == 0 and not invoked, "repeat catch denied")
fire("battle.ball_thrown", { battle = repeatBattle, caught = false, shakes = 0 })
local log = mod.exports.gen3_notices.history()
assert(log[#log].code == "CATCH_DENIED"
    and log[#log].text:find("One Per Area", 1, true),
    "blocked Poke Ball should explain the rule in persisted notices")
assert(nativeBattleMessages[#nativeBattleMessages]:find("encounter already used", 1, true),
    "blocked Poke Ball explanation should appear in native battle text")
fire("battle.ended")
openMenu()
press("down");press("down");press("a") -- RUN JOURNAL
local journal=mod.exports.gen3_menu.model()
assert(journal.title=="RUN JOURNAL"
    and journal.rows[1]=="RUN: ACTIVE"
    and journal.rows[3]=="AREAS USED: 1"
    and journal.rows[4]=="AREA CATCHES: 1"
    and journal.rows[5]=="FALLEN: 0",
    "journal should present live run stats from existing records")
for _=1,6 do press("down") end
assert(mod.exports.gen3_menu.model().rows[7]:find("EVENT HISTORY:",1,true))
press("a")
assert(mod.exports.gen3_menu.model().title=="EVENT HISTORY")
assert(mod.exports.gen3_menu.model().rows[1]=="CATCH DENIED",
    "existing saved notices are accessible with readable labels")
press("a")
assert(mod.exports.gen3_menu.model().title=="JOURNAL ENTRY")
assert(#mod.exports.gen3_menu.model().rows>1,
    "long player-facing reason must wrap over multiple rows")
press("b");press("b")
assert(mod.exports.gen3_menu.model().title=="RUN JOURNAL",
    "back returns to journal, not a second message-history root")
press("down") -- RUN RULE DETAILS
assert(mod.exports.gen3_menu.model().rows[8]=="RUN RULE DETAILS")
press("a")
local detailPage=mod.exports.gen3_menu.model()
assert(detailPage.title=="RUN DETAILS"
    and table.concat(detailPage.rows," "):find("CATCH: PER AREA",1,true),
    "player-facing rules must describe configured areas, not raw maps")
for _,line in ipairs(detailPage.rows) do
    assert(#line<=25,"help text must wrap before native menu clips it")
end
for _=1,9 do press("down") end
assert(mod.exports.gen3_menu.model().scroll>0
    and mod.exports.gen3_menu.model().index>6,
    "long details must scroll to every row")
press("b")
assert(mod.exports.gen3_menu.model().title=="RUN JOURNAL")
press("b");press("b")
game.session.map = "FR_ROUTE_2"
fire("map.entered", { mapId = "FR_ROUTE_2" })
local newAreaBattle = {}
fire("battle.started", { battle = newAreaBattle, kind = "wild" })
assert(select(1, throw(newAreaBattle)) == true, "new area allowed")
fire("battle.ended")

-- Failed Encounters OFF: a failed attempt does not claim the route; after a
-- successful catch, the route becomes committed even with failure mode OFF.
local core = mod.exports.gen3_core
assert(core.schema == 1 and #core.definitions() == 8, "eight approved CORE rules")
assert(core.setRule("failed_encounter", false))
game.session.map = "FR_ROUTE_3"
fire("map.entered", { mapId = "FR_ROUTE_3" })
local try1 = {}
fire("battle.started", { battle = try1, kind = "wild" })
assert(select(1, throw(try1)) == true, "first attempt allowed")
fire("battle.ended")
assert(values.gen3_classic_v1.areas.FR_ROUTE_3.spent == false,
    "failed catch must not consume the area")
local try2 = {}
fire("battle.started", { battle = try2, kind = "wild" })
assert(select(1, throw(try2)) == true, "second attempt allowed when failures OFF")
fire("pokemon.caught", { battle = try2 })
fire("battle.ended")
local try3 = {}
fire("battle.started", { battle = try3, kind = "wild" })
assert(select(1, throw(try3)) == false, "successful catch closes area")
fire("battle.ended")
assert(core.setRule("encounter_limit", false))
local noLimit = {}
fire("battle.started", { battle = noLimit, kind = "wild" })
assert(select(1, throw(noLimit)) == true, "one-per-area OFF disables catch block")
fire("battle.ended")
assert(core.setRule("encounter_limit", true))
assert(core.setRule("failed_encounter", true))
assert(core.setRule("nickname_rule", false),
    "nickname requirement can be disabled for a run")
assert(core.setRule("nickname_rule", true),
    "nickname requirement can be enabled for a run")
assert(core.setRule("pc_survivors_allowed", true),
    "PC survivor rule is toggleable for testing")
assert(core.setRule("pc_survivors_allowed", false),
    "PC survivor default remains OFF")

-- Permadeath OFF must restore normal revives and allow ordinary fainting.
assert(core.setRule("permadeath", false))
local safeMon = { species = 25, personality = 7421, hp = 0, level = 5 }
local safeBattle = { playerParty = { safeMon } }
fire("battle.started", { battle = safeBattle, kind = "trainer" })
fire("battle.fainted", { battle = safeBattle, sideName = "player",
    battler = { side = "player", partyIndex = 1, mon = safeMon } })
assert(#values.gen3_classic_v1.graveyard == 0 and not safeMon.nuzlockeDead,
    "permadeath OFF does not mark death")
fire("battle.ended")
assert(#game.session.party == 1, "permadeath OFF preserves party")
assert(fakeBattleItems.canUseOn({}, "REVIVE", 1, safeMon),
    "revive item becomes usable with permadeath OFF")
assert(core.setRule("permadeath", true))

assert(fakeBattleItems.canUseOn({}, "REVIVE", 1, game.session.party[1]) == false,
    "revival should be denied by target-selection UI")
local dummyAdapter = { say = function(_, text) assert(text:find("No revives")) end }
assert(select(1, fakeBattleItems.use({}, dummyAdapter, {}, game.session,
    "REVIVE", 1)) == "error", "native revival action must also be blocked")
assert(select(1, fakeBattleItems.use({}, dummyAdapter, {}, game.session,
    "POTION", 1)) == "heal", "ordinary healing still delegates to engine")

-- Player faint in a trainer battle: immediate death even if an external
-- battle effect later restores HP on the copied party mon.
local battleMon = {
    species = 25, personality = 7421, hp = 0, level = 5,
    nickname = "Starter",
}
local trainerBattle = { playerParty = { battleMon } }
fire("battle.started", { battle = trainerBattle, kind = "trainer" })
local faint = { battle = trainerBattle, sideName = "player",
    battler = { side = "player", partyIndex = 1, mon = battleMon } }
fire("battle.fainted", faint)
assert(battleMon.nuzlockeDead, "death is recorded during battle")
assert(#values.gen3_classic_v1.graveyard == 1, "instant graveyard entry")
assert(values.gen3_classic_v1.graveyard[1].archiveComplete
    and values.gen3_classic_v1.graveyard[1].archive.personality == 7421
    and values.gen3_classic_v1.graveyard[1].archive.nuzlockeDead == nil,
    "death archive preserves Pokemon identity without death marker")
fire("battle.fainted", faint)
assert(#values.gen3_classic_v1.graveyard == 1, "duplicate faint not recorded")
battleMon.hp = 13
game.session.party[1].hp = 13 -- simulate a mid-battle revive / heal bypass
fire("battle.ended")
assert(#game.session.party == 0, "fainted mon removed despite later HP gain")
assert(#values.gen3_classic_v1.graveyard == 1, "death not duplicated at cleanup")
assert(values.gen3_classic_v1.graveyard[1].speciesName == "Pikachu",
    "new memorial records keep the native species name")
assert(values.gen3_classic_v1.graveyard[1].areaName == "Route 3",
    "new memorial records keep readable native location")
assert(mod.exports.gen3_classic.state().failed, "empty party loses run")

-- Migration/display test: pre-existing saves store only species=16 and
-- area=FR_ROUTE_1, yet should render Pidgey at Route 1.
local historic = { species = 16, level = 3, area = "FR_ROUTE_1" }
table.insert(values.gen3_classic_v1.graveyard, historic)
openMenu()
for _ = 1, 3 do press("down") end -- GRAVEYARD
press("a")
assert(mod.exports.gen3_menu.model().title == "GRAVEYARD")
assert(mod.exports.gen3_menu.model().rows[1] == "Starter Lv5")
assert(mod.exports.gen3_menu.model().rows[2] == "Pidgey Lv3")
press("down")
press("a")
local memorial = mod.exports.gen3_menu.model()
assert(memorial.title == "IN MEMORY")
assert(memorial.rows[1] == "POKEMON: Pidgey")
assert(memorial.rows[2] == "LEVEL: 3")
assert(memorial.rows[3] == "LOST AT: Route 1")
press("b")
press("b")
press("b")
table.remove(values.gen3_classic_v1.graveyard) -- restore original one-death record

toggle("NUZLOCKE: ON", "NUZLOCKE: ON")
assert(mod.exports.gen3_classic.state().failed, "failure cannot be cleared")
assert(core.setRule("nuzlocke_enabled", false) == false,
    "failed-run config remains sealed")

-- Whiteout has higher priority than healthy reserve Pokémon in the PC;
-- switching it OFF allows the native loss outcome when the party survives.
values.gen3_classic_v1 = {
    enabled = true, failed = false, areas = {}, graveyard = {},
    rules = { whiteout_ends_run = true, permadeath = true }
}
game.session.party = {
    { species = 1, personality = 77, hp = 12, level = 5 },
}
game.session.storage = {
    boxes = { { mons = { { species = 4, hp = 11, level = 5 } } } },
}
local losing = {}
fire("battle.started", { battle = losing, kind = "trainer" })
fire("battle.ended", { result = "lose" })
assert(values.gen3_classic_v1.failed, "whiteout ends run despite PC reserves")

values.gen3_classic_v1.failed = false
assert(core.setRule("whiteout_ends_run", false))
local forgivenLoss = {}
fire("battle.started", { battle = forgivenLoss, kind = "trainer" })
fire("battle.ended", { result = "lose" })
assert(not values.gen3_classic_v1.failed,
    "whiteout OFF does not by itself end a surviving-party run")

-- Nuz Dev: SELECT held + A is the reliable native Input path
-- (press edge rather than navigating the D-pad repeatedly). The
-- eight-direction code is retained as an alternative. Neither may
-- taint a run until an explicit activation confirmation.
local function selectA()
    assert(uiStack.top)
    uiStack.top.module.handleInput({
        isDown=function(_,key)return key=="select" end,
        wasPressed=function(_,key)return key=="a" end,
    })
end
openMenu()
local taintedBefore=mod.exports.gen3_dev_info.status().tainted
selectA()
assert(mod.exports.gen3_menu.model().title=="DEV ACCESS"
    and not mod.exports.gen3_dev_info.status().enabled
    and mod.exports.gen3_dev_info.status().tainted==taintedBefore,
    "SELECT+A on NUZ MENU must unlock access without modifying the run")
press("down");press("a") -- Cancel
assert(mod.exports.gen3_menu.model().title=="NUZ MENU")
press("a") -- NUZ RULES
selectA() -- SELECT+A may work as ordinary A but never unlock submenus
assert(mod.exports.gen3_menu.model().title~="DEV ACCESS",
    "SELECT+A must not open dev access on a submenu")
press("b");press("b")
assert(mod.exports.gen3_menu.model().title=="NUZ MENU")
local sequence={"up","up","down","down","left","right","left","right"}
for _,key in ipairs(sequence) do press(key) end
assert(mod.exports.gen3_menu.model().title=="DEV ACCESS"
    and not mod.exports.gen3_dev_info.status().enabled
    and mod.exports.gen3_dev_info.status().tainted==taintedBefore,
    "unlock sequence must not activate or taint developer mode")
press("down");press("a") -- CANCEL dev access
assert(mod.exports.gen3_menu.model().title=="NUZ MENU")
for _,key in ipairs(sequence) do press(key) end
assert(mod.exports.gen3_menu.model().title=="DEV ACCESS",
    "access code can be entered again within the current session")
press("a") -- OPEN DEV TOOLS
assert(mod.exports.gen3_menu.model().title == "NUZ DEV")
assert(mod.exports.gen3_menu.model().rows[1] == "ENABLE DEV MODE")
press("a")
assert(mod.exports.gen3_menu.model().title == "CONFIRM EDIT")
press("b") -- refuse confirmation
assert(not mod.exports.gen3_dev_info.status().enabled,
    "cancelled developer activation must not change save")
press("a")
press("a") -- explicit YES
assert(mod.exports.gen3_dev_info.status().enabled,
    "developer mode opt-in should work")
assert(mod.exports.gen3_dev_info.status().tainted,
    "using developer editing marks test save permanently")
assert(mod.exports.gen3_menu.model().rows[1] == "RE-ARM CURRENT")

-- One-step quick re-arm for the next wild encounter, then detailed editing.
press("a") -- quick re-arm
assert(mod.exports.gen3_menu.model().title == "CONFIRM EDIT")
press("a")
assert(values.gen3_classic_v1.areas.FR_ROUTE_3.spent == false,
    "quick re-arm opens current map catch slot")
assert(mod.exports.gen3_menu.model().title == "NUZ DEV")
press("down") -- EDIT CURRENT AREA
press("a")
assert(mod.exports.gen3_menu.model().title == "EDIT AREA")
assert(mod.exports.gen3_menu.model().rows[2] == "STATE: OPEN")
press("down")
press("down") -- MARK OPEN
press("a")
press("a") -- confirm
assert(values.gen3_classic_v1.areas.FR_ROUTE_3.spent == false)
assert(mod.exports.gen3_menu.model().rows[2] == "STATE: OPEN")
assert(mod.exports.gen3_dev_info.snapshot().areasOpen == 1)
press("down") -- MARK SPENT
press("a")
press("a")
assert(values.gen3_classic_v1.areas.FR_ROUTE_3.spent == true)
assert(mod.exports.gen3_menu.model().rows[2] == "STATE: SPENT")
press("down") -- MARK CAUGHT
press("a")
press("a")
assert(values.gen3_classic_v1.areas.FR_ROUTE_3.caught == true)
assert(mod.exports.gen3_menu.model().rows[2] == "STATE: CAUGHT")
press("down") -- CLEAR ENTRY
press("a")
press("a")
assert(values.gen3_classic_v1.areas.FR_ROUTE_3 == nil,
    "clear entry should rearm only that map")
assert(mod.exports.gen3_menu.model().rows[2] == "STATE: UNRECORDED")

-- The area editor is forbidden while a native battle is live.
local devFight = {}
fire("battle.started", { battle = devFight, kind = "trainer" })
press("up") -- MARK CAUGHT
press("a")
press("a")
assert(mod.exports.gen3_menu.model().title == "EDIT BLOCKED")
assert(values.gen3_classic_v1.areas.FR_ROUTE_3 == nil,
    "developer edits must not mutate battle state")
press("b")
fire("battle.ended")
press("b") -- back to NUZ DEV
assert(mod.exports.gen3_menu.model().title == "NUZ DEV")
press("down") -- EDIT ALL AREAS
press("a")
assert(mod.exports.gen3_menu.model().rows[1] == "NO RECORDED AREAS")
press("b")
press("down") -- CLEAR ALL AREAS
values.gen3_classic_v1.areas.FR_ROUTE_4 = { spent = true, caught = true }
press("a")
press("b") -- cancel
assert(values.gen3_classic_v1.areas.FR_ROUTE_4 ~= nil,
    "cancelled global reset should leave areas alone")
press("a")
press("a") -- confirm clear ALL
assert(next(values.gen3_classic_v1.areas) == nil,
    "global reset should clear all encounter records")

press("down") -- STATE INSPECTOR
press("a")
assert(mod.exports.gen3_menu.model().title == "NUZ DEV STATUS")
press("b")
press("down") -- RULE INSPECTOR
press("a")
assert(mod.exports.gen3_menu.model().title == "RULE INSPECT")
press("b")

press("down") -- RESET CLAUSE COUNTS
values.gen3_classic_v1.shinyExceptionsUsed = 2
values.gen3_classic_v1.capturedSpecies = { ["16"] = true }
values.gen3_classic_v1.roamerClaims = { ["243"] = true }
press("a")
press("b") -- cancel
assert(values.gen3_classic_v1.shinyExceptionsUsed == 2,
    "cancelled clause reset should do nothing")
press("a")
press("a")
assert(values.gen3_classic_v1.shinyExceptionsUsed == 0
    and next(values.gen3_classic_v1.capturedSpecies) == nil
    and next(values.gen3_classic_v1.roamerClaims) == nil,
    "confirm clause reset clears allowances, captures and roamer claims")
press("down") -- PRINT DEBUG REPORT
press("a")
assert(mod.exports.gen3_menu.model().title == "REPORT PRINTED")
press("b")
press("down") -- CLEAR GRAVEYARD
values.gen3_classic_v1.graveyard = { { species = 25, nickname = "Test" } }
press("a")
press("a")
assert(#values.gen3_classic_v1.graveyard == 0)
assert(#game.session.party == 1, "dev edits never remove party members")

press("down") -- CLEAR RUN FAILURE
values.gen3_classic_v1.failed = true
game.session.party = {}
press("a")
press("a")
assert(values.gen3_classic_v1.failed == true,
    "cannot clear run failure with an empty party")
assert(mod.exports.gen3_menu.model().title == "EDIT BLOCKED")
press("b")
game.session.party = { { species = 25, personality = 7421, hp = 0 } }
press("a")
press("a")
assert(values.gen3_classic_v1.failed == true,
    "cannot clear loss with only fainted party members")
assert(mod.exports.gen3_menu.model().title == "EDIT BLOCKED")
press("b")
game.session.party[1].hp = 22
press("a")
press("a")
assert(values.gen3_classic_v1.failed == false,
    "can clear loss after restoring a living native party")

press("down") -- DISABLE DEV MODE
press("a")
press("a")
assert(not mod.exports.gen3_dev_info.status().enabled)
assert(mod.exports.gen3_dev_info.status().tainted,
    "disabling test tools must not remove the audit marker")
assert(mod.exports.gen3_menu.model().rows[1] == "ENABLE DEV MODE")
press("b") -- back to NUZ MENU
assert(mod.exports.gen3_menu.model().title=="NUZ MENU")
for _,label in ipairs(mod.exports.gen3_menu.model().rows) do
    assert(label~="NUZ DEV", "unlock must not leave a permanent home row")
end
press("b") -- close menu
openMenu()
assert(mod.exports.gen3_menu.model().title=="NUZ MENU")
press("b") -- close again

-- Integration: repeated Pokémon are rejected without spending an unused
-- area's first chance; shiny exceptions bypass Dupes/area only when successful.
values.gen3_classic_v1 = {
    enabled = true, failed = false, areas = {}, graveyard = {},
    rules = { failed_encounter = true, encounter_limit = true },
}
game.session.party = {
    { species = 25, personality = 7421, hp = 21, level = 5 },
}
assert(mod.exports.gen3_clauses.setMode("dupes_mode", 1))
assert(mod.exports.gen3_clauses.setMode("shiny_clause", 1))
game.session.map = "FR_ROUTE_6"
fire("map.entered", { mapId = "FR_ROUTE_6" })
local dupeBattle = { enemy = { mon = { species = 25, isShiny = false } } }
fire("battle.started", { battle = dupeBattle, kind = "wild",
    speciesId = 25 })
assert(select(1, throw(dupeBattle)) == false,
    "owned species denied by Dupes Clause")
assert(values.gen3_classic_v1.areas.FR_ROUTE_6 == nil,
    "rejected duplicate must not use the encounter")
fire("battle.ended")
local normalBattle = { enemy = { mon = { species = 16, isShiny = false } } }
fire("battle.started", { battle = normalBattle, kind = "wild",
    speciesId = 16 })
assert(select(1, throw(normalBattle)) == true,
    "unrelated species still available")
assert(values.gen3_classic_v1.areas.FR_ROUTE_6.spent,
    "eligible encounter consumes the route normally")
fire("battle.ended")
local shinyBattle = { enemy = { mon = { species = 25, isShiny = true } } }
fire("battle.started", { battle = shinyBattle, kind = "wild",
    speciesId = 25 })
local allowed, _, invoked = hooks["catch.rate"](function()
    return true, 4
end, "MASTER_BALL", shinyBattle.enemy.mon, {}, { battle = shinyBattle })
assert(allowed and not not allowed, "shiny exception bypasses spent duplicate")
fire("pokemon.caught", { battle = shinyBattle, speciesId = 25,
    mon = shinyBattle.enemy.mon })
assert(mod.exports.gen3_clauses.summary().shinyExceptionsUsed == 1,
    "successful exceptional catch consumes exactly one allowance")
fire("battle.ended")
local secondShiny = { enemy = { mon = { species = 25, isShiny = true } } }
fire("battle.started", { battle = secondShiny, kind = "wild",
    speciesId = 25 })
assert(select(1, throw(secondShiny)) == false,
    "one-time shiny exception cannot be reused")
fire("battle.ended")
assert(values.gen3_classic_v1.areas.FR_ROUTE_6.caught ~= true,
    "shiny exception must not falsely mark a normal area catch")

-- CLAUSES menu cycle and unsupported entries visibly remain inert.
openMenu()
press("a") -- NUZ RULES
press("down") -- CLAUSES
press("a")
local clausesMenu = mod.exports.gen3_menu.model()
assert(clausesMenu.title == "CLAUSES" and #clausesMenu.rows == 8,
    "Gen 3 clause menu excludes Gold-only contest and includes all planned rows")
assert(clausesMenu.rows[1] == "DUPES CLAUSE: SPEC")
assert(clausesMenu.rows[2] == "SHINY CLAUSE: 1")
press("a") -- SPEC -> FAM
assert(mod.exports.gen3_clauses.getMode("dupes_mode") == 2)
assert(mod.exports.gen3_menu.model().rows[1] == "DUPES CLAUSE: FAM")
press("down") -- shiny clause
press("a") -- 1 -> 2
assert(mod.exports.gen3_clauses.getMode("shiny_clause") == 2)
press("down") -- shiny rate
assert(mod.exports.gen3_menu.model().rows[3] == "SHINY RATE: NATIVE")
press("a")
assert(mod.exports.gen3_clauses.getMode("shiny_rate_mode") == 1,
    "Shiny Rate cycles through supported real modes")
assert(mod.exports.gen3_menu.model().rows[3] == "SHINY RATE: 1/4096")
press("b") -- CLAUSES -> RULES
press("b") -- RULES -> NUZ MENU
press("b") -- NUZ MENU -> game

-- Native Gen 3 roamer: don't spend an area when the roaming Pokémon
-- flees, then close only its species slot when eventually caught.
values.gen3_classic_v1 = {
    enabled = true, failed = false, areas = {}, graveyard = {},
    rules = { failed_encounter = true, encounter_limit = true },
}
game.session.party = { { species = 25, personality = 99, hp = 22 } }
assert(mod.exports.gen3_clauses.setMode("gen3_roamer_clause", 1))
game.session.map = "FR_ROUTE_7"
fire("map.entered", { mapId = "FR_ROUTE_7" })
fire("roamer.encountered", { species = 243, mapId = "FR_ROUTE_7" })
local fleeingRoamer = { enemy = { mon = { species = 243 } } }
fire("battle.started", { battle = fleeingRoamer, kind = "wild", speciesId = 243 })
assert(select(1, throw(fleeingRoamer)) == true,
    "first roamer gets its own encounter slot")
assert(values.gen3_classic_v1.areas.FR_ROUTE_7 == nil,
    "roamer encounter must not claim route even on Failed Encounters ON")
fire("battle.ended", { result = "run" })
fire("roamer.encountered", { species = 243, mapId = "FR_ROUTE_7" })
local caughtRoamer = { enemy = { mon = { species = 243 } } }
fire("battle.started", { battle = caughtRoamer, kind = "wild", speciesId = 243 })
assert(select(1, throw(caughtRoamer)) == true,
    "fled roamer can be caught in a later battle")
fire("pokemon.caught", { battle = caughtRoamer, speciesId = 243 })
assert(values.gen3_classic_v1.roamerClaims["243"],
    "successful capture closes Raikou's species-specific slot")
assert(values.gen3_classic_v1.areas.FR_ROUTE_7 == nil,
    "caught roamer must not claim regular grass encounter")
fire("battle.ended")
-- The next battle may use the native mon.roamer flag instead of an event.
local repeatRoamer = { enemy = { mon = { species = 243, roamer = true } } }
fire("battle.started", { battle = repeatRoamer, kind = "wild", speciesId = 243 })
assert(select(1, throw(repeatRoamer)) == false,
    "claimed roamer slot cannot be reused")
fire("battle.ended")
local otherRoamer = { enemy = { mon = { species = 244, roamer = true } } }
fire("battle.started", { battle = otherRoamer, kind = "wild", speciesId = 244 })
assert(select(1, throw(otherRoamer)) == true, "another roamer retains separate slot")
fire("battle.ended", { result = "run" })
local routeWild = { enemy = { mon = { species = 16, isShiny = false } } }
fire("battle.started", { battle = routeWild, kind = "wild", speciesId = 16 })
assert(select(1, throw(routeWild)) == true,
    "ordinary first route encounter remains eligible after roamer")
assert(values.gen3_classic_v1.areas.FR_ROUTE_7.spent,
    "ordinary first encounter consumes the route")
fire("battle.ended")
assert(mod.exports.gen3_clauses.getMode("gen3_roamer_clause") == 1)
assert(mod.exports.gen3_clauses.summary().speciesRecorded >= 1)
assert(mod.exports.gen3_clauses.summary().roamerClaims == 1,
    "read-only clause summary shows captured roamer slots")

-- Menu uses the real clause registry, not the Gen 2-only rule list.
openMenu()
press("a") -- NUZ RULES
press("down") -- CLAUSES
press("a")
for _ = 1, 3 do press("down") end
local roamerMenu = mod.exports.gen3_menu.model()
assert(roamerMenu.rows[4] == "ROAMER CLAUSE: SLOT",
    "Gen 3 Roamer Clause row should show actual active mode")
press("a")
assert(mod.exports.gen3_clauses.getMode("gen3_roamer_clause") == 0)
assert(mod.exports.gen3_menu.model().rows[4]
    == "ROAMER CLAUSE: OFF")
press("b")
press("b")
press("b")

-- Shiny Rate is deliberately independent of Nuzlocke master switch.
-- An eligible newly generated wild Pokémon gets a persistent, individual
-- shiny flag rather than a repeated draw-time random roll.
values.gen3_classic_v1 = {
    enabled = false, failed = false, areas = {}, graveyard = {},
}
assert(mod.exports.gen3_clauses.setMode("shiny_rate_mode", 6))
local forced = { species = 16, personality = 7256 }
local shinyFight = { enemy = { mon = forced } }
fire("battle.started", { battle = shinyFight, kind = "wild", speciesId = 16 })
assert(forced.isShiny == true and forced.nuzlockeShinyRateBoosted,
    "ALWAYS should mark new wild shiny even when master switch OFF")
fire("battle.ended")
local trainerMon = { species = 16, personality = 7257 }
fire("battle.started", { battle = { enemy = { mon = trainerMon } },
    kind = "trainer" })
assert(not trainerMon.nuzlockeShinyRateBoosted,
    "Shiny Rate should not affect generated trainer Pokemon")
fire("battle.ended")

-- Egg acquisition and token redemptions are connected through the real
-- Gen 3 event bus; neither changes party structure or destroys an Egg.
values.gen3_classic_v1 = {
    enabled = true, failed = false, areas = {}, graveyard = {},
}
assert(mod.exports.gen3_clauses.setMode("gen3_egg_encounter_mode", 1))
game.session.map = "FR_ROUTE_11"
fire("map.entered", { mapId = "FR_ROUTE_11" })
local newEgg = { species = 175, personality = 2026, isEgg = true }
fire("breeding.egg_created", { egg = newEgg, mother = { species = 25 } })
assert(newEgg.nuzEggReceivedAt == "FR_ROUTE_11", "native Egg gets receipt provenance")
game.session.map = "FR_ROUTE_12"
fire("map.entered", { mapId = "FR_ROUTE_12" })
local hatchling = { species = 175, personality = 2026, isEgg = false }
fire("egg.hatched", { mon = hatchling, egg = newEgg, species = 175 })
assert(hatchling.nuzEggProvenance == "ELIGIBLE"
    and values.gen3_classic_v1.areas.FR_ROUTE_11.spent,
    "RECEIVED claims receipt map, not hatch location")
assert(values.gen3_classic_v1.areas.FR_ROUTE_12 == nil)
assert(mod.exports.gen3_clauses.summary().eggsTracked == 1)
-- Seed a known initial badge; enable Route Forgiveness START 1, then confirm
-- later badge progress awards exactly one extra token.
game.session.flags = { [0x820] = true }
assert(mod.exports.gen3_clauses.setMode("route_forgiveness", 2))
assert(mod.exports.gen3_clauses.summary().forgivenessTokens == 1,
    "START 1 awards one token on first activation")
game.session.flags[0x821] = true
fire("map.entered", { mapId = "FR_ROUTE_12" })
assert(mod.exports.gen3_clauses.summary().forgivenessTokens == 2,
    "first new badge awards one token")
fire("map.entered", { mapId = "FR_ROUTE_12" })
assert(mod.exports.gen3_clauses.summary().forgivenessTokens == 2,
    "the same badge never pays twice")
values.gen3_classic_v1.areas.FR_ROUTE_13 = { caught = false, spent = true }
openMenu()
press("a") -- rules
press("down") -- clauses
press("a")
for _ = 1, 7 do press("down") end
assert(mod.exports.gen3_menu.model().rows[8] == "REDEEM TOKEN",
    "redemption action is discoverable in CLAUSES")
press("a")
assert(mod.exports.gen3_menu.model().title == "FORGIVENESS")
assert(mod.exports.gen3_menu.model().rows[1] == "TOKENS: 2")
press("down")
press("a") -- route 13 -> confirmation
assert(mod.exports.gen3_menu.model().title == "CONFIRM TOKEN")
press("b") -- cancel
assert(values.gen3_classic_v1.areas.FR_ROUTE_13.spent,
    "cancelling a token redemption has no effect")
press("a")
press("a") -- confirm yes
assert(values.gen3_classic_v1.areas.FR_ROUTE_13.spent == false
    and mod.exports.gen3_clauses.summary().forgivenessTokens == 1,
    "confirm consumes token and reopens the chosen missed route")
press("b")
press("b")
press("b")
press("b")

-- Scripted acquisition integration: the Gen 3 script.command hook must
-- deny optional gifts BEFORE the native opcode and force its failure code.
-- NPC trade admission must refuse before the script offers a swap; completed
-- swaps alone write AREA/BONUS history. These are mocked native seams.
package.loaded["src.core.game3.scripting.flags"] = {
    getVar=function(_,raw,id) return raw.specialVars[id] or 0 end,
    setVar=function(_,raw,id,value) raw.specialVars[id]=value end,
}
package.loaded["src.core.game3.scripting.natives"] = {
    specialName=function(id)
        if id==77 then return "GetInGameTradeSpeciesInfo" end
    end,
}
local tradedCalls=0
local npcTrades={
    entry=function(id) return id==3 and {species=25} or nil end,
    tradeMons=function(sess,slot,offered)
        tradedCalls=tradedCalls+1
        local old=sess.party[slot+1]
        sess.party[slot+1]=offered
        return old
    end,
}
package.loaded["src.core.game3.scripting.natives_trade"]=npcTrades
local catchRules=mod.exports.gen3_catch_rules
values.gen3_classic_v1={enabled=true,failed=false,areas={},graveyard={}}
game.session.map="FR_ROUTE_20"
fire("map.entered",{mapId="FR_ROUTE_20"})
assert(type(hooks["script.command"])=="function")
local vm={ctx={specialVars={[0x8004]=3}}}
local c={runner=vm}
local giftCalls=0
local function nativeGift()
    giftCalls=giftCalls+1
    game.session.party[#game.session.party+1]={species=25,hp=10}
    vm.ctx.specialVars[0x800D]=0
    return false
end
assert(catchRules.setRule("allow_gifts",false))
-- The Gen1Recomp mod sandbox deliberately hides global package.
local hostPackage=package
package=nil
local giftOK,giftResult=pcall(hooks["script.command"],nativeGift,c,
    "givemon",{op="givemon",species=25,level=5})
package=hostPackage
assert(giftOK and giftResult==false,
    "scripted Gift guard must run without package.loaded")
assert(giftCalls==0 and vm.ctx.specialVars[0x800D]==2,
    "denied gift must not run the native opcode")
assert(#game.session.party==1)
assert(catchRules.setRule("allow_gifts",true))
hooks["script.command"](nativeGift,c,"givemon",
    {op="givemon",species=25,level=5})
assert(giftCalls==1 and #game.session.party==2
    and values.gen3_classic_v1.areas.FR_ROUTE_20.spent)
local history=values.gen3_classic_v1.acquisitionHistory
assert(#history==1 and history[1].slot=="AREA"
    and history[1].kind=="gift")
local giftSlot=c and mod.exports.gen3_catch_rules
assert(giftSlot.setRule("gift_slot_policy",1))
game.session.map="FR_ROUTE_21"
fire("map.entered",{mapId="FR_ROUTE_21"})
hooks["script.command"](nativeGift,c,"givemon",
    {op="givemon",species=25,level=5})
assert(giftCalls==2 and values.gen3_classic_v1.areas.FR_ROUTE_21==nil
    and values.gen3_classic_v1.acquisitionHistory[2].slot=="BONUS")
-- A mandatory starter remains obtainable even if optional gifts are OFF.
assert(catchRules.setRule("allow_gifts",false))
game.session.party={}
game.session.map="FR_OAKS_LAB"
fire("map.entered",{mapId="FR_OAKS_LAB"})
hooks["script.command"](nativeGift,c,"givemon",
    {op="givemon",species=25,level=5})
assert(giftCalls==3 and #game.session.party==1
    and #values.gen3_classic_v1.acquisitionHistory==2)
-- Unknown/failed gifts leave the area available; AREA never claims it.
assert(catchRules.setRule("allow_gifts",true))
assert(catchRules.setRule("gift_slot_policy",0))
game.session.map="FR_ROUTE_22"
fire("map.entered",{mapId="FR_ROUTE_22"})
hooks["script.command"](function()
    vm.ctx.specialVars[0x800D]=2; return false
end,c,"givemon",{op="givemon",species=25,level=5})
assert(values.gen3_classic_v1.areas.FR_ROUTE_22==nil)
-- NPC trade: preview special is allowed to populate display strings,
-- but the returned required species is overridden to zero when banned.
local previewCalls=0
local function nativePreview()
    previewCalls=previewCalls+1
    vm.ctx.specialVars[0x800D]=25
    return false
end
assert(catchRules.setRule("allow_trades",false))
hooks["script.command"](nativePreview,c,"specialvar",
    {op="specialvar",[1]=0x800D,[2]=77})
assert(previewCalls==1 and vm.ctx.specialVars[0x800D]==0,
    "banned NPC trade must advertise no matching required species")
assert(catchRules.setRule("allow_trades",true))
assert(catchRules.setRule("trade_slot_policy",0))
game.session.map="FR_ROUTE_23"
fire("map.entered",{mapId="FR_ROUTE_23"})
hooks["script.command"](nativePreview,c,"specialvar",
    {op="specialvar",[1]=0x800D,[2]=77})
assert(vm.ctx.specialVars[0x800D]==25)
local traded=npcTrades.tradeMons(game.session,0,{species=25,hp=10})
assert(traded and tradedCalls==1
    and values.gen3_classic_v1.areas.FR_ROUTE_23.source=="trade")
-- A spent AREA slot blocks the preflight and swap without losing a mon.
local offered={species=25,hp=10}
local prior=game.session.party[1]
hooks["script.command"](nativePreview,c,"specialvar",
    {op="specialvar",[1]=0x800D,[2]=77})
assert(vm.ctx.specialVars[0x800D]==0)
assert(npcTrades.tradeMons(game.session,0,offered)==nil)
assert(game.session.party[1]==prior and tradedCalls==1)
assert(catchRules.setRule("trade_slot_policy",1))
hooks["script.command"](nativePreview,c,"specialvar",
    {op="specialvar",[1]=0x800D,[2]=77})
assert(vm.ctx.specialVars[0x800D]==25)
assert(npcTrades.tradeMons(game.session,0,offered))
assert(tradedCalls==2
    and values.gen3_classic_v1.acquisitionHistory[
        #values.gen3_classic_v1.acquisitionHistory].slot=="BONUS")

-- A scripted gift can be the FIRST eligible acquisition in RANDOM
-- Alphabetlocke. Its chosen initial must be written into the save,
-- not silently reselected when the first wild encounter later starts.
local nativePokemon=package.loaded["src.core.game3.pokemon"]
nativePokemon.speciesFromNational=function(nat)
    return nat==25 and 25 or nil
end
nativePokemon.keyName=function(id)
    return id==25 and "PIKACHU" or nil
end
assert(catchRules.setRule("alphabetlocke_mode",1))
game.session.map="FR_ROUTE_24"
fire("map.entered",{mapId="FR_ROUTE_24"})
hooks["script.command"](nativeGift,c,"givemon",
    {op="givemon",species=25,level=5})
assert(values.gen3_classic_v1.catchRules.alphabetlocke_random_letter==16,
    "first gift must persist its randomly chosen supported letter")
assert(values.gen3_classic_v1.areas.FR_ROUTE_24.caught,
    "allowed scripted gift commits its receipt map after selection")

-- Type Locke integrates at both battle-start encounter claiming and Ball
-- resolution, and shares the optional gift/NPC trade preflight. An off-type
-- wild must not spend its route, even with Failed Encounters enabled.
local variants=mod.exports.gen3_variants
assert(catchRules.setRule("alphabetlocke_mode",0))
nativePokemon.keyName=function(id)
    return ({[25]="PIKACHU",[4]="CHARMANDER"})[id]
end
nativePokemon.speciesFromNational=function(nat)
    return nat==25 and 25 or nat==4 and 4 or nil
end
nativePokemon.types=function(id)
    return ({[25]={13,13},[4]={10,10}})[id] or {0,0}
end
assert(variants.setRule("type_lock_mode",1))
assert(variants.setRule("type_lock_primary",10)) -- FIRE
game.session.map="FR_ROUTE_25"
fire("map.entered",{mapId="FR_ROUTE_25"})
local wrongType={enemy={mon={species=25,speciesId=25}}}
fire("battle.started",{battle=wrongType,kind="wild",speciesId=25})
assert(values.gen3_classic_v1.areas.FR_ROUTE_25==nil,
    "off-type encounters must never consume the first route slot")
local called=false
local won,shakes=hooks["catch.rate"](function()
    called=true;return true,4
end,"POKE_BALL",{speciesId=25},25,{battle=wrongType})
assert(not won and shakes==0 and not called,
    "off-type Ball must be vetoed before native catching")
fire("battle.ended")
local rightType={enemy={mon={species=4,speciesId=4}}}
fire("battle.started",{battle=rightType,kind="wild",speciesId=4})
assert(values.gen3_classic_v1.areas.FR_ROUTE_25.spent,
    "matching species becomes the FIRST eligible route encounter")
called=false
won=hooks["catch.rate"](function()
    called=true;return true,4
end,"POKE_BALL",{speciesId=4},4,{battle=rightType})
assert(won and called,"matching type reaches native catch transaction")
fire("battle.ended")
-- Type restriction applies to optional gifts before native mutation;
-- mandatory starter exception is handled independently upstream.
game.session.map="FR_ROUTE_26"
fire("map.entered",{mapId="FR_ROUTE_26"})
local giftBefore=giftCalls
hooks["script.command"](nativeGift,c,"givemon",
    {op="givemon",species=25,level=5})
assert(giftCalls==giftBefore
    and values.gen3_classic_v1.areas.FR_ROUTE_26==nil,
    "off-type gift rejected without changing party or route")
assert(variants.setRule("type_lock_primary",13)) -- ELECTRIC
hooks["script.command"](nativeGift,c,"givemon",
    {op="givemon",species=25,level=5})
assert(giftCalls==giftBefore+1,
    "matching gift accepted by native transaction")
-- NPC trade's offered species must be checked before destructive swap.
game.session.map="FR_ROUTE_27"
fire("map.entered",{mapId="FR_ROUTE_27"})
assert(variants.setRule("type_lock_primary",10))
hooks["script.command"](nativePreview,c,"specialvar",
    {op="specialvar",[1]=0x800D,[2]=77})
assert(vm.ctx.specialVars[0x800D]==0,
    "off-type NPC trade refused at preview, not after swap")
assert(variants.setRule("type_lock_primary",13))
hooks["script.command"](nativePreview,c,"specialvar",
    {op="specialvar",[1]=0x800D,[2]=77})
assert(vm.ctx.specialVars[0x800D]==25,
    "legal NPC trade preview preserved")
assert(variants.setRule("type_lock_mode",0))
-- Catch Draft must derive its types from native SUCCESSFUL wild catches,
-- not a battle start, failed Ball, gift receipt or NPC trade.
nativePokemon.keyName=function(id)
    return ({[25]="PIKACHU",[4]="CHARMANDER",
        [7]="SQUIRTLE",[3]="VENUSAUR"})[id]
end
nativePokemon.types=function(id)
    return ({[25]={13,13},[4]={10,10},
        [7]={11,11},[3]={12,3}})[id] or {0,0}
end
assert(variants.setRule("type_lock_mode",2))
assert(variants.setRule("type_lock_draft",true))
local initial=values.gen3_classic_v1.variantRules
assert(initial.drafted_types==nil and variants.getRule("type_lock_draft"))
game.session.map="FR_ROUTE_28"
fire("map.entered",{mapId="FR_ROUTE_28"})
local giftCount=giftCalls
hooks["script.command"](nativeGift,c,"givemon",
    {op="givemon",species=25,level=5})
assert(giftCalls==giftCount
    and values.gen3_classic_v1.variantRules.drafted_types==nil,
    "before the first wild catch, a gift may not supply a draft type")
local failedWild={enemy={mon={species=4,speciesId=4}}}
fire("battle.started",{battle=failedWild,kind="wild",speciesId=4})
local result=hooks["catch.rate"](function()
    return false,0
end,"POKE_BALL",{speciesId=4},4,{battle=failedWild})
assert(not result)
fire("battle.ended")
assert(values.gen3_classic_v1.variantRules.drafted_types==nil,
    "failed Ball or failed encounter must not fill draft lanes")
game.session.map="FR_ROUTE_29"
fire("map.entered",{mapId="FR_ROUTE_29"})
local electricWild={enemy={mon={species=25,speciesId=25}}}
fire("battle.started",{battle=electricWild,kind="wild",speciesId=25})
local capture=hooks["catch.rate"](function() return true,4 end,
    "POKE_BALL",{speciesId=25},25,{battle=electricWild})
assert(capture)
fire("pokemon.caught",{battle=electricWild,speciesId=25,
    mon={speciesId=25}})
assert(values.gen3_classic_v1.variantRules.drafted_types[1]==13,
    "first real wild catch drafts ELECTRIC")
fire("pokemon.caught",{battle=electricWild,speciesId=25,
    mon={speciesId=25}})
assert(#values.gen3_classic_v1.variantRules.drafted_types==1,
    "duplicate caught notification must not draft twice")
fire("battle.ended")
game.session.map="FR_ROUTE_30"
fire("map.entered",{mapId="FR_ROUTE_30"})
hooks["script.command"](nativeGift,c,"givemon",
    {op="givemon",species=25,level=5})
assert(giftCalls==giftCount+1
    and #values.gen3_classic_v1.variantRules.drafted_types==1,
    "matching gift is legal but does NOT draft a second type")
local offGift=giftCalls
game.session.map="FR_ROUTE_33"
fire("map.entered",{mapId="FR_ROUTE_33"})
hooks["script.command"](nativeGift,c,"givemon",
    {op="givemon",species=4,level=5})
assert(giftCalls==offGift
    and values.gen3_classic_v1.areas.FR_ROUTE_33==nil,
    "off-type gift rejected on a fresh map while draft is partial")
-- NPC trades may use the drafted ELECTRIC type but may not supply a lane.
game.session.map="FR_ROUTE_34"
fire("map.entered",{mapId="FR_ROUTE_34"})
local tradeBefore=tradedCalls
hooks["script.command"](nativePreview,c,"specialvar",
    {op="specialvar",[1]=0x800D,[2]=77})
assert(vm.ctx.specialVars[0x800D]==25)
local swapped=npcTrades.tradeMons(game.session,0,{species=25,hp=10})
assert(swapped and tradedCalls==tradeBefore+1
    and #values.gen3_classic_v1.variantRules.drafted_types==1,
    "legal NPC trade never drafts another type")
game.session.map="FR_ROUTE_35"
fire("map.entered",{mapId="FR_ROUTE_35"})
tradeBefore=tradedCalls
assert(npcTrades.tradeMons(game.session,0,{species=4,hp=10})==nil
    and tradedCalls==tradeBefore
    and values.gen3_classic_v1.areas.FR_ROUTE_35==nil,
    "off-type NPC trade refused without removing offered Pokemon")
-- Another successful wild catch, not a gift/trade, completes the draft.
game.session.map="FR_ROUTE_31"
fire("map.entered",{mapId="FR_ROUTE_31"})
local fireWild={enemy={mon={species=4,speciesId=4}}}
fire("battle.started",{battle=fireWild,kind="wild",speciesId=4})
assert(hooks["catch.rate"](function()return true,4 end,
    "POKE_BALL",{speciesId=4},4,{battle=fireWild}))
fire("pokemon.caught",{battle=fireWild,speciesId=4,
    mon={speciesId=4}})
fire("battle.ended")
local savedDraft=values.gen3_classic_v1.variantRules.drafted_types
assert(#savedDraft==2 and savedDraft[1]==13 and savedDraft[2]==10,
    "draft picks are stored by canonical native GBA type ID")
game.session.map="FR_ROUTE_32"
fire("map.entered",{mapId="FR_ROUTE_32"})
local waterWild={enemy={mon={species=7,speciesId=7}}}
fire("battle.started",{battle=waterWild,kind="wild",speciesId=7})
assert(values.gen3_classic_v1.areas.FR_ROUTE_32==nil,
    "after the draft is full, off-type wild cannot spend a route")
local nativeCalled=false
result=hooks["catch.rate"](function()
    nativeCalled=true;return true,4
end,"POKE_BALL",{speciesId=7},7,{battle=waterWild})
assert(not result and not nativeCalled,
    "off-type wild Ball vetoed before native catch transaction")
fire("battle.ended")
assert(variants.setRule("type_lock_draft",false))
assert(values.gen3_classic_v1.variantRules.drafted_types==nil,
    "disabling draft resets recorded selections cleanly")
assert(variants.setRule("type_lock_mode",0))
-- No Catching is a global Ball ban: do not consume a first encounter
-- merely because Failed Encounters Count is active.
local battleItems=mod.exports.gen3_battle_items
assert(core.setRule("failed_encounter",true))
assert(core.setRule("encounter_limit",true))
assert(battleItems.setRule("no_catching",true))
game.session.map="FR_ROUTE_36"
fire("map.entered",{mapId="FR_ROUTE_36"})
local prohibited={enemy={mon={species=25,speciesId=25}}}
fire("battle.started",{battle=prohibited,kind="wild",speciesId=25})
assert(values.gen3_classic_v1.areas.FR_ROUTE_36==nil,
    "No Catching must not waste the first route attempt")
local calledNative=false
local allowedCatch,shakes=hooks["catch.rate"](function()
    calledNative=true
    return true,4
end,"POKE_BALL",{speciesId=25},25,{battle=prohibited})
assert(not allowedCatch and shakes==0 and not calledNative)
fire("battle.ended")
assert(battleItems.setRule("no_catching",false))
print("Gen3 experimental Nuzlocke smoke PASS")
