-- Gen 3 Egg Encounter policy: source tagging, safe hatch claims, unknown gifts.
local Egg = assert(loadfile("gen3_eggs.lua"))()()
local s = { areas = {} }
local born = { personality = 771, otId = 45, species = 175, isEgg = true }
assert(Egg.created(s, { egg = born, mother = { species = 25 } }, "FR_ROUTE_5"))
assert(born.nuzEggReceivedAt == "FR_ROUTE_5"
    and born.nuzEggOrigin == "DAYCARE", "native event tags real bred egg")
local grown = { personality = 771, otId = 45, species = 175, isEgg = false }
local ok, result = Egg.hatched(s,
    { mon = grown, egg = born, species = 175 }, "FR_ROUTE_6", 1)
assert(ok and result == "claimed", "RECEIVED uses saved receipt source")
assert(s.areas.FR_ROUTE_5 and s.areas.FR_ROUTE_5.caught
    and s.areas.FR_ROUTE_6 == nil, "claim receipt map, not hatch map")
local nextEgg = { personality = 992, species = 174 }
Egg.created(s, { egg = nextEgg, mother = { species = 174 } }, "FR_ROUTE_5")
local invalid = { species = 174 }
ok, result = Egg.hatched(s,
    { mon = invalid, egg = nextEgg, species = 174 }, "FR_ROUTE_7", 1)
assert(not ok and result == "area_spent"
    and invalid.nuzEggProvenance == "INELIGIBLE",
    "spent receipt map flags hatch as ineligible without deleting it")
assert(s.areas.FR_ROUTE_5.caughtSpeciesId == 175,
    "invalid second egg never overwrites existing claim")
local hatchEgg = { personality = 23, species = 172 }
Egg.created(s, { egg = hatchEgg, mother = { species = 25 } }, "FR_ROUTE_5")
local hatchMon = { species = 172 }
ok, result = Egg.hatched(s,
    { mon = hatchMon, egg = hatchEgg, species = 172 }, "FR_ROUTE_8", 2)
assert(ok and s.areas.FR_ROUTE_8.caughtSpeciesId == 172,
    "HATCHED consumes hatch location, ignoring received site")
local unknown = { species = 133 }
local gift = { species = 133, isEgg = true }
Egg.created(s, { egg = gift }, "FR_ROUTE_9")
ok, result = Egg.hatched(s, { mon = unknown, egg = gift },
    "FR_ROUTE_10", 3)
assert(not ok and result == "location_unavailable"
    and not s.areas.FR_ROUTE_9 and not s.areas.FR_ROUTE_10,
    "unknown gift delivery cannot silently consume a made-up slot")
local free = { species = 16 }
ok, result = Egg.hatched(s, { mon = free, egg = hatchEgg },
    "FR_ROUTE_11", 0)
assert(ok and result == "exempt" and s.areas.FR_ROUTE_11 == nil,
    "OFF lets bred Eggs hatch freely")
print("Gen3 egg provenance smoke PASS")
