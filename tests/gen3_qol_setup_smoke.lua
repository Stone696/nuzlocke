-- Fresh-save-only Gen3 QOL Setup policy and atomic PC loadouts.
local S=assert(loadfile("gen3_qol_setup.lua"))()()
local Core=assert(loadfile("gen3_core_rules.lua"))()()
local s=Core.normalise({})
local defs=S.descriptors()
assert(#defs==5)
for i,key in ipairs({"starting_pokeballs","starting_rare_candies",
    "starting_money","pc_starting_heal_items",
    "pc_starting_vitamins"}) do
    assert(defs[i].key==key and defs[i].status=="working")
end
assert(S.get(s,"starting_pokeballs")==0)
assert(S.get(s,"starting_rare_candies")==0)
assert(S.get(s,"starting_money")==-1)
assert(S.label(s,"starting_money")=="NATIVE")
assert(S.label(s,"pc_starting_heal_items")=="OFF")
assert(S.label(s,"pc_starting_vitamins")=="OFF")
assert(S.get(s,"missing")==nil)
assert(not S.set(s,"missing",true))
assert(not S.set(s,"starting_money",nil))
assert(not S.set(s,"starting_money",1000000))
assert(not S.set(s,"starting_money",-2))
assert(not S.set(s,"starting_pokeballs",100))
assert(not S.set(s,"starting_rare_candies",-1))
assert(not S.set(s,"starting_rare_candies","99"))
assert(not S.set(s,"pc_starting_vitamins",1))
assert(S.next(s,"starting_pokeballs")==5)
assert(S.next(s,"starting_money")==0)
assert(S.next(s,"pc_starting_vitamins")==true)
assert(S.set(s,"starting_money",0))
assert(S.get(s,"starting_money")==0)
assert(S.set(s,"starting_money",-1))
assert(S.set(s,"starting_pokeballs",99))
assert(S.next(s,"starting_pokeballs")==0)
assert(S.set(s,"starting_pokeballs",0))

local Storage={
    MAX_ITEM_QTY=999,
    ensure=function(native) return native.storage end,
    addPcItem=function(native,id,qty)
        local items=native.storage.items
        for _,entry in ipairs(items) do
            if entry.id==id then
                entry.qty=entry.qty+qty
                return true
            end
        end
        if #items>=30 then return false,"pc_full" end
        items[#items+1]={id=id,qty=qty}
        return true
    end,
    pcItemsCount=function()return 30 end,
}
local function fresh()
    return {engine="game3",generation=3,version="firered",
        money=3000,party={},bag={},
        storage={items={{id=13,qty=1}}},modData={}}
end
local native=fresh()
local success,why=S.apply(s,native,Storage)
assert(success and why==nil)
assert(native.money==3000 and #native.storage.items==1)
assert(native.storage.items[1].id==13
    and native.storage.items[1].qty==1)
assert(native.modData.nuzQolSetupApplied==true)
assert(not S.apply(s,native,Storage))
assert(native.storage.items[1].qty==1,
    "new game resources must never duplicate")

assert(S.set(s,"starting_pokeballs",25))
assert(S.set(s,"starting_rare_candies",50))
assert(S.set(s,"starting_money",7500))
assert(S.set(s,"pc_starting_heal_items",true))
assert(S.set(s,"pc_starting_vitamins",true))
local plan=S.plan(s)
assert(plan.money==7500 and #plan.items==17,
    "2 resources + 9 heals + 6 vitamins")
local byId={}
for _,item in ipairs(plan.items) do
    assert(not byId[item.id], "duplicate starter item IDs")
    byId[item.id]=item.qty
end
assert(byId[4]==25 and byId[68]==50)
assert(byId[13]==10 and byId[22]==10
    and byId[20]==10 and byId[14]==10
    and byId[15]==10 and byId[16]==10
    and byId[17]==10 and byId[18]==10 and byId[23]==10)
for _,id in ipairs({63,64,65,66,67,70}) do
    assert(byId[id]==10,"native Gen3 vitamin missing "..id)
end
native=fresh()
assert(S.apply(s,native,Storage))
assert(native.money==7500)
assert(#native.storage.items==16,
    "deferred Balls are withheld from initial 16-item PC loadout")
local items={}
for _,e in ipairs(native.storage.items) do
    assert(not items[e.id],"duplicate PC item slot")
    items[e.id]=e.qty
end
assert(items[13]==11,"keep the native starting Potion")
assert(items[4]==nil and items[68]==50,
    "extra Balls must not exist in PC before capture unlock")
assert(native.modData.nuzQolSetupSummary.money==7500)
assert(native.modData.nuzQolSetupSummary.pcItemTypes==16)
assert(native.modData.nuzQolDeferredBalls==25)
assert(not S.deliverBalls({},native,Storage),
    "no Balls before native capture unlock")
assert(not S.deliverBalls({captureUnlocked=false},native,Storage))
assert(S.deliverBalls({captureUnlocked=true},native,Storage))
assert(native.modData.nuzQolDeferredBalls==0
    and native.modData.nuzQolExtraBallsGranted==true)
local ballCount=0
for _,entry in ipairs(native.storage.items) do
    if entry.id==4 then ballCount=entry.qty end
end
assert(ballCount==25,"extra Balls delivered into native PC")
assert(not S.deliverBalls({captureUnlocked=true},native,Storage),
    "deferred rewards must not duplicate")
local prior=native
assert(not S.apply(s,prior,Storage))
assert(prior.storage.items[1].qty==11,
    "reapplying on save.loaded must do nothing")
local reloaded={engine="game3",generation=3,
    money=prior.money,storage=prior.storage,modData=prior.modData}
assert(not S.apply(s,reloaded,Storage),
    "persisted once-only marker must prevent regrant")

local limited=fresh()
local tiny={
    MAX_ITEM_QTY=999,
    ensure=Storage.ensure,
    addPcItem=Storage.addPcItem,
    pcItemsCount=function() return 5 end,
}
assert(not S.apply(s,limited,tiny))
assert(limited.money==3000 and #limited.storage.items==1
    and not limited.modData.nuzQolSetupApplied,
    "PC capacity failure must not partially apply kit or money")
local overflowing=fresh()
overflowing.storage.items[1].qty=995
assert(not S.apply(s,overflowing,Storage))
assert(overflowing.money==3000 and #overflowing.storage.items==1
    and overflowing.storage.items[1].qty==995
    and not overflowing.modData.nuzQolSetupApplied,
    "PC stack failure must preserve all original state")
assert(not S.apply(s,{engine="game2",generation=2},Storage))
assert(not S.apply(s,{engine="game3",generation=3,
    storage={items={}}},{}))
assert(S.set(s,"pc_starting_heal_items",false))
assert(S.set(s,"pc_starting_vitamins",false))
assert(S.set(s,"starting_pokeballs",0))
assert(S.set(s,"starting_rare_candies",0))
assert(S.set(s,"starting_money",-1))
local ordinary=fresh()
assert(S.apply(s,ordinary,Storage))
assert(ordinary.money==3000 and #ordinary.storage.items==1)
local saved={setupRules=s.setupRules}
assert(S.get(saved,"starting_money")==-1)
assert(S.get(saved,"starting_pokeballs")==0)
s.failed=true
assert(S.set(s,"starting_money",12000),
    "next-run setup must remain editable after losing a run")
local file=assert(io.open("gen3_runtime.lua","rb"))
local runtime=file:read("*a");file:close()
for _,token in ipairs({
    'readModule("gen3_qol_setup.lua")',
    'mod.hooks:wrap("save.new_game",function(next,fresh)',
    'QolSetup.apply(loadState(),native,Storage)',
    'qolSetupRules = QolSetup',
    'mod.exports.gen3_qol_setup',
}) do
    assert(runtime:find(token,1,true),"setup hook missing "..token)
end
print("Gen3 QOL Setup: native new game, PC resources, atomic failure, persistence: PASS")
