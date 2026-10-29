-- Shiny Nuzlocke Gen3 playstyle: eligibility, precedence, notices and menu.
local Style = assert(loadfile("gen3_playstyles.lua"))()()
local Core = assert(loadfile("gen3_core_rules.lua"))()()
local state = Core.normalise({})
assert(Style.get(state,"shiny_nuzlocke")==false
    and Style.descriptors()[1].status=="working")
assert(not Style.active(state,Core))
assert(Style.set(state,"shiny_nuzlocke",true))
assert(not Style.active(state,Core),
    "the Nuzlocke master switch controls the playstyle")
assert(Core.set(state,"nuzlocke_enabled",true))
assert(Style.active(state,Core))
assert(not Style.qualifies(state,Core,false))
assert(Style.qualifies(state,Core,true))
assert(not Style.allowShinyException(state,Core))
assert(not Style.set(state,"shiny_nuzlocke",3))
assert(not Style.set(state,"no_such_variant",true))
local recovered=Style.normalise({playstyles={shiny_nuzlocke=true}})
assert(Style.get(recovered,"shiny_nuzlocke")==true,
    "playstyle must survive reloading saved state")
recovered.failed=true
assert(not Style.set(recovered,"shiny_nuzlocke",false),
    "failed runs cannot change playstyle")

