-- End-to-end Gen3 run end: menu forfeit, native save reload, battle
-- whiteout autosave, and genuine Hall of Fame close with postgame resume.
local layers,events,hooks,values={},{},{},{}
local writes,disk,quits=0,nil,0
local function copy(v)
    if type(v)~="table" then return v end
    local out={}
    for k,x in pairs(v) do out[k]=copy(x) end
    return out
end
local Stack={}
function Stack.push(id,module)
    for i=#layers,1,-1 do
        if layers[i].id==id then table.remove(layers,i) end
    end
    layers[#layers+1]={id=id,mod=module}
end
function Stack.pop(id)
    for i=#layers,1,-1 do
        if layers[i].id==id then table.remove(layers,i);return true end
    end
end
function Stack.has(id)
    for _,v in ipairs(layers) do if v.id==id then return true end end
    return false
end
function Stack.top() return layers[#layers] end
package.loaded["src.ui.game3.stack"]=Stack
local Hof={open=false,close=function(self) self.open=false end}
package.loaded["src.ui.game3.hall_of_fame"]=Hof
package.loaded["src.ui.game3.pc_chrome"]={
    drawLeftDataPanel=function()return true end,
}
-- Model the real engine's exported newContext/accuracyCheck boundary.
-- The OHKO resolver calls this after native move display and PP spending,
-- before applying one-hit damage. No base-engine modifications are needed.
local nativeAccuracyCalls,failedMoveMessages=0,0
local moveContextMT={};moveContextMT.__index=moveContextMT
function moveContextMT:accuracyCheck()
    nativeAccuracyCalls=nativeAccuracyCalls+1
    return true
end
package.loaded["src.core.game3.battle.engine"]={
    newContext=function(user,target,moveId,slot,adapter)
        return setmetatable({user=user,target=target,moveId=moveId,
            effect=38,adapter=adapter,anim={}},moveContextMT)
    end,
}
local nativeAccuracy=moveContextMT.accuracyCheck
package.loaded["src.core.game3.pokemon"]={
    monIcon=function()return {native=true} end,
    isShiny=function(mon)return mon.isShiny==true end,
    name=function(id) return ({[1]="BULBASAUR",[4]="CHARMANDER",
        [7]="SQUIRTLE"})[id] or "POKEMON" end,
    speciesOf=function(mon)return mon.species end,
}
local nativeMonIcon=package.loaded["src.core.game3.pokemon"].monIcon
local function pokemon(id,hp,name)
    return {species=id,level=10,personality=100+id,hp=hp,
        maxHp=28,nickname=name or "",atk=20,def=18,spe=17,spa=19,spd=18}
end
local session={version="firered",map="FR_ROUTE_1",
    name="RED",party={pokemon(1,28,"Leaf")},flags={}}
local game={generation=3,session=session}
-- Match the native Game3 API exactly: saveGame exists, writeSave does
-- not. This would have caught the original failed-autosave regression.
assert(game.writeSave==nil)
function game:saveGame()
    writes=writes+1
    disk=copy(values.gen3_classic_v1)
    return true
end
function game:returnToTitle()
    quits=quits+1
    layers={}
end
local mod={game=game,exports={},
    save={
        get=function(_,key,default)return values[key] or default end,
        set=function(_,key,value)values[key]=value end,
    },
    events={on=function(_,name,fn)events[name]=fn end},
    hooks={wrap=function(_,name,fn)hooks[name]=fn end},
    read=function(_,path)
        local f=assert(io.open(path,"rb"))
        local content=f:read("*a");f:close()
        return content
    end,
}
values.gen3_classic_v1={enabled=true,areas={
    FR_ROUTE_1={caught=true,spent=true}},
    graveyard={{species=4,speciesName="Charmander",name="Flame",
        nickname="Flame",level=9,area="FR_ROUTE_1",cause="Critical hit",
        archive=pokemon(4,0,"Flame")}}}
assert(loadfile("gen3_runtime.lua")()(mod)==nil)
assert(type(events["save.loaded"])=="function"
    and type(events["battle.ended"])=="function")
assert(type(Hof.close)=="function" and Hof.__nuzResultsOwner==mod,
    "Hall of Fame is patched at native completion boundary")
local corePokemon=package.loaded["src.core.game3.pokemon"]
local chrome=package.loaded["src.ui.game3.pc_chrome"]
assert(corePokemon.monIcon==nativeMonIcon
    and corePokemon.__nuzVisualIconWrap==nil,
    "runtime must leave native PC/party mini-icons completely untouched")
assert(chrome.__nuzVisualOwner==mod
    and chrome.__nuzVisualPanelWrap==chrome.drawLeftDataPanel,
    "runtime must still wrap the PC portrait for shiny artwork")
assert(corePokemon.monIcon({species=56,isShiny=true}).native==true
    and corePokemon.monIcon({species=56,isShiny=false}).native==true,
    "shiny and normal Pokemon must use the standard visible native icon")
-- The engine lazily installs native battle guards at save/map entry,
-- not simply at mod registration (before the ROM battle is loaded).
events["save.loaded"]()
-- OHKO Clause must block the engine context's OHKO accuracy check
-- without touching move effect/PP/damage, and only when enabled.
local mkCtx=package.loaded["src.core.game3.battle.engine"].newContext
assert(moveContextMT.accuracyCheck~=nativeAccuracy
    and moveContextMT.__nuzOHKOOwner==mod)
local target={hp=75,side="enemy"}
local player={side="player",mon={pp={5}}}
local adapter={sayFail=function() failedMoveMessages=failedMoveMessages+1 end}
local function doOHKO(side,effect)
    local actor={side=side,mon={pp={5}}}
    local ctx=mkCtx(actor,target,12,1,adapter)
    ctx.effect=effect
    -- Native OHKO has already spent PP by the time this hook runs.
    actor.mon.pp[1]=actor.mon.pp[1]-1
    local allowed=ctx:accuracyCheck("lockon",true)
    if allowed then target.hp=0 end
    return ctx,actor,allowed
end
local blockedMon,blockedUser,allowed=doOHKO("enemy",38)
assert(allowed==true and target.hp==0 and blockedUser.mon.pp[1]==4,
    "default OFF must preserve native OHKO")
target.hp=75
local s=values.gen3_classic_v1
s.battleClauses={ohko_clause=true}
local ctx,actor,hit=doOHKO("enemy",38)
assert(hit==false and ctx.failed and ctx.missReason=="fail"
    and target.hp==75 and actor.mon.pp[1]==4
    and failedMoveMessages==1,
    "ON must fail before lethal OHKO damage, with native PP spent")
local _,_,hitPlayer=doOHKO("player",38)
assert(hitPlayer==false and target.hp==75 and failedMoveMessages==2,
    "both sides must be protected")
local _,_,ordinaryHit=doOHKO("enemy",0)
assert(ordinaryHit==true and target.hp==0,
    "non-OHKO moves must use native accuracy")
target.hp=75
s.enabled=false
local _,_,masterOff=doOHKO("enemy",38)
assert(masterOff==true, "master OFF must restore native OHKO")
s.enabled=true
assert(nativeAccuracyCalls==3)
-- User chooses END RUN, receives a separate irreversible confirmation.
assert(mod.exports.gen3_menu.open(game))
local function pressTop(button)
    local top=assert(layers[#layers])
    top.mod.handleInput({
        wasPressed=function(_,key) return key==button end,
    })
end
local function advanceTo(label)
    local top=assert(layers[#layers])
    local model=assert(top.mod.model())
    local target=nil
    for i,v in ipairs(model.rows) do
        if v==label then target=i;break end
    end
    assert(target,"Missing control "..label)
    for _=1,#model.rows+1 do
        if top.mod.model().index==target then break end
        pressTop("down")
    end
    assert(top.mod.model().index==target)
    pressTop("a")
end
advanceTo("END RUN")
assert(mod.exports.gen3_menu.model().title=="END THIS RUN?")
assert(writes==0 and values.gen3_classic_v1.failed~=true,
    "opening confirmation cannot end run")
pressTop("b")
assert(writes==0 and values.gen3_classic_v1.failed~=true,
    "cancel must leave run active")
advanceTo("END RUN")
advanceTo("CONFIRM END RUN")
local terminal=values.gen3_classic_v1
assert(terminal.failed and terminal.finalResult
    and terminal.finalResult.outcome=="FORFEIT"
    and writes==1 and disk and disk.failed,
    "manual end run must snapshot and autosave once")
assert(Stack.has("nuzlocke.gen3.results"))
local results=layers[#layers].mod
assert(results.model().title=="NUZ RUN RESULTS")
for _,name in ipairs(results.model().rows) do
    assert(name~="CONTINUE ADVENTURE")
end
pressTop("b")
assert(Stack.has("nuzlocke.gen3.results"),
    "failed run cannot escape with B")
advanceTo("QUIT TO TITLE")
assert(quits==1 and #layers==0)
-- Continue from the actual saved terminal record. The title's CONTINUE
-- may restore the game session but must never expose live gameplay.
values.gen3_classic_v1=copy(disk)
game.session={version="firered",map="FR_ROUTE_1",
    name="RED",party={pokemon(1,28,"Leaf")},flags={}}
events["save.loaded"]()
assert(Stack.has("nuzlocke.gen3.results")
    and layers[#layers].mod.model().outcome=="FORFEIT",
    "reloading failed save must reopen terminal results")
assert(writes==1,"reloading a terminal save must not overwrite it")
Stack.push("unrelated.native.menu",{})
events["world.stepped"]()
assert(Stack.top().id=="nuzlocke.gen3.results",
    "native menu layers must never cover the failed-run results modal")
advanceTo("QUIT TO TITLE")
assert(quits==2)
-- New run must be able to end from native battle end with autosave.
values.gen3_classic_v1={enabled=true,areas={},graveyard={}}
game.session={version="firered",map="FR_ROUTE_1",
    name="RED",party={pokemon(7,0,"Shell")},flags={}}
events["save.created"]()
events["battle.ended"]({result="lose",battle={}})
assert(values.gen3_classic_v1.failed
    and values.gen3_classic_v1.finalResult.outcome=="FAILED"
    and writes==2 and disk.finalResult.outcome=="FAILED"
    and Stack.has("nuzlocke.gen3.results"),
    "native whiteout should autosave and lock into final results")
advanceTo("QUIT TO TITLE")
-- Champion path is triggered by completed native HOF induction, NOT a
-- trainer victory. The player can continue after viewing/exporting.
values.gen3_classic_v1={enabled=true,areas={},graveyard={}}
game.session={version="emerald",map="EM_EVER_GRANDE_CITY",
    name="MAY",party={pokemon(1,75,"Flora")},flags={},
    game_cleared=true,hallOfFameTeams={{{species=1,level=55}}}}
events["save.created"]()
Hof.open=true
Hof.close(Hof)
assert(values.gen3_classic_v1.finalResult
    and values.gen3_classic_v1.finalResult.outcome=="VICTORY"
    and values.gen3_classic_v1.failed~=true
    and writes==3 and disk.finalResult.outcome=="VICTORY"
    and Stack.has("nuzlocke.gen3.results"),
    "native Champion induction commits the victory and saves it")
advanceTo("CONTINUE ADVENTURE")
assert(not Stack.has("nuzlocke.gen3.results")
    and values.gen3_classic_v1.failed~=true
    and quits==3, -- only the three failed runs returned to title
    "Champion result must allow continuing without quitting")
print("Gen 3 End Run native save/reload, battle failure and champion: PASS")
