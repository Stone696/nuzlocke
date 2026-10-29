-- Gen 3 UI regression: locked choices, native starter naming, full text.
local events, hooks, saved = {}, {}, {}
local msg = { pageText = "", skips = 0 }
msg.currentPage = function() return msg.pageText end
msg.show = function(text, opts)
    msg.showSpeed = opts and opts.speed
    return msg
end
msg.advance = function() msg.advanceCount = (msg.advanceCount or 0) + 1 end
msg.tick = function() msg.tickCount = (msg.tickCount or 0) + 1 end
msg.skipReveal = function() msg.skips = msg.skips + 1 end
package.loaded["src.ui.game3.message"] = msg
local asked = 0
local choice = {}
choice.yesNo = function(cb)
    asked = asked + 1
    choice.pending = cb
end
package.loaded["src.ui.game3.choice"] = choice
local ui = {}
ui.askYesNo = function(_, cb)
    ui.pending = cb
end
package.loaded["src.core.game3.battle.ui"] = ui
local naming = {}
naming.open = function(opts)
    naming.opened = (naming.opened or 0) + 1
    naming.last = opts
end
package.loaded["src.ui.game3.naming"] = naming

local nativePrinter = { AUTO_SCROLL = 2 }
nativePrinter.open = function(p)
    nativePrinter.current = p
    return true
end
nativePrinter.tick = function()
    local p = nativePrinter.current
    if not p then return end
    if p.task < 2 then p.task = p.task + 1; return end
    if p.printer == "pause" then p.delay = p.delay - 1; return end
    if p.printer == "char_delay" and p.delay > 0 then
        p.delay = p.delay - 1
        return
    end
    if p.index < 5 then
        p.index = p.index + 1
        p.printer, p.delay = "char_delay", 3
    else
        p.printer, p.mode = "end", 0
    end
end
package.loaded["src.ui.game3.rs.field_auto_scroll_message"] = nativePrinter
local kit = { printer = function(_,opts)
    return {
        speed = opts.speed, state = "char", active = true, pos = 1,
        render = function(self)
            if self.pos < 4 then
                self.pos = self.pos + 1
                return "print"
            end
            self.state = "pause"
            self.paused = 30
            return "repeat"
        end,
        run = function(self)
            if self.state == "pause" then
                self.paused = self.paused - 1
                if self.paused == 0 then self.state = "char" end
            end
        end,
    }
end }
package.loaded["src.ui.game3.rse.scene_kit"] = kit
local intro = { new = function() return {textSpeed=4} end }
package.loaded["src.ui.game3.new_game_scene"] = intro
local stack = {}
package.loaded["src.ui.game3.stack"] = {
    push = function(id, object) stack[#stack+1] = { id = id, object = object } end,
    pop = function(id)
        assert(stack[#stack] and stack[#stack].id == id)
        stack[#stack] = nil
    end,
}
local game = {generation=3, session = {map="FR_ROUTE_1",
    version="emerald",
    party={{species=25, personality=10, hp=20, level=5}}}}
local mod = {
    game = game, exports = {},
    save = {
        get = function(_,k,default) return saved[k] or default end,
        set = function(_,k,v) saved[k]=v end,
    },
    events = {on=function(_,n,cb) events[n]=cb end},
    hooks = {wrap=function(_,n,cb) hooks[n]=cb end},
    read = function(_,path)
        local f = assert(io.open(path,"rb"))
        local text = f:read("*a"); f:close()
        return text
    end,
}
assert(loadfile("gen3_runtime.lua")()(mod)==nil)
assert(mod.exports.gen3_core.setRule("nuzlocke_enabled",true))
events["save.loaded"]()
-- Field script starter question is not a battle catch nickname prompt.
msg.pageText = "Would you like to give a nickname to TREECKO?"
local starterAnswer
choice.yesNo(function(answer) starterAnswer = answer end)
assert(starterAnswer == true and asked == 0,
    "starter's native NO button must not be a way around Nickname Rule")
-- FireRed/LeafGreen use the same native field choice for the starter.
game.session.version = "firered"
msg.pageText = "Would you like to give a nickname to BULBASAUR?"
local frlgAnswer
choice.yesNo(function(answer) frlgAnswer = answer end)
assert(frlgAnswer == true and asked == 0,
    "FRLG starter nickname cannot be declined")
game.session.version = "emerald"
-- Other Yes/No choices remain vanilla, including NO.
msg.pageText = "Would you like to save your game?"
local ordinary
choice.yesNo(function(answer) ordinary=answer end)
assert(asked==1 and ordinary==nil)
choice.pending(false)
assert(ordinary==false, "unrelated field prompt must retain NO")
-- Starter's NICKNAME template is just as restricted as CAUGHT_MON.
local selected
naming.open({template="NICKNAME", species=25,
    onDone=function(name) selected=name end})
assert(naming.opened==1 and type(naming.last.onDone)=="function")
naming.last.onDone("")
assert(not selected and naming.opened==2,
    "empty starter nickname must reopen the naming screen")
naming.last.onDone("SPARK")
assert(selected=="SPARK", "custom starter nickname must be accepted")

local qol=mod.exports.gen3_qol
assert(qol.setRule("instant_text",true))
msg.show("first page",{})
assert(msg.showSpeed==0,"field dialogue must receive native instant speed")
local before=msg.skips
msg.advance()
msg.tick()
assert(msg.skips>=before+2,"new field pages must reveal in one frame")
local cutscene = kit.printer("intro",{speed=4})
assert(cutscene.speed==0 and cutscene.state=="pause"
    and cutscene.pos==4 and cutscene.paused==30,
    "RSE cutscene glyphs reveal instantly but explicit pause survives")
cutscene:run({})
assert(cutscene.paused==29,
    "RSE cutscene pause must advance only on a native printer frame")
assert(intro.new().textSpeed==0,
    "FRLG Professor Oak scene must use instant printer speed")
local prepared={task=0,mode=2,printer="begin",index=1,delay=0}
assert(nativePrinter.open(prepared))
nativePrinter.tick()
nativePrinter.tick()
assert(prepared.index==5,
    "RS field auto-scroll must flush all contiguous glyphs in one frame")
-- A scripted pause must not be skipped.
prepared={task=2,mode=2,printer="pause",index=1,delay=60}
nativePrinter.open(prepared)
nativePrinter.tick()
assert(prepared.index==1 and prepared.delay==59,
    "native RS pause remains under native timing control")

-- Locks must describe the real reason instead of COMING SOON.
assert(qol.setRule("instant_text",false))
saved.gen3_classic_v1.runSettingsLocked=true
assert(mod.exports.gen3_menu.open(game))
local function press(key)
    stack[#stack].object.handleInput({
        wasPressed=function(_,button) return button==key end,
    })
end
press("a") -- NUZ RULES
press("a") -- CORE
press("a") -- try Nuzlocke toggle
assert(mod.exports.gen3_menu.model().title=="SETTINGS LOCKED",
    "locked CORE option must not be reported as COMING SOON")
print("Gen 3 locked-menu, Instant Text, starter nickname smoke PASS")
