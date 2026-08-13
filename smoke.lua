-- Headless release smoke test for Nuzlocke Rules beta.27.16.
-- Usage: fengari smoke.lua /absolute/or/relative/path/to/main.lua

local source = assert(arg[1], "main.lua path required")

package.preload["src.pokemon.Stats"] = function() return {} end
package.preload["src.pokemon.Growth"] = function() return {} end
package.preload["src.core.Data"] = function()
  return { constants = { badges = {
    { id = "BOULDERBADGE" }, { id = "CASCADEBADGE" },
    { id = "THUNDERBADGE" }, { id = "RAINBOWBADGE" },
    { id = "SOULBADGE" }, { id = "MARSHBADGE" },
    { id = "VOLCANOBADGE" }, { id = "EARTHBADGE" },
  } } }
end
package.preload["src.script.MapScripts"] = function()
  return {
    baseTalk = function() return {} end,
    talkSource = function() return nil end,
  }
end

local specialCalls = { handlerSlots = 0, allSlots = 0, allCards = 0 }
local originalHandlerSlots = function()
  specialCalls.handlerSlots = specialCalls.handlerSlots + 1
end
local originalAllSlots = function()
  specialCalls.allSlots = specialCalls.allSlots + 1
end
local originalAllCards = function()
  specialCalls.allCards = specialCalls.allCards + 1
end
local gen2Specials = {
  HANDLERS = { SlotMachine = originalHandlerSlots },
  ALL = { SlotMachine = originalAllSlots, CardFlip = originalAllCards },
}
function gen2Specials.block(_, start)
  local answer
  start(function(value) answer = value end)
  return answer
end
package.preload["src.script.gen2.Specials"] = function() return gen2Specials end

