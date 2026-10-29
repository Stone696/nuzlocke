-- Gen 3 new-run setup policy. The title menu edits an isolated draft;
-- selected settings are committed only when the native new save is created.
return function()
    local M = { api = 1 }
    local GROUPS = {
        "rules", "clauses", "catchRules", "battleItemRules",
        "fieldItemRules", "serviceRules", "statRules",
        "areaSplitRules", "runPartyRules", "difficultyRules",
        "hardcoreRules", "qolRules", "setupRules", "variantRules",
        "battleClauses", "statusBans", "playstyles",
    }
    local RANDOM_KEYS = {
        "random_encounter_tables", "random_trainers",
        "randomizer_seed", "random_encounter_balance",
        "random_trainer_balance", "random_species_generation",
        "randomizer_preset",
    }
    local function copy(source)
        if type(source) ~= "table" then return {} end
        local result = {}
        for k, v in pairs(source) do
            if type(v) == "table" then result[k] = copy(v)
            else result[k] = v end
        end
        return result
    end

    function M.newDraft(previous)
        previous = type(previous) == "table" and previous or {}
        local draft = {
            _setup = true, enabled = previous.enabled == true,
            failed = false, areas = {}, graveyard = {},
            capturedSpecies = {}, roamerClaims = {},
            runSettingsLocked = false, captureUnlocked = false,
        }
        for _, name in ipairs(GROUPS) do
            draft[name] = copy(previous[name])
        end
        -- These fields record live results. Never carry a former run's
        -- resolved seed/used marker or level-cap wins/banked EXP into a new one.
        draft.randomizer = {}
        for _, key in ipairs(RANDOM_KEYS) do
            if previous.randomizer and previous.randomizer[key] ~= nil then
                draft.randomizer[key] = previous.randomizer[key]
            end
        end
        draft.levels = {
            scope = previous.levels and previous.levels.scope or 0,
            edging = previous.levels and previous.levels.edging == true,
        }
        -- Catch-rule random target/seed caches are run-specific.
        draft.catchRules.alphabetlocke_random_letter = nil
        draft.catchRules.colorlocke_random_color = nil
        return draft
    end

    function M.mayEdit(s)
        return type(s) == "table"
            and (s.runSettingsLocked ~= true or s._setup == true)
    end

    function M.lockError(s)
        if M.mayEdit(s) then return nil end
        return "run_settings_locked"
    end

    -- Used only at save.created; setup state itself never goes in a prior save.
    function M.commit(s)
        if type(s) ~= "table" then return nil end
        s._setup = nil
        s.captureUnlocked = false
        s.failed = false
        return s
    end

    return M
end
