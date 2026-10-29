-- Gen 3 Mod Support: live, read-only companion detection and API diagnostics.
local ModSupport=assert(loadfile("gen3_mod_support.lua"))()()
local function check(actual,expected,message)
    assert(actual==expected,(message or "status")..
        ": expected "..tostring(expected)..", got "..tostring(actual))
end

-- Missing or failing mod.find is not evidence of missing mods.
local unknown=ModSupport.inspect({},nil,nil,{})
check(unknown.untamed,"UNKNOWN")
for _,key in ipairs({
    "untamed","nationalDex","battleSprites","modernSpawns","hdSprites"
}) do
    local item=unknown.integrations[key]
    check(item.detection,"UNKNOWN",key)
    check(item.api,"UNKNOWN",key)
    check(item.tested,"NOT VERIFIED",key)
end
local reads=0
local mod={find=function()reads=reads+1;return nil end}
local absent=ModSupport.inspect(mod,nil,nil,{})
check(absent.untamed,"NOT FOUND")
for _,item in pairs(absent.integrations) do
    check(item.detection,"NOT FOUND")
    check(item.api,"N/A")
end
assert(reads==6,"five companions plus legacy randomizer probed live")

-- Presence alone is not an API contract.
local installed={
    national_dex_gen3={exports={apiVersion=2,listSpecies=function()end}},
    ["g9-battle-sprites-gen3"]={},
    modern_spawns={exports={apiVersion=1}},
    ["gen3-hd-sprites"]={exports={version=2}},
    untamed_advanced={exports={engine={}}},
    pokemon_randomizer={},
}
mod.find=function(_,id) return installed[id] end
local present=ModSupport.inspect(mod,nil,nil,{})
check(present.untamed,"DETECTED")
check(present.otherRandomizer,"DETECTED")
check(present.integrations.untamed.api,"NO PUBLIC API")
check(present.integrations.untamed.hook,"UNVERIFIED")
for _,key in ipairs({"nationalDex","battleSprites","modernSpawns","hdSprites"}) do
    local entry=present.integrations[key]
    check(entry.detection,"DETECTED")
    check(entry.api,"UNAVAILABLE")
    check(entry.tested,"NOT VERIFIED")
end

-- A usable read-only public API can be reported; do NOT call any
-- potentially state-changing provider functions just to diagnose it.
local called={active=0,unsafe=0}
local function active(value)
    return function()called.active=called.active+1;return value end
end
local function unsafe()
    called.unsafe=called.unsafe+1
    error("mod support must never enumerate sprites/spawns/mutate state")
end
installed.national_dex_gen3.exports={
    apiVersion=2,isActive=active(true),
    listSpecies=unsafe,listForms=unsafe,
    idOfSlot=unsafe,baseDexOf=unsafe,
}
installed["g9-battle-sprites-gen3"].exports={
    isActive=active(true),hasSprite=unsafe,
}
installed.modern_spawns.exports={
    apiVersion=2,isActive=active(false),tableFor=unsafe,drawFor=unsafe,
}
installed["gen3-hd-sprites"].exports={
    isActive=active(true),enabled=unsafe,tag=unsafe,
}
local result=ModSupport.inspect(mod,nil,nil,{})
for _,key in ipairs({"nationalDex","battleSprites","modernSpawns","hdSprites"}) do
    check(result.integrations[key].api,"READY",key)
    check(result.integrations[key].tested,"NOT VERIFIED",key)
end
check(result.integrations.nationalDex.active,"ACTIVE")
check(result.integrations.battleSprites.active,"ACTIVE")
check(result.integrations.modernSpawns.active,"INACTIVE")
check(result.integrations.hdSprites.active,"ACTIVE")
check(called.active,4,"only safe isActive probes")
check(called.unsafe,0,"no provider mutation/asset access")

-- Re-read current provider state every time, and fail closed if a
-- public status accessor throws or returns an ambiguous value.
installed["g9-battle-sprites-gen3"].exports.isActive=function()
    error("temporarily unavailable")
end
local changed=ModSupport.inspect(mod,nil,nil,{})
check(changed.integrations.battleSprites.api,"READY")
check(changed.integrations.battleSprites.active,"UNKNOWN")
installed.national_dex_gen3.exports.apiVersion=1
check(ModSupport.inspect(mod,nil,nil,{}).integrations.nationalDex.api,
    "UNAVAILABLE","v1 not a v2 form roster")
installed.modern_spawns=nil
check(ModSupport.inspect(mod,nil,nil,{}).integrations.modernSpawns.detection,
    "NOT FOUND","live removal")
mod.find=function()error("provider loader error")end
check(ModSupport.inspect(mod,nil,nil,{}).integrations.untamed.detection,
    "UNKNOWN","broken loader must not report absence")

-- Preserve the existing shiny/rng diagnostics and report their read failures
-- without bringing down the menu.
local fakeShiny={externalProvider=function()return "custom-shiny" end}
local fakeRng={get=function(_,key)
    if key=="random_encounter_tables" then return true end
    if key=="random_trainers" then return false end
end}
mod.find=function(_,id)return installed[id]end
local legacy=ModSupport.inspect(mod,fakeShiny,fakeRng,{})
check(legacy.shiny,"EXTERNAL")
check(legacy.shinyOwner,"custom-shiny")
assert(legacy.wildRandom==true and legacy.trainerRandom==false)
local failing=ModSupport.inspect(mod,{
    externalProvider=function()error("unavailable")end
},{
    get=function()error("unavailable")end
},{})
check(failing.shiny,"NUZLOCKE")
assert(not failing.wildRandom and not failing.trainerRandom)
print("Gen 3 Mod Support companion detection / API readiness: PASS")
