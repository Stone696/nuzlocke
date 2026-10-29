-- Gen3 Game Difficulty policy: stable profiles, trainer-native stat and AI seams.
local D=assert(loadfile("gen3_difficulty.lua"))()()
local Core=assert(loadfile("gen3_core_rules.lua"))()()
local s=Core.normalise({})
assert(#D.descriptors()==1)
assert(D.get(s,"difficulty_profile")==0)
assert(D.label(s,"difficulty_profile")=="VANILLA")
assert(not D.active(s))
assert(not D.set(s,"difficulty_profile",-1))
assert(not D.set(s,"difficulty_profile",16))
assert(not D.set(s,"difficulty_profile",1.5))
assert(not D.set(s,"difficulty_profile","1"))
assert(not D.set(s,"unknown",true))
assert(D.next(s,"difficulty_profile")==1)
local names={}
for i=0,15 do
    assert(D.set(s,"difficulty_profile",i))
    local profile=D.profile(s)
    assert(profile.id==i and profile.name and profile.name~="")
    assert(not names[profile.name],"profile labels must be distinct")
    names[profile.name]=true
    assert(profile.iv<=31 and profile.iv>=0
        and profile.ev<=85 and profile.ev>=0)
    assert(profile.ai>=0 and profile.ai<=4)
    assert(D.get(s,"difficulty_profile")==i)
    assert(D.next(s,"difficulty_profile")==((i+1)%16))
end
assert(D.set(s,"difficulty_profile",0))
local party={
    {species=1,level=5,ivs={hp=0,atk=10,def=20,spe=25,spa=1,spd=30},
        evs={hp=2,atk=1,def=5,spe=0,spa=9,spd=12},moves={1,2}},
    {species=4,level=99,ivs={hp=31,atk=31,def=31,spe=31,spa=31,spd=31},
        evs={hp=0,atk=0,def=0,spe=0,spa=0,spd=0},moves={3,4}},
}
local foe={trainerId=99,trainerClass=84,trainerClassName="LEADER",
    species=1,level=5,aiFlags=3,party=party,
    nativeNpcTrainer=true,items={1,0,0,0}}
local opts={trainerId=99,foe=foe,wild=false}
local native={version="firered",party={{species=1}}}
local providers={get=function()return {aiFlags=3,className="LEADER"} end}
assert(D.prepare(s,opts,native,providers)==opts)
assert(D.set(s,"difficulty_profile",2))
local out=D.prepare(s,opts,native,providers)
assert(out~=opts and out.foe~=foe and out.foe.party~=party)
assert(out.foe.party[1]~=party[1]
    and out.foe.party[1].ivs~=party[1].ivs
    and out.foe.party[1].evs~=party[1].evs)
assert(out.foe.party[1].species==party[1].species
    and out.foe.party[1].level==9
    and out.foe.party[2].level==100)
assert(out.foe.party[1].ivs.hp==16
    and out.foe.party[1].ivs.atk==16
    and out.foe.party[1].ivs.def==20
    and out.foe.party[1].ivs.spe==25
    and out.foe.party[1].ivs.spd==30)
assert(out.foe.party[1].evs.hp==32
    and out.foe.party[1].evs.atk==32
    and out.foe.party[1].evs.spd==32)
assert(out.foe.party[1].attack==nil
    and out.foe.party[1].maxHp==nil)
assert(out.foe.party[1].moves==party[1].moves
    and out.foe.party[1].species==1)
assert(out.foe.party[2].ivs.hp==31)
assert(party[1].ivs.hp==0 and party[1].level==5
    and party[1].evs.hp==2
    and party[2].level==99,
    "original ROM/provider roster must remain immutable")
assert(foe.aiFlags==3 and opts.aiFlags==nil)
assert(out.aiFlags~=nil)
assert(out.foe.level==out.foe.party[1].level)
assert(out.foe.party[1].nativeNpcTrainer==nil
    or out.foe.party[1].nativeNpcTrainer==party[1].nativeNpcTrainer)
assert(D.prepare(s,{wild=true,foe=foe},native,providers).wild==true)
for _,key in ipairs({"wild","link","recordedLink","battleTower",
    "trainerHill","secretBase","firstBattle","twoOpponents",
    "pyramid","frontier","eReader"}) do
    local o={foe=foe}
    o[key]=true
    assert(D.prepare(s,o,native,providers)==o,
        key.." must not alter specialised battles")
end
local ext={foe=foe,externalDifficulty="other_mod"}
assert(D.prepare(s,ext,native,providers)==ext)
local byFoe={foe={species=1,difficultyProvider="external"}}
assert(D.prepare(s,byFoe,native,providers)==byFoe)
assert(D.set(s,"difficulty_profile",6))
assert(D.prepare(s,{foe={trainerClassName="YOUNGSTER",
    party={{species=1,level=5}}}},native,providers).foe.party[1].level==5,
    "boss-only mode must leave normal trainers unchanged")
assert(D.set(s,"difficulty_profile",7))
assert(D.prepare(s,opts,native,providers).foe.party[1].level==12)
assert(D.isBoss({trainerClassName="CHAMPION"},{},nil))
assert(D.isBoss({trainerClassName="TRAINER_CLASS_RIVAL"},{},nil))
assert(D.isBoss({trainerClassName="TRAINER_CLASS_LEADER"},{},nil))
assert(not D.isBoss({trainerClassName="BUG_CATCHER"},{},nil))
assert(not D.isBoss({trainerClassName="TEAM_AQUA"},{},nil))
assert(D.family({version="emerald"})=="emerald")
assert(D.family({version="ruby"})=="rs")
assert(D.family({version="sapphire"})=="rs")
assert(D.family({version="leafgreen"})=="frlg")
assert(D.family({version="unknown"})==nil)
assert(D.aiMask({version="unknown"},4)==0)
assert(D.aiMask({version="firered"},2)==7)
assert(D.aiMask({version="emerald"},2)==7)
assert(D.aiMask({version="emerald"},3)==39)
assert(D.aiMask({version="emerald"},4)==303)
local a=D.aiMask({version="emerald"},4)
assert(a>0)
assert(D.set(s,"difficulty_profile",15))
local master=D.prepare(s,opts,{version="emerald"},providers)
assert(master.foe.party[1].level==15)
assert(master.foe.party[1].ivs.hp==31)
assert(master.foe.party[1].evs.hp==85)
local evTotal=0
for _,key in ipairs({"hp","atk","def","spe","spa","spd"}) do
    evTotal=evTotal+master.foe.party[1].evs[key]
end
assert(evTotal==510,"max profile must stay within legal Gen3 510-EV cap")
assert(Core.active(s)==false,"difficulty must be independent of Nuz ON")
assert(D.active(s),"difficulty must still be selectable with master OFF")
assert(D.prepare(s,opts,native,providers)~=opts)
local saved={difficultyRules=s.difficultyRules}
assert(D.get(saved,"difficulty_profile")==15)
assert(D.label(saved,"difficulty_profile")=="FULL MASTER")
local corrupted={difficultyRules={difficulty_profile=99}}
assert(D.get(corrupted,"difficulty_profile")==0)
s.failed=true
assert(not D.set(s,"difficulty_profile",1))
local f=assert(io.open("gen3_runtime.lua","rb"))
local runtime=f:read("*a");f:close()
for _,token in ipairs({
    'readModule("gen3_difficulty.lua")',
    'Difficulty.prepare(saved,opts,session(),',
    'if not Core.active(saved) then',
    'Stats.foe(saved,Core,source,v,Pokemon)',
    'RunParty.gymDenial(saved,Core,',
    'mod.exports.gen3_game_difficulty',
    'gameDifficulty = Difficulty',
}) do
    assert(runtime:find(token,1,true),"missing native difficulty seam: "..token)
end
print("Gen3 Game Difficulty: 16 profiles, native AI/EV/IV, level caps, provider safety: PASS")
