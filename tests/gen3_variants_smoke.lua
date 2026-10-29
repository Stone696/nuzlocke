-- Gen 3 Type Locke: canonical GBA types, selected lanes and save policy.
local V=assert(loadfile("gen3_variants.lua"))()()
local Core=assert(loadfile("gen3_core_rules.lua"))()()
local s=Core.normalise({})
local P={
    speciesFromNational=function(n)
        return n<=6 and n or nil
    end,
    keyName=function(id)
        return ({[1]="CHARMANDER",[2]="SQUIRTLE",
            [3]="BULBASAUR",[4]="PIDGEY",
            [5]="GASTLY",[6]="MAGNEMITE",
            [7]="PROVIDER"})[id]
    end,
    speciesFromName=function(name)
        return ({CHARMANDER=1,SQUIRTLE=2,BULBASAUR=3,
            PIDGEY=4,GASTLY=5,MAGNEMITE=6,PROVIDER=7})[name]
    end,
    types=function(id)
        return ({
            [1]={10,10}, -- FIRE
            [2]={11,11}, -- WATER
            [3]={12,3},  -- GRASS / POISON
            [4]={0,2},   -- NORMAL / FLYING
            [5]={7,3},   -- GHOST / POISON
            [6]={13,8},  -- ELECTRIC / STEEL
            [7]={14,9},  -- custom PSYCHIC / MYSTERY
        })[id] or {0,0}
    end,
}
local function check(id,seed) return V.check(s,id,P,Core,seed or "trainer:1") end
assert(#V.descriptors()==8)
assert(V.get(s,"type_lock_draft")==false)
assert(V.label(s,"type_lock_draft")=="OFF")
assert(V.get(s,"type_lock_mode")==0)
assert(V.get(s,"type_lock_primary")==0)
assert(V.label(s,"type_lock_mode")=="OFF")
assert(V.label(s,"type_lock_primary")=="RANDOM")
assert(not V.set(s,"type_lock_mode",7))
assert(not V.set(s,"type_lock_primary",18))
assert(not V.set(s,"type_lock_draft",3))
assert(not V.set(s,"wonderlocke",true),
    "removed Wonderlocke key must remain unsupported in old saves")
assert(V.next(s,"type_lock_mode")==1)
assert(V.next(s,"type_lock_primary")==1)
assert(Core.set(s,"nuzlocke_enabled",true), "Type Locke only enforces when the master is ON")
assert(V.set(s,"type_lock_mode",1))
assert(V.set(s,"type_lock_primary",10)) -- GBA FIRE
assert(V.label(s,"type_lock_mode")=="MONO")
assert(V.label(s,"type_lock_primary")=="FIRE")
assert(check(1),"same type admitted")
assert(not check(2),"WATER is illegal in Mono FIRE")
assert(not check(3),"GRASS/POISON is illegal in Mono FIRE")
local accepted,why=check("SQUIRTLE")
assert(not accepted and why:find("Type Locke",1,true))
assert(V.set(s,"type_lock_mode",2))
assert(V.label(s,"type_lock_mode")=="DUO")
assert(V.set(s,"type_lock_secondary",11)) -- GBA WATER
assert(check(1) and check(2),"either configured lane qualifies")
assert(not check(4),"NORMAL/FLYING still fails")
assert(V.set(s,"type_lock_secondary",4)) -- POISON
assert(check(3),"dual typed GRASS/POISON matches secondary POISON")
assert(check(5),"GHOST/POISON also matches")
assert(V.set(s,"type_lock_secondary",11))
assert(V.set(s,"type_lock_mode",6))
assert(V.label(s,"type_lock_mode")=="HEXA")
for i,key in ipairs(V.keys()) do
    assert(V.get(s,key)~=nil,"all six lane settings exposed")
end
assert(V.set(s,"type_lock_mode",0))
assert(check(4),"OFF permits non-matching Pokemon")
assert(Core.set(s,"nuzlocke_enabled",true))
assert(V.set(s,"type_lock_mode",2))
assert(V.set(s,"type_lock_primary",10))
assert(V.set(s,"type_lock_secondary",11))
assert(check(1) and check(2))
assert(not check(4))
assert(check(9999),"unknown/provider-only types fail open")
assert(Core.set(s,"nuzlocke_enabled",false))
assert(check(4),"Nuzlocke master OFF leaves wild catches native")
assert(Core.set(s,"nuzlocke_enabled",true))
assert(V.set(s,"type_lock_mode",3))
assert(V.set(s,"type_lock_primary",0))
assert(V.set(s,"type_lock_secondary",0))
assert(V.set(s,"type_lock_tertiary",0))
assert(V.prepare(s,P,"trainer:1"))
local r=s.variantRules.random_types
assert(type(r)=="table" and r[1] and r[2] and r[3])
assert(r[1]~=r[2] and r[1]~=r[3] and r[2]~=r[3],
    "RANDOM lanes should be distinct")
local t1,t2,t3=V.label(s,"type_lock_primary"),
    V.label(s,"type_lock_secondary"),V.label(s,"type_lock_tertiary")
assert(t1:find("RND:",1,true)==1)
assert(not V.prepare(s,P,"trainer:999"),
    "after resolution, changed seed cannot reroll saved types")
assert(V.label(s,"type_lock_primary")==t1
    and V.label(s,"type_lock_secondary")==t2
    and V.label(s,"type_lock_tertiary")==t3)
local clone={enabled=true,rules=s.rules,variantRules=s.variantRules}
assert(V.label(clone,"type_lock_primary")==t1
    and V.label(clone,"type_lock_secondary")==t2,
    "resolved lane identities persist across save reload")
assert(V.set(s,"type_lock_primary",10))
assert(s.variantRules.random_types==nil,
    "changing a lane resets only generated allocations")
assert(V.prepare(s,P,"trainer:1"))
assert(V.get(s,"type_lock_primary")==10)
assert(V.label(s,"type_lock_primary")=="FIRE")
assert(V.label(s,"type_lock_secondary")~="RND:FIRE",
    "random lane must never duplicate a manually chosen type")
assert(V.set(s,"type_lock_mode",1))
assert(V.set(s,"type_lock_primary",16)) -- GBA DRAGON
assert(not check(1))
assert(V.set(s,"type_lock_primary",1)) -- FIGHTING
assert(not check(1),"FIRE is not FIGHTING")
assert(V.set(s,"type_lock_primary",17)) -- GBA DARK
assert(not check(4),"NORMAL / FLYING is not DARK")
assert(V.set(s,"type_lock_primary",14)) -- GBA PSYCHIC
assert(check(7),"provider Pokémon matches PSYCHIC")
local corrupt={enabled=true,rules=s.rules,
    variantRules={type_lock_mode=90,type_lock_primary=900}}
assert(V.get(corrupt,"type_lock_mode")==0)
assert(V.get(corrupt,"type_lock_primary")==0)
s.failed=true
assert(not V.set(s,"type_lock_mode",0))
assert(not V.set(s,"type_lock_primary",0))
assert(check(4),"failed run disables catch enforcement")
-- Catch Draft: only actual successful WILD catches draft new type lanes.
-- Wilds remain free until all required lanes are drafted, while gifts
-- and trades may only use existing drafted types and never add new lanes.
local draft=Core.normalise({})
assert(Core.set(draft,"nuzlocke_enabled",true))
assert(V.set(draft,"type_lock_mode",2))
assert(V.set(draft,"type_lock_primary",10))
assert(V.set(draft,"type_lock_secondary",11))
assert(V.set(draft,"type_lock_draft",true))
assert(V.label(draft,"type_lock_draft")=="ON")
assert(V.label(draft,"type_lock_primary")=="AWAIT CATCH")
assert(V.draftProgress(draft)==0)
assert(not V.set(draft,"type_lock_primary",12),
    "draft lane cannot be overwritten manually")
assert(not V.prepare(draft,P,"trainer:seed"),
    "draft mode must not preselect RANDOM types")
assert(V.check(draft,1,P,Core,nil,"wild"),
    "first wild catch unrestricted regardless of configured types")
assert(V.check(draft,4,P,Core,nil,"wild"))
assert(not V.check(draft,1,P,Core,nil,"gift"),
    "no established type: gifts must not circumvent wild draft")
assert(not V.check(draft,1,P,Core,nil,"trade"))
assert(not V.noteCatch(draft,9999,P,Core),
    "unregistered Pokémon cannot establish a false NORMAL lane")
local success,name,n,total=V.noteCatch(draft,3,P,Core) -- GRASS/POISON
assert(success and name=="GRASS" and n==1 and total==2)
assert(V.label(draft,"type_lock_primary")=="GRASS")
assert(V.label(draft,"type_lock_secondary")=="AWAIT CATCH")
assert(V.check(draft,2,P,Core,nil,"wild"),
    "wilds still free during partial draft")
assert(V.check(draft,3,P,Core,nil,"gift"),
    "gifts matching a drafted type are legal while draft incomplete")
assert(not V.check(draft,2,P,Core,nil,"trade"),
    "off-type NPC trades blocked during draft")
success,name,n,total=V.noteCatch(draft,3,P,Core)
assert(success and name=="POISON" and n==2,
    "second catch prefers undrafted secondary type")
assert(V.label(draft,"type_lock_secondary")=="POISON")
assert(not V.check(draft,1,P,Core,nil,"wild"),
    "after full draft, wild type restriction is enforced")
assert(V.check(draft,5,P,Core,nil,"wild"),
    "dual-type Ghost/Poison matches drafted POISON")
assert(not V.noteCatch(draft,5,P,Core),
    "completed draft cannot add another lane")
local reloaded={enabled=true,rules=draft.rules,
    variantRules=draft.variantRules}
assert(V.draftProgress(reloaded)==2)
assert(V.label(reloaded,"type_lock_primary")=="GRASS"
    and V.label(reloaded,"type_lock_secondary")=="POISON",
    "save/reload must preserve drafted type order")
assert(not V.check(reloaded,1,P,Core,nil,"wild"))
assert(V.set(draft,"type_lock_mode",3))
assert(V.draftProgress(draft)==0,
    "mode change starts a fresh draft")
assert(V.noteCatch(draft,3,P,Core))
assert(V.noteCatch(draft,3,P,Core))
assert(not V.noteCatch(draft,3,P,Core),
    "both types already selected: duplicate cannot fill an extra slot")
assert(V.draftProgress(draft)==2)
success,name,n,total=V.noteCatch(draft,5,P,Core)
assert(success and name=="GHOST" and n==3 and total==3)
assert(not V.check(draft,2,P,Core,nil,"wild"))
assert(V.set(draft,"type_lock_draft",false))
assert(V.draftProgress(draft)==0)
assert(draft.variantRules.drafted_types==nil,
    "disabling Catch Draft clears its earned lanes")
assert(V.label(draft,"type_lock_primary")=="FIRE",
    "normal configured lane stays available after switching draft off")
assert(V.set(draft,"type_lock_mode",0))
assert(V.set(draft,"type_lock_draft",true))
assert(V.check(draft,1,P,Core,nil,"gift"),
    "disabled Type Locke does not prohibit gifts despite draft option")
assert(Core.set(draft,"nuzlocke_enabled",false))
assert(V.set(draft,"type_lock_mode",2))
assert(not V.noteCatch(draft,3,P,Core),
    "Nuzlocke OFF must not record draft catches")
assert(V.check(draft,2,P,Core,nil,"trade"))
assert(Core.set(draft,"nuzlocke_enabled",true))
draft.failed=true
assert(not V.set(draft,"type_lock_draft",false))
assert(not V.noteCatch(draft,3,P,Core),
    "failed run cannot continue drafting")

print("Gen 3 Type Locke and Catch Draft wild-only save policy: PASS")
