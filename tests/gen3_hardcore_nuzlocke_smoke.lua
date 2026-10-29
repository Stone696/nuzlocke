-- Gen 3 Hardcore Nuzlocke: core overlays, cap, SET and battle items.
-- Run from repo root with: lua5.1 tests/gen3_hardcore_nuzlocke_smoke.lua
local Core = assert(loadfile("gen3_core_rules.lua"))()()
local Style = assert(loadfile("gen3_playstyles.lua"))()()
local Levels = assert(loadfile("gen3_levels.lua"))()()
local state = Core.normalise({})
assert(Core.set(state, "permadeath", false))
assert(Core.set(state, "encounter_limit", false))
assert(Core.set(state, "failed_encounter", false))
assert(Core.set(state, "whiteout_ends_run", false))
assert(Style.set(state, "hardcore_nuzlocke", true))
assert(not Style.hardcoreActive(state, Core), "master switch required")
assert(Core.set(state, "nuzlocke_enabled", true))
assert(Style.hardcoreActive(state, Core))
for _, key in ipairs({"permadeath","encounter_limit","failed_encounter",
    "whiteout_ends_run"}) do
    assert(Core.get(state,key) == false,
        "Hardcore must not alter saved CORE settings")
    assert(Core.enforced(state,key), "Hardcore must enforce "..key)
    local ok, why = Core.set(state,key,false)
    assert(not ok and why=="hardcore_override",
        "effective hardcore rules cannot be disabled mid-run")
end
assert(Core.shouldSpendOnStart(state),
    "failed encounters must consume a Hardcore area")
assert(Core.catchAllowed(state,"FR_ROUTE_1")) -- empty area is legal
state.areas.FR_ROUTE_1 = {spent=true}
assert(not Core.catchAllowed(state,"FR_ROUTE_1"),
    "Hardcore one-per-area must override saved OFF")
assert(Core.failedWhiteout(state,"whiteout"),
    "Hardcore whiteout still loses the run")

local badges = {}
for i=1,8 do badges[i]=true end
local native = { version="firered",flags={} }
assert(Levels.set(state,"level_cap_scope",0))
assert(select(1,Levels.cap(state,native,badges))==nil)
local cap,stage=Levels.cap(state,native,badges,3)
assert(cap==54 and stage=="ELITE 1", "Hardcore caps persist through Elite Four")
assert(Levels.get(state,"level_cap_scope")==0,
    "Hardcore must not rewrite the player's Level Cap Scope")
assert(Style.set(state,"hardcore_nuzlocke",false))
assert(not Core.enforced(state,"permadeath") and
    not Core.enforced(state,"encounter_limit"))
assert(select(1,Levels.cap(state,native,badges))==nil)
assert(Style.set(state,"shiny_nuzlocke",true))
assert(Style.set(state,"hardcore_nuzlocke",true))
assert(Style.active(state,Core) and Style.hardcoreActive(state,Core),
    "Shiny + Hardcore may be combined")
assert(Style.qualifies(state,Core,false)==false)
assert(Style.set(state,"hardcore_nuzlocke",false))
assert(Style.active(state,Core), "Hardcore OFF must not clear Shiny mode")

-- Runtime mocks: keep all native dependencies stubbed; do not consume items.
local events,hooks,saves={}, {}, {}
local uses,uiChecks = 0,0
local battleItems = {
    isBall=function(id) return id==4 or id=="CUSTOM_BALL" end,
    isStatBooster=function(id) return id==75 end,
    isBattleUsable=function() uiChecks=uiChecks+1; return true end,
    canUseOn=function() return true end,
    use=function()
        uses=uses+1
        return "heal",{},true,false
    end,
}
local options = {
    battleStyle=function() return "shift" end,
}
package.loaded["src.core.game3.battle.items"]=battleItems
package.loaded["src.core.game3.options"]=options
package.loaded["src.core.game3.items_data"]={
    medicineKind=function(id)
        return ({[13]="heal",[14]="status",[19]="full_restore",
            [28]="revive",[75]="battle",[80]="battle"})[id] or "none"
    end,
}
package.loaded["src.core.game3.item_use"]={
    fieldUseKind=function(id)
        return ({[13]="heal",[14]="status",[28]="revive",
            [75]="battle",[80]="battle"})[id] or "none"
    end,
}
package.loaded["src.core.game3.pokemon"]={
    isShiny=function(mon)return mon.isShiny==true end,
    speciesOf=function(mon)return mon.species end,
    name=function(id)return tostring(id) end,
}
local session={version="firered",map="FR_ROUTE_1",
    bag={pockets={POKE_BALLS={{id=4,qty=5}}}},
    party={{species=25,hp=20,level=5,personality=123}},flags={}}
