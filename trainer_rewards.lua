-- Trainer reward / economy compatibility module.
--
-- Explicitly approved as the second Lua split in 2.0.0-beta.30.0.0.16.
-- This module owns the cohesive trainer-reward subsystem:
--   * trainer wallet snapshot and Trainer Money multiplier
--   * Forgiveness Token counters, Gym-trainer rewards, and shop Bag bridge
--   * trainer identity normalization used by those rewards
--   * Gym / Elite Four / Champion progression bookkeeping
--
-- It does NOT own core battle rules, encounter legality, faint/death handling,
-- tracker state, randomizers, title setup, general provider policy, or Gold
-- gameplay systems.
--
-- It is loaded through Gen1Recomp's documented sandbox-safe
-- load(mod:read(...)) multi-file pattern.

local M = {}

local TRAINER_MONEY_PCTS = {
    [0]=0, [1]=25, [2]=50, [3]=75, [4]=100,
    [5]=150, [6]=200, [7]=300, [8]=500,
}
local trainerMoneyStart = setmetatable({}, { __mode = "k" })

local mod
local d

local function trainerWalletValue(save)
    if type(save) ~= "table" then return nil end
    if tonumber(save.money) ~= nil then
        return math.floor(tonumber(save.money))
    end
    if type(save.player) == "table"
        and tonumber(save.player.money) ~= nil then
        return math.floor(tonumber(save.player.money))
    end
    return nil
end

local function trainerWalletCeiling(save)
    if type(save) ~= "table" then return 999999 end
    local player = type(save.player) == "table" and save.player or nil
    local candidates = {
        { save, "maxMoney" }, { save, "moneyMax" }, { save, "walletCap" },
        { player, "maxMoney" }, { player, "moneyMax" }, { player, "walletCap" },
    }
    for _, candidate in ipairs(candidates) do
        local owner, key = candidate[1], candidate[2]
        local cap = owner and tonumber(owner[key]) or nil
        if cap and cap == cap and cap ~= math.huge and cap ~= -math.huge
            and cap >= 0 then
            return math.floor(cap)
        end
    end
    return math.max(999999, trainerWalletValue(save) or 0)
end

local function setTrainerWalletValue(save, value)
    if type(save) ~= "table" then return false end
    value = math.max(0, math.min(trainerWalletCeiling(save),
        math.floor(tonumber(value) or 0)))
    if tonumber(save.money) ~= nil then
        save.money = value
        return true
    end
    if type(save.player) == "table"
        and tonumber(save.player.money) ~= nil then
        save.player.money = value
        return true
    end
    return false
end

local function compactTrainerIdentity(value)
    return tostring(value or ""):upper():gsub("[^A-Z0-9]", "")
end

local function trainerIdentityForReward(battle)
    local trainer = battle and battle.trainer
    local id = trainer and trainer.id
        or battle and (battle.trainerId or battle.opponentId)
    local name = trainer and trainer.name
        or battle and (battle.trainerName or battle.opponentName)
    local class = battle
        and (battle.oppClass or battle.trainerClass or battle.opponentClass)
    return tostring(id or "") .. "|" .. tostring(class or "")
        .. "|" .. tostring(name or "")
end

function M.forgivenessEnabled()
    return mod.save:get("nuzlocke_enabled", true) == true
        and math.floor(tonumber(
            mod.save:get("route_forgiveness", 0)) or 0) > 0
end

function M.forgivenessTokens()
    return math.max(0, math.floor(tonumber(
        mod.save:get("route_forgiveness_tokens", 0)) or 0))
end

function M.setForgivenessTokens(n)
    mod.save:set("route_forgiveness_tokens",
        math.max(0, math.floor(tonumber(n) or 0)))
end

