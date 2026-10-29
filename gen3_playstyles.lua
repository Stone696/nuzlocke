-- Gen 3 challenge playstyles. Deliberately separate from CORE and CLAUSES:
-- a playstyle changes eligibility, not natural shiny odds or base rules.
return function()
    local M = { api = 1, schema = 1 }
    local DEFINITIONS = {
        { key = "shiny_nuzlocke", label = "SHINY NUZLOCKE",
          default = false, status = "working" },
        { key = "hardcore_nuzlocke", label = "HARDCORE NUZLOCKE",
          default = false, status = "working" },
    }
    local byKey = {}
    for _, d in ipairs(DEFINITIONS) do byKey[d.key] = d end

    function M.normalise(s)
        if type(s.playstyles) ~= "table" then s.playstyles = {} end
        for _, d in ipairs(DEFINITIONS) do
            if type(s.playstyles[d.key]) ~= "boolean" then
                s.playstyles[d.key] = d.default
            end
        end
        return s
    end
    function M.descriptors()
        local out = {}
        for i, d in ipairs(DEFINITIONS) do
            out[i] = { key = d.key, label = d.label,
                default = d.default, status = d.status }
        end
        return out
    end
    function M.get(s, key)
        if not byKey[key] then return nil end
        return M.normalise(s).playstyles[key]
    end
    function M.set(s, key, value)
        if type(s) == "table" and s.runSettingsLocked == true and s._setup ~= true then
            return false, "run_settings_locked"
        end
        if not byKey[key] then return false, "unknown_playstyle" end
        if type(value) ~= "boolean" then return false, "boolean_required" end
        M.normalise(s)
        if s.failed == true then return false, "run_failed" end
        s.playstyles[key] = value
        return true
    end
    -- The Nuzlocke master switch still owns gameplay enforcement.
    function M.active(s, Core)
        return Core.active(s) and M.get(s, "shiny_nuzlocke") == true
    end
    -- Can combine with Shiny Nuzlocke; neither mode edits the saved
    -- CORE/LEVELS settings. Hardcore is inactive with NUZLOCKE OFF.
    function M.hardcoreActive(s, Core)
        return Core.active(s) and M.get(s, "hardcore_nuzlocke") == true
    end

    -- The first *eligible shiny* is the area encounter. A nonshiny
    -- must never claim it, even when Failed Encounters Count is ON.
    function M.qualifies(s, Core, shiny)
        return not M.active(s, Core) or shiny == true
    end
    -- Shiny Clause is a separate bonus-catch exception; in a Shiny
    -- Nuzlocke it cannot bypass one-per-area or Dupes restrictions.
    function M.allowShinyException(s, Core)
        return not M.active(s, Core)
    end
    return M
end
