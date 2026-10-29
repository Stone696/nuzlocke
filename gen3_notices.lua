-- Gen 3 Nuzlocke player notices. Persistent history + safe native battle text.
-- Never replace an existing overworld script/message or inject into menus.
return function()
    local M = { api = 1 }
    local MAX = 100
    local function clean(text)
        return tostring(text or ""):gsub("[%c]", " "):sub(1, 180)
    end
    function M.history(s)
        if type(s.notices) ~= "table" then s.notices = {} end
        return s.notices
    end
    function M.add(s, code, message)
        local log = M.history(s)
        message = clean(message)
        if message == "" then return false end
        log[#log + 1] = { code = tostring(code or "INFO"), text = message }
        while #log > MAX do table.remove(log, 1) end
        return true
    end
    function M.battle(message)
        -- Mods have no 'package' global in the real Gen1Recomp sandbox.
        -- Resolve the native UI through the permitted module facade.
        local ok, ui = pcall(require, "src.core.game3.battle.ui")
        if not ok then return false end
        if type(ui) ~= "table" or type(ui.push) ~= "function" then
            return false
        end
        ui.push(clean(message))
        return true
    end
    function M.name(mon, display)
        if type(mon) ~= "table" then return "Pokemon" end
        if display and type(display.pokemonName) == "function" then
            local ok, name = pcall(display.pokemonName, mon)
            if ok and type(name) == "string" and name ~= "" then
                return name
            end
        end
        return tostring(mon.nickname or mon.name or "Pokemon")
    end
    function M.catchReason(battle)
        if battle.roamer and not battle.roamerOpen then
            return "Roamer Clause: this Pokemon's catch slot is already used."
        end
        if battle.duplicate then
            return "Dupes Clause: this Pokemon is already owned."
        end
        return "One Per Area: your encounter for this area was used."
    end
    function M.expText(name, report, cap)
        if type(report) ~= "table" then return nil end
        local given = tonumber(report.awarded) or 0
        local applied = tonumber(report.applied) or 0
        local overflow = math.max(0, given - math.min(given, applied))
        local bankBefore = tonumber(report.bankBefore) or 0
        local prefix = tostring(name) .. ": "
        if overflow > 0 and report.edging then
            return prefix .. tostring(overflow)
                .. " EXP banked at the Lv " .. tostring(cap) .. " cap."
        end
        if overflow > 0 then
            return prefix .. "Lv " .. tostring(cap)
                .. " cap reached. " .. tostring(overflow) .. " EXP lost."
        end
        if bankBefore > 0 and applied > given then
            return prefix .. "released " .. tostring(applied - given)
                .. " saved EXP."
        end
        return nil
    end
    return M
end
