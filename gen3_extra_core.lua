-- Gen 3 CORE helpers: opening-rival detection, nickname audit and PC rescue.
-- Uses native session Pokemon; mod-save records contain metadata, not copies.
return function()
    local M = { api = 1 }

    local HOENN_FIRST_RIVAL = {
        [520] = true, [523] = true, [526] = true,
        [529] = true, [532] = true, [535] = true,
    }

    function M.openingRival(ev, native)
        if type(ev) ~= "table" or ev.kind ~= "trainer"
            or type(ev.battle) ~= "table" then return false end
        local id = tonumber(ev.trainerId or ev.battle.trainerId)
        if not id then return false end
        local battle = ev.battle
        -- FireRed/LeafGreen: Professor Oak's laboratory, not Route 22.
        if id >= 326 and id <= 328 then
            return battle.earlyRival == true
        end
        -- R/S/E: the three starter match-ups for each rival on Route 103.
        -- The Ruby/Sapphire IDs are BRENDAN_1/4/7 and MAY_1/4/7;
        -- Emerald's corresponding IDs explicitly name ROUTE_103.
        local edition = tostring(native and
            (native.version or native.edition or native.gameId) or ""):lower()
        if edition == "ruby" or edition == "sapphire"
            or edition == "emerald" then
            return HOENN_FIRST_RIVAL[id] == true
        end
        return false -- unknown version: never forgive an unrelated fight
    end

    local function trim(value)
        if type(value) ~= "string" then return "" end
        return (value:gsub("^%s+", ""):gsub("%s+$", ""))
    end

    function M.customName(name, species)
        local nick, base = trim(name):upper(), trim(species):upper()
        return nick ~= "" and nick ~= "EGG" and
            (base == "" or nick ~= base)
    end

    local function pokemonIdentity(mon, location)
        local species = tostring(mon.species or mon.speciesId or "")
        if mon.personality ~= nil then
            return species .. ":" .. tostring(mon.personality)
                .. ":" .. tostring(mon.otId or mon.trainerId or "")
        end
        return location
    end

    local function eachMon(native, callback)
        if type(native) ~= "table" then return end
        for slot, mon in ipairs(native.party or {}) do
            if type(mon) == "table" then callback(mon, "party", slot, nil) end
        end
        local storage = native.storage
        for boxId, box in ipairs(storage and storage.boxes or {}) do
            for slot = 1, 30 do
                local mon = box and box.mons and box.mons[slot]
                if type(mon) == "table" then callback(mon, "box", slot, boxId) end
            end
        end
    end

    -- A pending nickname is a mod-local requirement, not a native Pokemon
    -- mutation. Scanning both party and PC catches gifts, trades and hatches,
    -- including acquisitions which do not emit a common mod event.
    function M.auditNicknames(s, native, Display)
        local pending, items = {}, {}
        eachMon(native, function(mon, where, slot, box)
            if mon.isEgg or mon.isBadEgg then return end
            local species = Display.speciesName(mon)
            if not M.customName(mon.nickname, species) then
                local location = where .. ":" .. tostring(box or "") ..
                    ":" .. tostring(slot)
                local id = pokemonIdentity(mon, location)
                pending[id] = { species = species, location = location }
                items[#items + 1] = {
                    mon = mon, where = where, slot = slot, box = box,
                    name = species, id = id,
                }
            end
        end)
        if type(s) == "table" then s.nicknamePending = pending end
        return items
    end

    local function isDeadInArchive(s, mon)
        local species = tostring(mon.species or mon.speciesId or "")
        if mon.personality == nil then return false end
        for _, death in ipairs(s.graveyard or {}) do
            local archive = death.archive
            if type(archive) == "table" and
                tostring(archive.species or archive.speciesId or "") == species
                and tostring(archive.personality or "") ==
                    tostring(mon.personality) then
                return true
            end
        end
        return false
    end

    -- Caller invokes this ONLY after battle writeback and permadeath
    -- retirement. Move, do not copy, one living eligible PC Pokemon. This
    -- prevents an empty native party from softlocking the whiteout return.
    function M.rescueFromPc(s, native)
        if type(native) ~= "table" or type(native.party) ~= "table"
            or #native.party >= 6 then return false end
        -- Preserve Eggs but never rescue if any usable party member
        -- already remains; only a living PC mon can prevent a softlock.
        for _,existing in ipairs(native.party) do
            if type(existing)~="table"
                or (existing.isEgg~=true and existing.isBadEgg~=true) then
                return false
            end
        end
        local boxes = native.storage and native.storage.boxes
        if type(boxes) ~= "table" then return false end
        for boxId, box in ipairs(boxes) do
            for slot = 1, 30 do
                local mon = box and box.mons and box.mons[slot]
                if type(mon) == "table" and mon.isEgg ~= true
                    and mon.isBadEgg ~= true
                    and mon.nuzlockeDead ~= true
                    and mon.nuzlockeDeathRecorded ~= true
                    and mon.nuzlockeIneligible ~= true
                    and mon.nuzlockeProgressionLocked ~= true
                    and (tonumber(mon.hp) or 0) > 0
                    and not isDeadInArchive(s, mon) then
                    box.mons[slot] = nil
                    native.party[#native.party + 1] = mon
                    s.pcRescues = (tonumber(s.pcRescues) or 0) + 1
                    s.lastPcRescue = { box = boxId, slot = slot,
                        species = mon.species or mon.speciesId }
                    return true
                end
            end
        end
        return false
    end

    return M
end