local events,hooks,values={},{},{}
local battleText={}
package.loaded["src.core.game3.pokemon"]={
    isShiny=function(mon) return type(mon)=="table"
        and mon.isShiny==true end,
    speciesOf=function(mon) return tonumber(mon.species or mon.speciesId) end,
    national=function(id) return ({[277]=252,[401]=373,[402]=385})[id] or id end,
    stats=function(id)
        if id==25 then return {35,55,40,90,50,50} end
        if id==16 then return {40,45,40,56,35,35} end
        if id==277 then return {40,45,35,70,65,55} end
        if id==401 then return {95,135,80,100,110,80} end
        if id==402 then return {100,100,100,100,100,100} end
        return {45,45,45,45,45,45}
    end,
    name=function(id)
        return ({[4]="CHARMANDER",[16]="PIDGEY",[25]="PIKACHU",
            [160]="FERALIGATR"})[tonumber(id)]
    end,
}
package.loaded["src.core.game3.battle.ui"]={
    push=function(line) battleText[#battleText+1]=line end,
}
local secondaryCalls={flinch=0,trap=0,stats=0}
local nativeStatusCalls={}
local nativeSecondary={
    set=function(_,effect)
        if effect=="FLINCH" then secondaryCalls.flinch=secondaryCalls.flinch+1 end
        if effect=="WRAP" then secondaryCalls.trap=secondaryCalls.trap+1 end
        nativeStatusCalls[effect]=(nativeStatusCalls[effect] or 0)+1
        return true
    end,
    changeStat=function(_,target,stat,delta)
        secondaryCalls.stats=secondaryCalls.stats+1
        target.stages[stat]=(target.stages[stat] or 0)+delta
        return "worked"
    end,
}
local effectSource
package.loaded["src.core.game3.battle.effects.secondary"]=nativeSecondary
package.loaded["src.core.game3.battle.effect_ctx"]={
    current=function() return effectSource end,
}
local nativeEffects={
    run=function(id,_,user,target)
        if id=="EXP_MINIMIZE_EFFECT" then user.minimized=true end
        if id=="EXP_YAWN_EFFECT" then target.expYawnTurns=2 end
        return true
    end,
}
package.loaded["src.core.game3.battle.effects.init"]=nativeEffects
local nativeStatus={
    yawn=function(ctx)
        ctx.target.expYawnTurns=2
        return true
    end,
}
package.loaded["src.core.game3.battle.effects.status"]=nativeStatus
local nativeAdapter={
    new=function()
        return {
            applyStatus=function(self,target,status,source)
                target.status=status;return true
            end,
            applyConfusion=function(self,target)
                target.confusionTurns=3;return true
            end,
        }
    end,
}
package.loaded["src.core.game3.battle.adapter"]=nativeAdapter
package.loaded["src.import.gba.map_sections_extract"]={
    getInfo=function(_,map) return {
        resolved=true,
        rawName=map=="FR_ROUTE_1" and "ROUTE 1" or tostring(map),
        name=map=="FR_ROUTE_1" and "ROUTE 1" or tostring(map),
    } end,
}
local nativeRods,nativeFishingRolls=0,0
local nativeField={
    startFishing=function() nativeRods=nativeRods+1;return true end,
    tryFishingEncounter=function()
        nativeFishingRolls=nativeFishingRolls+1;return true
    end,
}
package.loaded["src.core.game3.field"]=nativeField
local g={generation=3,session={version="firered",map="FR_ROUTE_1",
    bag={pockets={POKE_BALLS={{id=4,qty=5}}}},
    party={{species=25,personality=10,level=9,hp=35}},flags={}}}
local stack={}
package.loaded["src.ui.game3.stack"]={
    push=function(id,m) stack[#stack+1]={id=id,module=m} end,
    pop=function(id)
        assert(stack[#stack] and stack[#stack].id==id)
        stack[#stack]=nil
    end,
}
local mod={game=g,exports={},
    save={
        get=function(_,k,default)return values[k] or default end,
        set=function(_,k,v)values[k]=v end,
    },
    events={on=function(_,n,fn)events[n]=fn end},
    hooks={wrap=function(_,n,fn)hooks[n]=fn end},
    read=function(_,path)
        local f=assert(io.open(path,"rb"))
        local t=f:read("*a");f:close();return t
    end,
}
assert(loadfile("gen3_runtime.lua")()(mod)==nil)
local styles=mod.exports.gen3_playstyles
local core=mod.exports.gen3_core
assert(styles.api==1 and styles.schema==1 and
    styles.getRule("shiny_nuzlocke")==false)
assert(core.setRule("nuzlocke_enabled",true))
assert(styles.setRule("shiny_nuzlocke",true))
assert(styles.getRule("shiny_nuzlocke"))
assert(mod.exports.gen3_notices.history()[1].code=="PLAYSTYLE_CHANGED")
local function ev(name,payload)
    assert(events[name],name)(payload)
end
local function map(id)
    g.session.map=id
    ev("map.entered",{mapId=id})
end
local function battle(species, shiny, options)
    options=options or {}
    local mon={species=species or 16,isShiny=shiny==true,
        personality=shiny and 77 or 1}
    local b={enemy={mon=mon},wildScripted=options.wildScripted,
        legendary=options.legendary,roamer=options.roamer}
    ev("battle.started",{battle=b,kind="wild",speciesId=species or 16})
    return b,mon
end
local function ball(b,mon)
    local nextCalled=0
    local caught,shakes=hooks["catch.rate"](function()
        nextCalled=nextCalled+1
        return true,4
    end,"POKE_BALL",mon,mon.species,{battle=b})
    ev("battle.ball_thrown",{battle=b,caught=caught,shakes=shakes})
    return caught,shakes,nextCalled
end
-- Many normal wilds can be encountered and even have balls thrown without
-- consuming the first route's chance with Failed Encounters ON.
map("FR_ROUTE_1")
for i=1,3 do
    local b,mon=battle(16,false)
    local caught,shakes,called=ball(b,mon)
    assert(not caught and shakes==0 and called==0,
        "ordinary wild Pokemon must not enter the native catch roll")
    local a=values.gen3_classic_v1.areas.FR_ROUTE_1
    assert(a==nil or a.spent==false,
        "nonshinies must never claim route on attempt")
    assert(battleText[#battleText]:find("only shiny Pokemon",1,true)
        and battleText[#battleText]:find("do not use your route",1,true),
        "blocked ball must explain the shiny restriction and unused route")
    ev("battle.ended",{battle=b,result="run"})
end
local b,mon=battle(16,true)
assert(values.gen3_classic_v1.areas.FR_ROUTE_1.spent==true,
    "first eligible shiny claims area with Failed Encounters ON")
assert(select(1,ball(b,mon))==true)
ev("pokemon.caught",{battle=b,speciesId=16,mon=mon})
assert(values.gen3_classic_v1.areas.FR_ROUTE_1.caught)
ev("battle.ended",{battle=b,result="catch"})
b,mon=battle(25,false)
assert(select(1,ball(b,mon))==false,
    "normal Pokemon also denied when the route was already claimed")
assert(battleText[#battleText]:find("route is already used",1,true),
    "a spent route must not be falsely reported as open")
ev("battle.ended",{battle=b,result="run"})
b,mon=battle(25,true)
assert(select(1,ball(b,mon))==false,
    "second shiny cannot use claimed map")
ev("battle.ended",{battle=b,result="run"})

-- Shiny Clause UNLIMITED must NOT create unlimited shiny catches
-- or bypass Dupes when playing Shiny Nuzlocke.
assert(mod.exports.gen3_clauses.setMode("shiny_clause",4))
b,mon=battle(25,true)
assert(select(1,ball(b,mon))==false)
assert(values.gen3_classic_v1.shinyExceptionsUsed==0)
ev("battle.ended",{battle=b,result="run"})

-- Failed Encounters OFF: shinies that flee are still eligible until caught.
assert(core.setRule("failed_encounter",false))
map("FR_ROUTE_2")
b,mon=battle(160,false)
assert(select(1,ball(b,mon))==false)
ev("battle.ended",{battle=b,result="run"})
b,mon=battle(160,true)
assert(not values.gen3_classic_v1.areas.FR_ROUTE_2.spent)
-- Simulate a natural ball failure, never fabricate a successful catch.
local passed=0
local result=hooks["catch.rate"](function()
    passed=passed+1;return false,2
end,"POKE_BALL",mon,160,{battle=b})
assert(result==false and passed==1)
ev("battle.ended",{battle=b,result="run"})
b,mon=battle(160,true)
assert(select(1,ball(b,mon))==true,"retry shiny after failed catch")
ev("pokemon.caught",{battle=b,speciesId=160,mon=mon})
assert(values.gen3_classic_v1.areas.FR_ROUTE_2.spent)
ev("battle.ended",{battle=b,result="catch"})

-- Dupes Clause excludes an already-owned shiny before it can claim
-- the first area slot. Another eligible shiny can still be caught there.
assert(mod.exports.gen3_clauses.setMode("dupes_mode",1))
map("FR_ROUTE_DUPES")
b,mon=battle(25,true) -- player's starter is Pikachu
assert(values.gen3_classic_v1.areas.FR_ROUTE_DUPES==nil,
    "duplicate shiny cannot use up the route's one encounter")
assert(select(1,ball(b,mon))==false,
    "Shiny Nuzlocke does not disable Dupes Clause")
ev("battle.ended",{battle=b,result="run"})
b,mon=battle(4,true)
assert(select(1,ball(b,mon))==true,
    "a different eligible shiny remains available")
ev("pokemon.caught",{battle=b,speciesId=4,mon=mon})
ev("battle.ended",{battle=b,result="catch"})
assert(mod.exports.gen3_clauses.setMode("dupes_mode",0))

-- Shiny rate (including ALWAYS) is separate from the capture rule.
assert(mod.exports.gen3_clauses.getMode("shiny_rate_mode")==0)
-- With One Per Area OFF, each shiny can be caught, but never a normal.
assert(core.setRule("encounter_limit",false))
map("FR_ROUTE_3")
for i=1,2 do
    b,mon=battle(160,true)
    assert(select(1,ball(b,mon))==true)
    ev("battle.ended",{battle=b,result="catch"})
end
b,mon=battle(16,false)
assert(select(1,ball(b,mon))==false)
ev("battle.ended",{battle=b,result="run"})

-- A wild target lacking an enemy-mon at battle.started must still be
-- rejected if not shiny and claimed once when the ball reveals shiny ID.
assert(core.setRule("encounter_limit",true))
assert(core.setRule("failed_encounter",true))
map("FR_ROUTE_4")
local late={enemy={}}
ev("battle.started",{battle=late,kind="wild",speciesId=16})
assert(values.gen3_classic_v1.areas.FR_ROUTE_4==nil)
local lateMon={species=16,isShiny=true}
assert(select(1,ball(late,lateMon))==true)
assert(values.gen3_classic_v1.areas.FR_ROUTE_4.spent)
ev("pokemon.caught",{battle=late,speciesId=16,mon=lateMon})
ev("battle.ended",{battle=late,result="catch"})

-- Even if the game does not report its current map, no ordinary wild can
-- bypass shiny-only enforcement. Leave unknown-area bookkeeping untouched.
g.session.map=nil
ev("map.entered",{})
b,mon=battle(16,false)
assert(select(1,ball(b,mon))==false)
ev("battle.ended",{battle=b,result="run"})

-- Toggle off: native catches are permitted, master Nuzlocke OFF also
-- disables variant enforcement while stored configuration remains ON.
assert(styles.setRule("shiny_nuzlocke",false))
map("FR_ROUTE_5")
b,mon=battle(16,false)
assert(select(1,ball(b,mon))==true)
ev("battle.ended",{battle=b,result="run"})
assert(styles.setRule("shiny_nuzlocke",true))
assert(core.setRule("nuzlocke_enabled",false))
b,mon=battle(16,false)
assert(select(1,ball(b,mon))==true)
ev("battle.ended",{battle=b,result="run"})

-- Advanced CATCH RULES are evaluated against the actual native catch
-- transaction, not merely the menu. A prohibited encounter is never spent.
local catch=assert(mod.exports.gen3_catch_rules)
assert(styles.setRule("shiny_nuzlocke",false))
assert(core.setRule("nuzlocke_enabled",true))
assert(catch.setRule("ban_pseudos",true))
assert(catch.setRule("maximum_bst",500))
map("FR_TEST_CATCH_BANS")
local bannedBattle,bannedMon=battle(401,false)
local caught,shakes,nativeCalls=ball(bannedBattle,bannedMon)
assert(not caught and shakes==0 and nativeCalls==0,
    "banned pseudo must not reach native capture")
local area=values.gen3_classic_v1.areas.FR_TEST_CATCH_BANS
assert(not area or not area.spent,
    "banned pseudo must not consume the area despite Failed Encounters ON")
assert(battleText[#battleText]:find("No Pseudos",1,true),
    "player must receive the precise catch denial")
ev("battle.ended",{battle=bannedBattle,result="run"})
local validBattle,validMon=battle(277,false) -- internal 277 = Treecko
caught,shakes,nativeCalls=ball(validBattle,validMon)
assert(caught and nativeCalls==1,
    "low-BST unbanned species still uses vanilla catch")
ev("battle.ended",{battle=validBattle,result="run"})
assert(catch.setRule("ban_pseudos",false))
assert(catch.setRule("maximum_bst",0))
-- Native field rods are guarded before they can open their fishing task.
assert(catch.setRule("no_fishing",true))
map("FR_TEST_FISHING")
assert(nativeField.startFishing(0)==false and nativeRods==0,
    "No Fishing must refuse rod use before the native animation starts")
assert(nativeField.tryFishingEncounter(0)==false and nativeFishingRolls==0,
    "a direct fishing roll cannot bypass the field rod restriction")
assert(mod.exports.gen3_notices.history()[#mod.exports.gen3_notices.history()].code
    =="NO_FISHING","fishing refusal must be visible in Nuzlocke notices")
assert(catch.setRule("no_fishing",false))
assert(nativeField.startFishing(0)==true and nativeRods==1)
assert(nativeField.tryFishingEncounter(0)==true and nativeFishingRolls==1)

-- Native static encounters are identified from battle-state flags, not
-- from species alone (a randomised normal wild can roll the same species).
assert(catch.setRule("no_static_encounters",true))
map("FR_TEST_STATIC_BANS")
local staticBattle,staticMon=battle(25,false,{wildScripted=true})
caught,shakes,nativeCalls=ball(staticBattle,staticMon)
assert(not caught and shakes==0 and nativeCalls==0,
    "scripted wild Pokemon cannot be captured")
local staticArea=values.gen3_classic_v1.areas.FR_TEST_STATIC_BANS
assert(not staticArea or not staticArea.spent,
    "disallowed static wild must not consume the route encounter")
assert(battleText[#battleText]:find("No Static",1,true),
    "native static capture rejection must explain why")
ev("battle.ended",{battle=staticBattle,result="run"})
local ordinaryBattle,ordinaryMon=battle(25,false)
caught,shakes,nativeCalls=ball(ordinaryBattle,ordinaryMon)
assert(caught and nativeCalls==1,
    "No Static must not block ordinary wild Pokemon")
ev("battle.ended",{battle=ordinaryBattle,result="run"})
map("FR_TEST_LEGENDARY_STATIC")
local legendaryBattle,legendaryMon=battle(25,false,{legendary=true})
caught,shakes,nativeCalls=ball(legendaryBattle,legendaryMon)
assert(not caught and nativeCalls==0,
    "native static legendary flag must block capture")
ev("battle.ended",{battle=legendaryBattle,result="run"})
map("FR_TEST_ROAMER_EXEMPT")
local roamerBattle,roamerMon=battle(25,false,{legendary=true,roamer=true})
caught,shakes,nativeCalls=ball(roamerBattle,roamerMon)
assert(caught and nativeCalls==1,
    "roaming wilds are not classified as fixed static encounters")
ev("battle.ended",{battle=roamerBattle,result="run"})
assert(catch.setRule("no_static_encounters",false))
assert(catch.setRule("no_fishing",true))
assert(core.setRule("nuzlocke_enabled",false))
assert(nativeField.startFishing(0)==true and nativeRods==2,
    "master OFF must restore native rod use")
assert(catch.setRule("no_fishing",false))
assert(styles.setRule("shiny_nuzlocke",true),
    "restore initial playstyle state for existing menu regression")

-- Runtime effect seam: both sides, King's Rock/shared flinch, partial
-- trapping and primary/secondary move stat stages use native effect methods.
local battleRules=assert(mod.exports.gen3_battle_clauses)
assert(core.setRule("nuzlocke_enabled",true))
map("FR_BATTLE_RULES_TEST")
local player={side="player",stages={attack=0,accuracy=0,evasion=0}}
local enemy={side="enemy",stages={attack=0,accuracy=0,evasion=0}}
assert(battleRules.setRule("flinch_clause_scope",1))
assert(not nativeSecondary.set({user=player},"FLINCH"),
    "SELF flinch clause prevents King's Rock and move flinch")
assert(secondaryCalls.flinch==0,
    "blocked flinch must not execute the native effect")
assert(nativeSecondary.set({user=enemy},"FLINCH"))
assert(secondaryCalls.flinch==1,
    "enemy flinch must be unchanged by SELF")
assert(battleRules.setRule("trap_clause_scope",2))
assert(not nativeSecondary.set({user=enemy},"WRAP"))
assert(secondaryCalls.trap==0)
assert(nativeSecondary.set({user=player},"WRAP"))
assert(secondaryCalls.trap==1)
assert(battleRules.setRule("setup_move_scope",1))
effectSource={user=player}
assert(nativeSecondary.changeStat({},player,"attack",2)=="blocked")
assert(player.stages.attack==0)
effectSource={user=enemy}
assert(nativeSecondary.changeStat({},enemy,"attack",2)=="worked"
    and enemy.stages.attack==2)
assert(battleRules.setRule("evasion_clause",true))
assert(nativeSecondary.changeStat({},enemy,"evasion",1)=="blocked"
    and enemy.stages.evasion==0)
assert(nativeEffects.run("EXP_MINIMIZE_EFFECT",
    {sayFail=function()end},enemy,player))
assert(not enemy.minimized,
    "Minimize must not apply its non-stage volatile flag")
assert(battleRules.setRule("evasion_clause",false))
assert(nativeEffects.run("EXP_MINIMIZE_EFFECT",{},enemy,player))
assert(enemy.minimized==true)
assert(battleRules.setRule("status_accuracy_scope",3))
assert(nativeSecondary.changeStat({},enemy,"accuracy",-1)=="blocked")
assert(nativeSecondary.changeStat({},player,"accuracy",-1)=="blocked")
assert(battleRules.setRule("other_stat_drop_scope",2))
assert(nativeSecondary.changeStat({},enemy,"attack",-1)=="blocked")
effectSource={user=player}
assert(nativeSecondary.changeStat({},player,"attack",-1)=="worked"
    and player.stages.attack==-1)
effectSource=nil
-- Native incidental non-move stat changes must not be blocked.
assert(nativeSecondary.changeStat({},enemy,"accuracy",-1)=="worked")
assert(enemy.stages.accuracy==-1)
assert(secondaryCalls.stats>=3,
    "native stat changes remain available when permitted")
assert(core.setRule("nuzlocke_enabled",false))
assert(nativeSecondary.set({user=player},"FLINCH"))
assert(core.setRule("nuzlocke_enabled",true))
for _,key in ipairs({"flinch_clause_scope","trap_clause_scope",
    "setup_move_scope","status_accuracy_scope","other_stat_drop_scope"}) do
    assert(battleRules.setRule(key,0))
end
assert(battleRules.setRule("evasion_clause",false))
assert(core.setRule("nuzlocke_enabled",false))

-- STATUS BANS: primary/secondary effect suppression, direct ability
-- status transactions, delayed Yawn and Rest self-sleep.
local statusRules=assert(mod.exports.gen3_status_bans)
assert(core.setRule("nuzlocke_enabled",true))
map("FR_TEST_STATUS_BANS")
local sourcePlayer={side="player"}
local sourceEnemy={side="enemy"}
local targetPlayer={side="player"}
local targetEnemy={side="enemy"}
assert(statusRules.setRule("status_move_scope",1))
local composedSet,composedRun=nativeSecondary.set,nativeEffects.run
map("FR_STATUS_GUARD_REENTRY_1")
map("FR_STATUS_GUARD_REENTRY_2")
assert(nativeSecondary.set==composedSet and nativeEffects.run==composedRun,
    "re-entering maps must not stack battle and status guard wrappers")
assert(not nativeSecondary.set({user=sourcePlayer,target=targetEnemy},
    "PARALYSIS",true,false,false))
assert(not nativeSecondary.set({user=sourcePlayer,target=targetEnemy},
    "BURN",false,false,false))
assert(nativeSecondary.set({user=sourceEnemy,target=targetPlayer},
    "FREEZE",false,false,false))
assert(nativeStatusCalls.PARALYSIS==nil and nativeStatusCalls.BURN==nil
    and nativeStatusCalls.FREEZE==1,
    "status guard must prevent native primary and secondary status mutation")
local adapter=nativeAdapter.new()
assert(adapter:applyStatus(targetPlayer,"PSN",sourcePlayer)==false,
    "direct ability inflict must respect SELF source scope")
assert(targetPlayer.status==nil)
assert(adapter:applyStatus(targetPlayer,"PSN",sourceEnemy)==true
    and targetPlayer.status=="PSN")
local resting={side="player"}
assert(adapter:applyStatus(resting,"SLP",resting)==true,
    "self-inflicted Rest sleep must still be legal")
assert(resting.status=="SLP")
local yawnVictim={side="enemy"}
local fakeAdapter={sayFail=function()end}
assert(nativeEffects.run("EXP_YAWN_EFFECT",
    fakeAdapter,sourcePlayer,yawnVictim)==true)
assert(yawnVictim.expYawnTurns==nil,
    "blocked Yawn must never schedule deferred sleep")
assert(nativeStatus.yawn({
    adapter=fakeAdapter,user=sourcePlayer,target=yawnVictim
})==nil)
assert(yawnVictim.expYawnTurns==nil)
assert(statusRules.setRule("status_move_scope",0))
assert(statusRules.setRule("status_sleep_scope",2))
assert(nativeEffects.run("EXP_YAWN_EFFECT",
    fakeAdapter,sourcePlayer,yawnVictim)==true)
assert(yawnVictim.expYawnTurns==2)
assert(yawnVictim._nuzYawnSource=="player",
    "allowed Yawn must retain source side until its delayed transaction")
assert(statusRules.setRule("status_sleep_scope",1))
assert(adapter:applyStatus(yawnVictim,"SLP",yawnVictim)==false,
    "delayed Yawn cannot bypass newly enabled source-side Sleep Ban")
assert(yawnVictim.status==nil)
assert(statusRules.setRule("status_sleep_scope",0))
assert(adapter:applyConfusion(targetEnemy,3,sourcePlayer)==true)
assert(targetEnemy.confusionTurns==3)
assert(statusRules.setRule("status_confusion_scope",1))
local freshTarget={side="enemy"}
assert(adapter:applyConfusion(freshTarget,3,sourcePlayer)==false
    and freshTarget.confusionTurns==nil)
assert(core.setRule("nuzlocke_enabled",false))
assert(nativeSecondary.set({user=sourcePlayer,target=targetEnemy},
    "PARALYSIS",true,false,false))
assert(core.setRule("nuzlocke_enabled",true))
assert(statusRules.setRule("status_confusion_scope",0))
assert(statusRules.setRule("status_move_scope",0))
assert(core.setRule("nuzlocke_enabled",false))

-- Menu exposes an actual PLAYSTYLES category and writes live state.
local start=hooks["ui.start_menu.items"](function(_,items)return items end,g,{})
assert(start[#start].label=="NUZ MENU")
start[#start].onSelect()
local function press(button)
    assert(stack[#stack])
    stack[#stack].module.handleInput({
        wasPressed=function(_,name)return name==button end
    })
end
press("a") -- NUZ RULES
local mainRules=mod.exports.gen3_menu.model()
local expectedMain={
    "CORE","CLAUSES","HARDCORE",
    "GAME DIFFICULTY","RUN / PARTY",
    "LEVELS","PLAYSTYLES","ADVANCED RULES",
    "RANDOMIZER","QOL","QOL SETUP ONLY",
}
assert(mainRules.title=="NUZ RULES" and #mainRules.rows==#expectedMain)
for i, label in ipairs(expectedMain) do
    assert(mainRules.rows[i]==label,
        "main NUZ RULES row "..i.." should be "..label)
end
-- RUN / PARTY is now implemented, with live controls and details.
for _=1,4 do press("down") end
press("a")
local rp=mod.exports.gen3_menu.model()
assert(rp.title=="RUN / PARTY" and #rp.rows==4)
assert(rp.rows[1]=="Gym Team Size: OFF"
    and rp.rows[2]=="Party Size Limit: 6/6"
    and rp.rows[3]=="Evolution Limits: NORMAL"
    and rp.rows[4]=="  DETAILS: RUN / PARTY")
press("a")
assert(mod.exports.gen3_menu.model().rows[1]=="Gym Team Size: ON")
press("a");press("down")
for _,i in ipairs({1,2,3,4,5,6}) do
    press("a")
    assert(mod.exports.gen3_menu.model().rows[2]
        =="Party Size Limit: "..i.."/6")
end
press("down")
for _,label in ipairs({"NO FINAL","NO EVOLUTION","NORMAL"}) do
    press("a")
    assert(mod.exports.gen3_menu.model().rows[3]
        =="Evolution Limits: "..label)
end
press("down");press("a")
assert(mod.exports.gen3_menu.model().title=="RUN / PARTY HELP")
press("b");press("b")
assert(mod.exports.gen3_menu.model().title=="NUZ RULES")
for _=1,4 do press("up") end
assert(mod.exports.gen3_menu.model().index==1)
-- The difficulty selector spans 16 unique native Gen3 profiles.
for _=1,3 do press("down") end
press("a")
local difficulty=mod.exports.gen3_menu.model()
assert(difficulty.title=="GAME DIFFICULTY" and #difficulty.rows==2)
assert(difficulty.rows[1]=="Game Difficulty: VANILLA"
    and difficulty.rows[2]=="  DETAILS: DIFFICULTY")
local difficulties={
    "NUZ MEDIUM","NUZ HARD","NUZ EXPERT","NUZ MASTER",
    "BOSS MEDIUM","BOSS HARD","BOSS EXPERT","BOSS MASTER",
    "TACTIC MEDIUM","TACTIC HARD","TACTIC EXPERT","TACTIC MASTER",
    "FULL MEDIUM","FULL HARD","FULL MASTER","VANILLA",
}
for _,label in ipairs(difficulties) do
    press("a")
    assert(mod.exports.gen3_menu.model().rows[1]
        =="Game Difficulty: "..label)
end
press("down");press("a")
assert(mod.exports.gen3_menu.model().title=="GAME DIFFICULTY HELP")
press("b");press("b")
assert(mod.exports.gen3_menu.model().title=="NUZ RULES"
    and mod.exports.gen3_menu.model().index==4)
for _=1,3 do press("up") end
assert(mod.exports.gen3_menu.model().index==1)
-- HARDCORE: all five native-supported switches and their detail page.
press("down");press("down");press("a")
local hc=mod.exports.gen3_menu.model()
assert(hc.title=="HARDCORE" and #hc.rows==6)
local hcLabels={"No Escape","Whiteout","Gym Lock-In",
    "Dungeon Lock-In","No Held Items"}
for i,label in ipairs(hcLabels) do
    assert(hc.rows[i]==label..": OFF")
    press("a")
    assert(mod.exports.gen3_menu.model().rows[i]==label..": ON")
    press("a")
    assert(mod.exports.gen3_menu.model().rows[i]==label..": OFF")
    press("down")
end
press("a")
assert(mod.exports.gen3_menu.model().title=="HARDCORE RULES HELP")
press("b");press("b")
assert(mod.exports.gen3_menu.model().title=="NUZ RULES")
press("up");press("up")
assert(mod.exports.gen3_menu.model().index==1)
-- QOL is deliberately restricted to four working Gen3 entries.
for _=1,9 do press("down") end
press("a")
local qolPage=mod.exports.gen3_menu.model()
assert(qolPage.title=="QOL" and #qolPage.rows==5)
assert(qolPage.rows[1]=="Instant Text: OFF")
assert(qolPage.rows[2]=="Run / Surf: OFF")
assert(qolPage.rows[3]=="Unlimited Bag Space: OFF")
assert(qolPage.rows[4]=="Trade Evolutions: OFF")
assert(qolPage.rows[5]=="  DETAILS: QOL")
press("a")
assert(mod.exports.gen3_menu.model().rows[1]=="Instant Text: ON")
press("down")
for _,v in ipairs({"HOLD B","ALWAYS","OFF"}) do
    press("a")
    assert(mod.exports.gen3_menu.model().rows[2]=="Run / Surf: "..v)
end
press("down");press("a")
assert(mod.exports.gen3_menu.model().rows[3]=="Unlimited Bag Space: ON")
press("down");press("a")
assert(mod.exports.gen3_menu.model().rows[4]=="Trade Evolutions: ON")
press("down");press("a")
assert(mod.exports.gen3_menu.model().title=="QOL HELP")
press("b");press("b")
assert(mod.exports.gen3_menu.model().title=="NUZ RULES"
    and mod.exports.gen3_menu.model().index==10)
-- Setup-only settings affect a future native save.new_game, never a
-- currently loaded game or the inherited Gen1/2 setup catalogue.
press("down");press("a")
local setupPage=mod.exports.gen3_menu.model()
assert(setupPage.title=="QOL SETUP ONLY" and #setupPage.rows==6)
assert(setupPage.rows[1]=="Starting Poke Balls: 0")
assert(setupPage.rows[2]=="Starting Rare Candy: 0")
assert(setupPage.rows[3]=="Starting Money: NATIVE")
assert(setupPage.rows[4]=="Heal Loadout: OFF")
assert(setupPage.rows[5]=="PC Vitamins: OFF")
assert(setupPage.rows[6]=="  DETAILS: QOL SETUP")
press("a")
assert(mod.exports.gen3_menu.model().rows[1]=="Starting Poke Balls: 5")
press("down");press("a")
assert(mod.exports.gen3_menu.model().rows[2]=="Starting Rare Candy: 5")
press("down");press("a")
assert(mod.exports.gen3_menu.model().rows[3]=="Starting Money: 0")
press("down");press("a")
assert(mod.exports.gen3_menu.model().rows[4]=="Heal Loadout: ON")
press("down");press("a")
assert(mod.exports.gen3_menu.model().rows[5]=="PC Vitamins: ON")
press("down");press("a")
assert(mod.exports.gen3_menu.model().title=="QOL SETUP HELP")
press("b");press("b")
assert(mod.exports.gen3_menu.model().title=="NUZ RULES"
    and mod.exports.gen3_menu.model().index==11)
for _=1,10 do press("up") end
assert(mod.exports.gen3_menu.model().index==1)
local catalog=mod.exports.gen3_menu.catalog()
for _, category in ipairs(catalog) do
    assert(category.title~="WORLD" and category.title~="UI",
        "obsolete Gen 3 WORLD and UI placeholders must be removed")
end
local position
for i,c in ipairs(catalog) do
    if c.title=="PLAYSTYLES" then position=i end
end
assert(position and position>1)
for i=2,position do press("down") end
press("a")
assert(mod.exports.gen3_menu.model().title=="PLAYSTYLES")
local rows=mod.exports.gen3_menu.model().rows
assert(#rows==4, "PLAYSTYLES must have only toggle/details pairs")
assert(rows[1]=="SHINY NUZ: ON" and rows[2]=="  DETAILS: SHINY NUZ"
    and rows[3]=="HARDCORE: OFF" and rows[4]=="  DETAILS: HARDCORE",
    "each playstyle switch must be followed immediately by its DETAILS")
press("a")
assert(mod.exports.gen3_menu.model().rows[1]=="SHINY NUZ: OFF")
assert(styles.getRule("shiny_nuzlocke")==false)
press("down");press("a") -- Shiny details
local details=mod.exports.gen3_menu.model()
assert(details.title=="SHINY NUZLOCKE"
    and #details.rows>=10, "shiny conditions must live on details page")
assert(table.concat(details.rows,";"):find("SHINY CLAUSE: NO BONUS",1,true))
press("b") -- keep position at Shiny details
assert(mod.exports.gen3_menu.model().index==2)
press("down");press("a") -- Hardcore ON
assert(mod.exports.gen3_menu.model().rows[3]=="HARDCORE: ON")
assert(styles.getRule("hardcore_nuzlocke")==true)
press("down");press("a") -- Hardcore details
details=mod.exports.gen3_menu.model()
assert(details.title=="HARDCORE NUZLOCKE"
    and #details.rows>=12,"hardcore restrictions must live on details page")
assert(table.concat(details.rows,";"):find("FORCED SET BATTLE STYLE",1,true))
press("b");press("up");press("a") -- Hardcore OFF
assert(mod.exports.gen3_menu.model().rows[3]=="HARDCORE: OFF")
assert(styles.getRule("hardcore_nuzlocke")==false)
press("b") -- back to NUZ RULES, selection remains PLAYSTYLES
assert(mod.exports.gen3_menu.model().title=="NUZ RULES")
assert(mod.exports.gen3_menu.model().index==position)
press("down");press("a") -- ADVANCED RULES immediately after PLAYSTYLES
local advanced=mod.exports.gen3_menu.model()
local expectedAdvanced={
    "CATCH RULES","BATTLE CLAUSES","STATUS BANS","VARIANTS",
    "BATTLE ITEMS","FIELD ITEMS","SERVICES & ECONOMY",
    "POKEMON STATS","AREA SPLITS",
}
assert(advanced.title=="ADVANCED RULES"
    and #advanced.rows==#expectedAdvanced,
    "Advanced Rules must contain exactly the nine requested categories")
for i, name in ipairs(expectedAdvanced) do
    assert(advanced.rows[i]==((name=="CATCH RULES"
        or name=="BATTLE CLAUSES"
        or name=="STATUS BANS" or name=="VARIANTS"
        or name=="BATTLE ITEMS" or name=="FIELD ITEMS"
        or name=="SERVICES & ECONOMY"
        or name=="POKEMON STATS"
        or name=="AREA SPLITS")
        and name or "[Soon] "..name),
        "advanced category "..i.." should reflect real feature readiness")
    press("a")
    local child=mod.exports.gen3_menu.model()
    assert(child.title==name and #child.rows>0,
        "advanced category must open its original rules")
    if name=="CATCH RULES" then
        assert(child.rows[1]=="Town Catches: OFF",
            "redundant Overworld Encounters rule must be absent")
        for _,label in ipairs(child.rows) do
            assert(not label:find("Overworld",1,true),
                "visible overworld Pokémon use native catch rules")
        end
    elseif name=="BATTLE CLAUSES" then
        assert(child.rows[1]=="OHKO Clause: OFF",
            "OHKO Clause is now a working ON/OFF battle clause")
        press("a")
        assert(mod.exports.gen3_menu.model().rows[1]=="OHKO Clause: ON",
            "OHKO can be enabled from the native menu")
        press("a")
        assert(mod.exports.gen3_menu.model().rows[1]=="OHKO Clause: OFF")
    elseif name~="STATUS BANS" and name~="VARIANTS"
        and name~="BATTLE ITEMS" and name~="FIELD ITEMS"
        and name~="SERVICES & ECONOMY"
        and name~="POKEMON STATS"
        and name~="AREA SPLITS" then
        assert(child.rows[1]:find("[Soon]",1,true),
            "unsupported rows must stay read-only even in an active category")
    end
    if name=="AREA SPLITS" then
        assert(child.rows[1]=="Area Scope: NATIVE MAP"
            and child.rows[2]=="Route 2 North/South: OFF"
            and child.rows[3]=="Route 10 North/South: OFF"
            and child.rows[4]=="Route 20 West/East: OFF"
            and child.rows[5]=="Route 21 North/South: OFF"
            and child.rows[6]=="Mt. Moon: FOLLOW SCOPE"
            and child.rows[7]=="Safari Zone: FOLLOW SCOPE"
            and child.rows[8]=="Kanto Dungeons: FOLLOW SCOPE"
            and child.rows[9]=="Sevii Dungeons: FOLLOW SCOPE"
            and child.rows[10]=="Hoenn Dungeons: FOLLOW SCOPE",
            "Area Splits must expose native, location and floor policies")
        for _,mode in ipairs({"ONE/LOCATION","PER FLOOR","NATIVE MAP"}) do
            press("a")
            assert(mod.exports.gen3_menu.model().rows[1]
                =="Area Scope: "..mode)
        end
        press("down")
        for rowIndex=2,5 do
            press("a")
            assert(mod.exports.gen3_menu.model().rows[rowIndex]
                :find(": ON",1,true))
            press("a")
            assert(mod.exports.gen3_menu.model().rows[rowIndex]
                :find(": OFF",1,true))
            press("down")
        end
        for rowIndex=6,10 do
            local expected=rowIndex==7 and
                {"ONE ZONE","PER AREA","UNTIL CATCH","AREA + CATCH"}
                or {"ONE LOCATION","PER FLOOR"}
            for _,value in ipairs(expected) do
                press("a")
                assert(mod.exports.gen3_menu.model().rows[rowIndex]
                    :find(": "..value,1,true))
            end
            press("a")
            assert(mod.exports.gen3_menu.model().rows[rowIndex]
                :find(": FOLLOW SCOPE",1,true))
            press("down")
        end
        assert(mod.exports.gen3_menu.model().rows[11]
            :find("[Soon] Time Split",1,true)
            and mod.exports.gen3_menu.model().rows[12]
            :find("[Soon] Headbutt",1,true))
        press("down");press("down")
        press("a")
        assert(mod.exports.gen3_menu.model().title=="AREA SPLITS HELP")
        press("b")
    end
    if name=="POKEMON STATS" then
        assert(child.rows[1]=="Player Starting EVs: 0 EV/STAT"
            and child.rows[2]=="Wild Starting EVs: 0 EV/STAT"
            and child.rows[3]=="Trainer Starting EVs: 0 EV/STAT"
            and child.rows[4]=="No EV Gain: OFF"
            and child.rows[5]=="Perfect Player IVs: OFF"
            and child.rows[6]=="Perfect Wild IVs: OFF"
            and child.rows[7]=="Perfect Trainer IVs: OFF",
            "Pokemon Stats must have seven active Gen3 EV/IV controls")
        for rowIndex=1,3 do
            for _,ev in ipairs({16,32,48,64,85,0}) do
                press("a")
                assert(mod.exports.gen3_menu.model().rows[rowIndex]
                    :find(tostring(ev).." EV/STAT",1,true),
                    "EV preset must cycle legal Gen3 EV distributions")
            end
            press("down")
        end
        for rowIndex=4,7 do
            press("a")
            assert(mod.exports.gen3_menu.model().rows[rowIndex]
                :find(": ON",1,true))
            press("a")
            assert(mod.exports.gen3_menu.model().rows[rowIndex]
                :find(": OFF",1,true))
            press("down")
        end
        press("a")
        assert(mod.exports.gen3_menu.model().title=="POKEMON STATS HELP")
        press("b")
    end
    if name=="SERVICES & ECONOMY" then
        assert(child.rows[1]=="No Center Heal: OFF"
            and child.rows[2]=="No Mom Heal: OFF"
            and child.rows[3]=="No Day Care: OFF"
            and child.rows[4]=="Shop Restrictions: NORMAL"
            and child.rows[5]=="No Gambling: OFF"
            and child.rows[6]=="Trainer Money: 100%",
            "Services & Economy must expose all six working controls")
        press("a")
        assert(mod.exports.gen3_menu.model().rows[1]=="No Center Heal: ON")
        press("a");press("down");press("a")
        assert(mod.exports.gen3_menu.model().rows[2]=="No Mom Heal: ON")
        press("a");press("down");press("a")
        assert(mod.exports.gen3_menu.model().rows[3]=="No Day Care: ON")
        press("a");press("down")
        for _,label in ipairs({"NO BUY","NO SELL","CLOSED","NORMAL"}) do
            press("a")
            assert(mod.exports.gen3_menu.model().rows[4]
                =="Shop Restrictions: "..label)
        end
        press("down");press("a")
        assert(mod.exports.gen3_menu.model().rows[5]=="No Gambling: ON")
        press("a");press("down")
        for _,pct in ipairs({"200%","300%","0%","50%","100%"}) do
            press("a")
            assert(mod.exports.gen3_menu.model().rows[6]
                =="Trainer Money: "..pct)
        end
        press("down");press("a")
        assert(mod.exports.gen3_menu.model().title=="SERVICES HELP")
        press("b")
    end
    if name=="FIELD ITEMS" then
        assert(child.rows[1]=="No Repels: OFF"
            and child.rows[2]=="No Escape Rope: OFF"
            and child.rows[3]=="Travel Restrictions: NORMAL"
            and child.rows[4]=="No Field Heal: OFF"
            and child.rows[5]=="No PP Items: OFF"
            and child.rows[6]=="No TMs: OFF"
            and child.rows[7]=="No Rare Candy: OFF",
            "all seven Field Items must be working")
        press("a")
        assert(mod.exports.gen3_menu.model().rows[1]=="No Repels: ON")
        press("a");press("down");press("a")
        assert(mod.exports.gen3_menu.model().rows[2]=="No Escape Rope: ON")
        press("a");press("down")
        for _,label in ipairs({"NO FLY","NO FLY+TELEPORT","NORMAL"}) do
            press("a")
            assert(mod.exports.gen3_menu.model().rows[3]
                =="Travel Restrictions: "..label)
        end
        for i=4,7 do
            press("down");press("a")
            assert(mod.exports.gen3_menu.model().rows[i]:find(": ON",1,true),
                "Field Items toggle should activate")
            press("a")
            assert(mod.exports.gen3_menu.model().rows[i]:find(": OFF",1,true))
        end
        press("down");press("a")
        assert(mod.exports.gen3_menu.model().title=="FIELD ITEMS HELP")
        press("b")
        for _=1,7 do press("up") end
    end
    if name=="BATTLE ITEMS" then
        assert(child.rows[1]=="No Healing Items: OFF"
            and child.rows[2]=="No X Items: OFF"
            and child.rows[3]=="No Catching: OFF"
            and child.rows[4]=="Ball Per Enc.: OFF"
            and child.rows[5]=="  DETAILS: BATTLE ITEMS",
            "all four Battle Items rules must be working")
        press("a")
        assert(mod.exports.gen3_menu.model().rows[1]
            =="No Healing Items: ON")
        press("a")
        assert(mod.exports.gen3_menu.model().rows[1]
            =="No Healing Items: OFF")
        press("down");press("a")
        assert(mod.exports.gen3_menu.model().rows[2]=="No X Items: ON")
        press("a")
        press("down");press("a")
        assert(mod.exports.gen3_menu.model().rows[3]=="No Catching: ON")
        press("a")
        press("down")
        local limits={"1","2","3","5","10","OFF"}
        for _,limit in ipairs(limits) do
            press("a")
            assert(mod.exports.gen3_menu.model().rows[4]
                =="Ball Per Enc.: "..limit,
                "Ball limit preset cycles OFF/1/2/3/5/10")
        end
        press("down");press("a")
        assert(mod.exports.gen3_menu.model().title=="BATTLE ITEMS HELP")
        press("b")
        press("up");press("up");press("up");press("up")
        assert(mod.exports.gen3_menu.model().rows[4]=="Ball Per Enc.: OFF")
    end
    if name=="STATUS BANS" then
        assert(child.rows[1]=="No Status Moves: OFF"
            and child.rows[2]=="Paralysis: OFF"
            and child.rows[3]=="Confusion: OFF"
            and child.rows[4]=="Sleep Ban: OFF"
            and child.rows[5]=="Poison/Toxic: OFF"
            and child.rows[6]=="Burn Ban: OFF"
            and child.rows[7]=="Freeze: OFF"
            and child.rows[8]=="Sleep Clause: OFF",
            "status menu must expose independent working Sleep Clause")
        press("a")
        local parentActive=mod.exports.gen3_menu.model()
        assert(parentActive.rows[1]=="No Status Moves: SELF"
            and parentActive.rows[2]=="Sleep Clause: OFF"
            and #parentActive.rows==3,
            "parent status scope hides child bans but not Sleep Clause")
        assert(statusRules.getRule("status_poison_scope")==1)
        press("down");press("a") -- independent Sleep Clause ON
        assert(mod.exports.gen3_menu.model().rows[2]=="Sleep Clause: ON")
        press("a");press("up") -- OFF, back to parent
        press("a");press("a");press("a") -- ENEMY, ALL, OFF
        assert(mod.exports.gen3_menu.model().rows[1]=="No Status Moves: OFF"
            and mod.exports.gen3_menu.model().rows[8]=="Sleep Clause: OFF")
        assert(statusRules.getRule("status_poison_scope")==0)
        for k=1,7 do press("down") end
        press("a") -- Sleep Clause ON while parent OFF
        assert(mod.exports.gen3_menu.model().rows[8]=="Sleep Clause: ON")
        press("a") -- OFF
    end
    if name=="BATTLE CLAUSES" then
        assert(child.rows[1]=="OHKO Clause: OFF"
            and child.rows[2]=="Flinch Clause: OFF"
            and child.rows[3]=="Trap Clause: OFF"
            and child.rows[4]=="No Setup Moves: OFF"
            and child.rows[5]=="Evasion Clause: OFF"
            and child.rows[6]=="Accuracy Drops: OFF"
            and child.rows[7]=="Other Stat Drops: OFF",
            "battle menu must expose seven working clauses including OHKO")
        press("down");press("a")
        assert(child.title=="BATTLE CLAUSES"
            and mod.exports.gen3_menu.model().rows[2]=="Flinch Clause: SELF")
        assert(battleRules.getRule("flinch_clause_scope")==1)
        press("a")
        assert(battleRules.getRule("flinch_clause_scope")==2)
        assert(battleRules.setRule("flinch_clause_scope",0))
        press("up")
    end
    if name=="VARIANTS" then
        assert(child.rows[1]=="Type Locke: OFF"
            and child.rows[2]=="Catch Draft: OFF"
            and child.rows[3]=="  DETAILS: TYPE LOCKE",
            "Variants must contain only Type Locke, Catch Draft and details")
        press("a") -- MONO
        assert(mod.exports.gen3_menu.model().rows[1]=="Type Locke: MONO"
            and mod.exports.gen3_menu.model().rows[3]=="Type 1: RANDOM")
        press("a") -- DUO
        assert(mod.exports.gen3_menu.model().rows[4]=="Type 2: RANDOM")
        press("down");press("down");press("a") -- Type 1: NORMAL
        assert(mod.exports.gen3_menu.model().rows[3]=="Type 1: NORMAL")
        press("up");press("a") -- Catch Draft ON
        local draftMenu=mod.exports.gen3_menu.model()
        assert(draftMenu.rows[2]=="Catch Draft: ON"
            and draftMenu.rows[3]=="Type 1: AWAIT CATCH"
            and draftMenu.rows[4]=="Type 2: AWAIT CATCH"
            and draftMenu.rows[5]=="DRAFT: 0/2 TYPES",
            "draft mode hides manual lane selection and shows progress")
        press("down");press("a") -- Type 1 cannot change manually
        assert(mod.exports.gen3_menu.model().rows[3]
            =="Type 1: AWAIT CATCH")
        press("up");press("a") -- Catch Draft OFF, restores manual types
        assert(mod.exports.gen3_menu.model().rows[3]
            =="Type 1: NORMAL")
        press("up")
        for _=1,5 do press("a") end -- TRI, QUAD, PENTA, HEXA, OFF
        assert(mod.exports.gen3_menu.model().rows[1]=="Type Locke: OFF"
            and mod.exports.gen3_menu.model().rows[3]=="  DETAILS: TYPE LOCKE")
        -- Restore the lane default without enabling the mode.
        assert(mod.exports.gen3_variants.setRule("type_lock_primary",0))
        assert(mod.exports.gen3_variants.getRule("type_lock_mode")==0)
    end
    if name=="CATCH RULES" then
        assert(child.rows[2]=="No Legendaries: OFF"
            and child.rows[3]=="No Mythicals: OFF"
            and child.rows[4]=="No Pseudos: OFF"
            and child.rows[5]=="No Static Enc: OFF"
            and child.rows[6]=="No Fishing: OFF"
            and child.rows[11]=="Maximum BST: OFF",
            "six native catch rules must have working switches")
        -- Check live toggle and leave the new first row untouched.
        press("down");press("a")
        assert(mod.exports.gen3_menu.model().rows[2]=="No Legendaries: ON"
            and catch.getRule("ban_legendaries")==true)
        press("a")
        assert(catch.getRule("ban_legendaries")==false)
        press("up") -- return to first row without wrapping around
        for _=1,11 do press("down") end -- PKMN BAN row
        assert(mod.exports.gen3_menu.model().rows[12]=="PKMN BAN: 0 BANNED")
        press("a") -- National Dex picker
        assert(mod.exports.gen3_menu.model().title=="PKMN BAN")
        press("down");press("down");press("down") -- #001
        press("a")
        assert(mod.exports.gen3_menu.model().rows[4]:find(": BAN",1,true))
        assert(catch.getRule("pkmn_ban")==1)
        press("b")
        assert(mod.exports.gen3_menu.model().rows[12]
            =="PKMN BAN: 1 BANNED","ban count persists in parent")
        press("a") -- revisit picker and clear ban
        press("down");press("down");press("down");press("a")
        assert(catch.getRule("pkmn_ban")==0)
        press("b")
        press("down") -- Colorlocke
        assert(mod.exports.gen3_menu.model().rows[13]=="Colorlocke: OFF")
        press("a")
        assert(mod.exports.gen3_menu.model().rows[13]=="Colorlocke: RANDOM")
        press("a")
        local cr=mod.exports.gen3_menu.model().rows
        assert(cr[13]=="Colorlocke: CHOOSE"
            and cr[14]=="Color: BLACK",
            "Color picker only appears for CHOOSE mode")
        press("down");press("a")
        assert(mod.exports.gen3_menu.model().rows[14]=="Color: BLUE")
        press("up");press("a") -- hide Color row by switching mode OFF
        assert(mod.exports.gen3_menu.model().rows[13]=="Colorlocke: OFF"
            and mod.exports.gen3_menu.model().rows[14]=="Alphabetlocke: OFF")
        for _=1,12 do press("up") end -- return to Town Catches
    end
    if name=="VARIANTS" then
        for _,label in ipairs(mod.exports.gen3_menu.model().rows) do
            assert(not label:find("Wonderlocke",1,true),
                "removed Wonderlocke must not appear in the variant menu")
        end
    end
    press("b")
    advanced=mod.exports.gen3_menu.model()
    assert(advanced.title=="ADVANCED RULES" and advanced.index==i,
        "B should return to the same advanced category and selection")
    if i<#expectedAdvanced then press("down") end
end
press("b") -- return to top-level rules at ADVANCED RULES
assert(mod.exports.gen3_menu.model().title=="NUZ RULES"
    and mod.exports.gen3_menu.model().index==position+1)
press("up");press("a") -- PLAYSTYLES still uses original config
assert(mod.exports.gen3_menu.model().title=="PLAYSTYLES"
    and mod.exports.gen3_menu.model().rows[1]=="SHINY NUZ: OFF"
    and mod.exports.gen3_menu.model().rows[3]=="HARDCORE: OFF")
press("b");press("b");press("b")
assert(#stack==0)
print("Gen3 Shiny Nuzlocke, clean rules menu, advanced navigation and save state: PASS")
