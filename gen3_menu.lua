-- Gen 3 Nuzlocke menu: native 240x160 GBA menu stack.
-- Gen 1/2 screens are unchanged; this is an isolated, labelled feature tracker.
-- [WIP] = partially implemented; [Soon] = visible planning placeholder.
return function(mod, api)
    local MENU_ID = "nuzlocke.gen3.menu"
    local VISIBLE = 6
    local pages = {}
    local setupOnDone
    local engineGame
    local Core = assert(api.core, "Gen 3 menu needs CORE rule contract")
    local Clauses = assert(api.clauses, "Gen 3 menu needs CLAUSES policy")
    local CatchRules = assert(api.catchRules, "Gen 3 menu needs CATCH RULES policy")
    local Variants = assert(api.variants, "Gen 3 menu needs VARIANTS policy")
    local BattleItemRules = assert(api.battleItemRules, "Gen 3 menu needs BATTLE ITEMS policy")
    local FieldRules = assert(api.fieldItemRules, "Gen 3 menu needs FIELD ITEMS policy")
    local Services = assert(api.serviceRules, "Gen 3 menu needs SERVICES policy")
    local Stats = assert(api.statRules, "Gen 3 menu needs POKEMON STATS policy")
    local AreaSplits = assert(api.areaSplitRules, "Gen 3 menu needs AREA SPLITS policy")
    local RunParty = assert(api.runPartyRules, "Gen 3 menu needs RUN / PARTY policy")
    local Difficulty = assert(api.gameDifficulty, "Gen 3 menu needs GAME DIFFICULTY policy")
    local Hardcore = assert(api.hardcoreRules, "Gen 3 menu needs HARDCORE policy")
    local Qol = assert(api.qolRules, "Gen 3 menu needs QOL policy")
    local Setup = assert(api.qolSetupRules, "Gen 3 menu needs QOL SETUP policy")
    local BattleClauses = assert(api.battleClauses,
        "Gen 3 menu needs BATTLE CLAUSES policy")
    local StatusBans = assert(api.statusBans,
        "Gen 3 menu needs STATUS BANS policy")
    local Playstyles = assert(api.playstyles, "Gen 3 menu needs PLAYSTYLES policy")
    local ShinyRate = assert(api.shinyRate, "Gen 3 menu needs shiny rate service")
    local Forgiveness = assert(api.forgiveness, "Gen 3 menu needs token policy")
    local Dev = assert(api.dev, "Gen 3 menu needs developer tools")
    local Levels = assert(api.levels, "Gen 3 menu needs LEVELS contract")
    local Randomizer = assert(api.randomizer, "Gen 3 menu needs RANDOMIZER contract")
    local Display = assert(api.display, "Gen 3 menu needs species and location labels")

    -- Mirrored from rule_catalog.lua in the established Gen 1/2 mod.
    -- A catalog row is not evidence of Gen 3 runtime support.
    local CATALOG = {
    { title = "CORE", rules = {{ "nuzlocke_enabled", "Nuzlocke" }, { "permadeath", "Permadeath" }, { "first_rival_forgiveness", "First Rival Mercy" }, { "encounter_limit", "One Per Area" }, { "failed_encounter", "Failed Encounters" }, { "nickname_rule", "Nickname" } } },
    { title = "CLAUSES", rules = {{ "dupes_mode", "Dupes Clause" }, { "shiny_clause", "Shiny Clause" }, { "shiny_rate_mode", "Shiny Rate" }, { "gen3_roamer_clause", "Roamer Clause" }, { "gen3_egg_encounter_mode", "Egg Encounter" }, { "route_forgiveness", "Route Forgiveness" } } },
    { title = "HARDCORE", rules = {{ "no_escape", "No Escape" }, { "whiteout_clause", "Whiteout" }, { "gym_lock_in", "Gym Lock-In" }, { "dungeon_lock_in", "Dungeon Lock-In" }, { "no_held_items", "No Held Items" } } },
    { title = "GAME DIFFICULTY", rules = {{ "difficulty_profile", "Game Difficulty" } } },
    { title = "RUN / PARTY", rules = {{ "gym_team_size", "Gym Team Size" }, { "party_size_limit", "Party Size Limit" }, { "evolution_limit", "Evolution Limits" } } },
    { title = "LEVELS", rules = {{ "level_cap_scope", "Level Cap Scope" }, { "exp_edging", "EXP Edging" } } },
    { title = "PLAYSTYLES", rules = {
        { "shiny_nuzlocke", "Shiny Nuzlocke" },
        { "hardcore_nuzlocke", "Hardcore Nuzlocke" },
    } },
    { title = "CATCH RULES", rules = {{ "town_catches", "Town Catches" }, { "ban_legendaries", "No Legendaries" }, { "ban_mythicals", "No Mythicals" }, { "ban_pseudos", "No Pseudos" }, { "no_static_encounters", "No Static Enc" }, { "no_fishing", "No Fishing" }, { "allow_gifts", "Gift Pokemon" }, { "gift_slot_policy", "Gift Slot Policy" }, { "allow_trades", "In-Game Trades" }, { "trade_slot_policy", "Trade Slot Policy" }, { "maximum_bst", "Maximum BST" }, { "pkmn_ban", "PKMN BAN" }, { "colorlocke_mode", "Colorlocke" }, { "colorlocke_color", "Color" }, { "alphabetlocke_mode", "Alphabetlocke" }, { "alphabetlocke_letter", "Letter" }, { "allow_glitch_pokemon", "Allow Glitches" } } },
    { title = "BATTLE CLAUSES", rules = {{ "ohko_clause", "OHKO Clause" }, { "flinch_clause_scope", "Flinch Clause" }, { "trap_clause_scope", "Trap Clause" }, { "setup_move_scope", "No Setup Moves" }, { "evasion_clause", "Evasion Clause" }, { "status_accuracy_scope", "Accuracy Drops" }, { "other_stat_drop_scope", "Other Stat Drops" } } },
    { title = "STATUS BANS", rules = {{ "status_move_scope", "No Status Moves" }, { "status_paralysis_scope", "Paralysis" }, { "status_confusion_scope", "Confusion" }, { "status_sleep_scope", "Sleep Ban" }, { "status_poison_scope", "Poison/Toxic" }, { "status_burn_scope", "Burn Ban" }, { "status_freeze_scope", "Freeze" }, { "sleep_clause", "Sleep Clause" } } },
    { title = "VARIANTS", rules = {{ "type_lock_mode", "Type Locke" }, { "type_lock_draft", "Catch Draft" }, { "type_lock_primary", "Type 1" }, { "type_lock_secondary", "Type 2" }, { "type_lock_tertiary", "Type 3" }, { "type_lock_quaternary", "Type 4" }, { "type_lock_quinary", "Type 5" }, { "type_lock_senary", "Type 6" } } },
    { title = "BATTLE ITEMS", rules = {{ "no_healing_items", "No Healing Items" }, { "no_battle_items", "No X Items" }, { "no_catching", "No Catching" }, { "encounter_ball_limit", "Ball Per Enc." } } },
    { title = "FIELD ITEMS", rules = {{ "no_repels", "No Repels" }, { "no_escape_rope", "No Escape Rope" }, { "travel_restrictions", "Travel Restrictions" }, { "no_field_healing", "No Field Heal" }, { "no_pp_items", "No PP Items" }, { "no_tm_use", "No TMs" }, { "no_rare_candy_use", "No Rare Candy" } } },
    { title = "SERVICES & ECONOMY", rules = {{ "no_poke_center", "No Center Heal" }, { "no_mom_heal", "No Mom Heal" }, { "no_day_care", "No Day Care" }, { "shop_restrictions", "Shop Restrictions" }, { "no_gambling", "No Gambling" }, { "trainer_money_multiplier", "Trainer Money" } } },
    { title = "POKEMON STATS", rules = {{ "player_start_stat_exp", "Player Stat EXP" }, { "wild_start_stat_exp", "Wild Stat EXP" }, { "trainer_start_stat_exp", "Trainer Stat EXP" }, { "no_player_stat_exp_gain", "No Stat EXP Gain" }, { "perfect_player_ivs", "Perfect Player IVs" }, { "perfect_wild_ivs", "Perfect Wild IVs" }, { "perfect_trainer_ivs", "Perfect Trainer IVs" } } },
    { title = "AREA SPLITS", rules = {{ "route_2_split", "Route 2" }, { "route_10_split", "Route 10" }, { "route_20_split", "Route 20" }, { "mt_moon_splits", "Mt. Moon" }, { "safari_zone_splits", "Safari Clause" }, { "gold_time_split", "Time Split" }, { "gold_headbutt_split", "Headbutt Split" } } },
    { title = "RANDOMIZER", rules = {{ "randomizer_preset", "Rndm Preset" }, { "randomizer_seed", "Rndm Seed" }, { "random_starter", "Rndm Strtr" }, { "random_starter_style", "Strtr Style" }, { "random_starter_balance", "Strtr Balance" }, { "random_starter_trio_typing", "Trio Typing" }, { "random_starter_rerolls", "Starter Rerolls" }, { "random_encounter_tables", "Random Encounters" }, { "random_static_pokemon", "Random Static Pokemon" }, { "random_static_balance", "Static Balance" }, { "random_gift_pokemon", "Random Gift Pokemon" }, { "random_egg_gifts", "Random Egg Gifts" }, { "random_gift_balance", "Gift Balance" }, { "random_field_items", "Random Field Items" }, { "random_field_item_balance", "Field Item Balance" }, { "random_field_item_repetition", "Field Item Repeats" }, { "random_encounter_balance", "Encounter Balance" }, { "random_encounter_repetition", "Encounter Repeats" }, { "random_encounter_diversity_strength", "Diversity Strength" }, { "randomizer_info_policy", "Randomizer Info" }, { "random_species_generation", "Species Pool" }, { "random_species_roster", "National Dex" }, { "random_species_forms", "Alternate Forms" }, { "random_learnsets", "Random Learnsets" }, { "random_trainers", "Random Trainers" }, { "random_evolutions", "Random Evolutions" }, { "random_evolution_balance", "Evolution Balance" }, { "random_shops", "Random Shops" }, { "random_shop_balance", "Shop Balance" }, { "random_tms", "Random TMs" }, { "random_tm_compatibility", "TM Compatibility" }, { "random_tm_locations", "Random TM Locations" }, { "random_gift_items", "Random Gift Items" }, { "random_trainer_balance", "Trainer Balance" }, { "random_trainer_diversity", "Trainer Diversity" }, { "random_trainer_theme", "Trainer Theme" }, { "random_learnset_generation", "Learnset Gen" }, { "random_learnset_stab", "Learnset STAB" } } },
    { title = "QOL", rules = {{ "instant_text", "Instant Text" }, { "run_surf", "Run / Surf" }, { "unlimited_bag_space", "Unlimited Bag Space" }, { "trade_evolutions", "Trade Evolutions" } } },
    { title = "QOL SETUP ONLY", rules = {{ "starting_pokeballs", "Starting Poke Balls" }, { "starting_rare_candies", "Starting Rare Candy" }, { "starting_money", "Starting Money" }, { "pc_starting_heal_items", "Heal Loadout" }, { "pc_starting_vitamins", "PC Vitamins" } } },
    }

    -- Less commonly used legacy rule groups live one level down to keep
    -- NUZ RULES focused on the currently relevant Gen 3 functionality.
    -- Preserve each category's original key/label definitions and [Soon]
    -- status; this changes navigation only, not saved rule values.
    local ADVANCED_RULES = {
        ["CATCH RULES"] = true,
        ["BATTLE CLAUSES"] = true,
        ["STATUS BANS"] = true,
        ["VARIANTS"] = true,
        ["BATTLE ITEMS"] = true,
        ["FIELD ITEMS"] = true,
        ["SERVICES & ECONOMY"] = true,
        ["POKEMON STATS"] = true,
        ["AREA SPLITS"] = true,
    }

    local function state()
        return api.getState()
    end

    local function prefix(kind)
        if kind == "soon" then return "[Soon] " end
        if kind == "wip" then return "[WIP] " end
        return ""
    end

    local function row(label, kind, action, detail)
        return {
            label = prefix(kind) .. tostring(label or ""),
            kind = kind or "working",
            action = action,
            detail = detail,
        }
    end

    local function page(title, rows)
        return { title = tostring(title), rows = rows or {}, index = 1, scroll = 0 }
    end

    local function present(title, rows, refresh)
        local p = page(title, rows)
        p.refresh = refresh
        pages[#pages + 1] = p
    end

    local function popPage()
        if #pages <= 1 then return end
        pages[#pages] = nil
        local p = pages[#pages]
        if p and p.refresh then
            p.rows = p.refresh()
            p.index = math.max(1, math.min(p.index, #p.rows))
            p.scroll = math.min(p.scroll, math.max(0, #p.rows - VISIBLE))
        end
    end

    -- Detail pages should not silently clip long help text at 181 px.
    -- At most 25 single-byte characters per row fits the native GBA
    -- small font. Lists with long Pokémon names keep their own detail pages.
    local function wrapDetails(message)
        local lines,line={},""
        for word in tostring(message or ""):gmatch("%S+") do
            while #word>25 do
                if line~="" then lines[#lines+1]=line;line="" end
                lines[#lines+1]=word:sub(1,25)
                word=word:sub(26)
            end
            if #word>0 then
                if #line>0 and #line+#word+1>25 then
                    lines[#lines+1]=line
                    line=word
                else
                    line=line=="" and word or (line.." "..word)
                end
            end
        end
        if line~="" then lines[#lines+1]=line end
        return lines
    end

    local function info(title, lines)
        -- Lock denials are a deliberate, supported policy, never [Soon].
        -- Most category setters pass their reason through this shared popup.
        for _, message in ipairs(lines or {}) do
            if message == "run_settings_locked" then
                title = "SETTINGS LOCKED"
                lines = {
                    "LOCK FOR RUN IS ACTIVE",
                    "RULES CANNOT BE CHANGED",
                    "DURING THIS PLAYTHROUGH",
                    "NEW GAME TO RECONFIGURE",
                    "NO SETTINGS CHANGED",
                }
                break
            end
        end
        local rows = {}
        for _, label in ipairs(lines or {}) do
            local wrapped=wrapDetails(label)
            if #wrapped==0 then wrapped={tostring(label)} end
            for _,part in ipairs(wrapped) do
                rows[#rows+1]=row(part,nil)
            end
        end
        present(title, rows)
    end

    local function count(t)
        local n = 0
        for _ in pairs(t or {}) do n = n + 1 end
        return n
    end

    local function current()
        return pages[#pages]
    end

    local function showStatus()
        local s = state()
        info("RUN DETAILS", {
            s.failed and "RUN: LOST"
                or (s.finalResult and s.finalResult.outcome=="VICTORY"
                    and "RUN: CHAMPION" or "RUN: ACTIVE"),
            "MODE: " .. (s.enabled and "ON" or "OFF"),
            "AREAS: " .. count(s.areas),
            "DEATHS: " .. #s.graveyard,
            "CATCH: " .. (Core.get(s, "encounter_limit")
                and "PER AREA" or "UNLIMITED"),
            "DEATH: " .. (Core.get(s, "permadeath")
                and "IMMEDIATE" or "OFF"),
            "DUPES: " .. Clauses.label(s, "dupes_mode"),
            "PLAYSTYLE: " .. (Playstyles.get(s, "hardcore_nuzlocke")
                and (Playstyles.get(s, "shiny_nuzlocke")
                    and "SHINY + HARD" or "HARDCORE")
                or (Playstyles.get(s, "shiny_nuzlocke")
                    and "SHINY NUZ" or "CLASSIC")),
            "SHINY CLAUSE: " .. Clauses.label(s, "shiny_clause"),
            "SHINY USED: " .. tostring(s.shinyExceptionsUsed or 0),
            "B: RETURN",
        })
    end

    local function showTracker()
        local s = state()
        local ids = {}
        for key in pairs(s.areas) do ids[#ids + 1] = tostring(key) end
        table.sort(ids)
        local rows = {}
        rows[#rows + 1] = row("AREA LEDGER",nil,nil,
            "The active Area Splits policy controls encounter keys.")
        for _, key in ipairs(ids) do
            local entry = s.areas[key]
            local didCatch = type(entry) == "table" and entry.caught
            local spent = Core.areaSpent(entry)
            local id = key
            local place = AreaSplits.name(id,Display.areaName)
            local caught = didCatch and Display.trackerCatch(entry,
                engineGame and engineGame.session, s.graveyard) or nil
            local label = (didCatch and "C " or
                (spent and "- " or "* ")) .. place
            if caught and caught.known then
                label = label .. ": " .. caught.name
            end
            rows[#rows + 1] = row(label, nil, function()
                local details = {
                    "LOCATION: " .. place,
                    didCatch and "CAUGHT: YES" or "CAUGHT: NO",
                    spent and "ENCOUNTER USED" or "CATCH STILL OPEN",
                    "ATTEMPTS: " .. tostring(entry.attempts or 1),
                }
                if caught then
                    if caught.known then
                        details[#details + 1] = "NAME: " .. caught.name
                        details[#details + 1] = "SPECIES: " .. caught.species
                        details[#details + 1] = "LEVEL CAUGHT: "
                            .. (caught.level and tostring(caught.level)
                                or "UNKNOWN")
                    else
                        details[#details + 1] = "CAPTURE DETAILS UNAVAILABLE"
                        details[#details + 1] = "OLDER SAVE RECORD"
                    end
                end
                info("AREA DETAIL", details)
            end)
        end
        if #ids == 0 then
            rows[#rows + 1] = row("NO AREAS CLAIMED")
        end
        present("ENC TRACKER", rows)
    end

    local function showGraveyard()
        local s = state()
        local rows = {}
        for _, entry in ipairs(s.graveyard) do
            local member = entry
            local species = Display.speciesName(member)
            local name = Display.pokemonName(member)
            local location = Display.areaName(member.area)
            if location == "Unknown location"
                and type(member.areaName) == "string"
                and member.areaName ~= "" then
                location = member.areaName
            end
            local level = tonumber(member.level)
            local summary = name
            if level then summary = summary .. " Lv" .. tostring(level) end
            rows[#rows + 1] = row(summary, nil, function()
                local details = {
                    "POKEMON: " .. name,
                }
                if name ~= species then
                    -- Don't repeat species/name unless there is a nickname.
                    details[#details + 1] = "SPECIES: " .. species
                end
                details[#details + 1] =
                    "LEVEL: " .. (level and tostring(level) or "Unknown")
                details[#details + 1] = "LOST AT: " .. location
                details[#details + 1] =
                    "CAUSE: " .. tostring(member.cause or "Fainted")
                info("IN MEMORY", details)
            end)
        end
        if #rows == 0 then rows[1] = row("NO FALLEN POKEMON") end
        present("GRAVEYARD", rows)
    end

    local function disabledFeature(title, key)
        info("COMING SOON", {
            "[Soon] " .. title,
            "NOT ACTIVE IN GEN 3",
            "NO SETTINGS CHANGED",
            key and ("ID: " .. key) or "PLANNED FEATURE",
        })
    end

    -- Display and edit from one source of truth, never a duplicated list.
    -- A [Soon] row is intentionally read-only even if a default is stored.
    local function coreRows()
        local s = state()
        local rows = {}
        local labels = {
            nuzlocke_enabled = "NUZLOCKE",
            permadeath = "PERMADEATH",
            encounter_limit = "ONE PER AREA",
            failed_encounter = "FAILED ENC.",
            nickname_rule = "NICKNAME",
            first_rival_forgiveness = "RIVAL MERCY",
            whiteout_ends_run = "WHITEOUT FAILS",
            pc_survivors_allowed = "PC SURVIVORS",
        }
        for _, desc in ipairs(Core.descriptors()) do
            local key = desc.key
            local label = labels[key] or desc.label
            local status = desc.status
            if status == "soon" then
                rows[#rows + 1] = row(label, "soon", function()
                    disabledFeature(label, key)
                end)
            else
                local function updateLabel()
                    local fresh = state()
                    if Playstyles.hardcoreActive(fresh, Core)
                        and Core.hardcoreForced(key) then
                        return label .. ": FORCED ON"
                    end
                    return label .. ": " ..
                        (Core.get(fresh, key) and "ON" or "OFF")
                end
                rows[#rows + 1] = row(updateLabel(), nil,
                    function()
                        local fresh = state()
                        local ok, reason = Core.set(fresh, key,
                            not Core.get(fresh, key))
                        if ok then
                            api.setState(fresh)
                            -- Update the displayed label at the same cursor
                            -- without pushing a second screen.
                            current().rows = coreRows()
                        elseif reason == "run_failed" then
                            return
                        elseif reason == "hardcore_override" then
                            info("HARDCORE OVERRIDE", {
                                label .. ": FORCED ON",
                                "DISABLE HARDCORE FIRST",
                                "ORIGINAL RULE IS SAVED",
                            })
                        elseif reason == "run_settings_locked" then
                            info("SETTINGS LOCKED", { reason })
                        else
                            disabledFeature(label, key)
                        end
                    end)
            end
        end
        return rows
    end

    local function eggHistory()
        local rows, history = {}, state().eggHistory or {}
        for i = #history, math.max(1, #history - 19), -1 do
            local item = history[i]
            local species = Display.speciesName({ species = item.species })
            rows[#rows + 1] = row(species .. " " .. tostring(item.status), nil,
                function() info("EGG DETAIL", {
                    "POKEMON: " .. species,
                    "HATCH: " .. Display.areaName(item.location),
                    "STATUS: " .. tostring(item.status),
                }) end)
        end
        if #rows == 0 then rows[1] = row("NO EGGS TRACKED") end
        present("EGG HISTORY", rows)
    end

    local function forgivenessRows()
        local saved = state()
        local rows = { row("TOKENS: " .. Forgiveness.balance(saved)) }
        if Clauses.get(saved, "route_forgiveness") == 0 then
            rows[#rows + 1] = row("CLAUSE OFF")
            return rows
        end
        local ids = {}
        for id in pairs(saved.areas or {}) do
            if Forgiveness.canReopen(saved, id) then ids[#ids + 1] = id end
        end
        table.sort(ids)
        for _, id in ipairs(ids) do
            local target = id
            rows[#rows + 1] = row(Display.areaName(id), nil, function()
                present("CONFIRM TOKEN", {
                    row("YES: REOPEN", nil, function()
                        local latest = state()
                        if Forgiveness.reopen(latest, target) then
                            api.setState(latest)
                            if api.notify then
                                api.notify("ROUTE_FORGIVEN",
                                    "Route Forgiveness: " .. Display.areaName(target)
                                    .. " reopened. One token spent.", false)
                            end
                        end
                        popPage()
                    end),
                    row("CANCEL", nil, popPage),
                    row("COST: 1 TOKEN"),
                })
            end)
        end
        if #ids == 0 then rows[#rows + 1] = row("NO FAILED ROUTES") end
        rows[#rows + 1] = row("REVIVE POKEMON", "soon",
            function() info("RECOVERY PENDING", {
                "ARCHIVE SUPPORTED", "PC RECOVERY NOT READY",
                "NO TOKEN SPENT",
            }) end)
        return rows
    end

    local function openForgiveness()
        present("FORGIVENESS", forgivenessRows(), forgivenessRows)
    end

    -- Each playstyle has exactly two rows: its switch, then its own
    -- detail screen. The compact 240x160 menu stays navigable.
    local PLAYSTYLE_DETAILS = {
        shiny_nuzlocke = {
            title = "SHINY NUZLOCKE",
            lines = {
                "REQUIRES CORE NUZLOCKE",
                "ONLY SHINY WILDS CATCH",
                "NORMALS: ROUTE STAYS OPEN",
                "FIRST ELIGIBLE SHINY",
                "ONE PER AREA STILL APPLIES",
                "FAILED SHINY COUNTS*",
                "*IF FAILED ENC. IS ON",
                "DUPES & ROAMERS APPLY",
                "SHINY CLAUSE: NO BONUS",
                "ODDS IN CLAUSES > RATE",
                "OVERWORLD WILDS COUNT",
                "CAN COMBINE WITH HARDCORE",
                "CORE OFF: INACTIVE",
            },
        },
        hardcore_nuzlocke = {
            title = "HARDCORE NUZLOCKE",
            lines = {
                "REQUIRES CORE NUZLOCKE",
                "PERMADEATH FORCED ON",
                "ONE PER AREA FORCED",
                "FAILED ENC. FORCED ON",
                "WHITEOUT ENDS RUN",
                "BATTLE ITEMS: NO USE",
                "EXCEPT POKE BALLS",
                "FORCED SET BATTLE STYLE",
                "GYM/ELITE/CHAMPION CAPS",
                "EXP & CANDY CAPS APPLY",
                "HELD ITEMS STILL ALLOWED",
                "FIELD HEALING ALLOWED",
                "BASE SETTINGS PRESERVED",
                "CAN COMBINE WITH SHINY",
                "CORE OFF: INACTIVE",
            },
        },
    }

    local function playstyleRows()
        local rows = {}
        local styles = {
            { key = "shiny_nuzlocke", label = "SHINY NUZ" },
            { key = "hardcore_nuzlocke", label = "HARDCORE" },
        }
        for _, style in ipairs(styles) do
            local key, label = style.key, style.label
            local enabled = Playstyles.get(state(), key)
            rows[#rows + 1] = row(label .. ": " .. (enabled and "ON" or "OFF"),
                nil, function()
                    local updated = state()
                    local value = not Playstyles.get(updated, key)
                    local ok, reason = Playstyles.set(updated, key, value)
                    if not ok then
                        info("PLAYSTYLE UNAVAILABLE", { tostring(reason) })
                        return
                    end
                    api.setState(updated)
                    if api.notify then
                        if key == "shiny_nuzlocke" then
                            api.notify("PLAYSTYLE_CHANGED", value
                                and "Shiny Nuzlocke ON: only shinies may be "
                                    .. "caught; normals leave routes open."
                                or "Shiny Nuzlocke OFF: normal catch rules restored.",
                                false)
                        else
                            api.notify("PLAYSTYLE_CHANGED", value
                                and "Hardcore ON: SET, no battle items except "
                                    .. "Balls, strict catches/deaths, boss caps."
                                or "Hardcore OFF: original rule settings restored.",
                                false)
                        end
                    end
                    current().rows = playstyleRows()
                end)
            rows[#rows + 1] = row("  DETAILS: " .. label, nil, function()
                local details = PLAYSTYLE_DETAILS[key]
                info(details.title, details.lines)
            end)
        end
        return rows
    end

    local function clausesRows()
        local rows = {}
        for _, descriptor in ipairs(Clauses.descriptors()) do
            local d = descriptor
            if d.status == "soon" then
                rows[#rows + 1] = row(d.label, "soon", function()
                    disabledFeature(d.label, d.key)
                end)
            else
                local external = d.key == "shiny_rate_mode"
                    and ShinyRate.externalProvider(mod) or nil
                rows[#rows + 1] = row(d.label .. ": " ..
                    (external and "EXTERNAL" or Clauses.label(state(), d.key)),
                    nil, function()
                    if external then
                        info("SHINY PROVIDER", {
                            "EXTERNAL SHINY MOD",
                            "CONTROLS SHINY ODDS",
                            "NUZ WILL NOT OVERRIDE",
                        })
                        return
                    end
                    local currentState = state()
                    local value = Clauses.get(currentState, d.key)
                    local nextValue = (value + 1) % #d.options
                    local ok, reason = Clauses.set(currentState, d.key, nextValue)
                    if ok then
                        if api.onClauseChanged then api.onClauseChanged(currentState, d.key) end
                        api.setState(currentState)
                        current().rows = clausesRows()
                    elseif reason == "run_failed" then
                        return
                    else
                        info("RULE UNAVAILABLE", { tostring(reason) })
                    end
                end)
            end
        end
        rows[#rows + 1] = row("EGG HISTORY", nil, eggHistory)
        rows[#rows + 1] = row("REDEEM TOKEN", nil, openForgiveness)
        return rows
    end

    local function levelRows()
        local scope = Levels.get("level_cap_scope") or 0
        local hardcore = Playstyles.hardcoreActive(state(), Core)
        local edging = Levels.get("exp_edging") == true
        local cap, stage = Levels.cap()
        local banked, pending = 0, 0
        for _, mon in ipairs(Levels.currentParty()) do
            local amount = Levels.banked(mon)
            banked = banked + amount
            if amount > 0 then pending = pending + 1 end
        end
        return {
            row("CAP SCOPE: " .. (hardcore and "CHAMPION*" or ({
                "NONE", "GYMS", "ELITE FOUR", "CHAMPION", "POSTGAME"
            })[scope + 1]), nil, function()
                if hardcore then
                    info("HARDCORE LEVEL CAP", {
                        "CHAMPION SCOPE FORCED",
                        "ORIGINAL SCOPE SAVED",
                        "DISABLE HARDCORE TO EDIT",
                    })
                elseif Levels.set("level_cap_scope", (scope + 1) % 5) then
                    current().rows = levelRows()
                end
            end),
            row("EXP EDGING: " .. (edging and "ON" or "OFF"), nil,
                function()
                    if Levels.set("exp_edging", not edging) then
                        current().rows = levelRows()
                    end
                end),
            row("CURRENT CAP: " .. (cap and ("LV " .. cap) or "NONE")),
            row("STAGE: " .. (stage or "UNKNOWN")),
            row("PARTY BANK: " .. tostring(banked) .. " EXP"),
            row("BANKED MEMBERS: " .. tostring(pending)),
        }
    end

    local function seedEditor()
        if Randomizer.locked() then
            return info("SEED LOCKED", {
                "SEED IS FIXED FOR RUN",
                "START NEW RUN TO CHANGE",
                "REPLAY WITH SAME SEED",
            })
        end
        local digits = string.format("%08d",
            Randomizer.get("randomizer_seed") or 0)
        local function editorRows()
            local rows = { row("SEED: " .. digits) }
            for index = 1, 8 do
                local i = index
                rows[#rows + 1] = row("DIGIT " .. i .. ": "
                    .. digits:sub(i, i), nil, function()
                    local digit = (tonumber(digits:sub(i, i)) + 1) % 10
                    digits = digits:sub(1, i - 1) .. tostring(digit)
                        .. digits:sub(i + 1)
                    current().rows = editorRows()
                end)
            end
            rows[#rows + 1] = row("APPLY SEED", nil, function()
                local ok, reason = Randomizer.set("randomizer_seed",
                    tonumber(digits))
                if ok then popPage()
                else info("SEED ERROR", { tostring(reason) }) end
            end)
            rows[#rows + 1] = row("USE AUTO", nil, function()
                local ok, reason = Randomizer.set("randomizer_seed", 0)
                if ok then popPage()
                else info("SEED ERROR", { tostring(reason) }) end
            end)
            rows[#rows + 1] = row("CANCEL", nil, popPage)
            return rows
        end
        present("EDIT RNG SEED", editorRows(), editorRows)
    end

    local function randomError(reason)
        if reason == "locked_after_first_randomised_result" then
            return info("RNG LOCKED", {
                "RANDOMISER ALREADY USED",
                "KEEP THIS RUN SEED",
                "NEW SAVE TO RECONFIGURE",
            })
        end
        info("RNG ERROR", { tostring(reason or "Unknown error") })
    end

    local function randomRows()
        local config = Randomizer
        local rows = {}
        local function cycle(key, label, options)
            local value = config.get(key)
            rows[#rows + 1] = row(label .. ": "
                .. tostring(options[value + 1]), nil, function()
                local ok, reason = config.set(key, (value + 1) % #options)
                if ok then current().rows = randomRows()
                else randomError(reason) end
            end)
        end
        local function toggle(key, label)
            local on = config.get(key)
            rows[#rows + 1] = row(label .. ": "
                .. (on and "ON" or "OFF"), nil, function()
                local ok, reason = config.set(key, not on)
                if ok then current().rows = randomRows()
                else randomError(reason) end
            end)
        end
        cycle("randomizer_preset", "PRESET", {
            "CUSTOM", "CHAOS", "BALANCED" })
        toggle("random_encounter_tables", "RANDOM WILD")
        toggle("random_trainers", "RANDOM TRAINERS")
        toggle("random_starter", "RANDOM STARTERS")
        if config.get("random_starter") then
            cycle("random_starter_style", "STARTER STYLE",
                { "ANY", "BASE FORMS", "FINAL FORMS" })
            cycle("random_starter_trio_typing", "TRIO TYPING",
                { "ANY", "DISTINCT" })
            cycle("random_starter_rerolls", "STARTER REROLLS",
                { "OFF", "1", "3", "5", "UNLIMITED" })
            cycle("random_starter_balance", "STARTER BALANCE",
                { "CHAOS", "SIM BST" })
            if type(config.starterRerollStatus) == "function" then
                local st = config.starterRerollStatus()
                if st.limit ~= 0 then
                    local remaining = st.remaining == -1
                        and "UNLIMITED" or tostring(st.remaining)
                    rows[#rows + 1] = row("REROLLS LEFT: " .. remaining)
                    rows[#rows + 1] = row("REROLL STARTERS NOW", nil,
                        function()
                            local trio, reason = config.rerollStarters()
                            if not trio then
                                info("STARTER REROLL", {
                                    tostring(reason or "Unavailable") })
                                return
                            end
                            current().rows = randomRows()
                            info("NEW STARTER TRIO", {
                                "1: " .. Display.speciesName({species=trio[1]}),
                                "2: " .. Display.speciesName({species=trio[2]}),
                                "3: " .. Display.speciesName({species=trio[3]}),
                                "CHANGES SAVED FOR RIVAL",
                            })
                        end)
                end
            end
        end
        toggle("random_static_pokemon", "RANDOM STATIC")
        toggle("random_gift_pokemon", "RANDOM GIFTS")
        toggle("random_egg_gifts", "RANDOM EGGS")
        toggle("random_field_items", "RANDOM FIELD ITEMS")
        toggle("random_shops", "RANDOM SHOPS")
        toggle("random_tms", "RANDOM TMS")
        toggle("random_tm_locations", "RANDOM TM LOCATIONS")
        toggle("random_gift_items", "RANDOM GIFT ITEMS")
        toggle("random_learnsets", "RANDOM LEARNSETS")
        if config.get("random_learnsets") then
            cycle("random_learnset_generation", "LEARNSET GEN",
                { "ALL", "GEN 1", "GEN 2", "GEN 3" })
            cycle("random_learnset_stab", "LEARNSET STAB",
                { "ANY", "PREFER", "ONLY" })
        end
        toggle("random_evolutions", "RANDOM EVOS")
        if config.get("random_evolutions") then
            cycle("random_evolution_balance", "EVO BALANCE",
                { "CHAOS", "SIM BST" })
        end
        cycle("randomizer_info_policy", "RNG INFO",
            { "SHOW", "HIDE SEED" })
        cycle("random_tm_compatibility", "TM COMPAT", {
            "NATIVE", "RANDOM", "ALL" })
        if config.get("random_shops") then
            cycle("random_shop_balance", "SHOP BALANCE",
                { "CHAOS", "SIM VALUE" })
        end
        if config.get("random_field_items") then
            cycle("random_field_item_balance", "ITEM BALANCE",
                { "CHAOS", "SIM VALUE" })
            cycle("random_field_item_repetition", "ITEM VARIETY",
                { "NORMAL", "UNIQUE AREA" })
        end
        if config.get("random_static_pokemon") then
            cycle("random_static_balance", "STATIC BALANCE",
                { "CHAOS", "SIM BST" })
        end
        if config.get("random_gift_pokemon") or config.get("random_egg_gifts") then
            cycle("random_gift_balance", "GIFT BALANCE",
                { "CHAOS", "SIM BST" })
        end
        if config.get("random_encounter_tables") then
            cycle("random_encounter_balance", "WILD BALANCE",
                { "CHAOS", "SIM BST" })
            cycle("random_encounter_repetition", "WILD VARIETY",
                { "NORMAL", "UNIQUE AREA" })
            if config.get("random_encounter_repetition")==1 then
                cycle("random_encounter_diversity_strength",
                    "DIVERSITY", { "SPECIES", "PRIMARY TYPE", "BOTH TYPES" })
            end
        end
        if config.get("random_trainers") then
            cycle("random_trainer_balance", "TRAINER BALANCE",
                { "CHAOS", "SIM BST" })
            cycle("random_trainer_diversity", "TRAINER VARIETY",
                { "NORMAL", "UNIQUE TEAM" })
            cycle("random_trainer_theme", "TRAINER THEME",
                { "ANY TYPE", "LEAD TYPE" })
        end
        if config.get("random_encounter_tables")
            or config.get("random_trainers")
            or config.get("random_starter")
            or config.get("random_static_pokemon")
            or config.get("random_gift_pokemon")
            or config.get("random_egg_gifts")
            or config.get("random_field_items") then
            cycle("random_species_generation", "SPECIES POOL",
                { "ALL", "KANTO", "JOHTO", "HOENN", "SINNOH",
                  "UNOVA", "KALOS", "ALOLA", "GALAR", "PALDEA" })
            cycle("random_species_roster", "ROSTER",
                { "GEN 1-3", "NATIONAL DEX" })
            if config.get("random_species_roster")==1 then
                toggle("random_species_forms", "ALT FORMS")
            end
            if type(config.rosterInfo)=="function" then
                local status=config.rosterInfo()
                rows[#rows+1]=row("ELIGIBLE: "
                    ..tostring(status.total or 0),nil)
                if config.get("random_species_roster")==1 then
                    rows[#rows+1]=row(status.provider
                        and ("NEW SPECIES: "..tostring(status.extended or 0))
                        or "NAT DEX NOT DETECTED",nil)
                    if config.get("random_species_forms") then
                        rows[#rows+1]=row("ALT FORMS: "
                            ..tostring(status.forms or 0),nil)
                    end
                end
            end
        end
        local hideSeed=config.get("randomizer_info_policy")==1
            and config.locked()
        rows[#rows + 1] = row(hideSeed and "SEED: HIDDEN" or ("SEED: "
            .. ((config.get("randomizer_seed") or 0) == 0
                and "AUTO" or string.format("%08d",
                config.get("randomizer_seed")))), nil,
            hideSeed and nil or seedEditor)
        rows[#rows + 1] = row(hideSeed and "RUN SEED: HIDDEN"
            or ("RUN SEED: "
            .. ((config.seed() or 0) == 0 and "NOT ROLLED"
                or string.format("%08d", config.seed()))))
        rows[#rows + 1] = row("CONFIG: "
            .. (config.locked() and "LOCKED" or "EDITABLE"))
        -- Keep other legacy settings visible as non-interactive placeholders.
        for _, cat in ipairs(CATALOG) do
            if cat.title == "RANDOMIZER" then
                local supported = {
                    randomizer_preset=true, random_encounter_tables=true,
                    random_trainers=true, randomizer_seed=true,
                    random_encounter_balance=true, random_trainer_balance=true,
                    random_species_generation=true,
                    random_species_roster=true,random_species_forms=true,
                    random_trainer_diversity=true,
                    random_encounter_repetition=true,
                    random_starter=true, random_starter_balance=true,
                    random_static_pokemon=true, random_static_balance=true,
                    random_gift_pokemon=true, random_egg_gifts=true,
                    random_gift_balance=true,
                    random_field_items=true,
                    random_field_item_balance=true,
                    random_field_item_repetition=true,
                    random_shops=true, random_shop_balance=true,
                    random_tms=true, random_tm_compatibility=true,
                    random_starter_style=true,
                    random_starter_trio_typing=true,
                    random_starter_rerolls=true,
                    random_encounter_diversity_strength=true,
                    randomizer_info_policy=true,
                    random_trainer_theme=true,
                    random_learnsets=true,
                    random_learnset_generation=true,
                    random_learnset_stab=true,
                    random_evolutions=true,
                    random_evolution_balance=true,
                    random_tm_locations=true,
                    random_gift_items=true,
                }
                for _, def in ipairs(cat.rules) do
                    local key, label = def[1], def[2]
                    if not supported[key] then
                        rows[#rows + 1] = row(label, "soon", function()
                            disabledFeature(label, key)
                        end)
                    end
                end
            end
        end
        return rows
    end

    local function showPkmnBan()
        local currentPage=1
        local PER_PAGE=20
        local okDex,Pokemon=pcall(require,"src.core.game3.pokemon")
        local maxDex=386
        if okDex and type(Pokemon)=="table"
            and type(Pokemon.speciesFromNational)=="function" then
            local ok,found=pcall(Pokemon.speciesFromNational,1025)
            if ok and tonumber(found) then maxDex=1025 end
        end
        local MAX_PAGE=math.ceil(maxDex/PER_PAGE)
        local function buildRows()
            local saved=state()
            local rows={}
            rows[#rows+1]=row("BANNED: "..CatchRules.banCount(saved)
                .." / "..maxDex,nil)
            rows[#rows+1]=row("< PREV PAGE",nil,function()
                currentPage=math.max(1,currentPage-1)
                local p=current()
                p.rows=buildRows()
                p.index=2
                p.scroll=0
            end)
            rows[#rows+1]=row(string.format("NEXT PAGE > %02d/%02d",
                currentPage,MAX_PAGE),nil,function()
                currentPage=math.min(MAX_PAGE,currentPage+1)
                local p=current()
                p.rows=buildRows()
                p.index=3
                p.scroll=0
            end)
            local ok,Pokemon=pcall(require,"src.core.game3.pokemon")
            for nat=(currentPage-1)*PER_PAGE+1,
                math.min(maxDex,currentPage*PER_PAGE) do
                local speciesName="UNKNOWN"
                if ok and type(Pokemon)=="table"
                    and type(Pokemon.speciesFromNational)=="function"
                    and type(Pokemon.name)=="function" then
                    local success,id=pcall(Pokemon.speciesFromNational,nat)
                    if success and tonumber(id) then
                        local named,name=pcall(Pokemon.name,id)
                        if named and type(name)=="string" then
                            speciesName=name
                        end
                    end
                end
                local id=nat
                local banned=CatchRules.isBannedNational(saved,id)
                rows[#rows+1]=row(string.format("#%03d %s: %s",
                    id,speciesName,banned and "BAN" or "OK"),nil,function()
                    local changed=state()
                    local accepted,reason=CatchRules.toggleNational(changed,id)
                    if not accepted then
                        info("PKMN BAN", {tostring(reason)})
                        return
                    end
                    api.setState(changed)
                    current().rows=buildRows()
                end)
            end
            return rows
        end
        present("PKMN BAN",buildRows(),buildRows)
    end

    local function catchRuleRows(category)
        local rows = {}
        local s = state()
        for _, entry in ipairs(category.rules) do
            local key, label = entry[1], entry[2]
            local value = CatchRules.get(s, key)
            if (key=="alphabetlocke_letter"
                and CatchRules.get(s,"alphabetlocke_mode")~=2)
                or (key=="colorlocke_color"
                and CatchRules.get(s,"colorlocke_mode")~=2) then
                -- Hide selectors unless their mode is CHOOSE.
            elseif key=="pkmn_ban" then
                rows[#rows+1]=row("PKMN BAN: "..CatchRules.label(s,key),
                    nil,showPkmnBan)
            elseif value == nil then
                rows[#rows+1] = row(label, "soon", function()
                    disabledFeature(label, key)
                end)
            else
                local caption=CatchRules.label(s,key)
                rows[#rows+1] = row(label .. ": " .. caption, nil, function()
                    local saved = state()
                    local nextValue=CatchRules.next(saved,key)
                    local ok, reason = CatchRules.set(saved, key, nextValue)
                    if not ok then
                        info("CATCH RULE UNAVAILABLE", {tostring(reason)})
                        return
                    end
                    api.setState(saved)
                    current().rows = catchRuleRows(category)
                    if current().index>#current().rows then
                        current().index=#current().rows
                    end
                end)
            end
        end
        rows[#rows+1] = row("  DETAILS: CATCH BANS", nil, function()
            info("CATCH RULES HELP", {
                "CORE NUZLOCKE: REQUIRED",
                "BANNED MONS CANNOT CATCH",
                "BANNED MONS DO NOT SPEND",
                "THE AREA ENCOUNTER SLOT",
                "LEGENDARY/MYTHICAL SPLIT",
                "PSEUDOS: WHOLE EVO LINE",
                "NO STATIC: SCRIPTED WILD",
                "ROAMERS ARE NOT STATIC",
                "NO FISHING: BLOCK ROD USE",
                "TOWN: CITY/TOWN MAPS",
                "TOWN OFF: NO CATCHES",
                "PKMN BAN: DEX PICKER",
                "BAN INDIVIDUAL SPECIES",
                "NATIONAL 001-386",
                "COLORLOCKE: SPECIES",
                "NOT SHINY/SPRITE COLOR",
                "RANDOM: SAVED PER RUN",
                "COLOR: CHOOSE 1 OF 10",
                "ALPHABET: FIRST LETTER",
                "CHOOSE: PICK A-Z",
                "GLITCH OFF: BLOCK BAD ID",
                "GIFT OFF: OPTIONAL DENIED",
                "TRADES OFF: NPC DENIED",
                "STARTERS: NEVER BLOCK",
                "GIFT/TRADE: AREA/BONUS",
                "AREA: SPENDS MAP SLOT",
                "BONUS: KEEPS MAP SLOT",
                "SPECIES BANS APPLY",
                "MAX BST: SIX BASE STATS",
                "BST > LIMIT IS BANNED",
                "BST OFF: NO STAT LIMIT",
                "UNKNOWN BST: CATCH BLOCK",
                "NO SHINY CLAUSE BYPASS",
                "NATIVE CATCH FLOW KEPT",
                "RANDOM WILDS APPLY",
                "UNTAMED WILDS APPLY",
                "UNTAMED USES WILD RULES",
            })
        end)
        return rows
    end

    local function battleClauseRows(category)
        local rows={}
        for _,entry in ipairs(category.rules) do
            local key,label=entry[1],entry[2]
            local value=BattleClauses.get(state(),key)
            if value==nil then
                rows[#rows+1]=row(label,"soon",function()
                    disabledFeature(label,key)
                end)
            else
                rows[#rows+1]=row(label..": "..
                    BattleClauses.label(state(),key),nil,function()
                    local saved=state()
                    local nextValue=BattleClauses.next(saved,key)
                    local ok,reason=BattleClauses.set(saved,key,nextValue)
                    if not ok then
                        info("BATTLE RULE UNAVAILABLE",{tostring(reason)})
                        return
                    end
                    api.setState(saved)
                    current().rows=battleClauseRows(category)
                end)
            end
        end
        rows[#rows+1]=row("  DETAILS: BATTLE",nil,function()
            info("BATTLE CLAUSE HELP",{
                "CORE NUZLOCKE REQUIRED",
                "OFF: NORMAL BATTLE",
                "SELF: YOUR MOVES",
                "ENEMY: FOE MOVES",
                "ALL: BOTH SIDES",
                "FLINCH: NO FLINCH",
                "TRAP: NO PARTIAL TRAP",
                "SETUP: NO STAT BOOSTS",
                "EVASION: NO EVA BOOST",
                "ACCURACY: NO ACC DROPS",
                "OTHER: NO OTHER DROPS",
                "DAMAGE STILL APPLIES",
                "OHKO: ON BLOCKS BOTH SIDES",
                "ITEM/ABILITY STAT FX",
                "NOT BLOCKED BY SCOPE",
            })
        end)
        return rows
    end

    local function statusBanRows(category)
        local rows={}
        local saved=state()
        local hideChildren=StatusBans.childrenHidden(saved)
        for _,entry in ipairs(category.rules) do
            local key,label=entry[1],entry[2]
            local currentValue=StatusBans.get(saved,key)
            if currentValue==nil then
                rows[#rows+1]=row(label,"soon",function()
                    disabledFeature(label,key)
                end)
            elseif not (hideChildren and key~="status_move_scope"
                and key~="sleep_clause") then
                rows[#rows+1]=row(label..": "..
                    StatusBans.label(saved,key),nil,function()
                    local nextState=state()
                    local value=StatusBans.next(nextState,key)
                    local ok,reason=StatusBans.set(nextState,key,value)
                    if not ok then
                        info("STATUS BAN UNAVAILABLE",{tostring(reason)})
                        return
                    end
                    api.setState(nextState)
                    current().rows=statusBanRows(category)
                    if current().index>#current().rows then
                        current().index=#current().rows
                    end
                end)
            end
        end
        rows[#rows+1]=row("  DETAILS: STATUS",nil,function()
            info("STATUS BANS HELP",{
                "CORE NUZLOCKE REQUIRED",
                "OFF: NO BAN",
                "SELF: CAUSED BY YOU",
                "ENEMY: CAUSED BY FOE",
                "ALL: BOTH SIDES",
                "PARENT SYNCS ALL SIX",
                "PARENT ON HIDES CHILDREN",
                "PARENT OFF CLEARS SIX",
                "BANS BLOCK STATUS ONLY",
                "DAMAGE IS UNAFFECTED",
                "PARALYSIS / CONFUSION",
                "SLEEP / POISON / TOXIC",
                "BURN / FREEZE",
                "SELF REST: ALLOWED",
                "YAWN: BLOCKS DROWSY",
                "SLEEP CLAUSE: ON/OFF",
                "ONE INFLICTED SLEEP",
                "PER OPPOSING PARTY",
                "SWITCHED MONS COUNT",
            })
        end)
        return rows
    end

    local function variantRows(category)
        local rows={}
        local saved=state()
        local mode=Variants.mode(saved)
        local drafting=Variants.get(saved,"type_lock_draft")
        local progress,target=Variants.draftProgress(saved)
        for _,entry in ipairs(category.rules) do
            local key,label=entry[1],entry[2]
            local lane=tonumber(key:match("^type_lock_") and
                ({type_lock_primary=1,type_lock_secondary=2,
                  type_lock_tertiary=3,type_lock_quaternary=4,
                  type_lock_quinary=5,type_lock_senary=6})[key])
            if lane and lane>mode then
                -- Only show type selectors for active lanes.
                        elseif lane and drafting then
                -- Catch Draft owns these slots: never let a manual click
                -- overwrite types learned from successful wild catches.
                rows[#rows+1]=row(label..": "
                    ..Variants.label(saved,key))
            else
                local value=Variants.get(saved,key)
                if value==nil then
                    rows[#rows+1]=row(label,"soon",function()
                        disabledFeature(label,key)
                    end)
                else
                    rows[#rows+1]=row(label..": "
                        ..Variants.label(saved,key),nil,function()
                        local nextState=state()
                        local nextValue=Variants.next(nextState,key)
                        local ok,why=Variants.set(nextState,key,nextValue)
                        if not ok then
                            info("VARIANT UNAVAILABLE",{tostring(why)})
                            return
                        end
                        api.setState(nextState)
                        current().rows=variantRows(category)
                        current().index=math.min(current().index,
                            #current().rows)
                    end)
                end
            end
        end
        if drafting and mode>0 then
            rows[#rows+1]=row("DRAFT: "..progress.."/"..target
                .." TYPES",nil,function()
                info("CATCH DRAFT",{
                    "SUCCESSFUL WILD CATCHES",
                    "EACH ADDS ONE NEW TYPE",
                    "DUPLICATE TYPE: NO SLOT",
                    "GIFTS/TRADES CANNOT DRAFT",
                    "WILD CATCHES FREE UNTIL",
                    "ALL TYPES ARE COLLECTED",
                    "PROGRESS: "..progress.."/"..target,
                })
            end)
        end
        rows[#rows+1]=row("  DETAILS: TYPE LOCKE",nil,function()
            info("TYPE LOCKE HELP",{
                "CORE NUZLOCKE: REQUIRED",
                "OFF: ALL TYPES ALLOWED",
                "MONO..HEXA: 1..6 TYPES",
                "SELECT A TYPE PER LANE",
                "RANDOM: FIXED PER SAVE",
                "CATCH DRAFT: OPTIONAL",
                "DRAFT USES SUCCESSFUL WILDS",
                "ONE NEW TYPE PER CATCH",
                "DUAL: PREFER UNUSED TYPE",
                "SAME TYPES: NO NEW LANE",
                "WILDS FREE UNTIL FULL",
                "GIFTS/TRADES USE DRAFT",
                "NO WILD TYPE: NO GIFT",
                "DRAFT TYPES SAVED",
                "TYPE SLOTS READ ONLY",
                "RANDOM LANES UNIQUE",
                "MATCH EITHER POKEMON TYPE",
                "OFF-TYPE CANNOT CATCH",
                "OFF-TYPE SPENDS NO SLOT",
                "SHINY CANNOT BYPASS",
                "GIFT AND TRADE CHECKED",
                "FIRST STARTER EXEMPT",
                "UNLISTED TYPES: ALLOWED",
                "CHANGING MODE RESETS DRAFT",
            })
        end)
        return rows
    end

    local function battleItemRows(category)
        local out={}
        local saved=state()
        for _,def in ipairs(category.rules) do
            local key,label=def[1],def[2]
            local value=BattleItemRules.get(saved,key)
            if value==nil then
                out[#out+1]=row(label,"soon",function()
                    disabledFeature(label,key)
                end)
            else
                out[#out+1]=row(label..": "
                    ..BattleItemRules.label(saved,key),nil,function()
                    local updated=state()
                    local wanted=BattleItemRules.next(updated,key)
                    local ok,why=BattleItemRules.set(updated,key,wanted)
                    if not ok then
                        info("BATTLE ITEM RULE",{tostring(why)})
                        return
                    end
                    api.setState(updated)
                    current().rows=battleItemRows(category)
                end)
            end
        end
        out[#out+1]=row("  DETAILS: BATTLE ITEMS",nil,function()
            info("BATTLE ITEMS HELP",{
                "CORE NUZLOCKE: REQUIRED",
                "NO HEAL: HP / STATUS",
                "REVIVES AND HEAL BERRIES",
                "NO X: STAT BOOST ITEMS",
                "DIRE HIT / GUARD SPEC",
                "NO CATCH: ALL BALLS",
                "BALL PER ENC: OFF OR",
                "1 / 2 / 3 / 5 / 10",
                "COUNTS LEGAL BALL THROWS",
                "RESETS EACH WILD BATTLE",
                "ILLEGAL BALLS: NO COUNT",
                "DENIED USE: NO ITEM LOST",
                "DENIED USE: NO TURN",
                "GIFTS / TRADES UNAFFECTED",
                "HARDCORE: ONLY BALLS",
                "NUZ OFF: NATIVE ITEMS",
            })
        end)
        return out
    end

    local function fieldItemRows(category)
        local rows={}
        local currentState=state()
        for _,definition in ipairs(category.rules) do
            local key,label=definition[1],definition[2]
            local value=FieldRules.get(currentState,key)
            if value==nil then
                rows[#rows+1]=row(label,"soon",function()
                    disabledFeature(label,key)
                end)
            else
                rows[#rows+1]=row(label..": "
                    ..FieldRules.label(currentState,key),nil,function()
                    local saved=state()
                    local desired=FieldRules.next(saved,key)
                    local ok,why=FieldRules.set(saved,key,desired)
                    if not ok then
                        info("FIELD ITEM RULE",{tostring(why)})
                        return
                    end
                    api.setState(saved)
                    current().rows=fieldItemRows(category)
                end)
            end
        end
        rows[#rows+1]=row("  DETAILS: FIELD ITEMS",nil,function()
            info("FIELD ITEMS HELP",{
                "CORE NUZLOCKE REQUIRED",
                "REPELS: BLOCK ALL THREE",
                "ESCAPE ROPE: BLOCK USE",
                "TRAVEL: NORMAL / NO FLY",
                "NO FLY + NO TELEPORT",
                "DIG AND STORY TRAVEL OK",
                "FIELD HEAL: HP STATUS",
                "AND REVIVAL MEDICINES",
                "PP ITEMS: FIELD + BATTLE",
                "ETHERS / ELIXIRS /",
                "LEPPA / PP UP / PP MAX",
                "NO TMS: HMS STILL OK",
                "NO RARE CANDY: BLOCK",
                "PARTY AND BAG USE",
                "NO ITEMS CONSUMED",
                "BATTLE HEAL SEPARATE",
                "FIELD MOVE TRAVEL ONLY",
                "NO FISH/STORY CHANGE",
            })
        end)
        return rows
    end

    local function serviceRows(category)
        local rows={}
        for _,definition in ipairs(category.rules) do
            local key,label=definition[1],definition[2]
            local saved=state()
            local value=Services.get(saved,key)
            if value==nil then
                rows[#rows+1]=row(label,"soon",function()
                    disabledFeature(label,key)
                end)
            else
                rows[#rows+1]=row(label..": "..Services.label(saved,key),
                    nil,function()
                    local currentState=state()
                    local desired=Services.next(currentState,key)
                    local ok,why=Services.set(currentState,key,desired)
                    if not ok then
                        info("SERVICE RULE",{tostring(why)})
                        return
                    end
                    api.setState(currentState)
                    current().rows=serviceRows(category)
                end)
            end
        end
        rows[#rows+1]=row("  DETAILS: SERVICES",nil,function()
            info("SERVICES HELP",{
                "CORE NUZLOCKE REQUIRED",
                "CENTER: NO NURSE HEALS",
                "MOM: NO HOME HEALS",
                "STORY HEALS UNAFFECTED",
                "DAY CARE: NO DEPOSITS",
                "EXISTING MONS: COLLECT",
                "EXISTING EGGS: ALLOWED",
                "SHOPS: NORMAL / NO BUY",
                "NO SELL / CLOSED",
                "DECOR SHOPS INCLUDED",
                "GAMBLING: NO SLOTS",
                "OR ROULETTE",
                "TRAINER PRIZES: 0%,",
                "50%, 100%, 200%, 300%",
                "SCRIPTED CASH UNCHANGED",
                "NO ITEMS/MONEY DELETED",
                "NUZ OFF: NATIVE RULES",
            })
        end)
        return rows
    end

    local function pokemonStatRows(category)
        local rows={}
        for _,definition in ipairs(category.rules) do
            local key,label=definition[1],definition[2]
            local saved=state()
            local value=Stats.get(saved,key)
            if value==nil then
                rows[#rows+1]=row(label,"soon",function()
                    disabledFeature(label,key)
                end)
            else
                -- Keep the existing catalogue keys, display Gen 3 EV names.
                local title=label
                if key=="player_start_stat_exp" then
                    title="Player Starting EVs"
                elseif key=="wild_start_stat_exp" then
                    title="Wild Starting EVs"
                elseif key=="trainer_start_stat_exp" then
                    title="Trainer Starting EVs"
                elseif key=="no_player_stat_exp_gain" then
                    title="No EV Gain"
                end
                rows[#rows+1]=row(title..": "..Stats.label(saved,key),
                    nil,function()
                    local currentState=state()
                    local desired=Stats.next(currentState,key)
                    local ok,why=Stats.set(currentState,key,desired)
                    if not ok then
                        info("POKEMON STATS",{tostring(why)})
                        return
                    end
                    api.setState(currentState)
                    current().rows=pokemonStatRows(category)
                end)
            end
        end
        rows[#rows+1]=row("  DETAILS: POKEMON STATS",nil,function()
            info("POKEMON STATS HELP",{
                "CORE NUZLOCKE REQUIRED",
                "GEN 3: EV NOT STAT EXP",
                "START EVS: 0 / 16 / 32",
                "48 / 64 / 85 EACH STAT",
                "EV CAP: 510 TOTAL",
                "85 EACH = FULL 510",
                "PLAYER: NEW ACQUISITIONS",
                "WILD: NEW ENCOUNTERS",
                "TRAINER: NEW FOES",
                "DEFAULT 0: NATIVE EVS",
                "NO EV GAIN: NO NEW",
                "BATTLE / VITAMIN EVS",
                "EXISTING EVS ARE KEPT",
                "PERFECT IVS: 31 EACH",
                "HP/ATK/DEF/SPE/SPA/SPD",
                "PERFECT PLAYER: NEW",
                "PERFECT WILD / TRAINER",
                "LINK BATTLES EXCLUDED",
                "EXISTING MONS UNCHANGED",
                "NUZ OFF: NATIVE STATS",
            })
        end)
        return rows
    end

    local function areaSplitRows(category)
        local rows={}
        local currentState=state()
        for _,definition in ipairs(AreaSplits.descriptors()) do
            local key,label=definition.key,definition.label
            rows[#rows+1]=row(label..": "..
                AreaSplits.label(currentState,key),nil,function()
                local saved=state()
                local desired=AreaSplits.next(saved,key)
                local ok,reason=AreaSplits.set(saved,key,desired)
                if not ok then
                    info("AREA SPLITS",{tostring(reason)})
                    return
                end
                api.setState(saved)
                current().rows=areaSplitRows(category)
            end)
        end
        -- Legacy Gen 2-specific fields are deliberately not actionable
        -- in Gen 3. Keep them visible as an explicit edition note.
        rows[#rows+1]=row("Time Split (Gen 2 only)","soon",function()
            info("GEN 2 ONLY",{"MORNING / DAY / NIGHT",
                "NOT A GEN 3 RULE"})
        end)
        rows[#rows+1]=row("Headbutt (Gen 2 only)","soon",function()
            info("GEN 2 ONLY",{"HEADBUTT ENCOUNTERS",
                "NOT A GEN 3 RULE"})
        end)
        rows[#rows+1]=row("  DETAILS: AREA SPLITS",nil,function()
            local currentKey=api.currentEncounterArea
                and api.currentEncounterArea(state()) or nil
            info("AREA SPLITS HELP",{
                "CORE NUZLOCKE REQUIRED",
                "NATIVE MAP = OLD BEHAVIOUR",
                "ONE/LOCATION: WHOLE CAVE",
                "PER FLOOR: 1F / B1F...",
                "KANTO / SEVII / HOENN",
                "OVERRIDES: FOLLOW / ONE",
                "/ FLOOR FOR EACH REGION",
                "MT MOON: ITS OWN CHOICE",
                "SAFARI: WHOLE OR AREAS",
                "UNTIL CATCH: SAFARI",
                "FLEES DO NOT SPEND",
                "ROUTES 2/10: NORTH/SOUTH",
                "ROUTE 20: WEST / EAST",
                "ROUTE 21: GROUP OR SPLIT",
                "ROUTE MIDLINE NEEDS XY",
                "OLD CLAIMS STILL COUNT",
                "NO DATA / NO SPLIT",
                "CURRENT: "..(currentKey
                    and AreaSplits.name(currentKey,Display.areaName)
                    or "UNKNOWN"),
            })
        end)
        return rows
    end

    local function setupRows(category)
        local rows={}
        local saved=state()
        for _,definition in ipairs(Setup.descriptors()) do
            local key,label=definition.key,definition.label
            rows[#rows+1]=row(label..": "..Setup.label(saved,key),
                nil,function()
                local updated=state()
                local desired=Setup.next(updated,key)
                local ok,why=Setup.set(updated,key,desired)
                if not ok then
                    info("QOL SETUP",{tostring(why)})
                    return
                end
                api.setState(updated)
                current().rows=setupRows(category)
            end)
        end
        rows[#rows+1]=row("  DETAILS: QOL SETUP",nil,function()
            local savedNow=state()
            info("QOL SETUP HELP",{
                "FUTURE NEW GAMES ONLY",
                "CURRENT SAVE UNCHANGED",
                "SUPPLIES GO TO PC",
                "BALLS: "..Setup.label(savedNow,
                    "starting_pokeballs"),
                "RARE CANDY: "..Setup.label(savedNow,
                    "starting_rare_candies"),
                "MONEY: "..Setup.label(savedNow,"starting_money"),
                "NATIVE MONEY: UNCHANGED",
                "HEAL LOADOUT: 10 EACH",
                "POTION / SUPER / MAX",
                "ANTIDOTE / BURN HEAL",
                "ICE HEAL / AWAKENING",
                "PARLYZ / FULL HEAL",
                "VITAMINS: 10 EACH",
                "HP UP / PROTEIN",
                "IRON / CARBOS",
                "CALCIUM / ZINC",
                "STARTER/FLAGS NATIVE",
                "NOT BACKFILLED",
                "PC KIT ATOMIC",
                "NO ITEMS DELETED",
                "NEW GAME HOOK ONLY",
            })
        end)
        return rows
    end

    local function qolRows(category)
        local rows={}
        local saved=state()
        for _,definition in ipairs(Qol.descriptors()) do
            local key,label=definition.key,definition.label
            if definition.status~="working" then
                local note=definition.detail or "Not available in Gen 3."
                rows[#rows+1]=row(label, "soon",function()
                    info("QOL NOT AVAILABLE",{label,note,
                        "NO GEN 3 SETTING SAVED"})
                end)
            else
                rows[#rows+1]=row(label..": "..Qol.label(saved,key),
                    nil,function()
                    local updated=state()
                    local desired=Qol.next(updated,key)
                    local ok,why=Qol.set(updated,key,desired)
                    if not ok then
                        info("QOL",{tostring(why)})
                        return
                    end
                    api.setState(updated)
                    current().rows=qolRows(category)
                end)
            end
        end
        rows[#rows+1]=row("  DETAILS: QOL",nil,function()
            info("QOL HELP",{
                "GEN 3 QOL",
                "INSTANT: FIELD/BATTLE",
                "INTRO + RSE PRINTERS",
                "PAGE/CHOICE WAITS KEPT",
                "RUN / SURF: OFF",
                "HOLD B: 2X STEP SPEED",
                "ALWAYS: 2X STEP SPEED",
                "NO BIKE OR CUTSCENES",
                "UNLIMITED BAG SPACE:",
                "ITEM & BALL POCKETS",
                "NATIVE 99-STACK KEPT",
                "KEY/TM/BERRY NATIVE",
                "TRADE EVOLUTIONS:",
                "LEVEL 40+ INSTEAD",
                "HELD ITEM STILL NEEDED",
                "EVERSTONE RESPECTED",
                "NO EVO RULE OVERRIDES",
                "QOL WORKS WITH NUZ OFF",
            })
        end)
        return rows
    end

    local function hardcoreRows(category)
        local rows={}
        local saved=state()
        for _,d in ipairs(Hardcore.descriptors()) do
            local key=d.key
            rows[#rows+1]=row(d.label..": "..Hardcore.label(saved,key),
                nil,function()
                local updated=state()
                local ok,reason=Hardcore.set(updated,key,
                    Hardcore.next(updated,key))
                if not ok then
                    info("HARDCORE RULES",{tostring(reason)})
                    return
                end
                api.setState(updated)
                current().rows=hardcoreRows(category)
            end)
        end
        rows[#rows+1]=row("  DETAILS: HARDCORE",nil,function()
            local entry=api.dungeonEntry and api.dungeonEntry()
            info("HARDCORE RULES HELP",{
                "CORE NUZLOCKE REQUIRED",
                "NO ESCAPE: RUN FAILS",
                "RUN STILL SPENDS TURN",
                "TUTORIAL / SAFARI SAFE",
                "WHITEOUT: PC RESCUE",
                "IF A LIVING MON EXISTS",
                "NO SURVIVOR = RUN END",
                "GYM LOCK-IN: NO EXIT",
                "BEFORE BADGE EARNED",
                "CLEARED GYMS EXEMPT",
                "DUNGEON LOCK-IN:",
                "SEALS ENTRANCE USED",
                "KNOWN MULTI-EXIT ONLY",
                "OTHER EXITS ALLOWED",
                "ESCAPE ROPE / DIG",
                "TELEPORT / FLY BLOCK",
                "MISSING DATA FAILS OPEN",
                "HELD ITEMS: NO GIVE",
                "EXISTING ITEMS KEPT",
                "PLAYER EFFECTS OFF",
                "TRAINER ITEMS NORMAL",
                "ENTRY: "..(entry and entry.group or "NONE"),
            })
        end)
        return rows
    end

    local function difficultyRows(category)
        local saved=state()
        local profile=Difficulty.profile(saved)
        local rows={
            row("Game Difficulty: "..Difficulty.label(saved,
                "difficulty_profile"),nil,function()
                local updated=state()
                local desired=Difficulty.next(updated,"difficulty_profile")
                local ok,reason=Difficulty.set(updated,
                    "difficulty_profile",desired)
                if not ok then
                    info("GAME DIFFICULTY",{tostring(reason)})
                    return
                end
                api.setState(updated)
                current().rows=difficultyRows(category)
            end),
            row("  DETAILS: DIFFICULTY",nil,function()
                local p=Difficulty.profile(state())
                info("GAME DIFFICULTY HELP",{
                    "PROFILE: "..p.name,
                    "ID: "..tostring(p.id).."/15",
                    p.id==0 and "NATIVE TRAINERS" or
                        "TRAINER LEVEL BOOST",
                    "NORMAL: +"..tostring(p.normal),
                    "BOSSES: +"..tostring(p.boss),
                    "MINIMUM IV: "..tostring(p.iv),
                    "EVS: "..tostring(p.ev).."/STAT",
                    "AI TIER: "..tostring(p.ai),
                    p.bossOnly and "GYMS / RIVALS / ELITE" or
                        "NORMAL + BOSS TEAMS",
                    "WILD BATTLES UNCHANGED",
                    "LINK / FACILITY SAFE",
                    "NO SPECIES REPLACED",
                    "CURATED MOVES KEPT",
                    "OTHER TRAINER MODS",
                    "MAY NEED COMPAT TEST",
                    "WORKS WITH NUZ OFF",
                    "EXPLICIT STAT RULES",
                    "OVERRIDE IV/EV FLOORS",
                    "GYM TEAM SIZE USES",
                    "COMPOSED TEAM COUNT",
                    "ONLY FUTURE BATTLES",
                })
            end),
        }
        return rows
    end

    local function runPartyRows(category)
        local rows={}
        local currentState=state()
        for _,definition in ipairs(RunParty.descriptors()) do
            local key,label=definition.key,definition.label
            rows[#rows+1]=row(label..": "..
                RunParty.label(currentState,key),nil,function()
                local saved=state()
                local desired=RunParty.next(saved,key)
                local ok,reason=RunParty.set(saved,key,desired)
                if not ok then
                    info("RUN / PARTY",{tostring(reason)})
                    return
                end
                api.setState(saved)
                current().rows=runPartyRows(category)
            end)
        end
        rows[#rows+1]=row("  DETAILS: RUN / PARTY",nil,function()
            info("RUN / PARTY HELP",{
                "CORE NUZLOCKE REQUIRED",
                "GYM TEAM SIZE:",
                "MATCH LIVE LEADER TEAM",
                "FEWER MONS ARE ALLOWED",
                "OTHER TRAINERS EXEMPT",
                "PARTY SIZE: 1 TO 6",
                "6 = NATIVE DEFAULT",
                "NO EXTRA ACTIVE MONS",
                "CATCH / GIFT REFUSED",
                "PC WITHDRAWAL BLOCKED",
                "SWAPS / DEPOSITS OK",
                "OLD PARTY UNCHANGED",
                "EVOLUTION LIMITS:",
                "NORMAL: VANILLA",
                "NO FINAL: ONLY TARGETS",
                "WITH FURTHER EVOS",
                "NO EVOLUTION: NONE",
                "LEVEL / ITEM / TRADE",
                "UNKNOWN MOD EVOS: SAFE",
                "NO STORY PARTIES EDITED",
                "NUZ OFF: NATIVE RULES",
            })
        end)
        return rows
    end

    local function categoryRows(category)
        if category.title == "SERVICES & ECONOMY" then return serviceRows(category) end
        if category.title == "POKEMON STATS" then return pokemonStatRows(category) end
        if category.title == "AREA SPLITS" then return areaSplitRows(category) end
        if category.title == "RUN / PARTY" then return runPartyRows(category) end
        if category.title == "GAME DIFFICULTY" then return difficultyRows(category) end
        if category.title == "HARDCORE" then return hardcoreRows(category) end
        if category.title == "QOL" then return qolRows(category) end
        if category.title == "QOL SETUP ONLY" then return setupRows(category) end
        if category.title == "FIELD ITEMS" then return fieldItemRows(category) end
        if category.title == "BATTLE ITEMS" then return battleItemRows(category) end
        if category.title == "VARIANTS" then return variantRows(category) end
        if category.title == "STATUS BANS" then return statusBanRows(category) end
        if category.title == "BATTLE CLAUSES" then
            return battleClauseRows(category)
        end
        if category.title == "CATCH RULES" then return catchRuleRows(category) end
        if category.title == "CORE" then return coreRows() end
        if category.title == "CLAUSES" then return clausesRows() end
        if category.title == "PLAYSTYLES" then return playstyleRows() end
        if category.title == "LEVELS" then return levelRows() end
        if category.title == "RANDOMIZER" then return randomRows() end
        local rows = {}
        for _, rule in ipairs(category.rules) do
            local key, label = rule[1], rule[2]
            -- Not yet ported: do not allow touching the Gen 1/2 rule store.
            rows[#rows + 1] = row(label, "soon", function()
                disabledFeature(label, key)
            end)
        end
        return rows
    end

    -- The same category opener is shared by ordinary and advanced groups.
    -- Nested [Soon] entries remain read-only; all working categories retain
    -- their original refresh callbacks.
    local function categoryActive(c)
        return c.title == "CORE" or c.title == "CLAUSES"
            or c.title == "CATCH RULES"
            or c.title == "BATTLE CLAUSES"
            or c.title == "STATUS BANS"
            or c.title == "VARIANTS"
            or c.title == "BATTLE ITEMS"
            or c.title == "FIELD ITEMS"
            or c.title == "SERVICES & ECONOMY"
            or c.title == "POKEMON STATS"
            or c.title == "AREA SPLITS"
            or c.title == "RUN / PARTY"
            or c.title == "GAME DIFFICULTY"
            or c.title == "HARDCORE"
            or c.title == "QOL"
            or c.title == "QOL SETUP ONLY"
            or c.title == "PLAYSTYLES"
            or c.title == "LEVELS" or c.title == "RANDOMIZER"
    end

    local function categoryLink(c)
        local active = categoryActive(c)
        return row(c.title, active and "working" or "soon", function()
            present(c.title, categoryRows(c),
                active and function() return categoryRows(c) end or nil)
        end)
    end

    local function showAdvancedRules()
        local rows = {}
        for _, c in ipairs(CATALOG) do
            if ADVANCED_RULES[c.title] then
                rows[#rows + 1] = categoryLink(c)
            end
        end
        present("ADVANCED RULES", rows)
    end

    local function showRules()
        local rows = {}
        for _, c in ipairs(CATALOG) do
            if not ADVANCED_RULES[c.title] then
                rows[#rows + 1] = categoryLink(c)
                if c.title == "PLAYSTYLES" then
                    rows[#rows + 1] = row("ADVANCED RULES", nil,
                        showAdvancedRules)
                end
            end
        end
        present("NUZ RULES", rows)
    end

    -- Nuz Dev is intentionally independent from gameplay rules. It edits
    -- *Nuzlocke records only*, not party/PC Pokémon, and leaves an audit trail.
    local function confirmDev(label, description, apply)
        present("CONFIRM EDIT", {
            row("YES: " .. label, nil, function()
                local ok, reason = apply()
                popPage()
                if not ok then
                    info("EDIT BLOCKED", {
                        tostring(reason or "UNKNOWN ERROR"),
                        "NO DATA CHANGED",
                    })
                end
            end),
            row("CANCEL", nil, popPage),
            row(description or "TEST SAVE ONLY"),
            row("SAVE FLAGGED AS DEV"),
        })
    end

    local function showDevInspector()
        local d = Dev.inspect()
        info("NUZ DEV STATUS", {
            "AREA: " .. tostring(d.map or "UNKNOWN"),
            "PARTY: " .. tostring(d.party),
            "USED: " .. tostring(d.areasSpent),
            "OPEN: " .. tostring(d.areasOpen),
            "CAUGHT: " .. tostring(d.areasCaught),
            "DEATHS: " .. tostring(d.deaths),
            "RUN: " .. (d.failed and "LOST" or "ACTIVE"),
            "MOD: " .. (d.enabled and "ON" or "OFF"),
            "EDITS: " .. tostring(d.edits),
            d.tainted and "DEV RUN: YES" or "DEV RUN: NO",
        })
    end

    local function showDevRules()
        local items = {}
        local currentState = state()
        for _, descriptor in ipairs(Core.descriptors()) do
            local desc = descriptor
            items[#items + 1] = row(desc.label, desc.status == "soon" and "soon" or nil,
                function()
                    info("RULE DETAIL", {
                        desc.key,
                        "VALUE: " .. (Core.get(currentState, desc.key) and "ON" or "OFF"),
                        "STATE: " .. desc.status:upper(),
                    })
                end)
        end
        present("RULE INSPECT", items)
    end

    local function areaRows(key)
        local entry = state().areas[key]
        local status = entry == nil and "UNRECORDED"
            or (entry.caught and "CAUGHT")
            or (Core.areaSpent(entry) and "SPENT" or "OPEN")
        return {
            row("MAP: " .. key),
            row("STATE: " .. status),
            row("MARK OPEN", nil, function()
                confirmDev("OPEN", "RE-ARM CATCH", function()
                    return Dev.setArea(key, "open")
                end)
            end),
            row("MARK SPENT", nil, function()
                confirmDev("SPENT", "BLOCK CATCH", function()
                    return Dev.setArea(key, "spent")
                end)
            end),
            row("MARK CAUGHT", nil, function()
                confirmDev("CAUGHT", "FAKE CLAIM", function()
                    return Dev.setArea(key, "caught")
                end)
            end),
            row("CLEAR ENTRY", nil, function()
                confirmDev("CLEAR", "REMOVE RECORD", function()
                    return Dev.setArea(key, "clear")
                end)
            end),
        }
    end

    local function openAreaEditor(key)
        if not key then
            return info("NO CURRENT MAP", {
                "ENTER AN OVERWORLD MAP",
                "AND REOPEN NUZ DEV",
            })
        end
        present("EDIT AREA", areaRows(key), function() return areaRows(key) end)
    end

    local function listAreaRows()
        local out = {}
        for _, entry in ipairs(Dev.areas()) do
            local key = entry.key
            local marker = entry.caught and "C" or (entry.spent and "X" or "O")
            out[#out + 1] = row(marker .. " " .. key, nil, function()
                openAreaEditor(key)
            end)
        end
        if #out == 0 then out[1] = row("NO RECORDED AREAS") end
        return out
    end

    local function showDevAreas()
        present("EDIT ALL AREAS", listAreaRows(), listAreaRows)
    end

    local function showDevRestore()
        local function restoreRows()
            local candidates=Dev.restoreCandidates()
            local rows={}
            for _,candidate in ipairs(candidates) do
                local index=candidate.index
                local archive=candidate.entry.archive
                local label=Display.pokemonName(candidate.entry)
                if type(label)~="string" or label=="" then
                    label=Display.speciesName(archive)
                end
                rows[#rows+1]=row(label,nil,function()
                    confirmDev("RESTORE","HALF HP, SAFE SLOT",function()
                        return Dev.restorePokemon(index)
                    end)
                end)
            end
            if #rows==0 then
                rows[1]=row("NO COMPLETE ARCHIVES")
            end
            rows[#rows+1]=row("ONLY FULL ARCHIVES",nil,function()
                info("DEV RESTORE",{
                    "TEST RUNS ONLY",
                    "ORIGINAL STATS AND MOVES",
                    "REVIVES AT HALF MAX HP",
                    "PARTY FIRST, THEN PC",
                    "DUPLICATES ARE BLOCKED",
                    "NO ROOM: REFUSED",
                    "LOST RUNS STAY SEALED",
                })
            end)
            return rows
        end
        present("DEV RESTORE",restoreRows(),restoreRows)
    end

    local function devRows()
        local d = Dev.status()
        if not d.enabled then
            return {
                row("ENABLE DEV MODE", nil, function()
                    confirmDev("ENABLE", "TEST MODE ONLY", Dev.enable)
                end),
                row("MODIFIES NUZ RECORDS"),
                row("NOT THE POKEMON PARTY"),
                row(d.tainted and "SAVE ALREADY FLAGGED" or "SAVE WILL BE FLAGGED"),
            }
        end
        return {
            row("RE-ARM CURRENT", nil, function()
                local key = api.currentEncounterArea and
                    api.currentEncounterArea(state()) or Dev.currentArea()
                if not key then
                    info("NO CURRENT MAP", { "ENTER AN OVERWORLD MAP" })
                    return
                end
                confirmDev("RE-ARM", "SLOT OPEN AGAIN", function()
                    return Dev.setArea(key, "open")
                end)
            end),
            row("EDIT CURRENT AREA", nil, function()
                openAreaEditor(api.currentEncounterArea and
                    api.currentEncounterArea(state()) or Dev.currentArea())
            end),
            row("EDIT ALL AREAS", nil, showDevAreas),
            row("CLEAR ALL AREAS", nil, function()
                confirmDev("CLEAR ALL", "ALL CATCH RECORDS", Dev.clearAllAreas)
            end),
            row("STATE INSPECTOR", nil, showDevInspector),
            row("RULE INSPECTOR", nil, showDevRules),
            row("RESET CLAUSE COUNTS", nil, function()
                confirmDev("RESET CLAUSES", "KEEP REAL POKEMON",
                    Dev.clearClauseHistory)
            end),
            row("PRINT DEBUG REPORT", nil, function()
                local ok, err = Dev.printReport()
                if ok then
                    info("REPORT PRINTED", {
                        "SEE GAME CONSOLE",
                        "SEARCH FOR [NUZ DEV]",
                    })
                else
                    info("REPORT BLOCKED", { tostring(err) })
                end
            end),
            row("CLEAR GRAVEYARD", nil, function()
                confirmDev("CLEAR DEAD", "NO POKEMON RESTORED", Dev.clearGraveyard)
            end),
            row("CLEAR RUN FAILURE", nil, function()
                confirmDev("CLEAR LOSS", "NEEDS LIVING PARTY", Dev.clearFailed)
            end),
            row("DISABLE DEV MODE", nil, function()
                confirmDev("DISABLE", "SAVE STAYS FLAGGED", Dev.disable)
            end),
            row("ADD TEST TOKEN", nil, function()
                confirmDev("GRANT TOKEN", "DEV RUN ONLY", Dev.grantTestToken)
            end),
            row("RESTORE FROM GRAVE",nil,showDevRestore),
        }
    end

    local function showDevTools()
        present("NUZ DEV", devRows(), devRows)
    end

    local function showNicknameTasks()
        local naming = api.nickname
        if not naming then return end
        local function tasksRows()
            local rows = {}
            if not Core.enforced(state(), "nickname_rule") then
                rows[1] = row("NICKNAME RULE IS OFF")
                return rows
            end
            local tasks = naming.pending()
            for _, item in ipairs(tasks) do
                local mon = item.mon
                local label = (item.where == "party"
                    and ("PARTY " .. tostring(item.slot))
                    or ("BOX " .. tostring(item.box) .. "/" .. tostring(item.slot)))
                    .. ": " .. item.name
                rows[#rows + 1] = row(label, nil, function()
                    local Naming = require("src.ui.game3.naming")
                    Naming.open({
                        template = "CAUGHT_MON", maxLen = 10,
                        species = mon.species or mon.speciesId,
                        personality = mon.personality,
                        gender = mon.gender,
                        seed = item.name,
                        sentToPc = item.where == "box",
                        title = Naming.monTitle(item.name),
                        onDone = function(value)
                            if naming.rename(mon, value) and current() then
                                current().rows = tasksRows()
                            end
                        end,
                    })
                end)
            end
            if #rows == 0 then rows[1] = row("ALL POKEMON NAMED") end
            return rows
        end
        present("NICKNAME TASKS", tasksRows(), tasksRows)
    end

    -- Readable on a 240x160 screen: details must wrap instead of being
    -- truncated to a single 181px row.
    local function noticeLines(message)
        return wrapDetails(message)
    end
    -- RUN JOURNAL combines live status and persistent rule events without
    -- duplicating or migrating older saved notice records.
    local function journalHistoryRows()
        local history = api.notices and api.notices() or {}
        local rows = {}
        for i=#history, math.max(1,#history-99), -1 do
            local event=history[i]
            if type(event)=="table" then
                local message=tostring(event.text or "")
                local heading=tostring(event.code or "NOTICE"):gsub("_"," ")
                rows[#rows+1]=row(heading,nil,function()
                    local content={"EVENT: "..heading}
                    for _,line in ipairs(noticeLines(message)) do
                        content[#content+1]=line
                    end
                    info("JOURNAL ENTRY",content)
                end)
            end
        end
        if #rows==0 then rows[1]=row("NO EVENTS YET") end
        return rows
    end

    local function showRunJournal()
        local function journalRows()
            local s=state()
            local claimed,catches=0,0
            for _,entry in pairs(s.areas or {}) do
                if Core.areaSpent(entry) then claimed=claimed+1 end
                if type(entry)=="table" and entry.caught then
                    catches=catches+1
                end
            end
            local history=api.notices and api.notices() or {}
            local outcome=s.failed and "LOST" or
                (s.finalResult and s.finalResult.outcome=="VICTORY"
                    and "CHAMPION" or "ACTIVE")
            local style=Playstyles.get(s,"hardcore_nuzlocke")
                and (Playstyles.get(s,"shiny_nuzlocke")
                    and "SHINY + HARD" or "HARDCORE")
                or (Playstyles.get(s,"shiny_nuzlocke")
                    and "SHINY NUZ" or "CLASSIC")
            return {
                row("RUN: "..outcome,nil,showStatus),
                row("STYLE: "..style,nil,showStatus),
                row("AREAS USED: "..claimed,nil,showTracker),
                row("AREA CATCHES: "..catches,nil,showTracker),
                row("FALLEN: "..#(s.graveyard or {}),nil,showGraveyard),
                row("SHINY EXC: "..tostring(s.shinyExceptionsUsed or 0),
                    nil,showStatus),
                row("EVENT HISTORY: "..#history,nil,function()
                    present("EVENT HISTORY",
                        journalHistoryRows(),journalHistoryRows)
                end),
                row("RUN RULE DETAILS",nil,showStatus),
                row("ENCOUNTER TRACKER",nil,showTracker),
                row("GRAVEYARD",nil,showGraveyard),
            }
        end
        present("RUN JOURNAL",journalRows(),journalRows)
    end

    -- This is a diagnostic screen, not another source of rule settings.
    -- Gen 3 composes native rules with provider hooks automatically; the
    -- Gen 1/2 per-capability ownership preferences have no Gen 3 contract.
    local function showModSupport()
        local function supportRows()
            local status=api.modSupport and api.modSupport() or {}
            local untamed=tostring(status.untamed or "UNKNOWN")
            local shiny=tostring(status.shiny or "UNKNOWN")
            local random=tostring(status.otherRandomizer or "UNKNOWN")
            local integrations=type(status.integrations)=="table"
                and status.integrations or {}
            local function integration(key)
                local entry=integrations[key]
                if type(entry)~="table" then
                    return {detection="UNKNOWN",api="UNKNOWN",
                        active="UNKNOWN",tested="NOT VERIFIED"}
                end
                return entry
            end
            local function label(entry)
                if entry.detection~="DETECTED" then
                    return tostring(entry.detection or "UNKNOWN")
                end
                if entry.api=="READY" then
                    return entry.active=="INACTIVE" and "INACTIVE"
                        or "API READY"
                end
                return "DETECTED"
            end
            local function companion(key,title,description)
                local entry=integration(key)
                return row(title..": "..label(entry),nil,function()
                    local lines={
                        "DETECTION: "..tostring(entry.detection),
                        "PUBLIC API: "..tostring(entry.api),
                        "RUN STATE: "..tostring(entry.active),
                        "COMBINED TEST: "..tostring(entry.tested),
                    }
                    for _,message in ipairs(description) do
                        lines[#lines+1]=message
                    end
                    info(title.." SUPPORT",lines)
                end)
            end
            return {
                row("UNTAMED: "..untamed,nil,function()
                    local entry=integration("untamed")
                    info("UNTAMED SUPPORT",{
                        "DETECTION: "..untamed,
                        "HOOK: "..tostring(entry.hook or "UNKNOWN"),
                        "WANDERING WILD POKEMON",
                        "SHARE NUZ CATCH RULES",
                        "RANDOM WILD / SHINY HOOKS",
                        "NO EXPORTED API PROBE",
                        "COMBINED TEST: NOT VERIFIED",
                    })
                end),
                row("SHINY ODDS: "..shiny,nil,function()
                    info("SHINY PROVIDER",{
                        "OWNER: "..shiny,
                        status.shinyOwner and
                            ("MOD: "..tostring(status.shinyOwner):sub(1,20))
                            or "NATIVE + NUZ ODDS",
                        "EXTERNAL OWNER MUST",
                        "EXPORT SHINY CAPABILITY",
                        "NO DOUBLE SHINY ROLLS",
                    })
                end),
                row("OTHER RNG: "..random,nil,function()
                    info("RANDOMIZER SUPPORT",{
                        "OTHER MOD: "..random,
                        "NUZ RANDOMIZER: BUILT IN",
                        status.wildRandom and
                            "NUZ WILDS: ON" or "NUZ WILDS: OFF",
                        status.trainerRandom and
                            "NUZ TRAINERS: ON" or "NUZ TRAINERS: OFF",
                        "OVERLAPPING RANDOMIZERS",
                        "MAY REQUIRE MANUAL SETUP",
                        "NO AUTOMATIC OWNERSHIP",
                        "IS CLAIMED FOR GEN 3",
                    })
                end),
                companion("nationalDex","NAT DEX",{
                    "EXPANDED SPECIES & FORMS",
                    "ROSTER / NAMES / RULES",
                    "NO SPECIES ID REWRITES",
                }),
                companion("battleSprites","G9 SPRITES",{
                    "NORMAL / SHINY / FORMS",
                    "NATIVE SPRITE API HOOKS",
                    "API READY IS NOT TESTED",
                }),
                companion("modernSpawns","MOD SPAWNS",{
                    "WILD ENCOUNTER TABLES",
                    "MOD SPAWNS OWNS TABLES",
                    "OVERLAP NEEDS GAME TEST",
                }),
                companion("hdSprites","HD SPRITES",{
                    "HI-RES PRESENTATION",
                    "NO NUZ RULE OWNERSHIP",
                    "API READY IS NOT TESTED",
                }),
                row("HOW SUPPORT WORKS",nil,function()
                    info("MOD SUPPORT HELP",{
                        "THIS SCREEN IS READ ONLY",
                        "DETECTED: MOD FOUND",
                        "API READY: FUNCTIONS EXIST",
                        "INACTIVE: PROVIDER OFF",
                        "NOT VERIFIED: GAME TEST",
                        "UNTAMED HOOK UNPROVEN",
                        "NO MANUAL OWNER SWITCHES",
                        "NUZ KEEPS CATCH RULES",
                        "TEST COMBINED MODS",
                    })
                end),
            }
        end
        present("MOD SUPPORT",supportRows(),supportRows)
    end

    local function showEndRun()
        if api.openResults and type(state().finalResult)=="table" then
            return api.openResults()
        end
        if state().enabled~=true then
            info("END RUN",{"NO NUZLOCKE RUN ENABLED",
                "ENABLE IN CORE TO START"})
            return
        end
        present("END THIS RUN?",{
            row("THIS ACTION IS PERMANENT"),
            row("RUN WILL BE MARKED LOST"),
            row("GAME WILL AUTO SAVE"),
            row("CONTINUE WILL BE LOCKED"),
            row("CONFIRM END RUN",nil,function()
                local ok,why=api.endRun()
                if not ok then
                    info("END RUN FAILED",{tostring(why)})
                end
            end),
            row("KEEP PLAYING",nil,function() popPage() end),
        })
    end
    -- Private, per-menu-session key sequence. It is an accidental-use
    -- safeguard rather than a security secret: source-visible and never
    -- persisted. The player must still confirm DEV activation separately.
    local DEV_KEYS={"up","up","down","down","left","right","left","right"}
    local devKeyProgress=0
    -- Prefer the native SELECT-held + A edge: no D-pad auto-repeat,
    -- timing or repeated identical key presses are required. Keep the
    -- old eight-direction sequence available as an alternative.
    local function openDevAccess()
        devKeyProgress=0
        present("DEV ACCESS",{
            row("OPEN DEV TOOLS",nil,function()
                popPage()
                showDevTools()
            end),
            row("CANCEL",nil,popPage),
            row("TEST RUNS ONLY"),
            row("DEV ENABLE FLAGS SAVE"),
        })
        return true
    end
    local function devKeyPress(key)
        if setupOnDone or not current()
            or current().title~="NUZ MENU" then
            devKeyProgress=0
            return false
        end
        if key==DEV_KEYS[devKeyProgress+1] then
            devKeyProgress=devKeyProgress+1
        else
            devKeyProgress=key==DEV_KEYS[1] and 1 or 0
        end
        if devKeyProgress~=#DEV_KEYS then return false end
        return openDevAccess()
    end

    local function home()
        present("NUZ MENU", {
            row("NUZ RULES", nil, showRules),
            row("ENC TRACKER", nil, showTracker),
            row("RUN JOURNAL", nil, showRunJournal),
            row("GRAVEYARD", nil, showGraveyard),
            row("MOD SUPPORT", nil, showModSupport),
            row("NICKNAME TASKS", nil, showNicknameTasks),
            row("END RUN", nil, showEndRun),
        })
    end

    local M = { isMenu = true }

    local function finishSetup(accepted)
        local callback = setupOnDone
        if not callback then return end
        setupOnDone = nil
        pages = {}
        engineGame = nil
        callback(accepted == true)
    end

    -- All working advanced categories are the very same pages used by the
    -- in-game menu: there is no duplicate or obsolete setup-rule catalogue.
    local function newRunRows()
        local locked = state().runSettingsLocked == true
        return {
            row("CORE RULES", nil, function()
                present("CORE", coreRows(), coreRows)
            end),
            row("ALL NUZ RULES", nil, showRules),
            row("QOL SETUP ONLY", nil, function()
                for _, category in ipairs(CATALOG) do
                    if category.title == "QOL SETUP ONLY" then
                        present("QOL SETUP", setupRows(category),
                            function() return setupRows(category) end)
                        return
                    end
                end
            end),
            row("LOCK FOR RUN: " .. (locked and "ON" or "OFF"), nil,
                function()
                    local saved = state()
                    if saved._setup ~= true then return end
                    saved.runSettingsLocked = not locked
                    api.setState(saved)
                    current().rows = newRunRows()
                end),
            row("START NEW GAME", nil, function()
                finishSetup(true)
            end),
            row("CANCEL", nil, function()
                finishSetup(false)
            end),
        }
    end

    function M.openSetup(game, done)
        if type(done) ~= "function" then return false end
        engineGame = game
        setupOnDone = done
        pages = {}
        devKeyProgress=0
        present("NEW RUN SETUP", newRunRows(), newRunRows)
        return true
    end

    function M.isSetupOpen()
        return setupOnDone ~= nil
    end

    function M.open(game)
        if not (game and game.session) then return false end
        setupOnDone = nil
        engineGame = game
        pages = {}
        devKeyProgress=0
        home()
        local Stack = require("src.ui.game3.stack")
        Stack.push(MENU_ID, M, { isMenu = true, hideBelow = true, fullscreen = true })
        return true
    end

    local function move(delta)
        local p = current()
        if not p or #p.rows == 0 then return end
        p.index = ((p.index - 1 + delta) % #p.rows) + 1
        if p.index <= p.scroll then p.scroll = p.index - 1 end
        if p.index > p.scroll + VISIBLE then p.scroll = p.index - VISIBLE end
    end

    local function back()
        if #pages > 1 then
            popPage()
        elseif setupOnDone then
            finishSetup(false)
        else
            pages = {}
            engineGame = nil
            require("src.ui.game3.stack").pop(MENU_ID)
        end
    end

    function M.handleInput(input)
        if not input or not current() then return end
        if not setupOnDone and current().title=="NUZ MENU"
            and type(input.isDown)=="function"
            and input:isDown("select")
            and input:wasPressed("a") then
            openDevAccess()
            return
        end
        local pressed
        for _,key in ipairs({"up","down","left","right"}) do
            if input:wasPressed(key) then pressed=key break end
        end
        if pressed and devKeyPress(pressed) then return end
        if not pressed then devKeyProgress=0 end
        if input:wasPressed("up") then move(-1)
        elseif input:wasPressed("down") then move(1)
        elseif input:wasPressed("a") then
            local p = current()
            local picked = p and p.rows[p.index]
            if picked and picked.action then picked.action() end
        elseif input:wasPressed("b") or input:wasPressed("start") then
            back()
        end
    end

    function M.update() end

    function M.draw()
        local p = current()
        if not p then return end
        local Window = require("src.ui.game3.window")
        local Chrome = require("src.ui.game3.chrome")
        local Font = require("src.ui.game3.frlg_font")
        -- Preserve the 240x160 GBA native display; don't use the 160x144
        -- Game Boy canvas/chrome from Gen 1/2.
        Window.fill(Window.template(0, 0, 30, 20), 1, 1, 1, 1)
        Chrome.fixedStdFrame(1, 1, 28, 18)
        Window.printPx(p.title, 24, 13, { maxWidth = 190 })
        Window.printPx(tostring(p.index) .. "/" .. tostring(#p.rows),
            186, 13, { maxWidth = 35, small = true })
        for slot = 1, VISIBLE do
            local index = p.scroll + slot
            local item = p.rows[index]
            if item then
                local y = 31 + (slot - 1) * 17
                if index == p.index then Window.cursorPx(18, y) end
                Window.printPx(item.label, 32, y,
                    { maxWidth = 181, small = true })
            end
        end
        if p.scroll > 0 then
            Window.printPx("UP", 200, 23, { small = true })
        end
        if p.scroll + VISIBLE < #p.rows then
            Window.printPx("MORE", 187, 125, { small = true })
        end
        Window.printPx("A: SELECT  B: BACK", 28, 138,
            { maxWidth = 185, small = true })
    end

    -- Small, side-effect-free state inspection for automated testing.
    function M.model()
        local p = current()
        if not p then return nil end
        local labels = {}
        for i, value in ipairs(p.rows) do labels[i] = value.label end
        return { title = p.title, rows = labels, index = p.index,
            scroll = p.scroll, depth = #pages }
    end

    function M.catalog()
        return CATALOG
    end

    return M
end
