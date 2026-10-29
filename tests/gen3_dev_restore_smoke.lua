-- Isolated Gen 3 NUZ DEV restoration: no ROM or game engine needed.
local Archive=assert(loadfile("gen3_archive.lua"))()()
local state={areas={},graveyard={},enabled=true,failed=false}
local session={party={{species=1,personality=100,hp=20}},
    storage={boxes={{mons={}}}}}
local inBattle=false
local Dev=assert(loadfile("gen3_dev.lua"))()({
    archive=Archive,
    getState=function()return state end,
    setState=function(next)state=next end,
    getCurrentArea=function()return "FR_ROUTE_1" end,
    getSession=function()return session end,
    inBattle=function()return inBattle end,
    areaSpent=function(v)return v and v.spent end,
})
local function burial(species,pid,maxHp,shiny)
    local mon={species=species,personality=pid,level=24,
        maxHp=maxHp,hp=0,otId=50,isShiny=shiny,
        nickname="Fallen",ivs={attack=31},moves={8,40,98},
        nuzlockeDead=true,nuzlockeDeathRecorded=true}
    local archive,complete=Archive.snapshot(mon)
    assert(complete)
    return {species=species,personality=pid,archive=archive,
        archiveComplete=true,nickname="Fallen"}
end
state.graveyard={burial(25,200,70,true)}
assert(#Dev.restoreCandidates()==1)
local ok,reason=Dev.restorePokemon(1)
assert(not ok and reason=="dev_disabled")
assert(Dev.enable())
assert(state.dev.enabled and state.dev.tainted)
assert(Dev.restorePokemon(1))
assert(#session.party==2 and #state.graveyard==0
    and session.party[2].hp==35
    and session.party[2].isShiny==true
    and session.party[2].ivs.attack==31
    and session.party[2].nuzlockeDead==nil
    and state.dev.edits==2,
    "complete archives restore to party once and remain audited")
session.party[2].ivs.attack=5
assert(session.party[2].ivs.attack~=31,
    "restored mon is independent of any graveyard snapshot")
state.graveyard={burial(25,200,70,true)}
ok,reason=Dev.restorePokemon(1)
assert(not ok and reason=="already_present"
    and #state.graveyard==1 and #session.party==2,
    "a matching active mon must prevent duplication")
state.graveyard={burial(7,700,61,false)}
session.party={
 {species=1,personality=101,hp=20},
 {species=2,personality=102,hp=20},
 {species=3,personality=103,hp=20},
 {species=4,personality=104,hp=20},
 {species=5,personality=105,hp=20},
 {species=6,personality=106,hp=20},
}
ok,reason=Dev.restorePokemon(1)
assert(ok and reason=="pc"
    and #session.party==6
    and session.storage.boxes[1].mons[1].personality==700
    and session.storage.boxes[1].mons[1].hp==30
    and #state.graveyard==0,
    "full party restores to a verified existing PC slot")
state.graveyard={burial(7,700,61,false)}
ok,reason=Dev.restorePokemon(1)
assert(not ok and reason=="already_present",
    "duplicates in storage must also be refused")
state.graveyard={burial(8,800,66,false)}
session.storage.boxes[1].mons={}
for i=1,30 do
    session.storage.boxes[1].mons[i]={species=12,personality=1000+i}
end
ok,reason=Dev.restorePokemon(1)
assert(not ok and reason=="no_space" and #state.graveyard==1)
session.party={{species=1,personality=101,hp=20}}
session.storage=nil
ok,reason=Dev.restorePokemon(1)
assert(not ok and reason=="pc_unavailable",
    "unknown PC state must fail closed rather than risking duplication")
session.storage={boxes={{mons={}}}}
state.graveyard={{species=16,personality=999,archiveComplete=false}}
assert(#Dev.restoreCandidates()==0)
ok,reason=Dev.restorePokemon(1)
assert(not ok and reason=="archive_incomplete",
    "legacy species-level memorial cannot become a manufactured Pokemon")
state.graveyard={burial(8,800,66,false)}
inBattle=true
ok,reason=Dev.restorePokemon(1)
assert(not ok and reason=="battle_active"
    and #session.party==1 and #state.graveyard==1)
inBattle=false
state.failed=true
ok,reason=Dev.restorePokemon(1)
assert(not ok and reason=="run_ended"
    and #state.graveyard==1,
    "dev resurrection cannot bypass irreversible Nuzlocke loss")
state.failed=false
state.finalResult={outcome="FORFEIT"}
ok,reason=Dev.restorePokemon(1)
assert(not ok and reason=="run_ended")
assert(state.dev.tainted)
print("Gen3 Nuz Dev archive restore safety: PASS")
