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

-- 2.5.57: executable active()-guard contracts for gameplay-state mutation.
-- The recurring failure class was a new reward/progression mutator being added
-- without the master-rule enforcement guard. Keep the contract beside the
-- subsystem it protects, and make intentional OFF-state persistence explicit.
local ACTIVE_GUARD_CONTRACTS = {
    rememberWallet = { guard = "d.active(", mutation = "trainerMoneyStart[battle] =", policy = "enforcement" },
    scaleTrainerMoney = { guard = "d.active(", mutation = "setTrainerWalletValue(", policy = "enforcement" },
    awardGymLeaderForgiveness = { guard = "d.active(", mutation = "mod.save:set(\"route_forgiveness_gym_leaders\"", policy = "enforcement" },
    recordLeagueProgression = {
        guard = "d.canWriteNuzlockeSave(",
        mutation = "mod.save:set(",
        policy = "passive_progression",
        exception = "badge/E4/Champion sync is intentionally allowed while the master rule is off",
    },
    forgivenessTokens = {
        guard = "d.canWriteNuzlockeSave(",
        mutation = "mod.save:set(\"route_forgiveness_tokens\"",
        policy = "compatibility_mirror",
        exception = "inventory-to-save token mirror is maintenance, not a gameplay award",
    },
    setForgivenessTokens = {
        guard = "d.canWriteNuzlockeSave(",
        mutation = "mod.save:set(\"route_forgiveness_tokens\"",
        policy = "compatibility_mirror",
        exception = "shared token setter is also used by save/inventory reconciliation",
    },
    syncForgivenessTokenItem = {
        guard = "game and game.save",
        mutation = "M.ensureForgivenessTokenItem(game)",
        policy = "compatibility_mirror",
        exception = "save/inventory reconciliation must remain available while the master rule is off",
    },
}

