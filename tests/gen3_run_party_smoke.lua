-- Gen 3 Run / Party: gym team cap, active-party cap and evolutions.
local Policy=assert(loadfile("gen3_run_party.lua"))()()
local Core=assert(loadfile("gen3_core_rules.lua"))()()
local s=Core.normalise({})
assert(#Policy.descriptors()==3)
assert(not Policy.get(s,"gym_team_size"))
assert(Policy.get(s,"party_size_limit")==6)
assert(Policy.get(s,"evolution_limit")==0)
assert(Policy.label(s,"gym_team_size")=="OFF")
assert(Policy.label(s,"party_size_limit")=="6/6")
assert(Policy.label(s,"evolution_limit")=="NORMAL")
assert(not Policy.set(s,"gym_team_size",1))
assert(not Policy.set(s,"party_size_limit",0))
assert(not Policy.set(s,"party_size_limit",7))
assert(not Policy.set(s,"party_size_limit",2.3))
assert(not Policy.set(s,"evolution_limit",3))
assert(not Policy.set(s,"evolution_limit","1"))
assert(not Policy.set(s,"unknown",true))
local function native(n,version)
    local party={}
    for i=1,n do party[i]={species=i} end
    return {party=party,version=version or "firered"}
end
local player=native(4)
assert(Policy.partyCap(s,Core)==6)
assert(Policy.addDenied(s,Core,player)==nil)
assert(Core.set(s,"nuzlocke_enabled",true))
assert(Policy.set(s,"party_size_limit",3))
assert(Policy.partyCap(s,Core)==3)
assert(Policy.addDenied(s,Core,player):find("4/3",1,true))
assert(Policy.addDenied(s,Core,native(2))==nil)
assert(Policy.get(s,"party_size_limit")==3)
for _,v in ipairs({4,5,6,1,2,3}) do
    assert(Policy.next(s,"party_size_limit")==v)
    assert(Policy.set(s,"party_size_limit",v))
end
assert(Policy.set(s,"party_size_limit",6))
assert(Policy.addDenied(s,Core,native(6))==nil,
    "native full-party catch/gift may go directly to PC")
assert(Policy.set(s,"party_size_limit",1))
assert(Policy.addDenied(s,Core,native(1)))
assert(not Policy.addDenied(s,Core,native(0)))
assert(Policy.partyCount(native(4))==4)
assert(Policy.partyCount(nil)==nil)

assert(Policy.set(s,"gym_team_size",true))
assert(Policy.next(s,"gym_team_size")==false)
assert(Policy.label(s,"gym_team_size")=="ON")
local leader={trainerId=123,trainerClass=84,
    party={{species=1},{species=2},{species=3}}}
local opts={trainerId=123}
local trainers={get=function(id)
    assert(id==123)
    return {class=84,className="LEADER"}
end}
assert(Policy.isGymLeader(player,leader,opts,trainers))
assert(Policy.gymDenial(s,Core,player,leader,opts,trainers)
    :find("has 4 Pokemon; this Leader has 3",1,true))
assert(not Policy.gymDenial(s,Core,native(2),leader,opts,trainers))
assert(not Policy.gymDenial(s,Core,player,leader,
    {wild=true,trainerId=123},trainers))
assert(not Policy.gymDenial(s,Core,player,leader,
    {link=true,trainerId=123},trainers))
assert(not Policy.gymDenial(s,Core,player,leader,
    {battleTower=true,trainerId=123},trainers))
assert(not Policy.gymDenial(s,Core,player,leader,
    {twoOpponents=true,trainerId=123},trainers))
assert(not Policy.isGymLeader(native(4,"firered"),
    {trainerClass=83,trainerClassName="BOSS"}, {},nil))
assert(not Policy.isGymLeader(native(4,"emerald"),
    {trainerClass=13,trainerClassName="AQUA LEADER"}, {},nil))
assert(not Policy.isGymLeader(native(4,"ruby"),
    {trainerClass=2,trainerClassName="AQUA LEADER"}, {},nil))
local d=Policy.gymDenial(s,Core,native(4,"emerald"),
    {trainerClass=32,party={{},{}}}, {},nil)
assert(d and d:find("has 2",1,true),
    "Emerald numeric gym class must be edition-specific")
assert(Policy.isGymLeader(native(4,"ruby"),{trainerClass=25,party={{}}},{},nil))
assert(not Policy.isGymLeader(native(4,"ruby"),{trainerClass=32,party={{}}},{},nil))
assert(Policy.isGymLeader(native(4,"firered"),{
    trainerClassName="TRAINER_CLASS_LEADER",party={{}}
},{},nil))
assert(not Policy.isGymLeader(native(4,"firered"),{
    trainerClassName="TRAINER_CLASS_MAGMA_LEADER",party={{}}
},{},nil))
-- Provider-adjusted party must be the counted live party, not
-- Trainers.get(...).partySize or an earlier authored roster.
local composed={trainerClass=84,party={{},{}},trainerId=123}
assert(Policy.gymDenial(s,Core,native(3),composed,
    {trainerId=123},trainers):find("has 2",1,true))
assert(not Policy.gymDenial(s,Core,native(3),composed,
    {trainerId=123,foeParty={{},{},{},{}}},trainers))
assert(not Policy.gymDenial(s,Core,native(4),
    {trainerClass=84,party={}}, {},nil),
    "missing roster must fail open rather than invent a leader team")

local mock={
    stats=function(id)
        if id==1 or id==2 or id==3 then return {hp=40} end
        return nil
    end,
    evolutions=function(id)
        if id==2 then return {{method=4,param=16,target=3}} end
        if id==3 then return {} end
        if id==1 then return {{4,16,2}} end
        return {}
    end
}
assert(not Policy.evoDenied(s,Core,{},3,mock))
assert(Policy.set(s,"evolution_limit",1))
assert(Policy.label(s,"evolution_limit")=="NO FINAL")
assert(not Policy.evoDenied(s,Core,{},2,mock),
    "midstage target retains a known evolution")
assert(Policy.evoDenied(s,Core,{},3,mock),
    "terminal target must be denied")
assert(not Policy.evoDenied(s,Core,{},999,mock),
    "unindexed modded species must fail open")
assert(not Policy.evoDenied(s,Core,{},0,mock))
assert(not Policy.evoDenied(s,Core,{},nil,mock))
assert(not Policy.evoDenied(s,Core,{},3,nil))
local broken={
    stats=function(id) return {hp=1} end,
    evolutions=function(id) return {{method=4,target=999}} end
}
assert(not Policy.evoDenied(s,Core,{},2,{
    stats=function(id) return id==2 and {} or nil end,
    evolutions=broken.evolutions
}), "incomplete next-species metadata must fail open")
assert(Policy.set(s,"evolution_limit",2))
assert(Policy.label(s,"evolution_limit")=="NO EVOLUTION")
assert(Policy.evoDenied(s,Core,{},2,mock))
assert(Policy.evoDenied(s,Core,{},999,mock))
assert(not Policy.evoDenied(s,Core,{},0,mock))
local persisted={runPartyRules=s.runPartyRules}
assert(Policy.get(persisted,"party_size_limit")==1
    and Policy.get(persisted,"gym_team_size")==true
    and Policy.get(persisted,"evolution_limit")==2)
assert(Core.set(s,"nuzlocke_enabled",false))
assert(Policy.partyCap(s,Core)==6)
assert(not Policy.addDenied(s,Core,native(4)))
assert(not Policy.gymDenial(s,Core,player,leader,opts,trainers))
assert(not Policy.evoDenied(s,Core,{},3,mock))
s.failed=true
assert(not Policy.set(s,"gym_team_size",false))
local corrupted={runPartyRules={gym_team_size=2,party_size_limit=9,
    evolution_limit="2"}}
assert(Policy.get(corrupted,"gym_team_size")==false)
assert(Policy.get(corrupted,"party_size_limit")==6)
assert(Policy.get(corrupted,"evolution_limit")==0)

local f=assert(io.open("gen3_runtime.lua","rb"))
local runtime=f:read("*a");f:close()
for _,token in ipairs({
    'readModule("gen3_run_party.lua")',
    'installRunPartyGuards()',
    'RunParty.addDenied(s,Core,session())',
    'RunParty.gymDenial(saved,Core',
    'RunParty.evoDenied(loadState(),Core',
    'Battle.start=guardedStart',
    'Evolution.targetSpecies=guardedTarget',
    'Party.__nuzStatsGive=guardedGive',
    'Battle.__nuzStatsStart=guardedStart',
    'Evolution.apply=guardedApply',
    'Party.giveMon=guardedGive',
    'Catching.storeCaught=guardedStore',
    'wrap("withdraw",function() return true end)',
    'wrap("moveMon",function(native',
    'wrap("placeHeldMon",function(native',
    'mod.exports.gen3_run_party',
    'PARTY_LIMIT_SHEDINJA',
}) do
    assert(runtime:find(token,1,true),"missing Run/Party seam "..token)
end
assert(not runtime:find('Party.__nuzRunGive=',1,true),
    "do not layer competing gift wrappers over Stats")
assert(not runtime:find('Battle.__nuzRunStart=',1,true),
    "do not layer competing battle wrappers over Stats")
print("Gen3 Run/Party: gym composed cap, party PC/acquisition limit and evolutions PASS")
