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

-- 2.5.21: reward recognition and league progression must use the same
-- trainer identity surface. Gen 1 primarily exposes oppClass, while Gold and
-- compatibility providers may carry classId/class on battle.trainer instead.
-- Normalize each semantic field once so sibling systems cannot drift between
-- id/name-only and id/class/name matching.
local function trainerIdentityKeys(battle)
    local trainer = battle and battle.trainer
    local function firstKey(...)
        for i = 1, select("#", ...) do
            local key = compactTrainerIdentity(select(i, ...))
            if key ~= "" then return key end
        end
        return ""
    end
    return {
        id = firstKey(
            trainer and trainer.id,
            battle and battle.trainerId,
            battle and battle.opponentId),
        class = firstKey(
            battle and battle.oppClass,
            battle and battle.trainerClass,
            battle and battle.opponentClass,
            trainer and trainer.classId,
            trainer and trainer.class),
        name = firstKey(
            trainer and trainer.name,
            battle and battle.trainerName,
            battle and battle.opponentName),
    }
end

local function trainerIdentityContains(identity, target)
    local targetKey = compactTrainerIdentity(target)
    if targetKey == "" then return false end
    return identity.id:find(targetKey, 1, true) ~= nil
        or identity.class:find(targetKey, 1, true) ~= nil
        or identity.name:find(targetKey, 1, true) ~= nil
end

local function trainerIdentityEquals(identity, target)
    local targetKey = compactTrainerIdentity(target)
    if targetKey == "" then return false end
    return identity.id == targetKey
        or identity.class == targetKey
        or identity.name == targetKey
end

local function trainerIdentityForReward(battle)
    local identity = trainerIdentityKeys(battle)
    -- Normalize semantic fields independently, then join them. The reward
    -- ledger uses exact keys, so the boundaries must survive normalization.
    return identity.id .. ":" .. identity.class .. ":" .. identity.name
end

local function trainerMatchesLeader(battle, leader)
    return trainerIdentityContains(trainerIdentityKeys(battle), leader)
end

function M.forgivenessEnabled(game, battle)
    game = game or d.getCurrentGame()
    return d.shouldEnforceNuzlocke(game, battle)
        and math.floor(tonumber(
            mod.save:get("route_forgiveness", 0)) or 0) > 0
end

function M.forgivenessTokens()
    return math.max(0, math.floor(tonumber(
        mod.save:get("route_forgiveness_tokens", 0)) or 0))
end

