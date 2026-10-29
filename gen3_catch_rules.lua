-- Gen 3 ADVANCED RULES / CATCH RULES: species eligibility for wild catches.
-- The native battle owns Poké Ball consumption, shake animation and storage.
-- This policy only allows/denies the existing catch.rate transaction.
return function()
    local M = { api = 1, schema = 1 }
    local MAX_NATIONAL=1025
    local dexProvider, flaggedSource, flaggedSpecies
    function M.setSpeciesProvider(provider)
        dexProvider=type(provider)=="function" and provider or nil
        flaggedSource,flaggedSpecies=nil,nil
    end
    local function providerFlags(national)
        if type(dexProvider)~="function" then return nil end
        local ok,api=pcall(dexProvider)
        if not ok or type(api)~="table"
            or type(api.listSpecies)~="function"
            or (tonumber(api.apiVersion) or 0)<2 then return nil end
        if flaggedSource~=api then
            flaggedSource,flaggedSpecies=api,{}
            local listed,rows=pcall(api.listSpecies)
            if listed and type(rows)=="table" then
                for _,entry in ipairs(rows) do
                    if type(entry)=="table" then
                        local dex=tonumber(entry.dex)
                        if dex and dex==math.floor(dex)
                            and dex>=1 and dex<=MAX_NATIONAL then
                            flaggedSpecies[dex]={legendary=entry.legendary==true,
                                mythical=entry.mythical==true}
                        end
                    end
                end
            end
        end
        return flaggedSpecies and flaggedSpecies[national]
    end
    local RULES = {
        { key = "town_catches", label = "Town Catches",
          default = false, kind = "toggle" },
        { key = "ban_legendaries", label = "No Legendaries",
          default = false, kind = "toggle" },
        { key = "ban_mythicals", label = "No Mythicals",
          default = false, kind = "toggle" },
        { key = "ban_pseudos", label = "No Pseudos",
          default = false, kind = "toggle" },
        { key = "no_static_encounters", label = "No Static Enc",
          default = false, kind = "toggle" },
        { key = "no_fishing", label = "No Fishing",
          default = false, kind = "toggle" },
        { key = "allow_gifts", label = "Gift Pokemon",
          default = true, kind = "toggle" },
        { key = "gift_slot_policy", label = "Gift Slot Policy",
          default = 0, kind = "slot" },
        { key = "allow_trades", label = "In-Game Trades",
          default = true, kind = "toggle" },
        { key = "trade_slot_policy", label = "Trade Slot Policy",
          default = 0, kind = "slot" },
        { key = "maximum_bst", label = "Maximum BST",
          default = 0, kind = "cycle" },
        { key = "pkmn_ban", label = "PKMN BAN",
          default = 0, kind = "picker" },
        { key = "colorlocke_mode", label = "Colorlocke",
          default = 0, kind = "color_mode" },
        { key = "colorlocke_color", label = "Color",
          default = 1, kind = "color" },
        { key = "alphabetlocke_mode", label = "Alphabetlocke",
          default = 0, kind = "alphabet_mode" },
        { key = "alphabetlocke_letter", label = "Letter",
          default = 1, kind = "letter" },
        { key = "allow_glitch_pokemon", label = "Allow Glitches",
          default = false, kind = "toggle" },
    }
    -- 0 = unlimited. Explicit presets keep the 240x160 menu compact.
    local BST_LIMITS = { 0, 300, 350, 400, 450, 500, 550, 600, 650, 700 }
    -- Canonical Gen 1-3 National Dex species colors; source:
    -- PokeAPI species color IDs (1 BLACK, 2 BLUE, 3 BROWN, 4 GRAY,
    -- 5 GREEN, 6 PINK, 7 PURPLE, 8 RED, 9 WHITE, A YELLOW).
    -- These are species identity colors, NOT drawable/shiny palettes.
    local CANONICAL_COLORS=table.concat({
        "5558882225593AA333733377AAAA222777663A6677228887733AAA2333322233",
        "344455522333AA66443339977777774AA88886A333367744623228837658A833",
        "822732A862233712AA22376555AAA22233338858722A66995596A522356527AA",
        "8227116412A47A746748A2133883364887411224839736A866A3254598555588",
        "8222443989A75555333229A99922353934A3622A3246771444285AAA47557822",
        "2A83173355552291A84288317544364511115292442222264629222232482285",
        "A8",
    })
    local COLOR_NAMES={"BLACK","BLUE","BROWN","GRAY","GREEN",
        "PINK","PURPLE","RED","WHITE","YELLOW"}
    local COLOR_IDS={}
    for i,name in ipairs(COLOR_NAMES) do COLOR_IDS[name]=i end
    local byKey = {}
    for _, rule in ipairs(RULES) do byKey[rule.key] = rule end
    local function asState(s)
        if type(s) ~= "table" then return {} end
        if type(s.catchRules) ~= "table" then s.catchRules = {} end
        return s.catchRules
    end
    function M.descriptors()
        local copy = {}
        for i, d in ipairs(RULES) do
            copy[i] = { key=d.key, label=d.label, kind=d.kind, status="working" }
        end
        return copy
    end
    local function banSet(s)
        local rules=asState(s)
        if type(rules.bannedNational)~="table" then
            rules.bannedNational={}
        end
        return rules.bannedNational
    end
    function M.banCount(s)
        local count=0
        for i=1,MAX_NATIONAL do
            if banSet(s)[tostring(i)]==true then count=count+1 end
        end
        return count
    end
    function M.isBannedNational(s,nat)
        local n=tonumber(nat)
        return n and n==math.floor(n) and n>=1 and n<=MAX_NATIONAL
            and banSet(s)[tostring(n)]==true or false
    end
    function M.toggleNational(s,nat)
        if type(s) == "table" and s.runSettingsLocked == true and s._setup ~= true then
            return false, "run_settings_locked"
        end
        local n=tonumber(nat)
        if type(s)~="table" then return false,"invalid_state" end
        if s.failed then return false,"run_failed" end
        if not n or n~=math.floor(n) or n<1 or n>MAX_NATIONAL then
            return false,"invalid_national_dex"
        end
        local bans=banSet(s)
        local key=tostring(n)
        if bans[key]==true then bans[key]=nil else bans[key]=true end
        return true
    end
    function M.get(s, key)
        local d = byKey[key]
        if not d then return nil end
        local rules = asState(s)
        local v = rules[key]
        if d.kind=="picker" then return M.banCount(s) end
        if d.kind == "toggle" then
            if type(v)=="boolean" then return v end
            return d.default
        elseif d.kind == "alphabet_mode" or d.kind=="color_mode" then
            return type(v)=="number" and v==math.floor(v)
                and v>=0 and v<=2 and v or d.default
        elseif d.kind == "letter" then
            return type(v)=="number" and v==math.floor(v)
                and v>=1 and v<=26 and v or d.default
        elseif d.kind == "color" then
            return type(v)=="number" and v==math.floor(v)
                and v>=1 and v<=10 and v or d.default
        elseif d.kind == "slot" then
            return (v==0 or v==1) and v or d.default
        end
        for _, option in ipairs(BST_LIMITS) do
            if v == option then return v end
        end
        return d.default
    end
    function M.set(s, key, value)
        if type(s) == "table" and s.runSettingsLocked == true and s._setup ~= true then
            return false, "run_settings_locked"
        end
        local d = byKey[key]
        if not d then return false, "not_implemented" end
        if type(s)~="table" then return false,"invalid_state" end
        if s.failed then return false, "run_failed" end
        if d.kind=="picker" then return false,"use_species_picker" end
        if d.kind == "toggle" then
            if type(value) ~= "boolean" then return false, "boolean_required" end
        elseif d.kind == "alphabet_mode" or d.kind=="color_mode" then
            if type(value)~="number" or value~=math.floor(value)
                or value<0 or value>2 then return false,"invalid_mode" end
        elseif d.kind == "letter" then
            if type(value)~="number" or value~=math.floor(value)
                or value<1 or value>26 then return false,"invalid_letter" end
        elseif d.kind=="color" then
            if type(value)~="number" or value~=math.floor(value)
                or value<1 or value>10 then return false,"invalid_color" end
        elseif d.kind == "slot" then
            if value~=0 and value~=1 then return false,"invalid_slot" end
        else
            local valid = false
            for _, option in ipairs(BST_LIMITS) do
                if value == option then valid = true; break end
            end
            if not valid then return false, "invalid_bst" end
        end
        local rules=asState(s)
        rules[key] = value
        if key=="alphabetlocke_mode" then
            rules.alphabetlocke_random_letter=nil
        elseif key=="colorlocke_mode" then
            rules.colorlocke_random_color=nil
        end
        return true
    end
    function M.next(s,key)
        local d=byKey[key]
        if not d then return nil end
        local current=M.get(s,key)
        if d.kind=="toggle" then return not current end
        if d.kind=="cycle" then return M.nextBst(current) end
        if d.kind=="alphabet_mode" or d.kind=="color_mode" then
            return (current+1)%3
        end
        if d.kind=="letter" then return (current%26)+1 end
        if d.kind=="color" then return (current%10)+1 end
        if d.kind=="slot" then return 1-current end
        return nil
    end
    function M.label(s,key)
        local d=byKey[key]
        if not d then return "UNKNOWN" end
        local v=M.get(s,key)
        if d.kind=="toggle" then return v and "ON" or "OFF" end
        if d.kind=="cycle" then return v==0 and "OFF" or tostring(v) end
        if d.kind=="picker" then return tostring(v).." BANNED" end
        if d.kind=="color" then return COLOR_NAMES[v] end
        if d.kind=="color_mode" then
            if v==1 then
                local chosen=asState(s).colorlocke_random_color
                if type(chosen)=="number" and COLOR_NAMES[chosen] then
                    return "RND:"..COLOR_NAMES[chosen]
                end
            end
            return ({"OFF","RANDOM","CHOOSE"})[v+1]
        end
        if d.kind=="alphabet_mode" then
            if v==1 then
                local chosen=asState(s).alphabetlocke_random_letter
                if type(chosen)=="number" and chosen>=1 and chosen<=26 then
                    return "RND:"..string.char(64+chosen)
                end
            end
            return ({"OFF","RANDOM","CHOOSE"})[v+1]
        end
        if d.kind=="letter" then return string.char(64+v) end
        if d.kind=="slot" then return v==0 and "AREA" or "BONUS" end
        return "UNKNOWN"
    end
    function M.nextBst(value)
        for i, option in ipairs(BST_LIMITS) do
            if option == value then return BST_LIMITS[i % #BST_LIMITS + 1] end
        end
        return 0
    end
    function M.anyEnabled(s)
        for _, d in ipairs(RULES) do
            if M.get(s, d.key) ~= d.default then return true end
        end
        return false
    end

    -- The region's native outdoor map IDs are authoritative; avoid
    -- substring matching on translated display labels or interiors.
    local ISLAND_TOWNS={
        ONE=true,TWO=true,THREE=true,FOUR=true,
        FIVE=true,SIX=true,SEVEN=true,
    }
    function M.isTownMap(mapId)
        if type(mapId)~="string" then return false end
        if not (mapId:match("^FR_") or mapId:match("^RU_")
            or mapId:match("^SA_") or mapId:match("^EM_")) then
            return false
        end
        if mapId:match("_[A-Z0-9_]+_TOWN$")
            or mapId:match("_[A-Z0-9_]+_CITY$") then return true end
        local island=mapId:match("^FR_([A-Z]+)_ISLAND$")
        return ISLAND_TOWNS[island] == true
    end
    -- Scripted wild battles expose both flags on the native Gen 3 battle
    -- state, unlike the public battle.started event's short payload.
    -- Roamers are intentionally excluded even when a battle is marked
    -- legendary: they are roaming, not fixed overworld/scripted encounters.
    function M.checkBattle(s, battle, core, mapId)
        if not core or not core.active(s) then return true end
        if not M.get(s,"town_catches") and M.isTownMap(mapId) then
            return false, "Town Catches: wild catches in towns are disabled."
        end
        if M.get(s, "no_static_encounters")
            and type(battle) == "table" and battle.roamer ~= true
            and (battle.wildScripted == true or battle.legendary == true) then
            return false,
                "No Static Encounters: scripted wild Pokemon cannot be caught."
        end
        return true
    end
    -- Scripted acquisitions use the native transaction but check legality
    -- before the gift is granted / NPC trade is offered. A mandatory first
    -- starter is exempt so a disabled Gift toggle cannot softlock the story.
    function M.canAcquire(s, kind, species, mapId, pokemon, core, opts)
        if not core or not core.active(s) then return true end
        if kind~="gift" and kind~="trade" then return true end
        opts=opts or {}
        if kind=="gift" and opts.mandatoryStarter then return true end
        local enabled=kind=="gift" and "allow_gifts" or "allow_trades"
        if M.get(s,enabled)==false then
            return false,kind=="gift"
                and "Gift Pokemon: optional gifts are disabled."
                or "In-Game Trades: NPC trades are disabled."
        end
        local eligible,why=M.check(s,species,pokemon,core,opts.seed)
        if not eligible then return false,why end
        local slotKey=kind=="gift" and "gift_slot_policy"
            or "trade_slot_policy"
        if M.get(s,slotKey)==0 and mapId
            and core.enforced(s,"encounter_limit")
            and not core.catchAllowed(s,mapId) then
            return false,(kind=="gift" and "Gift Slot Policy: "
                or "Trade Slot Policy: ")..
                "the area encounter slot is already spent."
        end
        return true
    end

    function M.noteAcquired(s,kind,species,mapId,core)
        if not core or not core.active(s) then return false end
        if kind~="gift" and kind~="trade" then return false end
        if type(s.acquisitionHistory)~="table" then
            s.acquisitionHistory={}
        end
        local slot=M.get(s,kind=="gift" and "gift_slot_policy"
            or "trade_slot_policy")
        local entry={kind=kind, speciesId=species, area=mapId,
            slot=slot==0 and "AREA" or "BONUS"}
        s.acquisitionHistory[#s.acquisitionHistory+1]=entry
        -- Bound ongoing history to avoid indefinite save growth.
        if #s.acquisitionHistory>256 then table.remove(s.acquisitionHistory,1) end
        if slot==0 and mapId and core.enforced(s,"encounter_limit") then
            if type(s.areas)~="table" then s.areas={} end
            s.areas[mapId]={speciesId=species,caughtSpeciesId=species,
                caught=true,spent=true,attempts=1,source=kind}
        end
        return true
    end

    function M.fishingBlocked(s, core)
        return core and core.active(s)
            and M.get(s, "no_fishing") == true or false
    end

    -- National Dex IDs, NOT internal Gen 3 species IDs! Hoenn internal IDs
    -- do not match National IDs (e.g. Treecko's internal index is 277).
    -- Query Pokemon.national() before classifying; never mistake internal
    -- gaps/form slots for banned species.
    local LEGENDARIES = {
        [144]=true,[145]=true,[146]=true,[150]=true,
        [243]=true,[244]=true,[245]=true,[249]=true,[250]=true,
        [377]=true,[378]=true,[379]=true,[380]=true,[381]=true,
        [382]=true,[383]=true,[384]=true,
    }
    local MYTHICALS = { [151]=true,[251]=true,[385]=true,[386]=true }
    -- Whole pseudo-legendary evolution lines, not just final evolutions.
    local PSEUDOS = {
        [147]=true,[148]=true,[149]=true,
        [246]=true,[247]=true,[248]=true,
        [371]=true,[372]=true,[373]=true,
        [374]=true,[375]=true,[376]=true,
        -- Full pseudo-legendary lines introduced after Hoenn.
        [443]=true,[444]=true,[445]=true, -- Gible
        [633]=true,[634]=true,[635]=true, -- Deino
        [704]=true,[705]=true,[706]=true, -- Goomy
        [782]=true,[783]=true,[784]=true, -- Jangmo-o
        [885]=true,[886]=true,[887]=true, -- Dreepy
        [996]=true,[997]=true,[998]=true, -- Frigibax
    }
    local function resolvedId(species,pokemon)
        local id=tonumber(species)
        if not id and pokemon and type(pokemon.speciesFromName)=="function" then
            local ok,v=pcall(pokemon.speciesFromName,species)
            if ok then id=tonumber(v) end
        end
        return id
    end
    local function nationalId(id,pokemon)
        if id and pokemon and type(pokemon.national)=="function" then
            local ok,v=pcall(pokemon.national,id)
            if ok then return tonumber(v) end
        elseif id and id<=251 then
            return id
        end
        return nil
    end
    local function canonicalName(id,pokemon)
        if not id or not pokemon then return nil end
        if type(pokemon.keyName)=="function" then
            local ok,v=pcall(pokemon.keyName,id)
            if ok and type(v)=="string" and v~="" then return v end
        end
        return nil
    end
    -- Read canonical internal names, not language-dependent display names.
    -- Random mode picks a represented initial once, persisting it in save.
    function M.prepareAlphabet(s,pokemon,seed)
        if M.get(s,"alphabetlocke_mode")~=1 then return false end
        local rows=asState(s)
        local old=tonumber(rows.alphabetlocke_random_letter)
        if old and old>=1 and old<=26 and old==math.floor(old) then
            return false
        end
        if not pokemon or type(pokemon.speciesFromNational)~="function"
            or type(pokemon.keyName)~="function" then return false end
        local present,choices={},{}
        for nat=1,MAX_NATIONAL do
            local ok,id=pcall(pokemon.speciesFromNational,nat)
            if ok and tonumber(id) then
                local name=canonicalName(tonumber(id),pokemon)
                local first=name and name:upper():match("^([A-Z])")
                if first then present[string.byte(first)-64]=true end
            end
        end
        for i=1,26 do if present[i] then choices[#choices+1]=i end end
        if #choices==0 then return false end
        local fingerprint=tostring(seed or "GEN3")
        local hash=5381
        for i=1,#fingerprint do
            hash=(hash*33+fingerprint:byte(i))%2147483647
        end
        rows.alphabetlocke_random_letter=choices[hash%#choices+1]
        return true
    end
    function M.selectedLetter(s,pokemon,seed)
        local mode=M.get(s,"alphabetlocke_mode")
        if mode==0 then return nil end
        if mode==2 then return M.get(s,"alphabetlocke_letter") end
        M.prepareAlphabet(s,pokemon,seed)
        local v=asState(s).alphabetlocke_random_letter
        if type(v)=="number" and v>=1 and v<=26 then return v end
        return nil
    end
    local function colorId(species,pokemon)
        local id=resolvedId(species,pokemon)
        if not id then return nil end
        -- Valid mod-provided color metadata takes priority if explicitly
        -- present. Other custom species fail open, never infer sprite color.
        if pokemon and type(pokemon.speciesMeta)=="function" then
            local ok,meta=pcall(pokemon.speciesMeta,id)
            if ok and type(meta)=="table" then
                if type(meta.color)=="string" then
                    local chosen=COLOR_IDS[meta.color:upper()]
                    if chosen then return chosen end
                end
                if type(meta.bodyColor)=="number"
                    and meta.bodyColor>=0 and meta.bodyColor<=9 then
                    local native={8,2,10,5,1,3,7,4,9,6}
                    return native[meta.bodyColor+1]
                end
            end
        end
        local nat=nationalId(id,pokemon)
        if not nat or nat<1 or nat>386 then return nil end
        local c=CANONICAL_COLORS:sub(nat,nat)
        return c=="A" and 10 or tonumber(c)
    end
    M.colorId=colorId
    function M.prepareColor(s,pokemon,seed)
        if M.get(s,"colorlocke_mode")~=1 then return false end
        local rules=asState(s)
        if type(rules.colorlocke_random_color)=="number"
            and COLOR_NAMES[rules.colorlocke_random_color] then
            return false
        end
        if not pokemon or type(pokemon.speciesFromNational)~="function"
            then return false end
        local seen,colors={},{}
        for nat=1,MAX_NATIONAL do
            local ok,id=pcall(pokemon.speciesFromNational,nat)
            local c=ok and colorId(id,pokemon) or nil
            if c and not seen[c] then seen[c]=true end
        end
        for i=1,10 do if seen[i] then colors[#colors+1]=i end end
        if #colors==0 then return false end
        local fingerprint=tostring(seed or "GEN3")
        local hash=5381
        for i=1,#fingerprint do
            hash=(hash*33+fingerprint:byte(i))%2147483647
        end
        rules.colorlocke_random_color=colors[hash%#colors+1]
        return true
    end
    function M.selectedColor(s,pokemon,seed)
        local mode=M.get(s,"colorlocke_mode")
        if mode==0 then return nil end
        if mode==2 then return M.get(s,"colorlocke_color") end
        M.prepareColor(s,pokemon,seed)
        return asState(s).colorlocke_random_color
    end
    function M.isGlitch(species,pokemon)
        local id=resolvedId(species,pokemon)
        -- The catch-rate hook may lack a species ID even for a valid wild.
        -- Unknown provenance is not proof of a glitch; never veto it.
        if id==nil then return nil end
        if id<1 or id~=math.floor(id) then return true end
        if not pokemon or type(pokemon.national)~="function" then
            return nil -- cannot judge without the live species registry
        end
        local meta
        if type(pokemon.speciesMeta)=="function" then
            local ok,v=pcall(pokemon.speciesMeta,id)
            if ok and type(v)=="table" then meta=v end
        end
        if meta and (meta.isGlitch or meta.glitch) then return true end
        local nat=nationalId(id,pokemon)
        -- Keep vanilla behaviour: the ROM may expose valid Gen 1-3
        -- species without all metadata during a scripted check.
        if nat and nat>=1 and nat<=386 then return false end
        if nat and nat>386 and nat<=MAX_NATIONAL
            and canonicalName(id,pokemon)
            and pokemon and type(pokemon.stats)=="function" then
            local ok,stats=pcall(pokemon.stats,id)
            if ok and type(stats)=="table" then return false end
        end
        -- Allow other verified custom species from third-party providers.
        if meta and canonicalName(id,pokemon) then return false end
        return true
    end
    function M.check(s, species, pokemon, core, seed)
        if not core or not core.active(s) then return true end
        if not M.get(s,"allow_glitch_pokemon")
            and M.isGlitch(species,pokemon)==true then
            return false,"Allow Glitches OFF: invalid or glitch Pokemon."
        end
        if not M.anyEnabled(s) then return true end
        local id=resolvedId(species,pokemon)
        local national=nationalId(id,pokemon)
        if national then
            if M.isBannedNational(s,national) then
                return false,"PKMN BAN: species #"
                    ..string.format("%03d",national).." is banned."
            end
            local flags=providerFlags(national)
            if M.get(s,"ban_legendaries")
                and (LEGENDARIES[national] or flags and flags.legendary) then
                return false, "No Legendaries: this Pokemon cannot be caught."
            end
            if M.get(s,"ban_mythicals")
                and (MYTHICALS[national] or flags and flags.mythical) then
                return false, "No Mythicals: this Pokemon cannot be caught."
            end
            if M.get(s,"ban_pseudos") and PSEUDOS[national] then
                return false, "No Pseudos: this evolution family is banned."
            end
        end
        if M.get(s,"colorlocke_mode")~=0 then
            local required=M.selectedColor(s,pokemon,seed)
            if not required then
                return false,"Colorlocke: cannot select a valid color."
            end
            local actual=colorId(species,pokemon)
            -- Non-native/provider species without color metadata fail open.
            if actual and actual~=required then
                return false,"Colorlocke: only "
                    ..COLOR_NAMES[required].." Pokemon can be caught."
            end
        end
        local letter=M.selectedLetter(s,pokemon,seed)
        if M.get(s,"alphabetlocke_mode")~=0 then
            if not letter then
                return false,"Alphabetlocke: cannot resolve a valid letter."
            end
            local name=canonicalName(id,pokemon)
            if not name then
                return false,"Alphabetlocke: cannot verify species name."
            end
            if name:upper():sub(1,1)~=string.char(64+letter) then
                return false,"Alphabetlocke: only "
                    ..string.char(64+letter).." Pokemon can be caught."
            end
        end
        local cap = M.get(s, "maximum_bst")
        if cap > 0 then
            local stats
            if id and pokemon and type(pokemon.stats)=="function" then
                local ok, result = pcall(pokemon.stats, id)
                if ok then stats = result end
            end
            -- A configured maximum is a hard restriction. Unknown stats
            -- must not silently bypass the limit.
            if type(stats) ~= "table" then
                return false, "Maximum BST: unable to verify Pokemon stats."
            end
            local bst = 0
            for i=1,6 do
                local n = tonumber(stats[i])
                if not n or n < 0 then
                    return false, "Maximum BST: unable to verify Pokemon stats."
                end
                bst = bst + n
            end
            if bst > cap then
                return false, "Maximum BST: " .. tostring(bst)
                    .. " exceeds " .. tostring(cap) .. "."
            end
        end
        return true
    end
    return M
end
