-- Gen 3 LEVELS policy and native adapter smoke tests.
local Levels = assert(loadfile("gen3_levels.lua"))()()
local function mon(nick, exp, level)
    return { species = 25, personality = 17, otId = 3, nickname = nick,
        hp = 12, maxHp = 20, level = level or 5, exp = exp or 500 }
end
local function flags(n)
    local b = {}
    for i = 1, (n or 0) do b[i] = true end
    for i = (n or 0) + 1, 8 do b[i] = false end
    return b
end
local r = { levels = {} }
local fr = { version = "firered" }
assert(Levels.get(r, "level_cap_scope") == 0)
assert(Levels.get(r, "exp_edging") == false)
assert(Levels.set(r, "level_cap_scope", 1))
assert(Levels.set(r, "exp_edging", true))
assert(not Levels.set(r, "level_cap_scope", 5))
assert(select(1, Levels.cap(r, fr, nil)) == nil, "unknown badges fail open")
assert(select(1, Levels.cap(r, fr, flags(0))) == 14)
assert(select(1, Levels.cap(r, fr, flags(1))) == 21)
assert(select(1, Levels.cap(r, fr, flags(8))) == nil,
    "GYMS ends after eighth badge")

local emerald = { version = "emerald" }
local ruby = { version = "ruby" }
assert(select(1, Levels.cap(r, ruby, flags(0))) == 15)
assert(select(1, Levels.cap(r, emerald, flags(1))) == 19)
assert(select(1, Levels.cap(r, ruby, flags(7))) == 43)
assert(select(1, Levels.cap(r, emerald, flags(7))) == 46)
assert(Levels.set(r, "level_cap_scope", 2))
assert(select(1, Levels.cap(r, fr, flags(8))) == 54)
local recovered = { levels = {scope=3} }
assert(select(1, Levels.cap(recovered, {
    version="emerald", flags = {[0x4FB]=true, [0x4FC]=true}
}, flags(8))) == 53, "native E4 flags restore prior progress")
assert(select(1, Levels.cap(recovered, {
    version="firered", flags = {[0x82C]=true}
}, flags(8))) == nil, "native game-clear flag removes Champion cap")
assert(Levels.setPostgameCap(recovered, 75))
assert(Levels.set(recovered, "level_cap_scope", 4))
assert(select(1, Levels.cap(recovered, {
    version="ruby", flags = {[0x804]=true}
}, flags(8))) == 75, "completed save honours postgame provider")
assert(not Levels.noteWin(r, fr, {trainerId=411}),
    "cannot skip Lorelei")
assert(Levels.noteWin(r, fr, { trainerId = 410 }))
assert(select(1, Levels.cap(r, fr, flags(8))) == 56)
assert(not Levels.noteWin(r, fr, { trainerId = 410 }),
    "same boss is not awarded twice")
assert(Levels.noteWin(r, fr, { trainerId = 411 }))
assert(Levels.noteWin(r, fr, { trainerId = 412 }))
assert(Levels.noteWin(r, fr, { trainerId = 413 }))
assert(select(1, Levels.cap(r, fr, flags(8))) == nil,
    "ELITE FOUR scope stops before Champion")
assert(Levels.set(r, "level_cap_scope", 3))
assert(select(1, Levels.cap(r, fr, flags(8))) == 63)
assert(Levels.noteWin(r, fr, { trainerId = 438 }))
assert(select(1, Levels.cap(r, fr, flags(8))) == nil)
assert(Levels.set(r, "level_cap_scope", 4))
assert(select(1, Levels.cap(r, fr, flags(8))) == nil)
assert(Levels.setPostgameCap(r, 70))
assert(select(1, Levels.cap(r, fr, flags(8))) == 70)
assert(Levels.setPostgameCap(r, nil))
assert(select(1, Levels.cap(r, fr, flags(8))) == nil)

local edging = { levels = {} }
assert(Levels.set(edging, "level_cap_scope", 1))
assert(Levels.set(edging, "exp_edging", true))
local lead = mon("Spark", 550, 5)
local threshold = function(_, lv) return lv * 100 end
assert(Levels.adjust(edging, lead, 100, 5, threshold) == 49,
    "cap means one EXP short of next level")
assert(Levels.banked(edging, lead) == 51)
lead.exp = lead.exp + 49
assert(Levels.adjust(edging, lead, 20, 8, threshold) == 71,
    "bank released after cap increases")
assert(Levels.banked(edging, lead) == 0)
local boxed = { species = lead.species, personality = lead.personality,
    otId = lead.otId, exp = lead.exp, level = lead.level }
assert(Levels.adjust(edging, lead, 500, 5, threshold) == 0)
assert(Levels.banked(edging, boxed) == 500,
    "bank is identity based across PC movement")