local game={generation=3,session=session}
local mod={game=game,exports={},
    save={
        get=function(_,k,d)return saves[k] or d end,
        set=function(_,k,v)saves[k]=v end,
    },
    events={on=function(_,name,fn) events[name]=fn end},
    hooks={wrap=function(_,name,fn) hooks[name]=fn end},
    read=function(_,p)
        local f=assert(io.open(p,"rb"))
        local c=f:read("*a")
        f:close()
        return c
    end,
}
assert(loadfile("gen3_runtime.lua")()(mod)==nil)
local core,style=mod.exports.gen3_core,mod.exports.gen3_playstyles
local level=mod.exports.gen3_levels
assert(core.setRule("nuzlocke_enabled",true))
for _,key in ipairs({"permadeath","encounter_limit","failed_encounter",
    "whiteout_ends_run"}) do assert(core.setRule(key,false)) end
assert(level.setRule("level_cap_scope",0))
assert(level.getCurrentCap()==nil)
assert(style.setRule("hardcore_nuzlocke",true))
assert(style.getRule("hardcore_nuzlocke")==true)
assert(level.getCurrentCap()==14,
    "Hardcore should enforce Brock cap even when base scope NONE")
assert(level.getRule("level_cap_scope")==0)
local function started(kind,sp,opts)
    opts=opts or {}
    local battle={enemy={mon={species=sp or 16,level=5,
        personality=math.random(1000,100000),isShiny=false}},
        playerParty=session.party,session=session}
    for k,v in pairs(opts) do battle[k]=v end
    events["battle.started"]({kind=kind,battle=battle,
        speciesId=sp or 16})
    return battle
end
local b=started("trainer",16)
assert(options.battleStyle(session)=="set",
    "Hardcore must enforce SET when a trainer replaces a fainted mon")
assert(battleItems.isBattleUsable(13)==false,
    "Healing items must not appear as usable in a Hardcore battle")
assert(battleItems.isBattleUsable(4)==true,
    "Poke Balls stay selectable")
assert(select(1,battleItems.canUseOn(b,13,1,session.party[1]))==false)
local adapter={say=function(self,msg) self.text=msg end}
local denied,_,endsTurn= battleItems.use(b,adapter,{},session,13,1)
assert(denied=="error" and endsTurn==false and uses==0
    and adapter.text:find("Hardcore"),
    "medicine transaction must not spend a turn or consume a Potion")
assert(select(1,battleItems.use(b,adapter,{},session,4,1))=="heal"
    and uses==1,"Balls still use the normal native transaction")
events["battle.ended"]({battle=b,result="win"})
assert(options.battleStyle(session)=="shift",
    "global SET override must be limited to an active battle")

-- A skipped encounter must spend the route with effective hardcore rules
-- even if its original classic toggles are all OFF.
local first=started("wild",16)
assert(saves.gen3_classic_v1.areas.FR_ROUTE_1.spent==true)
events["battle.ended"]({battle=first,result="run"})
local second=started("wild",16)
local called=0
local caught=hooks["catch.rate"](function()
    called=called+1
    return true,4
end,4,second.enemy.mon,16,{battle=second})
assert(caught==false and called==0,
    "Hardcore cannot bypass used encounter even if classic limit OFF")
events["battle.ended"]({battle=second,result="run"})

assert(style.setRule("hardcore_nuzlocke",false))
assert(level.getCurrentCap()==nil,
    "pre-Hardcore cap scope should be restored instantly")
local third=started("trainer",16)
assert(options.battleStyle(session)=="shift")
assert(battleItems.isBattleUsable(13)==true)
assert(select(1,battleItems.use(third,adapter,{},session,13,1))=="heal"
    and uses==2, "ordinary item use restored after Hardcore OFF")
events["battle.ended"]({battle=third,result="win"})

-- With Hardcore ON but Nuzlocke master OFF, rules must not apply.
assert(style.setRule("hardcore_nuzlocke",true))
assert(core.setRule("nuzlocke_enabled",false))
local fourth=started("trainer",16)
assert(options.battleStyle(session)=="shift")
assert(battleItems.isBattleUsable(13)==true)
events["battle.ended"]({battle=fourth,result="win"})
assert(level.getCurrentCap()==nil)

