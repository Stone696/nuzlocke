-- Gen 3 new-game-only QoL. Never rewrites a running save or its story flags.
-- Fresh-save grants use the native Player PC, not direct bag mutation.
return function()
    local M = { api = 1 }
    local DEFINITIONS = {
        { key = "starting_money", label = "START MONEY", default = 3000,
          options = { 0, 1000, 3000, 5000, 10000, 50000, 999999 } },
        { key = "starting_pokeballs", label = "START BALLS", default = 0,
          options = { 0, 5, 10, 20, 50, 99 } },
        { key = "starting_rare_candies", label = "START CANDY", default = 0,
          options = { 0, 10, 25, 50, 99 } },
        { key = "pc_starting_heal_items", label = "PC HEAL KIT", default = false },
        { key = "pc_starting_vitamins", label = "PC VITAMINS", default = false },
    }
    local byKey = {}
    for _, d in ipairs(DEFINITIONS) do byKey[d.key] = d end
    local HEALS = { 13, 22, 20, 14, 15, 16, 17, 18, 23 }
    -- Gen 3 includes Zinc as its sixth native vitamin.
    local VITAMINS = { 63, 64, 65, 66, 67, 70 }
    local BALL_ID = 4

    function M.descriptors()
        return DEFINITIONS
    end

    function M.normalise(s)
        if type(s) ~= "table" then return s end
        if type(s.setupQol) ~= "table" then s.setupQol = {} end
        for _, d in ipairs(DEFINITIONS) do
            local value = s.setupQol[d.key]
            if type(d.default) == "boolean" then
                s.setupQol[d.key] = value == true
            else
                value = tonumber(value)
                if value == nil or value ~= math.floor(value) then value = d.default end
                local allowed = false
                for _, option in ipairs(d.options) do
                    if value == option then allowed = true; break end
                end
                s.setupQol[d.key] = allowed and value or d.default
            end
        end
        return s
    end

    function M.get(s, key)
        if not byKey[key] then return nil end
        return M.normalise(s).setupQol[key]
    end

    function M.set(s, key, value)
        local d = byKey[key]
        if not d then return false, "unknown_qol" end
        -- Truly setup-only, even if the run leaves challenge rules editable.
        if not s or s._setup ~= true then return false, "setup_only" end
        if type(value) ~= type(d.default) then return false, "invalid_type" end
        if d.options then
            local allowed = false
            for _, option in ipairs(d.options) do
                if option == value then allowed = true; break end
            end
            if not allowed then return false, "invalid_choice" end
        end
        M.normalise(s).setupQol[key] = value
        return true
    end

    local function pcEntries(s)
        local result = {}
        local q = M.normalise(s).setupQol
        if q.starting_rare_candies > 0 then
            result[#result + 1] = { id = 68, qty = q.starting_rare_candies }
        end
        if q.pc_starting_heal_items then
            for _, id in ipairs(HEALS) do
                result[#result + 1] = { id = id, qty = 10 }
            end
        end
        if q.pc_starting_vitamins then
            for _, id in ipairs(VITAMINS) do
                result[#result + 1] = { id = id, qty = 10 }
            end
        end
        return result
    end

    local function canFitInPC(native, storage, entries)
        local pc = native and native.storage
        if type(pc) ~= "table" or type(pc.items) ~= "table" then
            return false, "native_pc_missing"
        end
        if not storage or type(storage.addPcItem) ~= "function"
            or type(storage.pcItemsCount) ~= "function" then
            return false, "native_pc_api_missing"
        end
        local stock, count = {}, #pc.items
        for _, entry in ipairs(pc.items) do
            if type(entry) == "table" then
                stock[entry.id] = (stock[entry.id] or 0) + (entry.qty or 0)
            end
        end
        for _, entry in ipairs(entries) do
            if not stock[entry.id] then count = count + 1 end
            stock[entry.id] = (stock[entry.id] or 0) + entry.qty
            if stock[entry.id] > 999 then return false, "pc_stack_full" end
        end
        if count > (storage.pcItemsCount(native) or 0) then
            return false, "pc_capacity"
        end
        return true
    end

    -- Called after Gen1Recomp's Schema.newGame has made a concrete session.
    -- Never creates equipment, changes quest flags, or opens capture early.
    function M.applyNewGame(s, native, storage)
        if not s or s.qolCreatedApplied == true then return false, "already_applied" end
        if type(native) ~= "table" then return false, "native_session_missing" end
        local entries = pcEntries(s)
        if #entries > 0 then
            local valid, reason = canFitInPC(native, storage, entries)
            if not valid then return false, reason end
        end
        for _, entry in ipairs(entries) do
            local ok, reason = storage.addPcItem(native, entry.id, entry.qty)
            if not ok then return false, reason or "pc_grant_failed" end
        end
        native.money = M.get(s, "starting_money")
        s.qolBallsPending = M.get(s, "starting_pokeballs")
        s.qolCreatedApplied = true
        return true
    end

    -- Extra Balls are withheld until the original game has already supplied
    -- a usable Ball. They are delivered to PC, never into early scripted battles.
    -- The pending quantity lives in mod.save so it survives ordinary reloads.
    function M.deliverBalls(s, native, storage)
        local pending = s and tonumber(s.qolBallsPending) or 0
        if pending <= 0 or not s.qolCreatedApplied then return false, "nothing_pending" end
        local pockets = native and native.bag and native.bag.pockets
        local balls = pockets and pockets.POKE_BALLS
        local owned = false
        for _, slot in pairs(type(balls) == "table" and balls or {}) do
            if type(slot) == "table" and (tonumber(slot.qty) or 0) > 0 then
                owned = true
                break
            end
        end
        if not owned and s.captureUnlocked ~= true then
            return false, "capture_not_unlocked"
        end
        if not storage or type(storage.addPcItem) ~= "function" then
            return false, "native_pc_api_missing"
        end
        local ok, reason = storage.addPcItem(native, BALL_ID, pending)
        if not ok then return false, reason or "pc_grant_failed" end
        s.qolBallsPending = 0
        s.qolBallsDelivered = true
        return true
    end

    return M
end
