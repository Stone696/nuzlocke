-- EXPERIMENTAL Gen 3 runtime: CORE, encounter CLAUSES, independent shiny
-- odds, roamer slots and full-fidelity death archive for future recovery.
-- Deliberately independent of main.lua's Gen 1/2 save schema and UI.
return function(mod)
    local KEY = "gen3_classic_v1"
    -- Load mod-local modules without require-path assumptions. The mature
    -- Gen 1/2 runtime keeps its own API and its own save schema.
    local function readModule(path)
        local source, err = mod:read(path)
        assert(type(source) == "string",
            "Nuzlocke cannot read " .. path .. ": " .. tostring(err))
        local chunk, compileError = (loadstring or load)(
            source, "@mods/nuzlocke/" .. path)
        assert(type(chunk) == "function",
            "Nuzlocke cannot compile " .. path .. ": " .. tostring(compileError))
        return chunk()
    end
    local Core = readModule("gen3_core_rules.lua")()
    local Clauses = readModule("gen3_clauses.lua")()
    local CatchRules = readModule("gen3_catch_rules.lua")()
    local BattleItemRules = readModule("gen3_battle_items.lua")()
    local FieldRules = readModule("gen3_field_items.lua")()
    local Services = readModule("gen3_services_economy.lua")()
    local Stats = readModule("gen3_pokemon_stats.lua")()
