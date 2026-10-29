-- Gen 3 Pokémon Stats: saved rules, legal EV/IV conversions,
-- immutable foe templates, ownership and native guard wiring.
local Stats=assert(loadfile("gen3_pokemon_stats.lua"))()()
local Core=assert(loadfile("gen3_core_rules.lua"))()()
local s=Core.normalise({})
local keys={"player_start_stat_exp","wild_start_stat_exp",
    "trainer_start_stat_exp","no_player_stat_exp_gain",
    "perfect_player_ivs","perfect_wild_ivs","perfect_trainer_ivs"}
local six={"hp","atk","def","spe","spa","spd"}
assert(#Stats.descriptors()==7)
for _,key in ipairs(keys) do
    assert(Stats.get(s,key)~=nil and Stats.label(s,key))
end
for _,key in ipairs({"player_start_stat_exp","wild_start_stat_exp",
    "trainer_start_stat_exp"}) do
    assert(Stats.get(s,key)==0)
    assert(Stats.label(s,key)=="0 EV/STAT")
    assert(not Stats.set(s,key,-1))
    assert(not Stats.set(s,key,6))
    assert(not Stats.set(s,key,2.5))
    assert(not Stats.set(s,key,"2"))
    assert(Stats.next(s,key)==1)
end
for _,key in ipairs({"no_player_stat_exp_gain",
    "perfect_player_ivs","perfect_wild_ivs","perfect_trainer_ivs"}) do
    assert(Stats.get(s,key)==false)
    assert(not Stats.set(s,key,1))
    assert(Stats.next(s,key)==true)
end
local function total(evs)
    local sum=0
    for _,k in ipairs(six) do sum=sum+evs[k] end
    return sum
end
local pokemon={
    applyStats=function(mon)
        mon.maxHp=40+(mon.ivs and mon.ivs.hp or 0)
            +math.floor(((mon.evs and mon.evs.hp) or 0)/4)
        mon.hp=mon.hp or mon.maxHp
        mon.attack=10+((mon.ivs and mon.ivs.atk) or 0)
    end,
}
local fresh={species=25,level=8,hp=0,maxHp=40,
    ivs={hp=5,atk=6,def=7,spe=8,spa=9,spd=10},
    evs={hp=1,atk=2,def=3,spe=4,spa=5,spd=6}}
assert(Stats.player(s,Core,fresh,pokemon)==false)
assert(fresh.ivs.hp==5 and fresh.evs.atk==2)
assert(Core.set(s,"nuzlocke_enabled",true))
for preset=1,5 do
    assert(Stats.set(s,"wild_start_stat_exp",preset))
    local base={species=25,hp=4,maxHp=40,attack=32,
        ivs={hp=5,atk=6,def=7,spe=8,spa=9,spd=10},
        evs={hp=1,atk=2,def=3,spe=4,spa=5,spd=6}}
    local foe=Stats.foe(s,Core,"wild",base,pokemon)
    assert(foe~=base and foe.evs~=base.evs)
    local amount=Stats.presetAmount(preset)
    for _,k in ipairs(six) do assert(foe.evs[k]==amount) end
    assert(total(foe.evs)<=510)
    assert(base.ivs.hp==5 and base.evs.hp==1,
        "native encounter input must not be mutated")
    assert(foe.hp==4 and foe.maxHp==nil and foe.attack==nil,
        "native generator must calculate stats after personality assignment")
end
assert(Stats.presetAmount(5)==85)
assert(Stats.set(s,"perfect_wild_ivs",true))
local wild=Stats.foe(s,Core,"wild",{species=1,ivs={hp=6}},pokemon)
for _,k in ipairs(six) do assert(wild.ivs[k]==31) end
assert(Stats.set(s,"trainer_start_stat_exp",4))
assert(Stats.set(s,"perfect_trainer_ivs",true))
local trainer=Stats.foe(s,Core,"trainer",
    {species=4,level=12,ivs={hp=0}},pokemon)
assert(total(trainer.evs)==384)
for _,k in ipairs(six) do assert(trainer.ivs[k]==31) end
assert(Stats.foe(s,Core,"link",trainer,pokemon)==trainer)
assert(Stats.set(s,"player_start_stat_exp",5))
assert(Stats.set(s,"perfect_player_ivs",true))
assert(Stats.player(s,Core,fresh,pokemon))
for _,k in ipairs(six) do
    assert(fresh.ivs[k]==31 and fresh.evs[k]==85)
end
assert(total(fresh.evs)==510 and fresh.hp==0,
    "fainted Pokémon must remain fainted")
local native={party={fresh,{species=1}}}
assert(not Stats.playerMon(s,Core,native,fresh),
    "no EV gain must default OFF")
assert(Stats.set(s,"no_player_stat_exp_gain",true))
assert(Stats.noGain(s,Core))
assert(Stats.playerMon(s,Core,native,fresh))
assert(not Stats.playerMon(s,Core,native,{}))
local copied={enabled=s.enabled,rules=s.rules,statRules=s.statRules}
assert(Stats.get(copied,"player_start_stat_exp")==5
    and Stats.get(copied,"perfect_wild_ivs"))
assert(Core.set(s,"nuzlocke_enabled",false))
assert(not Stats.noGain(s,Core))
assert(Stats.foe(s,Core,"trainer",trainer,pokemon)==trainer)
local old=fresh.ivs.hp
assert(not Stats.player(s,Core,fresh,pokemon) and fresh.ivs.hp==old)
s.failed=true
assert(not Stats.set(s,"perfect_wild_ivs",false))
local bad={statRules={player_start_stat_exp=99,
    perfect_player_ivs="on",no_player_stat_exp_gain="yes"}}
assert(Stats.get(bad,"player_start_stat_exp")==0)
assert(not Stats.get(bad,"perfect_player_ivs"))
assert(not Stats.get(bad,"no_player_stat_exp_gain"))

local f=assert(io.open("gen3_runtime.lua","rb"))
local runtime=f:read("*a");f:close()
for _,token in ipairs({
    'readModule("gen3_pokemon_stats.lua")',
    'Stats.player(loadState(),Core,ev.mon,Pokemon)',
    'Stats.player(loadState(),Core,mon,Pokemon)',
    'Stats.player(loadState(),Core,received,Pokemon)',
    'Stats.foe(saved,Core,source,v,Pokemon)',
    'guardGrowth("gainEVs")',
    'guardGrowth("raiseEvFromItem")',
    'Battle.start=guardedStart',
    'Party.giveMon=guardedGive',
    'Trade.tradeMons=guardedTrade',
    'installStatGuards()',
}) do
    assert(runtime:find(token,1,true),"missing Gen3 stat seam "..token)
end
print("Gen3 Pokémon Stats: 7 rules, legal EVs/31 IVs, generation/ownership: PASS")
