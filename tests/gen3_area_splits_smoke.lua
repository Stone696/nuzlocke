-- Gen 3 Area Splits native-map/floor/route/Safari ledger tests.
local Splits=assert(loadfile("gen3_area_splits.lua"))()()
local Core=assert(loadfile("gen3_core_rules.lua"))()()
local s=Core.normalise({})
local function set(k,v) assert(Splits.set(s,k,v)) end
local function resolve(id,p) return Splits.resolve(s,Core,id,p) end
assert(#Splits.descriptors()==10)
assert(Splits.label(s,"area_scope")=="NATIVE MAP")
assert(resolve("FR_MT_MOON_1F")=="FR_MT_MOON_1F")
assert(Core.set(s,"nuzlocke_enabled",true))
assert(resolve("FR_MT_MOON_1F")=="FR_MT_MOON_1F",
    "upgraded runs must keep native map ledger by default")
assert(not Splits.set(s,"area_scope",4))
assert(not Splits.set(s,"mt_moon_splits",true))
assert(not Splits.set(s,"route_2_split",1))
assert(not Splits.set(s,"safari_zone_splits",5))
assert(not Splits.set(s,"gold_time_split",true))
set("area_scope",1)
assert(resolve("FR_MT_MOON_1F")=="SPLIT:FR:MT_MOON")
assert(resolve("FR_MT_MOON_B1F")=="SPLIT:FR:MT_MOON")
assert(resolve("FR_MT_MOON_B2F")=="SPLIT:FR:MT_MOON")
assert(resolve("FR_ROCK_TUNNEL_B1F")=="SPLIT:FR:ROCK_TUNNEL")
assert(resolve("FR_SEAFOAM_ISLANDS_B4F")=="SPLIT:FR:SEAFOAM_ISLANDS")
assert(resolve("FR_VICTORY_ROAD_2F")=="SPLIT:FR:VICTORY_ROAD")
assert(resolve("FR_POKEMON_MANSION_B1F")=="SPLIT:FR:POKEMON_MANSION")
assert(resolve("FR_POKEMON_TOWER_7F")=="SPLIT:FR:POKEMON_TOWER")
assert(resolve("FR_CERULEAN_CAVE_B1F")=="SPLIT:FR:CERULEAN_CAVE")
assert(resolve("FR_SILPH_CO_11F")=="SPLIT:FR:SILPH_CO")
assert(resolve("FR_SSANNE_1F_CORRIDOR")=="SPLIT:FR:SSANNE")
assert(resolve("FR_FOUR_ISLAND_ICEFALL_CAVE_B1F")=="SPLIT:FR:ICEFALL_CAVE")
assert(resolve("FR_FIVE_ISLAND_LOST_CAVE_ROOM14")=="SPLIT:FR:LOST_CAVE")
assert(resolve("FR_MT_EMBER_RUBY_PATH_B3F")=="SPLIT:FR:MT_EMBER")
assert(resolve("FR_NAVEl_ROCK_1F")=="FR_NAVEl_ROCK_1F",
    "invalid/unknown case must not create synthetic locations")
assert(resolve("RU_METEOR_FALLS_1F_1R")=="SPLIT:RU:METEOR_FALLS")
assert(resolve("SA_GRANITE_CAVE_B2F")=="SPLIT:SA:GRANITE_CAVE")
assert(resolve("EM_SHOAL_CAVE_LOW_TIDE_INNER_ROOM")=="SPLIT:EM:SHOAL_CAVE")
assert(resolve("EM_MT_PYRE_3F")=="SPLIT:EM:MT_PYRE")
assert(resolve("EM_SKY_PILLAR_5F")=="SPLIT:EM:SKY_PILLAR")
assert(resolve("EM_SEAFLOOR_CAVERN_ROOM7")=="SPLIT:EM:SEAFLOOR_CAVERN")
assert(resolve("FR_PALLET_TOWN")=="FR_PALLET_TOWN")
assert(resolve("FR_ROUTE_1")=="FR_ROUTE_1")
assert(resolve("FR_PALLET_TOWN_OAKS_LAB")=="FR_PALLET_TOWN_OAKS_LAB")
assert(resolve("RU_LITTLEROOT_TOWN")=="RU_LITTLEROOT_TOWN")
assert(resolve("EM_PETALBURG_CITY_GYM")=="EM_PETALBURG_CITY_GYM")
assert(resolve("FR_ROUTE_21_NORTH")=="SPLIT:FR:ROUTE_21")
assert(resolve("FR_ROUTE_21_SOUTH")=="SPLIT:FR:ROUTE_21")
set("route_21_split",true)
assert(resolve("FR_ROUTE_21_NORTH")=="FR_ROUTE_21_NORTH")
set("route_21_split",false)
set("area_scope",2)
assert(resolve("FR_MT_MOON_1F")=="SPLIT:FR:MT_MOON:1F")
assert(resolve("FR_MT_MOON_B1F")=="SPLIT:FR:MT_MOON:B1F")
assert(resolve("FR_ROCK_TUNNEL_B1F")=="SPLIT:FR:ROCK_TUNNEL:B1F")
assert(resolve("FR_FIVE_ISLAND_LOST_CAVE_ROOM1")==
    resolve("FR_FIVE_ISLAND_LOST_CAVE_ROOM14"),
    "room puzzle should not gain a slot for each door")
assert(resolve("RU_METEOR_FALLS_1F_1R")=="SPLIT:RU:METEOR_FALLS:1F")
assert(resolve("EM_SHOAL_CAVE_LOW_TIDE_INNER_ROOM")==
    "SPLIT:EM:SHOAL_CAVE:LOW_TIDE")
assert(resolve("EM_SKY_PILLAR_5F")=="SPLIT:EM:SKY_PILLAR:5F")
assert(Splits.name("SPLIT:FR:MT_MOON:B1F")=="Mt. Moon - B1F")
assert(Splits.name("FR_MT_MOON_1F")=="Mt. Moon - 1F")
set("mt_moon_splits",1)
assert(resolve("FR_MT_MOON_B1F")=="SPLIT:FR:MT_MOON")
assert(resolve("FR_ROCK_TUNNEL_B1F")=="SPLIT:FR:ROCK_TUNNEL:B1F")
set("mt_moon_splits",0)
set("kanto_dungeon_splits",1)
assert(resolve("FR_ROCK_TUNNEL_1F")=="SPLIT:FR:ROCK_TUNNEL")
assert(resolve("RU_METEOR_FALLS_1F_1R")=="SPLIT:RU:METEOR_FALLS:1F")
set("kanto_dungeon_splits",0)
set("hoenn_dungeon_splits",1)
assert(resolve("EM_SKY_PILLAR_1F")=="SPLIT:EM:SKY_PILLAR")
assert(resolve("FR_ROCK_TUNNEL_B1F")=="SPLIT:FR:ROCK_TUNNEL:B1F")
set("hoenn_dungeon_splits",0)
set("sevii_dungeon_splits",1)
assert(resolve("FR_FOUR_ISLAND_ICEFALL_CAVE_B1F")=="SPLIT:FR:ICEFALL_CAVE")
assert(resolve("FR_ROCK_TUNNEL_B1F")=="SPLIT:FR:ROCK_TUNNEL:B1F")
set("sevii_dungeon_splits",0)
set("area_scope",0)
set("route_2_split",true)
set("route_10_split",true)
set("route_20_split",true)
assert(resolve("FR_ROUTE_2",{x=10,y=2,width=25,height=100})==
    "SPLIT:FR:ROUTE_2:NORTH")
assert(resolve("FR_ROUTE_2",{x=10,y=90,width=25,height=100})==
    "SPLIT:FR:ROUTE_2:SOUTH")
assert(resolve("FR_ROUTE_10",{x=5,y=39,width=20,height=80})==
    "SPLIT:FR:ROUTE_10:NORTH")
assert(resolve("FR_ROUTE_10",{x=5,y=42,width=20,height=80})==
    "SPLIT:FR:ROUTE_10:SOUTH")
assert(resolve("FR_ROUTE_20",{x=5,y=10,width=100,height=30})==
    "SPLIT:FR:ROUTE_20:WEST")
assert(resolve("FR_ROUTE_20",{x=90,y=10,width=100,height=30})==
    "SPLIT:FR:ROUTE_20:EAST")
assert(resolve("FR_ROUTE_2",{x=10,y=10})=="FR_ROUTE_2",
    "unknown map dimensions must fail open to native identity")
assert(resolve("FR_ROUTE_2",{x=10,y=-5,width=25,height=100})==
    "FR_ROUTE_2")
assert(resolve("FR_ROUTE_3",{x=10,y=90,width=25,height=100})==
    "FR_ROUTE_3")
set("safari_zone_splits",1)
assert(resolve("FR_SAFARI_ZONE_CENTER")=="SPLIT:FR:SAFARI_ZONE")
assert(resolve("FR_SAFARI_ZONE_EAST")=="SPLIT:FR:SAFARI_ZONE")
assert(resolve("EM_SAFARI_ZONE_NORTHWEST")=="SPLIT:EM:SAFARI_ZONE")
assert(not Splits.safariUntilCatch(s,Core,"FR_SAFARI_ZONE_CENTER"))
set("safari_zone_splits",3)
assert(Splits.safariUntilCatch(s,Core,"FR_SAFARI_ZONE_CENTER"))
assert(resolve("FR_SAFARI_ZONE_NORTH")=="SPLIT:FR:SAFARI_ZONE")
set("safari_zone_splits",4)
assert(resolve("FR_SAFARI_ZONE_NORTH")=="SPLIT:FR:SAFARI_ZONE:NORTH")
assert(resolve("FR_SAFARI_ZONE_WEST")=="SPLIT:FR:SAFARI_ZONE:WEST")
assert(resolve("EM_SAFARI_ZONE_NORTHWEST")==
    "SPLIT:EM:SAFARI_ZONE:NORTHWEST")
assert(not Splits.safariUntilCatch(s,Core,"FR_FUCHSIA_CITY_SAFARI_ZONE_ENTRANCE"))
-- Switching projection preserves the spent history.
s.areas={}
set("safari_zone_splits",1)
assert(Splits.catchAllowed(s,Core,resolve("FR_SAFARI_ZONE_CENTER"),"FR_SAFARI_ZONE_CENTER"))
s.areas.FR_SAFARI_ZONE_EAST={spent=true}
assert(not Splits.catchAllowed(s,Core,resolve("FR_SAFARI_ZONE_CENTER"),"FR_SAFARI_ZONE_CENTER"),
    "a historical Safari area claim blocks a new grouped whole-zone catch")
s.areas={}
set("mt_moon_splits",1)
local shared=resolve("FR_MT_MOON_1F")
s.areas[shared]={spent=true}
set("mt_moon_splits",2)
assert(not Splits.catchAllowed(s,Core,resolve("FR_MT_MOON_B1F"),"FR_MT_MOON_B1F"))
s.areas={}
s.areas.FR_MT_MOON_1F={spent=true}
assert(not Splits.catchAllowed(s,Core,resolve("FR_MT_MOON_1F"),"FR_MT_MOON_1F"))
assert(Splits.catchAllowed(s,Core,resolve("FR_MT_MOON_B1F"),"FR_MT_MOON_B1F"),
    "per-floor mode must still permit a different unspent floor")
set("mt_moon_splits",1)
assert(not Splits.catchAllowed(s,Core,resolve("FR_MT_MOON_B1F"),"FR_MT_MOON_B1F"),
    "grouping cannot re-arm an old floor claim")
s.areas={}
set("route_2_split",true)
local north=resolve("FR_ROUTE_2",{x=5,y=1,width=10,height=20})
local south=resolve("FR_ROUTE_2",{x=5,y=19,width=10,height=20})
s.areas[north]={spent=true}
assert(Splits.catchAllowed(s,Core,south,"FR_ROUTE_2"),
    "split route's other half is a separate slot")
assert(not Splits.catchAllowed(s,Core,north,"FR_ROUTE_2"))
set("route_2_split",false)
assert(not Splits.catchAllowed(s,Core,resolve("FR_ROUTE_2"),"FR_ROUTE_2"),
    "turning off route split must not re-arm the entire route")
set("route_2_split",true)
s.areas.FR_ROUTE_2={spent=true}
assert(not Splits.catchAllowed(s,Core,south,"FR_ROUTE_2"),
    "an old whole-route claim must block both newly split sides")
-- Master off restores raw map IDs and disables enforcement.
assert(Core.set(s,"nuzlocke_enabled",false))
assert(resolve("FR_MT_MOON_B1F")=="FR_MT_MOON_B1F")
assert(Splits.catchAllowed(s,Core,north,"FR_ROUTE_2"))
assert(not Splits.safariUntilCatch(s,Core,"FR_SAFARI_ZONE_EAST"))
local persisted={areaSplitRules=s.areaSplitRules}
assert(Splits.get(persisted,"area_scope")==0
    and Splits.get(persisted,"route_2_split"))
s.failed=true
assert(not Splits.set(s,"area_scope",2))
local f=assert(io.open("gen3_runtime.lua","rb"))
local runtime=f:read("*a");f:close()
for _,token in ipairs({
    'readModule("gen3_area_splits.lua")',
    'AreaSplits.resolve(saved or loadState(),Core,mapId',
    'AreaSplits.catchAllowed(s,Core,key,rawArea)',
    'AreaSplits.safariUntilCatch(s,Core,rawArea)',
    'AreaSplits.safariUntilCatch(s,Core,areaNow())',
    'mod.exports.gen3_area_splits',
    'local rawArea=areaNow()',
}) do
    assert(runtime:find(token,1,true),"missing area native seam: "..token)
end
print("Gen3 Area Splits: routes, Safari, Kanto/Sevii/Hoenn cave floors: PASS")
