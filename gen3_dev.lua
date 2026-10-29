-- Gen 3 developer-only state editing and carefully validated archive recovery.
-- All mutations require explicit dev opt-in, are battle-gated and mark the
-- Nuzlocke save as a test run. Never export mutating methods to other mods.
return function(api)
    local M = { api = 1 }
    local getState = assert(api.getState)
    local setState = assert(api.setState)
    local getCurrentArea = assert(api.getCurrentArea)
    local inBattle = assert(api.inBattle)
    local getSession = assert(api.getSession)
    local Archive = assert(api.archive, "dev recovery needs archive copier")

    local function context(s)
        if type(s.dev) ~= "table" then s.dev = {} end
        local dev = s.dev
        dev.enabled = dev.enabled == true
        dev.tainted = dev.tainted == true
        dev.edits = math.max(0, math.floor(tonumber(dev.edits) or 0))
        if type(dev.history) ~= "table" then dev.history = {} end
        return dev
    end

    local function audit(s, action)
        local d = context(s)
        d.tainted = true
        d.edits = d.edits + 1
        d.lastAction = tostring(action)
        d.history[#d.history + 1] = d.lastAction
        if #d.history > 20 then table.remove(d.history, 1) end
        setState(s)
    end

    local function guard()
        if inBattle() then return nil, "battle_active" end
        local s = getState()
        if not context(s).enabled then return nil, "dev_disabled" end
        return s
    end

    function M.status()
        local s = getState()
        local d = context(s)
        return {
            enabled = d.enabled, tainted = d.tainted,
            edits = d.edits, lastAction = d.lastAction,
        }
    end

    -- Opt in via a confirmation in the menu. Once tainted, always tainted
    -- for this run, even when dev tools are switched back off.
    function M.enable()
        if inBattle() then return false, "battle_active" end
        local s = getState()
        local d = context(s)
        if not d.enabled then
            d.enabled = true
            audit(s, "DEV ENABLE")
        end
        return true
    end

    function M.disable()
        local s, err = guard()
        if not s then return false, err end
        context(s).enabled = false
        audit(s, "DEV DISABLE")
        return true
    end

    function M.currentArea()
        return getCurrentArea()
    end

    function M.areas()
        local s = getState()
        local out = {}
        for key, value in pairs(s.areas or {}) do
            if type(key) == "string" and type(value) == "table" then
                out[#out + 1] = {
                    key = key,
                    caught = value.caught == true,
                    spent = api.areaSpent(value),
                    attempts = tonumber(value.attempts) or 0,
                }
            end
        end
        table.sort(out, function(a, b) return a.key < b.key end)
        return out
    end

    function M.inspect()
        local s = getState()
        local party = getSession() and getSession().party or {}
        local spent, open, caught = 0, 0, 0
        for _, area in pairs(s.areas or {}) do
            if api.areaSpent(area) then spent = spent + 1
            else open = open + 1 end
            if type(area) == "table" and area.caught then
                caught = caught + 1
            end
        end
        local d = context(s)
        return {
            enabled = s.enabled == true,
            failed = s.failed == true,
            party = type(party) == "table" and #party or 0,
            map = getCurrentArea(),
            areasSpent = spent, areasOpen = open, areasCaught = caught,
            deaths = #(s.graveyard or {}),
            dupesMode = s.clauses and s.clauses.dupes_mode or 0,
            shinyMode = s.clauses and s.clauses.shiny_clause or 0,
            shinyUsed = s.shinyExceptionsUsed or 0,
            roamersClaimed = (function()
                local n = 0
                for _, claimed in pairs(s.roamerClaims or {}) do
                    if claimed then n = n + 1 end
                end
                return n
            end)(),
            edits = d.edits,
            tainted = d.tainted,
            lastAction = d.lastAction,
        }
    end

    function M.setArea(key, mode)
        local s, err = guard()
        if not s then return false, err end
        if type(key) ~= "string" or key == "" then
            return false, "unknown_map"
        end
        if mode ~= "open" and mode ~= "spent"
            and mode ~= "caught" and mode ~= "clear" then
            return false, "invalid_mode"
        end
        if mode == "clear" then
            if s.areas[key] == nil then return false, "not_recorded" end
            s.areas[key] = nil
        else
            local existing = s.areas[key]
            local entry = type(existing) == "table" and existing or {}
            -- A dev edit is a deliberate override of the map's claim state,
            -- not an edit to any actual captured/boxed Pokémon.
            entry.spent = mode ~= "open"
            entry.caught = mode == "caught"
            entry.attempts = tonumber(entry.attempts) or 0
            s.areas[key] = entry
        end
        audit(s, "AREA " .. mode:upper() .. " " .. key)
        return true
    end

    function M.clearAllAreas()
        local s, err = guard()
        if not s then return false, err end
        s.areas = {}
        audit(s, "AREAS CLEAR ALL")
        return true
    end

    -- Test-only token injection to avoid needing to repeat Gym battles. This
    -- bypasses badge rewards but not the clause's route eligibility checks.
    function M.grantTestToken()
        local saved, err = guard()
        if not saved then return false, err end
        if type(saved.forgiveness) ~= "table" then
            saved.forgiveness = {}
        end
        local f = saved.forgiveness
        f.tokens = math.max(0, math.floor(tonumber(f.tokens) or 0)) + 1
        audit(saved, "FORGIVENESS TEST TOKEN")
        return true
    end

    -- Only complete individual snapshots are eligible. Never reconstruct
    -- Pokémon from a species/level memorial, and never restore the same
    -- personality/species while an individual already exists in party/PC.
    -- An open party slot is preferred; if full, use an existing native PC
    -- box slot. Do not call Storage.ensure here: preflight must be read-only.
    local function sameIdentity(mon,arch)
        if type(mon)~="table" then return false end
        local a=tonumber(mon.species or mon.speciesId)
        local b=tonumber(arch.species or arch.speciesId)
        local pa,pb=tonumber(mon.personality),tonumber(arch.personality)
        return a~=nil and b~=nil and a==b
            and pa~=nil and pb~=nil and pa==pb
    end

    local function locateSlot(native,arch)
        local party=native.party
        if type(party)~="table" then return nil,"party_unavailable" end
        for _,mon in pairs(party) do
            if sameIdentity(mon,arch) then return nil,"already_present" end
        end
        local storage=native.storage
        if type(storage)~="table" or type(storage.boxes)~="table" then
            -- Even when party has room, refuse recovery if PC residents
            -- cannot be checked for duplicates.
            return nil,"pc_unavailable"
        end
        local firstBox,firstSlot
        for b=1,14 do
            local box=storage.boxes[b]
            if type(box)=="table" and type(box.mons)=="table" then
                for _,mon in pairs(box.mons) do
                    if sameIdentity(mon,arch) then
                        return nil,"already_present"
                    end
                end
                if not firstBox then
                    for slot=1,30 do
                        if box.mons[slot]==nil then
                            firstBox,firstSlot=b,slot
                            break
                        end
                    end
                end
            elseif box~=nil then
                return nil,"pc_invalid"
            end
        end
        local count=0
        for index,mon in pairs(party) do
            if type(index)~="number" or index<1
                or index>6 or index~=math.floor(index)
                or type(mon)~="table" then
                return nil,"party_invalid"
            end
            count=count+1
        end
        if count<6 then
            for slot=1,6 do
                if party[slot]==nil then
                    if slot~=count+1 then return nil,"party_invalid" end
                    return {where="party",index=slot}
                end
            end
        end
        if firstBox then
            return {where="pc",box=firstBox,index=firstSlot}
        end
        return nil,"no_space"
    end

    function M.restoreCandidates()
        local s=getState()
        local out={}
        for i,entry in ipairs(s.graveyard or {}) do
            if type(entry)=="table" then
                local archive=entry.archive
                if entry.archiveComplete==true
                    and type(archive)=="table"
                    and archive.personality~=nil
                    and (archive.species~=nil or archive.speciesId~=nil)
                    and (tonumber(archive.maxHp or archive.maxhp) or 0)>=1
                    and archive.isEgg~=true then
                    out[#out+1]={index=i,entry=entry}
                end
            end
        end
        return out
    end

    function M.restorePokemon(index)
        local s,err=guard()
        if not s then return false,err end
        -- A terminal result is irreversible even with developer tools:
        -- restoring archived Pokémon does not unlock a failed run.
        if s.failed or (type(s.finalResult)=="table"
            and s.finalResult.outcome~="VICTORY") then
            return false,"run_ended"
        end
        if type(index)~="number" or index~=math.floor(index)
            or index<1 then return false,"invalid_index" end
        local entry=type(s.graveyard)=="table" and s.graveyard[index]
        if type(entry)~="table" or entry.archiveComplete~=true then
            return false,"archive_incomplete"
        end
        local arch=entry.archive
        if type(arch)~="table" or arch.isEgg==true
            or (tonumber(arch.maxHp or arch.maxhp) or 0)<1
            or arch.personality==nil
            or (arch.species==nil and arch.speciesId==nil) then
            return false,"archive_incomplete"
        end
        local fresh,complete=Archive.snapshot(arch)
        if not complete or not fresh then
            return false,"archive_incomplete"
        end
        local native=getSession()
        if type(native)~="table" then return false,"session_unavailable" end
        local slot,reason=locateSlot(native,fresh)
        if not slot then return false,reason end
        local maxHp=math.floor(tonumber(fresh.maxHp or fresh.maxhp) or 0)
        fresh.hp=math.max(1,math.floor(maxHp/2))
        fresh.nuzlockeDead=nil
        fresh.nuzlockeDeathRecorded=nil
        if slot.where=="party" then
            native.party[slot.index]=fresh
        else
            native.storage.boxes[slot.box].mons[slot.index]=fresh
        end
        table.remove(s.graveyard,index)
        audit(s,"POKEMON RESTORE "..tostring(fresh.species or fresh.speciesId))
        return true,slot.where
    end

    function M.clearGraveyard()
        local s, err = guard()
        if not s then return false, err end
        s.graveyard = {}
        audit(s, "GRAVEYARD CLEAR")
        return true
    end

    -- Clear only clause bookkeeping for repeatable tests. Pokémon physically
    -- present in the party or boxes, or memorialised in the graveyard, still
    -- count towards Dupes: this does NOT erase the Pokémon's existence.
    function M.clearClauseHistory()
        local s, err = guard()
        if not s then return false, err end
        s.capturedSpecies = {}
        s.shinyExceptionsUsed = 0
        s.roamerClaims = {}
        audit(s, "CLAUSE COUNTERS RESET")
        return true
    end

    -- Useful for attaching a compact snapshot to bug reports from the game's
    -- console. Never dumps raw save data or Pokémon ownership identifiers.
    function M.printReport()
        local s, err = guard()
        if not s then return false, err end
        local view = M.inspect()
        print("[NUZ DEV] ----- GEN 3 DEBUG REPORT -----")
        print("[NUZ DEV] MAP=" .. tostring(view.map)
            .. " ENABLED=" .. tostring(view.enabled)
            .. " LOST=" .. tostring(view.failed)
            .. " PARTY=" .. tostring(view.party)
            .. " DEATHS=" .. tostring(view.deaths))
        print("[NUZ DEV] AREA_SPENT=" .. tostring(view.areasSpent)
            .. " AREA_OPEN=" .. tostring(view.areasOpen)
            .. " AREA_CAUGHT=" .. tostring(view.areasCaught)
            .. " EDITS=" .. tostring(view.edits))
        print("[NUZ DEV] DUPES_MODE=" .. tostring(view.dupesMode)
            .. " SHINY_CLAUSE=" .. tostring(view.shinyMode)
            .. " SHINY_USED=" .. tostring(view.shinyUsed)
            .. " ROAMER_CLAIMS=" .. tostring(view.roamersClaimed))
        for _, area in ipairs(M.areas()) do
            print("[NUZ DEV] AREA " .. area.key
                .. " SPENT=" .. tostring(area.spent)
                .. " CAUGHT=" .. tostring(area.caught)
                .. " ATTEMPTS=" .. tostring(area.attempts))
        end
        print("[NUZ DEV] ----- END DEBUG REPORT -----")
        return true
    end

    -- A run can be re-armed only if the native party is already nonempty.
    -- This never recreates deleted Pokémon, heals anyone or touches the PC.
    function M.clearFailed()
        local s, err = guard()
        if not s then return false, err end
        local native = getSession()
        local party = native and native.party
        local living = false
        if type(party) == "table" then
            for _, mon in ipairs(party) do
                if type(mon) == "table" and mon.isEgg ~= true
                    and mon.nuzlockeDead ~= true
                    and (tonumber(mon.hp) or 0) > 0 then
                    living = true
                    break
                end
            end
        end
        if not living then return false, "no_living_party" end
        s.failed = false
        audit(s, "RUN FAILURE CLEAR")
        return true
    end

    return M
end
