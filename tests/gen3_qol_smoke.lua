-- Gen 3 QOL: truthful unsupported rows and four native-backed settings.
local Q=assert(loadfile("gen3_qol.lua"))()()
local Core=assert(loadfile("gen3_core_rules.lua"))()()
local s=Core.normalise({})
local defs=Q.descriptors()
local keys={"instant_text","run_surf","unlimited_bag_space","trade_evolutions"}
assert(#defs==4)
for i,d in ipairs(defs) do assert(d.key==keys[i] and d.status=="working") end
for _,key in ipairs({"progression_pc_catches","skip_cherrygrove_tour",
    "system_clock_sync","infinite_rare_candies"}) do
    assert(Q.get(s,key)==nil)
    assert(Q.next(s,key)==nil)
    assert(not Q.set(s,key,true))
end
assert(Q.get(s,"instant_text")==false)
assert(Q.get(s,"run_surf")==0)
assert(Q.get(s,"unlimited_bag_space")==false)
assert(Q.get(s,"trade_evolutions")==false)
assert(not Q.set(s,"run_surf",3))
assert(not Q.set(s,"run_surf",0.5))
assert(not Q.set(s,"instant_text",1))
assert(not Q.set(s,"invalid",false))
assert(Q.set(s,"instant_text",true))
assert(Q.enabled(s,"instant_text"))
local done=function() end
local qopts=Q.textOptions(s,done)
assert(qopts.done==done and qopts.speed==0)
local original={frame="sign",hold=true,stay=true,speed=2}
local changed=Q.textOptions(s,original)
assert(changed~=original and changed.frame=="sign"
    and changed.hold and changed.stay and changed.speed==0)
assert(original.speed==2,"text options must remain immutable")
assert(Q.set(s,"instant_text",false))
assert(Q.textOptions(s,original)==original)
assert(Q.set(s,"run_surf",1))
assert(Q.label(s,"run_surf")=="HOLD B")
local held={isDown=function(self,key)return key=="b" end}
local noB={isDown=function()return false end}
local walk={player={},walking=true,input=held}
assert(Q.frames(s,12,walk)==6)
assert(Q.frames(s,12,{player={},walking=true,input=noB})==12)
assert(Q.frames(s,12,{player={},surfing=true,input=held})==6)
for _,key in ipairs({"onBike","slope","underwater","forced"}) do
    local ctx={player={},walking=true,input=held}
    ctx[key]=true
    assert(Q.frames(s,12,ctx)==12,key.." must be native")
end
assert(Q.frames(s,12,{player={jumping=true},input=held})==12)
assert(Q.frames(s,12,{player={action=true},input=held})==12)
assert(Q.frames(s,12,{player={dismounting=true},input=held})==12)
assert(Q.frames(s,12,nil)==12)
assert(Q.frames(s,1,walk)==1)
assert(Q.next(s,"run_surf")==2)
assert(Q.set(s,"run_surf",2))
assert(Q.label(s,"run_surf")=="ALWAYS")
assert(Q.frames(s,11,{player={},surfing=true})==5)
assert(Q.next(s,"run_surf")==0)
assert(Q.set(s,"run_surf",0))
assert(Q.frames(s,12,walk)==12)

local data={
    CAPACITY={ITEMS=20,POKE_BALLS=16,
        KEY_ITEMS=20,TM_CASE=50,BERRY_POUCH=30},
    pocketOf=function(id)
        if id==4 then return "POKE_BALLS" end
        if id==100 then return "KEY_ITEMS" end
        return "ITEMS"
    end,
    toNumericId=function(id) return tonumber(id) end,
}
local bag={pockets={ITEMS={},POKE_BALLS={}}}
local seen
local function nativeAdd(bag,id,qty)
    local pocket=data.pocketOf(id)
    seen=data.CAPACITY[pocket]
    return qty<=99,qty
end
assert(Q.withBagCapacity(s,data,13,nativeAdd,bag,13,3))
assert(seen==20)
assert(Q.set(s,"unlimited_bag_space",true))
local ok,amount=Q.withBagCapacity(s,data,13,nativeAdd,bag,13,3)
assert(ok and amount==3 and seen==4096)
assert(data.CAPACITY.ITEMS==20,"capacity must restore immediately")
Q.withBagCapacity(s,data,4,nativeAdd,bag,4,2)
assert(seen==4096 and data.CAPACITY.POKE_BALLS==16)
Q.withBagCapacity(s,data,100,nativeAdd,bag,100,1)
assert(seen==20 and data.CAPACITY.KEY_ITEMS==20,
    "key item pocket must never increase")
local success=pcall(function()
    Q.withBagCapacity(s,data,13,function()
        assert(data.CAPACITY.ITEMS==4096)
        error("intentional")
    end)
end)
assert(not success and data.CAPACITY.ITEMS==20,
    "exception must not leave modified capacity")
assert(Q.bagCanAdd(s,bag,13,99,data,false))
assert(not Q.bagCanAdd(s,bag,13,1000,data,false))
assert(not Q.bagCanAdd(s,bag,100,1,data,false))
assert(Q.set(s,"unlimited_bag_space",false))
assert(not Q.bagCanAdd(s,bag,13,1,data,false))

local P={
    evolutions=function(id)
        if id==64 then return {{5,0,65}} end -- Kadabra -> Alakazam
        if id==79 then return {{4,37,80},{6,198,199}} end -- Slowpoke -> Slowking
        if id==67 then return {{5,0,68}} end -- Machoke -> Machamp
        return {}
    end,
}
local E={EVO_MODE_NORMAL=0,EVO_MODE_TRADE=1,
    EVO_TRADE=5,EVO_TRADE_ITEM=6,
    nationalAllows=function()return true end}
local evoItems={
    toNumericId=function(id) return tonumber(id) end,
    info=function()return {holdEffect=0} end,
}
local mon={species=64,level=39,item=0}
local target,param=Q.tradeLevelTarget(s,mon,0,0,0,{},E,P,evoItems)
assert(target==0)
assert(Q.set(s,"trade_evolutions",true))
target,param=Q.tradeLevelTarget(s,mon,0,0,0,{},E,P,evoItems)
assert(target==0,"trade boost starts at Level 40")
mon.level=40
target,param=Q.tradeLevelTarget(s,mon,0,0,0,{},E,P,evoItems)
assert(target==65 and param==0)
mon.item=195
target=Q.tradeLevelTarget(s,mon,0,0,0,{},E,P,evoItems)
assert(target==0,"Everstone must block shortcut")
mon.item=0
target=Q.tradeLevelTarget(s,mon,0,0,E.EVO_MODE_TRADE,{},E,P,evoItems)
assert(target==0,"real trade uses normal timing")
local slow={species=79,level=40,item=198}
target=Q.tradeLevelTarget(s,slow,80,37,0,{},E,P,evoItems)
assert(target==199,"matching held item branch wins")
assert(Q.consumeTradeItem(s,slow,79,199,"level",P,E,evoItems))
assert(slow.item==0 and slow.heldItem==0)
assert(not Q.consumeTradeItem(s,slow,79,80,"level",P,E,evoItems))
assert(not Q.consumeTradeItem(s,{species=64},64,65,"trade",P,E,evoItems))
local gated={EVO_MODE_NORMAL=0,EVO_TRADE=5,EVO_TRADE_ITEM=6,
    nationalAllows=function()return false end}
target=Q.tradeLevelTarget(s,{species=64,level=40},0,0,0,{},gated,P,evoItems)
assert(target==0,"FRLG National Dex evolution gate respected")
assert(Q.set(s,"trade_evolutions",false))
target=Q.tradeLevelTarget(s,mon,0,0,0,{},E,P,evoItems)
assert(target==0)
local saved={qolRules=s.qolRules}
assert(Q.get(saved,"run_surf")==0 and Q.get(saved,"instant_text")==false)
assert(Q.get(saved,"trade_evolutions")==false)
s.failed=true
assert(not Q.set(s,"instant_text",true))
local bad={qolRules={run_surf="2"}}
assert(Q.get(bad,"run_surf")==0)

local f=assert(io.open("gen3_runtime.lua","rb"))
local rt=f:read("*a");f:close()
for _,token in ipairs({
    'readModule("gen3_qol.lua")',
    'mod.hooks:wrap("movement.speed"',
    'Qol.frames(loadState(),base,ctx)',
    'installQolGuards()',
    'Qol.textOptions(loadState(),opts)',
    'Qol.withBagCapacity(loadState()',
    'Qol.tradeLevelTarget(loadState()',
    'Qol.consumeTradeItem(loadState()',
    'mod.exports.gen3_qol',
    'qolRules = Qol',
}) do
    assert(rt:find(token,1,true),"missing QOL integration "..token)
end
print("Gen3 QOL: text, movement, pocket capacity, trade level 40 PASS")
