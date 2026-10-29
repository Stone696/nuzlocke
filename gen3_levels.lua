-- Gen 3 Nuzlocke LEVELS policy. Battle EXP passes through the engine's
-- exp.gain hook before Experience.apply, preserving level-up presentation.
return function()
    local M = { api = 1, schema = 1 }
    M.scopes = { "NONE", "GYMS", "ELITE FOUR", "CHAMPION", "POSTGAME" }
    -- Boss ace levels by main-story badge / Elite Four order. Rematches and
    -- optional bosses are deliberately NOT treated as first-playthrough caps.
    local EDITIONS = {
        firered = {
            gyms = { 14, 21, 24, 29, 43, 43, 47, 50 },
            league = { 54, 56, 58, 60, 63 },
            wins = { [410]=1, [411]=2, [412]=3, [413]=4,
                [438]=5, [439]=5, [440]=5 },
        },
        ruby = {
            gyms = { 15, 18, 23, 28, 31, 33, 42, 43 },
            league = { 49, 51, 53, 55, 58 },
            wins = { [261]=1, [262]=2, [263]=3, [264]=4, [335]=5 },
        },
        emerald = {
            gyms = { 15, 19, 24, 29, 31, 33, 42, 46 },
            league = { 49, 51, 53, 55, 58 },
            wins = { [261]=1, [262]=2, [263]=3, [264]=4, [335]=5 },
        },
    }
    EDITIONS.leafgreen = EDITIONS.firered
    EDITIONS.sapphire = EDITIONS.ruby
    function M.edition(native)
        local raw = native and (native.edition or native.version
            or native.gameId or native.game)
        if type(raw) ~= "string" then return nil end
        local key = raw:lower():gsub("[%s_-]", "")
        if key == "fr" or key == "frlg" then key = "firered" end
        if key == "lg" then key = "leafgreen" end
        if key == "rs" then key = "ruby" end
        return EDITIONS[key] and key or nil
    end
    local function data(s)
        if type(s.levels) ~= "table" then s.levels = {} end
        local levels = s.levels
        if type(levels.wins) ~= "table" then levels.wins = {} end
        if type(levels.bank) ~= "table" then levels.bank = {} end
        local scope = tonumber(levels.scope)
        if not scope or scope % 1 ~= 0 or scope < 0 or scope > 4 then
            levels.scope = 0
        end
        if type(levels.edging) ~= "boolean" then levels.edging = false end
        return levels
    end
    function M.get(s, key)
        local levels = data(s)
        if key == "level_cap_scope" then return levels.scope end
        if key == "exp_edging" then return levels.edging end
        return nil
    end
    function M.set(s, key, value)
        if type(s) == "table" and s.runSettingsLocked == true and s._setup ~= true then
            return false, "run_settings_locked"
        end
        if type(s) ~= "table" or s.failed then return false, "run_failed" end
        local levels = data(s)
        if key == "level_cap_scope" then
            if type(value) ~= "number" or value % 1 ~= 0
                or value < 0 or value > 4 then return false, "invalid_scope" end
            levels.scope = value
        elseif key == "exp_edging" then
            if type(value) ~= "boolean" then return false, "boolean_required" end
            levels.edging = value
        else
            return false, "unknown_rule"
        end
        return true
    end
    -- A postgame provider may opt in explicitly. No provider = no invented cap.
    function M.setPostgameCap(s, cap)
        local levels = data(s)
        if cap == nil then levels.postgameCap = nil; return true end
        if type(cap) ~= "number" or cap % 1 ~= 0
            or cap < 1 or cap > 100 then return false, "invalid_cap" end
        levels.postgameCap = cap
        return true
    end
    local CLEAR_FLAGS = { firered = 0x82C, leafgreen = 0x82C,
        ruby = 0x804, sapphire = 0x804, emerald = 0x864 }
    local LEAGUE_FLAGS = {
        firered = { 0x4B8, 0x4B9, 0x4BA, 0x4BB },
        ruby = { 0x4DD, 0x4DE, 0x4DF, 0x4E0 },
        emerald = { 0x4FB, 0x4FC, 0x4FD, 0x4FE },
    }
    LEAGUE_FLAGS.leafgreen = LEAGUE_FLAGS.firered
    LEAGUE_FLAGS.sapphire = LEAGUE_FLAGS.ruby
    local function nativeFlags(native)
        local flags = native and native.flags
        -- Direct package.loaded access fails inside the mod sandbox.
        local okSpace, space = pcall(require,
            "src.core.game3.scripting.space")
        if not okSpace then space = nil end
        if type(space) == "table" and type(space.getStore) == "function" then
            local ok, store = pcall(space.getStore)
            if ok and type(store) == "table"
                and type(store.flags) == "table" then flags = store.flags end
        end
        return type(flags) == "table" and flags or {}
    end
    local function hasFlag(flags, id)
        return flags[id] == true or flags[tostring(id)] == true
    end
    local function nativeLeagueProgress(native, edition)
        local flags = nativeFlags(native)
        if hasFlag(flags, CLEAR_FLAGS[edition])
            or flags.FLAG_SYS_GAME_CLEAR == true then return 5 end
        local won = 0
        for _, id in ipairs(LEAGUE_FLAGS[edition] or {}) do
            if hasFlag(flags, id) then won = won + 1 else break end
        end
        return won
    end

    local function completed(wins)
        local n = 0
        for i = 1, 5 do
            if wins[i] == true or wins[tostring(i)] == true then
                n = i
            else
                break
            end
        end
        return n
    end
    function M.cap(s, native, badges, overrideScope)
        local levels = data(s)
        local scope = type(overrideScope) == "number"
            and overrideScope >= 1 and overrideScope <= 4
            and overrideScope % 1 == 0 and overrideScope or levels.scope
        if scope == 0 then return nil, "NONE" end
        local id = M.edition(native)
        local edition = id and EDITIONS[id]
        if not edition or type(badges) ~= "table" then
            return nil, "UNKNOWN" -- never manufacture a cap
        end
        for i = 1, 8 do
            if badges[i] ~= true then
                return edition.gyms[i], "GYM " .. i
            end
        end
        if scope == 1 then return nil, "GYMS COMPLETE" end
        -- Detect already-completed native saves even when this Nuzlocke
        -- feature was enabled after beating the Champion.
        local progress = math.max(completed(levels.wins),
            nativeLeagueProgress(native, id))
        if progress < 4 then
            return edition.league[progress + 1], "ELITE " .. (progress + 1)
        end
        if scope == 2 then return nil, "ELITE COMPLETE" end
        if progress < 5 then return edition.league[5], "CHAMPION" end
        if scope == 4 then
            return levels.postgameCap, levels.postgameCap and "POSTGAME" or "POSTGAME OPEN"
        end
        return nil, "CHAMPION COMPLETE"
    end
    function M.noteWin(s, native, battle)
        local id = M.edition(native)
        if not id or type(battle) ~= "table" or battle.wild
            or battle.link or battle.facility or battle.battleTower
            or battle.trainerTower or battle.eReader or battle.secretBase
            or battle.frontier then return false end
        local stage = EDITIONS[id].wins[tonumber(battle.trainerId)]
        if not stage then return false end
        local levels = data(s)
        -- Strict progression: only advance the expected next league win.
        -- Prevent unrelated rematches / repeat encounters jumping the cap.
        if stage ~= completed(levels.wins) + 1 then return false end
        levels.wins[stage] = true
        return true
    end
    function M.identity(mon)
        if type(mon) ~= "table" or mon.personality == nil then return nil end
        -- Species must NOT be in the key: evolution must not lose EXP bank.
        -- Personality + original trainer IDs remain stable across evolution,
        -- PC movement, and native save/load.
        return tostring(mon.personality) .. ":"
            .. tostring(mon.otId or mon.trainerId or "") .. ":"
            .. tostring(mon.otSecretId or "")
    end
    -- A single transaction: base award + existing personal bank, limited to
    -- EXP threshold for cap+1 minus one. The overflow is banked if edging ON.
    -- Bank stays in mod.save by Pokemon identity and survives PC movement.
    function M.adjust(s, mon, awarded, limit, expForLevel)
        local levels = data(s)
        local raw = math.max(0, math.floor(tonumber(awarded) or 0))
        local id = M.identity(mon)
        local savedBank = id and math.max(0, math.floor(
            tonumber(levels.bank[id]) or 0)) or 0
        local bank = levels.edging and savedBank or 0
        local available = nil
        if type(limit) == "number" and limit < 100 then
            local ok, threshold = pcall(expForLevel, mon, limit + 1)
            if not ok or type(threshold) ~= "number" then
                return raw -- fail open if growth table not available
            end
            available = math.max(0, math.floor(threshold) - 1
                - (tonumber(mon.exp) or 0))
        end
        local budget = raw + bank
        local applied = available and math.min(budget, available) or budget
        if id and levels.edging then
            levels.bank[id] = budget > applied and (budget - applied) or nil
        end
        -- When edging is OFF, do not silently erase saved bank. It remains
        -- dormant until toggled ON again (or the user explicitly resets it).
        return applied
    end
    function M.banked(s, mon)
        local id = M.identity(mon)
        return id and (tonumber(data(s).bank[id]) or 0) or 0
    end
    return M
end
