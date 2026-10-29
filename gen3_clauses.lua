-- Generation 3 CLAUSES policy. Existing Gen 1/2 code is untouched.
-- 0=off, 1=species, 2=evolution family, 3=ancestor/descendant (split).
-- Shiny exception: 0=off, 1/2/3=allowances, 4=unlimited.
return function()
    local M = { api = 1, schema = 1 }
    local DEFINITIONS = {
        { key = "dupes_mode", label = "DUPES CLAUSE", default = 0,
          status = "wip", options = {"OFF", "SPEC", "FAM", "SPLIT"} },
        { key = "shiny_clause", label = "SHINY CLAUSE", default = 0,
          status = "wip", options = {"OFF", "1", "2", "3", "UNLIMITED"} },
        { key = "shiny_rate_mode", label = "SHINY RATE", default = 0,
          status = "wip",
          options = {"NATIVE", "1/4096", "1/1024", "1/512",
              "1/100", "1/10", "ALWAYS"} },
        { key = "gen3_roamer_clause", label = "ROAMER CLAUSE", default = 0,
          status = "wip", options = {"OFF", "SLOT"} },
        { key = "gen3_egg_encounter_mode", label = "EGG ENCOUNTER", default = 0,
          status = "wip", options = {"OFF", "RECEIVED", "HATCHED", "GIFT"} },
        { key = "route_forgiveness", label = "ROUTE FORGIVENESS", default = 0,
          status = "wip", options = {"OFF", "EARN", "START 1"} },
    }
    local byKey = {}
    for _, d in ipairs(DEFINITIONS) do byKey[d.key] = d end

    function M.descriptors()
        local out = {}
        for i, d in ipairs(DEFINITIONS) do
            local copy = {}
            for k, v in pairs(d) do copy[k] = v end
            out[i] = copy
        end
        return out
    end

    function M.normalise(s)
        if type(s.clauses) ~= "table" then s.clauses = {} end
        if type(s.capturedSpecies) ~= "table" then s.capturedSpecies = {} end
        if type(s.roamerClaims) ~= "table" then s.roamerClaims = {} end
        if type(s.shinyExceptionsUsed) ~= "number" then
            s.shinyExceptionsUsed = 0
        end
        s.shinyExceptionsUsed = math.max(0, math.floor(s.shinyExceptionsUsed))
        for _, d in ipairs(DEFINITIONS) do
            if type(s.clauses[d.key]) ~= type(d.default) then
                s.clauses[d.key] = d.default
            end
            local value = s.clauses[d.key]
            if type(value) == "number"
                and (value < 0 or value >= #d.options
                    or value ~= math.floor(value)) then
                s.clauses[d.key] = d.default
            end
        end
        return s
    end

    function M.get(s, key)
        if not byKey[key] then return nil end
        return M.normalise(s).clauses[key]
    end

    function M.set(s, key, value)
        if type(s) == "table" and s.runSettingsLocked == true and s._setup ~= true then
            return false, "run_settings_locked"
        end
        local d = byKey[key]
        if not d then return false, "unknown_rule" end
        if d.status == "soon" then return false, "not_implemented" end
        if s.failed then return false, "run_failed" end
        if s.runSettingsLocked and not s._setup then return false, "settings_locked" end
        if type(value) ~= type(d.default) then return false, "invalid_type" end
        if type(value) == "number" and (value < 0 or value >= #d.options
            or value ~= math.floor(value)) then
            return false, "invalid_mode"
        end
        M.normalise(s).clauses[key] = value
        return true
    end

    function M.label(s, key)
        local d = byKey[key]
        if not d then return "UNKNOWN" end
        local value = M.get(s, key)
        if type(value) == "boolean" then return value and "ON" or "OFF" end
        return d.options[value + 1] or "OFF"
    end

    local function numericSpecies(raw)
        local n = tonumber(raw)
        if n and n > 0 then return math.floor(n) end
        if type(raw) ~= "string" or raw == "" then return nil end
        local ok, Pokemon = pcall(require, "src.core.game3.pokemon")
        if not ok or not Pokemon then return nil end
        if type(Pokemon.speciesFromName) == "function" then
            local success, id = pcall(Pokemon.speciesFromName, raw)
            if success then return tonumber(id) end
        end
        return nil
    end
    M.speciesId = numericSpecies

    local function monSpecies(mon)
        if type(mon) ~= "table" then return nil end
        local ok, Pokemon = pcall(require, "src.core.game3.pokemon")
        if ok and Pokemon and type(Pokemon.speciesOf) == "function" then
            local success, result = pcall(Pokemon.speciesOf, mon)
            if success and tonumber(result) then return tonumber(result) end
        end
        return numericSpecies(mon.species or mon.speciesId)
    end

    local function addSpecies(set, value)
        local n = numericSpecies(value)
        if n then set[n] = true end
    end

    function M.ownedSpecies(s, session)
        M.normalise(s)
        local owned = {}
        for id, value in pairs(s.capturedSpecies) do
            if value then addSpecies(owned, id) end
        end
        for _, area in pairs(s.areas or {}) do
            if type(area) == "table" and area.caught then
                addSpecies(owned, area.caughtSpeciesId
                    or area.speciesId or area.species)
            end
        end
        for _, death in ipairs(s.graveyard or {}) do
            addSpecies(owned, monSpecies(death))
        end
        if type(session) == "table" then
            for _, mon in pairs(session.party or {}) do
                if type(mon) == "table" and not mon.isEgg then
                    addSpecies(owned, monSpecies(mon))
                end
            end
            local storage = session.storage
            for _, box in pairs(storage and storage.boxes or {}) do
                for _, mon in pairs(type(box) == "table" and box.mons or {}) do
                    if type(mon) == "table" and not mon.isEgg then
                        addSpecies(owned, monSpecies(mon))
                    end
                end
            end
        end
        return owned
    end

    -- Reverse ancestry is built from the installed edition's ROM evolution
    -- graph. No hard-coded Kanto/Hoenn families or National Dex assumptions.
    local graph, graphEdition
    local function ancestors(species, visiting)
        local out = {}
        local stack = { species }
        while #stack > 0 do
            local id = table.remove(stack)
            for parent in pairs(graph.reverse[id] or {}) do
                if not out[parent] and parent ~= species then
                    out[parent] = true
                    stack[#stack + 1] = parent
                end
            end
        end
        return out
    end

    local function evolutionGraph(edition)
        if graph and graphEdition == edition then return graph end
        local ok, Pokemon = pcall(require, "src.core.game3.pokemon")
        if not ok or type(Pokemon) ~= "table"
            or type(Pokemon.evolutions) ~= "function" then
            return nil
        end
        local reverse, forward, edges = {}, {}, 0
        -- Internal Gen 3 IDs include form slots above the 386 Pokédex species.
        -- Invalid species return an empty evolution list in the native API.
        for source = 1, 512 do
            local success, list = pcall(Pokemon.evolutions, source)
            if success and type(list) == "table" then
                for _, evo in ipairs(list) do
                    local target = tonumber(evo.target or evo[3])
                    if target and target > 0 and target ~= source then
                        target = math.floor(target)
                        reverse[target] = reverse[target] or {}
                        forward[source] = forward[source] or {}
                        reverse[target][source] = true
                        forward[source][target] = true
                        edges = edges + 1
                    end
                end
            end
        end
        if edges == 0 then return nil end
        graph, graphEdition = { reverse = reverse, forward = forward }, edition
        return graph
    end

    function M.isDuplicate(s, rawSpecies, session, edition)
        local mode = M.get(s, "dupes_mode") or 0
        if mode == 0 then return false end
        local species = numericSpecies(rawSpecies)
        if not species then return false end -- missing identity: fail open
        local owned = M.ownedSpecies(s, session)
        if owned[species] then return true end
        if mode == 1 then return false end
        if not evolutionGraph(edition) then return false end
        local ancestorsOfWild = ancestors(species)
        for previous in pairs(owned) do
            local previousAncestors = ancestors(previous)
            -- SPLIT: only ancestor/descendant lineages are duplicates.
            if ancestorsOfWild[previous] or previousAncestors[species] then
                return true
            end
            -- FAM: siblings after a branch also count. Every pair of
            -- evolution-family members shares at least one ancestor/root.
            if mode == 2 then
                local rootsWild = { [species] = true }
                local rootsPrevious = { [previous] = true }
                for id in pairs(ancestorsOfWild) do rootsWild[id] = true end
                for id in pairs(previousAncestors) do rootsPrevious[id] = true end
                for id in pairs(rootsWild) do
                    if rootsPrevious[id] then return true end
                end
            end
        end
        return false
    end

    function M.isShiny(mon)
        if type(mon) ~= "table" then return false end
        local ok, Pokemon = pcall(require, "src.core.game3.pokemon")
        if ok and Pokemon and type(Pokemon.isShiny) == "function" then
            local success, result = pcall(Pokemon.isShiny, mon)
            if success then return result == true end
        end
        return mon.isShiny == true
    end

    -- Gen 3 roamers (legendary dogs and Lati@s) have persistent individuals
    -- whose location changes naturally. Do not waste the route's encounter
    -- on an encounter that moves away: a caught roamer consumes only its
    -- species-specific slot.
    function M.roamerActive(s)
        return M.get(s, "gen3_roamer_clause") == 1
    end

    function M.roamerAvailable(s, rawSpecies)
        M.normalise(s)
        if not M.roamerActive(s) then return false end
        local id = numericSpecies(rawSpecies)
        return id ~= nil and s.roamerClaims[tostring(id)] ~= true
    end

    function M.claimRoamer(s, rawSpecies)
        M.normalise(s)
        if not M.roamerActive(s) then return false end
        local id = numericSpecies(rawSpecies)
        if not id then return false end
        if s.roamerClaims[tostring(id)] == true then return false end
        s.roamerClaims[tostring(id)] = true
        return true
    end

    function M.canUseShinyException(s)
        local limit = M.get(s, "shiny_clause") or 0
        return limit == 4 or (limit > 0
            and (s.shinyExceptionsUsed or 0) < limit)
    end

    function M.noteCaught(s, species, shinyException)
        M.normalise(s)
        local id = numericSpecies(species)
        if id then s.capturedSpecies[tostring(id)] = true end
        if shinyException then
            s.shinyExceptionsUsed = s.shinyExceptionsUsed + 1
        end
    end

    return M
end