boxed.species = 26 -- evolve without losing personality or original trainer
assert(Levels.banked(edging, boxed) == 500,
    "evolving must not orphan saved EXP bank")
assert(Levels.set(edging, "exp_edging", false))
assert(Levels.adjust(edging, lead, 40, 5, threshold) == 0)
assert(Levels.banked(edging, lead) == 500, "OFF preserves dormant bank")
assert(Levels.set(edging, "exp_edging", true))
assert(Levels.adjust(edging, lead, 0, nil, threshold) == 500,
    "uncapped next award releases saved EXP")
assert(Levels.banked(edging, lead) == 0)
edging.failed = true
assert(not Levels.set(edging, "level_cap_scope", 0),
    "failed run cannot alter level rule")

-- Native mod integration: hook invocation, Candy blocking, live UI.
local events, hooks, values = {}, {}, {}
package.loaded["src.core.game3.battle.experience"] = {
    expForLevel = threshold,
}
local candies = 0
package.loaded["src.core.game3.item_use"] = {
    useRareCandy = function() candies = candies + 1; return true end,
    fieldUseKind = function(id)
        return id == 68 and "level" or "heal"
    end,
}
local shown = {}
package.loaded["src.core.game3.battle.ui"] = {
    push = function(line) shown[#shown + 1] = line end,
}
package.loaded["src.core.game3.pokemon"] = {
    speciesOf = function(m) return m.species end,
    name = function() return "PIKACHU" end,
    isShiny = function() return false end,
}
local stack = { top = nil }
package.loaded["src.ui.game3.stack"] = {
    push = function(id, module) stack.top = {id = id, module = module} end,
    pop = function(id)
        assert(stack.top and stack.top.id == id)
        stack.top = nil
    end,
}
local session = { version = "firered", map = "FR_ROUTE_1",
    party = {mon("Spark", 1450, 14)}, flags = {} }
-- The *real* Game3 party screen never invokes item.use or
-- ItemUse.useRareCandy: it removes a Candy then writes mon.level directly.
local directCandyUses = 0
local nativeParty = {
    open = true, mode = "use", _item = 68, _session = session,
    _party = session.party, cursor = 1,
}
nativeParty.handleInput = function(input)
        if input:wasPressed("a") then
            directCandyUses = directCandyUses + 1
            nativeParty._party[nativeParty.cursor].level =
                nativeParty._party[nativeParty.cursor].level + 1
        end
    end
nativeParty.showMessage = function(message, callback)
    nativeParty.message = message
    nativeParty.mode = "message"
    nativeParty.dismiss = callback
end
package.loaded["src.ui.game3.party_menu"] = nativeParty
local game = { generation = 3, session = session }
local mod = { game = game, exports = {},
    save = {
        get = function(_, key, default) return values[key] or default end,
        set = function(_, key, value) values[key] = value end,
    },
    events = { on = function(_, name, fn) events[name] = fn end },
    hooks = { wrap = function(_, name, fn) hooks[name] = fn end },
    read = function(_, path)
        local f = assert(io.open(path, "rb"))
        local text = f:read("*a"); f:close()
        return text
    end,
}
assert(loadfile("gen3_runtime.lua")()(mod) == nil)
assert(mod.exports.gen3_core.setRule("nuzlocke_enabled", true))
local api = mod.exports.gen3_levels
assert(api.setRule("level_cap_scope", 1))
assert(api.setRule("exp_edging", true))
local original = session.party[1]
local battle = { playerParty = { original } }
events["battle.started"]({ battle = battle, kind = "trainer" })
nativeParty.handleInput({
    wasPressed = function(_, button) return button == "a" end,
})
assert(directCandyUses == 0 and original.level == 14,
    "native PartyMenu Candy branch must be cancelled before it changes level")
assert(nativeParty.message:find("Lv 14", 1, true)
    and nativeParty.mode == "message",
    "direct party-menu denial must show the cap explanation")
nativeParty.dismiss()
assert(nativeParty.mode == "use", "dismiss returns to party item-use mode")
local composed = 0
local exp = hooks["exp.gain"](function()
    composed = composed + 1; return 200
end, { mon = original, battle = battle })
assert(exp == 49 and composed == 1, "native EXP clamps to Brock cap")
assert(api.getBank(original) == 151)
events["battle.exp_gained"]({mon = original, gained = exp})
assert(#shown > 0 and shown[#shown]:find("151 EXP banked", 1, true),
    "battle should explain the capped EXP")
assert(package.loaded["src.core.game3.item_use"].useRareCandy(session, original) == false,
    "Rare Candy blocked at cap")
assert(candies == 0)
-- Real field use goes through the item.use mod hook, before item depletion.
local nativeUses = 0
local function nextItem()
    nativeUses = nativeUses + 1
    return true, "level", "Levelled up"
end
local used, kind, reason = hooks["item.use"](nextItem, game, nil, 68, 1, {})
assert(used == false and kind == "noeffect" and
    reason:find("Lv 14", 1, true) and nativeUses == 0,
    "Rare Candy transaction must fail before native use/consumption")
assert(mod.exports.gen3_notices.history()[#mod.exports.gen3_notices.history()].code
    == "LEVEL_CAP_ITEM", "denied item explained in notice history")
events["battle.ended"]({ battle = battle, result = "win" })
session.flags[0x820] = true
original.level, original.exp = 15, 1500
nativeParty.handleInput({
    wasPressed = function(_, button) return button == "a" end,
})
assert(directCandyUses == 1 and original.level == 16,
    "party-menu Candy delegates normally when below next cap")
assert(package.loaded["src.core.game3.item_use"].useRareCandy(session, original) == true)
assert(candies == 1, "Candy delegates below next cap")
local okItem = hooks["item.use"](nextItem, game, nil, 68, 1, {})
assert(okItem and nativeUses == 1, "field use below cap delegates")
local after = hooks["exp.gain"](function() return 25 end,
    { mon = original })
assert(after == 176 and api.getBank(original) == 0,
    "next award releases bank without bypassing composed amount")

assert(mod.exports.gen3_menu.open(game))
local menu = mod.exports.gen3_menu
local catalog = menu.catalog()
for _, category in ipairs(catalog) do
    assert(category.title ~= "BATTLE MECHANICS")
end
local function key(value)
    stack.top.module.handleInput({
        wasPressed = function(_, name) return value == name end
    })
end
key("a") -- Rules
assert(menu.model().rows[1] == "CORE"
    and menu.model().rows[2] == "CLAUSES",
    "CORE/CLAUSES category WIP labels removed")
for _ = 1, 5 do key("down") end -- LEVELS is sixth category
assert(menu.model().rows[6] == "LEVELS")
key("a")
assert(menu.model().title == "LEVELS"
    and menu.model().rows[1] == "CAP SCOPE: GYMS"
    and menu.model().rows[2] == "EXP EDGING: ON")
key("a")
assert(menu.model().rows[1] == "CAP SCOPE: ELITE FOUR")
key("down"); key("a")
assert(menu.model().rows[2] == "EXP EDGING: OFF")
key("b"); key("b"); key("b")
assert(stack.top == nil)
-- Field Items integration uses the *real* Gen 3 alternate seams:
-- item.use, direct ItemUse methods, native PartyMenu and field move table.
local field=mod.exports.gen3_field_items
local ItemUse=package.loaded["src.core.game3.item_use"]
local itemCalls={tm=0,escape=0,pp=0}
ItemUse.useTm=function() itemCalls.tm=itemCalls.tm+1;return true,"tm" end
ItemUse.useEscapeRope=function() itemCalls.escape=itemCalls.escape+1;return true end
ItemUse.applyPpItem=function() itemCalls.pp=itemCalls.pp+1;return true end
ItemUse.ppItemBoosts=function(id) return id==69 or id==71 end
ItemUse.fieldUseKind=function(id)
    if id==68 then return "level" end
    if id==83 or id==84 or id==86 then return "repel" end
    if id==85 then return "escape" end
    if id==34 or id==69 or id==71 or id==138 then return "pp" end
    if id==289 or id==339 then return "tm" end
    if id==13 or id==139 then return "heal" end
    if id==23 then return "status" end
    if id==24 then return "revive" end
    return "none"
end
local items={
    toNumericId=function(id) return tonumber(id) end,
    medicineKind=function(id)
        if id==13 or id==139 then return "heal" end
        if id==23 then return "status" end
        if id==24 then return "revive" end
        return "none"
    end,
    isTm=function(id) return id==289 or id==339 end,
    isHm=function(id) return id==339 end,
}
package.loaded["src.core.game3.items_data"]=items
local travelCalls={fly=0,teleport=0}
local moves={
    MOVES={FLY=19,TELEPORT=100},
    flyFromMenu=function(ctx)
        travelCalls.fly=travelCalls.fly+1
        return {ok=true,action="fly"}
    end,
    teleportFromMenu=function(ctx)
        travelCalls.teleport=travelCalls.teleport+1
        return {ok=true,action="teleport"}
    end,
}
moves.MENU_HANDLERS={
    [19]=moves.flyFromMenu,[100]=moves.teleportFromMenu
}
package.loaded["src.core.game3.field_moves"]=moves
events["map.entered"]({mapId="FR_ROUTE_1"})
local function fieldUse(id)
    return hooks["item.use"](function()
        nativeUses=nativeUses+1
        return true,"used"
    end,game,nil,id,1,{})
end
for _,case in ipairs({
    {"no_repels",86},
    {"no_escape_rope",85},
    {"no_field_healing",13},
    {"no_pp_items",34},
    {"no_tm_use",289},
    {"no_rare_candy_use",68},
}) do
    assert(field.setRule(case[1],true))
    local before=nativeUses
    local ok,kind,message=fieldUse(case[2])
    assert(ok==false and kind=="noeffect"
        and nativeUses==before and type(message)=="string",
        "field item.use must deny before native consumption: "..case[1])
end
assert(fieldUse(339)==true,"HM is legal under No TMs")
assert(fieldUse(93)==true,"evolution stone is unaffected")
assert(ItemUse.useTm(session,{},289,1)==false and itemCalls.tm==0,
    "direct TM teaching must be blocked")
assert(ItemUse.useTm(session,{},339,1)==true and itemCalls.tm==1,
    "direct HM teaching remains legal")
assert(ItemUse.useEscapeRope(session,{},85)==false
    and itemCalls.escape==0,"direct Escape Rope cannot bypass field hook")
assert(ItemUse.applyPpItem(original,69,1,nil,session)==false
    and itemCalls.pp==0,"direct PP Up mutation must be denied")
assert(ItemUse.applyPpItem(original,71,1,nil,session)==false
    and itemCalls.pp==0,"direct PP Max mutation must be denied")
assert(ItemUse.useRareCandy(session,original)==false
    and candies==1,"direct Rare Candy remains unused even under its level cap")
local partyInput={
    wasPressed=function(_,button)return button=="a" end
}
nativeParty.mode="use"
nativeParty.open=true
nativeParty._onSelect=nil
nativeParty._item=289
local partyBefore=directCandyUses
nativeParty.handleInput(partyInput)
assert(directCandyUses==partyBefore
    and nativeParty.message:find("No TMs",1,true),
    "native PartyMenu must deny TM before changing moves or bag")
nativeParty.dismiss()
nativeParty._item=68
nativeParty.handleInput(partyInput)
assert(directCandyUses==partyBefore
    and nativeParty.message:find("No Rare Candy",1,true),
    "native PartyMenu must deny candy before leveling/consuming")
nativeParty.dismiss()
nativeParty._item=339
nativeParty.handleInput(partyInput)
assert(directCandyUses==partyBefore+1,"HM selection remains delegated")
nativeParty._item=34
nativeParty.handleInput(partyInput)
assert(directCandyUses==partyBefore+1
    and nativeParty.message:find("No PP Items",1,true),
    "PP item PartyMenu use must be refused before its native action")
nativeParty.dismiss()
assert(field.setRule("travel_restrictions",1))
assert(moves.MENU_HANDLERS[19]({}).ok==false
    and travelCalls.fly==0,"captured menu Fly dispatch must be blocked")
assert(moves.MENU_HANDLERS[100]({}).ok
    and travelCalls.teleport==1,"NO FLY preserves Teleport")
assert(field.setRule("travel_restrictions",2))
assert(moves.teleportFromMenu({}).ok==false
    and travelCalls.teleport==1,"NO FLY+TELEPORT blocks player menu")
assert(field.setRule("travel_restrictions",0))
assert(moves.MENU_HANDLERS[19]({}).ok
    and travelCalls.fly==1,"normal Fly restored without reinstalling")
assert(moves.MENU_HANDLERS[100]({}).ok
    and travelCalls.teleport==2)
-- PP restriction is the only FIELD rule also relevant to BattleItems.
local battleUseCalls=0
local nativeItems={
    isBall=function() return false end,
    isStatBooster=function() return false end,
    isBattleUsable=function()return true end,
    canUseOn=function()return true end,
    use=function()
        battleUseCalls=battleUseCalls+1;return "heal",{},true,false
    end,
}
package.loaded["src.core.game3.battle.items"]=nativeItems
local trainer={session=session}
events["battle.started"]({battle=trainer,kind="trainer",speciesId=25})
assert(nativeItems.isBattleUsable(34)==false)
assert(select(1,nativeItems.canUseOn(trainer,34,1,original))==false)
local result,_,turn=nativeItems.use(trainer,nil,{},session,34,1)
assert(result=="error" and not turn and battleUseCalls==0,
    "PP item denied during battle before turn/inventory mutation")
assert(nativeItems.isBattleUsable(13)==true,
    "No Field Heal must not automatically ban in-battle Potion")
events["battle.ended"]({battle=trainer,result="win"})
assert(mod.exports.gen3_core.setRule("nuzlocke_enabled",false))
assert(fieldUse(68)==true,"master OFF restores field candy use")
assert(moves.MENU_HANDLERS[19]({}).ok
    and moves.MENU_HANDLERS[100]({}).ok)
assert(field.getRule("no_tm_use")==true and field.getRule("no_pp_items")==true,
    "master toggle must not clear the selected field rules")
print("Gen3 LEVELS, Field Items native bag/party/travel/battle: PASS")
