-- Gen 3 Field Items: seven saved rules, native metadata and travel policy.
local Rules=assert(loadfile("gen3_field_items.lua"))()()
local Core=assert(loadfile("gen3_core_rules.lua"))()()
local s=Core.normalise({})
assert(#Rules.descriptors()==7)
local expected={
    "no_repels","no_escape_rope","travel_restrictions",
    "no_field_healing","no_pp_items","no_tm_use","no_rare_candy_use"
}
for _,key in ipairs(expected) do
    assert(Rules.get(s,key)~=nil and Rules.label(s,key))
end
for _,key in ipairs(expected) do
    if key~="travel_restrictions" then
        assert(not Rules.get(s,key))
        assert(not Rules.set(s,key,1))
        assert(Rules.next(s,key)==true)
    end
end
assert(Rules.get(s,"travel_restrictions")==0)
assert(Rules.next(s,"travel_restrictions")==1)
assert(not Rules.set(s,"travel_restrictions",-1))
assert(not Rules.set(s,"travel_restrictions",3))
assert(not Rules.set(s,"travel_restrictions",1.5))
assert(not Rules.set(s,"travel_restrictions","1"))
local Items={
    isTm=function(id)
        local n=tonumber(id) or (id=="TM01" and 289)
            or (id=="HM01" and 339)
        return n and n>=289 and n<=346 or false
    end,
    isHm=function(id)
        local n=tonumber(id) or (id=="HM01" and 339)
        return n and n>=339 and n<=346 or false
    end,
    toNumericId=function(id)
        return ({RARE_CANDY=68,REPEL=86,
            SUPER_REPEL=83,MAX_REPEL=84,
            ESCAPE_ROPE=85,PP_UP=69,PP_MAX=71,
            LEPPA_BERRY=138,TM01=289,HM01=339})[id] or tonumber(id)
    end,
    medicineKind=function(id)
        return ({[13]="heal",[19]="full_restore",
            [23]="status",[24]="revive",
            [139]="heal",[141]="status",[138]="pp"})[id] or "none"
    end,
}
local Use={
    fieldUseKind=function(id)
        local n=Items.toNumericId(id)
        if n==83 or n==84 or n==86 then return "repel" end
        if n==85 then return "escape" end
        if n==68 then return "level" end
        if n==138 or n==34 or n==35 or n==36 or n==37
            or n==38 or n==69 or n==71 then return "pp" end
        if n and n>=289 and n<=346 then return "tm" end
        return Items.medicineKind(id)
    end,
    ppItemBoosts=function(id)
        local n=Items.toNumericId(id)
        return n==69 or n==71
    end,
}
local function check(id) return Rules.fieldDenial(s,Core,id,{},Use,Items) end
assert(check(86)==nil and Rules.travelDenial(s,Core,"FLY")==nil)
assert(Core.set(s,"nuzlocke_enabled",true))
for _,rule in ipairs(expected) do
    if rule~="travel_restrictions" then assert(Rules.set(s,rule,true)) end
end
for _,id in ipairs({83,84,86,"REPEL","MAX_REPEL"}) do
    assert(check(id):find("No Repels",1,true))
end
assert(check(85):find("No Escape Rope",1,true))
for _,id in ipairs({13,19,23,24,139,141}) do
    assert(check(id):find("No Field Heal",1,true),
        "block HP/status/revive medicine: "..id)
end
for _,id in ipairs({34,35,36,37,38,69,71,138,
    "PP_UP","PP_MAX","LEPPA_BERRY"}) do
    assert(check(id):find("No PP Items",1,true),
        "PP item, including PP Up/Max and Leppa: "..tostring(id))
    assert(Rules.battleDenial(s,Core,id,{},Use,Items)
        :find("No PP Items",1,true))
end
assert(check(289):find("No TMs",1,true))
assert(check("TM01"):find("No TMs",1,true))
assert(check(338):find("No TMs",1,true))
assert(check(339)==nil and check(346)==nil,
    "HMs still teach moves even when No TMs enabled")
assert(check("HM01")==nil)
assert(check(68):find("No Rare Candy",1,true))
assert(check("RARE_CANDY"):find("No Rare Candy",1,true))
assert(check(70)==nil,"Zinc is not PP Max")
assert(check(80)==nil,"Poke Doll unaffected")
assert(check(93)==nil,"evolution stone unaffected")
assert(check(261)==nil,"itemfinder unaffected")
assert(Rules.set(s,"travel_restrictions",1))
assert(Rules.label(s,"travel_restrictions")=="NO FLY")
assert(Rules.travelDenial(s,Core,"FLY"):find("Fly",1,true))
assert(Rules.travelDenial(s,Core,"TELEPORT")==nil)
assert(Rules.travelDenial(s,Core,"DIG")==nil)
assert(Rules.set(s,"travel_restrictions",2))
assert(Rules.label(s,"travel_restrictions")=="NO FLY+TELEPORT")
assert(Rules.travelDenial(s,Core,"TELEPORT"):find("Teleport",1,true))
assert(Rules.travelDenial(s,Core,"DIG")==nil)
assert(Rules.next(s,"travel_restrictions")==0)
assert(Rules.set(s,"travel_restrictions",0))
assert(Rules.travelDenial(s,Core,"FLY")==nil)
local copy={enabled=true,rules=s.rules,fieldItemRules=s.fieldItemRules}
assert(Rules.get(copy,"no_tm_use") and Rules.get(copy,"no_pp_items"))
assert(Rules.get(copy,"travel_restrictions")==0)
assert(Core.set(s,"nuzlocke_enabled",false))
assert(check(68)==nil and Rules.battleDenial(s,Core,69,{},Use,Items)==nil
    and Rules.travelDenial(s,Core,"FLY")==nil,
    "master OFF restores all native field behaviour")
s.failed=true
assert(not Rules.set(s,"no_tm_use",false))
assert(not Rules.set(s,"travel_restrictions",2))
local invalid={enabled=true,rules=s.rules,
    fieldItemRules={travel_restrictions=999,
        no_tm_use="true"}}
assert(Rules.get(invalid,"travel_restrictions")==0
    and Rules.get(invalid,"no_tm_use")==false,
    "corrupt settings fall back safely")
print("Gen 3 Field Items policy: 7 controls, item classification, travel: PASS")
