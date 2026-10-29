-- Gen3 Hardcore Rules: all five policies and safe native boundaries.
local H=assert(loadfile("gen3_hardcore_rules.lua"))()()
local Core=assert(loadfile("gen3_core_rules.lua"))()()
local Areas=assert(loadfile("gen3_area_splits.lua"))()()
local Extra=assert(loadfile("gen3_extra_core.lua"))()()
local s=Core.normalise({})
local d=H.descriptors()
assert(#d==5)
local names={"no_escape","whiteout_clause","gym_lock_in",
    "dungeon_lock_in","no_held_items"}
for i,key in ipairs(names) do
    assert(d[i].key==key)
    assert(H.get(s,key)==false)
    assert(H.label(s,key)=="OFF")
    assert(H.next(s,key)==true)
    assert(not H.set(s,key,1))
end
assert(not H.set(s,"missing_rule",true))
assert(Core.set(s,"nuzlocke_enabled",true))
assert(H.set(s,"no_escape",true))
assert(H.on(s,Core,"no_escape"))
assert(H.blockRun(s,Core,{wild=true}))
assert(not H.blockRun(s,Core,{wild=false}))
for _,st in ipairs({
    {wild=true,safari=true},
    {wild=true,link=true},
    {wild=true,recordedLink=true},
    {wild=true,oldManTutorial=true},
    {wild=true,wallyTutorial=true},
    {wild=true,firstBattle=true},
    {wild=true,kinds={firstBattle=true}},
    {wild=true,kinds={tutorial="wally"}},
    {wild=true,pokedude=true},
}) do
    assert(not H.blockRun(s,Core,st),"no escape must exempt special battles")
end
assert(H.set(s,"whiteout_clause",true))
assert(H.whiteout(s,Core,"lose"))
assert(H.whiteout(s,Core,"blackout"))
assert(not H.whiteout(s,Core,"run"))
local native={party={}}
assert(not H.allowSurvivors(s,Core,native,nil))
native.party={{species=1,hp=12}}
assert(H.allowSurvivors(s,Core,native,Extra))
native.party={{species=1,hp=0}}
assert(not H.allowSurvivors(s,Core,native,Extra))
native.party={{species=1,hp=9,isEgg=true}}
assert(not H.allowSurvivors(s,Core,native,Extra))
native.party={}
native.storage={boxes={{
    mons={[1]={species=7,personality=17,hp=20}}
}}}
assert(H.allowSurvivors(s,Core,native,Extra))
assert(#native.party==1 and native.party[1].species==7)
assert(native.storage.boxes[1].mons[1]==nil)
-- Egg-only parties count as zero usable survivors, not an occupied
-- party that prevents access to a living rescue Pokemon.
native.party={{species=9,hp=1,isEgg=true}}
native.storage.boxes[1].mons[1]={species=7,personality=17,hp=20}
assert(H.allowSurvivors(s,Core,native,Extra))
assert(#native.party==2 and native.party[1].isEgg
    and native.party[2].species==7)
assert(native.storage.boxes[1].mons[1]==nil)
native.party={}
native.storage.boxes[1].mons[1]={
    species=7,personality=17,hp=20,nuzlockeDead=true}
assert(not H.allowSurvivors(s,Core,native,Extra))
native.storage.boxes[1].mons[1]={species=7,personality=17,hp=20}
s.graveyard={{archive={species=7,personality=17}}}
assert(not H.allowSurvivors(s,Core,native,Extra))
s.graveyard={}

assert(H.gymOf("FR_PEWTER_CITY_GYM")=="PEWTER")
assert(H.gymOf("EM_RUSTBORO_CITY_GYM")=="RUSTBORO")
assert(H.gymOf("RU_PETALBURG_CITY_GYM")=="PETALBURG")
assert(not H.gymOf("FR_PEWTER_CITY"))
assert(H.gymOf("FR_PEWTER_CITY_GYM_1F")=="PEWTER")
assert(H.gymOf("FR_CINNABAR_ISLAND_GYM")=="CINNABAR")
assert(H.gymOf("EM_SOOTOPOLIS_CITY_GYM_B1F")=="SOOTOPOLIS")
assert(not H.gymOf("FR_VIRIDIAN_FOREST"))
assert(H.set(s,"gym_lock_in",true))
local flags={
    badgeInfo=function(i)
        return ({[1]={gym="PEWTER",flag=0x820},
            [2]={gym="CERULEAN",flag=0x821}})[i]
    end,
    getFlag=function(store,ctx,flag)return store[flag]==true end,
}
local badges={}
assert(H.gymLocked(s,Core,"FR_PEWTER_CITY_GYM",flags,badges))
assert(not H.gymLocked(s,Core,"FR_PEWTER_CITY_GYM",flags,badges,true),
    "Gym Team Size requires a trip to PC; do not seal player inside")
assert(not H.gymLocked(s,Core,"FR_CERULEAN_CITY",flags,badges))
assert(not H.gymLocked(s,Core,"EM_RUSTBORO_CITY_GYM",flags,badges),
    "unrecognised edition badge data must fail open")
badges[0x820]=true
assert(not H.gymLocked(s,Core,"FR_PEWTER_CITY_GYM",flags,badges),
    "already cleared gym must never become a trap")
assert(not H.gymLocked(s,Core,"FR_PEWTER_CITY_GYM",flags,nil))
assert(not H.gymLocked(s,Core,"FR_PEWTER_CITY_GYM",{},badges))

assert(H.set(s,"dungeon_lock_in",true))
assert(H.dungeonOf("FR_MT_MOON_1F",Areas))
assert(H.dungeonOf("FR_ROCK_TUNNEL_B1F",Areas))
assert(H.dungeonOf("FR_SEAFOAM_ISLANDS_B3F",Areas))
assert(H.dungeonOf("EM_VICTORY_ROAD_B1F",Areas))
assert(not H.dungeonOf("FR_POKEMON_MANSION_B1F",Areas),
    "single-exit/unsupported locations must fail open")
local entry=H.entry(s,Core,"FR_ROUTE_4","FR_MT_MOON_1F",8,20,Areas)
assert(entry and entry.map=="FR_MT_MOON_1F"
    and entry.origin=="FR_ROUTE_4" and entry.x==8 and entry.y==20)
assert(not H.entry(s,Core,"FR_ROUTE_4","FR_MT_MOON_1F",nil,20,Areas))
assert(not H.entry(s,Core,"FR_MT_MOON_1F","FR_MT_MOON_B1F",8,8,Areas))
assert(not H.entry(s,Core,"FR_ROUTE_4","FR_POKEMON_MANSION_1F",8,8,Areas))
assert(H.dungeonEntranceLocked(s,Core,entry,
    "FR_MT_MOON_1F","FR_ROUTE_4",8,20,Areas))
assert(H.dungeonEntranceLocked(s,Core,entry,
    "FR_MT_MOON_1F","FR_ROUTE_4",9,19,Areas))
assert(not H.dungeonEntranceLocked(s,Core,entry,
    "FR_MT_MOON_1F","FR_ROUTE_4",20,20,Areas),
    "different exits on the same external map must stay open")
assert(not H.dungeonEntranceLocked(s,Core,entry,
    "FR_MT_MOON_B1F","FR_ROUTE_4",8,20,Areas))
assert(not H.dungeonEntranceLocked(s,Core,entry,
    "FR_MT_MOON_1F","FR_ROUTE_3",8,20,Areas))
assert(not H.dungeonEntranceLocked(s,Core,entry,
    "FR_MT_MOON_1F","FR_ROUTE_4",nil,20,Areas))
assert(H.dungeonEscapeLocked(s,Core,entry,"FR_MT_MOON_B2F",Areas))
assert(not H.dungeonEscapeLocked(s,Core,entry,"FR_ROUTE_4",Areas))
assert(not H.dungeonEscapeLocked(s,Core,entry,"FR_ROCK_TUNNEL_1F",Areas))
assert(not H.dungeonEscapeLocked(s,Core,nil,"FR_MT_MOON_1F",Areas))

assert(H.set(s,"no_held_items",true))
assert(H.heldGiveDenied(s,Core))
assert(H.heldEffectDenied(s,Core,{side="player",item=23}))
assert(H.heldEffectDenied(s,Core,{user="player",item=23}))
assert(not H.heldEffectDenied(s,Core,{side="enemy",item=23}))
assert(not H.heldEffectDenied(s,Core,nil))
assert(H.set(s,"no_held_items",false))
assert(not H.heldEffectDenied(s,Core,{side="player"}))
assert(Core.set(s,"nuzlocke_enabled",false))
assert(not H.blockRun(s,Core,{wild=true}))
assert(not H.whiteout(s,Core,"blackout"))
assert(not H.gymLocked(s,Core,"FR_PEWTER_CITY_GYM",flags,{}))
assert(not H.dungeonEscapeLocked(s,Core,entry,"FR_MT_MOON_1F",Areas))
local persisted={hardcoreRules=s.hardcoreRules}
assert(H.get(persisted,"no_escape"))
assert(H.get(persisted,"whiteout_clause"))
s.failed=true
assert(not H.set(s,"no_escape",false))
local f=assert(io.open("gen3_runtime.lua","rb"))
local rt=f:read("*a");f:close()
for _,token in ipairs({
    'readModule("gen3_hardcore_rules.lua")',
    'installHardcoreGuards()',
    'Hardcore.blockRun(loadState(),Core,st)',
    'Hardcore.gymLocked(saved,Core,from,',
    'Hardcore.dungeonEntranceLocked(saved,Core,',
    'Hardcore.dungeonEscapeLocked(loadState(),Core,',
    'Hardcore.allowSurvivors(s,Core,native,Extra)',
    'Hardcore.heldEffectDenied(loadState(),Core,b)',
    'ItemUse[method]=guarded',
    'Engine.tryFlee=guarded',
    'Held.of=guarded',
    'mod.events:on("player.warped"',
    'mod.exports.gen3_hardcore_rules',
}) do
    assert(rt:find(token,1,true),"missing Hardcore seam: "..token)
end
print("Gen3 Hardcore Rules: No Escape/Whiteout/Gym/Dungeon/Held Items PASS")
