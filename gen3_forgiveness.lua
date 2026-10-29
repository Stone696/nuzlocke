-- Gen 3 Route Forgiveness: safe economy + reopen a missed encounter.
-- FULL Pokémon restoration is deliberately unavailable pending a verified
-- PC/party transaction and a full archive. No item-giving/modded inventory.
return function()
    local M = { api = 1 }
    local FLAGS = { 0x820, 0x821, 0x822, 0x823,
        0x824, 0x825, 0x826, 0x827 }

    local function state(s)
        if type(s.forgiveness) ~= "table" then s.forgiveness = {} end
        local f = s.forgiveness
        if type(f.badges) ~= "table" then f.badges = {} end
        if type(f.claimedRoutes) ~= "table" then f.claimedRoutes = {} end
        f.tokens = math.max(0, math.floor(tonumber(f.tokens) or 0))
        return f
    end
    function M.balance(s) return state(s).tokens end

    function M.badges(session)
        if type(session) ~= "table" then return nil end
        local flags = session.flags
        -- 'package.loaded' is not accessible from sandboxed mods.
        local okSpace, loaded = pcall(require,
            "src.core.game3.scripting.space")
        if not okSpace then loaded = nil end
        if type(loaded) == "table" and type(loaded.getStore) == "function" then
            local ok, store = pcall(loaded.getStore)
            if ok and type(store) == "table" and type(store.flags) == "table" then
                flags = store.flags
            end
        end
        if type(flags) ~= "table" then return nil end
        local badges = {}
        for i, flag in ipairs(FLAGS) do
            badges[i] = not not (flags[flag] or flags[tostring(flag)])
        end
        return badges
    end

    -- Set an explicit baseline as soon as a player turns the feature ON.
    -- Previously acquired badges never pay retroactively.
    function M.initialise(s, mode, badges)
        local f = state(s)
        if not f.initialised then
            f.initialised = true
            if mode == 2 then f.tokens = f.tokens + 1 end
        end
        if type(badges) == "table" and not f.baselined then
            for i = 1, 8 do if badges[i] then f.badges[i] = true end end
            f.baselined = true
        end
        return true
    end

    function M.observe(s, mode, badges)
        if mode ~= 1 and mode ~= 2 then return 0 end
        local f = state(s)
        -- Refuse to guess badge progress if provider isn't available.
        if not f.initialised then
            M.initialise(s, mode, badges)
            return 0
        end
        if type(badges) ~= "table" then return 0 end
        if not f.baselined then
            M.initialise(s, mode, badges)
            return 0
        end
        local earned = 0
        for i = 1, 8 do
            if badges[i] and not f.badges[i] then
                f.badges[i] = true
                earned = earned + 1
            end
        end
        if earned > 0 then f.tokens = f.tokens + earned end
        return earned
    end

    function M.canReopen(s, areaId)
        local f = state(s)
        if type(areaId) ~= "string" or areaId == "" then return false end
        local entry = type(s.areas) == "table" and s.areas[areaId]
        return f.tokens > 0 and s.enabled == true and not s.failed
            and type(s.clauses) == "table"
            and (s.clauses.route_forgiveness == 1
                or s.clauses.route_forgiveness == 2)
            and type(entry) == "table"
            and entry.spent ~= false and entry.caught ~= true
            and f.claimedRoutes[areaId] ~= true
    end

    function M.reopen(s, areaId)
        if not M.canReopen(s, areaId) then
            return false, "not_eligible"
        end
        local f = state(s)
        local entry = s.areas[areaId]
        entry.spent = false
        entry.caught = false
        f.tokens = f.tokens - 1
        f.claimedRoutes[areaId] = true
        return true
    end
    return M
end