local function contractFunctionSource(source, name)
    if type(source) ~= "string" then return nil end
    local needle = "function M." .. tostring(name) .. "("
    local first = source:find(needle, 1, true)
    if not first then return nil end
    local nextFn = source:find("\nfunction M.", first + #needle, true)
    return source:sub(first, nextFn and (nextFn - 1) or #source)
end

function M.activeGuardAudit(source)
    local report = { ok = true, checked = 0, failures = {}, contracts = {} }
    local blocks = {}
    if type(source) == "string" then
        for name in source:gmatch("function M%.([%w_]+)%s*%(") do
            blocks[name] = contractFunctionSource(source, name)
        end
    end

    -- Any exported trainer-reward function that directly writes Nuzlocke save
    -- state or the trainer wallet must have a contract. This is the piece that
    -- catches a newly-added mutation path even when the author forgets to add
    -- it to ACTIVE_GUARD_CONTRACTS.
    for name, body in pairs(blocks) do
        local mutates = name ~= "activeGuardAudit" and (
            body:find("mod.save:set(", 1, true)
            or body:find("setTrainerWalletValue(", 1, true)
            or body:find("save.inventory[", 1, true))
        if mutates and ACTIVE_GUARD_CONTRACTS[name] == nil then
            report.ok = false
            report.failures[#report.failures + 1] = name
                .. ":uncontracted player-state mutation"
        end
    end

    for name, contract in pairs(ACTIVE_GUARD_CONTRACTS) do
        local body = blocks[name] or contractFunctionSource(source, name)
        local present = body ~= nil
        local guardPos = present and body:find(contract.guard, 1, true) or nil
        local mutationPos = present and contract.mutation
            and body:find(contract.mutation, 1, true) or nil
        local guarded = guardPos ~= nil
            and (contract.mutation == nil or (mutationPos ~= nil and guardPos < mutationPos))
        local row = {
            name = name,
            policy = contract.policy,
            guard = contract.guard,
            mutation = contract.mutation,
            exception = contract.exception,
            present = present,
            guarded = guarded,
        }
        report.contracts[#report.contracts + 1] = row
        report.checked = report.checked + 1
        if not present or not guarded then
            report.ok = false
            local reason = not present and "function missing"
                or not guardPos and ("missing " .. contract.guard)
                or not mutationPos and ("mutation marker missing " .. tostring(contract.mutation))
                or "guard occurs after mutation"
            report.failures[#report.failures + 1] = name .. ":" .. reason
        end
    end
    table.sort(report.contracts, function(a, b) return a.name < b.name end)
    table.sort(report.failures)
    return report
end

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

-- 2.5.40: Forgiveness Tokens are real inventory items, not synthetic Mart
-- stock. Keep the historical mod.save counter as a compatibility mirror so
-- existing API consumers and saves continue to work, but the carried item is
-- the player-facing source of truth whenever a live save exists.
function M.ensureForgivenessTokenItem(game)
    game = game or d.getCurrentGame()
    if not (game and game.data) then return false end
    game.data.items = game.data.items or {}
    local id = mod.exports.__beta26.forgivenessTokenItemId
    local def = game.data.items[id]
    if type(def) ~= "table" then
        def = {}
        game.data.items[id] = def
    end
    def.id = id
    def.name = d.Strings("F. TOKEN")
    def.price = 0
    def.description = d.Strings(
        "Spend to reroll a failed encounter or revive one fallen Pokemon.")
    -- R/B/Y respects keyItem for TOSS protection. Gold uses the shared flat
    -- inventory plus pocket metadata; ITEM keeps the quantity visible while
    -- canToss=false removes GIVE/TOSS from its submenu.
    def.keyItem = true
    def.tossable = false
    def.canToss = false
    def.canSelect = false
    def.pocket = "ITEM"
    def.fieldMenu = "ITEMMENU_NOUSE"
    def.battleMenu = "ITEMMENU_NOUSE"
    return true
end

function M.forgivenessTokens()
    local game = d.getCurrentGame()
    local save = game and game.save
    local id = mod.exports.__beta26.forgivenessTokenItemId
    local inventory = save and save.inventory
    if type(inventory) == "table" and inventory[id] ~= nil then
        local count = math.max(0, math.floor(tonumber(inventory[id]) or 0))
        local mirrored = math.max(0, math.floor(tonumber(
            mod.save:get("route_forgiveness_tokens", 0)) or 0))
        if count ~= mirrored and d.canWriteNuzlockeSave(game) then
            mod.save:set("route_forgiveness_tokens", count)
        end
        return count
    end
    return math.max(0, math.floor(tonumber(
        mod.save:get("route_forgiveness_tokens", 0)) or 0))
end

function M.setForgivenessTokens(n)
    local game = d.getCurrentGame()
    if not d.canWriteNuzlockeSave(game) then return false end
    n = math.max(0, math.min(99, math.floor(tonumber(n) or 0)))
    mod.save:set("route_forgiveness_tokens", n)
    local save = game and game.save
    if not (save and type(save.inventory) == "table") then return true end
    M.ensureForgivenessTokenItem(game)
    local id = mod.exports.__beta26.forgivenessTokenItemId
    if n <= 0 then
        save.inventory[id] = nil
        local order = save.bagOrder
        if type(order) == "table" then
            for i = #order, 1, -1 do
                if order[i] == id then table.remove(order, i) end
            end
        end
        return true
    end
    -- Gym rewards are guaranteed challenge rewards. They must not disappear
    -- merely because the ordinary Bag/ITEM pocket is at its native slot cap.
    -- The item still obeys the engine's 99-stack ceiling above.
    save.inventory[id] = n
    local okBag, Bag = pcall(require, "src.inventory.Bag")
    if okBag and type(Bag) == "table" and type(Bag.order) == "function" then
        pcall(Bag.order, save, game and game.data)
    end
    return true
end

function M.syncForgivenessTokenItem(game)
    game = game or d.getCurrentGame()
    if not (game and game.save and type(game.save.inventory) == "table") then
        return false
    end
    M.ensureForgivenessTokenItem(game)
    local id = mod.exports.__beta26.forgivenessTokenItemId
    local inventoryCount = tonumber(game.save.inventory[id])
    local legacy = math.max(0, math.min(99, math.floor(tonumber(
        mod.save:get("route_forgiveness_tokens", 0)) or 0)))
    if inventoryCount == nil then
        if legacy > 0 then return M.setForgivenessTokens(legacy) end
        return true
    end
    inventoryCount = math.max(0, math.min(99, math.floor(inventoryCount)))
    if inventoryCount ~= legacy then
        mod.save:set("route_forgiveness_tokens", inventoryCount)
    end
    return true
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
    local tokenCommitted = M.setForgivenessTokens(M.forgivenessTokens() + 1)
    -- 2.5.85: the reward ledger and carried token are committed before Run
    -- History observes the award. The semantic Leader key makes this bridge
    -- idempotent across duplicate battle-finalization/provider callbacks.
    local runHistory = d.runHistory
    if tokenCommitted == true and type(runHistory) == "table"
        and type(runHistory.recordForgivenessAward) == "function" then
        pcall(runHistory.recordForgivenessAward, game, "gym_leader", key, {
            leader = tostring(leader),
            map = mapId,
            tokens = M.forgivenessTokens(),
            dedupe = "forgiveness:gym:" .. key,
        })
    end
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

    local guardReport = M.activeGuardAudit(d.sourceText)
    assert(guardReport.ok, "trainer rewards active-guard contract failed: "
        .. table.concat(guardReport.failures, ", "))

    for _, key in ipairs({
        "Strings", "active", "canWriteNuzlockeSave", "shouldEnforceNuzlocke",
        "isTrainerBattle", "isSaveEditorSession",
        "worldMechanic", "worldRuleTriplet", "externalRuleDelegation",
        "pushWorldText",
        "worldRuleText", "getCurrentGame", "VersionCompat",
        "gscProgress", "gscStages", "levelCapGymLeaders",
        "gymProgress", "gymProgressKey", "eliteFourCaps", "eliteFourDefeated",
        "currentGymProgressCount", "nextEliteFourCapInfo", "runHistory",
    }) do
        assert(d[key] ~= nil, "trainer rewards missing dependency: " .. key)
    end

    mod.exports.__beta26.forgivenessTokenItemId =
        "NUZLOCKE_FORGIVENESS_TOKEN"
    mod.exports.__beta26.forgivenessTokens = M.forgivenessTokens
    mod.exports.__beta26.ensureForgivenessTokenItem = M.ensureForgivenessTokenItem
    mod.exports.__beta26.syncForgivenessTokenItem = M.syncForgivenessTokenItem

    pcall(M.syncForgivenessTokenItem, d.getCurrentGame())
    mod.events:on("game.ready",
        function(ev) pcall(M.syncForgivenessTokenItem,
            (type(ev) == "table" and ev.game) or d.getCurrentGame()) end)
    mod.events:on("save.loaded",
        function(ev) pcall(M.syncForgivenessTokenItem,
            (type(ev) == "table" and ev.game) or d.getCurrentGame()) end)
    mod.events:on("save.created",
        function(ev) pcall(M.syncForgivenessTokenItem,
            (type(ev) == "table" and ev.game) or d.getCurrentGame()) end)
    return true
end

return M