assert(style.setRule("hardcore_nuzlocke",false))
assert(not style.getRule("hardcore_nuzlocke"))
-- Existing playstyle remains intact across toggles.
assert(style.setRule("shiny_nuzlocke",true))
assert(style.getRule("shiny_nuzlocke"))
-- Advanced Battle Items must compose with (but not depend on) Hardcore.
local rules=mod.exports.gen3_battle_items
assert(#rules.definitions()==4 and rules.getRule("encounter_ball_limit")==0)
assert(style.setRule("shiny_nuzlocke",false))
assert(core.setRule("nuzlocke_enabled",true))
assert(rules.setRule("no_healing_items",true))
assert(rules.setRule("no_battle_items",true))
local itemBattle=started("trainer",16)
assert(battleItems.isBattleUsable(13)==false)
assert(battleItems.isBattleUsable(14)==false)
assert(battleItems.isBattleUsable(28)==false)
assert(battleItems.isBattleUsable(75)==false)
assert(battleItems.isBattleUsable(80)==true,
    "Poke Doll is not a healing medicine or X item")
assert(battleItems.isBattleUsable(4)==true)
assert(select(1,battleItems.canUseOn(itemBattle,13,1,session.party[1]))==false)
assert(select(1,battleItems.canUseOn(itemBattle,75,1,session.party[1]))==false)
local usedBefore=uses
local result,_,ends=battleItems.use(itemBattle,adapter,{},session,13,1)
assert(result=="error" and ends==false and uses==usedBefore
    and adapter.text:find("No Healing",1,true),
    "medicine must be denied before consumption/turn")
result,_,ends=battleItems.use(itemBattle,adapter,{},session,75,1)
assert(result=="error" and ends==false and uses==usedBefore
    and adapter.text:find("No X Items",1,true),
    "X item must be denied before consumption/turn")
assert(select(1,battleItems.use(itemBattle,adapter,{},session,80,1))
    =="heal","unrelated battle item remains native")
events["battle.ended"]({battle=itemBattle,result="win"})
assert(rules.setRule("no_healing_items",false))
assert(rules.setRule("no_battle_items",false))
local itemEnabled=started("trainer",16)
assert(battleItems.isBattleUsable(13)==true)
assert(battleItems.isBattleUsable(75)==true)
events["battle.ended"]({battle=itemEnabled,result="win"})

-- No Catching and Ball Per Encounter are separate from healing/boost
-- restrictions. An illegal throw is blocked before native Bag.remove.
assert(rules.setRule("no_catching",true))
local noCatch=started("wild",16)
assert(battleItems.isBattleUsable(4)==false)
assert(battleItems.isBattleUsable("CUSTOM_BALL")==false)
usedBefore=uses
result,_,ends=battleItems.use(noCatch,adapter,{},session,4,1)
assert(result=="error" and not ends and uses==usedBefore)
local called=0
local captured=hooks["catch.rate"](function()
    called=called+1
    return true,4
end,4,noCatch.enemy.mon,16,{battle=noCatch})
assert(not captured and called==0 and rules.throws()==0,
    "No Catching vetoes raw catch.rate and doesn't spend throws")
events["battle.ended"]({battle=noCatch,result="run"})
assert(rules.setRule("no_catching",false))
assert(rules.setRule("encounter_ball_limit",2))
local capped=started("wild",16)
assert(battleItems.isBattleUsable(4)==true)
local function failedBall()
    return hooks["catch.rate"](function()
        called=called+1
        return false,0
    end,4,capped.enemy.mon,16,{battle=capped})
end
called=0
assert(not failedBall() and called==1 and rules.throws()==1)
assert(not failedBall() and called==2 and rules.throws()==2)
assert(battleItems.isBattleUsable(4)==false,
    "after two legal throws, ball unavailable in the battle bag")
assert(battleItems.isBattleUsable("CUSTOM_BALL")==false)
usedBefore=uses
result,_,ends=battleItems.use(capped,adapter,{},session,4,1)
assert(result=="error" and not ends and uses==usedBefore,
    "exhausted Ball limit cannot remove a ball or spend a turn")
assert(not failedBall() and called==2 and rules.throws()==2,
    "direct catch.rate cannot bypass an exhausted budget")
events["battle.ended"]({battle=capped,result="run"})
local fresh=started("wild",16)
assert(rules.throws()==0 and battleItems.isBattleUsable(4)==true,
    "each new wild battle gets its own throw counter")
events["battle.ended"]({battle=fresh,result="run"})
-- Disable Nuzlocke: policy values persist, but native battle items return.
assert(core.setRule("nuzlocke_enabled",false))
local disabled=started("trainer",16)
assert(battleItems.isBattleUsable(4)==true)
assert(battleItems.isBattleUsable(13)==true)
events["battle.ended"]({battle=disabled,result="win"})
assert(rules.getRule("encounter_ball_limit")==2)
assert(style.setRule("shiny_nuzlocke",true))
print("Gen3 Hardcore/Advanced Battle Items native runtime: PASS")