local AreaSplits = readModule("gen3_area_splits.lua")()
local RunParty = readModule("gen3_run_party.lua")()
local Difficulty = readModule("gen3_difficulty.lua")()
    local Hardcore = readModule("gen3_hardcore_rules.lua")()
    local Qol = readModule("gen3_qol.lua")()
    local QolSetup = readModule("gen3_qol_setup.lua")()
    local RunSetup = readModule("gen3_run_setup.lua")()
    local Variants = readModule("gen3_variants.lua")()
    local BattleClauses = readModule("gen3_battle_clauses.lua")()
    local StatusBans = readModule("gen3_status_bans.lua")()
    local Playstyles = readModule("gen3_playstyles.lua")()
    local ShinyRate = readModule("gen3_shiny_rate.lua")()
    local ModSupport = readModule("gen3_mod_support.lua")()
    local Archive = readModule("gen3_archive.lua")()
    local Eggs = readModule("gen3_eggs.lua")()
    local Forgiveness = readModule("gen3_forgiveness.lua")()
    local Display = readModule("gen3_display.lua")()
    local Results = readModule("gen3_run_results.lua")()
    local ResultsScreen = readModule("gen3_results_screen.lua")()
    local ShinyVisuals = readModule("gen3_shiny_visuals.lua")()
    local Extra = readModule("gen3_extra_core.lua")()
    local Levels = readModule("gen3_levels.lua")()
    local Notices = readModule("gen3_notices.lua")()
    local Randomizer = readModule("gen3_randomizer.lua")()
    -- Optional National Dex API v2: enumerate only registered base species
    -- and forms, never assume a numeric engine-slot ceiling. Re-evaluate
    -- after save changes so absent / late providers fail back to vanilla.
    local function nationalDexProvider()
        if type(mod.find) ~= "function" then return nil end
        local ok, dex = pcall(mod.find, mod, "national_dex_gen3")
        if not ok or type(dex) ~= "table" then return nil end
        return dex.exports
    end
    Randomizer.setSpeciesProvider(nationalDexProvider)
    CatchRules.setSpeciesProvider(nationalDexProvider)
    Display.setSpeciesProvider(nationalDexProvider)
    local currentArea
    local activeBattle
    local pendingRoamer
    local dungeonEntry
    local battleInProgress = false
    local currentBattleState
    local battleDeaths -- in-battle irrevocable faint records (not party-array removals)
    local mercyBattle
    local setupDraft, pendingNewGameState
    local expReports = setmetatable({}, { __mode = "k" })
    local function loadState()
        local s = Core.normalise(setupDraft or mod.save:get(KEY, {}))
        return Clauses.normalise(s)
    end

    local function writeState(s)
        if setupDraft then setupDraft=s else mod.save:set(KEY,s) end
    end

    local function areaKey(value)
        if type(value) == "string" and value ~= "" then return value end
        if type(value) == "number" then return tostring(value) end
        return nil -- unknown maps must never be silently merged
    end

    local function game()
        return mod.game
    end

    local function session()
        local g = game()
        return g and g.session
    end

    -- Gen 3 has no dedicated shiny mini-icon art. Leave Pokemon.monIcon
    -- completely native for both PC box and party slots: shrinking a front
    -- sprite into a mini-icon causes empty/incorrect native icon rendering.
    -- The PC portrait still uses extracted shiny ROM artwork below.
    local function installShinyVisualGuards()
        local okP,Pokemon=pcall(require,"src.core.game3.pokemon")
        if not okP or type(Pokemon)~="table" then return false end
        local okC,Chrome=pcall(require,"src.ui.game3.pc_chrome")
        local panelMark="__nuzVisualPanelWrap"
        if okC and type(Chrome)=="table"
            and type(Chrome.drawLeftDataPanel)=="function"
            and (Chrome[panelMark]~=Chrome.drawLeftDataPanel
                or Chrome.__nuzVisualOwner~=mod) then
            local native=Chrome.drawLeftDataPanel
            local function panel(mon,...)
                local original=native(mon,...)
                if loadState().enabled
                    and ShinyVisuals.isShiny(Pokemon,mon) then
                    pcall(ShinyVisuals.drawPcPortrait,Pokemon,mon)
                end
                return original
            end
            Chrome.drawLeftDataPanel=panel
            Chrome[panelMark]=panel
            Chrome.__nuzVisualOwner=mod
        end
        return true
    end

    local function countBadgesForResult()
        local ok,SaveMenu=pcall(require,"src.ui.game3.save_menu")
        if ok and type(SaveMenu.countBadges)=="function" then
            local worked,n=pcall(SaveMenu.countBadges,session())
            if worked and type(n)=="number" then return n end
        end
        return session() and session().badgeCount or 0
    end
    local function saveTerminalRecord()
        local running=game()
        -- mod.game is the LIVE Game3 instance, NOT a Gen 1/Game2 owner.
        -- Native Game3:saveGame persists script flags, the live Gen3
        -- session, mod save data and all standard save.write safeguards.
        -- Calling writeSave here ALWAYS fails: Game3 does not have it.
        -- Do not invoke quickSaveAllowed: terminal UI is intentionally
        -- modal, and that optional player hotkey policy rejects open menus.
        if not running or type(running.saveGame)~="function" then
            return false,"Gen 3 saveGame unavailable"
        end
        local ok,written,err=pcall(running.saveGame,running)
        if not ok then return false,tostring(written) end
        if written~=true then
            return false,tostring(err or
                (written==false and "Game refused the save"
                    or "Game save returned no confirmation"))
        end
        return true
    end
    local function openFinalScreen(record)
        if type(record)~="table" then return false end
        local stored=loadState()
        if type(stored.finalResult)=="table" then
            local okP,Pokemon=pcall(require,"src.core.game3.pokemon")
            if Results.enrich(stored,session(),okP and Pokemon or nil) then
                writeState(stored)
            end
            record=stored.finalResult
        end
        local running=game()
        local ok,opened=pcall(ResultsScreen.open,running,record,{
            shinyVisuals=ShinyVisuals,
            display=Display,
            onQuit=function()
                if running and type(running.returnToTitle)=="function" then
                    ResultsScreen.close()
                    return running:returnToTitle()
                end
                return false
            end,
            onSave=function()
                local hadError=record.saveError
                record.saveError=nil
                local ok,why=saveTerminalRecord()
                if not ok then record.saveError=tostring(why or hadError) end
                return ok,why
            end,
        })
        -- Headless test harnesses and early save-load callbacks may not
        -- have the Game 3 UI stack available yet. The terminal record
        -- remains saved and is re-opened on map entry or the next load.
        return ok and opened==true
    end
    local function finishRun(outcome,reason,auto)
        local saved=loadState()
        if saved.enabled~=true or not session() then
            return false,"A Nuzlocke run is not active"
        end
        local record=Results.finish(saved,session(),Display,
            outcome,reason,countBadgesForResult())
        if not record then return false,"Unable to record this run" end
        writeState(saved)
        if auto or outcome~="VICTORY" then
            local ok,why=saveTerminalRecord()
            if not ok then
                record.saveError=tostring(why)
                Notices.add(saved,"RUN_SAVE_WARNING",
                    "Run ended, but autosave failed: "..tostring(why)
                        ..". Retry from the results screen.")
                writeState(saved)
            end
        end
        openFinalScreen(record)
        return true
    end
    local function installChampionResultHook()
        local ok,Hof=pcall(require,"src.ui.game3.hall_of_fame")
        if not ok or type(Hof)~="table"
            or type(Hof.close)~="function" then return false end
        if Hof.__nuzResultsOwner==mod
            and Hof.__nuzResultsClose==Hof.close then return true end
        local previous=Hof.close
        local function guarded(...)
            local wasOpen=Hof.open==true
            local result=previous(...)
            local native=session()
            -- Only after native Hall of Fame induction finished: game
            -- clear flag, HOF team and engine save must already exist.
            if wasOpen and type(native)=="table"
                and native.game_cleared==true
                and type(native.hallOfFameTeams)=="table"
                and #native.hallOfFameTeams>0 then
                local saved=loadState()
                if saved.enabled and not saved.failed
                    and type(saved.finalResult)~="table" then
                    finishRun("VICTORY","Champion defeated",true)
                end
            end
            return result
        end
        Hof.close=guarded
        Hof.__nuzResultsClose=guarded
        Hof.__nuzResultsOwner=mod
        return true
    end

    -- The first physically carried native Ball unlocks area accounting.
    -- A PC item alone never arms a route. Successful legacy catches also
    -- establish a past unlock; the flag remains true after Ball depletion.
    local function captureAvailable(saved)
        if saved.captureUnlocked == true then return true end
        local native = session()
        local pocket = native and native.bag and native.bag.pockets
            and native.bag.pockets.POKE_BALLS
        if type(pocket) == "table" then
            for _, entry in pairs(pocket) do
                if type(entry) == "table"
                    and (tonumber(entry.qty) or 0) > 0 then
                    saved.captureUnlocked = true
                    writeState(saved)
                    return true
                end
            end
        end
        for _, entry in pairs(saved.areas or {}) do
            if type(entry) == "table" and entry.caught == true then
                saved.captureUnlocked = true
                writeState(saved)
                return true
            end
        end
        return false
    end

    local function deliverPendingStartingBalls()
        local native = session()
        if not (native and native.modData
            and (tonumber(native.modData.nuzQolDeferredBalls) or 0) > 0) then
            return
        end
        local saved = loadState()
        if not captureAvailable(saved) then return end
        local ok, Storage = pcall(require, "src.core.game3.storage")
        if ok then QolSetup.deliverBalls(saved, native, Storage) end
    end

    local function areaNow()
        local s = session()
        return areaKey(currentArea) or areaKey(s and s.map)
    end

    -- Use a separate identity for encounter accounting; map IDs stay
    -- native for story scripts, services and randomizer seed sources.
    local function encounterAreaNow(saved)
        local mapId=areaNow()
        if not mapId then return nil end
        local native=session()
        local g=game()
        local def=g and g.data and g.data.maps and g.data.maps[mapId]
        local layout=def and (type(def.layout)=="table" and def.layout or def) or {}
        return AreaSplits.resolve(saved or loadState(),Core,mapId,{
            x=native and (native.x or native.playerX),
            y=native and (native.y or native.playerY),
            width=layout and layout.width,
            height=layout and layout.height,
        })
    end

    -- Untamed builds OWE personalities before there is a wild battle. Keep
    -- a small bounded cache of those exact individuals so the ordinary
    -- battle-start shiny-rate handler never rerolls a visible non-shiny.
    local oweShinySeen, oweShinyOrder = {}, {}
    local function oweShinyIdentity(species, personality)
        if type(personality) ~= "number"
            or type(species) ~= "number"
            or personality < 0 or personality ~= math.floor(personality) then
            return nil
        end
        return tostring(species) .. ":" .. tostring(personality)
    end
    local function noteOWEShiny(species, personality)
        local key = oweShinyIdentity(species, personality)
        if not key or oweShinySeen[key] then return end
        oweShinySeen[key] = true
        oweShinyOrder[#oweShinyOrder + 1] = key
        if #oweShinyOrder > 256 then
            oweShinySeen[table.remove(oweShinyOrder, 1)] = nil
        end
    end
    local function resetOWEShinies()
        oweShinySeen, oweShinyOrder = {}, {}
    end
    local function shinyRandomUnit()
        if love and love.math and love.math.random then
            return love.math.random()
        end
        return math.random()
    end

    -- Gen 3 RANDOMIZER deliberately runs even if Nuzlocke rules are OFF.
    local function randomSpecies(source, key, original, excluded, wildScope, wildSlot, themeType)
        local saved = loadState()
        local ok, Pokemon = pcall(require, "src.core.game3.pokemon")
        if not ok then return nil end
        local usedBefore = Randomizer.locked(saved)
        local result, name = Randomizer.replace(saved, Pokemon, source,
            key, original, function()
                -- AUTO consumes engine entropy once per game save and stores
                -- the resolved seed; all subsequent selections are pure.
                return math.random(1, 99999999)
            end,function(national)
                return Core.active(saved)
                    and CatchRules.isBannedNational(saved,national)
            end, excluded, wildScope, wildSlot, themeType)
        if result then
            if not usedBefore then
                Notices.add(saved, "RANDOMIZER_LOCK",
                    "Randomiser seed and settings locked after first result.")
            end
            writeState(saved)
        end
        return result, name
    end

    -- TM/HM compatibility and move display/teaching all call Pokemon's
    -- native resolver. Replacing the two shared methods preserves the
    -- original TM item ID, consumption, bag and native party menu flow.
    -- Reinstalled on session changes without stacking our own wrappers.
    local function installRandomTmResolvers()
        local ok,Pokemon=pcall(require,"src.core.game3.pokemon")
        if not ok or type(Pokemon)~="table" then return false end
        local tag="__nuzRandomTmMove"
        if type(Pokemon.moveFromTmItem)=="function"
            and (Pokemon[tag]~=Pokemon.moveFromTmItem
                or Pokemon.__nuzRandomTmOwner~=mod) then
            local native=Pokemon.moveFromTmItem
            local function resolve(item)
                local original=native(item)
                if not Randomizer.get(loadState(),"random_tms") then
                    return original
                end
                local id=tonumber(item)
                if not id then
                    local okI,ItemsData=pcall(require,
                        "src.core.game3.items_data")
                    if okI and type(ItemsData.toNumericId)=="function" then
                        local okNum,num=pcall(ItemsData.toNumericId,item)
                        if okNum then id=tonumber(num) end
                    end
                end
                if not id or id<289 or id>338
                    or not original then return original end
                local nativeMoves={}
                for index=1,50 do
                    nativeMoves[index]=native(288+index)
                end
                local saved=loadState()
                local locked=Randomizer.locked(saved)
                local moves=Randomizer.tms(saved,Pokemon,nativeMoves,
                    function() return math.random(1,99999999) end)
                if not moves then return original end
                if not locked then
                    Notices.add(saved,"RANDOMIZER_LOCK",
                        "TM moves fixed for this run; randomiser locked.")
                end
                writeState(saved)
                return moves[id-288] or original
            end
            Pokemon.moveFromTmItem=resolve
            Pokemon[tag]=resolve
            Pokemon.__nuzRandomTmOwner=mod
        end
        local compatTag="__nuzRandomTmCompat"
        if type(Pokemon.canLearnTmIndex)=="function"
            and (Pokemon[compatTag]~=Pokemon.canLearnTmIndex
                or Pokemon.__nuzRandomTmOwner~=mod) then
            local native=Pokemon.canLearnTmIndex
            local function compatible(species,index)
                local original=native(species,index)
                if Randomizer.get(loadState(),
                    "random_tm_compatibility")==0 then return original end
                local saved=loadState()
                local locked=Randomizer.locked(saved)
                local result=Randomizer.tmCanLearn(saved,Pokemon,
                    species,index,
                    function() return math.random(1,99999999) end)
                if result==nil then return original end
                if not locked then
                    Notices.add(saved,"RANDOMIZER_LOCK",
                        "TM compatibility fixed for this run; randomiser locked.")
                end
                writeState(saved)
                return result
            end
            Pokemon.canLearnTmIndex=compatible
            Pokemon[compatTag]=compatible
            Pokemon.__nuzRandomTmOwner=mod
        end
        return true
    end
    installRandomTmResolvers()

    -- The underlying Pokemon accessors are shared by initial party
    -- move generation, level-up, evolution and UI. Wrap once, preserving
    -- the native ROM arrays and all evolution method requirements.
    local function installRandomProgressionResolvers()
        local ok,Pokemon=pcall(require,"src.core.game3.pokemon")
        if not ok or type(Pokemon)~="table" then return false end
        local methods={
            {"learnset","learnset","random_learnsets"},
            {"evolutions","evolutions","random_evolutions"},
        }
        for _,entry in ipairs(methods) do
            local key,policy,toggle=entry[1],entry[2],entry[3]
            local marker="__nuzRandom_"..key
            if type(Pokemon[key])=="function"
                and (Pokemon[marker]~=Pokemon[key]
                    or Pokemon.__nuzProgressOwner~=mod) then
                local previous=Pokemon[key]
                if key=="evolutions" then
                    Pokemon.__nuzNativeEvolutions=previous
                end
                local function resolver(species)
                    local native=previous(species)
                    if not Randomizer.get(loadState(),toggle)
                        then return native end
                    local id=type(species)=="table"
                        and (Pokemon.speciesOf
                            and Pokemon.speciesOf(species)) or species
                    if type(id)=="string"
                        and type(Pokemon.speciesFromName)=="function" then
                        id=Pokemon.speciesFromName(id) or tonumber(id)
                    end
                    local saved=loadState()
                    local locked=Randomizer.locked(saved)
                    local result=Randomizer[policy](saved,Pokemon,
                        id,native,function()
                            return math.random(1,99999999)
                        end)
                    if not result then return native end
                    if not locked then
                        Notices.add(saved,"RANDOMIZER_LOCK",
                            "Randomised "..key.." fixed for this run.")
                    end
                    writeState(saved)
                    return result
                end
                Pokemon[key]=resolver
                Pokemon[marker]=resolver
                Pokemon.__nuzProgressOwner=mod
            end
        end
        return true
    end
    installRandomProgressionResolvers()

    -- The RSE bag chooser reads StarterChoose.species() for its label,
    -- portrait, cry AND FieldRse.giveStarter(). Override that resolver,
    -- not the ROM starter manifest, to keep its three options consistent.
    -- FRLG instead asks GetStarterSpecies before its scripted givemon.
    local nativeRseStarterSpecies
    local function starterChoices(source, originals)
        local saved = loadState()
        if not Randomizer.get(saved, "random_starter") then return nil end
        local ok, Pokemon = pcall(require, "src.core.game3.pokemon")
        if not ok then return nil end
        local already = Randomizer.locked(saved)
        local choices = Randomizer.starters(saved, Pokemon, source,
            originals, function() return math.random(1, 99999999) end,
            function(national)
                return Core.active(saved)
                    and CatchRules.isBannedNational(saved, national)
            end)
        if choices then
            if not already then
                Notices.add(saved, "RANDOMIZER_LOCK",
                    "Starter choices fixed for this run; randomiser locked.")
            end
            writeState(saved)
        end
        return choices
    end
    -- Manual rerolls are deliberately outside the config lock. Once the
    -- starter has joined the party, the action is unavailable.
    local function manualStarterReroll(source, originals)
        local native = session()
        if type(native) ~= "table" or type(native.party) ~= "table"
            or #native.party > 0 then return nil, "starter_already_received" end
        if type(originals) ~= "table" or #originals ~= 3 then
            return nil, "starter_manifest_unavailable" end
        -- Allow the player to reroll from the Nuz menu before viewing the
        -- first trio (Oak's scripted choice opens the same saved selections).
        if not starterChoices(source, originals) then
            return nil, "starter_choices_unavailable" end
        local saved = loadState()
        local ok, Pokemon = pcall(require, "src.core.game3.pokemon")
        if not ok then return nil, "pokemon_data_unavailable" end
        local trio, why = Randomizer.rerollStarters(saved, Pokemon, source,
            originals, function(national)
                return Core.active(saved)
                    and CatchRules.isBannedNational(saved, national)
            end)
        if trio then writeState(saved) end
        return trio, why
    end

    local FRLG_STARTERS = { 1, 7, 4 } -- Bulbasaur, Squirtle, Charmander
    local function isOakLab()
        local native = session()
        local map = tostring(native and native.map or ""):upper()
        return map:find("OAK", 1, true) ~= nil
            and map:find("LAB", 1, true) ~= nil
    end
    local function installStarterResolvers()
        local okR, Chooser = pcall(require, "src.ui.game3.rse.starter_choose")
        if okR and type(Chooser) == "table"
            and type(Chooser.species) == "function"
            and Chooser.__nuzGen3StarterOwner ~= mod then
            local original = Chooser.species
            nativeRseStarterSpecies = original
            Chooser.species = function(man, selection)
                local base = original(man, selection)
                if base == nil then return base end
                local manifest = man or (type(Chooser.manifest) == "function"
                    and Chooser.manifest())
                local list = manifest and manifest.species
                if type(list) ~= "table" or #list ~= 3 then return base end
                local choices = starterChoices("rse", list)
                local index = tonumber(selection)
                return choices and index and choices[index + 1] or base
            end
            -- RSE bag is its own fullscreen native UI; SELECT rerolls in
            -- the selection state, and refreshes the label immediately.
            if type(Chooser.frame) == "function" then
                local frame = Chooser.frame
                Chooser.frame = function(screen, inp, ...)
                    if screen and screen.state == "input" and inp
                        and inp.new and inp.new.select then
                        local trio = manualStarterReroll("rse",
                            screen.man and screen.man.species)
                        if trio then
                            if type(screen._clearLabel) == "function" then
                                screen:_clearLabel()
                            end
                            if type(screen._createLabel) == "function" then
                                screen:_createLabel()
                            end
                        end
                    end
                    return frame(screen, inp, ...)
                end
            end
            if type(Chooser.draw) == "function" then
                local draw = Chooser.draw
                Chooser.draw = function(screen, ...)
                    local result = draw(screen, ...)
                    if screen and screen.state == "input"
                        and Randomizer.get(loadState(), "random_starter") then
                        local st = Randomizer.starterRerollStatus(loadState())
                        if st.limit ~= 0 then
                            local okFont, Font = pcall(require,
                                "src.ui.game3.frlg_font")
                            if okFont and type(Font.draw) == "function" then
                                local left = st.remaining == -1
                                    and "INF" or tostring(st.remaining)
                                pcall(Font.draw,
                                    "SELECT: REROLL ("..left..")", 8, 144,
                                    {font="narrow"})
                            end
                        end
                    end
                    return result
                end
            end
            Chooser.__nuzGen3StarterOwner = mod
        end
        local okF, Queries = pcall(require,
            "src.core.game3.scripting.natives_queries")
        local byName = okF and type(Queries) == "table"
            and Queries.BY_NAME or nil
        if type(byName) == "table"
            and type(byName.GetStarterSpecies) == "function"
            and Queries.__nuzGen3StarterOwner ~= mod then
            local original = byName.GetStarterSpecies
            byName.GetStarterSpecies = function(ctx, ...)
                local status, species = original(ctx, ...)
                if not isOakLab() then return status, species end
                local choices = starterChoices("frlg", FRLG_STARTERS)
                if choices then
                    for i, base in ipairs(FRLG_STARTERS) do
                        if species == base then return status, choices[i] end
                    end
                end
                return status, species
            end
            Queries.__nuzGen3StarterOwner = mod
        end
    end
    installStarterResolvers()
    -- Oak's three ball scripts set VAR_TEMP_2 (0x4002) BEFORE showmonpic
    -- and givemon. Replace that initial value so the portrait, dialogue,
    -- cry, and eventual gift all agree. VAR_TEMP_3 is the rival's chosen
    -- species for the same scripted conversation. Leave both script rows
    -- and the ROM data immutable for other mods.
    local function starterScriptCommand(op, row)
        if op ~= "setvar" or type(row) ~= "table" or not isOakLab() then
            return row
        end
        local native = session()
        if type(native) ~= "table" or #(native.party or {}) > 0 then
            return row
        end
        local target = tonumber(row.var or row[1])
        if target ~= 0x4002 and target ~= 0x4003 then return row end
        local source = tonumber(row.value or row[2])
        local index
        for i, original in ipairs(FRLG_STARTERS) do
            if source == original then index = i; break end
        end
        if not index then return row end
        local choices = starterChoices("frlg", FRLG_STARTERS)
        if not choices then return row end
        local copy = {}
        for k, v in pairs(row) do copy[k] = v end
        if row.value ~= nil then copy.value = choices[index]
        else copy[2] = choices[index] end
        return copy
    end

    -- Explicit ROM story rival IDs, not trainer classes. The game also
    -- contains other rivals, Wally and player-vs-player trainers whose
    -- teams must not inherit the protagonist's random starter trio.
    local FRLG_RIVALS = {}
    for id = 326, 334 do FRLG_RIVALS[id] = true end
    for id = 426, 441 do FRLG_RIVALS[id] = true end
    for id = 739, 741 do FRLG_RIVALS[id] = true end
    local RSE_RIVALS = {}
    for id = 520, 537 do RSE_RIVALS[id] = true end
    for _, id in ipairs({
        592, 593, 599, 600, 768, 769,
        661, 662, 663, 664, 665, 666
    }) do RSE_RIVALS[id] = true end
    local function rivalStarter(trainerId, sourceSpecies)
        local native = session()
        local edition = tostring(native and
            (native.version or native.edition or native.gameId) or ""):lower()
        local isFrlg = edition == "firered" or edition == "leafgreen"
        local isRse = edition == "ruby" or edition == "sapphire"
            or edition == "emerald"
        local id = tonumber(trainerId)
        if not id or not ((isFrlg and FRLG_RIVALS[id])
            or (isRse and RSE_RIVALS[id])) then return nil end
        local saved = loadState()
        local rng = saved.randomizer
        if type(rng) ~= "table" or not rng.random_starter
            or type(rng.starterOptions) ~= "table" then return nil end
        local source = isFrlg and "frlg" or "rse"
        if rng.starterSource ~= source then return nil end
        local originals = isFrlg and FRLG_STARTERS or nil
        if isRse then
            local ok, Chooser = pcall(require,
                "src.ui.game3.rse.starter_choose")
            local manifest = ok and type(Chooser) == "table"
                and type(Chooser.manifest) == "function"
                and Chooser.manifest() or nil
            originals = manifest and manifest.species
        end
        if type(originals) ~= "table" then return nil end
        local ok, Pokemon = pcall(require, "src.core.game3.pokemon")
        if not ok then return nil end
        return Randomizer.rivalStarter(saved, Pokemon, source, originals,
            sourceSpecies, function(national)
                return Core.active(saved)
                    and CatchRules.isBannedNational(saved, national)
            end)
    end

    mod.hooks:wrap("encounter.species", function(next, encounter, ctx)
        local base = next(encounter, ctx)
        if type(base) ~= "table" or not ctx
            or ctx.mapId == nil or base.roamer == true then return base end
        local original = base.speciesId or base.species
        -- Do not serialize a table's pointer address into the source key.
        -- Only stable scalar terrain identifiers are reproducible on reload.
        local terrain = (type(ctx.terrain) == "string"
            or type(ctx.terrain) == "number") and ctx.terrain or ""
        local key = table.concat({ tostring(ctx.mapId),
            tostring(terrain), tostring(original),
            tostring(base.level or "") }, ":")
        local scope = "STEP:" .. tostring(ctx.mapId) .. ":" .. tostring(terrain)
        local id, name = randomSpecies("ENCOUNTERS", key, original,
            nil, scope, tostring(original))
        if not id then return base end
        local copy = {}
        for k, v in pairs(base) do copy[k] = v end
        copy.species = name
        copy.speciesId = id
        return copy
    end)
    -- Untamed-Advanced's wandering overworld Pokemon are authored and
    -- spawned independently of encounter.species. Its opt-in hook fires
    -- BEFORE building the world sprite and before creating the battle foe.
    -- Same Wild toggle, Gen 3 pool, fixed/AUTO seed, and balance policy.
    mod.hooks:wrap("untamed.owe.species", function(next, encounter, ctx)
        local base = next(encounter, ctx)
        if type(base) ~= "table" or type(ctx) ~= "table"
            or ctx.source ~= "untamed_advanced" or ctx.mapId == nil
            or (ctx.terrain ~= "land" and ctx.terrain ~= "water")
            or base.roamer == true or base.scripted == true then
            return base
        end
        local original = tonumber(base.species)
        local level = tonumber(base.level)
        if not original or original % 1 ~= 0 or original <= 0
            or not level or level % 1 ~= 0
            or level < 1 or level > 100 then return base end
        -- Keep this separate from native step/rod mapping: an OWE's
        -- unique source is the visible spawn, not a vanilla step roll.
        -- Coords are intentionally excluded, so the same original wild
        -- species on a route retains its identity across spawn locations.
        local key = table.concat({ "OWE", tostring(ctx.mapId),
            ctx.terrain, tostring(original) }, ":")
        local scope = "OWE:" .. tostring(ctx.mapId) .. ":" .. ctx.terrain
        local id = randomSpecies("ENCOUNTERS", key, original,
            nil, scope, tostring(original))
        if not id then return base end
        local copy = {}
        for k, v in pairs(base) do copy[k] = v end
        copy.species = id -- Untamed expects an internal numeric species ID.
        return copy
    end)

    -- The same CLAUSES -> SHINY RATE applies to generated Untamed OWEs,
    -- irrespective of Random Wild and whether Nuzlocke playstyle is ON.
    -- Untamed owns final native personality conversion and visual checks.
    mod.hooks:wrap("untamed.owe.shiny", function(next, source, ctx)
        local base = next(source, ctx)
        if type(base) ~= "table" or type(ctx) ~= "table"
            or ctx.source ~= "untamed_advanced" or ctx.mapId == nil
            or (ctx.terrain ~= "land" and ctx.terrain ~= "water")
            or type(base.species) ~= "number"
            or type(base.level) ~= "number"
            or type(base.personality) ~= "number"
            or type(base.shiny) ~= "boolean" then return base end

        local final = base
        local mode = Clauses.get(loadState(), "shiny_rate_mode")
        local extra = ShinyRate.extraProbability(mode)
        if not base.shiny and extra > 0
            and not ShinyRate.externalProvider(mod)
            and type(ctx.makeShiny) == "function"
            and (extra >= 1 or shinyRandomUnit() < extra) then
            local ok, pid = pcall(ctx.makeShiny, base.personality)
            if ok and type(pid) == "number" and pid ~= base.personality
                and pid == math.floor(pid) and pid >= 0
                and pid < 4294967296
                and pid % 65536 == base.personality % 65536 then
                final = {}
                for k, v in pairs(base) do final[k] = v end
                final.personality, final.shiny = pid, true
            end
        end
        -- Record even native/unchanged results. If rate settings are
        -- changed while a sprite is already standing on the map, that
        -- individual still keeps the shiny status it was spawned with.
        noteOWEShiny(final.species, final.personality)
        return final
    end)

    -- Gen 3's pristine save is prepared before save.created and before
    -- first map entry. Apply optional setup resources exactly at that
    -- native transaction, so an old loaded save cannot be backfilled.
    mod.hooks:wrap("save.new_game",function(next,fresh)
        local native=next(fresh)
        if type(native)~="table" then return native end
        local ok,Storage=pcall(require,"src.core.game3.storage")
        if not ok then return native end
        QolSetup.apply(loadState(),native,Storage)
        return native
    end)

    -- QOL movement operates at Gen 3's native player step-frame hook;
    -- keeping it there leaves bicycles, scripts and other systems intact.
    mod.hooks:wrap("movement.speed",function(next,frames,ctx)
        local base=next(frames,ctx)
        return Qol.frames(loadState(),base,ctx)
    end)

    -- Fishing has an independent engine hook, NOT encounter.species.
    mod.hooks:wrap("encounter.fishing", function(next, rod, mapId, pool)
        local base = next(rod, mapId, pool)
        if type(base) ~= "table" or mapId == nil or base.roamer then
            return base end
        local original = base.speciesId or base.species
        local key = table.concat({ tostring(mapId), tostring(rod),
            tostring(original), tostring(base.level or "") }, ":")
        local scope = "FISH:" .. tostring(mapId) .. ":" .. tostring(rod)
        local id, name = randomSpecies("ENCOUNTERS", "FISH:" .. key, original,
            nil, scope, tostring(original))
        if not id then return base end
        local copy = {}
        for k, v in pairs(base) do copy[k] = v end
        copy.species, copy.speciesId = name, id
        return copy
    end)
    mod.hooks:wrap("trainer.party", function(next, trainerClass,
            trainerId, party)
        local original = next(trainerClass, trainerId, party)
        if type(original) ~= "table" or #original == 0
            or tonumber(trainerId) == nil or tonumber(trainerId) <= 0 then
            return original
        end
        local result, changed = {}, false
        local unique = Randomizer.get(loadState(), "random_trainer_diversity") == 1
        local themeType
        if Randomizer.get(loadState(),"random_trainer_theme")==1 then
            local okP,Pokemon=pcall(require,"src.core.game3.pokemon")
            local lead=original[1]
            local id=lead and tonumber(lead.speciesId or lead.species)
            if okP and id and type(Pokemon.types)=="function" then
                local okT,types=pcall(Pokemon.types,id)
                if okT and type(types)=="table" then
                    themeType=tonumber(types[1])
                end
            end
        end
        local selected = {}
        for i, member in ipairs(original) do
            local newMember = {}
            for k, v in pairs(member) do newMember[k] = v end
            local key = tostring(trainerClass or "") .. ":"
                .. tostring(trainerId) .. ":" .. tostring(i)
                .. ":" .. tostring(member.speciesId or member.species or "")
            local sourceSpecies = member.speciesId or member.species
            -- The rival's original starter can occupy any party slot.
            -- Resolve before general Trainer Randomisation so it remains
            -- the same lineage even when both options are enabled.
            local id, name = rivalStarter(trainerId, sourceSpecies)
            if not id then
                id, name = randomSpecies("TRAINERS", key, sourceSpecies,
                    unique and selected or nil,nil,nil,themeType)
            end
            if not id and unique then
                -- A tiny filtered pool may lack an unused candidate. Keep
                -- native randomisation rather than deleting a team member.
                id, name = randomSpecies("TRAINERS", key, sourceSpecies,
                    nil,nil,nil,themeType)
            end
            if id then
                newMember.species, newMember.speciesId = name, id
                selected[id] = true
                changed = true
            end
            result[i] = newMember
        end
        return changed and result or original
    end)

    local function isActive()
        return Core.active(loadState())
    end

    local function nicknameTasks()
        local saved = loadState()
        if not Core.enforced(saved, "nickname_rule") then return {} end
        local previous = saved.nicknamePending or {}
        local tasks = Extra.auditNicknames(saved, session(), Display)
        local newlyPending = 0
        for _, item in ipairs(tasks) do
            if not previous[item.id] then newlyPending = newlyPending + 1 end
        end
        if newlyPending > 0 then
            Notices.add(saved, "NICKNAME_TASKS",
                tostring(newlyPending) .. " Pokemon need a nickname. "
                .. "Open NUZ MENU > NICKNAME TASKS.")
        end
        writeState(saved)
        return tasks
    end

    -- Badge flags are saved in native script state; refresh when the player
    -- moves or opens Nuzlocke, not by polling each frame.
    local function refreshForgiveness()
        local saved = loadState()
        local mode = Clauses.get(saved, "route_forgiveness")
        if mode == 0 or not Core.active(saved) then return end
        local f = saved.forgiveness
        local before = f and f.tokens or 0
        local already = f and f.initialised
        local baselined = f and f.baselined
        local earned = Forgiveness.observe(saved, mode,
            Forgiveness.badges(session()))
        if earned > 0 then
            Notices.add(saved, "FORGIVENESS_EARNED",
                "Route Forgiveness: earned " .. tostring(earned)
                .. " token(s) from new Gym badges.")
        end
        if earned > 0 or not already or
            (saved.forgiveness and saved.forgiveness.tokens ~= before)
            or (saved.forgiveness and
                saved.forgiveness.baselined ~= baselined) then
            writeState(saved)
        end
    end

    local function levelCap(saved)
        saved = saved or loadState()
        -- Hardcore requires every main-story gym/league boss cap through
        -- Champion, without modifying the user's own LEVELS scope.
        local scope = Playstyles.hardcoreActive(saved, Core) and 3 or nil
        return Levels.cap(saved, session(),
            Forgiveness.badges(session()), scope)
    end
    local function notify(code, message, inBattle)
        local saved = loadState()
        if Notices.add(saved, code, message) then writeState(saved) end
        if inBattle then Notices.battle(message) end
    end
    -- Gen 3 scripted gifts have a pre-mutation script.command seam.
    -- The gift opcode returns code 0/1 on success and 2 on failure.
    -- Block the opcode itself rather than deleting an already-owned mon.
    local function giftStarterExempt(mapId)
        local party=session() and session().party
        if type(party)~="table" or #party~=0 then return false end
        return mapId=="FR_OAKS_LAB"
            or mapId=="RU_ROUTE_101" or mapId=="SA_ROUTE_101"
            or mapId=="EM_ROUTE_101"
    end
    local function scriptVar(ctx,id)
        local vm=type(ctx)=="table" and (ctx.runner or ctx.vm)
        local raw=type(vm)=="table" and vm.ctx
        if type(raw)~="table" then return nil end
        local ok,F=pcall(require,"src.core.game3.scripting.flags")
        if not ok or type(F)~="table" or type(F.getVar)~="function" then
            return nil
        end
        -- package.loaded is unavailable to sandboxed Gen1Recomp mods.
        local okSpace,space=pcall(require,
            "src.core.game3.scripting.space")
        local store=okSpace and space and space.store
            or (session() and session().store)
        local success,v=pcall(F.getVar,store,raw,id)
        return success and v or nil
    end
    local function setScriptVar(ctx,id,value)
        local vm=type(ctx)=="table" and (ctx.runner or ctx.vm)
        local raw=type(vm)=="table" and vm.ctx
        if type(raw)~="table" then return false end
        local ok,F=pcall(require,"src.core.game3.scripting.flags")
        if not ok or type(F)~="table" or type(F.setVar)~="function" then
            return false
        end
        -- package.loaded is unavailable to sandboxed Gen1Recomp mods.
        local okSpace,space=pcall(require,
            "src.core.game3.scripting.space")
        local store=okSpace and space and space.store
            or (session() and session().store)
        return pcall(F.setVar,store,raw,id,value)
    end
    local function pokemonResolver()
        local ok,P=pcall(require,"src.core.game3.pokemon")
        return ok and P or nil
    end
    local function acquisitionEligible(kind,species,location,options)
        local saved=loadState()
        options=options or {}
        local native=session()
        local seed=tostring(native and native.trainerId or "")
            ..":"..tostring(native and native.trainerSecretId or "")
            ..":"..tostring(native and native.name or "")
        local resolver=pokemonResolver()
        if Core.active(saved) and not options.mandatoryStarter then
            local a=CatchRules.prepareAlphabet(saved,resolver,seed)
            local b=CatchRules.prepareColor(saved,resolver,seed)
            local c=Variants.prepare(saved,resolver,seed)
            if a or b or c then writeState(saved) end
        end
        options.seed=seed
        -- AREA-slot gifts/trades inherit historical claims even after
        -- the map scope is changed during a run.
        local key=encounterAreaNow(saved)
        local policy=CatchRules.get(saved,kind=="gift"
            and "gift_slot_policy" or "trade_slot_policy")
        if key and policy==0
            and Core.enforced(saved,"encounter_limit")
            and not options.mandatoryStarter
            and not AreaSplits.catchAllowed(saved,Core,key,location) then
            return false,"Area Splits: encounter slot already spent."
        end
        local allowed,why=CatchRules.canAcquire(saved,kind,species,
            key or location,resolver,Core,options)
        if not allowed or options.mandatoryStarter then return allowed,why end
        return Variants.check(saved,species,resolver,Core,seed,kind)
    end
    local function scriptGiftSpecies(ctx,row)
        local id=type(row)=="table" and (row[1] or row.species)
        local n=tonumber(id)
        if n and n>=0x4000 then return scriptVar(ctx,n) end
        return n or id
    end
    local function acquisitionReceipt(kind,species,location)
        local saved=loadState()
        local key=encounterAreaNow(saved) or location
        if not CatchRules.noteAcquired(saved,kind,species,key,Core)
            then return end
        Clauses.noteCaught(saved,species,false)
        writeState(saved)
        notify("ACQUISITION", (kind=="gift" and "Gift Pokemon" or
            "In-Game Trade")..": received Pokemon ("..
            tostring(CatchRules.get(saved,kind=="gift"
                and "gift_slot_policy" or "trade_slot_policy")==0
                and "AREA" or "BONUS").." slot).")
    end
    -- This is the native script command boundary. We replace opcode
    -- input before the engine constructs a gift/egg or a scripted foe,
    -- never mutate an existing player's Pokémon or the ROM template.
    -- Versioned key includes the script address/label when available so
    -- two independent static encounters on one map are not conflated.
    -- Rolls at the native pickup boundary, before bag capacity checks,
    -- text, consumption flags or inventory changes. No replacement is
    -- attempted for mandatory/rare story items or malformed item packs.
    local function randomFieldItem(sourceId,original,scope)
        local saved=loadState()
        if not Randomizer.get(saved,"random_field_items") then return nil end
        local ok,ItemsData=pcall(require,"src.core.game3.items_data")
        if not ok then return nil end
        local wasLocked=Randomizer.locked(saved)
        local id=Randomizer.item(saved,ItemsData,sourceId,original,
            function() return math.random(1,99999999) end,scope)
        if id then
            if not wasLocked then
                Notices.add(saved,"RANDOMIZER_LOCK",
                    "Field item choices fixed for this run; randomiser locked.")
            end
            writeState(saved)
        end
        return id
    end
    local function itemMapScope()
        local map=areaNow() or (session() and session().map)
        if map==nil or tostring(map)=="" then return nil end
        return "MAP:"..tostring(map)
    end
    local function randomTmLocation(original)
        local saved=loadState()
        if not Randomizer.get(saved,"random_tm_locations") then return nil end
        local locked=Randomizer.locked(saved)
        local result=Randomizer.tmLocation(saved,original,
            function() return math.random(1,99999999) end)
        if result then
            if not locked then
                Notices.add(saved,"RANDOMIZER_LOCK",
                    "TM locations fixed for this run.")
            end
            writeState(saved)
        end
        return result
    end
    local function randomItemBall(ctx,op,row)
        if op~="callstd" or type(row)~="table" then return end
        local std=tonumber(row.std or row[1])
        if std~=0 and std~=1 then return end
        local runner=type(ctx)=="table" and (ctx.runner or ctx.vm)
        local script=type(runner)=="table" and
            (runner._scriptKey or (runner.ctx and runner.ctx.pc
                and runner.ctx.pc.listKey))
        -- Without a script address two pickup balls on the same map
        -- could receive the wrong mapping. Fail open instead.
        if type(script)~="string" or script=="" then return end
        local scope=itemMapScope()
        if not scope then return end
        local original=scriptVar(ctx,0x8000)
        if type(original)~="number" then return end
        local sourceId=(std==0 and "GIFT:" or "VISIBLE:")
            ..scope..":"..script..":"..tostring(original)
        local picked=randomTmLocation(original)
        if not picked and std==1 then
            picked=randomFieldItem(sourceId,original,scope)
        elseif not picked and std==0 then
            local saved=loadState()
            if Randomizer.get(saved,"random_gift_items") then
                local okI,ItemsData=pcall(require,
                    "src.core.game3.items_data")
                if okI then
                    local locked=Randomizer.locked(saved)
                    picked=Randomizer.item(saved,ItemsData,sourceId,
                        original,function() return math.random(1,99999999) end,
                        scope,"GIFT")
                    if picked then
                        if not locked then
                            Notices.add(saved,"RANDOMIZER_LOCK",
                                "Gift items fixed for this run.")
                        end
                        writeState(saved)
                    end
                end
            end
        end
        if picked then setScriptVar(ctx,0x8000,picked) end
    end
    local function installRandomHiddenItemGuards()
        local ok,Field=pcall(require,"src.core.game3.field")
        if not ok or type(Field)~="table" then return false end
        for _,method in ipairs({"pickUpHiddenItem","digUpUnderfootItem"}) do
            local marker="__nuzRandom_"..method
            if type(Field[method])=="function"
                and (Field[marker]~=Field[method]
                    or Field.__nuzRandomOwner~=mod) then
                local previous=Field[method]
                local function guarded(g,hidden,...)
                    if type(hidden)~="table"
                        or type(hidden.item)~="number"
                        or hidden.item==0 then
                        return previous(g,hidden,...)
                    end
                    local scope=itemMapScope()
                    if not scope then return previous(g,hidden,...) end
                    local identity=hidden.flag or hidden.hiddenItemId
                    if identity==nil then
                        if hidden.x==nil or hidden.y==nil then
                            return previous(g,hidden,...)
                        end
                        identity=tostring(hidden.x)..":"..tostring(hidden.y)
                    end
                    local key="HIDDEN:"..scope..":"..tostring(identity)
                        ..":"..tostring(hidden.item)
                    local id=randomTmLocation(hidden.item)
                        or randomFieldItem(key,hidden.item,scope)
                    if not id then return previous(g,hidden,...) end
                    local copy={}
                    for k,v in pairs(hidden) do copy[k]=v end
                    copy.item=id
                    -- The original ROM event stays intact for the next
                    -- field load; native routine owns hidden-item flags.
                    return previous(g,copy,...)
                end
                Field[method]=guarded
                Field[marker]=guarded
                Field.__nuzRandomOwner=mod
            end
        end
        return true
    end
    installRandomHiddenItemGuards()

    local function scriptedSource(ctx, kind, original, level)
        local runner = type(ctx)=="table" and (ctx.runner or ctx.vm)
        local script = type(runner)=="table"
            and (runner._scriptKey or (runner.ctx and runner.ctx.pc
                and runner.ctx.pc.listKey)) or nil
        local map = areaNow() or (session() and session().map) or ""
        return table.concat({kind, tostring(map), tostring(script or ""),
            tostring(original), tostring(level or "")}, ":")
    end
    local function skipScriptedStarter()
        local native=session()
        local map=tostring(native and native.map or ""):upper()
        local noParty = type(native)=="table"
            and type(native.party)=="table" and #native.party==0
        return noParty and (isOakLab() or map=="FR_OAKS_LAB"
            or map=="RU_ROUTE_101" or map=="SA_ROUTE_101"
            or map=="EM_ROUTE_101")
    end
    local function cloneScript(row, id)
        local copy={}
        for k,v in pairs(row) do copy[k]=v end
        if row[1]~=nil then copy[1]=id else copy.species=id end
        return copy
    end
    local function scriptReplacement(ctx,op,row)
        if type(row)~="table" then return row end
        local source
        if op=="setwildbattle" then
            source="STATIC"
            -- The Pokémon Tower Marowak is a special ghost battle.
            -- Its battle mechanics and visibility depend on its species.
            local map=tostring(session() and session().map or ""):upper()
            if map:find("POKEMON_TOWER",1,true) then return row end
            if skipScriptedStarter() then return row end
        elseif op=="givemon" then
            source="GIFTS"
            if skipScriptedStarter() then return row end
        elseif op=="giveegg" then
            source="EGG_GIFTS"
        else
            return row
        end
        local operand=row[1] or row.species
        local original=tonumber(operand)
        if not original then return row end
        -- Direct constants are safe. For variable-backed gifts, preserve
        -- the source variable for subsequent scripted species-name text.
        if original>=0x4000 then original=tonumber(scriptVar(ctx,original)) end
        if not original or original<1 or original>512 then return row end
        local id=randomSpecies(source,
            scriptedSource(ctx,source,original,
                row[2] or row.level),original)
        if not id then return row end
        if (op=="givemon" or op=="giveegg")
            and tonumber(operand)>=0x4000 then
            -- Do not produce one species while the script's display
            -- variable still refers to another. Unsafe VM contexts fall
            -- through unchanged.
            if not setScriptVar(ctx,tonumber(operand),id) then return row end
        end
        return cloneScript(row,id)
    end
    local function specialStatic(ctx,op,row,next)
        if op~="special" and op~="specialvar" then
            return false,nil
        end
        if type(row)~="table" then return false,nil end
        local ok,Natives=pcall(require,"src.core.game3.scripting.natives")
        if not ok or type(Natives)~="table"
            or type(Natives.specialName)~="function" then return false,nil end
        local id=op=="specialvar" and row[2] or (row.id or row[1])
        local good,name=pcall(Natives.specialName,id)
        if not good or name~="CreateEnemyEventMon" then return false,nil end
        -- Run the native special FIRST: it must construct the enemy event
        -- Pokemon and set all side effects. Rewrite only its pending foe.
        local output=next(ctx,op,row)
        local okE,Enc=pcall(require,"src.core.game3.encounters")
        local pending=okE and type(Enc)=="table" and Enc._pendingWild
        if type(pending)=="table"
            and not pending.roamer and not pending.ghost then
            local original=tonumber(pending.species)
            if original and original>0 and original<0x4000 then
                local map=tostring(session() and session().map or ""):upper()
                if not map:find("POKEMON_TOWER",1,true)
                    and not skipScriptedStarter() then
                    local replacement=randomSpecies("STATIC",
                        scriptedSource(ctx,"STATIC",original,pending.level),
                        original)
                    if replacement then pending.species=replacement end
                end
            end
        end
        return true,output
    end
    mod.hooks:wrap("script.command",function(next,ctx,op,row)
        -- These streams must work even when Nuzlocke itself is OFF.
        row = starterScriptCommand(op,row)
        row = scriptReplacement(ctx,op,row)
        randomItemBall(ctx,op,row)
        local handled,result=specialStatic(ctx,op,row,next)
        if handled then return result end
        if not Core.active(loadState()) or type(row)~="table" then
            return next(ctx,op,row)
        end
        -- Check native specials before the VM mutates the party or shop.
        -- Unrelated scripted heals and story progression remain native.
        local specialName=nil
        if op=="special" or op=="specialvar" then
            local ok,Natives=pcall(require,"src.core.game3.scripting.natives")
            if ok and type(Natives)=="table"
                and type(Natives.specialName)=="function" then
                local id=op=="specialvar" and row[2]
                    or (row.id or row[1])
                local resolved,name=pcall(Natives.specialName,id)
                if resolved then specialName=name end
            end
        end
        if specialName=="HealPlayerParty"
            or specialName=="ScrSpecial_HealPlayerParty" then
            local why=Services.healDenial(loadState(),Core,areaNow())
            if why then
                notify("SERVICE_HEAL_DENIED",why,false)
                return false
            end
        end
        if specialName=="StoreSelectedPokemonInDaycare"
            or specialName=="PutMonInRoute5Daycare" then
            local why=Services.daycareDenial(loadState(),Core)
            if why then
                notify("SERVICE_DAYCARE_DENIED",why,false)
                return false
            end
        end
        if op=="playslotmachine" or specialName=="PlayRoulette"
            or specialName=="PlaySlotMachine" then
            local why=Services.gamblingDenial(loadState(),Core)
            if why then
                notify("SERVICE_GAMBLING_DENIED",why,false)
                return false
            end
        end
        if op=="givemon" then
            local species=scriptGiftSpecies(ctx,row)
            local location=areaNow()
            local mandatoryStarter=giftStarterExempt(location)
            local permitted,why=acquisitionEligible("gift",species,
                location,{mandatoryStarter=mandatoryStarter})
            if not permitted and setScriptVar(ctx,0x800D,2) then
                notify("GIFT_DENIED",why)
                return false
            end
            local result=next(ctx,op,row)
            local code=scriptVar(ctx,0x800D)
            if permitted and (code==0 or code==1)
                and not mandatoryStarter then
                acquisitionReceipt("gift",species,location)
            end
            return result
        end
        if op=="special" or op=="specialvar" then
            local ok,Natives=pcall(require,
                "src.core.game3.scripting.natives")
            if ok and type(Natives)=="table"
                and type(Natives.specialName)=="function" then
                local id=op=="specialvar" and row[2]
                    or (row.id or row[1])
                local resolved,name=pcall(Natives.specialName,id)
                if resolved and name=="GetInGameTradeSpeciesInfo" then
                    local okTrade,Trade=pcall(require,
                        "src.core.game3.scripting.natives_trade")
                    local index=scriptVar(ctx,0x8004)
                    local okEntry,entry=false,nil
                    if okTrade and Trade and Trade.entry then
                        okEntry,entry=pcall(Trade.entry,index)
                    end
                    if okEntry and type(entry)=="table" then
                        local permitted,why=acquisitionEligible(
                            "trade",entry.species,areaNow())
                        -- This native special only supplies the requested
                        -- species for the NPC dialogue. Run it first so its
                        -- display strings are still populated, then force
                        -- a species mismatch BEFORE any exchange can start.
                        if not permitted then
                            local output=next(ctx,op,row)
                            local dest=op=="specialvar" and row[1]
                                or 0x800D
                            if setScriptVar(ctx,dest,0) then
                                notify("TRADE_DENIED",why)
                            end
                            return output
                        end
                    end
                end
            end
        end
        return next(ctx,op,row)
    end)

    -- The common FRLG/RSE NPC exchange writes the outgoing party slot in
    -- Trade.tradeMons. Record only a completed swap; do not mistake the
    -- preview/create-offered-Pokemon scratch party for a real acquisition.
    local function installAcquisitionGuards()
        local ok,Trade=pcall(require,
            "src.core.game3.scripting.natives_trade")
        if not ok or type(Trade)~="table"
            or type(Trade.tradeMons)~="function" then return end
        if Trade.__nuzAcquisitionOwner==mod
            and Trade.tradeMons==Trade.__nuzAcquisitionWrap then return end
        local previous=Trade.tradeMons
        local function guarded(sess,slot,offered)
            local species=type(offered)=="table"
                and (offered.species or offered.speciesId)
            local location=areaNow()
            local permitted,why=acquisitionEligible(
                "trade",species,location)
            if not permitted then
                notify("TRADE_DENIED",why)
                return nil
            end
            local sent=previous(sess,slot,offered)
            if sent then acquisitionReceipt("trade",species,location) end
            return sent
        end
        Trade.tradeMons=guarded
        Trade.__nuzAcquisitionOwner=mod
        Trade.__nuzAcquisitionWrap=guarded
    end

    local function refreshCapNotice()
        local saved = loadState()
        if not Core.active(saved)
            or ((Levels.get(saved, "level_cap_scope") or 0) == 0
                and not Playstyles.hardcoreActive(saved, Core)) then return end
        local cap, stage = levelCap(saved)
        local levels = saved.levels
        local marker = tostring(cap or "-") .. ":" .. tostring(stage or "")
        if levels.lastObservedCap ~= marker then
            if levels.lastObservedCap ~= nil then
                local text = cap
                    and ("Level Cap: next boss allows Lv " .. cap
                        .. " (" .. tostring(stage) .. ").")
                    or "Level Cap: current scope is complete; cap lifted."
                Notices.add(saved, "LEVEL_CAP_CHANGED", text)
            end
            levels.lastObservedCap = marker
            writeState(saved)
        end
    end
    local function isCandyCapped(native, mon)
        local saved = loadState()
        if not Core.active(saved) or type(mon) ~= "table" then return false end
        local cap = levelCap(saved)
        return cap ~= nil and (tonumber(mon.level) or 1) >= cap, cap
    end
    local function candyMessage(cap)
        return "Nuzlocke: Level cap Lv " .. tostring(cap)
            .. " reached. RARE CANDY cannot be used."
    end

    local function fieldDenial(itemId,native)
        if Hardcore.dungeonEscapeLocked(loadState(),Core,
            dungeonEntry,areaNow(),AreaSplits) then
            local okI,Use=pcall(require,"src.core.game3.item_use")
            if okI and type(Use.fieldUseKind)=="function"
                and Use.fieldUseKind(itemId,native)=="escape" then
                return "Dungeon Lock-In: Escape Rope is restricted."
            end
        end
        local okI,ItemUse=pcall(require,"src.core.game3.item_use")
        local okD,ItemsData=pcall(require,"src.core.game3.items_data")
        return FieldRules.fieldDenial(loadState(),Core,itemId,
            native or session(),okI and ItemUse or nil,
            okD and ItemsData or nil)
    end

    -- The authoritative overworld path is ItemUse.useField -> item.use.
    -- Guard before native consumption. A direct useRareCandy wrapper alone
    -- cannot intercept all Gen 3 bag / RSE item paths.
    mod.hooks:wrap("item.use", function(next, game, unused, itemId,
            partySlot, bag)
        local native = session()
        local fieldReason=fieldDenial(itemId,native)
        if fieldReason then
            notify("FIELD_ITEM_DENIED",fieldReason,false)
            return false,"noeffect",fieldReason
        end
        local ok, ItemUse = pcall(require, "src.core.game3.item_use")
        if ok and type(ItemUse) == "table"
            and type(ItemUse.fieldUseKind) == "function"
            and ItemUse.fieldUseKind(itemId, native) == "level" then
            local mon = native and native.party and native.party[partySlot]
            local denied, cap = isCandyCapped(native, mon)
            if denied then
                local message = candyMessage(cap)
                notify("LEVEL_CAP_ITEM", message, false)
                return false, "noeffect", message
            end
        end
        return next(game, unused, itemId, partySlot, bag)
    end)
    -- The native Game3 PartyMenu has a separate "use" branch which
    -- directly removes Rare Candy from the bag and mutates mon.level.
    -- It NEVER calls ItemUse.useRareCandy or ItemUse.useField. Cancel the
    -- actual A-press before that branch can consume anything.
    local function installPartyCandyGuard()
        local okP, PartyMenu = pcall(require, "src.ui.game3.party_menu")
        local okI, ItemUse = pcall(require, "src.core.game3.item_use")
        if not okP or not okI or type(PartyMenu) ~= "table"
            or type(ItemUse) ~= "table"
            or type(PartyMenu.handleInput) ~= "function"
            or type(PartyMenu.showMessage) ~= "function"
            or type(ItemUse.fieldUseKind) ~= "function" then return false end
        if PartyMenu.__nuzGen3CandyOwner == mod then return true end
        local original = PartyMenu.handleInput
        PartyMenu.handleInput = function(input, ...)
            if PartyMenu.open and PartyMenu.mode == "use"
                and not PartyMenu._onSelect and input
                and type(input.wasPressed) == "function"
                and input:wasPressed("a") then
                local slot = tonumber(PartyMenu.cursor)
                local mon = slot and PartyMenu._party
                    and PartyMenu._party[slot]
                if mon and not mon.isEgg then
                    local reason=fieldDenial(PartyMenu._item,
                        PartyMenu._session)
                    if reason then
                        notify("FIELD_ITEM_DENIED",reason,false)
                        PartyMenu.showMessage(reason,function()
                            PartyMenu.mode="use"
                        end)
                        return
                    end
                end
                if mon and not mon.isEgg
                    and ItemUse.fieldUseKind(PartyMenu._item,
                        PartyMenu._session) == "level" then
                    local denied, cap = isCandyCapped(PartyMenu._session, mon)
                    if denied then
                        local message = candyMessage(cap)
                        notify("LEVEL_CAP_ITEM", message, false)
                        PartyMenu.showMessage(message, function()
                            PartyMenu.mode = "use"
                        end)
                        return
                    end
                end
            end
            return original(input, ...)
        end
        PartyMenu.__nuzGen3CandyOwner = mod
        return true
    end
    local function installCandyGuard()
        installPartyCandyGuard()
        local ok, ItemUse = pcall(require, "src.core.game3.item_use")
        if not ok or type(ItemUse) ~= "table"
            or type(ItemUse.useRareCandy) ~= "function" then return false end
        if ItemUse.__nuzGen3CandyOwner == mod then return true end
        local original = ItemUse.useRareCandy
        ItemUse.useRareCandy = function(native, mon, ...)
            local reason=fieldDenial("RARE_CANDY",native)
            if reason then
                notify("FIELD_ITEM_DENIED",reason,false)
                return false,"no_effect",reason
            end
            local denied, cap = isCandyCapped(native, mon)
            if denied then
                local message = candyMessage(cap)
                notify("LEVEL_CAP_ITEM", message, false)
                return false, "no_effect", message
            end
            return original(native, mon, ...)
        end
        ItemUse.__nuzGen3CandyOwner = mod
        return true
    end

    -- Direct native item calls used by the TM Case / medicine UI do
    -- not necessarily reach item.use. Wrap their mutation boundaries;
    -- the PartyMenu A-press guard catches its own direct TM/Candy branch.
    local function installFieldItemGuards()
        local okI,ItemUse=pcall(require,"src.core.game3.item_use")
        if okI and type(ItemUse)=="table" then
            local function protect(key,idAt,sessionAt)
                local marker="__nuzFieldWrap_"..key
                if type(ItemUse[key])~="function" then return end
                if ItemUse[marker]==ItemUse[key]
                    and ItemUse.__nuzFieldOwner==mod then return end
                local previous=ItemUse[key]
                local function guard(...)
                    local args={...}
                    local item=idAt(args)
                    local native=sessionAt(args)
                    local why=fieldDenial(item,native)
                    if why then
                        notify("FIELD_ITEM_DENIED",why,false)
                        return false,"noeffect",why
                    end
                    return previous(...)
                end
                ItemUse[key]=guard
                ItemUse[marker]=guard
            end
            protect("useTm",function(a)return a[3] end,
                function(a)return a[1] end)
            protect("useEscapeRope",function(a)return a[3] end,
                function(a)return a[1] end)
            protect("applyPpItem",function(a)return a[2] end,
                function(a)return a[5] end)
            ItemUse.__nuzFieldOwner=mod
        end
        -- The menu dispatch table captures handlers when field_moves.lua
        -- loads; replacing flyFromMenu alone would leave the old entry live.
        local okM,Moves=pcall(require,"src.core.game3.field_moves")
        if okM and type(Moves)=="table" then
            local function guardMove(name,method)
                local marker="__nuzFieldTravel_"..name
                local dispatch=Moves.MENU_HANDLERS
                local moveId=Moves.MOVES and Moves.MOVES[name]
                if type(Moves[method])~="function" then return end
                if Moves[marker]==Moves[method]
                    and (not dispatch or not moveId
                        or dispatch[moveId]==Moves[method]) then return end
                local previous=Moves[method]
                local function guarded(ctx)
                    local why=FieldRules.travelDenial(loadState(),Core,name)
                    if why then
                        notify("FIELD_TRAVEL_DENIED",why,false)
                        return {ok=false,text=why}
                    end
                    return previous(ctx)
                end
                Moves[method]=guarded
                Moves[marker]=guarded
                if type(dispatch)=="table" and moveId then
                    dispatch[moveId]=guarded
                end
            end
            guardMove("FLY","flyFromMenu")
            guardMove("TELEPORT","teleportFromMenu")
        end
        return true
    end

    -- Read live Hardcore policy at native action boundaries. Do not
    -- change the game's ROM maps, trainers, equipment or badge flags.
    local function installHardcoreGuards()
        local okE,Engine=pcall(require,"src.core.game3.battle.engine")
        if okE and type(Engine)=="table"
            and type(Engine.tryFlee)=="function"
            and Engine.__nuzHcFlee~=Engine.tryFlee then
            local previous=Engine.tryFlee
            local function guarded(st,adapter,battler,...)
                if Hardcore.blockRun(loadState(),Core,st) then
                    st.fleeAttempts=(tonumber(st.fleeAttempts) or 0)+1
                    if adapter and type(adapter.sayText)=="function" then
                        adapter:sayText("STRINGID_CANTESCAPE2")
                    end
                    return false
                end
                return previous(st,adapter,battler,...)
            end
            Engine.tryFlee=guarded
            Engine.__nuzHcFlee=guarded
        end

        local okI,ItemUse=pcall(require,"src.core.game3.item_use")
        if okI and type(ItemUse)=="table" then
            for _,method in ipairs({"giveToMon","giveHeld","switchHeld"}) do
                local tag="__nuzHc_"..method
                if type(ItemUse[method])=="function"
                    and ItemUse[tag]~=ItemUse[method] then
                    local previous=ItemUse[method]
                    local function guarded(...)
                        if Hardcore.heldGiveDenied(loadState(),Core) then
                            notify("NO_HELD_ITEMS",
                                "No Held Items: you cannot give held items.",false)
                            return false,"no_held_items",
                                "No Held Items: take existing items instead."
                        end
                        return previous(...)
                    end
                    ItemUse[method]=guarded
                    ItemUse[tag]=guarded
                end
            end
        end

        local okH,Held=pcall(require,"src.core.game3.battle.held_items")
        if okH and type(Held)=="table" and type(Held.of)=="function"
            and Held.__nuzHcOf~=Held.of then
            local previous=Held.of
            local function guarded(b,trigger,st,...)
                if Hardcore.heldEffectDenied(loadState(),Core,b) then
                    -- Preserve underlying held item for later taking.
                    return 0,0,tonumber(b.item) or 0
                end
                return previous(b,trigger,st,...)
            end
            Held.of=guarded
            Held.__nuzHcOf=guarded
        end

        local okW,Warp=pcall(require,"src.core.game3.warp")
        if okW and type(Warp)=="table" then
            local function prevent(from,dest,x,y)
                local saved=loadState()
                local okF,Flags=pcall(require,
                    "src.core.game3.scripting.flags")
                local Space=package.loaded["src.core.game3.scripting.space"]
                if okF and Hardcore.gymLocked(saved,Core,from,
                    Flags,Space and Space.store,
                    RunParty.get(saved,"gym_team_size")) then
                    notify("GYM_LOCK_IN",
                        "Gym Lock-In: defeat the Gym Leader before leaving.",
                        false)
                    return true
                end
                if Hardcore.dungeonEntranceLocked(saved,Core,
                    dungeonEntry,from,dest,x,y,AreaSplits) then
                    notify("DUNGEON_LOCK_IN",
                        "Dungeon Lock-In: use a different exit.",false)
                    return true
                end
                return false
            end
            for _,method in ipairs({"startDoorExit","startStairWarp",
                "startTeleport","startEscalator","startDoorEntrance"}) do
                local tag="__nuzHc_"..method
                if type(Warp[method])=="function"
                    and Warp[tag]~=Warp[method] then
                    local previous=Warp[method]
                    local function guarded(...)
                        local args={...}
                        local dest=args[3]
                        local px,py
                        if method=="startDoorExit" then
                            px,py=tonumber(args[6]),tonumber(args[7])
                        end
                        if not px or not py then
                            local P=package.loaded["src.core.game3.player"]
                            px,py=P and tonumber(P.cellX),
                                P and tonumber(P.cellY)
                        end
                        if prevent(areaNow(),dest,px,py) then
                            return false
                        end
                        return previous(...)
                    end
                    Warp[method]=guarded
                    Warp[tag]=guarded
                end
            end
        end

        local okM,Moves=pcall(require,"src.core.game3.field_moves")
        if okM and type(Moves)=="table" then
            for _,name in ipairs({"DIG","TELEPORT","FLY"}) do
                local method=({DIG="digFromMenu",
                    TELEPORT="teleportFromMenu",FLY="flyFromMenu"})[name]
                local tag="__nuzHcTravel_"..name
                local dispatch=Moves.MENU_HANDLERS
                local id=Moves.MOVES and Moves.MOVES[name]
                if type(Moves[method])=="function"
                    and (Moves[tag]~=Moves[method]
                        or (dispatch and id
                            and dispatch[id]~=Moves[method])) then
                    local previous=Moves[method]
                    local function guarded(ctx)
                        if Hardcore.dungeonEscapeLocked(loadState(),Core,
                            dungeonEntry,areaNow(),AreaSplits) then
                            local why="Dungeon Lock-In: "
                                .."field travel is restricted."
                            notify("DUNGEON_TRAVEL_LOCK",why,false)
                            return {ok=false,text=why}
                        end
                        return previous(ctx)
                    end
                    Moves[method]=guarded
                    Moves[tag]=guarded
                    if type(dispatch)=="table" and id then
                        dispatch[id]=guarded
                    end
                end
            end
        end
    end

    -- QOL hooks are idempotent across save/map loads, and read live
    -- settings each time. No in-place mutation of session options.
    local function installQolGuards()
        local okM,Message=pcall(require,"src.ui.game3.message")
        if okM and type(Message)=="table"
            and type(Message.show)=="function"
            and Message.__nuzQolShow~=Message.show then
            local previous=Message.show
            local function guardedShow(text,opts,...)
                return previous(text,Qol.textOptions(loadState(),opts),...)
            end
            Message.show=guardedShow
            Message.__nuzQolShow=guardedShow
        end
        if okM and type(Message)=="table" then
            -- A new page uses Message.advance, bypassing show(speed=0).
            -- Skip ONLY the reveal, not a paragraph/choice wait.
            if type(Message.advance)=="function"
                and Message.__nuzQolAdvance~=Message.advance then
                local oldAdvance=Message.advance
                local function fastAdvance(...)
                    local answer=oldAdvance(...)
                    if Qol.enabled(loadState(),"instant_text")
                        and Message.skipReveal then Message.skipReveal() end
                    return answer
                end
                Message.advance=fastAdvance
                Message.__nuzQolAdvance=fastAdvance
            end
            -- The native auto-scroller can create the next page in tick.
            if type(Message.tick)=="function"
                and Message.__nuzQolTick~=Message.tick then
                local oldTick=Message.tick
                local function fastTick(...)
                    local answer=oldTick(...)
                    if Qol.enabled(loadState(),"instant_text")
                        and Message.skipReveal then Message.skipReveal() end
                    return answer
                end
                Message.tick=fastTick
                Message.__nuzQolTick=fastTick
            end
        end
        -- Ruby/Sapphire's native field auto-scroll printer does not use
        -- Message._speedIdx. Flush character glyphs without crossing a
        -- scripted PAUSE, button wait, scroll or clear boundary.
        local okRS,RsPrinter=pcall(require,
            "src.ui.game3.rs.field_auto_scroll_message")
        if okRS and type(RsPrinter)=="table" then
            if type(RsPrinter.open)=="function"
                and RsPrinter.__nuzQolOpen~=RsPrinter.open then
                local oldOpen=RsPrinter.open
                local function fastOpen(prepared,...)
                    local ok=oldOpen(prepared,...)
                    if ok then RsPrinter.__nuzQolActive=prepared end
                    return ok
                end
                RsPrinter.open=fastOpen
                RsPrinter.__nuzQolOpen=fastOpen
            end
            if type(RsPrinter.tick)=="function"
                and RsPrinter.__nuzQolTick~=RsPrinter.tick then
                local oldTick=RsPrinter.tick
                local function fastTick(...)
                    local result=oldTick(...)
                    if not Qol.enabled(loadState(),"instant_text") then
                        return result
                    end
                    local p=RsPrinter.__nuzQolActive
                    if type(p)~="table" or p.task~=2
                        or p.mode~=RsPrinter.AUTO_SCROLL then
                        return result
                    end
                    for _=1,4096 do
                        local stage=p.printer
                        if stage~="begin" and stage~="normal"
                            and stage~="newline"
                            and stage~="char_delay" then break end
                        if stage=="char_delay" then p.delay=0 end
                        oldTick(...)
                        if p.mode~=RsPrinter.AUTO_SCROLL then break end
                    end
                    return result
                end
                RsPrinter.tick=fastTick
                RsPrinter.__nuzQolTick=fastTick
            end
        end
        -- Emerald/RSE intro/cutscene printers are separate from field text.
        local okKit,Kit=pcall(require,"src.ui.game3.rse.scene_kit")
        if okKit and type(Kit)=="table"
            and type(Kit.printer)=="function"
            and Kit.__nuzQolPrinter~=Kit.printer then
            local oldPrinter=Kit.printer
            local function fastPrinter(source,opts,...)
                if not Qol.enabled(loadState(),"instant_text") then
                    return oldPrinter(source,opts,...)
                end
                local cfg={}
                if type(opts)=="table" then
                    for k,v in pairs(opts) do cfg[k]=v end
                end
                -- A native speed=0 constructor pre-runs even explicit
                -- PAUSE controls. Build at speed 1 instead, then reveal
                -- only contiguous glyphs before any script/choice boundary.
                cfg.speed=1
                local printer=oldPrinter(source,cfg,...)
                if type(printer)=="table"
                    and type(printer.render)=="function" then
                    printer.speed=0
                    printer.delay=0
                    local emptyInput={new={},held={}}
                    local function flushChars(p)
                        for _=1,4096 do
                            if p.active==false or p.state~="char" then break end
                            p:render(emptyInput)
                        end
                    end
                    flushChars(printer)
                    if type(printer.run)=="function" then
                        local oldRun=printer.run
                        printer.run=function(self,input,...)
                            local answer=oldRun(self,input,...)
                            if self.state=="char" then flushChars(self) end
                            return answer
                        end
                    end
                end
                return printer
            end
            Kit.printer=fastPrinter
            Kit.__nuzQolPrinter=fastPrinter
        end
        -- FRLG's Professor Oak intro uses its own text printer, too.
        local okIntro,Intro=pcall(require,"src.ui.game3.new_game_scene")
        if okIntro and type(Intro)=="table"
            and type(Intro.new)=="function"
            and Intro.__nuzQolNew~=Intro.new then
            local oldNew=Intro.new
            local function fastNew(...)
                local scene=oldNew(...)
                if Qol.enabled(loadState(),"instant_text")
                    and type(scene)=="table" then scene.textSpeed=0 end
                return scene
            end
            Intro.new=fastNew
            Intro.__nuzQolNew=fastNew
        end
        local okB,Bag=pcall(require,"src.core.game3.bag")
        local okI,ItemsData=pcall(require,"src.core.game3.items_data")
        if okB and okI and type(Bag)=="table"
            and type(ItemsData)=="table" then
            for _,method in ipairs({"canAdd","add"}) do
                local tag="__nuzQol_"..method
                if type(Bag[method])=="function"
                    and Bag[tag]~=Bag[method] then
                    local previous=Bag[method]
                    local function guarded(bag,id,...)
                        return Qol.withBagCapacity(loadState(),
                            ItemsData,id,previous,bag,id,...)
                    end
                    Bag[method]=guarded
                    Bag[tag]=guarded
                end
            end
        end
    end

    -- Reinstallable native guards. Rules never rewrite game data.
    local function installServiceGuards()
        local okD,Daycare=pcall(require,"src.core.game3.daycare")
        if okD and type(Daycare)=="table" then
            for _,name in ipairs({"deposit","depositRoute5"}) do
                local marker="__nuzService_"..name
                if type(Daycare[name])=="function"
                    and Daycare[marker]~=Daycare[name] then
                    local original=Daycare[name]
                    local function guarded(...)
                        local why=Services.daycareDenial(loadState(),Core)
                        if why then
                            notify("SERVICE_DAYCARE_DENIED",why,false)
                            return nil
                        end
                        return original(...)
                    end
                    Daycare[name]=guarded
                    Daycare[marker]=guarded
                end
            end
        end
        -- RSE/RS specials and opcodes may start the Game Corner UI
        -- through this module instead of the generic script.command seam.
        local okG,GameCorner=pcall(require,
            "src.core.game3.scripting.natives_game_corner_rse")
        if okG and type(GameCorner)=="table" then
            for _,name in ipairs({"playSlotMachine","playRoulette"}) do
                local marker="__nuzServiceGambling_"..name
                if type(GameCorner[name])=="function"
                    and GameCorner[marker]~=GameCorner[name] then
                    local original=GameCorner[name]
                    local function guarded(...)
                        local why=Services.gamblingDenial(loadState(),Core)
                        if why then
                            notify("SERVICE_GAMBLING_DENIED",why,false)
                            return false
                        end
                        return original(...)
                    end
                    GameCorner[name]=guarded
                    GameCorner[marker]=guarded
                end
            end
        end
        local okS,Shop=pcall(require,"src.ui.game3.shop_menu")
        -- Use the final native inventory list at shop opening, not a
        -- global ROM mart edit. The extracted pointer is required for
        -- a stable shop identity; unidentified/non-normal shops fail open.
        if okS and type(Shop)=="table"
            and type(Shop.show)=="function"
            and (Shop.__nuzRandomShopOwner~=mod
                or Shop.__nuzRandomShopWrap~=Shop.show) then
            local previous=Shop.show
            local function randomShopShow(opts)
                if type(opts)~="table" or type(opts.items)~="table"
                    or not Randomizer.get(loadState(),"random_shops")
                    or (opts.martType and opts.martType~="NORMAL") then
                    return previous(opts)
                end
                local okM,Marts=pcall(require,"src.core.game3.marts")
                local mart=opts.mart
                if not mart and okM and type(Marts)=="table" then
                    for _,entry in pairs(Marts._byKey or {}) do
                        if type(entry)=="table"
                            and entry.items==opts.items then
                            mart=entry
                            break
                        end
                    end
                end
                if type(mart)~="table"
                    or (mart.martType and mart.martType~="NORMAL")
                    or (mart.ptr==nil and mart.key==nil) then
                    return previous(opts)
                end
                local map=areaNow() or (session() and session().map)
                if map==nil or tostring(map)=="" then
                    return previous(opts)
                end
                local okI,ItemsData=pcall(require,
                    "src.core.game3.items_data")
                if not okI then return previous(opts) end
                local saved=loadState()
                local locked=Randomizer.locked(saved)
                local identity="MAP:"..tostring(map)..":MART:"
                    ..tostring(mart.ptr or mart.key)
                local stock=Randomizer.shop(saved,ItemsData,identity,
                    opts.items,function()
                        return math.random(1,99999999)
                    end)
                if not stock then return previous(opts) end
                local newOpts,newMart={},{}
                for k,v in pairs(opts) do newOpts[k]=v end
                for k,v in pairs(mart) do newMart[k]=v end
                newMart.items=stock
                newOpts.items=stock
                newOpts.mart=newMart
                if not locked then
                    Notices.add(saved,"RANDOMIZER_LOCK",
                        "Shop stock fixed for this run; randomiser locked.")
                end
                writeState(saved)
                return previous(newOpts)
            end
            Shop.show=randomShopShow
            Shop.__nuzRandomShopWrap=randomShopShow
            Shop.__nuzRandomShopOwner=mod
        end
        if okS and type(Shop)=="table"
            and type(Shop.handleInput)=="function"
            and Shop.__nuzServiceInput~=Shop.handleInput then
            local original=Shop.handleInput
            local function guarded(input)
                if Shop.open and not Shop._fading and input
                    and type(input.wasPressed)=="function"
                    and input:wasPressed("a") then
                    local action
                    if Shop._rse then
                        if Shop.state=="root" then
                            if Shop.cursor==1 then action="buy"
                            elseif Shop.cursor==2 and
                                (Shop._martType==nil
                                    or Shop._martType=="NORMAL") then
                                action="sell"
                            end
                        elseif Shop.state=="confirm"
                            and Shop.yesCursor==1 then action="buy" end
                    elseif Shop.mode=="root" then
                        local choice=Shop.ROOT and Shop.ROOT[Shop.cursor]
                        action=choice and choice.id or nil
                    elseif Shop.mode=="buy_confirm"
                        and Shop.yesNoCursor==1 then action="buy" end
                    local why=Services.shopDenial(loadState(),Core,action)
                    if why then
                        notify("SERVICE_SHOP_DENIED",why,false)
                        return
                    end
                end
                return original(input)
            end
            Shop.handleInput=guarded
            Shop.__nuzServiceInput=guarded
        end
        local okP,Prize=pcall(require,"src.core.game3.battle.prize")
        if okP and type(Prize)=="table" then
            for _,name in ipairs({"calc","rewardRse"}) do
                local marker="__nuzServicePrize_"..name
                if type(Prize[name])=="function"
                    and Prize[marker]~=Prize[name] then
                    local original=Prize[name]
                    local function guarded(...)
                        return Services.trainerPrize(loadState(),Core,
                            original(...))
                    end
                    Prize[name]=guarded
                    Prize[marker]=guarded
                end
            end
        end
        return true
    end

    -- Pokemon Stats: install only at native creation/award boundaries.
    -- Never mutate ROM templates or existing party members on rule toggles.
    local function installStatGuards()
        local okP,Pokemon=pcall(require,"src.core.game3.pokemon")
        if not okP or type(Pokemon)~="table" then return false end
        local function playerOwned(mon)
            return Stats.playerMon(loadState(),Core,session(),mon)
        end
        local function guardGrowth(name)
            local marker="__nuzStats_"..name
            if type(Pokemon[name])~="function"
                or Pokemon[marker]==Pokemon[name] then return end
            local previous=Pokemon[name]
            local function wrapped(mon,...)
                if playerOwned(mon) then return nil end
                return previous(mon,...)
            end
            Pokemon[name]=wrapped
            Pokemon[marker]=wrapped
        end
        guardGrowth("gainEVs")
        guardGrowth("raiseEvFromItem")

        local okI,ItemUse=pcall(require,"src.core.game3.item_use")
        if okI and type(ItemUse)=="table"
            and type(ItemUse.useVitamin)=="function"
            and ItemUse.__nuzStatsVitamin~=ItemUse.useVitamin then
            local previous=ItemUse.useVitamin
            local function guardedVitamin(native,mon,item,...)
                if playerOwned(mon) then
                    local okItems,Items=pcall(require,
                        "src.core.game3.items_data")
                    local id=okItems and type(Items)=="table"
                        and type(Items.toNumericId)=="function"
                        and Items.toNumericId(item) or tonumber(item)
                    -- Ordinary EV vitamins only. EV-reduction berries
                    -- remain legal and retain friendship side effects.
                    if id==63 or id==64 or id==65 or id==66
                        or id==67 or id==70 then
                        notify("STAT_EV_DENIED",
                            "No EV Gain: vitamins cannot raise EVs.",false)
                        return false,"no_effect","No EV Gain: vitamin refused."
                    end
                end
                return previous(native,mon,item,...)
            end
            ItemUse.useVitamin=guardedVitamin
            ItemUse.__nuzStatsVitamin=guardedVitamin
        end
        if okI and type(ItemUse)=="table"
            and type(ItemUse.applyEnigmaItem)=="function"
            and ItemUse.__nuzStatsEnigma~=ItemUse.applyEnigmaItem then
            local previous=ItemUse.applyEnigmaItem
            local function guardedEnigma(native,mon,move,...)
                if playerOwned(mon) then
                    local okE,Enigma=pcall(require,
                        "src.core.game3.rs.enigma")
                    if okE and type(Enigma)=="table"
                        and Enigma.matches and Enigma.matches(native)
                        and Enigma.effectType and Enigma.itemEffect then
                        local typ=Enigma.effectType(
                            Enigma.itemEffect(native))
                        if type(typ)=="number"
                            and typ>=12 and typ<=17 then
                            return false,{mon=mon,restored=0}
                        end
                    end
                end
                return previous(native,mon,move,...)
            end
            ItemUse.applyEnigmaItem=guardedEnigma
            ItemUse.__nuzStatsEnigma=guardedEnigma
        end

        local okParty,Party=pcall(require,"src.core.game3.party")
        if okParty and type(Party)=="table"
            and type(Party.giveMon)=="function"
            and Party.__nuzStatsGive~=Party.giveMon then
            local previous=Party.giveMon
            local function guardedGive(native,...)
                -- Compose Player Stats and Run/Party at the *same* seam.
                -- Separate wrappers would repeatedly wrap each other on
                -- every map/save lifecycle reinstallation.
                local reason=RunParty.addDenied(loadState(),Core,native)
                if reason then
                    notify("PARTY_LIMIT_GIFT",reason,false)
                    return false,Party.MON_CANT_GIVE,nil
                end
                local ok,code,mon,box,slot=previous(native,...)
                if ok and type(mon)=="table" then
                    Stats.player(loadState(),Core,mon,Pokemon)
                end
                return ok,code,mon,box,slot
            end
            Party.giveMon=guardedGive
            Party.__nuzStatsGive=guardedGive
        end
        local okTrade,Trade=pcall(require,
            "src.core.game3.scripting.natives_trade")
        if okTrade and type(Trade)=="table"
            and type(Trade.tradeMons)=="function"
            and Trade.__nuzStatsTrade~=Trade.tradeMons then
            local previous=Trade.tradeMons
            local function guardedTrade(native,slot,offered,...)
                local result=previous(native,slot,offered,...)
                if result and native and native.party then
                    local received=native.party[(tonumber(slot) or 0)+1]
                    if received==offered then
                        Stats.player(loadState(),Core,received,Pokemon)
                    end
                end
                return result
            end
            Trade.tradeMons=guardedTrade
            Trade.__nuzStatsTrade=guardedTrade
        end
        -- Game3 creates fresh enemy Mons inside Battle.start. Prepare
        -- cloned encounter descriptors BEFORE engine stat calculation,
        -- keeping the original trainer/encounter source tables unchanged.
        local okB,Battle=pcall(require,"src.core.game3.battle.init")
        if okB and type(Battle)=="table"
            and type(Battle.start)=="function"
            and Battle.__nuzStatsStart~=Battle.start then
            local previous=Battle.start
            local function guardedStart(opts,...)
                if type(opts)~="table"
                    or opts.link or opts.recordedLink or opts.oldManTutorial
                    or opts.pokedude or (opts.foe and opts.foe.link) then
                    return previous(opts,...)
                end
                local saved=loadState()
                -- Game Difficulty is independent of NUZ ON/OFF. All
                -- profiles operate on final composed trainer opponents
                -- at battle start; providers' original tables are intact.
                local okTr,Trainers=pcall(require,
                    "src.core.game3.scripting.trainers")
                local effective=Difficulty.prepare(saved,opts,session(),
                    okTr and Trainers or nil)
                if not Core.active(saved) then
                    return previous(effective,...)
                end
                local source=opts.wild and "wild" or "trainer"
                local gymReason=RunParty.gymDenial(saved,Core,
                    session(),effective.foe,effective,okTr and Trainers or nil)
                if gymReason then
                    notify("GYM_TEAM_LIMIT",gymReason,false)
                    return nil,"gym_team_size"
                end
                -- Explicit Pokemon Stats rules take precedence over
                -- difficulty IV/EV floors on the same cloned descriptors.
                local function transform(v)
                    if type(v)~="table" then return v end
                    return Stats.foe(saved,Core,source,v,Pokemon)
                end
                local result={}
                for k,v in pairs(effective) do result[k]=v end
                if type(effective.foe)=="table" then
                    local foe=transform(effective.foe)
                    if type(effective.foe.party)=="table" then
                        if foe==effective.foe then
                            foe={}
                            for k,v in pairs(effective.foe) do foe[k]=v end
                        end
                        local party={}
                        for i,v in ipairs(effective.foe.party) do
                            party[i]=transform(v)
                        end
                        foe.party=party
                    end
                    result.foe=foe
                end
                if type(effective.foeParty)=="table" then
                    local party={}
                    for i,v in ipairs(effective.foeParty) do
                        party[i]=transform(v)
                    end
                    result.foeParty=party
                end
                return previous(result,...)
            end
            Battle.start=guardedStart
            Battle.__nuzStatsStart=guardedStart
        end
        return true
    end

    -- Run/Party guards cover native transaction boundaries. Catches
    -- are refused at catch.rate BEFORE dex/party writes; this second
    -- catching guard covers direct callers and other catch providers.
    -- In particular, never trim a live party or delete excess Mons.
    local function installRunPartyGuards()
        local okCatch,Catching=pcall(require,
            "src.core.game3.battle.catching")
        if okCatch and type(Catching)=="table"
            and type(Catching.storeCaught)=="function"
            and Catching.__nuzRunStore~=Catching.storeCaught then
            local previous=Catching.storeCaught
            local function guardedStore(native,...)
                local reason=RunParty.addDenied(loadState(),Core,native)
                if reason then
                    notify("PARTY_LIMIT_CATCH",reason,false)
                    return {success=false,reason="party_size_limit",
                        location=nil,firstTimeCaught=false,mon=nil}
                end
                return previous(native,...)
            end
            Catching.storeCaught=guardedStore
            Catching.__nuzRunStore=guardedStore
        end

        local okStorage,Storage=pcall(require,"src.core.game3.storage")
        if okStorage and type(Storage)=="table" then
            local function wrap(method,deny)
                local tag="__nuzRun_"..method
                if type(Storage[method])~="function"
                    or Storage[tag]==Storage[method] then return end
                local previous=Storage[method]
                local function guarded(native,...)
                    local reason=RunParty.addDenied(loadState(),Core,native)
                    if reason and deny(native,...) then
                        notify("PARTY_LIMIT_PC",reason,false)
                        return false,"party_size_limit"
                    end
                    return previous(native,...)
                end
                Storage[method]=guarded
                Storage[tag]=guarded
            end
            wrap("withdraw",function() return true end)
            wrap("moveMon",function(native,srcLoc,srcIdx,dstLoc,dstIdx)
                if srcLoc~="box" or dstLoc~="party" then return false end
                return not (native.party and native.party[dstIdx])
            end)
            wrap("placeHeldMon",function(native,mon,loc,slot)
                return loc=="party" and not
                    (native.party and native.party[slot])
            end)
        end

        -- Gym Team Size is composed in the existing Stats Battle.start
        -- wrapper, avoiding repeated wrapping across map transitions.

        -- All native evolution checks (level, stone, trade) converge on
        -- targetSpecies. Deny BEFORE scenes or evolution item consumption.
        local okE,Evolution=pcall(require,"src.core.game3.evolution")
        if okE and type(Evolution)=="table" then
            local okP,Pokemon=pcall(require,"src.core.game3.pokemon")
            if type(Evolution.targetSpecies)=="function"
                and Evolution.__nuzRunTarget~=Evolution.targetSpecies then
                local previous=Evolution.targetSpecies
                local function guardedTarget(mon,mode,...)
                    local target,param=previous(mon,mode,...)
                    local okI,ItemsData=pcall(require,
                        "src.core.game3.items_data")
                    if okP then
                        target,param=Qol.tradeLevelTarget(loadState(),
                            mon,target,param,mode,session(),Evolution,
                            Pokemon,okI and ItemsData or nil)
                    end
                    if okP and RunParty.evoDenied(loadState(),Core,
                        mon,target,Pokemon) then return 0,0 end
                    return target,param
                end
                Evolution.targetSpecies=guardedTarget
                Evolution.__nuzRunTarget=guardedTarget
            end
            if type(Evolution.apply)=="function"
                and Evolution.__nuzRunApply~=Evolution.apply then
                local previous=Evolution.apply
                local function guardedApply(mon,target,native,bag,via,...)
                    -- Scripted progression transformations stay native.
                    if (via==nil or via=="level" or via=="item"
                        or via=="trade")
                        and okP and RunParty.evoDenied(loadState(),Core,
                            mon,target,Pokemon) then
                        notify("EVOLUTION_DENIED",
                            "Evolution Limits: this evolution is restricted.",
                            false)
                        return false
                    end
                    -- Nincada -> Ninjask can create a separate Shedinja
                    -- when a native party slot exists. Redirect ONLY that
                    -- newly-created mon to PC if the configured cap is met.
                    -- No space in PC = refuse before mutating either species.
                    local moveExtra=false
                    local cap=RunParty.partyCap(loadState(),Core)
                    local count=RunParty.partyCount(native)
                    local oldSpecies=type(mon)=="table" and
                        tonumber(mon.species or mon.speciesId)
                    if cap<6 and count and count>=cap
                        and count<6 and oldSpecies and okP
                        and type(Pokemon.evolutions)=="function" then
                        local rows=Pokemon.evolutions(oldSpecies)
                        local first=type(rows)=="table" and rows[1]
                        local second=type(rows)=="table" and rows[2]
                        if first and second
                            and tonumber(first.method or first[1])
                                ==Evolution.EVO_LEVEL_NINJASK
                            and tonumber(first.target or first[3])
                                ==tonumber(target)
                            and tonumber(second.method or second[1])
                                ==Evolution.EVO_LEVEL_SHEDINJA then
                            local okS,Storage=pcall(require,
                                "src.core.game3.storage")
                            if not okS or not Storage
                                or not Storage.findOpenSlot
                                or not Storage.sendMonToPC
                                or not Storage.findOpenSlot(
                                    Storage.ensure(native)) then
                                notify("PARTY_LIMIT_SHEDINJA",
                                    "Party Size Limit: PC is full; "
                                    .."cannot safely create Shedinja.",false)
                                return false
                            end
                            moveExtra=Storage
                        end
                    end
                    local changed=previous(mon,target,native,bag,via,...)
                    if changed and okP then
                        local okI,ItemsData=pcall(require,
                            "src.core.game3.items_data")
                        Qol.consumeTradeItem(loadState(),mon,oldSpecies,
                            target,via,Pokemon,Evolution,
                            okI and ItemsData or nil)
                    end
                    if changed and moveExtra and native
                        and native.party and #native.party>count then
                        local extra=native.party[#native.party]
                        local ok=moveExtra.sendMonToPC(native,extra)
                        if ok then
                            table.remove(native.party)
                            notify("PARTY_LIMIT_SHEDINJA",
                                "Party Size Limit: Shedinja sent to PC.",false)
                        end
                    end
                    return changed
                end
                Evolution.apply=guardedApply
                Evolution.__nuzRunApply=guardedApply
            end
        end
    end

    -- Unlike a capture-only ban, No Fishing must refuse a rod BEFORE the
    -- field starts its fishing minigame. The engine's Field.startFishing
    -- is the native rod-use boundary. Keep an additional guard on direct
    -- tryFishingEncounter calls so other paths cannot bypass this rule.
    local function installFishingGuard()
        local ok, Field = pcall(require, "src.core.game3.field")
        if not ok or type(Field) ~= "table" then return false end
        local function protected(method)
            local marker = "__nuzGen3FishingWrap_" .. method
            if type(Field[method]) ~= "function" then return end
            if Field[marker] == Field[method]
                and Field.__nuzGen3FishingOwner == mod then return end
            local original = Field[method]
            local function guarded(...)
                if CatchRules.fishingBlocked(loadState(), Core) then
                    notify("NO_FISHING",
                        "No Fishing: fishing rods cannot be used.", false)
                    return false
                end
                return original(...)
            end
            Field[method] = guarded
            Field[marker] = guarded
        end
        protected("startFishing")
        protected("tryFishingEncounter")
        Field.__nuzGen3FishingOwner = mod
        return true
    end

    -- Nuzlocke-only effect-level guards. These functions are shared by
    -- primary moves, secondary effects and King's Rock. We never rewrite
    -- native move definitions or damage, and only restrict sources proven
    -- to be battle moves (not natural abilities/item stat changes).
    local battleClauseSource
    local reportedBattleClauses = {}
    local function battleClauseNotice(key, message)
        if reportedBattleClauses[key] then return end
        reportedBattleClauses[key] = true
        notify("BATTLE_CLAUSE", message, false)
    end
    local function installBattleClauseGuards()
        -- OHKO has its own resolver in engine.lua, outside Secondary.set
        -- and the regular damage calculator. Intercept the native context's
        -- first ("lockon") accuracy check, which happens AFTER the engine
        -- prints the move and spends PP, but BEFORE any OHKO hit/damage
        -- or focus-band roll. Fail through the normal native path.
        -- Engine.newContext exposes the same metatable used by real moves;
        -- obtain it with a synthetic, never-dispatched context instead of
        -- changing ROM moves or requiring a base-engine patch.
        local okE, Engine = pcall(require,
            "src.core.game3.battle.engine")
        if okE and type(Engine)=="table"
            and type(Engine.newContext)=="function" then
            local dummy={displayName=function() return "" end}
            local okCtx, context=pcall(Engine.newContext,
                {side="player"},{side="enemy"},12,nil,
                dummy,nil,{}, {},{})
            local mt=okCtx and type(context)=="table"
                and getmetatable(context) or nil
            if type(mt)=="table"
                and type(mt.accuracyCheck)=="function"
                and (mt.__nuzOHKOOwner~=mod
                    or mt.__nuzOHKOWrap~=mt.accuracyCheck) then
                local native=mt.accuracyCheck
                local function guarded(self,mode,...)
                    if mode=="lockon" and type(self)=="table"
                        and tonumber(self.effect)==38
                        and BattleClauses.denyOHKO(loadState(),
                            self.user,Core) then
                        self.failed=true
                        self.missReason="fail"
                        if self.adapter and
                            type(self.adapter.sayFail)=="function" then
                            self.adapter:sayFail()
                        end
                        battleClauseNotice("ohko",
                            "OHKO Clause: one-hit KO move prevented.")
                        return false
                    end
                    return native(self,mode,...)
                end
                mt.accuracyCheck=guarded
                mt.__nuzOHKOWrap=guarded
                mt.__nuzOHKOOwner=mod
            end
        end
        local okS, Secondary = pcall(require,
            "src.core.game3.battle.effects.secondary")
        local okC, EffectCtx = pcall(require,
            "src.core.game3.battle.effect_ctx")
        if not okS or type(Secondary)~="table"
            or not okC or type(EffectCtx)~="table" then return false end

        if type(Secondary.set)=="function"
            and (Secondary.__nuzGen3SetOwner~=mod
                or (Secondary.__nuzGen3SetWrap~=Secondary.set
                    and not (Secondary.__nuzStatusOwner==mod
                        and Secondary.__nuzStatusWrap==Secondary.set))) then
            local original = Secondary.set
            local function guarded(M, effect, ...)
                local source = type(M)=="table" and M.user or nil
                local saved = loadState()
                if source and BattleClauses.denyEffect(saved,
                    effect, source, Core) then
                    battleClauseNotice(effect, effect=="FLINCH"
                        and "Flinch Clause: move flinch prevented."
                        or "Trap Clause: partial trapping prevented.")
                    return false
                end
                local previous = battleClauseSource
                if source then battleClauseSource=source end
                local ok, result, extra, more = pcall(original,
                    M, effect, ...)
                battleClauseSource=previous
                if not ok then error(result,0) end
                return result, extra, more
            end
            Secondary.set=guarded
            Secondary.__nuzGen3SetWrap=guarded
            Secondary.__nuzGen3SetOwner=mod
        end

        if type(Secondary.changeStat)=="function"
            and (Secondary.__nuzGen3StatOwner~=mod
                or Secondary.__nuzGen3StatWrap~=Secondary.changeStat) then
            local original=Secondary.changeStat
            local function guarded(adapter,target,stat,delta,flags)
                local ctx=EffectCtx.current and EffectCtx.current()
                local source=(ctx and ctx.user) or battleClauseSource
                if source and BattleClauses.denyStat(loadState(),
                    stat, delta, source, Core) then
                    battleClauseNotice("stat:"..tostring(stat)..":"
                        ..(delta>0 and "+" or "-"),
                        "Battle Clause: move-caused "..tostring(stat)
                        .." change prevented.")
                    return "blocked"
                end
                return original(adapter,target,stat,delta,flags)
            end
            Secondary.changeStat=guarded
            Secondary.__nuzGen3StatWrap=guarded
            Secondary.__nuzGen3StatOwner=mod
        end

        -- Minimize has a second volatile flag besides its evasion stage.
        -- Suppress that special state entirely when the Evasion Clause
        -- prevents the move's stage boost.
        local okE, Effects=pcall(require,
            "src.core.game3.battle.effects.init")
        if okE and type(Effects)=="table"
            and type(Effects.run)=="function"
            and (Effects.__nuzGen3RunOwner~=mod
                or (Effects.__nuzGen3RunWrap~=Effects.run
                    and not (Effects.__nuzStatusRunOwner==mod
                        and Effects.__nuzStatusRunWrap==Effects.run))) then
            local original=Effects.run
            Effects.run=function(id,adapter,user,target,...)
                if id=="EXP_MINIMIZE_EFFECT" and user
                    and BattleClauses.denyStat(loadState(),
                        "evasion",1,user,Core) then
                    battleClauseNotice("minimize",
                        "Evasion Clause: Minimize was prevented.")
                    if adapter and type(adapter.sayFail)=="function" then
                        adapter:sayFail()
                    end
                    return true
                end
                return original(id,adapter,user,target,...)
            end
            Effects.__nuzGen3RunWrap=Effects.run
            Effects.__nuzGen3RunOwner=mod
        end
        return true
    end

    -- STATUS BANS: prevent the native status mutation, not the damaging
    -- move. Shared Secondary.set handles primary and secondary move effects;
    -- Adapter.new covers direct status transactions (abilities and Yawn).
    local function installStatusBanGuards()
        local okS, Secondary=pcall(require,
            "src.core.game3.battle.effects.secondary")
        if okS and type(Secondary)=="table"
            and type(Secondary.set)=="function"
            and (Secondary.__nuzStatusOwner~=mod
                or Secondary.__nuzStatusWrap~=Secondary.set) then
            local original=Secondary.set
            local function guarded(M,effect,...)
                local user=type(M)=="table" and M.user
                local target=type(M)=="table" and M.target
                local affectsUser=select(3,...)
                if affectsUser==true then target=user end
                local saved=loadState()
                if user and StatusBans.deny(saved,effect,
                    user,target,Core) then
                    battleClauseNotice("status:"..tostring(effect),
                        "Status Ban: "..tostring(effect)..
                        " from this side was prevented.")
                    return false
                end
                if user and (effect=="SLEEP" or effect=="SLP")
                    and StatusBans.denySleepClause(saved,user,target,
                        type(M)=="table" and M.adapter and M.adapter._st,
                        Core) then
                    battleClauseNotice("sleep:clause",
                        "Sleep Clause: another opposing Pokemon is asleep.")
                    return false
                end
                return original(M,effect,...)
            end
            Secondary.set=guarded
            Secondary.__nuzStatusWrap=guarded
            Secondary.__nuzStatusOwner=mod
        end

        -- Yawn only applies sleep after an end-of-turn delay and uses the
        -- victim as its direct native status source. Reject Yawn before
        -- drowsiness is scheduled, rather than undoing a later sleep.
        local okT, Status=pcall(require,
            "src.core.game3.battle.effects.status")
        if okT and type(Status)=="table"
            and type(Status.yawn)=="function"
            and (Status.__nuzYawnOwner~=mod
                or Status.__nuzYawnWrap~=Status.yawn) then
            local original=Status.yawn
            local function guarded(ctx,...)
                if type(ctx)=="table" and ctx.user
                    and (StatusBans.deny(loadState(),"SLEEP",
                        ctx.user,ctx.target,Core)
                        or StatusBans.denySleepClause(loadState(),
                            ctx.user,ctx.target,
                            ctx.adapter and ctx.adapter._st,Core)) then
                    battleClauseNotice("status:yawn",
                        "Sleep rule: Yawn was prevented.")
                    if ctx.adapter and type(ctx.adapter.sayFail)=="function"
                        then ctx.adapter:sayFail() end
                    return nil
                end
                local result=original(ctx,...)
                if type(ctx)=="table" and type(ctx.target)=="table"
                    and ctx.target.expYawnTurns
                    and ctx.user and ctx.user.side then
                    ctx.target._nuzYawnSource=ctx.user.side
                end
                return result
            end
            Status.yawn=guarded
            Status.__nuzYawnWrap=guarded
            Status.__nuzYawnOwner=mod
        end

        -- Effects.init captures Status.yawn when registering its handler,
        -- so wrapping the Status module alone is insufficient. Guard the
        -- live effect dispatcher as well (including ROM move aliases).
        local okE, Effects=pcall(require,
            "src.core.game3.battle.effects.init")
        if okE and type(Effects)=="table"
            and type(Effects.run)=="function"
            and (Effects.__nuzStatusRunOwner~=mod
                or Effects.__nuzStatusRunWrap~=Effects.run) then
            local original=Effects.run
            local function guarded(id,adapter,user,target,...)
                if id=="EXP_YAWN_EFFECT" and user
                    and (StatusBans.deny(loadState(),"SLEEP",
                        user,target,Core)
                        or StatusBans.denySleepClause(loadState(),
                            user,target,adapter and adapter._st,Core)) then
                    battleClauseNotice("status:yawn",
                        "Sleep rule: Yawn was prevented.")
                    if adapter and type(adapter.sayFail)=="function" then
                        adapter:sayFail()
                    end
                    return true
                end
                local result=original(id,adapter,user,target,...)
                if id=="EXP_YAWN_EFFECT" and type(target)=="table"
                    and target.expYawnTurns and user then
                    target._nuzYawnSource=user.side
                end
                return result
            end
            Effects.run=guarded
            Effects.__nuzStatusRunWrap=guarded
            Effects.__nuzStatusRunOwner=mod
        end

        local okA, Adapter=pcall(require,
            "src.core.game3.battle.adapter")
        if okA and type(Adapter)=="table"
            and type(Adapter.new)=="function"
            and (Adapter.__nuzStatusOwner~=mod
                or Adapter.__nuzStatusWrap~=Adapter.new) then
            local original=Adapter.new
            local function guarded(...)
                local ad=original(...)
                if type(ad)~="table" then return ad end
                if type(ad.applyStatus)=="function" then
                    local native=ad.applyStatus
                    ad.applyStatus=function(self,target,status,source,opts)
                        local sleep=status=="SLP" or status=="SLEEP"
                        -- Rest can happen while Yawn is pending; its
                        -- explicit three-turn sleep must stay self-induced.
                        local delayedYawn=sleep and source==target
                            and type(target)=="table"
                            and target._nuzYawnSource~=nil
                            and (type(opts)~="table" or opts.turns==nil)
                            -- Rest specifies a turn count. The deferred
                            -- Yawn path may omit its optional opts table in
                            -- compatible adapters, so don't require one.
                        local actualSource=delayedYawn
                            and target._nuzYawnSource or source
                        local saved=loadState()
                        if StatusBans.deny(saved,status,
                            actualSource,target,Core) then
                            battleClauseNotice("direct:"..tostring(status),
                                "Status Ban: "..tostring(status)..
                                " was prevented.")
                            if delayedYawn then
                                target._nuzYawnSleepBlocked=true
                                target._nuzYawnSource=nil
                            end
                            return false
                        end
                        if sleep and StatusBans.denySleepClause(saved,
                            actualSource,target,self._st,Core) then
                            battleClauseNotice("sleep:clause",
                                "Sleep Clause: another opposing Pokemon is asleep.")
                            if delayedYawn then
                                target._nuzYawnSleepBlocked=true
                                target._nuzYawnSource=nil
                            end
                            return false
                        end
                        local result=native(self,target,status,source,opts)
                        if sleep then
                            if result then
                                StatusBans.recordSleep(self._st,target,
                                    actualSource)
                            end
                            if type(target)=="table" then
                                target._nuzYawnSource=nil
                            end
                        end
                        return result
                    end
                    -- The native delayed-Yawn handler announces sleep even
                    -- when applyStatus returned false. Suppress ONLY that
                    -- misleading animation and message.
                    if type(ad.statusAnim)=="function" then
                        local statusAnim=ad.statusAnim
                        ad.statusAnim=function(self,target,status,...)
                            if type(target)=="table"
                                and target._nuzYawnSleepBlocked
                                and (status=="SLP" or status=="SLEEP") then
                                return
                            end
                            return statusAnim(self,target,status,...)
                        end
                    end
                    if type(ad.sayText)=="function" then
                        local sayText=ad.sayText
                        ad.sayText=function(self,id,fill,...)
                            local target=type(fill)=="table" and fill.eff
                            if id=="STRINGID_PKMNFELLASLEEP"
                                and type(target)=="table"
                                and target._nuzYawnSleepBlocked then
                                target._nuzYawnSleepBlocked=nil
                                return
                            end
                            return sayText(self,id,fill,...)
                        end
                    end
                end
                if type(ad.applyConfusion)=="function" then
                    local native=ad.applyConfusion
                    ad.applyConfusion=function(self,target,turns,source)
                        if StatusBans.deny(loadState(),"CONFUSION",
                            source,target,Core) then
                            battleClauseNotice("direct:CONFUSION",
                                "Status Ban: confusion was prevented.")
                            return false
                        end
                        return native(self,target,turns,source)
                    end
                end
                return ad
            end
            Adapter.new=guarded
            Adapter.__nuzStatusWrap=guarded
            Adapter.__nuzStatusOwner=mod
        end
        return true
    end

    -- Shared after-change hook for the menu and versioned public API.
    local function onClauseChanged(saved, key)
        if key == "route_forgiveness" then
            Forgiveness.initialise(saved,
                Clauses.get(saved, key), Forgiveness.badges(session()))
        end
    end

    -- Game 3 battles operate on *copies* of session.party. Never table.remove
    -- from battle.playerParty while a fight is running: partyIndex values drive
    -- forced switches, two active battlers and end-of-battle writeback.
    local function samePokemon(a, b, indexMatches)
        if type(a) ~= "table" or type(b) ~= "table" then return false end
        local pa, pb = a.personality, b.personality
        local sa, sb = a.species or a.speciesId, b.species or b.speciesId
        if pa ~= nil and pb ~= nil then
            return pa == pb and tostring(sa) == tostring(sb)
        end
        return indexMatches and tostring(sa) == tostring(sb)
            and tostring(a.nickname or a.name or "") == tostring(b.nickname or b.name or "")
    end

    local function memorialShiny(mon,entry)
        local ok,Pokemon=pcall(require,"src.core.game3.pokemon")
        local flag=Results.shinyStatus(mon,ok and Pokemon or nil)
        if flag~=nil then entry.isShiny=flag end
    end

    local function retireFainted(outcome, endedBattle)
        local s = loadState()
        if not Core.active(s) then return end
        if mercyBattle ~= nil and endedBattle == mercyBattle then return end
        local native = session()
        local party = native and native.party
        if type(party) ~= "table" then return end
        local deathEnabled = Core.enforced(s, "permadeath")

        -- A faint event has already committed the death to mod.save. Match the
        -- event's battle-party copy back to its native session counterpart,
        -- including selected-party/subset battles where slot numbers differ.
        if battleDeaths and type(battleDeaths.pending) == "table" then
            local claimed = {}
            for _, death in ipairs(battleDeaths.pending) do
                for index, mon in ipairs(party) do
                    if not claimed[index] and samePokemon(death.mon, mon,
                        index == death.slot and not battleDeaths.partySubset) then
                        mon.nuzlockeDead = true
                        mon.nuzlockeDeathRecorded = true
                        mon.hp = 0
                        claimed[index] = true
                        break
                    end
                end
            end
        end

        local modified, rescued = false, false
        for i = #party, 1, -1 do
            local mon = party[i]
            if type(mon) == "table" and mon.isEgg ~= true
                and (mon.nuzlockeDead == true
                    or (deathEnabled and (tonumber(mon.hp) or 0) <= 0)) then
                if not mon.nuzlockeDeathRecorded then
                    local entry = Display.memorial(mon, areaNow(),
                        "Fainted in battle")
                    memorialShiny(mon,entry)
                    entry.archive, entry.archiveComplete = Archive.snapshot(mon)
                    s.graveyard[#s.graveyard + 1] = entry
                end
                table.remove(party, i)
                modified = true
            end
        end
        -- A whiteout failure outranks PC rescue. Never revive the dead:
        -- move one existing living resident into an empty native party only
        -- after battle writeback and faint retirement are finished.
        if Hardcore.whiteout(s,Core,outcome) then
            local before=#party
            local viable=Hardcore.allowSurvivors(s,Core,native,Extra)
            rescued=viable and #party>before
            if rescued then modified=true end
            if not viable then s.failed=true end
        elseif Core.failedWhiteout(s, outcome) then
            s.failed = true
        elseif #party == 0 then
            if Core.enforced(s, "pc_survivors_allowed")
                and Extra.rescueFromPc(s, native) then
                modified = true
                rescued = true
            else
                s.failed = true
            end
        end
        if modified or s.failed then writeState(s) end
        if s.failed then
            notify("RUN_FAILED", "Run ended. Opening final results.", false)
        elseif rescued then
            notify("PC_SURVIVOR",
                "Party empty: a living PC survivor joined your team.", false)
        end
    end

    local function recordBattleFaint(ev)
        if not Core.enforced(loadState(), "permadeath")
            or type(ev) ~= "table" then return end
        if mercyBattle ~= nil and ev.battle == mercyBattle then return end
        local battler = ev.battler
        if type(battler) ~= "table" or
            (ev.sideName ~= "player" and battler.side ~= "player") then return end
        local battle = ev.battle
        local party = battle and battle.playerParty
        local slot = tonumber(battler.partyIndex)
        if type(party) ~= "table" or not slot or not party[slot] then return end
        if not battleDeaths or battleDeaths.battle ~= battle then
            battleDeaths = { battle = battle, pending = {}, seen = {} }
        end
        if battleDeaths.seen[slot] then return end
        local mon = party[slot]
        if mon.isEgg then return end
        local archived, complete = Archive.snapshot(mon)
        battleDeaths.seen[slot] = true
        battleDeaths.pending[#battleDeaths.pending + 1] = { mon = mon, slot = slot }
        -- Capture before the next forced-switch/revive decision. Existing
        -- battle/UI references remain intact; the mon is now irrevocably dead.
        mon.nuzlockeDead = true
        battler.mon.nuzlockeDead = true
        local s = loadState()
        local entry = Display.memorial(mon, areaNow(), "Fainted in battle")
        memorialShiny(mon,entry)
        entry.archive = archived
        entry.archiveComplete = complete
        s.graveyard[#s.graveyard + 1] = entry
        writeState(s)
        notify("PERMADEATH", Notices.name(mon, Display)
            .. " fainted. Permadeath: added to the Graveyard.", true)
    end

    -- The battle engine asks Options.battleStyle() when an enemy trainer
    -- prepares a replacement after fainting. Override the *answer*, never
    -- the session's actual SHIFT/SET preference, so switching Hardcore OFF
    -- restores it immediately. Forced switches after fainting remain legal.
    local function installHardcoreSetGuard()
        local ok, Options = pcall(require, "src.core.game3.options")
        if not ok or type(Options) ~= "table"
            or type(Options.battleStyle) ~= "function" then return false end
        if Options.__nuzGen3HardcoreOwner == mod then return true end
        local original = Options.battleStyle
        Options.battleStyle = function(native, ...)
            if battleInProgress
                and Playstyles.hardcoreActive(loadState(), Core)
                and native == session() then return "set" end
            return original(native, ...)
        end
        Options.__nuzGen3HardcoreOwner = mod
        return true
    end

    -- The native battle-item UI and the actual item transaction are distinct.
    -- Block revival and Hardcore item usage at BOTH points. Balls remain
    -- legal; catch restrictions are handled by the existing catch.rate hook.
    local function installReviveGuard()
        local okB, BattleItems = pcall(require, "src.core.game3.battle.items")
        local okD, ItemsData = pcall(require, "src.core.game3.items_data")
        local okU, ItemUse = pcall(require, "src.core.game3.item_use")
        if not (okB and okD and okU and type(BattleItems) == "table"
            and type(ItemsData) == "table" and type(ItemUse) == "table") then
            return false
        end
        if BattleItems.__nuzlockeGen3GuardOwner == mod then return true end
        if type(BattleItems.canUseOn) ~= "function"
            or type(BattleItems.use) ~= "function" then return false end
        local originalCanUse, originalUse = BattleItems.canUseOn, BattleItems.use
        local originalIsBattleUsable = BattleItems.isBattleUsable

        local function itemDenial(st,itemId)
            st=st or currentBattleState
            local current=activeBattle
            return BattleItemRules.itemDenial(loadState(),Core,Playstyles,
                itemId,BattleItems,ItemsData,ItemUse,{
                    battle=st,
                    wild=current~=nil and current.battle==st,
                    throws=current and current.ballThrows or 0,
                })
        end
        -- Suppress non-Ball choices in the battle bag where supported.
        if type(originalIsBattleUsable) == "function" then
            BattleItems.isBattleUsable = function(itemId, ...)
                if battleInProgress and
                    (itemDenial(nil,itemId) or
                    FieldRules.battleDenial(loadState(),Core,itemId,
                        session(),ItemUse,ItemsData)) then return false end
                return originalIsBattleUsable(itemId, ...)
            end
        end

        local function isRevive(itemId, nativeSession)
            local okKind, kind = pcall(ItemsData.medicineKind, itemId)
            if okKind and kind == "revive" then return true end
            local okField, field = pcall(ItemUse.fieldUseKind,
                itemId, nativeSession, true)
            return okField and field == "revive"
        end

        BattleItems.canUseOn = function(st, itemId, partySlot, mon, moveSlot)
            local denial=itemDenial(st,itemId)
            if not denial then
                denial=FieldRules.battleDenial(loadState(),Core,
                    itemId,st and st.session,ItemUse,ItemsData)
            end
            if denial then return false,denial end
            if Core.enforced(loadState(), "permadeath")
                and isRevive(itemId, st and st.session) then
                return false, "Nuzlocke: No revives."
            end
            return originalCanUse(st, itemId, partySlot, mon, moveSlot)
        end

        BattleItems.use = function(st, adapter, bag, nativeSession, itemId, ...)
            local message=itemDenial(st,itemId)
            if not message then
                message=FieldRules.battleDenial(loadState(),Core,
                    itemId,nativeSession,ItemUse,ItemsData)
            end
            if message then
                if adapter and type(adapter.say)=="function" then
                    adapter:say(message)
                end
                return "error",{message},false,false
            end
            if Core.enforced(loadState(), "permadeath")
                and isRevive(itemId, nativeSession) then
                local message = "Nuzlocke: No revives."
                if adapter and type(adapter.say) == "function" then
                    adapter:say(message)
                end
                return "error", { message }, false, false
            end
            return originalUse(st, adapter, bag, nativeSession, itemId, ...)
        end
        BattleItems.__nuzlockeGen3GuardOwner = mod
        return true
    end

    -- Native Gen 3 builds with the post-catch hook consult Nuzlocke at
    -- the *actual* capture decision, before ever drawing the YES/NO prompt.
    -- Engine builds without the hook keep the guarded UI compatibility path.
    mod.hooks:wrap("battle.catch.nickname_required", function(next, ctx)
        if type(ctx) == "table" and ctx.source == "gen3"
            and Core.enforced(loadState(), "nickname_rule") then
            notify("NICKNAME_FORCED",
                "Nickname Rule: a custom nickname is required.", false)
            return true
        end
        return next(ctx)
    end)

    -- IMPORTANT: Gen1Recomp runs mod callbacks in a restricted sandbox:
    -- 'package' is deliberately absent. Direct package.loaded access here
    -- caused the old capture guard to fail in-game, despite unsandboxed
    -- mock tests passing. Use the permitted require facade instead.
    local function nativeCatchNicknamePrompt()
        local ok, battle = pcall(require, "src.core.game3.battle.init")
        if not ok or type(battle) ~= "table" then
            ok, battle = pcall(require, "src.core.game3.battle")
        end
        return ok and type(battle) == "table"
            and battle._phase == "catch_nickname_prompt"
    end

    -- Starter/gift naming goes through the field script's ordinary yesnobox
    -- (Choice.yesNo), not the battle.catch.nickname_required hook. The
    -- actual native text is authoritative; never hijack unrelated yes/no
    -- menus or a choice before a Pokemon exists.
    local function nativeFieldNicknamePrompt()
        local native=session()
        if not (native and type(native.party)=="table"
            and #native.party>0) then return false end
        local ok,Message=pcall(require,"src.ui.game3.message")
        if not ok or type(Message)~="table"
            or type(Message.currentPage)~="function" then return false end
        local answer=Message.currentPage()
        if type(answer)~="string" then return false end
        local normal=answer:lower():gsub("[%c]+"," ")
        return normal:find("nickname",1,true)~=nil
            or normal:find("nick name",1,true)~=nil
    end

    -- Native catch and field-script nickname prompts cannot be declined.
    -- The guarded naming screen repeats until a non-default name is given.
    -- The safe overworld task list handles gifts, trades and hatches.
    local function installNicknameGuard()
        local okU, Ui = pcall(require, "src.core.game3.battle.ui")
        local okN, Naming = pcall(require, "src.ui.game3.naming")
        if not okU or type(Ui) ~= "table"
            or type(Ui.askYesNo) ~= "function" then return false end
        -- Install the prompt hook even if the naming UI has not loaded yet.
        -- The old all-or-nothing pcall(require, Naming) silently skipped BOTH
        -- hooks when native naming assets were unavailable at battle start.
        -- The native captured-mon prompt is emitted in battle/init.lua,
        -- which may be loaded under its .init path instead of the .lua alias.
        -- Both aliases must be checked: otherwise the player's No choice
        -- is left available on some module-loading paths.
        --
        -- Reinstall if a later integration replaces askYesNo. The owner
        -- marker alone used to incorrectly claim our hook was still active.
        if Ui.__nuzGen3NicknameOwner ~= mod
            or Ui.__nuzGen3NicknameWrap ~= Ui.askYesNo then
            local ask = Ui.askYesNo
            local function guardedAsk(prompt, callback, ...)
                local namingPrompt = nativeCatchNicknamePrompt()
                    or nativeFieldNicknamePrompt()
                if Core.enforced(loadState(), "nickname_rule")
                    and namingPrompt and type(callback)=="function" then
                    -- Ensure the native naming screen has its validator
                    -- before following the YES path. Do not display a
                    -- YES/NO prompt when No would violate the rule.
                    installNicknameGuard()
                    notify("NICKNAME_FORCED",
                        "Nickname Rule: give your new Pokemon a nickname.", false)
                    return callback(true)
                end
                return ask(prompt, callback, ...)
            end
            Ui.askYesNo = guardedAsk
            Ui.__nuzGen3NicknameWrap = guardedAsk
            Ui.__nuzGen3NicknameOwner = mod
        end
        -- Compatibility fail-safe for existing Gen1Recomp builds: when
        -- another UI wrapper draws the old YES/NO prompt, intercept the
        -- confirmation callback at the lower native Choice layer too.
        -- This cannot be declined; no other Yes/No screens are affected.
        local okC, Choice = pcall(require, "src.ui.game3.choice")
        if okC and type(Choice) == "table"
            and type(Choice.yesNo) == "function"
            and (Choice.__nuzGen3NicknameOwner ~= mod
                or Choice.__nuzGen3NicknameWrap ~= Choice.yesNo) then
            local originalChoice = Choice.yesNo
            local function guardedChoice(callback, ...)
                if (nativeCatchNicknamePrompt()
                    or nativeFieldNicknamePrompt())
                    and Core.enforced(loadState(), "nickname_rule")
                    and type(callback) == "function" then
                    notify("NICKNAME_FORCED",
                        "Nickname Rule: choose a custom nickname.", false)
                    return callback(true)
                end
                return originalChoice(callback, ...)
            end
            Choice.yesNo = guardedChoice
            Choice.__nuzGen3NicknameOwner = mod
            Choice.__nuzGen3NicknameWrap = guardedChoice
        end
        if not okN or type(Naming) ~= "table"
            or type(Naming.open) ~= "function" then return true end
        if Naming.__nuzGen3NicknameOwner == mod
            and Naming.__nuzGen3NicknameWrap == Naming.open then
            return true
        end
        local open = Naming.open
        local function guardedOpen(opts)
            if type(opts) ~= "table"
                or (opts.template ~= "CAUGHT_MON"
                    and opts.template ~= "NICKNAME")
                or not Core.enforced(loadState(), "nickname_rule")
                or type(opts.onDone) ~= "function" then
                return open(opts)
            end
            local speciesName = Display.speciesName({ species = opts.species })
            local wrapped = {}
            for k, v in pairs(opts) do wrapped[k] = v end
            local function validated(nick)
                if not Extra.customName(nick, speciesName) then
                    notify("NICKNAME_REQUIRED",
                        "Nickname Rule: enter a name different from the species.", false)
                    return open(wrapped)
                end
                return opts.onDone(nick)
            end
            wrapped.onDone = validated
            return open(wrapped)
        end
        Naming.open = guardedOpen
        Naming.__nuzGen3NicknameWrap = guardedOpen
        Naming.__nuzGen3NicknameOwner = mod
        return true
    end

    mod.events:on("player.warped",function(ev)
        if type(ev)~="table" then return end
        local nextEntry=Hardcore.entry(loadState(),Core,
            ev.fromMap,ev.toMap,ev.x,ev.y,AreaSplits)
        if nextEntry then dungeonEntry=nextEntry
        elseif dungeonEntry
            and not Hardcore.dungeonOf(ev.toMap,AreaSplits) then
            dungeonEntry=nil
        end
    end)

    -- Gen 3's map.entered uses a native map ID, not a Gen 1 map name.
    mod.events:on("map.entered", function(ev)
        currentArea = type(ev) == "table" and areaKey(ev.mapId) or nil
        pendingRoamer = nil -- never match a roamer across unrelated maps
        refreshForgiveness()
        refreshCapNotice()
        nicknameTasks()
        installCandyGuard()
        installFieldItemGuards()
        installRandomHiddenItemGuards()
        installRandomTmResolvers()
        installRandomProgressionResolvers()
        installServiceGuards()
        installStatGuards()
        installRunPartyGuards()
        installHardcoreGuards()
        installQolGuards()
        installNicknameGuard()
        installFishingGuard()
        installBattleClauseGuards()
        installStatusBanGuards()
        installAcquisitionGuards()
        deliverPendingStartingBalls()
        installChampionResultHook()
        installShinyVisualGuards()
        local saved=loadState()
        if Results.isTerminal(saved) then
            if not ResultsScreen.isOpen() then
                openFinalScreen(saved.finalResult)
            else
                ResultsScreen.ensureTop()
            end
        end
    end)

    -- On a failed save the terminal screen is persistent: no game
    -- interactions, world steps, or stray native UI transitions may
    -- return the player to ordinary Nuzlocke gameplay.
    mod.events:on("world.stepped",function()
        local saved=loadState()
        if Results.isTerminal(saved) then
            if not ResultsScreen.isOpen() then
                openFinalScreen(saved.finalResult)
            else
                ResultsScreen.ensureTop()
            end
            return
        end
        deliverPendingStartingBalls()
    end)

    mod.events:on("breeding.egg_created", function(ev)
        local s = loadState()
        Eggs.created(s, ev, areaNow())
        -- Provenance attaches directly to the egg; save-local fields are not
        -- spent until the actual hatch event confirms an acquired Pokemon.
    end)
    mod.events:on("egg.hatched", function(ev)
        if not isActive() then return end
        local saved = loadState()
        local mode = Clauses.get(saved, "gen3_egg_encounter_mode")
        local valid, reason = Eggs.hatched(saved, ev, areaNow(), mode)
        if type(ev) == "table" and type(ev.mon) == "table" then
            saved.eggHistory = saved.eggHistory or {}
            saved.eggHistory[#saved.eggHistory + 1] = {
                species = ev.species, location = areaNow(),
                status = reason, origin = ev.egg and ev.egg.nuzEggOrigin,
            }
        end
        if Core.enforced(saved, "nickname_rule") then
            Extra.auditNicknames(saved, session(), Display)
        end
        writeState(saved)
        if mode ~= 0 then
            local name = type(ev) == "table"
                and type(ev.mon) == "table"
                and Notices.name(ev.mon, Display) or "The hatched Pokemon"
            notify("EGG_ENCOUNTER", name .. " hatched. Egg Encounter: "
                .. tostring(reason or (valid and "accepted" or "not eligible")) .. ".", false)
        end
    end)

    -- Fires before the native Gen 3 wild battle is started. Useful even if
    -- the provider clones the roamer and loses its original roamer=true flag.
    mod.events:on("roamer.encountered", function(ev)
        if type(ev) ~= "table" then return end
        pendingRoamer = {
            speciesId = Clauses.speciesId(ev.species),
            mapId = areaKey(ev.mapId),
        }
    end)

    mod.events:on("save.loaded", function()
        setupDraft, pendingNewGameState = nil, nil
        dungeonEntry=nil
        Randomizer.clearCache()
        resetOWEShinies()
        currentArea = nil
        activeBattle = nil
        pendingRoamer = nil
        battleInProgress = false
        battleDeaths = nil
        mercyBattle = nil
        installCandyGuard()
        installFieldItemGuards()
        installRandomHiddenItemGuards()
        installRandomTmResolvers()
        installRandomProgressionResolvers()
        installServiceGuards()
        installStatGuards()
        installRunPartyGuards()
        installHardcoreGuards()
        installQolGuards()
        installNicknameGuard()
        installFishingGuard()
        installBattleClauseGuards()
        installStatusBanGuards()
        installAcquisitionGuards()
        installChampionResultHook()
        installShinyVisualGuards()
        local saved=loadState()
        if saved.failed==true and saved.enabled==true then
            if type(saved.finalResult)~="table" then
                Results.finish(saved,session(),Display,"FAILED",
                    "Earlier failed run",countBadgesForResult())
                writeState(saved)
            end
            openFinalScreen(saved.finalResult)
        end
    end)
    mod.events:on("save.created", function()
        if pendingNewGameState then
            mod.save:set(KEY, RunSetup.commit(pendingNewGameState))
        end
        setupDraft, pendingNewGameState = nil, nil
        dungeonEntry=nil
        Randomizer.clearCache()
        resetOWEShinies()
        currentArea = nil
        activeBattle = nil
        pendingRoamer = nil
        battleInProgress = false
        battleDeaths = nil
        mercyBattle = nil
        installCandyGuard()
        installFieldItemGuards()
        installRandomHiddenItemGuards()
        installRandomTmResolvers()
        installRandomProgressionResolvers()
        installServiceGuards()
        installStatGuards()
        installRunPartyGuards()
        installHardcoreGuards()
        installQolGuards()
        installNicknameGuard()
        installFishingGuard()
        installBattleClauseGuards()
        installStatusBanGuards()
        installAcquisitionGuards()
        installChampionResultHook()
        installShinyVisualGuards()
        ResultsScreen.close()
    end)

    -- Record the FIRST encounter even if it runs or faints; later Balls fail.
    -- Tutorial battles and scripted trainer battles do not claim an area.
    mod.events:on("battle.started", function(ev)
        activeBattle = nil
        battleInProgress = true
        currentBattleState = ev and ev.battle
        battleDeaths = nil
        mercyBattle = nil
        -- Install after the engine's battle modules exist, before any item turn.
        installReviveGuard()
        installHardcoreSetGuard()
        installNicknameGuard()
        installCandyGuard()
        installFieldItemGuards()
        installRandomHiddenItemGuards()
        installRandomTmResolvers()
        installRandomProgressionResolvers()
        installServiceGuards()
        installStatGuards()
        installRunPartyGuards()
        installHardcoreGuards()
        installQolGuards()
        installBattleClauseGuards()
        installStatusBanGuards()
        installAcquisitionGuards()
        reportedBattleClauses={}
        local starting = loadState()
        if Core.enforced(starting, "first_rival_forgiveness")
            and not starting.firstRivalMercyConsumed
            and Extra.openingRival(ev, session()) then
            starting.firstRivalMercyConsumed = true
            mercyBattle = ev.battle
            writeState(starting)
            notify("RIVAL_MERCY",
                "First Rival Mercy: fainting here will not count as a death.", true)
        end
        local announcedRoamer = pendingRoamer
        pendingRoamer = nil -- the next battle is the only possible match
        -- Shiny Rate is a gameplay-independent generation setting (like
        -- Game Difficulty), so it works even with Nuzlocke enforcement OFF.
        -- Apply once, BEFORE Shiny Clause checks encounter eligibility.
        local shinyMode = Clauses.get(loadState(), "shiny_rate_mode")
        if type(ev) == "table" and ev.kind == "wild" then
            local mon = ev.battle and ev.battle.enemy
                and ev.battle.enemy.mon
            if type(mon) == "table" then
                local key = oweShinyIdentity(
                    tonumber(mon.speciesId or mon.species or ev.speciesId),
                    tonumber(mon.personality))
                if key and oweShinySeen[key] then
                    -- OWE's spawn PID is authoritative: never improve it
                    -- again after its visible shiny sprite is chosen.
                    mon.nuzlockeShinyRateChecked = true
                end
            end
        end
        ShinyRate.apply(mod, ev, shinyMode, shinyRandomUnit, function(mon)
            local ok, Pokemon = pcall(require, "src.core.game3.pokemon")
            if not ok or not Pokemon or not Pokemon.isShiny then
                error("Gen 3 native shiny resolver unavailable")
            end
            return Pokemon.isShiny(mon)
        end)
        if not isActive() or type(ev) ~= "table" or ev.kind ~= "wild" then return end
        local s = loadState()
        if not captureAvailable(s) then
            -- Emerald's forced first wild battle and other pre-Ball fights
            -- must never count as failed/used encounters.
            return
        end
        deliverPendingStartingBalls()
        local shinyOnly = Playstyles.active(s, Core)
        local rawArea=areaNow()
        local key=encounterAreaNow(s)
        -- Unknown maps cannot claim a route; still enforce shiny-only
        -- catches rather than silently disabling the playstyle.
        -- Every wild catch must run the default glitch eligibility gate,
        -- including provider maps which have no vanilla area identity.
        local native = session()
        local enemy = ev.battle and ev.battle.enemy
        local wildMon = enemy and enemy.mon
        local species = ev.speciesId or ev.species
            or (wildMon and (wildMon.species or wildMon.speciesId))
        local spId = Clauses.speciesId(species)
        local edition = native and (native.edition or native.version
            or native.gameId) or "gen3"
        local markedRoamer = wildMon and wildMon.roamer == true
            or (ev.battle and ev.battle.roamer == true)
        local eventRoamer = announcedRoamer
            and announcedRoamer.speciesId ~= nil
            and announcedRoamer.speciesId == spId
            and (not announcedRoamer.mapId
                or announcedRoamer.mapId == rawArea)
        local roamer = Clauses.roamerActive(s)
            and (markedRoamer or eventRoamer) and spId ~= nil
        local roamerOpen = not roamer or Clauses.roamerAvailable(s, spId)
        local areaEligible = roamer or not key
            or AreaSplits.catchAllowed(s,Core,key,rawArea)
        -- The roamer's species slot replaces the map slot; a free roamer
        -- encounter never consumes this map, even if it flees or faints.
        local dupe = Clauses.isDuplicate(s, species, native, edition)
        local okPokemon, Pokemon = pcall(require, "src.core.game3.pokemon")
        local catchSeed=tostring(native and native.trainerId or "")
            ..":"..tostring(native and native.trainerSecretId or "")
            ..":"..tostring(native and native.name or "")
        local alphabetSet=CatchRules.prepareAlphabet(s,
            okPokemon and Pokemon or nil,catchSeed)
        local colorSet=CatchRules.prepareColor(s,
            okPokemon and Pokemon or nil,catchSeed)
        local typeSet=Variants.prepare(s,
            okPokemon and Pokemon or nil,catchSeed)
        if alphabetSet or colorSet or typeSet then writeState(s) end
        local catchPermitted, bannedReason = CatchRules.check(s, species,
            okPokemon and Pokemon or nil, Core,catchSeed)
        -- No Catching makes every wild ineligible, rather than letting
        -- Failed Encounters spend a route that could never be caught.
        local noCatchReason=BattleItemRules.catchDenial(s,Core,0)
        if noCatchReason then
            catchPermitted=false
            bannedReason=noCatchReason
        end
        local typePermitted,typeReason=Variants.check(s,species,
            okPokemon and Pokemon or nil,Core,catchSeed)
        if not typePermitted then
            catchPermitted=false
            bannedReason=typeReason
        end
        local sourcePermitted, sourceReason = CatchRules.checkBattle(s,
            ev.battle, Core,rawArea)
        if not sourcePermitted then
            catchPermitted = false
            bannedReason = sourceReason
        end
        local shiny = Clauses.isShiny(wildMon)
        -- Ordinary wild Pokémon are NEVER eligible encounters in this
        -- playstyle: Failed Encounters must not spend a route on them.
        local eligible = areaEligible and roamerOpen and not dupe
            and catchPermitted and Playstyles.qualifies(s, Core, shiny)
        local entry = key and s.areas[key] or nil
        if eligible and key and not roamer then
            -- Failed encounters spend normal eligible encounters only.
            -- Skipped duplicate species never claim a route.
            if type(entry) ~= "table" then
                entry = { species = ev.species, speciesId = ev.speciesId,
                    caught = false, spent = false, attempts = 0 }
            end
            entry.attempts = (tonumber(entry.attempts) or 0) + 1
            if Core.shouldSpendOnStart(s)
                and not AreaSplits.safariUntilCatch(s,Core,rawArea) then
                entry.spent = true
            end
            s.areas[key] = entry
            writeState(s)
        end
        activeBattle = {
            battle = ev.battle, area = key, eligible = eligible,
            ballThrows = 0,
            areaEligible = areaEligible, duplicate = dupe,
            shiny = shiny, shinyOnly = shinyOnly,
            exception = false,
            roamer = roamer, roamerOpen = roamerOpen,
            roamerSpecies = spId, prohibitedReason = bannedReason,
        }
        if shinyOnly and eligible then
            notify("SHINY_ENCOUNTER",
                "Shiny Nuzlocke: shiny found! This is a valid catch"
                .. (key and (" on " .. Display.areaName(key)) or "")
                .. ".", true)
        elseif eligible and not roamer and Core.enforced(s, "encounter_limit") then
            if Core.shouldSpendOnStart(s) then
                notify("FIRST_ENCOUNTER",
                    "First encounter on " .. Display.areaName(key)
                    .. "! Catch it now: fleeing or fainting uses your chance.", true)
            else
                notify("CATCH_OPPORTUNITY",
                    "Catch opportunity on " .. Display.areaName(key)
                    .. "! You may try again if it escapes or faints.", true)
            end
        end
    end)

    -- Gen 3's catch.rate wraps vanilla and returns (caught, shakes).
    -- This does not modify normal encounters or trainer battles.
    -- Compose EXP once, then cap it before native Experience.apply.
    mod.hooks:wrap("exp.gain", function(next, ctx)
        local awarded = next(ctx)
        local saved = loadState()
        if not Core.active(saved) or type(ctx) ~= "table"
            or type(ctx.mon) ~= "table" then return awarded end
        local ok, Experience = pcall(require, "src.core.game3.battle.experience")
        if not ok or type(Experience) ~= "table"
            or type(Experience.expForLevel) ~= "function" then
            return awarded
        end
        local cap = levelCap(saved)
        local beforeBank = Levels.banked(saved, ctx.mon)
        local applied = Levels.adjust(saved, ctx.mon, awarded,
            cap, Experience.expForLevel)
        expReports[ctx.mon] = {
            awarded = tonumber(awarded) or 0, applied = applied,
            bankBefore = beforeBank,
            edging = Levels.get(saved, "exp_edging") == true,
            cap = cap,
        }
        writeState(saved)
        return applied
    end)

    -- Native randomiser hooks are registered once at module startup
    -- above, with the current seeded replace() API. Do not re-register
    -- the obsolete Randomizer.wild()/trainers() adapters here.

    mod.hooks:wrap("catch.rate", function(next, ball, mon, species, ctx)
        local battle = activeBattle
        if not isActive() or not battle or type(ctx) ~= "table"
            or ctx.battle ~= battle.battle then
            return next(ball, mon, species, ctx)
        end
        local s = loadState()
        local partyReason=RunParty.addDenied(s,Core,session())
        if partyReason then
            battle.pendingCatchReason=partyReason
            return false,0
        end
        local itemReason=BattleItemRules.catchDenial(s,Core,
            battle.ballThrows)
        if itemReason then
            battle.pendingCatchReason=itemReason
            return false,0
        end
        -- Check at BOTH battle start (encounter-slot policy) and the Ball
        -- transaction (final legality), before Shiny Clause exceptions.
        local sourceAllowed, sourceReason = CatchRules.checkBattle(
            s, ctx.battle, Core,battle.area)
        if not sourceAllowed then
            battle.pendingCatchReason = sourceReason
            return false, 0
        end
        local okPokemon, Pokemon = pcall(require, "src.core.game3.pokemon")
        local native=session()
        local catchSeed=tostring(native and native.trainerId or "")
            ..":"..tostring(native and native.trainerSecretId or "")
            ..":"..tostring(native and native.name or "")
        local alphabetSet=CatchRules.prepareAlphabet(s,
            okPokemon and Pokemon or nil,catchSeed)
        local colorSet=CatchRules.prepareColor(s,
            okPokemon and Pokemon or nil,catchSeed)
        local typeSet=Variants.prepare(s,
            okPokemon and Pokemon or nil,catchSeed)
        if alphabetSet or colorSet or typeSet then writeState(s) end
        local allowed, reason = CatchRules.check(s,
            (type(ctx) == "table" and ctx.speciesId)
                or Clauses.speciesId(species)
                or (type(mon) == "table" and (mon.speciesId or mon.species)),
            okPokemon and Pokemon or nil, Core,catchSeed)
        if allowed then
            allowed,reason=Variants.check(s,
                (type(ctx)=="table" and ctx.speciesId)
                    or Clauses.speciesId(species)
                    or (type(mon)=="table"
                        and (mon.speciesId or mon.species)),
                okPokemon and Pokemon or nil,Core,catchSeed)
        end
        if not allowed then
            -- No shake/clone/PC writeback or Shiny Clause exception.
            -- The matching battle-start check does not spend a route.
            battle.pendingCatchReason = reason
            return false, 0
        end
        local shinyOnly = Playstyles.active(s, Core)
        local shiny = battle.shiny or Clauses.isShiny(mon)
        if shinyOnly and not shiny then
            local suffix = battle.areaEligible
                and " Non-shinies do not use your route chance."
                or " This route is already used."
            battle.pendingCatchReason = "Shiny Nuzlocke: only shiny Pokemon"
                .. " can be caught." .. suffix
            return false, 0
        end
        -- Recover from native wilds whose enemy is not populated until
        -- ball use: the target's shiny identity is authoritative.
        if shinyOnly and shiny and not battle.shiny then
            battle.shiny = true
            battle.eligible = battle.areaEligible and battle.roamerOpen
                and not battle.duplicate
            if battle.eligible and battle.area and not battle.roamer then
                local entry = s.areas[battle.area]
                if type(entry) ~= "table" then
                    entry = { species = species, caught = false,
                        spent = false, attempts = 0 }
                end
                entry.attempts = (tonumber(entry.attempts) or 0) + 1
                if Core.shouldSpendOnStart(s)
                    and not AreaSplits.safariUntilCatch(s,Core,areaNow()) then
                    entry.spent = true
                end
                s.areas[battle.area] = entry
                writeState(s)
            end
        end
        local limited = Core.enforced(s, "encounter_limit")
        local blockedByArea = limited and not battle.areaEligible
        local blockedByDupe = battle.duplicate
        local blockedByRoamer = battle.roamer and not battle.roamerOpen
        local exception = not blockedByRoamer
            and (blockedByArea or blockedByDupe)
            and Playstyles.allowShinyException(s, Core)
            and Clauses.canUseShinyException(s)
            and shiny
        if blockedByRoamer
            or ((blockedByArea or blockedByDupe) and not exception) then
            battle.pendingCatchReason = Notices.catchReason({
                roamer = blockedByRoamer, roamerOpen = battle.roamerOpen,
                duplicate = blockedByDupe, areaEligible = not blockedByArea,
            })
            if blockedByArea and not blockedByDupe and not blockedByRoamer then
                battle.pendingCatchReason = "One Per Area: " ..
                    AreaSplits.name(battle.area,Display.areaName) .. " encounter already used."
            end
            return false, 0
        end
        -- Count only approved Ball transactions. Denied attempts (bans,
        -- duplicate/area rules, and exhausted budgets) never spend a throw.
        local counted=BattleItemRules.countThrow(s,Core,battle.ballThrows)
        if counted then battle.ballThrows=counted end
        local caught, shakes = next(ball, mon, species, ctx)
        -- A failed Ball never consumes a Shiny Clause allowance.
        if caught and exception then battle.exception = true end
        return caught, shakes
    end)

    -- The ball roll runs before native throw/breakout presentation. Tell the
    -- player the rule reason after the ball-thrown event, not on each RNG call.
    mod.events:on("battle.ball_thrown", function(ev)
        local battle = activeBattle
        if not battle or type(ev) ~= "table"
            or ev.battle ~= battle.battle then return end
        local reason = battle.pendingCatchReason
        battle.pendingCatchReason = nil
        if reason then notify("CATCH_DENIED", reason, true) end
    end)

    mod.events:on("battle.exp_gained", function(ev)
        if type(ev) ~= "table" or type(ev.mon) ~= "table" then return end
        local report = expReports[ev.mon]
        expReports[ev.mon] = nil
        if report and report.cap then
            local msg = Notices.expText(
                Notices.name(ev.mon, Display), report, report.cap)
            if msg then notify("EXP_CAP", msg, true) end
        elseif report and report.bankBefore > 0
            and report.applied > report.awarded then
            local msg = Notices.expText(
                Notices.name(ev.mon, Display), report, "NONE")
            if msg then notify("EXP_RELEASE", msg, true) end
        end
    end)

    mod.events:on("pokemon.caught", function(ev)
        -- Native event contains the stored party/PC object, not a
        -- template. Modify only this freshly acquired Pokemon.
        if type(ev)=="table" and type(ev.mon)=="table" then
            local okP,Pokemon=pcall(require,"src.core.game3.pokemon")
            if okP and type(Pokemon)=="table" then
                Stats.player(loadState(),Core,ev.mon,Pokemon)
            end
        end
        -- Capture may have loaded or replaced the native UI after battle
        -- start. Reassert both hooks before the nickname prompt appears.
        installNicknameGuard()
        if not isActive() or not activeBattle then return end
        if type(ev) ~= "table" or ev.battle ~= activeBattle.battle then return end
        local s = loadState()
        local caughtSpecies = ev.speciesId or ev.species
            or (ev.mon and (ev.mon.species or ev.mon.speciesId))
        -- If the battle mon was generated shiny by Nuzlocke, preserve that
        -- explicit identity on the just-cloned captured Pokémon as well.
        local battleMon = activeBattle.battle and activeBattle.battle.enemy
            and activeBattle.battle.enemy.mon
        if battleMon and battleMon.nuzlockeShinyRateBoosted
            and type(ev.mon) == "table" then
            ev.mon.isShiny = true
            ev.mon.nuzlockeShinyRateBoosted = true
        end
        Clauses.noteCaught(s, caughtSpecies, activeBattle.exception)
        local drafted, draftedType, draftedCount, draftTarget
        if not activeBattle.draftRecorded then
            -- Native pokemon.caught is emitted only for a successful wild
            -- capture. Do not infer a draft from Battle started, Ball
            -- thrown, the mandatory starter, optional gifts or NPC swaps.
            activeBattle.draftRecorded=true
            drafted,draftedType,draftedCount,draftTarget=Variants.noteCatch(
                s,caughtSpecies,pokemonResolver(),Core)
        end
        -- A captured roamer closes its *species* slot, not the current route.
        -- Exceptional shiny captures never close the ordinary encounter slot.
        if activeBattle.roamer then
            Clauses.claimRoamer(s, activeBattle.roamerSpecies)
        elseif activeBattle.eligible and not activeBattle.exception then
            local area = s.areas[activeBattle.area]
            if type(area) == "table" then
                area.caught = true
                area.spent = true
                area.caughtSpeciesId = caughtSpecies
                -- Persist capture-time facts, not the Pokemon's future level.
                -- The nickname may be entered after this native event; the
                -- tracker resolves the same individual from party/PC later.
                local caughtMon = type(ev.mon) == "table"
                    and ev.mon or battleMon
                if type(caughtMon) == "table" then
                    area.caughtSpeciesId = caughtMon.species
                        or caughtMon.speciesId or caughtSpecies
                    area.caughtSpeciesName = Display.speciesName(caughtMon)
                    area.caughtNickname = caughtMon.nickname
                    area.caughtLevel = tonumber(caughtMon.level)
                        or (battleMon and tonumber(battleMon.level))
                    area.caughtPersonality = caughtMon.personality
                    area.caughtTrainerId = caughtMon.otId
                        or caughtMon.trainerId
                elseif type(battleMon) == "table" then
                    area.caughtLevel = tonumber(battleMon.level)
                end
            end
        end
        writeState(s)
        if drafted then
            notify("CATCH_DRAFT","Catch Draft: "..draftedType
                .." selected ("..draftedCount.."/"..draftTarget
                .." types).",true)
        end
        if activeBattle.eligible and not activeBattle.roamer
            and not activeBattle.exception and Core.enforced(s, "encounter_limit") then
            notify("ENCOUNTER_CAUGHT", "One Per Area: "
                .. AreaSplits.name(activeBattle.area,Display.areaName)
                .. " capture recorded. This area's slot is now used.", true)
        end
        if Playstyles.active(s, Core) and activeBattle.eligible
            and not activeBattle.exception then
            notify("SHINY_CATCH",
                "Shiny Nuzlocke: shiny Pokemon caught"
                .. (activeBattle.area
                    and (" on " .. AreaSplits.name(activeBattle.area,Display.areaName)) or "")
                .. ".", true)
        end
        if activeBattle.exception then
            notify("SHINY_EXCEPTION",
                "Shiny Clause: an extra catch was allowed.", true)
        elseif activeBattle.roamer then
            notify("ROAMER_CAUGHT",
                "Roamer Clause: this Pokemon's roaming slot is used.", true)
        end
    end)

    -- The engine emits this while the faint is being announced, before the
    -- forced-switch UI. Death is immediate; array compaction is deferred.
    mod.events:on("battle.fainted", recordBattleFaint)

    -- The native battle bridge writes back party HP before battle.ended.
    -- Compact party arrays only then, after the engine no longer needs indices.
    mod.events:on("battle.ended", function(ev)
        retireFainted(type(ev) == "table" and ev.result or nil,
            type(ev) == "table" and ev.battle or nil)
        if type(ev) == "table" and ev.result == "win" then
            local saved = loadState()
            if Levels.noteWin(saved, session(), ev.battle) then
                writeState(saved)
            end
        end
        activeBattle = nil
        battleInProgress = false
        currentBattleState = nil
        battleDeaths = nil
        mercyBattle = nil
        refreshCapNotice()
        nicknameTasks()
        installChampionResultHook()
        installShinyVisualGuards()
        if loadState().failed then
            finishRun("FAILED","Party defeated / no usable survivors",true)
        end
    end)

    -- Gen 3 is API 2 in this fork, and API 3's mod.ui.push uses a different
    -- UI bridge. Keep API 2 for the mature Gen 1/2 code and use the native
    -- Game 3 stack in a mod-local isolated menu module instead.
    local Dev = readModule("gen3_dev.lua")({
        archive = Archive,
        getState = loadState, setState = writeState,
        getCurrentArea = areaNow, getSession = session,
        inBattle = function() return battleInProgress end,
        areaSpent = Core.areaSpent,
    })
    local Gen3Menu = readModule("gen3_menu.lua")(mod, { 
        endRun = function()
            if battleInProgress then return false,"Wait until battle ends" end
            local saved=loadState()
            if Results.isTerminal(saved) then
                openFinalScreen(saved.finalResult)
                return true
            end
            if type(saved.finalResult)=="table" then
                openFinalScreen(saved.finalResult)
                return true
            end
            return finishRun("FORFEIT","Run ended by player",true)
        end,
        openResults = function()
            local saved=loadState()
            if type(saved.finalResult)~="table" then
                return false,"No completed run"
            end
            return openFinalScreen(saved.finalResult)
        end,
        randomizer = {
            get = function(key)
                return Randomizer.get(loadState(), key)
            end,
            set = function(key, value)
                local saved = loadState()
                local ok, reason = Randomizer.set(saved, key, value)
                if ok then writeState(saved) end
                return ok, reason
            end,
            seed = function()
                return Randomizer.seed(loadState())
            end,
            locked = function()
                return Randomizer.locked(loadState())
            end,
            starterRerollStatus = function()
                return Randomizer.starterRerollStatus(loadState())
            end,
            rerollStarters = function()
                local native = session()
                if not native then return nil, "game_not_ready" end
                local edition = tostring(native.version or native.edition
                    or native.gameId or ""):lower()
                if edition:find("fire",1,true)
                    or edition:find("leaf",1,true) then
                    if not isOakLab() then
                        return nil, "reroll_in_oak_lab_only" end
                    return manualStarterReroll("frlg", FRLG_STARTERS)
                end
                local ok, Chooser = pcall(require,
                    "src.ui.game3.rse.starter_choose")
                local man = ok and type(Chooser.manifest) == "function"
                    and Chooser.manifest() or nil
                if not man then return nil, "starter_manifest_unavailable" end
                return manualStarterReroll("rse", man.species)
            end,
            rosterInfo = function()
                local ok, Pokemon = pcall(require, "src.core.game3.pokemon")
                if not ok then return {total=0,extended=0,forms=0,provider=false} end
                return Randomizer.rosterInfo(loadState(), Pokemon)
            end,
        },

        variants = Variants,
        battleItemRules = BattleItemRules,
        fieldItemRules = FieldRules,
        serviceRules = Services,
        statRules = Stats,
        runPartyRules = RunParty,
        gameDifficulty = Difficulty,
        hardcoreRules = Hardcore,
        qolRules = Qol,
        qolSetupRules = QolSetup,
        areaSplitRules = AreaSplits,
        currentEncounterArea = encounterAreaNow,
        notices = function() return Notices.history(loadState()) end,
        modSupport = function()
            return ModSupport.inspect(mod,ShinyRate,Randomizer,loadState())
        end,
        notify = notify,
        getState = loadState, setState = writeState,
        core = Core, clauses = Clauses, catchRules = CatchRules,
        battleClauses = BattleClauses, statusBans = StatusBans,
        shinyRate = ShinyRate,
        playstyles = Playstyles,
        eggs = Eggs, forgiveness = Forgiveness,
        onClauseChanged = onClauseChanged,
        dev = Dev, display = Display,
        levels = {
            get = function(key) return Levels.get(loadState(), key) end,
            set = function(key, value)
                local saved = loadState()
                local ok, reason = Levels.set(saved, key, value)
                if ok then writeState(saved) end
                return ok, reason
            end,
            cap = function() return levelCap() end,
            banked = function(mon) return Levels.banked(loadState(), mon) end,
            currentParty = function()
                return (session() and session().party) or {}
            end,
        },
        nickname = {
            pending = nicknameTasks,
            rename = function(mon, name)
                if not Core.enforced(loadState(), "nickname_rule")
                    or type(mon) ~= "table"
                    or not Extra.customName(name, Display.speciesName(mon)) then
                    return false
                end
                mon.nickname = name
                nicknameTasks()
                notify("NICKNAME_SET", "Nickname Rule: "
                    .. Notices.name(mon, Display) .. " has been named.", false)
                return true
            end,
        },
    })

    -- Install terminal hooks before native Hall of Fame is lazily
    -- entered; game3's close callback is the authoritative completion.
    installChampionResultHook()
    installShinyVisualGuards()
    -- Install text hooks before the native new-game intro loads.
    -- Later save/map events reapply guards for lazy-loaded RSE modules.
    installQolGuards()

    -- Intercept native FRLG + Ruby/Sapphire/Emerald NEW GAME before intro.
    -- A cancelled setup does not write to the previously loaded save.
    readModule("gen3_title_setup.lua")(mod, {
        menu = Gen3Menu,
        beginSetup = function(done)
            setupDraft = RunSetup.newDraft(mod.save:get(KEY, {}))
            pendingNewGameState = nil
            local opened = Gen3Menu.openSetup(game(), function(accepted)
                if accepted then
                    pendingNewGameState = RunSetup.commit(setupDraft)
                else
                    setupDraft = nil
                end
                if type(done) == "function" then done(accepted) end
            end)
            if not opened then setupDraft = nil end
            return opened
        end,
    })

    mod.hooks:wrap("ui.start_menu.items", function(next, g, items)
        local rows = next(g, items)
        if type(rows) ~= "table" or not (g and g.session) then return rows end
        -- Mirror the Gen 1/2 entry: one Start-menu destination.
        table.insert(rows, {
            id = "nuzlocke.gen3.menu",
            label = "NUZ MENU",
            onSelect = function()
                refreshForgiveness()
                installCandyGuard()
                installFishingGuard()
                installBattleClauseGuards()
                installStatusBanGuards()
        installAcquisitionGuards()
                Gen3Menu.open(g)
            end,
        })
        return rows
    end)

    mod.exports.gen3_menu = Gen3Menu
    mod.exports.gen3_run_setup = { api = RunSetup.api,
        locked = function() return loadState().runSettingsLocked == true end,
    }
    mod.exports.gen3_randomizer = {
        api = Randomizer.api, algorithm = Randomizer.algorithm,
        get = function(key) return Randomizer.get(loadState(), key) end,
        set = function(key, value)
            local saved = loadState()
            local ok, reason = Randomizer.set(saved, key, value)
            if ok then writeState(saved) end
            return ok, reason
        end,
        effectiveSeed = function() return Randomizer.seed(loadState()) end,
        locked = function() return Randomizer.locked(loadState()) end,
    }
    mod.exports.gen3_playstyles = {
        api = Playstyles.api, schema = Playstyles.schema,
        definitions = Playstyles.descriptors,
        getRule = function(key)
            return Playstyles.get(loadState(), key)
        end,
        setRule = function(key, value)
            local saved = loadState()
            local ok, reason = Playstyles.set(saved, key, value)
            if ok then
                writeState(saved)
                if key == "hardcore_nuzlocke" then
                    notify("PLAYSTYLE_CHANGED", value
                        and "Hardcore ON: forced SET, no battle items except "
                            .. "Poke Balls, Champion level caps and strict "
                            .. "Nuzlocke rules."
                        or "Hardcore OFF: previous CORE, LEVELS and battle "
                            .. "style preferences restored.", false)
                    refreshCapNotice()
                else
                    notify("PLAYSTYLE_CHANGED",
                        "Shiny Nuzlocke " .. (value and "enabled: only shinies"
                            or "disabled: ordinary catch rules")
                        .. (value and " may be caught." or " restored."), false)
                end
            end
            return ok, reason
        end,
    }
    mod.exports.gen3_notices = {
        api = Notices.api,
        history = function() return Notices.history(loadState()) end,
    }
    mod.exports.gen3_levels = {
        api = Levels.api, schema = Levels.schema,
        scopes = Levels.scopes,
        getRule = function(key) return Levels.get(loadState(), key) end,
        getCurrentCap = function() return levelCap() end,
        getBank = function(mon) return Levels.banked(loadState(), mon) end,
        setRule = function(key, value)
            local saved = loadState()
            local ok, reason = Levels.set(saved, key, value)
            if ok then writeState(saved) end
            return ok, reason
        end,
        setPostgameCap = function(value)
            local saved = loadState()
            local ok, reason = Levels.setPostgameCap(saved, value)
            if ok then writeState(saved) end
            return ok, reason
        end,
    }
    -- Read-only diagnostic API. Mutators stay internal to the developer menu.
    mod.exports.gen3_status_bans = {
        api=StatusBans.api,schema=StatusBans.schema,
        definitions=StatusBans.descriptors,
        getRule=function(key) return StatusBans.get(loadState(),key) end,
        setRule=function(key,value)
            local saved=loadState()
            local ok,reason=StatusBans.set(saved,key,value)
            if ok then writeState(saved) end
            return ok,reason
        end,
    }
    mod.exports.gen3_battle_clauses = {
        api=BattleClauses.api, schema=BattleClauses.schema,
        definitions=BattleClauses.descriptors,
        getRule=function(key) return BattleClauses.get(loadState(),key) end,
        setRule=function(key,value)
            local s=loadState()
            local ok,reason=BattleClauses.set(s,key,value)
            if ok then writeState(s) end
            return ok,reason
        end,
    }
    mod.exports.gen3_qol_setup = {
        api=QolSetup.api,schema=QolSetup.schema,
        definitions=QolSetup.descriptors,
        getRule=function(key) return QolSetup.get(loadState(),key) end,
        setRule=function(key,value)
            local saved=loadState()
            local ok,reason=QolSetup.set(saved,key,value)
            if ok then writeState(saved) end
            return ok,reason
        end,
        preview=function() return QolSetup.plan(loadState()) end,
    }
    mod.exports.gen3_qol = {
        api=Qol.api,schema=Qol.schema,
        definitions=Qol.descriptors,
        getRule=function(key) return Qol.get(loadState(),key) end,
        setRule=function(key,value)
            local saved=loadState()
            local ok,reason=Qol.set(saved,key,value)
            if ok then writeState(saved) end
            return ok,reason
        end,
    }
    mod.exports.gen3_hardcore_rules = {
        api=Hardcore.api,schema=Hardcore.schema,
        definitions=Hardcore.descriptors,
        getRule=function(key) return Hardcore.get(loadState(),key) end,
        setRule=function(key,value)
            local saved=loadState()
            local ok,reason=Hardcore.set(saved,key,value)
            if ok then writeState(saved) end
            return ok,reason
        end,
        dungeonEntry=function() return dungeonEntry end,
    }
    mod.exports.gen3_game_difficulty = {
        api=Difficulty.api,schema=Difficulty.schema,
        definitions=Difficulty.descriptors,
        getRule=function(key) return Difficulty.get(loadState(),key) end,
        setRule=function(key,value)
            local saved=loadState()
            local ok,reason=Difficulty.set(saved,key,value)
            if ok then writeState(saved) end
            return ok,reason
        end,
        profile=function() return Difficulty.profile(loadState()) end,
    }
    mod.exports.gen3_run_party = {
        api=RunParty.api,schema=RunParty.schema,
        definitions=RunParty.descriptors,
        getRule=function(key) return RunParty.get(loadState(),key) end,
        setRule=function(key,value)
            local saved=loadState()
            local ok,reason=RunParty.set(saved,key,value)
            if ok then writeState(saved) end
            return ok,reason
        end,
        partyCap=function() return RunParty.partyCap(loadState(),Core) end,
    }
    mod.exports.gen3_area_splits = {
        api=AreaSplits.api,schema=AreaSplits.schema,
        definitions=AreaSplits.descriptors,
        getRule=function(key) return AreaSplits.get(loadState(),key) end,
        setRule=function(key,value)
            local saved=loadState()
            local ok,reason=AreaSplits.set(saved,key,value)
            if ok then writeState(saved) end
            return ok,reason
        end,
        current=function() return encounterAreaNow(loadState()) end,
        label=function(key)
            return AreaSplits.name(key,Display.areaName)
        end,
    }
    mod.exports.gen3_pokemon_stats = {
        api=Stats.api,schema=Stats.schema,
        definitions=Stats.descriptors,
        getRule=function(key) return Stats.get(loadState(),key) end,
        setRule=function(key,value)
            local saved=loadState()
            local ok,reason=Stats.set(saved,key,value)
            if ok then writeState(saved) end
            return ok,reason
        end,
    }
    mod.exports.gen3_services_economy = {
        api=Services.api,schema=Services.schema,
        definitions=Services.descriptors,
        getRule=function(key) return Services.get(loadState(),key) end,
        setRule=function(key,value)
            local saved=loadState()
            local ok,reason=Services.set(saved,key,value)
            if ok then writeState(saved) end
            return ok,reason
        end,
    }
    mod.exports.gen3_field_items = {
        api=FieldRules.api,schema=FieldRules.schema,
        definitions=FieldRules.descriptors,
        getRule=function(key) return FieldRules.get(loadState(),key) end,
        setRule=function(key,value)
            local saved=loadState()
            local ok,reason=FieldRules.set(saved,key,value)
            if ok then writeState(saved) end
            return ok,reason
        end,
    }
    mod.exports.gen3_battle_items = {
        api=BattleItemRules.api,schema=BattleItemRules.schema,
        definitions=BattleItemRules.descriptors,
        getRule=function(key) return BattleItemRules.get(loadState(),key) end,
        setRule=function(key,value)
            local saved=loadState()
            local ok,reason=BattleItemRules.set(saved,key,value)
            if ok then writeState(saved) end
            return ok,reason
        end,
        throws=function()
            return activeBattle and activeBattle.ballThrows or 0
        end,
    }
    mod.exports.gen3_variants = {
        api=Variants.api,schema=Variants.schema,
        definitions=Variants.descriptors,
        getRule=function(key) return Variants.get(loadState(),key) end,
        setRule=function(key,value)
            local saved=loadState()
            local ok,reason=Variants.set(saved,key,value)
            if ok then writeState(saved) end
            return ok,reason
        end,
        check=function(species)
            local ok,Pokemon=pcall(require,"src.core.game3.pokemon")
            return Variants.check(loadState(),species,
                ok and Pokemon or nil,Core)
        end,
    }
    mod.exports.gen3_catch_rules = {
        api = CatchRules.api, schema = CatchRules.schema,
        definitions = CatchRules.descriptors,
        getRule = function(key) return CatchRules.get(loadState(), key) end,
        setRule = function(key, value)
            local s = loadState()
            local ok, reason = CatchRules.set(s, key, value)
            if ok then writeState(s) end
            return ok, reason
        end,
        check = function(species)
            local ok, Pokemon = pcall(require, "src.core.game3.pokemon")
            return CatchRules.check(loadState(), species,
                ok and Pokemon or nil, Core)
        end,
    }
    mod.exports.gen3_clauses = {
        api = 1, schema = Clauses.schema,
        definitions = Clauses.descriptors,
        getMode = function(key)
            return Clauses.get(loadState(), key)
        end,
        shinyRateOwner = function()
            return ShinyRate.externalProvider(mod) or "Nuzlocke"
        end,
        setMode = function(key, value)
            if key == "shiny_rate_mode" and ShinyRate.externalProvider(mod) then
                return false, "external_provider"
            end
            local saved = loadState()
            local ok, reason = Clauses.set(saved, key, value)
            if ok then
                onClauseChanged(saved, key)
                writeState(saved)
            end
            return ok, reason
        end,
        summary = function()
            local saved = loadState()
            return { shinyExceptionsUsed = saved.shinyExceptionsUsed,
                forgivenessTokens = Forgiveness.balance(saved),
                eggsTracked = #(saved.eggHistory or {}),
                roamerClaims = (function()
                    local count = 0
                    for _, v in pairs(saved.roamerClaims or {}) do
                        if v then count = count + 1 end
                    end
                    return count
                end)(),
                speciesRecorded = (function()
                    local count = 0
                    for _ in pairs(saved.capturedSpecies) do count = count + 1 end
                    return count
                end)() }
        end,
    }
    mod.exports.gen3_dev_info = { api = 1, snapshot = Dev.inspect,
        status = Dev.status }

    -- Versioned integration contract: callers may inspect a COPY of state
    -- or ask whether a rule is enabled, but cannot bypass implementation gates.
    mod.exports.gen3_core = {
        api = 1,
        schema = Core.schema,
        definitions = Core.descriptors,
        getRule = function(key)
            return Core.get(loadState(), key)
        end,
        setRule = function(key, value)
            local state = loadState()
            local ok, err = Core.set(state, key, value)
            if ok then
                writeState(state)
                if key == "nickname_rule" and value then nicknameTasks() end
            end
            return ok, err
        end,
    }

    -- Advertise supported scope without borrowing existing API-37 promises.
    mod.exports.gen3_classic = {
        api = 1,
        stage = "EXPERIMENTAL",
        features = { "first_wild_per_area", "optional_failed_encounters",
            "gen3_dupes_clause", "gen3_shiny_clause", "gen3_roamer_clause",
            "gen3_shiny_rate", "gen3_shiny_nuzlocke",
            "gen3_hardcore_nuzlocke", "gen3_eggs_wip",
            "gen3_route_forgiveness_wip",
            "gen3_catch_species_bans", "gen3_catch_maximum_bst",
            "gen3_no_static_encounters", "gen3_no_fishing",
            "gen3_effect_battle_clauses",
            "gen3_status_bans",
            "immediate_faint_death", "revive_denial", "post_battle_retirement",
            "whiteout_ends_run", "first_rival_mercy_wip",
            "pc_survivors_wip", "nickname_requirement_wip",
            "gym_league_level_caps", "exp_edging",
            "random_wild_and_fishing_species", "random_trainer_parties",
            "randomizer_seed_v1" },
        state = function()
            local s = loadState()
            return { enabled = s.enabled, failed = s.failed,
                areaCount = (function()
                    local n = 0
                    for _ in pairs(s.areas) do n = n + 1 end
                    return n
                end)(), deaths = #s.graveyard }
        end,
    }
end
