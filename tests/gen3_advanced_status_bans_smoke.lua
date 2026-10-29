-- Status Bans: parent synchronisation, source scope, aliases and saves.
local B=assert(loadfile("gen3_status_bans.lua"))()()
local Core=assert(loadfile("gen3_core_rules.lua"))()()
local s=Core.normalise({})
assert(#B.descriptors()==8)
assert(B.get(s,"status_move_scope")==0)
assert(B.get(s,"status_sleep_scope")==0)
assert(B.get(s,"sleep_clause")==false)
assert(B.label(s,"sleep_clause")=="OFF")
assert(B.next(s,"sleep_clause")==true)
assert(not B.childrenHidden(s))
assert(not B.deny(s,"BURN","enemy",nil,Core))
assert(Core.set(s,"nuzlocke_enabled",true))
assert(B.set(s,"status_move_scope",1))
assert(B.set(s,"sleep_clause",true),
    "Sleep Clause must remain editable with the parent active")
assert(B.get(s,"sleep_clause") and B.label(s,"sleep_clause")=="ON")
assert(not B.set(s,"sleep_clause",1),
    "Sleep Clause requires a boolean, not a source scope")
assert(B.childrenHidden(s))
for _,key in ipairs(B.childKeys()) do
    assert(B.get(s,key)==1 and B.label(s,key)=="SELF")
    assert(not B.set(s,key,3),
        "parent must own child scopes when active")
end
assert(B.deny(s,"PARALYSIS","player",nil,Core))
assert(B.deny(s,"CONFUSION",{side="player"},nil,Core))
assert(B.deny(s,"TOXIC","player",nil,Core))
assert(B.deny(s,"FREEZE","player",nil,Core))
assert(not B.deny(s,"FREEZE","enemy",nil,Core))
assert(not B.deny(s,"FLINCH","player",nil,Core),
    "No Status Moves parent is NOT an all-non-damaging-moves ban")
local ownMon,other={side="player"},{side="enemy"}
assert(not B.deny(s,"SLEEP",ownMon,ownMon,Core),
    "self-induced Rest sleep is always allowed")
assert(B.deny(s,"SLEEP",ownMon,other,Core))
assert(B.set(s,"status_move_scope",2))
assert(B.deny(s,"PSN","enemy",nil,Core))
assert(not B.deny(s,"PSN","player",nil,Core))
assert(B.set(s,"status_move_scope",3))
assert(B.deny(s,"BRN","enemy",nil,Core)
    and B.deny(s,"BRN","player",nil,Core))
assert(B.next(s,"status_move_scope")==0)
assert(B.set(s,"status_move_scope",0))
assert(not B.childrenHidden(s))
for _,key in ipairs(B.childKeys()) do assert(B.get(s,key)==0) end
assert(B.set(s,"status_sleep_scope",1))
assert(B.set(s,"status_poison_scope",2))
assert(B.set(s,"status_paralysis_scope",3))
assert(B.deny(s,"SLEEP","player",other,Core))
assert(not B.deny(s,"SLEEP","enemy",other,Core))
assert(B.deny(s,"TOX","enemy",nil,Core))
assert(not B.deny(s,"TOX","player",nil,Core))
assert(B.deny(s,"PAR","enemy",nil,Core)
    and B.deny(s,"PAR","player",nil,Core))
assert(not B.deny(s,"FRZ","player",nil,Core))
assert(not B.deny(s,"PAR",nil,nil,Core),
    "unknown source must never be guessed")
-- Battle-local origin tracking: the asleep party member counts even when
-- switched out, while Rest and pre-existing unknown sleep do not.
local player={side="player",partyIndex=1}
local foe1={side="enemy",partyIndex=1}
local foe2={side="enemy",partyIndex=2}
local foe3={side="enemy",partyIndex=3}
local battle={
    playerParty={{status=nil,hp=20},{status=nil,hp=20}},
    foeParty={{status="SLP",hp=20},{status=nil,hp=20},
              {status=nil,hp=20}},
}
assert(not B.denySleepClause(s,player,foe2,battle,Core),
    "sleep existing before this battle has unknown origin")
B.recordSleep(battle,foe1,player)
assert(B.denySleepClause(s,player,foe2,battle,Core))
assert(B.denySleepClause(s,player,foe3,battle,Core),
    "a switched-out sleeper must still count")
assert(not B.denySleepClause(s,foe1,foe2,battle,Core),
    "sleep clause restricts only opposing-side infliction")
assert(not B.denySleepClause(s,player,player,battle,Core),
    "Rest is always exempt")
battle.foeParty[1].status=nil
assert(not B.denySleepClause(s,player,foe2,battle,Core),
    "waking or curing frees the sleep slot")
battle.foeParty[1].status="SLP"
battle.foeParty[1].hp=0
assert(not B.denySleepClause(s,player,foe2,battle,Core),
    "fainted party members do not hold a sleep slot")
battle.foeParty[1].hp=20
local p1={side="player",partyIndex=1}
local p2={side="player",partyIndex=2}
local enemy={side="enemy",partyIndex=1}
battle.playerParty[1].status="SLP"
B.recordSleep(battle,p1,p1)
assert(not B.denySleepClause(s,enemy,p2,battle,Core),
    "self-induced Rest sleep must not count")
B.recordSleep(battle,p1,enemy)
assert(B.denySleepClause(s,enemy,p2,battle,Core),
    "each side independently limits sleep it inflicts")
assert(not B.denySleepClause(s,nil,p2,battle,Core))
assert(B.set(s,"sleep_clause",false))
assert(not B.denySleepClause(s,player,foe2,battle,Core))
assert(B.set(s,"sleep_clause",true))
assert(not B.set(s,"status_move_scope",4))
assert(not B.set(s,"status_move_scope",-1))
assert(not B.set(s,"status_move_scope",1.5))
assert(not B.set(s,"status_move_scope",true))
local saved={statusBans=s.statusBans}
assert(B.get(saved,"status_sleep_scope")==1
    and B.get(saved,"status_poison_scope")==2
    and B.get(saved,"sleep_clause")==true)
assert(Core.set(s,"nuzlocke_enabled",false))
assert(not B.denySleepClause(s,player,foe2,battle,Core))
assert(not B.deny(s,"SLEEP","player",other,Core))
assert(Core.set(s,"nuzlocke_enabled",true))
s.failed=true
assert(not B.set(s,"status_move_scope",3))
assert(not B.set(s,"sleep_clause",false))
assert(not B.denySleepClause(s,player,foe2,battle,Core))
assert(not B.deny(s,"PAR","player",nil,Core))
print("Gen3 Status Bans policy parent/child/scope/save regression: PASS")
