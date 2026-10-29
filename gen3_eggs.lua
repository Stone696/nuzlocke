-- Gen 3 Egg Encounter provenance: never delete a gift or hatchling.
-- Egg provenance is attached to individual host-mon data so it travels through
-- party storage and is visible to native egg.hatched events.
return function()
    local M = { api = 1 }
    local function validMap(key)
        return type(key) == "string" and key ~= ""
    end
    local function monId(mon)
        if type(mon) ~= "table" then return nil end
        return tostring(mon.personality or "") .. ":" .. tostring(mon.otId or "")
    end

    -- The creation event is not guaranteed to be a successful receipt.
    -- Record a hint, but don't consume an encounter until the egg hatches.
    function M.created(s, ev, mapId)
        if type(ev) ~= "table" or type(ev.egg) ~= "table" then return false end
        local egg = ev.egg
        egg.nuzEggOrigin = ev.mother and "DAYCARE" or "UNKNOWN"
        egg.nuzEggReceivedAt = validMap(mapId) and mapId or nil
        egg.nuzEggIdentity = monId(egg)
        return true
    end

    function M.hatched(s, ev, hatchMap, mode)
        if type(ev) ~= "table" or type(ev.mon) ~= "table" then
            return false, "no_mon"
        end
        local mon, egg = ev.mon, ev.egg
        local provenance = type(egg) == "table" and egg or mon
        local receivedAt = provenance.nuzEggReceivedAt
        local origin = provenance.nuzEggOrigin or "UNKNOWN"
        local selected = mode or 0
        local encounterMap
        if selected == 1 then
            encounterMap = receivedAt
        elseif selected == 2 then
            encounterMap = hatchMap
        elseif selected == 3 and origin ~= "DAYCARE" then
            -- Native story gift-egg acquisition isn't yet exposed by an
            -- authoritative gift-delivery event: don't invent an area.
            encounterMap = nil
        end
        if selected == 0 or (selected == 3 and origin == "DAYCARE") then
            mon.nuzEggProvenance = "EXEMPT"
            return true, "exempt"
        end
        if not validMap(encounterMap) then
            mon.nuzEggProvenance = "UNKNOWN"
            return false, "location_unavailable"
        end
        if type(s.areas) ~= "table" then s.areas = {} end
        local old = s.areas[encounterMap]
        local spent = old ~= nil and (old.spent ~= false)
        mon.nuzEggProvenance = spent and "INELIGIBLE" or "ELIGIBLE"
        mon.nuzEggEncounterMap = encounterMap
        -- If the area was available, the Egg claims that slot at hatch. This
        -- isn't full RECEIVED-time enforcement until egg-delivery is exposed.
        if not spent then
            s.areas[encounterMap] = {
                spent = true, caught = true,
                species = ev.species or mon.species,
                speciesId = ev.species or mon.species,
                caughtSpeciesId = ev.species or mon.species,
                origin = "egg", attempts = 1,
            }
        end
        return not spent, spent and "area_spent" or "claimed"
    end
    return M
end
