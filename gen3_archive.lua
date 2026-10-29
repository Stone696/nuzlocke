-- Full Gen 3 Pokemon snapshots for diagnostics and developer-only recovery.
-- Never manufacture a Pokemon from species/level memorial metadata.
-- The caller must validate archive completeness, individual uniqueness and
-- destination capacity; ordinary Route Forgiveness revival is still disabled.
return function()
    local M = { api = 1 }
    local FORBIDDEN = {
        nuzlockeDead = true, nuzlockeDeathRecorded = true,
    }
    function M.snapshot(mon)
        if type(mon) ~= "table" then return nil, false end
        local complete, budget, seen = true, 2048, {}
        local function copy(value, depth)
            local typ = type(value)
            if typ == "nil" or typ == "boolean" or typ == "number"
                or typ == "string" then return value end
            if typ ~= "table" or depth > 12 or seen[value] then
                complete = false
                return nil
            end
            seen[value] = true
            local result = {}
            for key, entry in pairs(value) do
                budget = budget - 1
                if budget < 0 then complete = false; break end
                local kt = type(key)
                if depth == 0 and FORBIDDEN[key] then
                    -- These are intentionally omitted; the archive remains
                    -- complete when no actual Pokémon data was discarded.
                elseif kt == "string" or kt == "number" then
                    local valueCopy = copy(entry, depth + 1)
                    if valueCopy ~= nil then result[key] = valueCopy end
                else
                    complete = false
                end
            end
            seen[value] = nil
            return result
        end
        local saved = copy(mon, 0)
        if type(saved) == "table" and next(saved)
            and saved.personality ~= nil
            and (saved.species ~= nil or saved.speciesId ~= nil) then
            -- A fainted creature remains at 0 HP inside the archive. Recovery
            -- will later explicitly apply HALF MAX HP on a COPY of these data.
            return saved, complete
        end
        return nil, false
    end
    return M
end