local function installForgivenessTokenBagBridge()
    if d.isSaveEditorSession() then return true end
    local ok, Bag = pcall(require, "src.inventory.Bag")
    if not ok or type(Bag) ~= "table"
        or type(Bag.add) ~= "function" then
        return false
    end

    local session = Bag.__nuzlockeForgivenessTokenSession
    if type(session) == "table" and session.owner == mod
        and Bag.add == session.wrapper then
        return true
    end
    if type(session) == "table" and session.owner ~= mod
        and Bag.add == session.wrapper
        and type(session.previous) == "function" then
        Bag.add = session.previous
    end

    local previous = Bag.add
    local wrapper
    wrapper = function(save, itemId, count, data, ...)
        if tostring(itemId or "")
            == mod.exports.__beta26.forgivenessTokenShopId then
            if not M.forgivenessEnabled() then return false end
            local qty = math.max(1, math.floor(tonumber(count) or 1))
            M.setForgivenessTokens(M.forgivenessTokens() + qty)
            return true
        end
        return previous(save, itemId, count, data, ...)
    end

    Bag.add = wrapper
    Bag.__nuzlockeForgivenessTokenSession = {
        owner = mod, previous = previous, wrapper = wrapper,
    }
    return true
end

local function withForgivenessTokenStock(game, stock)
    if not M.forgivenessEnabled() or type(stock) ~= "table" then
        return stock
    end
    if game and game.data then
        game.data.items = game.data.items or {}
        game.data.items[mod.exports.__beta26.forgivenessTokenShopId] = {
            id = mod.exports.__beta26.forgivenessTokenShopId,
            name = d.Strings("FORGIVE TOKEN"),
            price = mod.exports.__beta26.forgivenessTokenShopPrice,
            description = d.Strings(
                "Restores one failed area's encounter chance. Gym Trainers award these normally."),
            keyItem = true, tossable = false, canToss = false,
        }
    end
    local out, found = {}, false
    for i, id in ipairs(stock) do
        out[i] = id
        if tostring(id)
            == mod.exports.__beta26.forgivenessTokenShopId then
            found = true
        end
    end
    if not found then
        out[#out + 1] = mod.exports.__beta26.forgivenessTokenShopId
    end
    return out
end

function M.rememberWallet(game, battle)
    if not battle or not game or not game.save
        or not d.active(game, battle)
        or not d.isTrainerBattle(battle) then
        return false
    end
    local wallet = trainerWalletValue(game.save)
    if wallet == nil then return false end
    trainerMoneyStart[battle] = wallet
    return true
end

function M.scaleTrainerMoney(battle, result)
    local start = trainerMoneyStart[battle]
    trainerMoneyStart[battle] = nil
    if result ~= "win" or start == nil or not battle
        or not d.isTrainerBattle(battle) then
        return false
    end

    local game = battle.game or d.getCurrentGame()
    if not d.active(game, battle) then return false end
    local save = game and game.save
    if not save then return false end

    local now = trainerWalletValue(save)
    if now == nil then return false end
    local gained = math.max(0, now - start)
    if gained <= 0 then return false end

    local idx = math.max(0, math.min(8,
        math.floor(tonumber(mod.save:get(
            "trainer_money_multiplier", 4)) or 4)))
    local pct = TRAINER_MONEY_PCTS[idx] or 100
    local desired = math.floor(gained * pct / 100)
    setTrainerWalletValue(save, start + desired)

    if idx ~= 4 and game then
        local t1, t2, t3 = d.worldRuleTriplet(
            game, "trainer_money_multiplier")
        d.worldMechanic(game,
            "trainer_money:" .. tostring(idx), t1, t2, t3)
    end
    return true
end

function M.awardGymTrainerForgiveness(battle, result)
    if result ~= "win" or not M.forgivenessEnabled() or not battle
        or not d.isTrainerBattle(battle) then
        return false
    end

    local game = battle.game or d.getCurrentGame()
    local mapId = game and game.overworld and game.overworld.map
        and game.overworld.map.id
        or game and game.save and game.save.player
        and game.save.player.map
    local leader = d.gymLeaderForMap
        and d.gymLeaderForMap(mapId, game)
    if not leader then return false end

    local who = compactTrainerIdentity(trainerIdentityForReward(battle))
    local leaderKey = tostring(leader):upper():gsub("[^A-Z0-9]", "")
    if leaderKey ~= "" and who:find(leaderKey, 1, true) then
        return false
    end

    local ledger = mod.save:get(
        "route_forgiveness_gym_trainers", {})
    if type(ledger) ~= "table" then ledger = {} end
    local key = tostring(mapId or "GYM") .. ":" .. who
    if ledger[key] then return false end

    ledger[key] = true
    mod.save:set("route_forgiveness_gym_trainers", ledger)
    M.setForgivenessTokens(M.forgivenessTokens() + 1)
    if game then
        pcall(d.pushWorldText, game,
            d.worldRuleText(game, "route_forgiveness_award"))
    end
    return true
end

function M.recordLeagueProgression(battle, result)
    if not battle or not d.isTrainerBattle(battle)
        or result ~= "win" then
        return false
    end

    local game = battle.game or d.getCurrentGame()
    local save = game and game.save
    if not save then return false end

    local trainer = battle.trainer
    local trainerId = trainer and trainer.id
    local trainerName = tostring((trainer and trainer.name)
        or battle.trainerName or battle.opponentName or ""):upper()
    local nameKey = compactTrainerIdentity(trainerName)
    local idKey = compactTrainerIdentity(trainerId)

    local ver = d.getGameVersion and d.getGameVersion() or "RED"
    local profile = d.VersionCompat.profiles[ver]
    if profile and profile.family == "GSC" then
        local key = nameKey .. idKey
        local progress = d.gscProgress(save)
        for _, stage in ipairs(d.gscStages) do
            local stageKey = compactTrainerIdentity(stage.name)
            if stageKey ~= "" and key:find(stageKey, 1, true) then
                progress[stage.name] = true
                mod.save:set("nuzlocke_gsc_defeated", progress)
                return true
            end
        end
        return false
    end

    local gymProgressTable = d.gymProgress(save)
    for _, gymLeader in ipairs(d.levelCapGymLeaders) do
        local leaderKey = compactTrainerIdentity(gymLeader)
        if (leaderKey ~= "" and nameKey:find(leaderKey, 1, true))
            or (leaderKey ~= "" and idKey:find(leaderKey, 1, true)) then
            gymProgressTable[gymLeader] = true
            mod.save:set(d.gymProgressKey, gymProgressTable)
            break
        end
    end

    for _, entry in ipairs(d.eliteFourCaps) do
        local entryIdKey = compactTrainerIdentity(entry.id)
        local entryNameKey = compactTrainerIdentity(entry.name)
        if (entryIdKey ~= "" and idKey == entryIdKey)
            or (entryNameKey ~= "" and nameKey == entryNameKey) then
            local defeated = d.eliteFourDefeated()
            defeated[entry.id] = true
            mod.save:set("nuzlocke_e4_defeated", defeated)
            return true
        end
    end

    local trainerKey = nameKey .. idKey
    if d.currentGymProgressCount(save) >= 8
        and not d.nextEliteFourCapInfo()
        and (trainerKey:find("RIVAL", 1, true)
            or trainerKey:find("BLUE", 1, true)
            or trainerKey:find("CHAMPION", 1, true)) then
        mod.save:set("nuzlocke_champion_defeated", true)
        return true
    end
    return false
end

function M.install(ownerMod, supplied)
    mod = assert(ownerMod, "trainer rewards requires mod")
    d = supplied or {}

    for _, key in ipairs({
        "Strings", "active", "isTrainerBattle", "isSaveEditorSession",
        "worldMechanic", "worldRuleTriplet", "pushWorldText",
        "worldRuleText", "getCurrentGame", "VersionCompat",
        "gscProgress", "gscStages", "levelCapGymLeaders",
        "gymProgress", "eliteFourCaps", "eliteFourDefeated",
        "currentGymProgressCount", "nextEliteFourCapInfo",
    }) do
        assert(d[key] ~= nil, "trainer rewards missing dependency: " .. key)
    end

    mod.exports.__beta26.forgivenessTokens = M.forgivenessTokens
    mod.exports.__beta26.forgivenessTokenShopId =
        "NUZLOCKE_FORGIVENESS_TOKEN"
    mod.exports.__beta26.forgivenessTokenShopPrice = 1000000
    mod.exports.__beta26.installForgivenessTokenBagBridge =
        installForgivenessTokenBagBridge
    mod.exports.__beta26.withForgivenessTokenStock =
        withForgivenessTokenStock

    pcall(installForgivenessTokenBagBridge)
    mod.events:on("game.ready",
        function() pcall(installForgivenessTokenBagBridge) end)
    mod.events:on("save.loaded",
        function() pcall(installForgivenessTokenBagBridge) end)
    return true
end

return M
