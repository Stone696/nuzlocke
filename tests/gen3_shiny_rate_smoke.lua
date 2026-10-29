-- Isolated Gen 3 shiny-rate tests: no ROM or battle simulation required.
local ShinyRate = assert(loadfile("gen3_shiny_rate.lua"))()()
local function battle(mon, extra)
    local st = { enemy = { mon = mon } }
    for k, v in pairs(extra or {}) do st[k] = v end
    return { kind = "wild", battle = st }
end
local p = {}
assert(ShinyRate.modeLabel(0) == "NATIVE")
assert(ShinyRate.modeLabel(6) == "ALWAYS")
local f = ShinyRate.extraProbability(1)
local target = (1 / 8192) + (8191 / 8192) * f
assert(math.abs(target - (1 / 4096)) < 1e-12,
    "enhanced odds must be total probability, not stacked native+full")
assert(ShinyRate.extraProbability(0) == 0)
assert(ShinyRate.extraProbability(6) == 1)
local rolls = 0
local function rng()
    rolls = rolls + 1
    return 0
end
local naturalCalls = 0
local function checkNative(mon)
    naturalCalls = naturalCalls + 1
    return mon.isShiny == true
end
local wild = { species = 16, personality = 2345 }
local ok, kind = ShinyRate.apply(p, battle(wild), 6, rng, checkNative)
assert(ok and kind == "boosted" and wild.isShiny == true,
    "ALWAYS should mark eligible wild shiny")
assert(wild.nuzlockeShinyRateBoosted == true)
assert(rolls == 0 and naturalCalls == 1,
    "ALWAYS doesn't need RNG; native status read once")
ok, kind = ShinyRate.apply(p, battle(wild), 6, rng, checkNative)
assert(ok and kind == "already_checked"
    and naturalCalls == 1 and rolls == 0,
    "multiple drawing/encounter callbacks may not reroll")
local shiny = { species = 25, isShiny = true }
ok, kind = ShinyRate.apply(p, battle(shiny), 6, rng, checkNative)
assert(not ok and kind == "naturally_shiny"
    and shiny.nuzlockeShinyRateBoosted ~= true,
    "preserve native shinies without labelling them boosted")
local ordinary = { species = 10, personality = 88 }
ok, kind = ShinyRate.apply(p, battle(ordinary), 1, function()
    rolls = rolls + 1
    return 0.99
end, checkNative)
assert(not ok and kind == "ordinary"
    and ordinary.isShiny == nil and ordinary.nuzlockeShinyRateChecked,
    "failed enhanced roll must not force normal identity or reroll")
for _, ev in ipairs({
    { kind = "trainer", battle = { enemy = { mon = { species = 16 } } } },
    battle({ species = 16 }, { firstBattle = true }),
    battle({ species = 16, roamer = true }),
    battle({ species = 16 }, { oldManTutorial = true }),
    battle({ species = 16 }, { kinds = { tutorial = "wally" } }),
}) do
    local enabled, why = ShinyRate.apply(p, ev, 6, rng, checkNative)
    assert(not enabled and why == "not_eligible",
        "never alter scripted tutorials/trainers/roamers")
end
local provider = {
    id = "SHINY_POKEMON",
    exports = { shiny_compat = { isShiny = function() return true end } },
}
local runtime = {
    id = "NUZLOCKE",
    find = function(_, id)
        return id == "SHINY_POKEMON" and provider or nil
    end,
}
assert(ShinyRate.externalProvider(runtime) == "SHINY_POKEMON")
local externalMon = { species = 16 }
ok, kind = ShinyRate.apply(runtime, battle(externalMon), 6, rng, checkNative)
assert(not ok and kind == "external"
    and externalMon.isShiny == nil,
    "verified external owner wins over ALWAYS")
assert(ShinyRate.externalProvider({ find = function()
    return { id = "SHINY_POKEMON", exports = {} }
end }) == nil, "stale identity registry is not an owner")
print("Gen3 shiny-rate policy smoke PASS")
