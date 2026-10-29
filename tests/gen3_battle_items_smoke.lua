-- ROM-free Battle Items rules: independent option state + native categories.
local Rules=assert(loadfile("gen3_battle_items.lua"))()()
local Core=assert(loadfile("gen3_core_rules.lua"))()()
local Styles=assert(loadfile("gen3_playstyles.lua"))()()
local s=Core.normalise({})
assert(#Rules.descriptors()==4)
for _,key in ipairs({"no_healing_items","no_battle_items","no_catching"}) do
    assert(Rules.get(s,key)==false and Rules.label(s,key)=="OFF")
    assert(not Rules.set(s,key,1),"toggles accept only booleans")
end
assert(Rules.get(s,"encounter_ball_limit")==0)
assert(Rules.label(s,"encounter_ball_limit")=="OFF")
for _,bad in ipairs({-1,4,6,11,100,"5"}) do
    assert(not Rules.set(s,"encounter_ball_limit",bad),
        "only OFF/1/2/3/5/10 are valid")
end
local caps={0,1,2,3,5,10,0}
for i=1,6 do
    assert(Rules.get(s,"encounter_ball_limit")==caps[i])
    assert(Rules.set(s,"encounter_ball_limit",
        Rules.next(s,"encounter_ball_limit")))
    assert(Rules.get(s,"encounter_ball_limit")==caps[i+1])
end
local items={
    medicineKind=function(id)
        return ({
            [13]="heal",[14]="status",[19]="full_restore",
            [24]="revive",[139]="heal",[141]="status",
            [138]="pp",[75]="battle",[80]="battle",
        })[id] or "none"
    end,
    toNumericId=function(id)
        if id=="X_ATTACK" then return 75 end
        if id=="POTION" then return 13 end
        if id=="CUSTOM_BALL" then return 650 end
        return tonumber(id)
    end,
}
local itemUse={fieldUseKind=function(id)
    if id==13 or id=="POTION" then return "heal" end
    if id==24 then return "revive" end
    return "none"
end}
local battleItems={
    isBall=function(id)
        return id==4 or id==1 or id=="CUSTOM_BALL"
    end,
    isStatBooster=function(id) return id==75 or id=="CUSTOM_BOOST" end,
}
local function denial(id,ctx)
    return Rules.itemDenial(s,Core,Styles,id,battleItems,items,itemUse,
        ctx or {battle={},wild=true,throws=0})
end
assert(denial(13)==nil,"Nuzlocke master OFF")
assert(Core.set(s,"nuzlocke_enabled",true))
assert(denial(13)==nil and denial(75)==nil and denial(4)==nil)
assert(Rules.set(s,"no_healing_items",true))
for _,id in ipairs({13,14,19,24,139,141,"POTION"}) do
    assert(denial(id):find("No Healing",1,true),
        "healing/status/revive medicine must be blocked: "..tostring(id))
end
assert(denial(138)==nil,"PP-only recovery not HP/status healing")
assert(denial(75)==nil and denial(80)==nil,
    "No Healing may not affect stat boosters or Poke Doll")
assert(Rules.set(s,"no_battle_items",true))
for _,id in ipairs({73,74,75,76,77,78,79,"X_ATTACK",
    "DIRE_HIT","GUARD_SPEC","CUSTOM_BOOST"}) do
    assert(denial(id):find("No X Items",1,true),
        "battle boost item blocked: "..tostring(id))
end
assert(denial(80)==nil and denial(4)==nil,
    "Poke Doll and balls unaffected by No X Items")
assert(Rules.set(s,"no_catching",true))
assert(denial(4):find("No Catching",1,true))
assert(denial(1):find("No Catching",1,true))
assert(denial("CUSTOM_BALL"):find("No Catching",1,true))
assert(Rules.catchDenial(s,Core,0):find("No Catching",1,true))
assert(Rules.countThrow(s,Core,0)==nil,
    "No Catching must not consume legal-throw budget")
assert(Rules.set(s,"no_catching",false))
assert(Rules.set(s,"encounter_ball_limit",2))
assert(Rules.countThrow(s,Core,0)==1)
assert(Rules.countThrow(s,Core,1)==2)
assert(Rules.countThrow(s,Core,2)==nil)
assert(Rules.catchDenial(s,Core,1)==nil)
assert(Rules.catchDenial(s,Core,2):find("Ball Per Enc",1,true))
assert(denial(4,{battle={},wild=true,throws=1})==nil)
assert(denial(4,{battle={},wild=true,throws=2})
    :find("Ball Per Enc",1,true))
assert(denial("CUSTOM_BALL",{battle={},wild=true,throws=2})
    :find("Ball Per Enc",1,true))
assert(denial(4,{battle={},wild=false,throws=2})==nil,
    "do not apply encounter budgets to trainer battles")
assert(denial(4,{battle={oldManTutorial=true},wild=true,throws=2})==nil,
    "tutorial scripted battle must remain native")
assert(Rules.set(s,"no_healing_items",false))
assert(Rules.set(s,"no_battle_items",false))
assert(Styles.set(s,"hardcore_nuzlocke",true))
assert(denial(13):find("Hardcore",1,true),
    "Hardcore must override individual No Healing OFF")
assert(denial(80):find("Hardcore",1,true),
    "Hardcore bans other battle items independently")
assert(denial(4)==nil,"Hardcore preserves balls subject to budget")
assert(Rules.set(s,"encounter_ball_limit",0))
assert(denial(4)==nil)
assert(Styles.set(s,"hardcore_nuzlocke",false))
assert(Core.set(s,"nuzlocke_enabled",false))
assert(Rules.set(s,"no_healing_items",true))
assert(denial(13)==nil,"master OFF restores normal item usability")
assert(Rules.catchDenial(s,Core,100)==nil)
local reloaded={enabled=true,failed=false,rules=s.rules,
    battleItemRules=s.battleItemRules}
assert(Rules.get(reloaded,"no_healing_items")==true)
assert(Rules.get(reloaded,"encounter_ball_limit")==0)
s.failed=true
assert(not Rules.set(s,"no_catching",true),
    "failed runs may not change settings")
assert(denial(13)==nil,"failed run is inactive")
print("Gen 3 Advanced Battle Items policy and Ball budgets: PASS")
