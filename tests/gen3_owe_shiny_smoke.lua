-- Untamed-Advanced OWE shiny-rate handshake: spawn -> sprite -> battle.
-- Run with lua5.1 tests/gen3_owe_shiny_smoke.lua
local events, hooks, saves = {}, {}, {}
package.loaded["src.core.game3.pokemon"] = {
    isShiny = function(mon) return mon.isShiny == true end,
    speciesOf = function(mon) return mon.species end,
    name = function(id) return tostring(id) end,
}
local g = {generation = 3, session = {map = "FR_ROUTE_1",
    version = "firered", party = {}, flags = {}}}
local mod = {
    game = g, exports = {},
    save = {
        get = function(_,k,default) return saves[k] or default end,
        set = function(_,k,v) saves[k] = v end,
    },
    events = {on = function(_,name,fn) events[name] = fn end},
    hooks = {wrap = function(_,name,fn) hooks[name] = fn end},
    read = function(_,path)
        local f = assert(io.open(path,"rb"))
        local contents = f:read("*a")
        f:close()
        return contents
    end,
}
assert(loadfile("gen3_runtime.lua")()(mod) == nil)
local rate = mod.exports.gen3_clauses
assert(rate.setMode("shiny_rate_mode",6))
assert(type(hooks["untamed.owe.shiny"]) == "function")

local function source(pid, shiny)
    return { species = 25, level = 7, personality = pid, shiny = shiny }
end
local converterCalls = 0
local context = {
    source = "untamed_advanced", mapId = "FR_ROUTE_1",
    terrain = "land", x = 5, y = 9,
    makeShiny = function(pid)
        converterCalls = converterCalls + 1
        return pid + 65536
    end,
}
local function native(mon) return mon end
local function spawn(mon, ctx)
    return hooks["untamed.owe.shiny"](native,mon,ctx or context)
end
local forced = spawn(source(10,false))
assert(forced.shiny == true and forced.personality == 65546)
assert(converterCalls == 1,
    "ALWAYS makes an actually shiny personality at spawn time")
local normalOriginal = source(11,false)
assert(normalOriginal.shiny == false and normalOriginal.personality == 11,
    "provider never mutates original OWE spawn data")

local natural = spawn(source(20,true))
assert(natural.shiny == true and natural.personality == 20
    and converterCalls == 1,"chain/native shinies must not be rewritten")
local wrongContext = {source="another",mapId="FR_ROUTE_1",terrain="land",
    makeShiny=context.makeShiny}
assert(spawn(source(21,false),wrongContext).personality == 21,
    "only Untamed generated OWEs may receive the modifier")

-- The same individual is not rerolled on entering its wild battle.
local function startBattle(pid, shiny)
    local mon = {species=25,level=7,personality=pid,isShiny=shiny}
    local battle = {enemy={mon=mon}}
    events["battle.started"]({kind="wild",battle=battle,speciesId=25})
    return mon
end
local caught = startBattle(65546,true)
assert(caught.isShiny and caught.nuzlockeShinyRateChecked,
    "boosted overworld PID remains the one used in the wild battle")

-- Spawn with NATIVE then switch to ALWAYS before touching the sprite:
-- existing individuals must stay visually/battle-consistent.
assert(rate.setMode("shiny_rate_mode",0))
local preexisting = spawn(source(31,false))
assert(not preexisting.shiny and preexisting.personality == 31)
assert(rate.setMode("shiny_rate_mode",6))
local preexistingBattle = startBattle(31,false)
assert(not preexistingBattle.isShiny and
    preexistingBattle.nuzlockeShinyRateChecked,
    "a visible nonshiny OWE must never turn shiny when battle begins")

-- Native step/fishing battles are still allowed their regular shiny roll.
local nativeBattle = startBattle(44,false)
assert(nativeBattle.isShiny == true and
    nativeBattle.nuzlockeShinyRateBoosted == true,
    "native wild battles continue to use normal Nuzlocke odds")

-- A failed conditional roll does not become a shiny, but is remembered.
assert(rate.setMode("shiny_rate_mode",4)) -- 1/100
local origRandom = math.random
math.random = function() return 0.99 end
local unchanged = spawn(source(51,false))
math.random = origRandom
assert(unchanged.personality == 51 and not unchanged.shiny,
    "ordinary overworld spawns do not silently become shiny")
assert(startBattle(51,false).nuzlockeShinyRateChecked,
    "failed spawn roll must not be retried in battle")

-- Higher native chain odds remain authoritative; external providers own
-- the shiny policy if explicitly installed and advertising compatibility.
-- Configure odds before external ownership: the public API correctly refuses
-- configuration changes while a different shiny mod owns generation.
-- Configure odds before external ownership; the public API refuses changes
-- while another shiny mod owns generation.
assert(rate.setMode("shiny_rate_mode",6))
mod.find = function(_,id)
    if id ~= "SHINY_POKEMON" then return nil end
    return { id = id, exports = {shiny_compat = {
        isShiny = function() return true end }} }
end
local external = spawn(source(61,false))
assert(not external.shiny and external.personality == 61,
    "external shiny owner must not be overridden")
mod.find = nil

events["save.loaded"]()
-- With no active boost the old cache should not survive save loading.
assert(rate.setMode("shiny_rate_mode",0))
assert(startBattle(31,false).nuzlockeShinyRateChecked ~= true,
    "OWE identity cache must be cleared on save reload")
print("Gen3 Untamed overworld shiny-rate handshake: PASS")
