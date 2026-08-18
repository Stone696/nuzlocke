-- Optional Gold Pokegear Cards integration for Nuzlocke.
--
-- Uses only the active provider's mod.exports API. It never directly patches
-- Pokegear and deliberately does not append to PHONE.

return function(mod, opts)
    opts = opts or {}

    local CARD_ID = "nuzlocke_status"
    local MAP_ID = "nuzlocke_map_status"
    local RADIO_ID = "nuzlocke_radio_world"
    local installedApi = nil
    local installCount = 0

    local function S(text, ...)
        local translate = opts.translate
        if type(translate) == "function" then
            local ok, out = pcall(translate, text, ...)
            if ok and out ~= nil then return tostring(out) end
        end
        if select("#", ...) > 0 then
            local ok, out = pcall(string.format, tostring(text), ...)
            if ok then return out end
        end
        return tostring(text or "")
    end

    local function fit(text, width)
        text = tostring(text or "")
        width = math.max(1, math.floor(tonumber(width) or 18))
        if #text <= width then return text end
        return text:sub(1, math.max(1, width - 1)) .. "."
    end

    local function isGold(game)
        local beta = mod.exports and mod.exports.__beta26
        if beta and type(beta.runtimeIsGold) == "function" then
            local ok, value = pcall(beta.runtimeIsGold, game or mod.game)
            if ok then return value == true end
        end
        return false
    end

    local function getTable(key)
        local value = mod.save:get(key, {})
        return type(value) == "table" and value or {}
    end

    local function countTrackerCatches()
        local total = 0
        for key, entries in pairs(getTable("tracker_log")) do
            if key ~= "__LEGACY__" and type(entries) == "table" then
                for _, entry in ipairs(entries) do
                    if type(entry) == "table" and entry.species then
                        total = total + 1
                    end
                end
            end
        end
        return total
    end

    local function countCaughtAreas()
        local total = 0
        for key, value in pairs(getTable("caught_areas")) do
            if key ~= "__LEGACY__" and value ~= nil then total = total + 1 end
        end
        return total
    end

    local function countVisitedAreas()
        local total = 0
        for key, value in pairs(getTable("visited_areas")) do
            if key ~= "__LEGACY__" and value == true then total = total + 1 end
        end
        return total
    end

    local function countFailedAreas()
        local total = 0
        for key, state in pairs(getTable("encounter_states")) do
            if key ~= "__LEGACY__" and type(state) == "table"
                and tostring(state.status or ""):upper() == "FAILED" then
                total = total + 1
            end
        end
        return total
    end

    local function ruleNames()
        local beta = mod.exports and mod.exports.__beta26
        if beta and type(beta.goldPokegearRuleNames) == "function" then
            local ok, value = pcall(beta.goldPokegearRuleNames)
            if ok and type(value) == "table" then return value end
        end
        if mod.save:get("nuzlocke_enabled", true) ~= true then
            return { S("Nuzlocke OFF") }
        end
        return {}
    end

    local function capInfo(game)
        local beta = mod.exports and mod.exports.__beta26
        if beta and type(beta.getNextLevelCapInfo) == "function" then
            local ok, value = pcall(beta.getNextLevelCapInfo,
                game and game.save or nil)
            if ok and type(value) == "table" then return value end
        end
        return { cap = 100, level = 100, boss = "MAX", maximum = true }
    end

    local function forgivenessTokens()
        local beta = mod.exports and mod.exports.__beta26
        if beta and type(beta.forgivenessTokens) == "function" then
            local ok, value = pcall(beta.forgivenessTokens)
            if ok then return math.max(0, math.floor(tonumber(value) or 0)) end
        end
        return math.max(0, math.floor(tonumber(
            mod.save:get("route_forgiveness_tokens", 0)) or 0))
    end

    local function lockeName()
        local mode = math.max(0, math.floor(tonumber(
            mod.save:get("locke_type", 1)) or 1))
        return ({
            [0] = "CUSTOM", [1] = "NUZLOCKE", [2] = "HARDCORE",
            [3] = "SOLO", [4] = "IRONMON", [5] = "VANILLA",
        })[mode] or "CUSTOM"
    end

    local function difficultyName()
        local id = tostring(mod.save:get(
            "difficulty_provider_id", "vanilla") or "vanilla")
        if id == "" then id = "vanilla" end
        return id:upper()
    end

    local function snapshot(gear)
        local cap = capInfo(gear and gear.game)
        local rules = ruleNames()
        local capValue = tonumber(cap.cap or cap.level) or 100
        return {
            enabled = mod.save:get("nuzlocke_enabled", true) == true,
            catches = countTrackerCatches(),
            deaths = math.max(0, math.floor(tonumber(
                mod.save:get("nuzlocke_losses", 0)) or 0)),
            failed = countFailedAreas(),
            caughtAreas = countCaughtAreas(),
            visitedAreas = countVisitedAreas(),
            tokens = forgivenessTokens(),
            cap = capValue,
            boss = tostring(cap.boss or cap.name or "MAX"),
            maximum = cap.maximum == true or capValue >= 100,
            rules = rules,
            locke = lockeName(),
            difficulty = difficultyName(),
        }
    end

    local function landmarkForArea(gear, areaId)
        areaId = tostring(areaId or "")
        if areaId == "" or areaId == "__LEGACY__" then return nil end

        local landmarks = gear and gear.landmarks and gear.landmarks.landmarks
        if type(landmarks) ~= "table" then return nil end
        if type(landmarks[areaId]) == "table" then return landmarks[areaId] end

        local game = gear and gear.game
        local maps = (game and game.world and game.world.maps)
            or (game and game.data and game.data.gen2Maps) or {}
        local def = maps[areaId]
        if not def then
            local parent = areaId
            parent = parent:gsub("_NORTH$", "")
            parent = parent:gsub("_SOUTH$", "")
            parent = parent:gsub("_EAST$", "")
            parent = parent:gsub("_WEST$", "")
            def = maps[parent]
        end

        local landmarkId = def and def.landmark
        if landmarkId and type(landmarks[landmarkId]) == "table" then
            return landmarks[landmarkId]
        end
        return nil
    end

    local function gearRegion(gear)
        if gear and type(gear.region) == "function" then
            local ok, value = pcall(gear.region, gear)
            if ok and (value == "johto" or value == "kanto") then return value end
        end
        return "johto"
    end

    local function landmarkInRegion(entry, region)
        local index = tonumber(entry and entry.index)
        if not index then return true end
        if index == 94 then return region == "johto" end
        if region == "kanto" then return index >= 46 and index <= 93 end
        return index >= 1 and index <= 45
    end

    -- rank: visited/open=1, failed=2, caught=3.
    local function landmarkStates(gear)
        local byEntry = {}
        local function set(areaId, rank)
            local entry = landmarkForArea(gear, areaId)
            if not (entry and entry.x and entry.y) then return end
            local key = tostring(entry.index or entry.name or areaId)
            local old = byEntry[key]
            if not old or rank > old.rank then
                byEntry[key] = { entry = entry, rank = rank }
            end
        end

        for areaId, visited in pairs(getTable("visited_areas")) do
            if visited == true then set(areaId, 1) end
        end
        for areaId, state in pairs(getTable("encounter_states")) do
            if type(state) == "table"
                and tostring(state.status or ""):upper() == "FAILED" then
                set(areaId, 2)
            end
        end
        for areaId, value in pairs(getTable("caught_areas")) do
            if value ~= nil then set(areaId, 3) end
        end
        for areaId, entries in pairs(getTable("tracker_log")) do
            if type(entries) == "table" then
                for _, entry in ipairs(entries) do
                    if type(entry) == "table" and entry.species then
                        set(areaId, 3)
                        break
                    end
                end
            end
        end
        return byEntry
    end

    local function currentLandmarkState(gear)
        local current = gear and gear.currentLandmark
        local landmarks = gear and gear.landmarks and gear.landmarks.landmarks
        local entry = landmarks and current and landmarks[current]
        if not entry then return 0 end
        local key = tostring(entry.index or entry.name or current)
        local state = landmarkStates(gear)[key]
        return state and state.rank or 0
    end

    local function hashText(text)
        local n = 0
        text = tostring(text or "")
        for i = 1, #text do n = (n * 33 + text:byte(i)) % 65521 end
        return n
    end

    local function radioLine(gear)
        if mod.save:get("gold_radio_world_building", false) ~= true then return nil end
        local beta = mod.exports and mod.exports.__beta26
        if beta and type(beta.goldRadioLine) == "function" then
            local ok, line = pcall(beta.goldRadioLine, gear and gear.game)
            if ok and line ~= nil then return tostring(line) end
        end
        if mod.save:get("nuzlocke_enabled", true) ~= true then return nil end
        local tier = math.max(0, math.min(3, math.floor(tonumber(
            mod.save:get("world_building_tier", 0)) or 0)))
        if tier <= 0 then return nil end

        local state = currentLandmarkState(gear)
        if tier == 1 then
            return ({ [0] = "NUZ: RUN ACTIVE", [1] = "NUZ: AREA OPEN",
                [2] = "NUZ: AREA LOST", [3] = "NUZ: CATCH LOGGED" })[state]
        elseif tier == 2 then
            return ({ [0] = "JOHTO NUZ REPORT", [1] = "JOHTO: SLOT OPEN",
                [2] = "JOHTO: CHANCE LOST", [3] = "JOHTO: AREA CLAIMED" })[state]
        end

        local pools = {
            [0] = { "NUZLOCKE AIRWAVES", "TRAIN SAFE, JOHTO",
                "KEEP THE RUN ALIVE" },
            [1] = { "ONE CHANCE WAITS", "LOCAL SLOT IS OPEN",
                "CHOOSE THIS CATCH" },
            [2] = { "LOCAL CHANCE IS GONE", "ROUTE REPORT: NO CATCH",
                "THAT SLOT IS LOST" },
            [3] = { "LOCAL CATCH LOGGED", "AREA CLAIMED: MOVE ON",
                "ONE PARTNER FOUND HERE" },
        }
        local pool = pools[state] or pools[0]
        local seed = hashText((gear and gear.currentLandmark) or "")
            + countTrackerCatches() + countFailedAreas()
        return pool[(seed % #pool) + 1]
    end

    local function drawCard(api, gear)
        local H = api.helpers
        local snap = snapshot(gear)
        local state = api.state(CARD_ID)
        state.page = math.max(1, math.min(4,
            math.floor(tonumber(state.page) or 1)))
        state.ruleOffset = math.max(0,
            math.floor(tonumber(state.ruleOffset) or 0))

        H.drawStrip(gear)
        H.textbox(gear, 0, 3, 18, 11)
        H.text(gear, fit(("NUZ %d/4"):format(state.page), 18), 2, 4)

        if state.page == 1 then
            H.text(gear, fit(snap.enabled and "RUN ACTIVE" or "RUN OFF", 16), 2, 6)
            H.text(gear, fit("CAUGHT " .. snap.catches, 16), 2, 8)
            H.text(gear, fit("DEATHS " .. snap.deaths, 16), 2, 10)
            H.text(gear, fit("TOKENS " .. snap.tokens, 16), 2, 12)
            H.text(gear, fit("LOAD " .. snap.locke, 16), 2, 14)
        elseif state.page == 2 then
            H.text(gear, "ENCOUNTERS", 2, 6)
            H.text(gear, fit("CAUGHT A " .. snap.caughtAreas, 16), 2, 8)
            H.text(gear, fit("VISITED " .. snap.visitedAreas, 16), 2, 10)
            H.text(gear, fit("LOST " .. snap.failed, 16), 2, 12)
            H.text(gear, fit("TOTAL C " .. snap.catches, 16), 2, 14)
        elseif state.page == 3 then
            H.text(gear, "RULES", 2, 6)
            if #snap.rules == 0 then
                H.text(gear, "NONE", 2, 8)
            else
                local visible = 4
                local maxOffset = math.max(0, #snap.rules - visible)
                if state.ruleOffset > maxOffset then state.ruleOffset = maxOffset end
                for row = 1, visible do
                    local name = snap.rules[state.ruleOffset + row]
                    if name then H.text(gear, fit(name, 16), 2, 7 + row * 2) end
                end
            end
        else
            local capText = snap.maximum and "NEXT CAP MAX"
                or ("NEXT CAP " .. math.floor(snap.cap))
            H.text(gear, "CAPS & DIFF", 2, 6)
            H.text(gear, fit(capText, 16), 2, 8)
            H.text(gear, fit("BOSS " .. snap.boss, 16), 2, 10)
            H.text(gear, fit("DIFF " .. snap.difficulty, 16), 2, 12)
            H.text(gear, fit("LOAD " .. snap.locke, 16), 2, 14)
        end
        H.text(gear, fit("UP/DN PAGE B:BACK", 18), 1, 16)
    end

    local function updateCard(api, gear, input)
        local state = api.state(CARD_ID)
        state.page = math.max(1, math.min(4,
            math.floor(tonumber(state.page) or 1)))
        state.ruleOffset = math.max(0,
            math.floor(tonumber(state.ruleOffset) or 0))

        if input:wasPressed("up") then
            state.page = state.page > 1 and state.page - 1 or 4
            state.ruleOffset = 0
        elseif input:wasPressed("down") then
            state.page = state.page < 4 and state.page + 1 or 1
            state.ruleOffset = 0
        elseif input:wasPressed("a") and state.page == 3 then
            local names = ruleNames()
            local visible = 4
            local maxOffset = math.max(0, #names - visible)
            if maxOffset > 0 then
                state.ruleOffset = state.ruleOffset + visible
                if state.ruleOffset > maxOffset then state.ruleOffset = 0 end
            end
        end
    end

    local function drawMapOverlay(api, gear)
        if not isGold(gear and gear.game) then return end
        local H = api.helpers
        local region = gearRegion(gear)
        local colors = {
            [1] = { 80, 160, 255 },
            [2] = { 255, 80, 80 },
            [3] = { 80, 220, 100 },
        }
        for _, row in pairs(landmarkStates(gear)) do
            if landmarkInRegion(row.entry, region) then
                H.marker(gear, row.entry.x, row.entry.y, colors[row.rank])
            end
        end
    end

    local function drawRadioOverlay(api, gear)
        if not isGold(gear and gear.game) then return end
        local line = radioLine(gear)
        if line and line ~= "" then api.helpers.text(gear, fit(line, 18), 1, 11) end
    end

    local function activeApi()
        local ok, handle = pcall(mod.find, "pokegear_cards")
        if not ok or not handle then return nil end
        local api = handle.exports
        if type(api) ~= "table" or api.apiVersion ~= 1 then return nil end
        if type(api.register) ~= "function" or type(api.append) ~= "function"
            or type(api.state) ~= "function" or type(api.helpers) ~= "table" then
            return nil
        end
        return api
    end

    local function tryInstall()
        local api = activeApi()
        if not api then return false end
        if installedApi == api and type(api.get) == "function"
            and api.get(CARD_ID) and api.get(MAP_ID) and api.get(RADIO_ID) then
            return true
        end

        local unregisterCard, cardErr = api.register({
            id = CARD_ID,
            label = "NUZ",
            icon = api.DEFAULT_ICON,
            priority = 70,
            owner = mod.id,
            visible = function(gear) return isGold(gear and gear.game) end,
            draw = function(gear) drawCard(api, gear) end,
            update = function(gear, input) updateCard(api, gear, input) end,
        })
        if not unregisterCard then
            if mod.log and mod.log.warn then
                mod.log:warn("Pokegear NUZ card registration failed: %s",
                    tostring(cardErr))
            end
            return false
        end

        local unmap, mapErr = api.append({
            host = "map",
            id = MAP_ID,
            kind = "overlay",
            priority = 70,
            owner = mod.id,
            visible = function(gear) return isGold(gear and gear.game) end,
            draw = function(gear) drawMapOverlay(api, gear) end,
        })
        if not unmap then
            pcall(unregisterCard)
            if mod.log and mod.log.warn then
                mod.log:warn("Pokegear NUZ map overlay failed: %s",
                    tostring(mapErr))
            end
            return false
        end

        local unradio, radioErr = api.append({
            host = "radio",
            id = RADIO_ID,
            kind = "overlay",
            priority = 70,
            owner = mod.id,
            visible = function(gear)
                return isGold(gear and gear.game)
                    and mod.save:get("gold_radio_world_building", false) == true
                    and (tonumber(mod.save:get("world_building_tier", 0)) or 0) > 0
            end,
            draw = function(gear) drawRadioOverlay(api, gear) end,
        })
        if not unradio then
            pcall(unmap)
            pcall(unregisterCard)
            if mod.log and mod.log.warn then
                mod.log:warn("Pokegear NUZ radio overlay failed: %s",
                    tostring(radioErr))
            end
            return false
        end

        installedApi = api
        installCount = installCount + 1
        mod.exports.pokegear_cards = {
            apiVersion = 1,
            provider = "pokegear_cards",
            cardId = CARD_ID,
            mapAppendId = MAP_ID,
            radioAppendId = RADIO_ID,
            phoneAppend = false,
            installCount = installCount,
        }
        if mod.log and mod.log.info then
            mod.log:info("Pokegear Cards integration active: NUZ + MAP + RADIO")
        end
        return true
    end

    -- 2.3.12: optional provider discovery begins at lifecycle events below.
    if mod.events and type(mod.events.on) == "function" then
        mod.events:on("mods.loaded", function() pcall(tryInstall) end)
        mod.events:on("game.ready", function() pcall(tryInstall) end)
        mod.events:on("save.loaded", function() pcall(tryInstall) end)
    end

    return {
        tryInstall = tryInstall,
        snapshot = snapshot,
        landmarkStates = landmarkStates,
        radioLine = radioLine,
    }
end
