-- Nuzlocke 2.5.87 public interoperability / capability API
-- Behavior-preserving extraction from main.lua.
return function(mod, deps)
  deps = deps or {}
  local getCurrentGame = assert(deps.currentGame, "public_interop requires currentGame getter")
  local getCurrentSave = assert(deps.currentSave, "public_interop requires currentSave getter")
  local defaultRuleValue = assert(deps.defaultRuleValue, "public_interop requires defaultRuleValue")
  local registerArea = assert(deps.registerArea, "public_interop requires registerArea")
  local externalRuleDelegation = deps.externalRuleDelegation
  local NON_CORE_DELEGATION = deps.NON_CORE_DELEGATION

    ---------------------------------------------------------------------
    -- PUBLIC INTEROP / CAPABILITY API (30.0.0.3)
    --
    -- Stable, capability-first seams for UI replacements, encounter/gift
    -- providers, quest packs, EXP providers, registry consumers, and other
    -- mods.  No FAFF0x mod IDs are required: providers advertise what they do.
    ---------------------------------------------------------------------
    do
        local Interop = { api = 1, providers = {}, listeners = {} }

        local function norm(v)
            return tostring(v or ""):upper():gsub("[^A-Z0-9]+", "_"):gsub("^_+", ""):gsub("_+$", "")
        end

        local function shallowCopy(t)
            local out = {}
            for k, v in pairs(type(t) == "table" and t or {}) do out[k] = v end
            return out
        end

        function Interop.registerProvider(provider)
            if type(provider) ~= "table" then return false, "provider table required" end
            local id = norm(provider.id or provider.name)
            if id == "" then return false, "provider id required" end
            local copy = shallowCopy(provider)
            copy.id = id
            copy.capabilities = shallowCopy(provider.capabilities)
            Interop.providers[id] = copy
            return true, id
        end

        function Interop.unregisterProvider(id)
            id = norm(id)
            local existed = Interop.providers[id] ~= nil
            Interop.providers[id] = nil
            return existed
        end

        function Interop.getProvider(id) return Interop.providers[norm(id)] end

        -- 2.5.87: read-only provider inventory for compatibility diagnostics and
        -- cooperative mods. Return shallow snapshots so enumeration cannot
        -- accidentally mutate the live registry table.
        function Interop.listProviders()
            local out = {}
            for _, provider in pairs(Interop.providers) do
                local row = shallowCopy(provider)
                row.capabilities = shallowCopy(provider.capabilities)
                out[#out + 1] = row
            end
            table.sort(out, function(a,b) return tostring(a.id) < tostring(b.id) end)
            return out
        end

        function Interop.providerCount()
            local count = 0
            for _ in pairs(Interop.providers) do count = count + 1 end
            return count
        end

        function Interop.hasCapability(capability)
            capability = norm(capability)
            for _, provider in pairs(Interop.providers) do
                local caps = provider.capabilities or {}
                if caps[capability] == true or caps[capability:lower()] == true then
                    return true, provider
                end
                for k, v in pairs(caps) do
                    if v == true and norm(k) == capability then return true, provider end
                end
            end
            return false, nil
        end

        function Interop.providersWith(capability)
            local out, wanted = {}, norm(capability)
            for _, provider in pairs(Interop.providers) do
                for k, v in pairs(provider.capabilities or {}) do
                    if v == true and norm(k) == wanted then out[#out + 1] = provider break end
                end
            end
            table.sort(out, function(a,b) return tostring(a.id) < tostring(b.id) end)
            return out
        end

        function Interop.resolveCapability(capability)
            local requested = norm(capability)
            local aliases = {
                -- 2.4.2: an alternate Bag/pocket/favorites UI is presentation,
                -- not evidence that the mod owns item effects or challenge
                -- legality. Automatic-use and machine providers remain mechanic
                -- providers because they may initiate use outside the Bag UI.
                ALTERNATE_ITEM_UI="ITEM_PRESENTATION",
                AUTOMATIC_ITEM_USE="ITEM_USE_ENTRYPOINT",
                MACHINE_PROVIDER="MACHINE_MECHANICS",
                ALTERNATE_PC_UI="STORAGE_PROVIDER",
                EXTERNAL_ENCOUNTER_START="ENCOUNTER_PROVIDER",
                ENCOUNTER_SELECTOR="ENCOUNTER_SELECTOR",
                CAPTURE_MECHANICS="CAPTURE_MECHANICS",
                BATTLE_INFORMATION="BATTLE_INFORMATION",
                EXP_DISTRIBUTION="EXP_DISTRIBUTION",
                QUEST_FRAMEWORK="QUEST_FRAMEWORK",
                QUEST_PRESENTATION="QUEST_PRESENTATION",
                QUEST_PROVIDER="QUEST_CONTENT_PROVIDER",
            }
            local canonical = aliases[requested] or requested
            local explicit, automatic = {}, {}
            for _, provider in pairs(Interop.providers) do
                local matched = false
                for k, v in pairs(provider.capabilities or {}) do
                    local key = norm(k)
                    if v == true and (key == requested or key == canonical
                        or (aliases[key] or key) == canonical) then
                        matched = true
                        break
                    end
                end
                if matched then
                    if provider.automatic == true then automatic[#automatic+1]=provider
                    else explicit[#explicit+1]=provider end
                end
            end
            table.sort(explicit, function(a,b) return tostring(a.id)<tostring(b.id) end)
            table.sort(automatic, function(a,b) return tostring(a.id)<tostring(b.id) end)
            return {
                capability=canonical:lower(),
                supplied=(#explicit + #automatic) > 0,
                explicit=explicit,
                automatic=automatic,
                preferred=explicit[1] or automatic[1],
            }
        end

        function Interop.on(topic, fn)
            if type(fn) ~= "function" then return false end
            topic = norm(topic)
            Interop.listeners[topic] = Interop.listeners[topic] or {}
            Interop.listeners[topic][#Interop.listeners[topic] + 1] = fn
            return true
        end

        function Interop.emit(topic, payload)
            topic = norm(topic)
            for _, fn in ipairs(Interop.listeners[topic] or {}) do pcall(fn, payload) end
            if mod.events and mod.events.emit then pcall(mod.events.emit, mod.events, "nuzlocke." .. topic:lower(), payload) end
        end

        local Acquisition = {}
        Acquisition.KINDS = {
            wild=true, gift=true, trade=true, starter=true, scripted=true,
            editor=true, summon=true, quest=true, forced=true, wonder_trade=true,
            trainer_capture=true,
        }
        function Acquisition.classify(context)
            context = type(context) == "table" and context or {}
            local declared = norm(context.kind or context.sourceKind or context.acquisitionType)
            local aliases = {
                WILD="wild", GIFT="gift", TRADE="trade", STARTER="starter",
                SCRIPTED="scripted", EDITOR="editor", SUMMON="summon",
                QUEST="quest", FORCED="forced", WONDER_TRADE="wonder_trade",
                TRAINER_CAPTURE="trainer_capture", TRAINER_CATCH="trainer_capture",
                SNAG="trainer_capture",
            }
            if aliases[declared] then return aliases[declared] end
            if context.editor == true then return "editor" end
            if context.trainerCapture == true or context.trainer_capture == true
                or context.snag == true then return "trainer_capture" end
            if context.quest == true then return "quest" end
            if context.summon == true then return "summon" end
            if context.trade == true then return "trade" end
            if context.gift == true then return "gift" end
            if context.starter == true then return "starter" end
            if context.wild == true or context.encounter == true then return "wild" end
            return "scripted"
        end

        function Acquisition.evaluate(context)
            context = type(context) == "table" and context or {}
            local game = context.game or getCurrentGame() or mod.game
            -- Registered quest/content source metadata fills gaps without
            -- requiring provider-specific conditionals.
            if mod.exports.nuzlocke and mod.exports.nuzlocke.content then
                local sourceId = norm(context.sourceId or context.contentId)
                local c = mod.exports.nuzlocke.content
                local meta = sourceId ~= "" and (c.gifts[sourceId] or c.encounters[sourceId]) or nil
                if meta then
                    if not context.kind then context.kind = meta.kind end
                    if not context.species then context.species = meta.species end
                    if not context.areaId then context.areaId = meta.areaId end
                    if meta.repeatable ~= nil and context.repeatable == nil then context.repeatable = meta.repeatable end
                end
            end
            local kind = Acquisition.classify(context)
            local concrete = type(context.mon) == "table" and context.mon
                or (type(context.pokemon) == "table" and context.pokemon or nil)
            local species = tostring(context.species or context.pokemonId or context.id
                or (concrete and concrete.species) or ""):upper()
            local result = { allowed=true, kind=kind, species=species, reason=nil, rule=nil }
            local progressionRequested = (context.progressionRequired == true
                    or context.nuzlockeProgressionRequired == true)
                and (context.allowProgressionException == true
                    or context.nuzlockeAllowProgressionException == true)
                and context.captureAttempt == true
            local function providerProgressionOverride(rule, reason)
                if not progressionRequested
                    or mod.save:get("progression_pc_catches", false) ~= true then
                    return false
                end
                local helper = mod.exports.__beta26.tryProgressionCatchOverride
                if type(helper) ~= "function" then return false end
                local ok, allowed, refusal = pcall(helper, game,
                    context.battle, rule or reason, context)
                if not ok or allowed ~= true then
                    if refusal == "progression_pc_full" then
                        result.allowed, result.rule, result.reason =
                            false, "progression_pc_catches", refusal
                        return true
                    end
                    return false
                end
                result.allowed = true
                result.exempt = true
                result.pcLock = true
                result.permanent = true
                result.consumeEncounter = false
                result.rule = "progression_pc_catches"
                result.reason = "progression_exception"
                result.pcLockReason = rule or reason
                return true
            end
            if kind == "wild" or kind == "summon" or kind == "quest"
                or kind == "trainer_capture" then
                if mod.save:get("no_catching", false) == true and context.captureAttempt == true then
                    if providerProgressionOverride("no_catching", "catching_banned") then
                        return result
                    end
                    result.allowed, result.rule, result.reason = false, "no_catching", "catching_banned"
                    return result
                end
            end
            if (species ~= "" or concrete ~= nil) and mod.exports.__beta26 then
                local evaluator = concrete and mod.exports.__beta26.typeLockAllowsPokemon
                    or mod.exports.__beta26.typeLockAllowsSpecies
                if type(evaluator) == "function" then
                    local ok, allowed = pcall(evaluator, game, concrete or species)
                    if ok and allowed == false then
                        if providerProgressionOverride("type_lock", "type_lock") then
                            return result
                        end
                        result.allowed, result.rule, result.reason = false, "type_lock", "type_lock"
                        return result
                    end
                end
            end
            if species ~= "" and type(specialAcquisitionDenied) == "function"
                and (kind == "gift" or kind == "trade") then
                local area = context.areaId or context.area or context.location
                local policyKind = kind
                local ok, reason = pcall(specialAcquisitionDenied, game, species, area, policyKind, concrete)
                if ok and reason then
                    result.allowed, result.rule, result.reason = false, reason, reason
                    return result
                end
            end
            return result
        end

        function Acquisition.begin(context)
            local result = Acquisition.evaluate(context)
            Interop.emit("acquisition_evaluated", {context=context, result=result})
            return result
        end

        function Acquisition.commit(context)
            context = type(context) == "table" and context or {}
            local result = Acquisition.evaluate(context)
            if result.allowed then
                if result.pcLock == true then
                    local game = context.game or getCurrentGame() or mod.game
                    local mon = type(context.mon) == "table" and context.mon
                        or (type(context.pokemon) == "table" and context.pokemon or nil)
                    local locker = mod.exports.__beta26.lockProgressionCatchInPc
                    if mon and type(locker) == "function" then
                        pcall(locker, game, mon,
                            result.pcLockReason or "progression_exception")
                    end
                end
                Interop.emit("acquisition_committed", {context=context, result=result})
            end
            return result
        end

        local ItemAPI = {}
        function ItemAPI.classify(context)
            context = type(context) == "table" and context or { itemId=context }
            local data = context.data or (context.game and context.game.data) or (getCurrentGame() and getCurrentGame().data) or (mod.game and mod.game.data)
            local itemId = context.itemId or context.id or context.item
            if ItemPolicy.isFishingRod(data, itemId) then return "fishing_rod" end
            local id = ItemPolicy.normalize(itemId)
            if ItemPolicy.repels[id] then return "repel" end
            if ItemPolicy.escapeRopes[id] then return "escape_rope" end
            if ItemPolicy.rareCandies[id] then return "rare_candy" end
            if ItemPolicy.xItems[id] then return "battle_item" end
            if ItemPolicy.isBall(data, itemId, context.itemEffects) then return "ball" end
            return "item"
        end

        function ItemAPI.evaluate(context)
            context = type(context) == "table" and context or { itemId=context }
            local game = context.game or getCurrentGame() or mod.game
            local data = context.data or (game and game.data)
            local save = context.save or (game and game.save) or getCurrentSave()
            local itemId = context.itemId or context.id or context.item
            local target = context.target or context.pokemon or context.mon
            if type(evaluateItemUsePolicy) == "function" then
                local ok, allowed, decision = pcall(evaluateItemUsePolicy,
                    game, data, save, itemId, target, context)
                if ok then
                    if allowed == false then
                        return { allowed=false,
                            rule=decision and (decision.rule or decision.code),
                            reason=decision and (decision.reason or decision.code),
                            code=decision and decision.code,
                            kind=ItemAPI.classify(context), decision=decision }
                    end
                    return { allowed=true, kind=ItemAPI.classify(context),
                        decision=decision }
                end
            end
            return {allowed=true, kind=ItemAPI.classify(context)}
        end

        function ItemAPI.beforeUse(context)
            local result = ItemAPI.evaluate(context)
            Interop.emit("item_use_evaluated", {context=context, result=result})
            return result
        end

        function ItemAPI.canUse(context)
            local result = ItemAPI.beforeUse(context)
            return result.allowed == true, result.rule, result.reason, result
        end

        -- Alternate inventory UIs should call this immediately before invoking
        -- the engine item effect.  The alias names make migration easy for Bag,
        -- shortcut, favorite-item, auto-repel, and similar mods.
        ItemAPI.check = ItemAPI.canUse
        ItemAPI.checkUse = ItemAPI.canUse

        local Registry = { revision = 0 }
        function Registry.effectivePokemon(game) game=game or getCurrentGame() or mod.game; return game and game.data and game.data.pokemon or nil end
        function Registry.effectiveEncounters(game)
            game = game or getCurrentGame() or mod.game
            local data = game and game.data
            -- The shared engine registry name is `encounters`, but Gold's live
            -- merge target is data.gen2Encounters.  Return the same final table
            -- the generation actually consumes so DexNav/guide/provider clients
            -- never receive a nil Gen 1 alias on a Gold boot (Gen1Recomp 0.2.7
            -- also adds TimeFishGroups/day-night fishing under this target).
            if not data then return nil end
            if mod.exports.__beta26.runtimeIsGold(game) then
                return data.gen2Encounters or data.encounters
            end
            return data.encounters
        end

        -- Gameplay consumers must always use the final composed live encounter
        -- registry. Information/presentation consumers may additionally respect
        -- the run's reveal policy without changing encounter generation.
        function Registry.encounterInformationPolicy(game)
            local randomized = not (externalRuleDelegation
                and externalRuleDelegation("random_encounter_tables", game or getCurrentGame() or mod.game))
                and mod.save:get("random_encounter_tables", false) == true
            local mode = math.max(0, math.min(1,
                math.floor(tonumber(mod.save:get("randomizer_info_policy", 0)) or 0)))
            return {
                mode = mode == 1 and "blind" or "open",
                randomized = randomized,
                gameplayRegistry = Registry.effectiveEncounters(game),
                revealRandomizedTables = not randomized or mode == 0,
            }
        end

        function Registry.canRevealEncounterInformation(context)
            context = type(context)=="table" and context or {}
            local policy = Registry.encounterInformationPolicy(context.game)
            if policy.revealRandomizedTables then return true, policy end
            -- Explicitly discovered/owned information may be shown even under a
            -- blind run. Providers can set any of these semantic facts without
            -- exposing the entire hidden table.
            if context.discovered == true or context.encountered == true
                or context.caught == true or context.owned == true then
                return true, policy
            end
            return false, policy
        end

        function Registry.encounterInformation(context)
            context = type(context)=="table" and context or {}
            local allowed, policy = Registry.canRevealEncounterInformation(context)
            return {
                allowed = allowed,
                policy = policy.mode,
                randomized = policy.randomized,
                registry = allowed and policy.gameplayRegistry or nil,
                reason = allowed and nil or "randomized_encounters_undiscovered",
            }
        end

        -- Targeted encounter tools (DexNav, radar, search/summon UIs) are
        -- gameplay selectors, not merely information panels. They must still
        -- use the final live registry, but under BLIND randomized info they
        -- should not deliberately select an undiscovered hidden species.
        --
        -- This is cooperative: providers call this before choosing a target.
        -- Ordinary random encounter generation is never blocked by BLIND INFO.
        function Registry.encounterSelection(context)
            context = type(context)=="table" and context or {}
            local policy = Registry.encounterInformationPolicy(context.game)
            local targeted = context.targeted == true
                or context.targetedSelection == true
                or context.selectSpecies == true
                or context.uncaughtOnly == true
                or context.selector == true

            local discovered = context.discovered == true
                or context.encountered == true
                or context.caught == true
                or context.owned == true

            local allowed = true
            local reason = nil
            if targeted and policy.randomized and policy.mode == "blind"
                and not discovered then
                allowed = false
                reason = "blind_targeted_encounter"
            end

            return {
                allowed = allowed,
                policy = policy.mode,
                randomized = policy.randomized,
                targeted = targeted,
                registry = allowed and policy.gameplayRegistry or nil,
                reason = reason,
                fallback = allowed and nil or "random_encounter",
            }
        end

        function Registry.canSelectEncounter(context)
            local result = Registry.encounterSelection(context)
            return result.allowed == true, result
        end

        function Registry.effectiveMoves(game) game=game or getCurrentGame() or mod.game; return game and game.data and game.data.moves or nil end
        function Registry.effectiveLearnset(species, game)
            local p = Registry.effectivePokemon(game)
            local def = p and p[tostring(species or ""):upper()]
            if type(def) ~= "table" then return nil end
            return { level1Moves=def.level1Moves, learnset=def.learnset }
        end
        function Registry.changed(kind, game, source)
            Registry.revision = Registry.revision + 1
            Interop.emit("registry_changed", {kind=kind or "all", revision=Registry.revision, game=game or getCurrentGame() or mod.game, source=source or "nuzlocke"})
        end
        function Registry.getRevision() return Registry.revision end
        function Registry.describe(game)
            game = game or getCurrentGame() or mod.game
            return {
                revision=Registry.revision,
                pokemon=game and game.data and game.data.pokemon or nil,
                encounters=Registry.effectiveEncounters(game),
                moves=game and game.data and game.data.moves or nil,
                randomEncounters=(not (externalRuleDelegation and externalRuleDelegation("random_encounter_tables", getCurrentGame() or mod.game)) and mod.save:get("random_encounter_tables", false) == true),
                randomLearnsets=(not (externalRuleDelegation and externalRuleDelegation("random_learnsets", getCurrentGame() or mod.game)) and mod.save:get("random_learnsets", false) == true),
                encounterInformation=Registry.encounterInformationPolicy(game),
            }
        end

        local Experience = { api = 2 }
        function Experience.getCap(game)
            game = game or getCurrentGame() or mod.game
            if mod.exports.__beta26 and mod.exports.__beta26.getNextLevelCapInfo then
                local ok, info = pcall(mod.exports.__beta26.getNextLevelCapInfo, game)
                if ok and type(info) == "table" then return info.level or info.cap, info end
            end
            return nil, nil
        end
        function Experience.capAward(context)
            context = type(context)=="table" and context or {}
            local requested = math.max(0,
                math.floor(tonumber(context.amount or context.gained) or 0))
            -- Rebound after the level-cap helpers enter lexical scope. Early
            -- callers fail open rather than relying on a forward reference.
            return {
                allowed=true, requested=requested, amount=requested,
                overflow=0, owner="pending_cap_policy", mutates=false,
            }
        end
        Experience.evaluateAward = Experience.capAward
        Experience.preflight = Experience.capAward

        local PartyPC = {}
        PartyPC.api = 2

        local function storageAction(value)
            local action = norm(value)
            if action == "WITHDRAW" or action == "DEPOSIT" or action == "RELEASE"
                or action == "SWAP" then return action end
            return action
        end

        function PartyPC.describe(context)
            context = type(context)=="table" and context or {}
            local action = storageAction(context.action or context.kind)
            local incoming = context.incoming or context.toParty
            local outgoing = context.outgoing or context.fromParty
            local mon = context.mon or context.pokemon
            if action == "WITHDRAW" and incoming == nil then incoming = mon end
            if (action == "DEPOSIT" or action == "RELEASE") and outgoing == nil then outgoing = mon end
            if action == "SWAP" then
                incoming = incoming or context.boxMon or context.boxPokemon
                outgoing = outgoing or context.partyMon or context.partyPokemon
            end
            return {
                action=action,
                incoming=incoming,
                outgoing=outgoing,
                source=context.source or context.provider,
                phase=context.phase or "before",
                transactionId=context.transactionId or context.id,
            }
        end

        function PartyPC.evaluate(context)
            context = type(context)=="table" and context or {}
            local tx = PartyPC.describe(context)
            local result = {
                allowed=true, action=tx.action, reason=nil, rule=nil,
                incoming=tx.incoming, outgoing=tx.outgoing,
                transactionId=tx.transactionId,
            }
            -- A configured value of 6 is vanilla capacity, not a Nuzlocke
            -- restriction. Alternate PC providers should keep their native/full
            -- party response at six instead of receiving a Nuzlocke denial.
            local challengePartyLimit = math.max(1, math.min(6,
                math.floor(tonumber(mod.save:get("party_size_limit",
                    defaultRuleValue("party_size_limit"))) or 6)))
            -- Progression/completion catches are a permanent storage-only
            -- classification. Alternate PC providers must refuse both a transfer
            -- into the active party and RELEASE, matching the native PC wrappers.
            if type(tx.incoming)=="table" and tx.incoming.nuzlockePcLocked == true then
                result.allowed, result.rule, result.reason =
                    false, "progression_pc_lock", "progression_pc_locked"
            elseif tx.action == "RELEASE" and type(tx.outgoing)=="table"
                and tx.outgoing.nuzlockePcLocked == true then
                result.allowed, result.rule, result.reason =
                    false, "progression_pc_lock", "progression_pc_locked"
            -- Challenge legality follows the Pokemon entering the active party,
            -- not the menu verb that moved it.  This makes WITHDRAW and direct
            -- party/box SWAP equivalent for alternate PC implementations.
            elseif type(tx.incoming)=="table" and tx.incoming.nuzlockeDead == true then
                result.allowed, result.rule, result.reason =
                    false, "death", "dead_pokemon_unusable"
            elseif type(tx.incoming)=="table" and tx.outgoing == nil
                and active(getCurrentGame() or mod.game, nil)
                and challengePartyLimit < 6
                and #(getCurrentSave() and getCurrentSave().party or {}) >= challengePartyLimit then
                result.allowed, result.rule, result.reason =
                    false, "party_size_limit", "party_size_limit"
            end
            Interop.emit("pc_action_evaluated", {context=context, transaction=tx, result=result})
            return result
        end

        function PartyPC.can(context)
            local r=PartyPC.evaluate(context); return r.allowed, r.rule, r.reason, r
        end

        function PartyPC.begin(context)
            local tx = PartyPC.describe(context)
            local r = PartyPC.evaluate(context)
            Interop.emit("storage_transaction_begin", {transaction=tx, result=r, context=context})
            return r
        end

        function PartyPC.commit(context)
            local tx = PartyPC.describe(context)
            tx.phase = "after"
            Interop.emit("storage_transaction_commit", {transaction=tx, context=context})
            return true, tx
        end

        -- Aliases use storage terminology so future PC replacements do not need
        -- to pretend they are using the vanilla Bill's-PC menu.
        PartyPC.evaluateTransaction = PartyPC.evaluate
        PartyPC.canTransaction = PartyPC.can

        local EncounterAPI = {}
        function EncounterAPI.evaluate(context)
            context=type(context)=="table" and context or {}
            local copy=shallowCopy(context)
            copy.encounter=true
            if context.source == "dexnav" or context.dexnav == true then copy.kind="wild" end
            if context.source == "summon" or context.summon == true then copy.kind="summon" end

            local targeted = context.targeted == true
                or context.targetedSelection == true
                or context.selectSpecies == true
                or context.uncaughtOnly == true
                or context.selector == true
            if targeted and Registry and type(Registry.encounterSelection) == "function" then
                local selection = Registry.encounterSelection(context)
                if selection.allowed ~= true then
                    return {
                        allowed=false,
                        kind=Acquisition.classify(copy),
                        species=tostring(context.species or ""):upper(),
                        rule="randomizer_info_policy",
                        reason=selection.reason or "blind_targeted_encounter",
                        selection=selection,
                    }
                end
            end

            local result = Acquisition.begin(copy)
            if targeted and Registry and type(Registry.encounterSelection) == "function" then
                result.selection = Registry.encounterSelection(context)
            end
            return result
        end
        EncounterAPI.selection = Registry.encounterSelection
        EncounterAPI.canSelect = Registry.canSelectEncounter

        local Content = {
            areas = {}, dungeons = {}, dungeonMapIndex = {},
            bosses = {}, gifts = {}, encounters = {},
            randomizerEncounterPolicies = {}, randomizerLearnsetPolicies = {},
        }

        local function contentId(value)
            return norm(value)
        end

        function Content.registerArea(def)
            if type(def) ~= "table" then return false, "area table required" end
            local id = contentId(def.id or def.mapId or def.areaId)
            if id == "" then return false, "area id required" end
            local row = shallowCopy(def)
            row.id = id
            row.name = def.name or def.displayName or id
            Content.areas[id] = row
            -- Feed the existing dynamic tracker catalogue rather than creating
            -- a parallel area namespace.
            pcall(registerArea, id, row.name)
            Interop.emit("content_area_registered", row)
            return true, id
        end

        function Content.registerDungeon(def)
            if type(def) ~= "table" then return false, "dungeon table required" end
            local id = contentId(def.id or def.family or def.name)
            if id == "" then return false, "dungeon id required" end
            local row = shallowCopy(def)
            row.id = id
            row.maps = {}
            local maps = def.maps or def.mapIds or {}
            if type(maps) == "string" then maps = { maps } end
            for _, mapId in ipairs(type(maps) == "table" and maps or {}) do
                local key = contentId(mapId)
                if key ~= "" then
                    row.maps[#row.maps + 1] = key
                    Content.dungeonMapIndex[key] = id
                    Content.registerArea({id=key, name=(def.mapNames and def.mapNames[mapId]) or key,
                        dungeon=id, provider=def.provider})
                end
            end
            Content.dungeons[id] = row
            Interop.emit("content_dungeon_registered", row)
            return true, id
        end

        function Content.dungeonFamily(mapId)
            return Content.dungeonMapIndex[contentId(mapId)]
        end

        function Content.registerBoss(def)
            if type(def) ~= "table" then return false, "boss table required" end
            local id = contentId(def.id or def.name or def.trainerId)
            if id == "" then return false, "boss id required" end
            local row = shallowCopy(def)
            row.id = id
            row.mapId = contentId(def.mapId or def.areaId)
            Content.bosses[id] = row
            Interop.emit("content_boss_registered", row)
            return true, id
        end

        function Content.registerGift(def)
            if type(def) ~= "table" then return false, "gift table required" end
            local id = contentId(def.id or def.sourceId or ((def.species or "GIFT") .. "_" .. (def.mapId or def.areaId or "")))
            if id == "" then return false, "gift id required" end
            local row = shallowCopy(def)
            row.id = id
            row.species = def.species and tostring(def.species):upper() or nil
            row.areaId = contentId(def.areaId or def.mapId)
            row.kind = def.kind or "quest"
            Content.gifts[id] = row
            if row.areaId ~= "" then Content.registerArea({id=row.areaId, name=def.areaName or row.areaId, provider=def.provider}) end
            Interop.emit("content_gift_registered", row)
            return true, id
        end

        function Content.registerEncounter(def)
            if type(def) ~= "table" then return false, "encounter table required" end
            local id = contentId(def.id or def.sourceId or ((def.species or "ENCOUNTER") .. "_" .. (def.mapId or def.areaId or "")))
            if id == "" then return false, "encounter id required" end
            local row = shallowCopy(def)
            row.id = id
            row.species = def.species and tostring(def.species):upper() or nil
            row.areaId = contentId(def.areaId or def.mapId)
            row.kind = def.kind or "quest"
            if def.repeatable == true then row.repeatable = true end
            if def.randomizable == false then row.randomizable = false end
            Content.encounters[id] = row
            if row.areaId ~= "" then Content.registerArea({id=row.areaId, name=def.areaName or row.areaId, provider=def.provider}) end
            Interop.emit("content_encounter_registered", row)
            return true, id
        end

        function Content.setEncounterRandomizerPolicy(id, policy)
            id = contentId(id)
            if id == "" then return false end
            Content.randomizerEncounterPolicies[id] = policy
            return true
        end

        function Content.setLearnsetRandomizerPolicy(species, policy)
            species = tostring(species or ""):upper()
            if species == "" then return false end
            Content.randomizerLearnsetPolicies[species] = policy
            return true
        end

        function Content.shouldRandomizeEncounter(context)
            context = type(context) == "table" and context or {}
            if context.randomizable == false then return false, "record_opt_out" end
            local sourceId = contentId(context.sourceId or context.id)
            local policy = sourceId ~= "" and Content.randomizerEncounterPolicies[sourceId] or nil
            if policy == false or policy == "preserve" or policy == "story" then return false, "provider_policy" end
            local mapId = contentId(context.mapId or context.areaId)
            for _, encounter in pairs(Content.encounters) do
                if encounter.randomizable == false
                    and (sourceId ~= "" and encounter.id == sourceId
                        or mapId ~= "" and encounter.areaId == mapId
                            and (not encounter.species or encounter.species == tostring(context.species or ""):upper())) then
                    return false, "content_opt_out"
                end
            end
            return true
        end

        function Content.shouldRandomizeLearnset(species, def)
            species = tostring(species or ""):upper()
            if type(def) == "table" and def.nuzlockeRandomizable == false then return false, "record_opt_out" end
            local policy = Content.randomizerLearnsetPolicies[species]
            if policy == false or policy == "preserve" or policy == "story" then return false, "provider_policy" end
            return true
        end

        function Content.describe()
            return {
                areas=Content.areas, dungeons=Content.dungeons, bosses=Content.bosses,
                gifts=Content.gifts, encounters=Content.encounters,
            }
        end

        -- A convenience provider bundle for quest/content mods. This is the
        -- preferred integration point for FAFF0x-style quest packs: one call
        -- can register dynamic maps, dungeons, bosses, gifts and encounters.
        function Content.registerBundle(bundle)
            if type(bundle) ~= "table" then return false, "bundle table required" end
            local provider = bundle.provider or bundle.id or bundle.name
            local function each(list, fn)
                if type(list) == "table" then
                    for _, def in pairs(list) do
                        if type(def) == "table" then
                            local row = shallowCopy(def)
                            row.provider = row.provider or provider
                            fn(row)
                        end
                    end
                end
            end
            each(bundle.areas, Content.registerArea)
            each(bundle.dungeons, Content.registerDungeon)
            each(bundle.bosses, Content.registerBoss)
            each(bundle.gifts, Content.registerGift)
            each(bundle.encounters, Content.registerEncounter)
            if type(bundle.randomizerEncounterPolicies) == "table" then
                for id, policy in pairs(bundle.randomizerEncounterPolicies) do
                    Content.setEncounterRandomizerPolicy(id, policy)
                end
            end
            if type(bundle.randomizerLearnsetPolicies) == "table" then
                for species, policy in pairs(bundle.randomizerLearnsetPolicies) do
                    Content.setLearnsetRandomizerPolicy(species, policy)
                end
            end
            Interop.emit("content_bundle_registered", {provider=provider})
            return true
        end

        local AutoCompat = {
            api = 1, detected = {}, adapters = {}, lastParty = {}, lastPC = {},
            lastArea = nil,
            -- Canonical behavior capabilities used by automatic adapters.
            -- Aliases below remain accepted for older integrations.
            capabilityAliases = {
                ALTERNATE_ITEM_UI = "item_presentation",
                AUTOMATIC_ITEM_USE = "item_use_entrypoint",
                ALTERNATE_PC_UI = "storage_provider",
                EXTERNAL_ENCOUNTER_START = "encounter_provider",
                ENCOUNTER_SELECTOR = "encounter_selector",
                CAPTURE_MECHANICS = "capture_mechanics",
                BATTLE_INFORMATION = "battle_information",
                REGISTRY_CONSUMER = "registry_consumer",
                EXP_DISTRIBUTION = "exp_distribution",
                QUEST_FRAMEWORK = "quest_framework",
                QUEST_PRESENTATION = "quest_presentation",
                QUEST_PROVIDER = "quest_content_provider",
                MACHINE_PROVIDER = "machine_mechanics",
            },
        }

        local function activeMods()
            local out = {}
            local function remember(id, info)
                id = norm(id)
                if id == "" then return end
                if out[id] == nil then
                    out[id] = type(info) == "table" and info or { id = id }
                end
            end

            -- 2.4.2: prefer the authoritative Gen1Recomp loaded-mod graph.
            -- This prevents disabled/removed mods from lingering as phantom
            -- automatic providers when an old global compatibility table is stale.
            local game = getCurrentGame() or mod.game
            local loader = game and game.mods
            if loader and type(loader.status) == "function" then
                local okStatus, status = pcall(function() return loader:status() end)
                if okStatus and type(status) == "table"
                    and type(status.loaded) == "table" then
                    for _, manifest in ipairs(status.loaded) do
                        if type(manifest) == "table" and manifest.id then
                            local okFind, found = pcall(mod.find, manifest.id)
                            remember(manifest.id, okFind and found or manifest)
                        end
                    end
                end
            end

            -- Older runtimes/fallback adapters may only expose these tables.
            local sources = {
                rawget(_G, "mods"), rawget(_G, "activeMods"),
                mod and mod.mods, mod and mod.activeMods,
            }
            for _, source in ipairs(sources) do
                if type(source) == "table" then
                    for k, v in pairs(source) do
                        if type(v) == "table" then
                            remember(v.id or v.name or k, v)
                        elseif v == true then
                            remember(k, { id = k })
                        end
                    end
                end
            end
            return out
        end

        local function canonicalCapability(name)
            local key = norm(name)
            return AutoCompat.capabilityAliases[key] or key:lower()
        end

        local function addCapability(caps, name)
            caps[name] = true
            caps[canonicalCapability(name)] = true
        end

        local function detectCapabilities(id)
            local caps = {}
            -- These are behavior-family hints, not enforcement branches. They
            -- allow current released mods that predate our API to be described
            -- until they adopt provider registration themselves.
            --
            -- 2.4.97: activeMods() normalizes existing separators but cannot
            -- infer word boundaries in compact IDs such as CatchHelper. Match
            -- both separated and joined spellings for every multi-word hint.
            local function has(separated, joined)
                if id:find(separated, 1, true) then return true end
                return joined ~= nil and id:find(joined, 1, true) ~= nil
            end

            if id:find("BAG",1,true) then addCapability(caps, "alternate_item_ui") end
            if has("ITEM_SHORTCUT", "ITEMSHORTCUT") or id:find("REPEL",1,true) then
                addCapability(caps, "automatic_item_use")
            end
            if id:find("BOX",1,true) or id:find("PC",1,true) then addCapability(caps, "alternate_pc_ui") end
            if id:find("DEXNAV",1,true) or id:find("SUMMON",1,true) then
                addCapability(caps, "external_encounter_start")
            end
            if id:find("DEXNAV",1,true) or id:find("SUMMON",1,true) then
                -- DexNav chooses from a live registry; Summon chooses an
                -- explicit species. Both are targeted encounter selectors.
                addCapability(caps, "encounter_selector")
            end
            if has("CATCH_HELPER", "CATCHHELPER") then
                -- Current Catch Helper both presents catch information and
                -- intentionally retunes Ultra Ball capture math.
                addCapability(caps, "capture_mechanics")
                addCapability(caps, "battle_information")
            end
            if id == "OVERWORLD_WILD_SPAWNS"
                or id == "OVERWORLDWILDSPAWNS" then
                addCapability(caps, "external_encounter_start")
                addCapability(caps, "capture_mechanics")
            end
            if id == "MODERN_PARTY_UI"
                or id == "MODERNPARTYUI" then
                addCapability(caps, "party_presentation")
            end
            if id == "KANTO_ASCENDANT"
                or id == "KANTO-ASCENDANT"
                or id == "KANTOASCENDANT" then
                -- Kanto Ascendant 6.5.4 owns badge-phased trainer/wild
                -- difficulty and additional Trainer Card presentation.
                -- Classify those surfaces explicitly so Nuzlocke can compose
                -- instead of stacking its own difficulty transforms.
                addCapability(caps, "difficulty")
                addCapability(caps, "trainer_levels")
                addCapability(caps, "wild_levels")
                addCapability(caps, "trainer_card_presentation")
            end
            if id:find("POKEDEX",1,true) or has("MOVES_MANAGER", "MOVESMANAGER") then addCapability(caps, "registry_consumer") end
            if has("EXP_SHARE", "EXPSHARE") then addCapability(caps, "exp_distribution") end
            if has("QUEST_SYSTEM", "QUESTSYSTEM") then
                addCapability(caps, "quest_framework")
                addCapability(caps, "quest_presentation")
            elseif id:find("QUEST",1,true) then
                addCapability(caps, "quest_provider")
            end
            if has("REUSABLE_MACHINE", "REUSABLEMACHINE") or id:find("TM",1,true) then addCapability(caps, "machine_provider") end
            if id:find("RANDOMIZER",1,true) then addCapability(caps, "randomizer_provider") end
            if has("LEVEL_CAP", "LEVELCAP") then addCapability(caps, "level_cap_provider") end
            if has("RUNNING_SHOE", "RUNNINGSHOE") then addCapability(caps, "running_shoes_provider") end
            if id:find("SNAG",1,true) then addCapability(caps, "trainer_capture_provider") end
            if id:find("BALL",1,true) then addCapability(caps, "custom_ball_provider") end
            return caps
        end

        function AutoCompat.scan()
            -- Automatic legacy adapters are a fresh projection of the active
            -- mod graph. Never let a provider that was disabled/removed remain
            -- registered and keep a Nuzlocke control delegated.
            for id, provider in pairs(Interop.providers) do
                if type(provider) == "table" and provider.automatic == true
                    and provider.source == "legacy_adapter" then
                    Interop.providers[id] = nil
                end
            end
            AutoCompat.detected = {}
            local mods = activeMods()
            for id, info in pairs(mods) do
                if id ~= norm(mod.id or mod.name or "NUZLOCKE") and not Interop.getProvider(id) then
                    local caps = detectCapabilities(id)
                    local any = false; for _, v in pairs(caps) do if v then any=true break end end
                    if any then
                        Interop.registerProvider({id=id, name=info.name or id,
                            capabilities=caps, automatic=true, source="legacy_adapter"})
                        AutoCompat.detected[id] = caps
                    end
                end
            end
            return AutoCompat.detected
        end

        local function pokemonIdentityLite(mon)
            if type(mon) ~= "table" then return nil end
            if mod.exports.__beta26 and mod.exports.__beta26.Identity
                and mod.exports.__beta26.Identity.pokemonIdentity then
                local ok, id = pcall(mod.exports.__beta26.Identity.pokemonIdentity, mon)
                if ok and id then return tostring(id) end
            end
            return tostring(mon.id or mon.personality or mon.uid or "") .. ":" .. tostring(mon.species or "")
        end

        local function collectMons(game)
            local out = {}
            local save = game and game.save
            for _, mon in ipairs(save and save.party or {}) do out[#out+1]=mon end
            mod.exports.__beta26.forEachExistingSaveBox(save, function(box)
                for _, mon in pairs(box) do
                    if type(mon)=="table" and mon.species then out[#out+1]=mon end
                end
            end)
            return out
        end

        function AutoCompat.snapshotPokemon(game)
            game=game or getCurrentGame() or mod.game
            local snap={}
            for _, mon in ipairs(collectMons(game)) do
                local id=pokemonIdentityLite(mon)
                if id and id ~= ":" then snap[id]={mon=mon,species=mon.species} end
            end
            return snap
        end

        function AutoCompat.reconcilePokemon(game, sourceHint)
            game=game or getCurrentGame() or mod.game
            local now=AutoCompat.snapshotPokemon(game)
            local before=AutoCompat.lastParty
            for id, row in pairs(now) do
                if not before[id] then
                    local mon=row.mon
                    local ctx={game=game, pokemon=mon, species=mon and mon.species,
                        sourceId=sourceHint, kind=(sourceHint and "quest" or "scripted"),
                        areaId=(game and game.map and (game.map.id or game.map.name))}
                    local result=Acquisition.begin(ctx)
                    Interop.emit("legacy_acquisition_detected", {context=ctx,result=result,mon=mon})
                end
            end
            AutoCompat.lastParty=now
            return now
        end


        -- 2.4.11: Wilds of Kanto 2.1.7 can complete an overworld Ball catch
        -- without entering the engine's normal battle-capture lifecycle.  Its
        -- public exports expose the live catching object and GameCompat facade,
        -- so compose at those exported seams instead of patching Wilds files.
        --
        -- Pre-commit: convert a successful overworld wobble into a normal escape
        -- when Nuzlocke capture policy rejects the target.  The consumed Ball is
        -- refunded, matching the native denied-Ball path, and Wilds keeps the
        -- entity alive/aggro-capable through its own failure resolver.
        --
        -- Post-commit: emit the standard pokemon.caught event after Wilds has
        -- successfully placed the Pokemon in party/box.  This reuses Nuzlocke's
        -- proven tracker/provenance listener instead of duplicating tracker code.
        function AutoCompat.installWildsOfKanto()
            local okFind, wilds = pcall(mod.find, "overworld_wild_spawns")
            if not okFind or type(wilds) ~= "table"
                or type(wilds.exports) ~= "table" then
                return false, "not_loaded"
            end
            local exports = wilds.exports
            local catching = exports.catching
            local gameCompat = exports.gameCompat
            if type(catching) ~= "table" or type(catching._resolveCapture) ~= "function"
                or type(gameCompat) ~= "table"
                or type(gameCompat.giveCaughtPokemon) ~= "function" then
                return false, "unsupported_surface"
            end

            local prior = catching.__nuzlockeCompat2411
            if type(prior) == "table" and prior.owner == mod
                and catching._resolveCapture == prior.resolveWrapper
                and gameCompat.giveCaughtPokemon == prior.giveWrapper then
                return true
            end
            if type(prior) == "table" then
                if catching._resolveCapture == prior.resolveWrapper
                    and type(prior.previousResolve) == "function" then
                    catching._resolveCapture = prior.previousResolve
                end
                if gameCompat.giveCaughtPokemon == prior.giveWrapper
                    and type(prior.previousGive) == "function" then
                    gameCompat.giveCaughtPokemon = prior.previousGive
                end
            end

            local previousResolve = catching._resolveCapture
            local previousGive = gameCompat.giveCaughtPokemon

            local function syntheticBattle(game, cap, mon)
                local enemyMon = mon or {
                    species = cap and cap.species,
                    shiny = cap and cap.entity and cap.entity.shiny,
                    variant = cap and cap.entity and cap.entity.variant,
                    level = cap and cap.level,
                }
                return {
                    game = game,
                    wild = true,
                    overworld = true,
                    isOverworld = true,
                    overworldEncounter = true,
                    source = "overworld",
                    encounterType = "overworld",
                    nuzlockeEncounterMethod = "overworld",
                    nuzlockeProgressionRequired = cap
                        and cap.nuzlockeProgressionRequired or nil,
                    nuzlockeAllowProgressionException = cap
                        and cap.nuzlockeAllowProgressionException or nil,
                    nuzlockeProgressionCatch = cap
                        and cap.nuzlockeProgressionCatch or nil,
                    nuzlockeProgressionCatchReason = cap
                        and cap.nuzlockeProgressionCatchReason or nil,
                    nuzlockeProgressionCatchPermanent = cap
                        and cap.nuzlockeProgressionCatchPermanent or nil,
                    enemy = { mon = enemyMon },
                }
            end

            local resolveWrapper
            resolveWrapper = function(self, game, ow, caught)
                if caught == true and active(game, nil)
                    and type(catchDeniedReason) == "function" then
                    local cap = self and self.activeCapture
                    local species = cap and cap.species
                    local battle = syntheticBattle(game, cap)
                    local okPolicy, reason = pcall(catchDeniedReason,
                        game, battle, species)
                    if okPolicy and battle.nuzlockeProgressionCatch == true
                        and type(cap) == "table" then
                        -- This provider settles the caught mon in a separate
                        -- giveCaughtPokemon callback, so carry the semantic
                        -- exception across that transaction boundary. The later
                        -- synthetic battle then reaches the shared pokemon.caught
                        -- handler with the same permanent PC-lock decision.
                        cap.nuzlockeProgressionCatch = true
                        cap.nuzlockeProgressionCatchReason =
                            battle.nuzlockeProgressionCatchReason
                        cap.nuzlockeProgressionCatchPermanent = true
                    end
                    if okPolicy and reason then
                        if self and type(self._refundBall) == "function"
                            and cap and cap.ballType then
                            pcall(self._refundBall, self, game, cap.ballType)
                        end
                        if self and self.hud
                            and type(self.hud.showFeedback) == "function" then
                            pcall(self.hud.showFeedback, self.hud,
                                "NUZLOCKE!", 0.85)
                        end
                        return previousResolve(self, game, ow, false)
                    end
                end
                return previousResolve(self, game, ow, caught)
            end

            local giveWrapper
            giveWrapper = function(game, mon, context)
                local result = previousGive(game, mon, context)
                if type(mon) == "table" and active(game, nil)
                    and type(result) == "table"
                    and (result.destination == "party"
                        or result.destination == "box") then
                    local cap = catching and catching.activeCapture
                    local battle = syntheticBattle(game, cap, mon)
                    -- Provider provenance is attached before the normal listener
                    -- runs so Catch Info/Tracker retain the actual acquisition
                    -- source even though no BattleState owned this catch.
                    mon.nuzlockeEncounterSource = "provider"
                    mon.nuzlockeEncounterProvider = "overworld_wild_spawns"
                    mon.nuzlockeEncounterProviderVersion =
                        tostring(exports.version or "")
                    if mod.events and type(mod.events.emit) == "function" then
                        pcall(mod.events.emit, mod.events, "pokemon.caught", {
                            game = game,
                            battle = battle,
                            mon = mon,
                            species = mon.species
                                or (context and context.species),
                            source = "overworld_wild_spawns",
                            ball = cap and cap.ballType,
                        })
                    end
                end
                return result
            end

            catching._resolveCapture = resolveWrapper
            gameCompat.giveCaughtPokemon = giveWrapper
            catching.__nuzlockeCompat2411 = {
                owner = mod,
                previousResolve = previousResolve,
                previousGive = previousGive,
                resolveWrapper = resolveWrapper,
                giveWrapper = giveWrapper,
                providerVersion = tostring(exports.version or ""),
            }
            return true
        end

        -- Modern Party UI intentionally preserves the engine party controller and
        -- owns presentation records only.  Record that relationship explicitly;
        -- no controller monkey-patch is necessary or desirable.
        function AutoCompat.noteModernPartyUI()
            local okFind, partyUI = pcall(mod.find, "modern_party_ui")
            if not okFind or type(partyUI) ~= "table" then return false end
            local provider = Interop.getProvider("MODERN_PARTY_UI")
            if not provider then
                Interop.registerProvider({
                    id = "MODERN_PARTY_UI",
                    name = "Modern Party UI",
                    capabilities = { party_presentation = true },
                    automatic = true,
                    source = "audited_adapter",
                })
            end
            return true
        end

        -- 2.4.12: Kanto Ascendant 6.5.4 explicitly owns its
        -- badge-phased difficulty curve and expanded Trainer Card presentation.
        -- Registration is metadata/composition only: do not patch Ascendant's
        -- trainer.party, encounter.species, randomizer, follower, or storage code.
        function AutoCompat.noteKantoAscendant()
            local ids = {
                "kanto_ascendant",
                "kanto-ascendant",
                "kantoascendant",
            }
            local found = nil
            for _, id in ipairs(ids) do
                local okFind, candidate = pcall(mod.find, id)
                if okFind and type(candidate) == "table" then
                    found = candidate
                    break
                end
            end
            if not found then return false end

            local provider = Interop.getProvider("KANTO_ASCENDANT")
            if not provider then
                Interop.registerProvider({
                    id = "KANTO_ASCENDANT",
                    name = "Kanto Ascendant",
                    capabilities = {
                        difficulty = true,
                        trainer_levels = true,
                        wild_levels = true,
                        trainer_card_presentation = true,
                    },
                    automatic = true,
                    source = "audited_adapter",
                    version = "6.5.4",
                })
            end
            return true
        end

        function AutoCompat.beforeExternalItemUse(context)
            return ItemAPI.beforeUse(context)
        end

        function AutoCompat.beforeExternalEncounter(context)
            context=type(context)=="table" and context or {}
            if not context.kind then
                local source=norm(context.source or context.sourceId)
                context.kind=source:find("SUMMON",1,true) and "summon" or "wild"
            end
            return EncounterAPI.evaluate(context)
        end

        function AutoCompat.beforeExternalPCAction(context)
            return PartyPC.evaluate(context)
        end

        function AutoCompat.registrySnapshot(game)
            return Registry.describe(game)
        end

        function AutoCompat.install()
            AutoCompat.scan()
            AutoCompat.lastParty=AutoCompat.snapshotPokemon(getCurrentGame() or mod.game)
            Interop.emit("legacy_adapters_ready", {detected=AutoCompat.detected})
            return true
        end

        -- Re-scan after the mod graph is authoritative. Reconciliation is
        -- deliberately observational: it never deletes an externally granted
        -- Pokémon. It emits provenance/policy information so existing recovery
        -- and provider paths can classify it safely instead of crashing or
        -- silently pretending it was a vanilla catch.
        mod.events:on("mods.loaded", function()
            pcall(AutoCompat.install)
            pcall(AutoCompat.installWildsOfKanto)
            pcall(AutoCompat.noteModernPartyUI)
            pcall(AutoCompat.noteKantoAscendant)
        end)
        mod.events:on("game.ready", function(ev)
            local game=type(ev)=="table" and ev.game or ev
            pcall(AutoCompat.install)
            pcall(AutoCompat.installWildsOfKanto)
            pcall(AutoCompat.noteModernPartyUI)
            pcall(AutoCompat.noteKantoAscendant)
            pcall(AutoCompat.reconcilePokemon, game or getCurrentGame() or mod.game)
        end)
        mod.events:on("save.loaded", function()
            pcall(AutoCompat.install)
            pcall(AutoCompat.installWildsOfKanto)
            pcall(AutoCompat.noteModernPartyUI)
            pcall(AutoCompat.noteKantoAscendant)
            pcall(AutoCompat.reconcilePokemon, getCurrentGame() or mod.game)
        end)

        mod.exports.nuzlocke = mod.exports.nuzlocke or {}
        mod.exports.nuzlocke.api = 1
        mod.exports.nuzlocke.build = mod.exports.__beta26.build
        mod.exports.nuzlocke.interop = Interop
        mod.exports.nuzlocke.compatibility = {
            api = mod.exports.__beta26.compatibilityApi,
            compatible_from = mod.exports.nuzlocke_compat
                and mod.exports.nuzlocke_compat.compatible_from or 10,
            audited_recomp = mod.exports.__beta26.recompCompatAudited,
            provider_inventory = true,
            engine_profile_introspection = true,
        }
        mod.exports.nuzlocke.ownership = {
            -- External providers may own mechanics/presentation; Nuzlocke
            -- remains the challenge-policy authority unless a selected rule
            -- explicitly delegates that policy.
            item_presentation="provider",
            item_use_entrypoint="provider",
            item_mechanics="provider",
            machine_mechanics="provider",
            item_policy="nuzlocke",
            encounter_mechanics="provider",
            encounter_selection="provider",
            encounter_policy="nuzlocke",
            capture_mechanics="provider",
            capture_policy="nuzlocke",
            battle_information="provider",
            quest_framework="provider",
            quest_presentation="provider",
            quest_content="provider",
            quest_reward_policy="source_mod",
            storage_mechanics="provider",
            exp_distribution="provider",
            exp_cap_policy="nuzlocke",
            challenge_policy="nuzlocke",
            provenance="nuzlocke",
        }
        mod.exports.nuzlocke.capabilities = {
            acquisition_policy=true, item_policy=true, effective_registry=true,
            registry_notifications=true, provider_registration=true,
            exp_post_distribution_seam=true, pc_policy=true,
            storage_transaction_policy=true, storage_swap_policy=true,
            encounter_entry_policy=true, encounter_information_policy=true,
            encounter_selection_policy=true, encounter_spend_indicator=true,
            final_encounter_registry=true,
            capture_mechanics=true, capture_policy=true, battle_information=true,
            quest_framework=true, quest_presentation=true, quest_content=true,
            alternate_item_ui=true,
            item_presentation=true, item_use_entrypoint=true,
            machine_mechanics=true, exp_distribution=true, exp_cap_policy=true,
            registry_revision=true, content_provider=true,
            dynamic_areas=true, dynamic_dungeons=true, quest_acquisitions=true,
            custom_boss_metadata=true, randomizer_opt_out=true,
            legacy_auto_adapter=true, passive_acquisition_detection=true,
        }
        mod.exports.nuzlocke.acquisitionPolicy = Acquisition
        mod.exports.nuzlocke.itemPolicy = ItemAPI
        mod.exports.nuzlocke.registry = Registry
        mod.exports.nuzlocke.experience = Experience
        mod.exports.nuzlocke.pcPolicy = PartyPC
        mod.exports.nuzlocke.encounterPolicy = EncounterAPI
        mod.exports.nuzlocke.content = Content
        mod.exports.nuzlocke.autoCompat = AutoCompat
        mod.exports.nuzlocke.delegation = {
            api = 1,
            statusForRule = function(key, game)
                return externalRuleDelegation and externalRuleDelegation(key, game) or nil
            end,
            rules = function() return NON_CORE_DELEGATION or {} end,
        }
        mod.exports.registerNuzlockeProvider = Interop.registerProvider
        -- Compatibility aliases for consumers written against the older
        -- nuzlocke_compat export. Keep these additive and read-only.
        if mod.exports.nuzlocke_compat then
            mod.exports.nuzlocke_compat.interop = mod.exports.nuzlocke
            mod.exports.nuzlocke_compat.evaluateItemUse = ItemAPI.evaluate
            mod.exports.nuzlocke_compat.evaluateAcquisition = Acquisition.evaluate
            mod.exports.nuzlocke_compat.effectiveRegistries = Registry.describe
            mod.exports.nuzlocke_compat.evaluateStorageTransaction = PartyPC.evaluate
            mod.exports.nuzlocke_compat.encounterInformation = Registry.encounterInformation
            mod.exports.nuzlocke_compat.encounterSelection = Registry.encounterSelection
            mod.exports.nuzlocke_compat.canSelectEncounter = Registry.canSelectEncounter
            mod.exports.nuzlocke_compat.encounterSpendIndicator =
                function(battle)
                    return mod.exports.__beta26.encounterSpendIndicator
                        and mod.exports.__beta26.encounterSpendIndicator(battle)
                        or nil
                end
            mod.exports.nuzlocke_compat.content = Content
            mod.exports.nuzlocke_compat.registerContentBundle = Content.registerBundle
            mod.exports.nuzlocke_compat.autoCompat = AutoCompat
            mod.exports.nuzlocke_compat.scanCompatibility = AutoCompat.scan
            mod.exports.nuzlocke_compat.resolveCapability = Interop.resolveCapability
            mod.exports.nuzlocke_compat.hasProviderCapability = Interop.hasCapability
            mod.exports.nuzlocke_compat.providersWithCapability = Interop.providersWith
            mod.exports.nuzlocke_compat.listProviders = Interop.listProviders
            mod.exports.nuzlocke_compat.providerCount = Interop.providerCount
        end
    end
  return mod.exports.nuzlocke
end