function M.setForgivenessTokens(n)
    local game = d.getCurrentGame()
    if not d.canWriteNuzlockeSave(game) then return false end
    return mod.save:set("route_forgiveness_tokens",
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
            if not M.forgivenessEnabled(d.getCurrentGame(), nil) then return false end
            local qty = math.max(1, math.floor(tonumber(count) or 1))
            if M.setForgivenessTokens(M.forgivenessTokens() + qty) == false then
                return false
            end
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


-- 2.4.10: The published F. TOKEN price is intentionally ¥1,000,000, one yen
-- above the native six-digit wallet ceiling. Keep that public/design price,
-- but settle the transaction at the engine's representable wallet ceiling.
-- This is token-specific: normal Mart prices and the global wallet cap remain
-- untouched. UI integrations should continue to present ¥1,000,000.
function M.forgivenessTokenSettlementPrice(save)
    local advertised = math.max(0, math.floor(tonumber(
        mod.exports.__beta26.forgivenessTokenShopPrice) or 1000000))
    local ceiling = trainerWalletCeiling(save)
    if advertised > ceiling then
        return ceiling
    end
    return advertised
end

local function withForgivenessTokenStock(game, stock)
    if not M.forgivenessEnabled(game, nil) or type(stock) ~= "table" then
        return stock
    end
    if game and game.data then
        game.data.items = game.data.items or {}
        game.data.items[mod.exports.__beta26.forgivenessTokenShopId] = {
            id = mod.exports.__beta26.forgivenessTokenShopId,
            name = d.Strings("F. TOKEN"),
            price = M.forgivenessTokenSettlementPrice(game and game.save),
            nuzlockeAdvertisedPrice =
                mod.exports.__beta26.forgivenessTokenShopPrice,
            description = d.Strings(
                "Restores one failed area's encounter chance. Gym Leaders award these normally."),
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

    -- If an active economy provider owns Trainer Money, its final payout is
    -- authoritative. Do not rewrite the wallet at all; this avoids stacking a
    -- stale Nuzlocke multiplier on top of the provider's economy result.
    if d.externalRuleDelegation
        and d.externalRuleDelegation("trainer_money_multiplier", game) then
        return false
    end

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

function M.awardGymLeaderForgiveness(battle, result)
    -- 2.4.6: permanent Gym rewards require a real active battle.
    local game = battle and (battle.game or d.getCurrentGame()) or d.getCurrentGame()
    if not d.active(game, battle) then return false end
    if result ~= "win" or not M.forgivenessEnabled(game, battle) or not battle
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

    -- A Gym reward belongs to the Leader only. Ordinary Gym Trainers never
    -- mint Forgiveness Tokens. Unknown/foreign Gym identity fails closed for
    -- the reward rather than accidentally paying a normal trainer.
    if not leader or not trainerMatchesLeader(battle, leader) then
        return false
    end

    -- One award per defeated Gym Leader, permanently. Use a semantic leader
    -- key instead of trainer party identity so rematches/providers cannot
    -- generate a second reward for the same Gym.
    local ledger = mod.save:get(
        "route_forgiveness_gym_leaders", {})
    if type(ledger) ~= "table" then ledger = {} end
    local key = compactTrainerIdentity(leader)
    if key == "" or ledger[key] then return false end

    ledger[key] = true
    mod.save:set("route_forgiveness_gym_leaders", ledger)
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
    if not d.canWriteNuzlockeSave(game) then return false end
    local save = game and game.save
    if not save then return false end

    local identity = trainerIdentityKeys(battle)

    local ver = d.getGameVersion and d.getGameVersion() or "RED"
    local profile = d.VersionCompat.profiles[ver]
    if profile and profile.family == "GSC" then
        local progress = d.gscProgress(save)
        for _, stage in ipairs(d.gscStages) do
            if trainerIdentityContains(identity, stage.name) then
                progress[stage.name] = true
                mod.save:set("nuzlocke_gsc_defeated", progress)
                return true
            end
        end
        return false
    end

    local gymProgressTable = d.gymProgress(save)
    for _, gymLeader in ipairs(d.levelCapGymLeaders) do
        if trainerIdentityContains(identity, gymLeader) then
            gymProgressTable[gymLeader] = true
            mod.save:set(d.gymProgressKey, gymProgressTable)
            return true
        end
    end

    for _, entry in ipairs(d.eliteFourCaps) do
        if trainerIdentityEquals(identity, entry.id)
            or trainerIdentityEquals(identity, entry.name) then
            local defeated = d.eliteFourDefeated()
            defeated[entry.id] = true
            mod.save:set("nuzlocke_e4_defeated", defeated)
            return true
        end
    end

    if d.currentGymProgressCount(save) >= 8
        and not d.nextEliteFourCapInfo()
        and (trainerIdentityContains(identity, "RIVAL")
            or trainerIdentityContains(identity, "BLUE")
            or trainerIdentityContains(identity, "CHAMPION")) then
        mod.save:set("nuzlocke_champion_defeated", true)
        return true
    end
    return false
end

function M.install(ownerMod, supplied)
    mod = assert(ownerMod, "trainer rewards requires mod")
    d = supplied or {}

    for _, key in ipairs({
        "Strings", "active", "canWriteNuzlockeSave", "shouldEnforceNuzlocke",
        "isTrainerBattle", "isSaveEditorSession",
        "worldMechanic", "worldRuleTriplet", "externalRuleDelegation",
        "pushWorldText",
        "worldRuleText", "getCurrentGame", "VersionCompat",
        "gscProgress", "gscStages", "levelCapGymLeaders",
        "gymProgress", "gymProgressKey", "eliteFourCaps", "eliteFourDefeated",
        "currentGymProgressCount", "nextEliteFourCapInfo",
    }) do
        assert(d[key] ~= nil, "trainer rewards missing dependency: " .. key)
    end

    mod.exports.__beta26.forgivenessTokens = M.forgivenessTokens
    mod.exports.__beta26.forgivenessTokenShopId =
        "NUZLOCKE_FORGIVENESS_TOKEN"
    mod.exports.__beta26.forgivenessTokenShopPrice = 1000000
    mod.exports.__beta26.forgivenessTokenSettlementPrice =
        M.forgivenessTokenSettlementPrice
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