local nicknameCalls = { answer = {}, accepted = 0 }
local goldItemCalls = 0
local gen2BattleState = {}
local originalGoldAnswerNickname = function(_, yes)
  nicknameCalls.answer[#nicknameCalls.answer + 1] = yes
  return yes
end
gen2BattleState.answerNickname = originalGoldAnswerNickname
gen2BattleState.useItem = function()
  goldItemCalls = goldItemCalls + 1
  return "vanilla-item"
end
package.preload["src.ui.gen2.BattleState"] = function() return gen2BattleState end

local nicknameType = {}
local gen2NamingScreen = { TYPES = { nickname = nicknameType } }
local originalGoldAccept = function(self)
  nicknameCalls.accepted = nicknameCalls.accepted + 1
  if self.onDone then self.onDone(self.text) end
  return self.text
end
gen2NamingScreen.accept = originalGoldAccept
package.preload["src.ui.gen2.NamingScreen"] = function() return gen2NamingScreen end

local function registry()
  local out = { values = {} }
  function out:register(id, value) self.values[id] = value end
  return out
end

local store = {}
local eventHandlers, hookHandlers = {}, {}
local otherMods = {}
local mod = {
  exports = {},
  save = {
    get = function(_, key, fallback)
      local value = store[key]
      if value == nil then return fallback end
      return value
    end,
    set = function(_, key, value) store[key] = value end,
  },
  events = {
    on = function(_, name, fn)
      eventHandlers[name] = eventHandlers[name] or {}
      eventHandlers[name][#eventHandlers[name] + 1] = fn
    end,
  },
  hooks = {
    wrap = function(_, name, fn)
      hookHandlers[name] = hookHandlers[name] or {}
      hookHandlers[name][#hookHandlers[name] + 1] = fn
    end,
  },
  content = {
    screens = registry(), commands = registry(), map_scripts = registry(),
  },
  ui = {
    push = function() end,
    insertBefore = function(items, label, value)
      for i, item in ipairs(items) do
        if item.label == label then table.insert(items, i, value); return true end
      end
      return false
    end,
  },
}
mod.find = function(id) return otherMods[id] end

local function emit(name, payload)
  for _, fn in ipairs(eventHandlers[name] or {}) do fn(payload) end
end

local function callHook(name, base, ...)
  local handlers = hookHandlers[name] or {}
  local function at(index, ...)
    local fn = handlers[index]
    if not fn then return base(...) end
    return fn(function(...) return at(index + 1, ...) end, ...)
  end
  return at(1, ...)
end

local function check(value, message)
  if not value then error("FAIL: " .. message, 2) end
  print("PASS: " .. message)
end

local entry = assert(loadfile(source))()
check(type(entry) == "function", "entry chunk returns a function")
entry(mod)
check(mod.exports.__beta26.build == "beta.27.16", "build id")
check(mod.exports.nuzlocke_compat.version == 22, "compat API version")
check(mod.exports.nuzlocke_compat.getCompatibilityReport().api == 22,
  "compat report API matches")

emit("save.loaded", {})

local red = {
  version = "RED",
  data = {
    pokemon = {}, maps = {},
    trainers = {
      OPP_BROCK = { parties = { { { species = "GEODUDE", level = 16 },
        { species = "ONIX", level = 18 } } } },
      OPP_MISTY = { parties = { { { species = "STARYU", level = 14 },
        { species = "STARMIE", level = 15 } } } },
    },
  },
  save = { inventory = {}, party = {}, boxes = {},
    player = { map = "PALLET_TOWN" }, flags = {} },
  stack = { push = function() end },
}
mod.game = red
emit("game.ready", { game = red })
store.nuzlocke_enabled = true
store.level_cap_scope = 1
store.nuzlocke_gym_defeated = {}
local info = mod.exports.__beta26.getNextLevelCapInfo(red.save)
local cap, boss = info.cap, info.boss
check(cap == 18 and boss == "BROCK", "merged Gen 1 trainer ace drives cap (got "
  .. tostring(cap) .. "/" .. tostring(boss) .. ")")

store.nuzlocke_gym_defeated = { BROCK = true }
info = mod.exports.__beta26.getNextLevelCapInfo(red.save)
cap, boss = info.cap, info.boss
check(cap == 18 and boss == "MISTY", "cap floor never regresses after a modded boss")

local function labels(items)
  local out = {}
  for _, item in ipairs(items) do out[#out + 1] = item.label end
  return table.concat(out, "|")
end
local redNew = callHook("ui.title_menu.items", function(_, items) return items end,
  red, { { label = "NEW GAME", onSelect = function() end },
    { label = "OPTION", onSelect = function() end } })
check(labels(redNew):find("SETUP|NEW GAME", 1, true) ~= nil,
  "Gen 1 new-save menu shows Setup")
local redSave = callHook("ui.title_menu.items", function(_, items) return items end,
  red, { { label = "CONTINUE", onSelect = function() end },
    { label = "NEW GAME", onSelect = function() end } })
check(labels(redSave):find("SETUP", 1, true) == nil,
  "Gen 1 existing-save menu hides Setup")

local gold = {
  version = "GOLD",
  data = {
    pokemon = {}, maps = {},
    items = {
      POKE_BALL = { pocket = "BALL" },
      GREAT_BALL = { pocket = "BALL" },
      ULTRA_BALL = { pocket = "BALL" },
      MASTER_BALL = { pocket = "BALL" },
      LOVE_BALL = { pocket = "BALL" },
    },
    trainers = { classes = {
      FALKNER = { index = 1, name = "LEADER", trainers = {
        { index = 1, id = "FALKNER1", name = "FALKNER",
          party = { { species = "PIDGEY", level = 10 },
            { species = "PIDGEOTTO", level = 12 } } },
      } },
      BUGSY = { index = 3, name = "LEADER", trainers = {
        { index = 1, id = "BUGSY1", name = "BUGSY",
          party = { { species = "SCYTHER", level = 19 } } },
      } },
    } },
  },
  save = { inventory = {}, party = {}, boxes = {}, flags = {},
    player = { map = "NEW_BARK_TOWN", badges = {}, kantoBadges = {} } },
  stack = { push = function() end },
}
mod.game = gold
emit("game.ready", { game = gold })
store.nickname_rule = true
check(mod.exports.__beta26.goldBetaRules.nickname_rule == true,
  "Gold config surface exposes Nickname Rule")
check(gen2BattleState.answerNickname({ game = gold, battle = {} }, false) == true
    and nicknameCalls.answer[#nicknameCalls.answer] == true,
  "Gold catch cannot decline Nickname Rule prompt")
local blankName = { game = gold, kind = nicknameType, text = "   " }
gen2NamingScreen.accept(blankName)
check(nicknameCalls.accepted == 0,
  "Gold Nickname Rule rejects empty and all-space names")
blankName.text = "BLAZE"
gen2NamingScreen.accept(blankName)
check(nicknameCalls.accepted == 1,
  "Gold Nickname Rule accepts a non-empty name")
local oldNicknameAnswerSession = gen2BattleState.__nuzlockeNicknameAnswerSession
local oldNicknameAcceptSession = gen2NamingScreen.__nuzlockeNicknameAcceptSession
oldNicknameAnswerSession.owner = {}
oldNicknameAcceptSession.owner = {}
emit("game.ready", { game = gold })
check(gen2BattleState.__nuzlockeNicknameAnswerSession.previous
      == originalGoldAnswerNickname
    and gen2NamingScreen.__nuzlockeNicknameAcceptSession.previous
      == originalGoldAccept,
  "Gold nickname wrappers restore their exact prior session methods")
store.no_static_encounters = true
gold.save.player.map = "ROUTE_36"
local stockStaticState = { game = gold, tutorial = false, battle = {
  wild = true, nuzlockeStaticEncounter = true,
  enemy = { species = "SUDOWOODO" },
} }
gen2BattleState.useItem(stockStaticState, "POKE_BALL")
check(stockStaticState.message == "Static catches are turned OFF."
    and goldItemCalls == 0,
  "Gold native scripted-wild static catch is blocked before Ball use")
local compatStaticState = { game = gold, tutorial = false, battle = {
  wild = false, fixedEncounter = true,
  enemy = { species = "SUDOWOODO" },
} }
gen2BattleState.useItem(compatStaticState, "POKE_BALL")
check(compatStaticState.message == "Static catches are turned OFF."
    and goldItemCalls == 0,
  "Gold mod-created fixed battle is admitted by static provenance")
store.no_static_encounters = false
check(gen2BattleState.useItem(compatStaticState, "POKE_BALL") == "vanilla-item"
    and goldItemCalls == 1,
  "Gold compatibility broadening preserves vanilla behavior when rule is off")
gold.save.player.map = "NEW_BARK_TOWN"
local ballContext = { data = gold.data, save = gold.save, isBall = true,
  inBattle = true, battle = { game = gold, wild = true } }
store.ball_use_ban_tier = 3
local ballAllowed = mod.exports.nuzlocke_compat.canUseItem(
  gold, "MASTER_BALL", ballContext)
check(ballAllowed == true,
  "Ball tier ULTRA still allows the stronger Master Ball")
store.ball_use_ban_tier = 4
local masterAllowed, masterReason, masterDecision =
  mod.exports.nuzlocke_compat.canUseItem(gold, "MASTER_BALL", ballContext)
local loveAllowed = mod.exports.nuzlocke_compat.canUseItem(
  gold, "LOVE_BALL", ballContext)
check(masterAllowed == false and masterReason == "ball_use_ban"
    and loveAllowed == true,
  "Ball tier STANDARD bans all standard Balls but permits specialty Balls")
check(masterDecision and masterDecision.tier2
    == "Standard Balls are banned. Specialty/custom Balls remain eligible."
    and not masterDecision.tier2:find("stronger", 1, true),
  "STANDARD denial guidance accurately identifies remaining Ball scope")
store.ball_use_ban_tier = 5
local allAllowed, allReason, allDecision =
  mod.exports.nuzlocke_compat.canUseItem(gold, "LOVE_BALL", ballContext)
check(allAllowed == false and allReason == "ball_use_ban"
    and allDecision.tier2 == "Every recognized Ball is banned by this rule.",
  "Ball tier ALL remains distinct and blocks specialty Balls")
store.ball_use_ban_tier = 0
check(mod.exports.__beta26.gameCornerMapIds.rbyPrizeRoom
    == "GAME_CORNER_PRIZE_ROOM"
    and mod.exports.__beta26.gameCornerMapIds.gscCeladonPrizeRoom
      == "CELADON_GAME_CORNER_PRIZE_ROOM",
  "generation-specific Game Corner map IDs stay distinct")
check(gen2Specials.HANDLERS.CardFlip == nil,
  "Gold gambling gate does not manufacture a missing HANDLERS entry")
gen2Specials.HANDLERS.SlotMachine({})
gen2Specials.ALL.SlotMachine({})
gen2Specials.ALL.CardFlip({})
check(specialCalls.handlerSlots == 1 and specialCalls.allSlots == 1
    and specialCalls.allCards == 1,
  "independent Gold special wrappers delegate to their own originals")
local oldSession = gen2Specials.__nuzlockeGamblingSession
oldSession.owner = {}
emit("game.ready", { game = gold })
local rebound = gen2Specials.__nuzlockeGamblingSession
check(rebound.methods.SlotMachine.previousHandlers == originalHandlerSlots
    and rebound.methods.SlotMachine.previousAll == originalAllSlots
    and rebound.methods.CardFlip.previousHandlers == nil
    and rebound.methods.CardFlip.previousAll == originalAllCards,
  "Gold special session restoration preserves each registry slot")
store.nuzlocke_gsc_defeated = {}
info = mod.exports.__beta26.getNextLevelCapInfo(gold.save)
cap, boss = info.cap, info.boss
check(cap == 12 and boss == "FALKNER", "merged Gold trainer ace drives cap")
gold.save.player.badges.ZEPHYR = true
info = mod.exports.__beta26.getNextLevelCapInfo(gold.save)
cap, boss = info.cap, info.boss
check(cap == 19 and boss == "BUGSY", "Gold badge seeding advances live cap")

for _, badge in ipairs({ "ZEPHYR", "HIVE", "PLAIN", "FOG", "MINERAL",
  "STORM", "GLACIER", "RISING" }) do gold.save.player.badges[badge] = true end
gold.save.flags.EVENT_BEAT_ELITE_4_WILL = true
store.level_cap_scope = 2
info = mod.exports.__beta26.getNextLevelCapInfo(gold.save)
check(info.cap == 44 and info.boss == "KOGA",
  "existing Gold save flags seed League progression")
emit("battle.ended", { result = "win", battle = {
  game = gold, wild = false,
  trainer = { class = "KOGA", name = "KOGA",
    party = { { species = "ARIADOS", level = 44 } } },
} })
info = mod.exports.__beta26.getNextLevelCapInfo(gold.save)
check(info.cap == 46 and info.boss == "BRUNO",
  "Gold trainer battles advance boss progression without kind field")
store.level_cap_scope = 1

local goldNew = callHook("ui.title_menu.items", function(_, items) return items end,
  gold, { { label = "NEW GAME", value = "new" },
    { label = "OPTION", value = "option" } })
check(labels(goldNew):find("SETUP|NEW GAME", 1, true) ~= nil,
  "Gold new-save menu shows Setup")
local goldSave = callHook("ui.title_menu.items", function(_, items) return items end,
  gold, { { label = "CONTINUE", value = "continue" },
    { label = "NEW GAME", value = "new" } })
check(labels(goldSave):find("SETUP", 1, true) == nil,
  "Gold existing-save menu hides Setup")

store.nuzlocke_first_rival_battle_seen = nil
store.first_rival_forgiveness = true
gold.save.player.badges = {}
local firstRival = { game = gold, wild = false,
  trainer = { class = "RIVAL1", name = "SILVER" },
  enemy = { species = "TOTODILE", level = 5 } }
check(mod.exports.__beta26.armFirstRivalForgiveness(gold, firstRival) == true
    and mod.exports.__beta26.isFirstRivalForgivenessActive(gold, firstRival),
  "opening Rival forgiveness arms when enabled")
local laterRival = { game = gold, wild = false,
  trainer = { class = "RIVAL2", name = "SILVER" },
  enemy = { species = "CROCONAW", level = 16 } }
check(mod.exports.__beta26.armFirstRivalForgiveness(gold, laterRival) == false,
  "Rival forgiveness cannot arm twice")

gold.save.party = {}
local giftRenameOptions
local giftVm = { specials = { renameMon = function(mon, done, opts)
  giftRenameOptions = opts
  done("BLAZE")
end } }
callHook("script.command", function(_, name)
  if name == "givepoke" then
    gold.save.party[#gold.save.party + 1] = { species = "CYNDAQUIL" }
  end
end, { generation = 2, mapId = "ELMS_LAB", vm = giftVm },
  "givepoke", { "CYNDAQUIL" }, { species = "CYNDAQUIL" })
check(gold.save.party[1] and gold.save.party[1].nickname == "BLAZE"
    and giftRenameOptions and giftRenameOptions.blank == true,
  "Gold scripted starter blocks on native naming and resumes with a name")

store.route_splits = 1
check(mod.exports.__beta26.cardinalPhysicalArea("ROUTE_1", 2, 2, 10, 20)
    == "ROUTE_1_NORTH", "cardinal route provenance uses coordinates")
check(mod.exports.__beta26.projectEncounterArea("ROUTE_1_NORTH")
    == "ROUTE_1_NORTH", "cardinal route projection ON")
store.tracker_log = { ROUTE_1_NORTH = { {
  species = "PIDGEY", encounterMapId = "ROUTE_1_NORTH",
} } }
store.encounter_states = { ROUTE_1_NORTH = {
  status = "CAUGHT", species = "PIDGEY",
  encounterMapId = "ROUTE_1_NORTH", consumedArea = true,
} }
store.caught_areas = { ROUTE_1_NORTH = "PIDGEY" }
store.route_splits = 0
mod.exports.__beta26.reprojectEncounterAreas()
check(type(store.tracker_log.ROUTE_1) == "table"
    and store.caught_areas.ROUTE_1 == "PIDGEY", "route projection groups OFF")
store.route_splits = 1
mod.exports.__beta26.reprojectEncounterAreas()
check(type(store.tracker_log.ROUTE_1_NORTH) == "table"
    and store.caught_areas.ROUTE_1_NORTH == "PIDGEY",
  "route projection restores CARDINAL without data loss")
store.mt_moon_splits = 0
check(mod.exports.__beta26.projectEncounterArea("MT_MOON_B1F") == "MT_MOON",
  "Mt. Moon OFF groups floors")
store.mt_moon_splits = 1
check(mod.exports.__beta26.projectEncounterArea("MT_MOON_B1F") == "MT_MOON_B1F",
  "Mt. Moon COMMON splits floors")
store.safari_zone_splits = 0
check(mod.exports.__beta26.projectEncounterArea("SAFARI_ZONE_EAST") == "SAFARI_ZONE",
  "Safari OFF groups areas")
store.safari_zone_splits = 1
check(mod.exports.__beta26.projectEncounterArea("SAFARI_ZONE_EAST")
    == "SAFARI_ZONE_EAST", "Safari COMMON splits areas")

red.data.pokemon.MEGA = { baseStats = { hp = 100, attack = 100,
  defense = 100, speed = 100, special = 100 } }
red.data.pokemon.UNKNOWN_STATS = { baseStats = { hp = 100 } }
red.save.player.map = "ROUTE_1"
mod.game = red
emit("game.ready", { game = red })
store.encounter_limit = false
store.maximum_bst = 450
store.allow_glitch_pokemon = false
store.no_static_encounters = false
store.shiny_clause = true
local allowed, reason = mod.exports.nuzlocke_compat.canCapture(red,
  { kind = "wild", game = red, enemy = { mon = { species = "MEGA" } } }, "MEGA")
check(allowed == false and reason == "bst", "Maximum BST blocks known over-limit catch")
allowed, reason = mod.exports.nuzlocke_compat.canCapture(red,
  { kind = "wild", game = red,
    enemy = { mon = { species = "UNKNOWN_STATS" } } }, "UNKNOWN_STATS")
check(allowed == true, "incomplete modded stat schema fails open")
allowed, reason = mod.exports.nuzlocke_compat.canCapture(red,
  { kind = "wild", game = red,
    enemy = { mon = { species = "MISSINGNO" } } }, "MISSINGNO")
check(allowed == false and reason == "glitch", "MissingNo is safely blocked by default")
store.allow_glitch_pokemon = true
allowed = mod.exports.nuzlocke_compat.canCapture(red,
  { kind = "wild", game = red,
    enemy = { mon = { species = "MISSINGNO" } } }, "MISSINGNO")
check(allowed == true, "Glitch Pokemon toggle permits MissingNo")
store.no_static_encounters = true
allowed, reason = mod.exports.nuzlocke_compat.canCapture(red,
  { kind = "wild", game = red, nuzlockeStaticEncounter = true,
    enemy = { mon = { species = "MEGA", shiny = true } } }, "MEGA")
check(allowed == false and reason == "static",
  "static ban takes precedence over Shiny Clause")
store.no_static_encounters = false
store.maximum_bst = 0

otherMods.capmod = {
  version = "1.0.0",
  exports = { nuzlocke_provider = { level_caps = {
    marker = true,
    getNextCap = function(self)
      assert(self.marker == true, "method receiver")
      return { levelCap = 41, trainer = "MOD BOSS" }
    end,
  } } },
}
emit("mods.loaded", { loader = { status = function()
  return { loaded = { { id = "capmod" } } }
end } })
info = mod.exports.__beta26.getNextLevelCapInfo(gold.save)
cap, boss = info.cap, info.boss
check(cap == 41 and boss == "MOD BOSS", "method-style cap provider aliases")

local cleaned = mod.exports.__beta26.cleanWorldText(
  "  One   line  ! \n  Next   line.  ")
check(cleaned == "One line!\nNext line.", "world text spacing normalization")

store.route_splits, store.mt_moon_splits, store.safari_zone_splits = 0, 0, 0
local splits = mod.exports.nuzlocke_compat.getEncounterSplitModes()
check(splits.routes == 0 and splits.mt_moon == 0 and splits.safari == 0,
  "all split modes support OFF")

print("SMOKE PASS")
