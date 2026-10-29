-- Standalone Gen 3 clauses policy tests: Lua 5.1, no ROM required.
local graph = {
    [133] = { { method = 7, param = 0, target = 134 },
              { method = 7, param = 0, target = 135 },
              { method = 7, param = 0, target = 136 } },
    [10] = { { method = 4, param = 7, target = 11 } },
    [11] = { { method = 4, param = 10, target = 12 } },
}
package.loaded["src.core.game3.pokemon"] = {
    evolutions = function(id) return graph[id] or {} end,
    speciesFromName = function(name)
        return ({ EEVEE = 133, JOLTEON = 135, VAPOREON = 134 })[name]
    end,
    isShiny = function(mon) return mon.isShiny == true end,
}
local Clauses = assert(loadfile("gen3_clauses.lua"))()()
local s = { areas = {}, graveyard = {}, capturedSpecies = {} }
assert(#Clauses.descriptors() == 6, "Gen 3 removes redundant shiny visuals")
assert(Clauses.get(s, "dupes_mode") == 0, "new games default dupes OFF")
assert(Clauses.get(s, "shiny_clause") == 0, "new games default shiny OFF")
assert(Clauses.set(s, "gen3_egg_encounter_mode", 2),
    "hatch location mode is selectable for WIP egg provenance")
assert(Clauses.set(s, "route_forgiveness", 2),
    "token-only forgiveness mode is selectable")
assert(Clauses.set(s, "shiny_rate_mode", 1),
    "Shiny Rate modes are now selectable")
assert(Clauses.get(s, "shiny_rate_mode") == 1)
assert(Clauses.set(s, "shiny_rate_mode", 6))
assert(Clauses.label(s, "shiny_rate_mode") == "ALWAYS")
assert(Clauses.set(s, "shiny_rate_mode", 7) == false,
    "out-of-range enhanced shiny odds must be rejected")
assert(Clauses.get(s, "shiny_colors") == nil
    and Clauses.get(s, "shiny_intro") == nil,
    "redundant native shiny visual controls are removed")
assert(Clauses.set(s, "dupes_mode", 42) == false,
    "invalid mode must be rejected")
Clauses.noteCaught(s, 134, false) -- previously caught Vaporeon
assert(Clauses.set(s, "dupes_mode", 1)) -- SPEC
assert(Clauses.isDuplicate(s, 134, nil, "firered"),
    "same species is a dupe")
assert(not Clauses.isDuplicate(s, 135, nil, "firered"),
    "SPEC permits Eevee sibling Jolteon")
assert(Clauses.set(s, "dupes_mode", 2)) -- FAM
assert(Clauses.isDuplicate(s, 135, nil, "firered"),
    "FAM includes Eevee sibling branches")
assert(Clauses.isDuplicate(s, 133, nil, "firered"),
    "FAM includes shared ancestors")
assert(not Clauses.isDuplicate(s, 25, nil, "firered"),
    "FAM doesn't block unrelated species")
assert(Clauses.set(s, "dupes_mode", 3)) -- SPLIT
assert(not Clauses.isDuplicate(s, 135, nil, "firered"),
    "SPLIT must allow Jolteon despite Vaporeon capture")
assert(Clauses.isDuplicate(s, 133, nil, "firered"),
    "SPLIT blocks ancestor Eevee after Vaporeon")
assert(Clauses.set(s, "dupes_mode", 2))
s.capturedSpecies = {}
-- A caught species continues to count after being permanently removed.
s.graveyard = { { species = 134 } }
assert(Clauses.isDuplicate(s, 135, nil, "firered"))
s.graveyard = {}
local session = { party = { { species = 133, hp = 30 } },
    storage = { boxes = { { mons = { { species = 10, hp = 20 } } } } } }
assert(Clauses.isDuplicate(s, 135, session, "firered"),
    "unrecorded starter in party must count")
assert(Clauses.isDuplicate(s, 12, session, "firered"),
    "boxed Caterpie counts after evolving into Butterfree")
session.party = {}
session.storage.boxes[1].mons = {}
s.areas = { ["FR_ROUTE_1"] = { caught = true, caughtSpeciesId = 134 } }
assert(Clauses.isDuplicate(s, 135, session, "firered"),
    "old catch records contribute to Dupes")
s.areas = {}
assert(Clauses.set(s, "shiny_clause", 1))
assert(Clauses.canUseShinyException(s))
assert(Clauses.isShiny({ isShiny = true }))
assert(not Clauses.isShiny({ isShiny = false }))
Clauses.noteCaught(s, 25, true)
assert(s.shinyExceptionsUsed == 1, "one exception consumed")
assert(not Clauses.canUseShinyException(s), "single shiny allowance spent")
assert(Clauses.set(s, "shiny_clause", 3))
assert(Clauses.canUseShinyException(s), "larger allowance uses spent count")
Clauses.noteCaught(s, 16, true)
Clauses.noteCaught(s, 19, true)
assert(not Clauses.canUseShinyException(s))
assert(Clauses.set(s, "shiny_clause", 4))
assert(Clauses.canUseShinyException(s), "unlimited ignores counter")
-- Roamers get one species-specific slot and never borrow a route slot.
assert(Clauses.get(s, "gen3_roamer_clause") == 0)
assert(Clauses.set(s, "gen3_roamer_clause", 1))
assert(Clauses.roamerAvailable(s, 243), "first roaming Raikou is eligible")
assert(Clauses.roamerAvailable(s, 244), "different roamer species has its own slot")
assert(Clauses.claimRoamer(s, 243), "successful Raikou catch closes its slot")
assert(not Clauses.roamerAvailable(s, 243), "caught roamer cannot be claimed again")
assert(Clauses.roamerAvailable(s, 244), "Raikou doesn't close Entei's slot")
assert(not Clauses.claimRoamer(s, 243), "duplicate roamer claim prevented")
assert(Clauses.set(s, "gen3_roamer_clause", 0))
assert(not Clauses.roamerAvailable(s, 244), "disabled roamer policy is inert")
assert(s.roamerClaims["243"] == true, "changing mode preserves history")
assert(Clauses.set(s, "gen3_roamer_clause", 1))
assert(not Clauses.roamerAvailable(s, 243), "history survives toggles")

s.failed = true
assert(Clauses.set(s, "dupes_mode", 0) == false,
    "failed runs cannot alter clause settings")
print("Gen3 clauses policy smoke PASS")
