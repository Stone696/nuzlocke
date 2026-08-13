-- Nuzlocke Rules 2.0.0-beta.29.1.0 - Gen1Recomp 0.1.83 compatibility hardening
-- Built directly from beta.29.0.2 with no intended gameplay behavior change.
-- Numeric lineage: beta.27 -> beta.27.1 -> beta.27.2 -> beta.27.3 -> beta.27.4 -> beta.27.5 -> beta.27.6 -> beta.27.7 -> beta.27.8 -> beta.27.9 -> beta.27.10 -> beta.27.11 -> beta.27.12 -> beta.27.13 -> beta.27.14 -> beta.27.15 -> beta.27.16 -> beta.28 -> beta.28.1 -> beta.28.2 -> beta.28.3 -> beta.28.4 -> beta.28.5 -> beta.28.6 -> beta.28.7 -> beta.28.8 -> beta.28.9 -> beta.28.10 -> beta.28.11 -> beta.28.12 -> beta.28.13 -> beta.28.14 -> beta.28.15 -> beta.28.16 -> beta.28.17 -> beta.28.18 -> beta.28.19 -> beta.28.20 -> beta.29.0.0 -> beta.29.0.1 -> beta.29.0.2 -> beta.29.1.0.
--
-- Lineage:
-- * beta.26 is promoted directly from the runtime-tested 26B10 development revision
-- * 26B10 descended forward from the published 25D4-RBY2 startup/menu hotfix
-- * older branches are reference material only; missing behavior is ported surgically after comparison
-- * schema 4 and the established persisted rule surface remain preserved
-- * Gold-only adapters remain isolated behind explicit generation checks
--
-- BETA.29 PROTECTED RUNTIME / FOLLOW-UP NOTES
-- * Runtime PASS: Gold NEW GAME reaches Nuzlocke Setup; collapsible Setup
--   sections function.
-- * Runtime PASS: Yellow existing-save numeric/config selection uses A or
--   Left/Right instead of consuming Up/Down navigation; collapsible sections
--   function and broad rule behavior was reported healthy.
-- * UI follow-up: use native directional glyphs for collapsible headers and
--   add explicit UI-composition support for Setup Rules, in-game Rules,
--   Encounter Tracker Map/Log, R/B/Y Nuz Status, and Catch Info.
-- * Data/UI follow-up: distinguish missed/lost encounters from Pokemon deaths
--   without corrupting historical save data that used older LOST bookkeeping.
return function(mod)
  mod.exports.__beta26 = { build = "beta.29.1.0", setupProfileScope = "gen1" }
  mod.exports.__beta25 = mod.exports.__beta26

  -- beta.27.4: Gen1Recomp's embedded Save Editor creates its own ModLoader
  -- inside the same Lua process. Runtime monkey patches installed from that
  -- editor loader can otherwise survive App.unload() in package.loaded and
  -- retain the editor session's mod.save closure when gameplay starts.
  -- Detect the editor without requiring its module: App.load has already put
  -- the flat `App` module in package.loaded and getState() is non-nil only
  -- while the editor session is actually open.
  mod.exports.__beta26.isSaveEditorSession = function()
      local loaded = package and package.loaded and package.loaded["App"]
      if type(loaded) ~= "table" or type(loaded.getState) ~= "function" then
          return false
      end
      local ok, state = pcall(loaded.getState)
      return ok and state ~= nil
  end
  mod.exports.__beta26.runtimeEnvironment = function()
      return mod.exports.__beta26.isSaveEditorSession() and "save_editor" or "gameplay"
  end

  local Stats = require("src.pokemon.Stats")
  local Growth = require("src.pokemon.Growth")
  local Strings = require("src.core.Strings")
  -- Public, generation-neutral localization seam for companion mods and
  -- translator test harnesses. English source text remains the stable key;
  -- missing entries safely fall back through the engine's Strings module.
  mod.exports.nuzlocke_translation = {
      api = 1,
      build = "beta.29.1.0",
      get = function(source, ...)
          return Strings(source, ...)
      end,
      source = function(text)
          return Strings.source(text)
      end,
  }
  local catchDeniedReason
  local isTownArea
  local enemyIsShiny
  local currentGame
  local currentSave
  local refreshGymGuideVisibility
  local getGameVersion
  local getDisplayRoutes
  local getEncounterState
  local LEGENDARIES, MYTHICALS, PSEUDOS
  local finalizeNuzlockeBattle
  local evaluateItemUsePolicy
  mod.exports.__beta26.recompCompatAudited = "0.1.83"
  mod.exports.__beta26.wonderlockeWip = true

  ---------------------------------------------------------------------
  -- FUTURE-SAFE SAVE SCHEMA
  --
  -- This layer is intentionally additive and independent of the Lua/mod
  -- version.  A save can skip releases, have the mod removed/reinstalled,
  -- or be loaded by a newer build without being mistaken for a new run.
  -- Migrations are idempotent and never delete or rewrite existing Nuzlocke
  -- gameplay data.  A newer schema is left untouched by older builds.
  ---------------------------------------------------------------------
  local SAVE_SCHEMA_KEY = "__nuzlocke_save_schema"
  local SAVE_MIGRATION_KEY = "__nuzlocke_last_migration"
  local CURRENT_SAVE_SCHEMA = 4
  local saveSchemaTooNew = false
  local saveMigrationError = nil

  local function runSaveMigrations()
      local rawVersion = mod.save:get(SAVE_SCHEMA_KEY, nil)
      local version = tonumber(rawVersion)

      -- Saves from all earlier Nuzlocke versions (and vanilla saves) have no
      -- schema marker. Establish the baseline only; the current beta
      -- reconstruction/default logic remains responsible for gameplay data.
      -- This avoids changing old-save behavior during the upgrade.
      if version == nil then
          version = 0
      end
      version = math.floor(version)

      if version > CURRENT_SAVE_SCHEMA then
          -- Never downgrade or migrate a save produced by a newer build.
          saveSchemaTooNew = true
          saveMigrationError = nil
          return false
      end

      saveSchemaTooNew = false
      saveMigrationError = nil

      while version < CURRENT_SAVE_SCHEMA do
          -- 0 -> 1 is deliberately a marker-only migration.
          -- 1 -> 2 disables the unfinished Wonderlocke mechanic so an older
          -- save cannot leave a WIP feature active after this update.
          -- 2 -> 3 introduces persistent per-Pokemon Nuzlocke identities.
          -- Identity assignment is performed lazily during reconstruction so
          -- old saves can be upgraded without rewriting unrelated Pokemon data.
          -- 3 -> 4 migrates the retired "No Shop" rule into No Buying /
          -- No Selling and upgrades the
          -- old boolean Dupes Clause into OFF / SPECIES / FAMILY mode.
          version = version + 1
          if version == 2 then
              mod.save:set("wonderlocke", false)
          elseif version == 4 then
              local oldShop = mod.save:get("no_shopping", nil)
              if type(oldShop) == "boolean" then
                  if mod.save:get("no_buying", nil) == nil then
                      mod.save:set("no_buying", oldShop)
                  end
                  if mod.save:get("no_selling", nil) == nil then
                      mod.save:set("no_selling", oldShop)
                  end
              end

              local oldDupes = mod.save:get("dupes_mode", nil)
              if type(oldDupes) == "boolean" then
                  mod.save:set("dupes_mode", oldDupes and 2 or 0)
              end
          end
          mod.save:set(SAVE_SCHEMA_KEY, version)
          mod.save:set(SAVE_MIGRATION_KEY, "v" .. tostring(version))
      end

      return true
  end

  -- Register before the other save.loaded handlers below so future migration
  -- steps can always run before reconstruction/rule synchronization.
  mod.events:on("save.loaded", function()
      local ok, err = pcall(runSaveMigrations)
      if not ok then
          saveMigrationError = tostring(err)
      end
  end)

  mod.events:on("game.ready", function(ev)
      local game = type(ev) == "table" and ev.game or ev
      currentGame = game or currentGame
      currentSave = (game and game.save) or currentSave
      -- Wonderlocke is WIP and cannot be enabled in this beta.
      if mod.exports.__beta26.wonderlockeWip
          and mod.save:get("wonderlocke", false) ~= false then
          mod.save:set("wonderlocke", false)
      end
  end)

  ---------------------------------------------------------------------
  -- INTER-MOD COMPATIBILITY / PROVIDER REGISTRY
  -- Capability-based only; never match mod names/descriptions.
  -- Providers are discovered from active loaded mods and revalidated with
  -- mod.find() at point of use, so disabled/failed mods do not interfere.
  -- Supported capabilities: level_caps, postgame_caps, escape, encounters, npc_talk,
  -- npc_behavior, npc_visibility, npc_movement. NPC capabilities are optional
  -- ownership declarations; vanilla NPC behavior remains ours unless another
  -- mod explicitly exports a provider.
  ---------------------------------------------------------------------
  local COMPAT_PROVIDERS = {
      level_caps = nil, postgame_caps = nil, escape = nil, encounters = nil,
      npc_talk = nil, npc_behavior = nil, npc_visibility = nil, npc_movement = nil,
      wonder_trade = nil, pokemon_identity = nil, species_metadata = nil,
  }
  local COMPAT_CAPABILITIES = {
      "level_caps", "postgame_caps", "escape", "encounters",
      "npc_talk", "npc_behavior", "npc_visibility", "npc_movement", "wonder_trade",
      "pokemon_identity", "species_metadata",
      -- beta.27.3: compatibility negotiation also advertises the shared engine
      -- surfaces most likely to be wrapped by other gameplay/UI mods. These are
      -- metadata/handshake capabilities; merely discovering one does not give a
      -- third-party mod ownership of Nuzlocke policy.
      "item_use", "shopping", "healing", "battle_finish", "trainer_card", "party_menu",
      "start_menu_items", "screens", "static_encounters", "gambling",
      "encounter_area_projection", "trainer_party", "boss_level_caps",
      "battle_classification", "movement_speed", "starter_randomization",
  }

  -- COMPATIBILITY LAYERS (beta.27.4)
  -- Keep engine-version compatibility separate from inter-mod cooperation.
  -- This namespace is deliberately hung from the existing beta export table so
  -- the giant main chunk does not accumulate another batch of long-lived locals.
  mod.exports.__beta26.compat = {
      Engine = {
          audited = mod.exports.__beta26.recompCompatAudited,
          active_profile = mod.exports.__beta26.recompCompatAudited,
          profiles = {
              ["0.1.78"] = {
                  api = 2, save_format = 4,
                  generation = { gen1 = true, gold = true },
                  note = "Published compatibility floor; protected historical runtime behavior.",
              },
              ["0.1.79"] = {
                  api = 2, save_format = 4,
                  generation = { gen1 = true, gold = true },
                  note = "Protected audited profile for the first expanded Gold compatibility build.",
              },
              ["0.1.80"] = {
                  api = 2, save_format = 4,
                  generation = { gen1 = true, gold = true },
                  note = "Gold Pack, battle replacement, naming, mart, and movement update profile.",
              },
              ["0.1.81"] = {
                  api = 2, save_format = 4,
                  generation = { gen1 = true, gold = true },
                  note = "Protected audited profile; public hooks/events and guarded Gold transaction seams verified.",
              },
              ["0.1.82"] = {
                  api = 2, save_format = 4,
                  generation = { gen1 = true, gold = true },
                  note = "Source-audited profile; protected battle, item, shop, save, and Gold script seams remain available.",
              },
              ["0.1.83"] = {
                  api = 2, save_format = 4,
                  generation = { gen1 = true, gold = true },
                  note = "Current source-audited profile; Mod API/save format are preserved and Gold mapOverview is additive.",
              },
          },
          seams = {
              item_use = { generation = "gen1", module = "src.inventory.ItemEffects", member = "use", mode = "compose" },
              battle_finish = { generation = "gen1", module = "src.battle.BattleState", member = "finish", mode = "compose" },
              gold_battle_finish = { generation = "gold", module = "src.ui.gen2.BattleState", member = "finishBattle", mode = "compose" },
              trainer_card = { generation = "gen1", module = "src.ui.TrainerCard", mode = "compose" },
              gold_trainer_card = { generation = "gold", module = "src.ui.gen2.TrainerCard", mode = "deprecated_for_nuz_status" },
              start_menu_items = { generation = "shared", hook = "ui.start_menu.items", mode = "compose" },
              pokemon_caught = { generation = "shared", event = "pokemon.caught", mode = "observe" },
              script_command = { generation = "shared", hook = "script.command", mode = "compose" },
              screens = { generation = "shared", registry = "screens", mode = "augment" },
          },
          -- beta.27.5: ask Gen1Recomp's own Gen2Compat table what a private
          -- Gen 1 module/member really means on Gold. This is diagnostic and
          -- capability-reporting only; it does not auto-rewrite protected hooks.
          gen2 = {
              coverage = function(name)
                  local ok, compat = pcall(require, "src.mods.Gen2Compat")
                  if not ok or type(compat) ~= "table"
                      or type(compat.coverage) ~= "function" then
                      return nil
                  end
                  local row = compat.coverage(name)
                  if type(row) == "table" then
                      row.coverageVersion = compat.COVERAGE_VERSION
                  end
                  return row
              end,
              memberStatus = function(name, member)
                  local ok, compat = pcall(require, "src.mods.Gen2Compat")
                  if not ok or type(compat) ~= "table"
                      or type(compat.memberStatus) ~= "function" then
                      return nil
                  end
                  return compat.memberStatus(name, member)
              end,
              modules = function()
                  local ok, compat = pcall(require, "src.mods.Gen2Compat")
                  if not ok or type(compat) ~= "table"
                      or type(compat.modules) ~= "function" then
                      return {}
                  end
                  return compat.modules()
              end,
          },
          environments = {
              gameplay = { runtime_patches = true, save_bound = true },
              save_editor = {
                  runtime_patches = false,
                  save_bound = false,
                  note = "Editor loader is data/catalog-only for Nuzlocke; skip direct runtime monkey patches so editor closures cannot leak into gameplay.",
              },
          },
          state = {},
      },
      Mods = {
          supported_relationships = {
              compose = true,
              delegate = true,
              exclusive = true,
              observe = true,
              incompatible = true,
          },
          defaults = {
              level_caps = "delegate",
              postgame_caps = "delegate",
              escape = "delegate",
              encounters = "compose",
              npc_talk = "compose",
              npc_behavior = "compose",
              npc_visibility = "compose",
              npc_movement = "compose",
              wonder_trade = "observe",
              pokemon_identity = "delegate",
              species_metadata = "delegate",
              item_use = "compose",
              shopping = "compose",
              healing = "compose",
              battle_finish = "compose",
              trainer_card = "compose",
              party_menu = "compose",
              start_menu_items = "compose",
              screens = "compose",
              static_encounters = "compose",
              gambling = "compose",
              encounter_area_projection = "compose",
              trainer_party = "compose",
              boss_level_caps = "compose",
              battle_classification = "observe",
              movement_speed = "compose",
              starter_randomization = "compose",
          },
          relationships = {},
          discovered = {},
      },
  }

  -- Normalize only declarative metadata. Discovery never executes another
  -- mod's callbacks simply to decide whether we can coexist.
  mod.exports.__beta26.compat.Mods.normalizeRelationship = function(value)
      if type(value) == "table" then
          value = value.relationship or value.mode or value.policy
      end
      local key = tostring(value or ""):lower()
      if mod.exports.__beta26.compat.Mods.supported_relationships[key] then
          return key
      end
      return nil
  end

  mod.exports.__beta26.compat.Mods.inspectRelationship = function(exports, capability)
      local layer = type(exports) == "table" and exports.nuzlocke_compat or nil
      if type(layer) ~= "table" and type(exports) == "table" then
          layer = exports.compat
      end
      if type(layer) == "table" then
          local rels = layer.relationships or layer.compatibility_relationships
          local declared = type(rels) == "table" and rels[capability] or nil
          if declared == nil and type(rels) == "table" and type(rels.defaults) == "table" then
              declared = rels.defaults[capability]
          end
          if declared == nil and type(rels) == "table" and type(rels.capabilities) == "table" then
              declared = rels.capabilities[capability]
          end
          local relation = mod.exports.__beta26.compat.Mods.normalizeRelationship(declared)
          if relation then return relation, "declared" end

          local ownership = layer.ownership
          if type(ownership) == "table" and ownership[capability] ~= nil then
              relation = mod.exports.__beta26.compat.Mods.normalizeRelationship(ownership[capability])
              if relation then return relation, "ownership" end
              if ownership[capability] == true then return "exclusive", "ownership" end
          end

          local cooperation = layer.cooperation
          local allows = type(cooperation) == "table" and cooperation.allows_wrapping or nil
          if type(allows) == "table" then
              for _, allowed in ipairs(allows) do
                  if tostring(allowed) == tostring(capability) then
                      return "compose", "allows_wrapping"
                  end
              end
          end
      end

      -- Backward-compatible provider metadata also participates in the new
      -- relationship report. This honors the pre-v11 `exclusive = true`
      -- convention without requiring another mod to adopt our exact table shape.
      if type(exports) == "table" then
          local providers = exports.nuzlocke_provider
          local provider = type(providers) == "table" and providers[capability]
              or exports[capability]
          if type(provider) == "table" then
              local relation = mod.exports.__beta26.compat.Mods.normalizeRelationship(
                  provider.relationship or provider.mode or provider.policy)
              if relation then return relation, "provider" end
              if provider.exclusive == true then return "exclusive", "provider" end
          end
      end
      return mod.exports.__beta26.compat.Mods.defaults[capability] or "compose", "default"
  end

  mod.exports.__beta26.compat.Mods.relationshipFor = function(modId, capability)
      local rows = mod.exports.__beta26.compat.Mods.relationships[modId]
      return type(rows) == "table" and rows[capability]
          or mod.exports.__beta26.compat.Mods.defaults[capability]
          or "compose"
  end

  mod.exports.__beta26.compat.Mods.report = function()
      return {
          supported_relationships = mod.exports.__beta26.compat.Mods.supported_relationships,
          defaults = mod.exports.__beta26.compat.Mods.defaults,
          relationships = mod.exports.__beta26.compat.Mods.relationships,
          discovered = mod.exports.__beta26.compat.Mods.discovered,
      }
  end

  local function providerValue(exports, capability)
      if type(exports) ~= "table" then return nil end
      local providers = exports.nuzlocke_provider
      if type(providers) == "table" and providers[capability] ~= nil then return providers[capability] end
      return exports[capability]
  end

  local function providerIsActive(provider, game, battle)
      if not provider then return false end
      if type(provider) == "table" then
          if provider.enabled == false or provider.active == false
              or provider.disabled == true then return false end
      end
      if type(provider) == "table" and type(provider.is_active) == "function" then
          local ok, result = pcall(provider.is_active, game, battle)
          return ok and result == true
      end
      return true
  end

  local function discoverCompatProviders(loader)
      for _, capability in ipairs(COMPAT_CAPABILITIES) do COMPAT_PROVIDERS[capability] = nil end
      mod.exports.__beta26.compat.Mods.relationships = {}
      mod.exports.__beta26.compat.Mods.discovered = {}
      if not loader or type(loader.status) ~= "function" then return end
      local ok, status = pcall(function() return loader:status() end)
      if not ok or type(status) ~= "table" or type(status.loaded) ~= "table" then return end
      for _, manifest in ipairs(status.loaded) do
          local id = manifest and manifest.id
          if id and id ~= "nuzlocke" then
              local foundOk, other = pcall(mod.find, id)
              if foundOk and other and other.exports then
                  local compatLayer = type(other.exports.nuzlocke_compat) == "table"
                      and other.exports.nuzlocke_compat
                      or (type(other.exports.compat) == "table" and other.exports.compat or nil)
                  mod.exports.__beta26.compat.Mods.discovered[id] = {
                      version = other.version or (manifest and manifest.version),
                      compat_api = compatLayer and compatLayer.version or nil,
                      has_compat_layer = compatLayer ~= nil,
                  }
                  mod.exports.__beta26.compat.Mods.relationships[id] = {}
                  for _, capability in ipairs(COMPAT_CAPABILITIES) do
                      local relationship = mod.exports.__beta26.compat.Mods.inspectRelationship(
                          other.exports, capability)
                      mod.exports.__beta26.compat.Mods.relationships[id][capability] = relationship
                      if relationship ~= "incompatible" and not COMPAT_PROVIDERS[capability] then
                          local value = providerValue(other.exports, capability)
                          if value ~= nil then
                              COMPAT_PROVIDERS[capability] = {
                                  id=id, version=other.version, value=value,
                                  relationship=relationship,
                              }
                          end
                      end
                  end
              end
          end
      end
  end

  local function activeCompatProvider(capability, game, battle)
      local provider = COMPAT_PROVIDERS[capability]
      if not provider then return nil end
      local ok, other = pcall(mod.find, provider.id)
      if not ok or not other or not other.exports then COMPAT_PROVIDERS[capability]=nil; return nil end
      local value = providerValue(other.exports, capability)
      if value == nil or not providerIsActive(value, game, battle) then COMPAT_PROVIDERS[capability]=nil; return nil end
      provider.value=value; provider.version=other.version
      return provider
  end

  local function providerContext(provider, game, battle)
      local value=provider and provider.value
      if type(value)~="table" or type(value.get_context)~="function" then return nil end
      local ok, context=pcall(value.get_context, game, battle)
      return ok and type(context)=="table" and context or nil
  end

  local function providerRecover(provider, save, mon)
      local value=provider and provider.value
      if type(value)~="table" or type(value.recover)~="function" then return nil end
      local ok, result=pcall(value.recover, save, mon)
      return ok and type(result)=="table" and result or nil
  end

  -- Providers can explicitly declare a mechanic exclusive. The default is
  -- composable: touching the same engine subsystem is not the same thing as
  -- owning the Nuzlocke behavior. Mods may modify or observe NPC systems
  -- without owning the Gym Guide or Nuzlocke encounter rules.
  local function providerExclusive(capability, game, battle)
      local provider = activeCompatProvider(capability, game, battle)
      local value = provider and provider.value
      if not provider then return false end
      local relationship = mod.exports.__beta26.compat.Mods.relationshipFor(provider.id, capability)
      return relationship == "exclusive"
          or (type(value) == "table" and value.exclusive == true)
  end

  -- The engine's talk registry can tell us whether a callable talk entry came
  -- from a mod. This is safer than guessing from a mod name or description,
  -- and uses the registry provenance metadata rather than guessing from names.
  -- Instruction-list entries are data and are safe to inspect; third-party
  -- closures are code and must never be executed merely for compatibility or
  -- migration analysis.
  local function talkEntryIsExternal(mapId, textId, entry)
      if type(entry) ~= "function" then return false end
      if not (mapId and textId) then return false end
      local ok, MapScripts = pcall(require, "src.script.MapScripts")
      if not ok or type(MapScripts) ~= "table"
          or type(MapScripts.talkSource) ~= "function" then
          return false
      end
      local okSource, source = pcall(MapScripts.talkSource, mapId, textId)
      return okSource and type(source) == "table" and source.modId ~= nil
  end

  -- Trainer-ness is a property of the map object, never of the sprite. This
  -- prevents mods that reuse trainer sprites for ordinary civilians from being
  -- mistaken for battles or trainer-owned NPCs.
  local function isTrainerDefinition(def)
      if type(def) ~= "table" then return false end
      return def.trainerClass ~= nil
          or def.trainerParty ~= nil
          or def.trainer ~= nil
  end

  mod.exports.nuzlocke_compat = {
      version = 25,
      compatible_from = 10,
      audited_recomp = mod.exports.__beta26.recompCompatAudited,
      runtime_environment = mod.exports.__beta26.runtimeEnvironment,
      save_editor = {
          detection = "package.loaded.App:getState",
          runtime_patches = false,
          contract = "Nuzlocke runtime monkey patches are not installed by the Save Editor ModLoader; gameplay rebinds them in the gameplay loader session.",
      },
      gold = {
          status_surface = "start_menu_screen",
          status_screen_id = "NuzlockeGoldStatusScreen",
          native_trainer_card_preserved = true,
          catch_observer = "pokemon.caught",
          gift_transaction_hook = "script.command",
          forced_nickname = "deferred_hidden",
          field_item_use_rules = "partial_deferred",
      },
      capabilities = COMPAT_CAPABILITIES,
      engine_compat = mod.exports.__beta26.compat.Engine,
      mod_compat = mod.exports.__beta26.compat.Mods,
      relationships = {
          supported = mod.exports.__beta26.compat.Mods.supported_relationships,
          defaults = mod.exports.__beta26.compat.Mods.defaults,
      },
      cooperation = {
          -- We are intentionally chain-friendly on these shared seams. Mods
          -- wrapping them should call their previous/next implementation rather
          -- than replacing it silently.
          allows_wrapping = {
              "item_use", "shopping", "healing", "battle_finish",
              "trainer_card", "party_menu", "npc_talk", "encounters",
              "start_menu_items", "screens",
          },
          requires_next = {
              "item_use", "shopping", "healing", "battle_finish",
              "trainer_card", "party_menu", "npc_talk",
              "start_menu_items",
          },
          silent_overwrite = false,
      },
      ownership = {
          encounter_tracking = true,
          encounter_area_projection = true,
          static_encounter_policy = true,
          game_corner_policy = true,
          gym_guide_rare_candy = true,
          pokemon_fields = {
              "nuzlockeId", "nuzlockeDead", "nuzlockeOrigin",
              "nuzlockeEncounterType", "nuzlockeEncounterSource",
              "nuzlockeEncounterMapId",
              "nuzlockeEncounterProvider", "nuzlockeEncounterProviderVersion",
              "nuzlockeEncounterContext", "nuzlockeExternalIdentity",
              "nuzlockeIdentityProvider", "nuzlockeIdentityDuplicateOf",
              "nuzlockeNeedsNickname", "nuzlockeNicknameRequired",
              "nuzlockeInvalidAcquisition", "nuzlockeTrackerRegistered",
              "nuzlockeRivalForgiven",
              "nuzlockeGlitch", "nuzlockeMissingNo", "nuzlockeRawSpecies",
              "nuzlockeWonderTradeOrigin", "nuzlockeWorldCapNotified",
              "deathLocation", "deathCause", "deathCauseText",
              "deathEncounterType", "deathOpponentSpecies", "deathMove",
              "deathCritical", "deathStatusCondition",
          },
      },
      wonderlocke = {
          status = "WIP",
          enabled = false,
          capability = "wonder_trade",
          contract = "Reserved for future Wonderlocke integration. This beta does not consume, replace, remove, block, or otherwise alter Wonder Trade transactions.",
      },
      battle_classifier = {
          api = 1,
          capability = "battle_classification",
          contract = "Read-only, generation-neutral classification. It inspects battle provenance and never changes rule state, encounter slots, parties, or story flow.",
      },
      pokemon_identity = {
          capability = "pokemon_identity",
          contract = "Optional provider for mods that recreate/extend Pokemon objects. Expose get_id(mon, game), get_identity(mon, game), or get_pokemon_id(mon, game) and return a stable string/number for the same Pokemon across saves/evolution.",
      },
      species_metadata = {
          capability = "species_metadata",
          contract = "Optional provider for merged species classification and BST. Expose get_metadata(game, species), metadata(game, species), or get_species_metadata(game, species); return legendary/mythical flags and optionally bst/baseStats metadata.",
      },
      getSpeciesBST = function(game, species)
          return mod.exports.__beta26.getSpeciesBST(game, species)
      end,
      getMaximumBST = function()
          return mod.exports.__beta26.getMaximumBST()
      end,
      getGlitchSpeciesInfo = function(game, species)
          return mod.exports.__beta26.getGlitchSpeciesInfo(game, species)
      end,
      isGlitchSpecies = function(game, species)
          return mod.exports.__beta26.getGlitchSpeciesInfo(game, species).isGlitch
      end,
      isRivalBattle = function(battle)
          return mod.exports.__beta26.isRivalBattle(battle)
      end,
      isFirstRivalForgivenessActive = function(game, battle)
          return mod.exports.__beta26.isFirstRivalForgivenessActive(game, battle)
      end,
      isStaticEncounter = function(game, battle)
          return mod.exports.__beta26.isStaticEncounter(game, battle)
      end,
      classifyBattle = function(game, battle, species)
          if type(mod.exports.__beta26.classifyBattle) ~= "function" then
              return { api = 1, kind = "unknown", flags = { unknown = true } }
          end
          return mod.exports.__beta26.classifyBattle(game, battle, species)
      end,
      canGamble = function(game)
          return not mod.exports.__beta26.ruleActive(game, "no_gambling")
      end,
      projectEncounterArea = function(mapId, safari, x, y, width, height)
          return mod.exports.__beta26.projectEncounterArea(
              mapId, safari, x, y, width, height)
      end,
      getEncounterSplitModes = function()
          return {
              routes = math.max(0, math.min(1,
                  math.floor(tonumber(mod.save:get("route_splits", 0)) or 0))),
              mt_moon = math.max(0, math.min(1,
                  math.floor(tonumber(mod.save:get("mt_moon_splits", 0)) or 0))),
              safari = math.max(0, math.min(1,
                  math.floor(tonumber(mod.save:get("safari_zone_splits", 0)) or 0))),
          }
      end,
      canCapture = function(game, battle, species)
          if type(catchDeniedReason) ~= "function" then return true end
          local reason = catchDeniedReason(game, battle, species)
          if reason == "bst" then
              return false, reason, {
                  bst = mod.exports.__beta26.getSpeciesBST(game, species),
                  maximum = mod.exports.__beta26.getMaximumBST(),
              }
          elseif reason == "glitch" then
              return false, reason,
                  mod.exports.__beta26.getGlitchSpeciesInfo(game, species)
          end
          return reason == nil, reason
      end,
      -- Wonderlocke remains a visible WIP placeholder only. Keep the capability
      -- name reserved so future provider work can resume without interfering with
      -- installed Wonder Trade mods today.
   -- These helpers are intentionally behavioral rather than name based.
      -- Other mods may use them to decide whether a Nuzlocke feature should
      -- compose with their own NPC systems.
      isTrainerDefinition = isTrainerDefinition,
      talkEntryIsExternal = talkEntryIsExternal,
      getCompatibilityReport = function()
          return {
              api = 25,
              environment = mod.exports.__beta26.runtimeEnvironment(),
              audited_recomp = mod.exports.__beta26.recompCompatAudited,
              engine = mod.exports.__beta26.compat.Engine,
              mods = mod.exports.__beta26.compat.Mods.report(),
          }
      end,
      getModRelationship = function(modId, capability)
          return mod.exports.__beta26.compat.Mods.relationshipFor(modId, capability)
      end,
      getGen2Coverage = function(moduleName)
          return mod.exports.__beta26.compat.Engine.gen2.coverage(moduleName)
      end,
      getGen2MemberStatus = function(moduleName, member)
          return mod.exports.__beta26.compat.Engine.gen2.memberStatus(moduleName, member)
      end,
  }
  -- Machine-readable ownership declaration for compatibility-aware mods.
  -- Keep it as the same table exposed inside nuzlocke_compat so the two
  -- contracts cannot drift.
  mod.exports.owns = mod.exports.nuzlocke_compat.ownership

  mod.events:on("mods.loaded", function(ev)
      discoverCompatProviders(ev and ev.loader)
      -- Dynamic trainer.party observations belong to the active composition,
      -- not the save. Clear them whenever the loader rebuilds the mod set so
      -- disabling or replacing a trainer overhaul cannot leave stale caps.
      if mod.exports.__beta26.levelCapBosses then
          mod.exports.__beta26.levelCapBosses.observed = {}
      end
  end)

  ---------------------------------------------------------------------
  -- WORD WRAP HELPER (16 chars: safe inner width for the desc box)
  ---------------------------------------------------------------------
  local function wrapText(str, limit)
      limit = limit or 16
      local lines = {}
      local currentLine = ""

      for word in tostring(str):gmatch("%S+") do
          if #currentLine == 0 then
              currentLine = word
          elseif #currentLine + 1 + #word <= limit then
              currentLine = currentLine .. " " .. word
          else
              table.insert(lines, currentLine)
              currentLine = word
          end
      end

      if #currentLine > 0 then
          table.insert(lines, currentLine)
      end

      return lines
  end

  ---------------------------------------------------------------------
  -- ALL GEN 1 CATCHABLE ROUTES / LOCATIONS
  --
  -- These IDs intentionally match the engine's actual map IDs.
  ---------------------------------------------------------------------
  local ALL_ROUTES = {
      -- Ordered in the normal Gen 1 discovery/progression order.
      -- Optional side areas are placed where a player would naturally
      -- first encounter them rather than grouping cities, routes, or caves.
      { id = "PALLET_TOWN",      name = Strings.source("Pallet Town")    },
      { id = "ROUTE_1",          name = Strings.source("Route 1")        },
      { id = "VIRIDIAN_CITY",    name = Strings.source("Viridian City")  },
      { id = "ROUTE_22",         name = Strings.source("Route 22")       },
      { id = "ROUTE_2",          name = Strings.source("Route 2")        },
      { id = "VIRIDIAN_FOREST",  name = Strings.source("Virid. Forest")  },
      { id = "PEWTER_CITY",      name = Strings.source("Pewter City")    },
      { id = "ROUTE_3",          name = Strings.source("Route 3")        },
      { id = "MT_MOON",          name = Strings.source("Mt. Moon")       },
      { id = "MT_MOON_1F",       name = Strings.source("Mt. Moon 1F")    },
      { id = "MT_MOON_B1F",      name = Strings.source("Mt. Moon B1F")   },
      { id = "MT_MOON_B2F",      name = Strings.source("Mt. Moon B2F")   },
      { id = "ROUTE_4",          name = Strings.source("Route 4")        },
      { id = "CERULEAN_CITY",    name = Strings.source("Cerulean City")  },
      { id = "CERULEAN_GYM",     name = Strings.source("Cerulean Gym")   },
      { id = "ROUTE_24",         name = Strings.source("Route 24")       },
      { id = "ROUTE_25",         name = Strings.source("Route 25")       },
      { id = "ROUTE_5",          name = Strings.source("Route 5")        },
      { id = "ROUTE_6",          name = Strings.source("Route 6")        },
      { id = "VERMILION_CITY",   name = Strings.source("Vermilion City") },
      { id = "VERMILION_HARBOR", name = Strings.source("Vermilion Harbor") },
      { id = "ROUTE_11",         name = Strings.source("Route 11")       },
      { id = "DIGLETT_CAVE",     name = Strings.source("Diglett Cave")   },
      { id = "ROUTE_9",          name = Strings.source("Route 9")        },
      { id = "ROUTE_10",         name = Strings.source("Route 10")       },
      { id = "ROCK_TUNNEL",      name = Strings.source("Rock Tunnel")    },
      { id = "POWER_PLANT",      name = Strings.source("Power Plant")    },
      { id = "LAVENDER_TOWN",    name = Strings.source("Lavender Town")  },
      { id = "POKEMON_TOWER",    name = Strings.source("Pkmn Tower")     },
      { id = "ROUTE_12",         name = Strings.source("Route 12")       },
      { id = "ROUTE_13",         name = Strings.source("Route 13")       },
      { id = "ROUTE_14",         name = Strings.source("Route 14")       },
      { id = "ROUTE_15",         name = Strings.source("Route 15")       },
      { id = "FUCHSIA_CITY",     name = Strings.source("Fuchsia City")   },
      { id = "SAFARI_ZONE",      name = Strings.source("Safari Zone")    },
      { id = "SAFARI_ZONE_CENTER", name = Strings.source("Safari Center") },
      { id = "SAFARI_ZONE_EAST",   name = Strings.source("Safari East")   },
      { id = "SAFARI_ZONE_NORTH",  name = Strings.source("Safari North")  },
      { id = "SAFARI_ZONE_WEST",   name = Strings.source("Safari West")   },
      { id = "CELADON_CITY",     name = Strings.source("Celadon City")   },
      { id = "ROUTE_16",         name = Strings.source("Route 16")       },
      { id = "ROUTE_17",         name = Strings.source("Route 17")       },
      { id = "ROUTE_18",         name = Strings.source("Route 18")       },
      { id = "ROUTE_7",          name = Strings.source("Route 7")        },
      { id = "ROUTE_8",          name = Strings.source("Route 8")        },
      { id = "SAFFRON_CITY",     name = Strings.source("Saffron City")   },
      { id = "SILPH_CO",         name = Strings.source("Silph Co.")      },
      { id = "ROUTE_19",         name = Strings.source("Route 19")       },
      { id = "ROUTE_20",         name = Strings.source("Route 20")       },
      { id = "SEAFOAM_ISLANDS",  name = Strings.source("Seafoam Isls.")  },
      { id = "CINNABAR_ISLAND",  name = Strings.source("Cinnabar Isl.")  },
      { id = "POKEMON_MANSION",  name = Strings.source("Pkmn Mansion")   },
      { id = "ROUTE_21",         name = Strings.source("Route 21")       },
      { id = "ROUTE_23",         name = Strings.source("Route 23")       },
      { id = "VICTORY_ROAD",     name = Strings.source("Victory Road")   },
      { id = "CERULEAN_CAVE",    name = Strings.source("Cerulean Cave")  },
  }

  -- CARDINAL mode divides every numbered Kanto route along its natural
  -- long axis. The direction is physical provenance: it is determined from
  -- the player's cell and map dimensions at the time of the encounter, then
  -- kept even while the rule is OFF so projection remains reversible.
  mod.exports.__beta26.routeCardinalAxes = {
      ROUTE_1 = "NS",  ROUTE_2 = "NS",  ROUTE_3 = "EW",
      ROUTE_4 = "EW",  ROUTE_5 = "NS",  ROUTE_6 = "NS",
      ROUTE_7 = "EW",  ROUTE_8 = "EW",  ROUTE_9 = "EW",
      ROUTE_10 = "NS", ROUTE_11 = "EW", ROUTE_12 = "NS",
      ROUTE_13 = "EW", ROUTE_14 = "NS", ROUTE_15 = "EW",
      ROUTE_16 = "EW", ROUTE_17 = "NS", ROUTE_18 = "EW",
      ROUTE_19 = "NS", ROUTE_20 = "EW", ROUTE_21 = "NS",
      ROUTE_22 = "EW", ROUTE_23 = "NS", ROUTE_24 = "NS",
      ROUTE_25 = "EW",
  }

  do
      local baseRoutes = ALL_ROUTES
      ALL_ROUTES = {}
      for _, route in ipairs(baseRoutes) do
          ALL_ROUTES[#ALL_ROUTES + 1] = route
          local axis = mod.exports.__beta26.routeCardinalAxes[route.id]
          if axis == "NS" then
              ALL_ROUTES[#ALL_ROUTES + 1] = {
                  id = route.id .. "_NORTH", name = route.name .. " North" }
              ALL_ROUTES[#ALL_ROUTES + 1] = {
                  id = route.id .. "_SOUTH", name = route.name .. " South" }
          elseif axis == "EW" then
              ALL_ROUTES[#ALL_ROUTES + 1] = {
                  id = route.id .. "_WEST", name = route.name .. " West" }
              ALL_ROUTES[#ALL_ROUTES + 1] = {
                  id = route.id .. "_EAST", name = route.name .. " East" }
          end
      end
  end

  local ROUTE_IDS = {}
  local ROUTE_NAMES = {}
  local ROUTE_ORDER = {}

  for index, route in ipairs(ALL_ROUTES) do
      ROUTE_IDS[route.id] = true
      ROUTE_NAMES[route.id] = route.name
      ROUTE_ORDER[route.id] = index
  end

  ---------------------------------------------------------------------
  -- LEGACY MAP ALIASES
  --
  -- Older versions of this mod could have stored a raw engine/text
  -- namespace identifier. Keep aliases here so upgrading a save does
  -- not throw away existing tracker information.
  ---------------------------------------------------------------------
  local MAP_ALIASES = {
      -- Text-pointer style names
      PalletTown       = "PALLET_TOWN",
      ViridianCity     = "VIRIDIAN_CITY",
      ViridianForest   = "VIRIDIAN_FOREST",
      PewterCity       = "PEWTER_CITY",
      MtMoon           = "MT_MOON",
      MtMoon1F         = "MT_MOON_1F",
      MtMoonB1F        = "MT_MOON_B1F",
      MtMoonB2F        = "MT_MOON_B2F",
      CeruleanCity     = "CERULEAN_CITY",
      VermilionCity    = "VERMILION_CITY",
      DiglettsCave     = "DIGLETT_CAVE",
      DiglettCave      = "DIGLETT_CAVE",
      LavenderTown     = "LAVENDER_TOWN",
      PokemonTower     = "POKEMON_TOWER",
      CeladonCity      = "CELADON_CITY",
      SafariZone       = "SAFARI_ZONE",
      SafariZoneCenter = "SAFARI_ZONE_CENTER",
      SafariZoneEast   = "SAFARI_ZONE_EAST",
      SafariZoneNorth  = "SAFARI_ZONE_NORTH",
      SafariZoneWest   = "SAFARI_ZONE_WEST",
      FuchsiaCity      = "FUCHSIA_CITY",
      SaffronCity      = "SAFFRON_CITY",
      SilphCo          = "SILPH_CO",
      CinnabarIsland   = "CINNABAR_ISLAND",
      VictoryRoad      = "VICTORY_ROAD",
      PowerPlant       = "POWER_PLANT",
      SeafoamIslands   = "SEAFOAM_ISLANDS",
      RockTunnel       = "ROCK_TUNNEL",
      MtEmber          = "MT_EMBER",
      PokemonMansion   = "POKEMON_MANSION",
      CeruleanCave     = "CERULEAN_CAVE",
      CeruleanGym      = "CERULEAN_GYM",
      VermilionHarbor  = "VERMILION_HARBOR",

      Route1           = "ROUTE_1",
      Route2           = "ROUTE_2",
      Route3           = "ROUTE_3",
      Route4           = "ROUTE_4",
      Route5           = "ROUTE_5",
      Route6           = "ROUTE_6",
      Route7           = "ROUTE_7",
      Route8           = "ROUTE_8",
      Route9           = "ROUTE_9",
      Route10          = "ROUTE_10",
      Route11          = "ROUTE_11",
      Route12          = "ROUTE_12",
      Route13          = "ROUTE_13",
      Route14          = "ROUTE_14",
      Route15          = "ROUTE_15",
      Route16          = "ROUTE_16",
      Route17          = "ROUTE_17",
      Route18          = "ROUTE_18",
      Route19          = "ROUTE_19",
      Route20          = "ROUTE_20",
      Route21          = "ROUTE_21",
      Route22          = "ROUTE_22",
      Route23          = "ROUTE_23",
      Route24          = "ROUTE_24",
      Route25          = "ROUTE_25",
  }

  ---------------------------------------------------------------------
  -- NORMALIZE A MAP ID
  --
  -- Current engine map IDs already match ALL_ROUTES.
  -- Aliases are only for compatibility with older mod tracker data.
  ---------------------------------------------------------------------
  local function routeKey(mapId)
      if mapId == nil then
          return nil
      end

      mapId = tostring(mapId)

      if ROUTE_IDS[mapId] then
          return mapId
      end

      local alias = MAP_ALIASES[mapId]
      if alias then
          return alias
      end

      -- Unknown map IDs are intentionally accepted. This makes the tracker
      -- compatible with map/overworld mods instead of silently rejecting a
      -- perfectly valid new area just because vanilla Gen 1 never had it.
      if mapId:match("^[%w_%-%:]+$") then
          return mapId
      end

      return nil
  end

  ---------------------------------------------------------------------
  -- RESOLVE DISPLAY-NAME CATCH LOCATIONS
  --
  -- Some existing save/UI mods preserve a Pokemon's catchLocation as the
  -- human-readable name (for example "Route 22" or "Pallet Town") rather
  -- than the internal map id (ROUTE_22 / PALLET_TOWN).  routeKey intentionally
  -- rejects strings containing spaces, so those values previously survived
  -- in Catch Info but could not be restored into the encounter tracker.
  -- Match against every known area's display name before falling back to the
  -- raw id. This is recovery-only and never guesses from species.
  ---------------------------------------------------------------------
  local function resolveCatchLocation(raw)
      if raw == nil then return nil end
      local direct = routeKey(raw)
      if direct then return direct end

      local target = tostring(raw):lower()
      target = target:gsub("[^%w]+", " "):gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", "")

      for _, route in ipairs(ALL_ROUTES) do
          local id = route and route.id
          if id then
              local display = ROUTE_NAMES[id] or id
              local normalized = tostring(display):lower()
              normalized = normalized:gsub("[^%w]+", " "):gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", "")
              if normalized == target then
                  return id
              end

              local idNormalized = tostring(id):lower():gsub("[^%w]+", " "):gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", "")
              if idNormalized == target then
                  return id
              end
          end
      end

      -- Common vanilla display forms are useful even before dynamic area
      -- discovery has populated ALL_ROUTES.
      local compact = target:gsub(" ", "_"):upper()
      local routeNumber = compact:match("^ROUTE_(%d+)$")
      if routeNumber then return "ROUTE_" .. routeNumber end
      local town = {
          ["PALLET_TOWN"] = "PALLET_TOWN", ["VIRIDIAN_CITY"] = "VIRIDIAN_CITY",
          ["PEWTER_CITY"] = "PEWTER_CITY", ["CERULEAN_CITY"] = "CERULEAN_CITY",
          ["VERMILION_CITY"] = "VERMILION_CITY", ["LAVENDER_TOWN"] = "LAVENDER_TOWN",
          ["CELADON_CITY"] = "CELADON_CITY", ["FUCHSIA_CITY"] = "FUCHSIA_CITY",
          ["SAFFRON_CITY"] = "SAFFRON_CITY", ["CINNABAR_ISLAND"] = "CINNABAR_ISLAND",
          ["INDIGO_PLATEAU"] = "INDIGO_PLATEAU",
      }
      return town[compact]
  end

  ---------------------------------------------------------------------
  -- LOOKUP / DYNAMIC AREA HELPERS
  ---------------------------------------------------------------------
  local function prettyAreaName(id)
      local text = tostring(id or "")
      text = text:gsub("_+", " ")
      text = text:gsub("([a-z])([A-Z])", "%1 %2")
      text = text:gsub("([A-Z]+)([A-Z][a-z])", "%1 %2")
      text = text:gsub("(%a)(%d)", "%1 %2")
      text = text:gsub("(%d)(%a)", "%1 %2")
      text = text:gsub("%s+", " ")
      text = text:gsub("^%s+", ""):gsub("%s+$", "")
      text = text:gsub("(%w)([%w]*)", function(first, rest)
          return first:upper() .. rest:lower()
      end)
      return text
  end

  -- Explicit display overrides for map IDs whose internal names are not
  -- reliably word-separable. IDs remain unchanged for save/mod compatibility.
  local DISPLAY_NAME_OVERRIDES = {
      CERULEANMART4 = "Cerulean Mart 4",
      CeruleanMart4 = "Cerulean Mart 4",
      CERULEANMART = "Cerulean Mart",
      CERULEANHOTEL = "Cerulean Hotel",
      CeruleanHotel = "Cerulean Hotel",
      CERULEANCITYHOTEL = "Cerulean City Hotel",
      CeruleanCityHotel = "Cerulean City Hotel",
      VERMILIONMART4 = "Vermilion Mart 4",
      VermilionMart4 = "Vermilion Mart 4",
      CELADONMART4 = "Celadon Mart 4",
      CeladonMart4 = "Celadon Mart 4",
      CELADONDEPTSTORE = "Celadon Dept Store",
      CeladonDeptStore = "Celadon Dept Store",

      VIRIDIANMART = "Viridian Mart",
      ViridianMart = "Viridian Mart",
      PEWTERMART = "Pewter Mart",
      PewterMart = "Pewter Mart",
      LAVENDERMART = "Lavender Mart",
      LavenderMart = "Lavender Mart",
      FUCHSIAMART = "Fuchsia Mart",
      FuchsiaMart = "Fuchsia Mart",
      SAFFRONMART = "Saffron Mart",
      SaffronMart = "Saffron Mart",
      CINNABARMART = "Cinnabar Mart",
      CinnabarMart = "Cinnabar Mart",
      CELADONMART = "Celadon Mart",
      CeladonMart = "Celadon Mart",
      VIRIDIANCENTER = "Viridian Center",
      ViridianCenter = "Viridian Center",
      PEWTERCENTER = "Pewter Center",
      PewterCenter = "Pewter Center",
      CERULEANCENTER = "Cerulean Center",
      CeruleanCenter = "Cerulean Center",
      VERMILIONCENTER = "Vermilion Center",
      VermilionCenter = "Vermilion Center",
      LAVENDERCENTER = "Lavender Center",
      LavenderCenter = "Lavender Center",
      FUCHSIACENTER = "Fuchsia Center",
      FuchsiaCenter = "Fuchsia Center",
      CELADONCENTER = "Celadon Center",
      CeladonCenter = "Celadon Center",
      SAFFRONCENTER = "Saffron Center",
      SaffronCenter = "Saffron Center",
      CINNABARCENTER = "Cinnabar Center",
      CinnabarCenter = "Cinnabar Center",
  }

  local function formatAreaDisplayName(name, id)
      local override = DISPLAY_NAME_OVERRIDES[tostring(id or "")]
      if override then return override end
      local text = tostring(name or "")
      if text == "" then
          return prettyAreaName(id)
      end
      text = text:gsub("_+", " ")
      text = text:gsub("([a-z])([A-Z])", "%1 %2")
      text = text:gsub("([A-Z]+)([A-Z][a-z])", "%1 %2")
      text = text:gsub("(%a)(%d)", "%1 %2")
      text = text:gsub("(%d)(%a)", "%1 %2")
      text = text:gsub("%s+", " ")
      text = text:gsub("^%s+", ""):gsub("%s+$", "")

      -- Common concatenated map-name components (CeruleanMart4, etc.).
      local tokens = {
          "Department Store", "Dept Store", "Pokemon Center", "Pokemon Mart",
          "Pkmn Center", "Pkmn Mart", "PokeMart", "Poke Mart",
          "Game Corner", "GameCorner", "Silph Co", "Bike Shop", "Fishing Guru",
          "Name Rater", "Safari Zone", "Pokemon Mansion", "Pokemon Tower",
          "Cerulean Cave", "Viridian Forest", "Diglett Cave", "Rock Tunnel",
          "Power Plant", "Seafoam Islands", "Victory Road", "Mart", "Hotel",
          "Gym", "House", "Lab", "Center", "Gate", "Museum", "Shop",
          "Office", "Floor", "Cave", "Tower", "Mansion", "Harbor", "Port"
      }
      for _, token in ipairs(tokens) do
          local compact = text:gsub("%s+", ""):lower()
          local tl = token:gsub("%s+", ""):lower()
          local pos = compact:find(tl, 1, true)
          if pos and pos > 1 then
              local before = compact:sub(1, pos - 1)
              local after = compact:sub(pos + #tl)
              if after ~= "" then
                  text = before .. " " .. token .. " " .. after
              else
                  text = before .. " " .. token
              end
          end
      end
      text = text:gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", "")
      if #text > 0 then
          text = text:sub(1, 1):upper() .. text:sub(2)
      end
      return text
  end

  local function registerArea(id, name)
      if not id or id == "__LEGACY__" then
          return nil
      end

      id = routeKey(id)
      if not id then
          return nil
      end

      if not ROUTE_IDS[id] then
          ROUTE_IDS[id] = true
          ROUTE_NAMES[id] = formatAreaDisplayName(name, id)
          table.insert(ALL_ROUTES, {
              id = id,
              name = ROUTE_NAMES[id]
          })
      elseif name then
          ROUTE_NAMES[id] = formatAreaDisplayName(name, id)
          for _, route in ipairs(ALL_ROUTES) do
              if route.id == id then
                  route.name = ROUTE_NAMES[id]
                  break
              end
          end
      end

      return id
  end

  local function isTrackedArea(id)
      id = routeKey(id)
      return id ~= nil and ROUTE_IDS[id] == true
  end

  local function routeName(id)
      return Strings(formatAreaDisplayName(ROUTE_NAMES[id], id))
  end

  local function discoverAreasFromTable(tbl)
      if type(tbl) ~= "table" then
          return
      end

      for rawId, def in pairs(tbl) do
          local id = rawId
          local name = nil

          if type(def) == "table" then
              id = def.id or def.mapId or def.key or rawId
              name = def.name or def.label or def.displayName or def.title
          elseif type(def) == "string" then
              id = rawId
              name = def
          end

          if type(id) == "string" then
              registerArea(id, name)
          end
      end
  end

  local function discoverAllKnownAreas(game)
      if not game then
          return
      end

      -- These are deliberately guarded: different recomp/mod builds may
      -- expose map definitions through different data containers.
      local data = game.data
      if type(data) == "table" then
          discoverAreasFromTable(data.maps)
          discoverAreasFromTable(data.mapsById)
          discoverAreasFromTable(data.mapData)
      end

      discoverAreasFromTable(game.maps)
      discoverAreasFromTable(game.mapsById)
      discoverAreasFromTable(game.mapData)

      if game.save then
          if type(game.save.visited) == "table" then
              for rawId, wasVisited in pairs(game.save.visited) do
                  if wasVisited then
                      registerArea(rawId)
                  end
              end
          end
          if game.save.player and game.save.player.map then
              registerArea(game.save.player.map)
          end
      end
  end

  ---------------------------------------------------------------------
  -- SAVE STATE HELPERS
  ---------------------------------------------------------------------
  local function caughtAreas()
      local areas = mod.save:get("caught_areas")

      if type(areas) ~= "table" then
          areas = {}
          mod.save:set("caught_areas", areas)
      end

      return areas
  end

  local function trackerLog()
      local log = mod.save:get("tracker_log")

      if type(log) ~= "table" then
          log = {}
          mod.save:set("tracker_log", log)
      end

      return log
  end

  -- COMMON encounter splitting keeps the physical map as immutable
  -- provenance and projects it into the currently selected rule layout.
  -- Persisted catches are never identified by species or guessed from a
  -- display name, so switching OFF <-> COMMON is reversible and randomizer
  -- safe. Unknown legacy catches remain on the unsplit parent area.
  mod.exports.__beta26.encounterSplitAreas = {
      mt_moon = {
          parent = "MT_MOON",
          members = {
              MT_MOON_1F = true,
              MT_MOON_B1F = true,
              MT_MOON_B2F = true,
          },
      },
      safari = {
          parent = "SAFARI_ZONE",
          members = {
              SAFARI_ZONE_CENTER = true,
              SAFARI_ZONE_EAST = true,
              SAFARI_ZONE_NORTH = true,
              SAFARI_ZONE_WEST = true,
          },
      },
  }

  for parent, axis in pairs(mod.exports.__beta26.routeCardinalAxes) do
      local members = {}
      if axis == "NS" then
          members[parent .. "_NORTH"] = true
          members[parent .. "_SOUTH"] = true
      else
          members[parent .. "_WEST"] = true
          members[parent .. "_EAST"] = true
      end
      mod.exports.__beta26.encounterSplitAreas["route_"
          .. parent:match("ROUTE_(%d+)")] = {
          parent = parent,
          members = members,
          selector = "route_splits",
      }
  end

  mod.exports.__beta26.splitFamilyFor = function(key)
      for _, family in pairs(mod.exports.__beta26.encounterSplitAreas) do
          if family.members[key] then return family end
      end
      return nil
  end

  mod.exports.__beta26.cardinalPhysicalArea = function(mapId, x, y, width, height)
      local key = routeKey(mapId)
      if not key then return nil end
      if mod.exports.__beta26.splitFamilyFor(key) then return key end
      local axis = mod.exports.__beta26.routeCardinalAxes[key]
      if not axis then return key end
      x, y, width, height = tonumber(x), tonumber(y), tonumber(width), tonumber(height)
      if axis == "NS" and y and height and height > 0 then
          return key .. (y < height / 2 and "_NORTH" or "_SOUTH")
      elseif axis == "EW" and x and width and width > 0 then
          return key .. (x < width / 2 and "_WEST" or "_EAST")
      end
      -- Old catches without position provenance stay on the parent. Never
      -- guess a side, because doing so could silently spend the wrong slot.
      return key
  end

  mod.exports.__beta26.projectEncounterArea = function(mapId, safari, x, y,
      width, height)
      local key = routeKey(mapId)
      if safari == true and not key then key = "SAFARI_ZONE" end
      if not key then return nil end

      key = mod.exports.__beta26.cardinalPhysicalArea(
          key, x, y, width, height)

      local routeFamily = mod.exports.__beta26.splitFamilyFor(key)
      if routeFamily and routeFamily.selector == "route_splits" then
          local mode = math.max(0, math.min(1,
              math.floor(tonumber(mod.save:get("route_splits", 0)) or 0)))
          return mode == 1 and key or routeFamily.parent
      end

      local moon = mod.exports.__beta26.encounterSplitAreas.mt_moon
      if moon.members[key] then
          local mode = math.max(0, math.min(1,
              math.floor(tonumber(mod.save:get("mt_moon_splits", 0)) or 0)))
          return mode == 1 and key or moon.parent
      end

      local zone = mod.exports.__beta26.encounterSplitAreas.safari
      if zone.members[key] then
          local mode = math.max(0, math.min(1,
              math.floor(tonumber(mod.save:get("safari_zone_splits", 0)) or 0)))
          return mode == 1 and key or zone.parent
      end
      if safari == true then return zone.parent end
      return key
  end

  local function encounterProviderHistory()
      local history = mod.save:get("encounter_provider_history")
      if type(history) ~= "table" then
          history = {}
          mod.save:set("encounter_provider_history", history)
      end
      return history
  end

  local function rememberEncounterProvider(providerId, providerVersion)
      if not providerId then return end
      local history = encounterProviderHistory()
      history[tostring(providerId)] = { version = providerVersion }
      mod.save:set("encounter_provider_history", history)
  end

  local function syncCaughtAreasFromLog()
      local areas = caughtAreas()
      local log = trackerLog()
      local changed = false

      for key, catches in pairs(log) do
          if key ~= "__LEGACY__" and areas[key] == nil and type(catches) == "table" then
              for _, entry in ipairs(catches) do
                  if type(entry) == "table" and entry.species
                      and entry.consumedArea ~= false then
                      areas[key] = entry.species
                      changed = true
                      break
                  end
              end
          end
      end

      if changed then
          mod.save:set("caught_areas", areas)
      end
      return areas
  end

  local function visitedAreas()
      local v = mod.save:get("visited_areas")

      if type(v) ~= "table" then
          v = {}
          mod.save:set("visited_areas", v)
      end

      return v
  end

  ---------------------------------------------------------------------
  -- AREA KEY
  ---------------------------------------------------------------------
  mod.exports.__beta26.encounterPosition = function(game)
      local ow = game and game.overworld
      if not (ow and ow.map) and game and game.world and game.world.map then
          ow = game.world
      end
      if not (ow and ow.map) and game and game.stack
          and type(game.stack.states) == "table" then
          for i = #game.stack.states, 1, -1 do
              local state = game.stack.states[i]
              if state and state.isOverworld and state.map then
                  ow = state
                  break
              end
          end
      end
      local map = ow and ow.map
      local player = ow and ow.player
      local x = player and player.cellX
      local y = player and player.cellY
      if x == nil and game and game.save and game.save.player then
          x = game.save.player.x
          y = game.save.player.y
      end
      return x, y, map and map.widthCells, map and map.heightCells
  end

  mod.exports.__beta26.currentPhysicalArea = function(game, mapId)
      local x, y, width, height =
          mod.exports.__beta26.encounterPosition(game)
      return mod.exports.__beta26.cardinalPhysicalArea(
          mapId, x, y, width, height)
  end

  local function areaKey(game, battle)
      if type(mod.exports.__beta26.ensureEncounterProjection) == "function" then
          pcall(mod.exports.__beta26.ensureEncounterProjection)
      end
      local mapId

      if game and game.overworld and game.overworld.map then
          mapId = game.overworld.map.id
      end

      if not mapId and game and game.world and game.world.map then
          mapId = game.world.map.id
      end

      if not mapId and game and game.save and game.save.player then
          mapId = game.save.player.map
      end

      local x, y, width, height =
          mod.exports.__beta26.encounterPosition(game)
      local physical = mod.exports.__beta26.cardinalPhysicalArea(
          mapId, x, y, width, height)
      if battle and type(battle) == "table" then
          battle.nuzlockeEncounterMapId = physical
          battle.nuzlockeEncounterX = x
          battle.nuzlockeEncounterY = y
      end
      return mod.exports.__beta26.projectEncounterArea(
          physical, battle and battle.safari == true)
  end

  ---------------------------------------------------------------------
  -- MARK AREA VISITED
  ---------------------------------------------------------------------
  local function markVisited(key, x, y, width, height)
      local physical = mod.exports.__beta26.cardinalPhysicalArea(
          key, x, y, width, height)
      key = registerArea(mod.exports.__beta26.projectEncounterArea(physical))

      if not isTrackedArea(key) then
          return false
      end

      if physical then
          local ledger = mod.save:get("encounter_visited_map_ids", {})
          if type(ledger) ~= "table" then ledger = {} end
          ledger[physical] = true
          mod.save:set("encounter_visited_map_ids", ledger)
      end

      local v = visitedAreas()

      if not v[key] then
          v[key] = true
          mod.save:set("visited_areas", v)
      end

      return true
  end

  ---------------------------------------------------------------------
  -- MARK AREA CAUGHT
  ---------------------------------------------------------------------
  local function markCaught(key, species)
      key = registerArea(key)

      if not isTrackedArea(key) then
          return
      end

      local areas = caughtAreas()

      if areas[key] == nil then
          areas[key] = species
          mod.save:set("caught_areas", areas)
      end
  end

  ---------------------------------------------------------------------
  -- NORMALIZE AN OLD TABLE OF MAP KEYS
  --
  -- Converts old:
  --     PalletTown = true
  --
  -- into:
  --     PALLET_TOWN = true
  ---------------------------------------------------------------------
  local function normalizeMapTable(tbl)
      if type(tbl) ~= "table" then
          return {}, true
      end

      local normalized = {}
      local changed = false

      for rawKey, value in pairs(tbl) do
          local key = routeKey(rawKey)

          if key then
              registerArea(key)
              normalized[key] = value
              if tostring(rawKey) ~= key then
                  changed = true
              end
          else
              -- Preserve unknown data rather than silently deleting it.
              normalized[rawKey] = value
          end
      end

      return normalized, changed
  end

  ---------------------------------------------------------------------
  -- NORMALIZE TRACKER LOG
  ---------------------------------------------------------------------
  local function normalizeTrackerLog(log)
      if type(log) ~= "table" then
          return {}, true
      end

      local normalized = {}
      local changed = false

      for rawKey, catches in pairs(log) do
          local key = routeKey(rawKey)

          if key then
              registerArea(key)
              normalized[key] = normalized[key] or {}

              if type(catches) == "table" then
                  for _, catch in ipairs(catches) do
                      if type(catch) == "table" then
                          table.insert(normalized[key], {
                              species = catch.species,
                              pokemonId = catch.pokemonId,
                              fingerprint = catch.fingerprint,
                              isShiny = catch.isShiny == true,
                              consumedArea = catch.consumedArea,
                              encounterType = catch.encounterType,
                              encounterMapId = catch.encounterMapId,
                              encounterSource = catch.encounterSource,
                              encounterProvider = catch.encounterProvider,
                              encounterProviderVersion = catch.encounterProviderVersion,
                              encounterContext = catch.encounterContext,
                              retroactive = catch.retroactive == true,
                              legacy = catch.legacy == true,
                              provenance = catch.provenance or (catch.legacy == true and "LEGACY" or nil),
                              recoveryStatus = catch.recoveryStatus,
                              possibleAreas = (function()
                                  if type(catch.possibleAreas) ~= "table" then return nil end
                                  local ids = {}
                                  for _, area in ipairs(catch.possibleAreas) do
                                      if type(area) == "table" then
                                          area = area.id or area.mapId or area.key
                                      end
                                      if area then
                                          local key = routeKey(area)
                                          if key then ids[#ids + 1] = key end
                                      end
                                  end
                                  return #ids > 0 and ids or nil
                              end)()
                          })
                      end
                  end
              end

              if tostring(rawKey) ~= key then
                  changed = true
              end
          else
              -- Keep legacy/unknown tracker entries.
              normalized[rawKey] = catches
          end
      end

      return normalized, changed
  end

  ---------------------------------------------------------------------
  -- RETROACTIVE SAVE RECONSTRUCTION
  --
  -- This is deliberately best-effort.
  --
  -- The vanilla save has:
  --   save.visited       -> vanilla town/fly visitation history
  --   save.player.map    -> current location
  --   save.party         -> current party
  --   save.boxes         -> PC Pokemon
  --
  -- The engine does NOT store a historical route-travel log or a native
  -- catch-location on Pokemon. Therefore we cannot truthfully recreate
  -- every route ever walked or exact locations of old Pokemon.
  --
  -- We do, however:
  --   1. import vanilla visited-area information
  --   2. mark the current location visited
  --   3. preserve/normalize old mod tracker data
  --   4. display pre-mod Pokemon under LEGACY
  ---------------------------------------------------------------------

  local function collectLegacyMons(save)
      local mons = {}

      local function addFrom(list)
          if type(list) ~= "table" then
              return
          end

          for _, mon in ipairs(list) do
              if type(mon) == "table" and mon.species then
                  table.insert(mons, mon)
              end
          end
      end

      addFrom(save.party)

      for _, box in ipairs(save.boxes or {}) do
          addFrom(box)
      end

      if type(save.daycare) == "table" and type(save.daycare.mon) == "table" then
          addFrom({ save.daycare.mon })
      end

      return mons
  end

  ---------------------------------------------------------------------
  -- POKEMON PROVENANCE / PERSISTENT IDENTITY
  --
  -- Pokemon instances are plain save-serializable tables in Gen1Recomp, so a
  -- small Nuzlocke-owned ID can live directly on each Pokemon and survive
  -- party/box moves and in-place evolution. This is safer than treating DVs,
  -- IVs, EVs, gender, ability, Pokerus, nature, stats, moves, or level as an
  -- identity: those fields may legitimately change or belong to another mod.
  --
  -- Older Nuzlocke saves are migrated lazily. Their species + DV fingerprint
  -- remains only as a compatibility fallback long enough to recover provenance;
  -- once a Pokemon has nuzlockeId, that ID is authoritative.
  ---------------------------------------------------------------------
  local Identity = (function()
  local ID_REGISTRY_KEY = "nuzlocke_pokemon_identity_registry"
  local ID_COUNTER_KEY = "nuzlocke_pokemon_identity_counter"
  local EXTERNAL_ID_MAP_KEY = "nuzlocke_external_identity_map"

  local function pokemonFingerprint(mon)
      if type(mon) ~= "table" then return nil end
      local species = tostring(mon.species or ""):upper()
      if species == "" then return nil end
      local dvs = mon.dvs
      if type(dvs) ~= "table" then
          return species .. "|DV:?"
      end

      local function dvValue(a, b)
          return tostring(dvs[a] ~= nil and dvs[a] or dvs[b] ~= nil and dvs[b] or "?")
      end
      return table.concat({
          species,
          dvValue("hp", "HP"),
          dvValue("attack", "ATTACK"),
          dvValue("defense", "DEFENSE"),
          dvValue("speed", "SPEED"),
          dvValue("special", "SPECIAL"),
      }, "|")
  end

  local function monIsShiny(mon)
      if type(mon) ~= "table" then return false end
      if type(mon.isShiny) == "boolean" then return mon.isShiny end
      if type(mon.shiny) == "boolean" then return mon.shiny end
      if type(mon.is_shiny) == "boolean" then return mon.is_shiny end
      if type(mon.dvs) == "table" then
          local ok, value = pcall(Stats.isShiny, mon.dvs)
          if ok then return value == true end
      end
      return false
  end

  local function speciesDefinition(game, species)
      local data = game and game.data and game.data.pokemon
      if type(data) ~= "table" then
          local coreData = require("src.core.Data")
          data = coreData and coreData.pokemon
      end
      if type(data) ~= "table" then return nil end
      return data[species] or data[tostring(species or ""):upper()]
  end

  local function providerSpeciesMetadata(game, species)
      local provider = activeCompatProvider("species_metadata", game, nil)
      local value = provider and provider.value
      if not provider then return nil end

      local getter
      if type(value) == "function" then
          getter = value
      elseif type(value) == "table" then
          getter = value.get_metadata or value.metadata or value.get_species_metadata
      end
      if type(getter) ~= "function" then return nil end

      local ok, result = pcall(getter, game, species)
      if not ok then ok, result = pcall(getter, species, game) end
      return ok and type(result) == "table" and result or nil
  end

  -- MissingNo and custom glitch species can arrive as names, raw numeric IDs,
  -- or partially malformed records. Classify without mutating/deleting them.
  -- A missing merged registry entry is considered glitch-shaped only when no
  -- active species-metadata provider recognizes it either.
  mod.exports.__beta26.getGlitchSpeciesInfo = function(game, species)
      local raw = species
      if type(raw) == "table" then
          raw = raw.species or raw.id or raw.key or raw.name
      end
      local rawType = type(raw)
      local text = (rawType == "string" or rawType == "number")
          and tostring(raw) or ""
      local key = text:upper():gsub("^%s+", ""):gsub("%s+$", "")
      local compact = key:gsub("[^A-Z0-9]", "")
      local registry = game and game.data and game.data.pokemon
      local registryAvailable = type(registry) == "table" and next(registry) ~= nil
      local def = key ~= "" and speciesDefinition(game, raw) or nil
      local meta = key ~= "" and providerSpeciesMetadata(game, raw) or nil
      local category = tostring((type(def) == "table"
          and (def.category or def.classification)) or (type(meta) == "table"
          and (meta.category or meta.classification)) or ""):lower()
      local flagged = (type(def) == "table" and (def.glitch == true
              or def.isGlitch == true or def.is_glitch == true))
          or (type(meta) == "table" and (meta.glitch == true
              or meta.isGlitch == true or meta.is_glitch == true))
          or category == "glitch"
      local missingNo = compact:find("MISSINGNO", 1, true) == 1
          or compact == "MISSINGNUMBER" or compact == "MISSINGNUM"
      local malformed = rawType ~= "string" and rawType ~= "number"
          or key == "" or (registryAvailable and def == nil and meta == nil)
      local isGlitch = flagged or missingNo or malformed
      local label
      if missingNo then
          label = "MISSINGNO"
      elseif isGlitch then
          label = key ~= "" and ("GLITCH " .. key):sub(1, 16) or "GLITCH"
      else
          label = key
      end
      return {
          isGlitch = isGlitch == true,
          missingNo = missingNo == true,
          malformed = malformed == true,
          key = key ~= "" and key or "GLITCH",
          label = label ~= "" and label or "GLITCH",
          raw = species,
          definition = def,
          metadata = meta,
      }
  end

  mod.exports.__beta26.safeSpeciesLabel = function(game, species)
      local info = mod.exports.__beta26.getGlitchSpeciesInfo(game, species)
      if info.isGlitch then return info.label end
      return info.key ~= "" and info.key or "???"
  end

  mod.exports.__beta26.glitchCatchesAllowed = function()
      return mod.save:get("nuzlocke_enabled", true) ~= false
          and mod.save:get("allow_glitch_pokemon", false) == true
  end

  -- Read BST from the live merged species registry first, with the optional
  -- species-metadata provider as a compatibility supplement. Gen 1 species
  -- have five base stats (SPECIAL counted once); Gen 2/custom schemas may
  -- expose split Special Attack and Special Defense, which are both counted.
  -- Unknown or incomplete schemas fail open instead of falsely banning a mon.
  mod.exports.__beta26.getSpeciesBST = function(game, species)
      if mod.exports.__beta26.getGlitchSpeciesInfo(game, species).isGlitch then
          return nil
      end
      local def = speciesDefinition(game, species)
      local meta = providerSpeciesMetadata(game, species)

      local function directBST(row)
          if type(row) ~= "table" then return nil end
          local value = tonumber(row.bst or row.baseStatTotal
              or row.base_stat_total or row.totalBaseStats)
          return value and value > 0 and math.floor(value) or nil
      end
      local direct = directBST(def) or directBST(meta)
      if direct then return direct end

      local function statTable(row)
          if type(row) ~= "table" then return nil end
          return row.baseStats or row.base_stats or row.stats
      end
      local stats = statTable(def) or statTable(meta)
      if type(stats) ~= "table" then return nil end

      -- Accept array-form registries as a conservative compatibility path:
      -- Gen 1 = HP/ATK/DEF/SPD/SPECIAL, Gen 2+ = six base stats.
      if #stats == 5 or #stats == 6 then
          local total = 0
          for i = 1, #stats do
              local value = tonumber(stats[i])
              if not value or value < 0 then return nil end
              total = total + value
          end
          return total > 0 and math.floor(total) or nil
      end

      local function pick(...)
          for i = 1, select("#", ...) do
              local key = select(i, ...)
              local value = tonumber(stats[key])
              if value ~= nil then return value end
          end
          return nil
      end
      local hp = pick("hp", "HP", "health")
      local attack = pick("attack", "atk", "ATTACK", "ATK")
      local defense = pick("defense", "defence", "def", "DEFENSE", "DEF")
      local speed = pick("speed", "spd", "SPEED", "SPD")
      if not (hp and attack and defense and speed) then return nil end

      local specialAttack = pick("specialAttack", "special_attack", "spAttack",
          "sp_attack", "spAtk", "sp_atk", "SPECIAL_ATTACK", "SP_ATTACK")
      local specialDefense = pick("specialDefense", "special_defense", "spDefense",
          "sp_defense", "spDef", "sp_def", "SPECIAL_DEFENSE", "SP_DEFENSE")
      local special = pick("special", "spc", "SPECIAL", "SPC")
      local total = hp + attack + defense + speed
      if specialAttack ~= nil or specialDefense ~= nil then
          if specialAttack == nil or specialDefense == nil then return nil end
          total = total + specialAttack + specialDefense
      elseif special ~= nil then
          total = total + special
      else
          return nil
      end
      return total > 0 and math.floor(total) or nil
  end

  mod.exports.__beta26.getMaximumBST = function()
      if mod.save:get("nuzlocke_enabled", true) == false then return 0 end
      return math.max(0, math.min(999,
          math.floor(tonumber(mod.save:get("maximum_bst", 0)) or 0)))
  end

  local function metadataHasFlag(meta, kind)
      if type(meta) ~= "table" then return false end
      if kind == "legendary" then
          if meta.isLegendary == true or meta.legendary == true or meta.is_legendary == true then return true end
      elseif kind == "mythical" then
          if meta.isMythical == true or meta.mythical == true or meta.is_mythical == true then return true end
      elseif kind == "pseudo" then
          if meta.isPseudoLegendary == true or meta.pseudoLegendary == true
              or meta.is_pseudo_legendary == true or meta.pseudo == true then return true end
      end
      local category = tostring(meta.category or meta.classification or meta.rarity or ""):lower()
      return category == kind
  end

  local function speciesHasFlag(game, species, kind)
      local def = speciesDefinition(game, species)
      if metadataHasFlag(def, kind) then return true end
      return metadataHasFlag(providerSpeciesMetadata(game, species), kind)
  end

  local function isLegendarySpecies(game, species)
      species = tostring(species or ""):upper()
      return (type(LEGENDARIES) == "table" and LEGENDARIES[species] == true)
          or speciesHasFlag(game, species, "legendary")
  end

  local function isMythicalSpecies(game, species)
      species = tostring(species or ""):upper()
      return (type(MYTHICALS) == "table" and MYTHICALS[species] == true)
          or speciesHasFlag(game, species, "mythical")
  end

  local function isPseudoSpecies(game, species)
      species = tostring(species or ""):upper()
      return (type(PSEUDOS) == "table" and PSEUDOS[species] == true)
          or speciesHasFlag(game, species, "pseudo")
  end

  local function allCurrentMons(save)
      return collectLegacyMons(save)
  end

  local function identityRegistry()
      local registry = mod.save:get(ID_REGISTRY_KEY)
      if type(registry) ~= "table" then registry = {} end
      return registry
  end

  local function externalIdentityMap()
      local map = mod.save:get(EXTERNAL_ID_MAP_KEY)
      if type(map) ~= "table" then map = {} end
      return map
  end

  local function normalizePokemonId(value)
      if value == nil then return nil end
      value = tostring(value)
      if value == "" then return nil end
      return value
  end

  local function providerPokemonIdentity(mon)
      if type(mon) ~= "table" then return nil end
      local provider = activeCompatProvider("pokemon_identity", currentGame, nil)
      if not provider then return nil end

      local value = provider.value
      local getter
      if type(value) == "function" then
          getter = value
      elseif type(value) == "table" then
          getter = value.get_id or value.get_identity or value.get_pokemon_id
      end
      if type(getter) ~= "function" then return nil end

      local ok, result = pcall(getter, mon, currentGame)
      if not ok then
          -- Some providers may prefer (game, mon). Accept that shape too.
          ok, result = pcall(getter, currentGame, mon)
      end
      local externalId = ok and normalizePokemonId(result) or nil
      if not externalId then return nil end
      return tostring(provider.id) .. "|" .. externalId, provider
  end

  local function allocatePokemonId(save)
      local registry = identityRegistry()
      local counter = math.max(0, math.floor(tonumber(mod.save:get(ID_COUNTER_KEY, 0)) or 0))

      -- Recover from a lost/reset counter by scanning IDs that survived on the
      -- Pokemon themselves and IDs retained in the registry.
      for _, mon in ipairs(allCurrentMons(save or currentSave or {})) do
          local n = tostring(mon and mon.nuzlockeId or ""):match("^NZL%-(%d+)$")
          n = tonumber(n)
          if n and n > counter then counter = n end
      end
      for id in pairs(registry) do
          local n = tostring(id):match("^NZL%-(%d+)$")
          n = tonumber(n)
          if n and n > counter then counter = n end
      end

      repeat
          counter = counter + 1
      until registry["NZL-" .. tostring(counter)] == nil

      mod.save:set(ID_COUNTER_KEY, counter)
      return "NZL-" .. tostring(counter)
  end

  local function existingPokemonIdentity(mon)
      if type(mon) ~= "table" then return nil end

      local id = normalizePokemonId(mon.nuzlockeId)
      if id then return id end

      local externalKey, provider = providerPokemonIdentity(mon)
      if externalKey then
          local map = externalIdentityMap()
          local mapped = normalizePokemonId(map[externalKey])
          if mapped then
              mon.nuzlockeId = mapped
              mon.nuzlockeIdentityProvider = provider and provider.id or nil
              mon.nuzlockeExternalIdentity = externalKey
              return mapped
          end
      end

      return nil
  end

  local function ensurePokemonIdentity(mon, save, origin)
      if type(mon) ~= "table" or not mon.species then return nil end

      local id = existingPokemonIdentity(mon)
      local externalKey, provider
      if not id then
          externalKey, provider = providerPokemonIdentity(mon)
          id = allocatePokemonId(save)
          mon.nuzlockeId = id
          if externalKey then
              local map = externalIdentityMap()
              map[externalKey] = id
              mod.save:set(EXTERNAL_ID_MAP_KEY, map)
              mon.nuzlockeIdentityProvider = provider and provider.id or nil
              mon.nuzlockeExternalIdentity = externalKey
          end
      end

      local registry = identityRegistry()
      local entry = registry[id]
      if type(entry) ~= "table" then entry = {} end
      entry.speciesAtRegistration = entry.speciesAtRegistration or tostring(mon.species or ""):upper()
      entry.currentSpecies = tostring(mon.species or ""):upper()
      if origin then entry.origin = origin end
      if mon.catchLocation then entry.catchLocation = mon.catchLocation end
      registry[id] = entry
      mod.save:set(ID_REGISTRY_KEY, registry)

      return id
  end

  local function pokemonIdentity(mon)
      return existingPokemonIdentity(mon)
  end

  local function samePokemonIdentity(entry, mon)
      if type(entry) ~= "table" or type(mon) ~= "table" then return false end

      local monId = pokemonIdentity(mon)
      local entryId = normalizePokemonId(entry.pokemonId)
      if monId and entryId then
          return monId == entryId
      end

      -- Old tracker rows have no Pokemon ID. Fingerprints remain a migration
      -- fallback only; species is the final compatibility fallback.
      local efp = entry.fingerprint
      local mfp = pokemonFingerprint(mon)
      if efp and mfp then return efp == mfp end

      return tostring(entry.species or ""):upper()
          == tostring(mon.species or ""):upper()
  end

  local function repairDuplicatePokemonIds(save)
      local seen = {}
      for _, mon in ipairs(allCurrentMons(save or {})) do
          if type(mon) == "table" then
              local id = normalizePokemonId(mon.nuzlockeId)
              if id then
                  if seen[id] and seen[id] ~= mon then
                      -- A copied Pokemon table can duplicate our custom ID.
                      -- Never let two current Pokemon share one identity.
                      mon.nuzlockeIdentityDuplicateOf = id
                      mon.nuzlockeId = nil
                      mon.nuzlockeOrigin = "EDITED"
                      ensurePokemonIdentity(mon, save, "EDITED")
                  else
                      seen[id] = mon
                  end
              end
          end
      end
  end

  local function pokemonBaseline()
      local baseline = mod.save:get("nuzlocke_pokemon_baseline")
      if type(baseline) ~= "table" then baseline = {} end
      return baseline
  end

  local function pokemonOrigins()
      local origins = mod.save:get("nuzlocke_pokemon_origins")
      if type(origins) ~= "table" then origins = {} end
      return origins
  end

  local function originBucket(origin)
      local origins = pokemonOrigins()
      origins[origin] = origins[origin] or {}
      return origins
  end

  local function setPokemonOrigin(mon, origin)
      if type(mon) ~= "table" or not origin then return end
      mon.nuzlockeOrigin = origin

      local id = normalizePokemonId(mon.nuzlockeId)
      if id then
          local registry = identityRegistry()
          local entry = registry[id]
          if type(entry) ~= "table" then entry = {} end
          entry.origin = origin
          entry.currentSpecies = tostring(mon.species or ""):upper()
          if mon.catchLocation then entry.catchLocation = mon.catchLocation end
          registry[id] = entry
          mod.save:set(ID_REGISTRY_KEY, registry)
      end
  end

  local function baselineAdd(mon, origin)
      if type(mon) ~= "table" then return end
      origin = origin or mon.nuzlockeOrigin or "NORMAL"
      local id = ensurePokemonIdentity(mon, currentSave, origin)
      setPokemonOrigin(mon, origin)

      -- The fingerprint baseline is kept only for migration from pre-ID saves.
      -- Register each persistent identity at most once so repeated save loads
      -- cannot inflate the old count-based baseline.
      local registry = identityRegistry()
      local identityEntry = id and registry[id] or nil
      if type(identityEntry) == "table" and identityEntry.baselineRegistered == true then
          return
      end

      local fp = pokemonFingerprint(mon)
      if fp then
          local baseline = pokemonBaseline()
          baseline[fp] = (tonumber(baseline[fp]) or 0) + 1
          local origins = originBucket(origin)
          origins[origin][fp] = (tonumber(origins[origin][fp]) or 0) + 1
          mod.save:set("nuzlocke_pokemon_baseline", baseline)
          mod.save:set("nuzlocke_pokemon_origins", origins)
      end

      if id then
          registry = identityRegistry()
          identityEntry = registry[id] or {}
          identityEntry.baselineRegistered = true
          identityEntry.origin = origin
          identityEntry.fingerprint = identityEntry.fingerprint or fp
          registry[id] = identityEntry
          mod.save:set(ID_REGISTRY_KEY, registry)
      end
  end

  local function consumeOrigin(origins, fp, preferred)
      local order = { preferred, "NORMAL", "PLAYER_CONFIRMED", "LEGACY", "EDITED" }
      local seen = {}
      for _, origin in ipairs(order) do
          if origin and not seen[origin] then
              seen[origin] = true
              local bucket = origins[origin]
              local count = bucket and tonumber(bucket[fp]) or 0
              if count and count > 0 then
                  bucket[fp] = count - 1
                  return origin
              end
          end
      end
      return nil
  end

  local function classifyPokemonProvenance(save, initializing)
      if type(save) ~= "table" then return end
      local mons = allCurrentMons(save)
      local baseline = pokemonBaseline()
      local origins = pokemonOrigins()

      repairDuplicatePokemonIds(save)

      if initializing then
          baseline = {}
          origins = { LEGACY = {}, NORMAL = {}, EDITED = {}, PLAYER_CONFIRMED = {} }
          mod.save:set("nuzlocke_pokemon_baseline", baseline)
          mod.save:set("nuzlocke_pokemon_origins", origins)

          local existingLog = mod.save:get("tracker_log")
          local knownNormal = {}
          local knownLegacy = {}
          if type(existingLog) == "table" then
              for area, entries in pairs(existingLog) do
                  if area ~= "__LEGACY__" and type(entries) == "table" then
                      for _, entry in ipairs(entries) do
                          if type(entry) == "table" and entry.species then
                              local sp = tostring(entry.species):upper()
                              if entry.provenance == "LEGACY"
                                  or entry.legacy == true or entry.retroactive == true then
                                  knownLegacy[sp] = (knownLegacy[sp] or 0) + 1
                              else
                                  knownNormal[sp] = (knownNormal[sp] or 0) + 1
                              end
                          end
                      end
                  end
              end
          end

          local usedNormal, usedLegacy = {}, {}
          for _, mon in ipairs(mons) do
              local sp = tostring(mon.species or ""):upper()

              -- If mod-owned fields survived but mod.save did not, preserve
              -- their explicit provenance rather than demoting the Pokemon.
              local origin = mon.nuzlockeOrigin
              if origin ~= "NORMAL" and origin ~= "PLAYER_CONFIRMED"
                  and origin ~= "LEGACY" and origin ~= "EDITED" then
                  origin = nil
              end

              if not origin then
                  origin = "LEGACY"
                  if (usedNormal[sp] or 0) < (knownNormal[sp] or 0) then
                      usedNormal[sp] = (usedNormal[sp] or 0) + 1
                      origin = "NORMAL"
                  elseif (usedLegacy[sp] or 0) < (knownLegacy[sp] or 0) then
                      usedLegacy[sp] = (usedLegacy[sp] or 0) + 1
                      origin = "LEGACY"
                  elseif mon.nuzlockeTrackerRegistered == true and mon.catchLocation then
                      origin = "NORMAL"
                  end
              end

              setPokemonOrigin(mon, origin)
              baselineAdd(mon, origin)
          end

          mod.save:set("nuzlocke_provenance_initialized", true)
          return
      end

      local remaining = {}
      for k, v in pairs(baseline) do remaining[k] = tonumber(v) or 0 end
      for _, bucket in pairs(origins) do
          if type(bucket) == "table" then
              for fp, count in pairs(bucket) do
                  bucket[fp] = tonumber(count) or 0
              end
          end
      end

      local registry = identityRegistry()

      for _, mon in ipairs(mons) do
          local id = existingPokemonIdentity(mon)
          local registered = id and registry[id]
          local registeredOrigin = type(registered) == "table" and registered.origin or nil

          if registeredOrigin then
              -- Persistent identity is authoritative. Species, DVs/IVs, EVs,
              -- gender, ability, Pokerus and moves may all change normally.
              setPokemonOrigin(mon, registeredOrigin)
              ensurePokemonIdentity(mon, save, registeredOrigin)
          elseif mon.nuzlockeOrigin
              and (id or mon.nuzlockeTrackerRegistered == true or mon.catchLocation) then
              -- Custom fields survived but the registry did not.
              ensurePokemonIdentity(mon, save, mon.nuzlockeOrigin)
              setPokemonOrigin(mon, mon.nuzlockeOrigin)
          else
              -- Pre-beta.19 compatibility path. Use the old fingerprint counts
              -- exactly once to recover provenance, then assign a persistent ID.
              local fp = pokemonFingerprint(mon)
              local known = fp and remaining[fp] or 0
              local origin

              if known and known > 0 then
                  remaining[fp] = known - 1
                  local preferred = mon.nuzlockeTrackerRegistered and "NORMAL" or nil
                  origin = fp and consumeOrigin(origins, fp, preferred)
                  origin = origin or preferred or "LEGACY"
              elseif mon.nuzlockeTrackerRegistered == true then
                  origin = mon.nuzlockeOrigin or "NORMAL"
              elseif mon.catchLocation then
                  -- A stored catch location is stronger evidence than the lack
                  -- of an old fingerprint entry.
                  origin = mon.nuzlockeOrigin or "LEGACY"
              else
                  origin = "EDITED"
              end

              setPokemonOrigin(mon, origin)
              local newId = ensurePokemonIdentity(mon, save, origin)

              -- This mon was recovered from an existing baseline; do not add a
              -- second count for the same historical Pokemon.
              if known and known > 0 and newId then
                  registry = identityRegistry()
                  local e = registry[newId] or {}
                  e.baselineRegistered = true
                  e.fingerprint = e.fingerprint or fp
                  e.origin = origin
                  registry[newId] = e
                  mod.save:set(ID_REGISTRY_KEY, registry)
              else
                  baselineAdd(mon, origin)
              end
          end
      end

      mod.save:set("nuzlocke_pokemon_origins", origins)
  end

  local function initializePokemonProvenance(save)
      local initialized = mod.save:get("nuzlocke_provenance_initialized", false) == true
      classifyPokemonProvenance(save, not initialized)

      -- Every current Pokemon should leave reconstruction with an identity,
      -- even if it came from a custom species/mod with no DVs at all.
      for _, mon in ipairs(allCurrentMons(save or {})) do
          if type(mon) == "table" and mon.species then
              local origin = mon.nuzlockeOrigin
                  or (mon.nuzlockeTrackerRegistered and "NORMAL")
                  or "LEGACY"
              ensurePokemonIdentity(mon, save, origin)
          end
      end
  end

  -- Public identity helpers for cooperative mods. Reading an existing ID does
  -- not mutate the Pokemon; ensurePokemonId is explicit for integrations that
  -- need a Nuzlocke-owned stable token immediately.
  if mod.exports.nuzlocke_compat then
      mod.exports.nuzlocke_compat.getPokemonId = function(mon)
          return pokemonIdentity(mon)
      end
      mod.exports.nuzlocke_compat.ensurePokemonId = function(mon, game, origin)
          return ensurePokemonIdentity(mon,
              game and game.save or currentSave,
              origin or (mon and mon.nuzlockeOrigin) or "NORMAL")
      end
  end


      return {
          fingerprint = pokemonFingerprint,
          isShiny = monIsShiny,
          isLegendarySpecies = isLegendarySpecies,
          isMythicalSpecies = isMythicalSpecies,
          isPseudoSpecies = isPseudoSpecies,
          allCurrentMons = allCurrentMons,
          identityRegistry = identityRegistry,
          existingPokemonIdentity = existingPokemonIdentity,
          ensurePokemonIdentity = ensurePokemonIdentity,
          pokemonIdentity = pokemonIdentity,
          samePokemonIdentity = samePokemonIdentity,
          setPokemonOrigin = setPokemonOrigin,
          baselineAdd = baselineAdd,
          initializePokemonProvenance = initializePokemonProvenance,
      }
  end)()

  -- Normalize only Nuzlocke-owned records. The live Pokemon's species field is
  -- never rewritten: MissingNo and mod-defined glitch payloads may rely on the
  -- original numeric/string representation to remain usable by their owner.
  mod.exports.__beta26.annotateGlitchData = function(game, save)
      save = save or (game and game.save) or currentSave
      if not save then return false end
      local changed = false

      for _, mon in ipairs(Identity.allCurrentMons(save)) do
          if type(mon) == "table" and mon.species ~= nil then
              local info = mod.exports.__beta26.getGlitchSpeciesInfo(game, mon.species)
              if info.isGlitch then
                  mon.nuzlockeGlitch = true
                  mon.nuzlockeMissingNo = info.missingNo or nil
                  mon.nuzlockeRawSpecies = mon.nuzlockeRawSpecies or mon.species
                  changed = true
              end
          end
      end

      local function normalizeRecord(record)
          if type(record) ~= "table" or record.species == nil then return end
          local source = record.rawSpecies or record.species
          local info = mod.exports.__beta26.getGlitchSpeciesInfo(game, source)
          if info.isGlitch then
              record.rawSpecies = record.rawSpecies or record.species
              record.species = info.key
              record.glitch = true
              record.missingNo = info.missingNo or nil
              if record.encounterType == nil then record.encounterType = "glitch" end
              changed = true
          end
      end

      for _, entries in pairs(trackerLog()) do
          if type(entries) == "table" then
              for _, record in ipairs(entries) do normalizeRecord(record) end
          end
      end
      local history = mod.save:get("nuzlocke_history", {})
      if type(history) == "table" then
          for _, record in ipairs(history) do normalizeRecord(record) end
          mod.save:set("nuzlocke_history", history)
      end
      local states = mod.save:get("encounter_states", {})
      if type(states) == "table" then
          for _, record in pairs(states) do normalizeRecord(record) end
          mod.save:set("encounter_states", states)
      end
      if changed then mod.save:set("tracker_log", trackerLog()) end
      return changed
  end

  local function restoreKnownCatchMetadata(save, log)
      -- Imported/old Gen 1 saves do not serialize our transient Pokemon fields.
      -- Rebuild those fields from the Nuzlocke tracker data when the tracker
      -- already knows the species/location. This is stronger evidence than
      -- vanilla encounter inference and prevents legitimate old catches from
      -- being demoted to LEGACY merely because the Pokemon object lost its
      -- runtime metadata during save conversion.
      local assignments = {}
      local assignmentsById = {}

      local function addEvidence(area, entry)
          if area == "__LEGACY__" or type(entry) ~= "table" or not entry.species then
              return
          end
          local sp = tostring(entry.species):upper()
          local evidence = {
              area = area,
              pokemonId = entry.pokemonId,
              fingerprint = entry.fingerprint,
              provenance = entry.provenance,
              encounterType = entry.encounterType,
              encounterSource = entry.encounterSource,
              encounterProvider = entry.encounterProvider,
              encounterProviderVersion = entry.encounterProviderVersion,
              encounterContext = entry.encounterContext,
          }
          assignments[sp] = assignments[sp] or {}
          assignments[sp][#assignments[sp] + 1] = evidence
          if entry.pokemonId then assignmentsById[tostring(entry.pokemonId)] = evidence end
      end

      for area, entries in pairs(log or {}) do
          if type(entries) == "table" then
              for _, entry in ipairs(entries) do
                  addEvidence(area, entry)
              end
          end
      end

      -- Older versions also kept one authoritative species per area in
      -- caught_areas. Use it as recovery evidence if the detailed tracker log
      -- was not present, or if an imported Pokemon lost its transient fields.
      local areaTable = caughtAreas()
      for area, species in pairs(areaTable) do
          if area ~= "__LEGACY__" and species then
              local sp = tostring(species):upper()
              assignments[sp] = assignments[sp] or {}
              local already = false
              for _, ev in ipairs(assignments[sp]) do
                  if ev.area == area then already = true; break end
              end
              if not already then
                  assignments[sp][#assignments[sp] + 1] = { area = area }
              end
          end
      end

      local used = {}
      for _, mon in ipairs(collectLegacyMons(save)) do
          if type(mon) == "table" and mon.species and not mon.catchLocation then
              local sp = tostring(mon.species):upper()
              local monId = Identity.pokemonIdentity(mon)
              local evidence = monId and assignmentsById[monId] or nil
              local usedKey

              if evidence then
                  usedKey = "ID:" .. monId
              else
                  local list = assignments[sp]
                  local slot = list and 1 or nil
                  while slot and used[sp .. ":" .. tostring(slot)] do
                      slot = slot + 1
                      if not list[slot] then slot = nil end
                  end
                  evidence = slot and list[slot] or nil
                  usedKey = slot and (sp .. ":" .. tostring(slot)) or nil
              end

              if evidence and evidence.area and not (usedKey and used[usedKey]) then
                  if usedKey then used[usedKey] = true end
                  if not mon.nuzlockeId and evidence.pokemonId then
                      mon.nuzlockeId = tostring(evidence.pokemonId)
                  end
                  if evidence.provenance and not mon.nuzlockeOrigin then
                      mon.nuzlockeOrigin = evidence.provenance
                  end
                  mon.catchLocation = evidence.area
                  mon.encounterType = evidence.encounterType or mon.encounterType or "wild"
                  mon.nuzlockeEncounterSource = evidence.encounterSource or mon.nuzlockeEncounterSource
                  mon.nuzlockeEncounterProvider = evidence.encounterProvider or mon.nuzlockeEncounterProvider
                  mon.nuzlockeEncounterProviderVersion = evidence.encounterProviderVersion or mon.nuzlockeEncounterProviderVersion
                  if evidence.encounterContext then
                      mon.nuzlockeEncounterContext = evidence.encounterContext
                  end
                  mon.nuzlockeTrackerRegistered = true
                  Identity.ensurePokemonIdentity(mon, save, mon.nuzlockeOrigin or evidence.provenance or "NORMAL")
              end
          end
      end
  end

  -- Rebuild tracker entries from catch-location metadata that survived
  -- mod removal/reinstallation.  Catch Info can still know a Pokemon was
  -- caught on (for example) Route 1 even when tracker_log/caught_areas were
  -- lost with an older mod install.  That metadata is stronger evidence than
  -- species-only encounter inference, so restore it directly.
  local function importStoredCatchLocations(save, log, areas)
      local changed = false

      for _, mon in ipairs(collectLegacyMons(save)) do
          if type(mon) == "table" and mon.species and mon.catchLocation then
              local area = resolveCatchLocation(mon.catchLocation)
              if area then
                  area = registerArea(area)
              end

              if area and isTrackedArea(area) then
                  log[area] = log[area] or {}
                  local sp = tostring(mon.species):upper()
                  local found = false
                  local monId = Identity.ensurePokemonIdentity(mon, save, mon.nuzlockeOrigin or "LEGACY")
                  for _, entry in ipairs(log[area]) do
                      if type(entry) == "table"
                          and ((monId and entry.pokemonId == monId)
                              or tostring(entry.species or ""):upper() == sp) then
                          found = true
                          entry.pokemonId = entry.pokemonId or monId
                          entry.fingerprint = entry.fingerprint or Identity.fingerprint(mon)
                          break
                      end
                  end

                  -- Respect the one-catch-per-area rule when the area already
                  -- contains a different species.  We only restore missing
                  -- historical evidence; we never overwrite an established
                  -- catch.
                  if not found and #log[area] == 0 then
                      table.insert(log[area], {
                          species = sp,
                          pokemonId = Identity.ensurePokemonIdentity(mon, save, mon.nuzlockeOrigin or "LEGACY"),
                          fingerprint = Identity.fingerprint(mon),
                          isShiny = Identity.isShiny(mon),
                          encounterType = mon.encounterType or "wild",
                          encounterSource = mon.nuzlockeEncounterSource or "stored",
                          encounterProvider = mon.nuzlockeEncounterProvider,
                          encounterProviderVersion = mon.nuzlockeEncounterProviderVersion,
                          encounterContext = mon.nuzlockeEncounterContext,
                          retroactive = true,
                          recoveryStatus = "STORED_LOCATION",
                      })
                      areas[area] = sp
                      markVisited(area)
                      changed = true
                  elseif found and areas[area] == nil then
                      areas[area] = sp
                      markVisited(area)
                      changed = true
                  end

                  mon.nuzlockeTrackerRegistered = true
              end
          end
      end

      if changed then
          mod.save:set("tracker_log", log)
          mod.save:set("caught_areas", areas)
      end
      return changed
  end

  local function addLegacyMonsToLog(save)
      local log = trackerLog()
      restoreKnownCatchMetadata(save, log)
      local legacy = log.__LEGACY__

      if type(legacy) ~= "table" then
          legacy = {}
      end

      local existing = {}
      local existingIds = {}

      for _, entry in ipairs(legacy) do
          if type(entry) == "table" then
              local species = tostring(entry.species or "")
              existing[species] = (existing[species] or 0) + 1
              if entry.pokemonId then existingIds[tostring(entry.pokemonId)] = true end
          end
      end

      local currentCounts = {}
      local provenanceInitialized =
          mod.save:get("nuzlocke_provenance_initialized", false) == true

      -- A Pokemon with catchLocation was caught after the tracker was active.
      -- It must never be copied into LEGACY just because it is present in the
      -- current save's party/boxes.
      for _, mon in ipairs(collectLegacyMons(save)) do
          if not mon.catchLocation then
              local species = tostring(mon.species or "")
              local monId = Identity.existingPokemonIdentity(mon)
              local registryEntry = monId and Identity.identityRegistry()[monId] or nil
              local knownOrigin = type(registryEntry) == "table" and registryEntry.origin
                  or mon.nuzlockeOrigin

              -- Once provenance has been initialized, a brand-new unregistered
              -- Pokemon belongs to the EDITED classifier, not the legacy bucket.
              local mayBeLegacy = not provenanceInitialized
                  or knownOrigin == "LEGACY"

              if mayBeLegacy then
                  monId = monId or Identity.ensurePokemonIdentity(mon, save, nil)
                  currentCounts[species] = (currentCounts[species] or 0) + 1

                  if not (monId and existingIds[monId])
                      and currentCounts[species] > (existing[species] or 0) then
                      table.insert(legacy, {
                          species = species,
                          pokemonId = monId,
                          fingerprint = Identity.fingerprint(mon),
                          isShiny = Identity.isShiny(mon),
                          legacy = true,
                          provenance = "LEGACY",
                      })
                      if monId then existingIds[monId] = true end
                  end
              end
          end
      end

      -- Remove accidental legacy entries for Pokemon that the tracker already
      -- knows were caught in a real area.  This repairs saves that were loaded
      -- by an earlier version which incorrectly added current Pokemon to
      -- LEGACY.
      local knownCaught = {}
      local knownCaughtIds = {}
      for area, catches in pairs(log) do
          if area ~= "__LEGACY__" and type(catches) == "table" then
              for _, catch in ipairs(catches) do
                  if type(catch) == "table" and catch.species then
                      knownCaught[tostring(catch.species)] = true
                      if catch.pokemonId then
                          knownCaughtIds[tostring(catch.pokemonId)] = true
                      end
                  end
              end
          end
      end

      local cleanedLegacy = {}
      for _, entry in ipairs(legacy) do
          if type(entry) == "table" and entry.species then
              local duplicate
              if entry.pokemonId then
                  duplicate = knownCaughtIds[tostring(entry.pokemonId)] == true
              else
                  -- Pre-beta.19 rows have no persistent Pokemon identity;
                  -- retain species-only cleanup strictly as a migration fallback.
                  duplicate = knownCaught[tostring(entry.species)] == true
              end
              if not duplicate then table.insert(cleanedLegacy, entry) end
          end
      end

      if #cleanedLegacy > 0 then
          log.__LEGACY__ = cleanedLegacy
      else
          log.__LEGACY__ = nil
      end

      mod.save:set("tracker_log", log)
  end

  ---------------------------------------------------------------------
  -- LEGACY CATCH RECOVERY
  --
  -- Existing Gen 1 saves do not contain a native catch-location field.
  -- We therefore recover only information that is provable from current
  -- game data:
  --
  --   EXACT      = known gift/trade/starter location
  --   UNIQUE     = species occurs in exactly one wild area in the loaded
  --                encounter data
  --   AMBIGUOUS  = multiple possible wild areas; player chooses
  --   UNKNOWN    = no safe location can be inferred
  --
  -- Never guess between multiple routes.
  ---------------------------------------------------------------------
  local function encounterSpeciesByArea(game)
      local result = {}
      local data = game and game.data
      local encounters = data and data.encounters

      if type(encounters) ~= "table" then
          return result
      end

      for rawArea, def in pairs(encounters) do
          local area = registerArea(rawArea)
          if area and type(def) == "table" then
              local speciesSet = {}
              local function scan(node)
                  if type(node) ~= "table" then return end
                  if type(node.species) == "string" then
                      speciesSet[tostring(node.species):upper()] = true
                  end
                  for k, v in pairs(node) do
                      if k ~= "species" and type(v) == "table" then
                          scan(v)
                      end
                  end
              end
              scan(def)

              if next(speciesSet) then
                  result[area] = speciesSet
              end
          end
      end
      return result
  end

  local function legacyCandidates(game, species)
      species = tostring(species or ""):upper()
      if species == "" then return {} end

      local encounterAreas = encounterSpeciesByArea(game)
      local candidates = {}
      for area, speciesSet in pairs(encounterAreas) do
          if speciesSet[species] then
              candidates[#candidates + 1] = area
          end
      end

      table.sort(candidates, function(a, b)
          return (ROUTE_ORDER[a] or 999999) < (ROUTE_ORDER[b] or 999999)
      end)
      return candidates
  end

  local function recoverUniqueLegacyCatches(game, log, areas, gameVersion)
      local legacy = log["__LEGACY__"]
      if type(legacy) ~= "table" then return false end

      -- Never infer historical locations from vanilla encounter data when an
      -- external encounter provider is active or has been observed earlier in
      -- this save. The provider's historical context is authoritative.
      local providerHistory = mod.save:get("encounter_provider_history")
      if type(providerHistory) == "table" and next(providerHistory) ~= nil then
          return false
      end
      if activeCompatProvider("encounters", currentGame, nil) then
          return false
      end

      local changed = false
      local remaining = {}

      -- Same static knowledge already used by the older migration path.
      local known = {
          MAGIKARP = { area = "ROUTE_4", type = "gift" },
          HITMONCHAN = { area = "SAFFRON_CITY", type = "gift" },
          HITMONLEE = { area = "SAFFRON_CITY", type = "gift" },
          LAPRAS = { area = "SILPH_CO", type = "gift" },
          EEVEE = { area = "CELADON_CITY", type = "gift" },
          OMANYTE = { area = "CINNABAR_ISLAND", type = "gift" },
          KABUTO = { area = "CINNABAR_ISLAND", type = "gift" },
          AERODACTYL = { area = "CINNABAR_ISLAND", type = "gift" },
          SCYTHER = { area = "CELADON_CITY", type = "gift" },
          PORYGON = { area = "CELADON_CITY", type = "gift" },
          DRATINI = { area = "CELADON_CITY", type = "gift" },
          PINSIR = { area = "CELADON_CITY", type = "gift" },
          JOLTEON = { area = "CELADON_CITY", type = "gift" },
          VAPOREON = { area = "CELADON_CITY", type = "gift" },
          FLAREON = { area = "CELADON_CITY", type = "gift" },
          JYNX = { area = "CERULEAN_CITY", type = "trade" },
          FARFETCHD = { area = "VERMILION_CITY", type = "trade" },
          MR_MIME = { area = "ROUTE_2", type = "trade" },
          LICKITUNG = { area = "FUCHSIA_CITY", type = "trade" },
          ELECTRODE = { area = "CINNABAR_ISLAND", type = "trade" },
          GOLEM = { area = "CINNABAR_ISLAND", type = "trade" },
          KANGASKHAN = { area = "SAFARI_ZONE", type = "trade" },
          MACHOKE = { area = "ROUTE_5", type = "trade" },
      }

      if tostring(gameVersion or ""):upper() == "YELLOW" then
          known.BULBASAUR = { area = "CERULEAN_CITY", type = "gift" }
          known.CHARMANDER = { area = "ROUTE_24", type = "gift" }
          known.SQUIRTLE = { area = "VERMILION_CITY", type = "gift" }
      end

      for _, entry in ipairs(legacy) do
          local sp = tostring(entry and entry.species or ""):upper()
          local candidates = legacyCandidates(game, sp)
          local knownSource = known[sp]

          if knownSource then
              -- Static gifts/trades are exact historical sources. Do not let
              -- the one-catch-per-area runtime rule prevent migration from
              -- restoring a legitimate additional gift/trade on an area.
              candidates = { knownSource.area }
          end

          if #candidates == 1 then
              local area = candidates[1]
              registerArea(area)
              log[area] = log[area] or {}
              local exists = false
              for _, existing in ipairs(log[area]) do
                  if tostring(existing.species or ""):upper() == sp then
                      exists = true
                      break
                  end
              end
              if not exists then
                  table.insert(log[area], {
                      species = sp,
                      pokemonId = entry.pokemonId,
                      fingerprint = entry.fingerprint,
                      isShiny = entry.isShiny == true,
                      encounterType = knownSource and knownSource.type or "wild",
                      encounterSource = "vanilla",
                      recoveryStatus = "DETERMINED",
                      retroactive = true,
                  })
              end
              if areas[area] == nil then
                  areas[area] = sp
              end
              markVisited(area)
              changed = true
          else
              entry.recoveryStatus = (#candidates > 1) and "AMBIGUOUS"
                  or "UNKNOWN"
              entry.possibleAreas = candidates
              if #candidates == 0 then
                  -- A save-editor/imported Pokemon (for example BLASTOISE) may
                  -- not exist in any wild encounter table. It is still valid to
                  -- ask the player where it belongs; recovery must never depend
                  -- on the species being a wild encounter.
                  entry.possibleAreas = {}
                  for _, areaDef in ipairs(getDisplayRoutes(game)) do
                      entry.possibleAreas[#entry.possibleAreas + 1] = areaDef.id
                  end
                  entry.recoveryStatus = "UNKNOWN"
              end
              table.insert(remaining, entry)
          end
      end

      if #remaining > 0 then
          log["__LEGACY__"] = remaining
      else
          log["__LEGACY__"] = nil
      end

      return changed
  end

  local function recoverLegacyEntriesFromProvider(save, log)
      local provider = activeCompatProvider("encounters", currentGame, nil)
      if not provider then return log end
      local legacy = log["__LEGACY__"] or {}
      local remaining = {}
      for _, entry in ipairs(legacy) do
          local recovered = providerRecover(provider, save, { species = entry.species, dvs = entry.dvs })
          if recovered and recovered.location then
              local area = registerArea(recovered.location, recovered.areaName)
              local areas = caughtAreas()
              if area and not areas[area] then
                  log[area] = log[area] or {}
                  table.insert(log[area], {
                      species = tostring(entry.species):upper(),
                      pokemonId = entry.pokemonId,
                      fingerprint = entry.fingerprint,
                      isShiny = entry.isShiny == true,
                      encounterType = recovered.encounterType or "wild",
                      encounterSource = "provider",
                      encounterProvider = provider.id,
                      encounterProviderVersion = provider.version,
                      encounterContext = recovered.context,
                      retroactive = true,
                      recoveryStatus = "PROVIDER",
                  })
                  areas[area] = tostring(entry.species):upper()
                  mod.save:set("caught_areas", areas)
                  markVisited(area)
              else
                  table.insert(remaining, entry)
              end
          else
              entry.recoveryStatus = entry.recoveryStatus or "UNKNOWN"
              entry.encounterSource = entry.encounterSource or "unknown"
              table.insert(remaining, entry)
          end
      end
      if #remaining > 0 then log["__LEGACY__"] = remaining else log["__LEGACY__"] = nil end
      mod.save:set("tracker_log", log)
      return log
  end

  ---------------------------------------------------------------------
  -- REBUILD TRACKER FROM AN EXISTING SAVE
  ---------------------------------------------------------------------
  local function rebuildTrackerFromSave(save)
      if type(save) ~= "table" then
          return
      end

      if type(mod.save:get("encounter_provider_history")) ~= "table" then
          mod.save:set("encounter_provider_history", {})
      end

      -------------------------------------------------------------------
      -- 1. Normalize anything already stored by older versions.
      -------------------------------------------------------------------
      local oldVisited = mod.save:get("visited_areas")

      if type(oldVisited) == "table" then
          local normalizedVisited, changed =
              normalizeMapTable(oldVisited)

          if changed then
              mod.save:set("visited_areas", normalizedVisited)
          end
      else
          mod.save:set("visited_areas", {})
      end

      local oldCaught = mod.save:get("caught_areas")

      if type(oldCaught) == "table" then
          local normalizedCaught, changed =
              normalizeMapTable(oldCaught)

          if changed then
              mod.save:set("caught_areas", normalizedCaught)
          end
      else
          mod.save:set("caught_areas", {})
      end

      local oldLog = mod.save:get("tracker_log")

      if type(oldLog) == "table" then
          local normalizedLog, changed =
              normalizeTrackerLog(oldLog)

          if changed then
              mod.save:set("tracker_log", normalizedLog)
          end
      else
          mod.save:set("tracker_log", {})
      end

      syncCaughtAreasFromLog()
      if type(mod.save:get("nuzlocke_losses")) ~= "number" then
          mod.save:set("nuzlocke_losses", 0)
      end

      -------------------------------------------------------------------
      -- 2. Discover every map definition exposed by the current build.
      -------------------------------------------------------------------
      discoverAllKnownAreas({ data = nil, save = save })

      -------------------------------------------------------------------
      -- 3. Import the vanilla save's visited table.
      --
      -- The engine itself stores vanilla town visitation in save.visited.
      -------------------------------------------------------------------
      if type(save.visited) == "table" then
          for mapId, wasVisited in pairs(save.visited) do
              if wasVisited then
                  registerArea(mapId)
                  markVisited(mapId)
              end
          end
      end

      -------------------------------------------------------------------
      -- 3. Always mark the player's current map.
      --
      -- This fixes old saves even when they have never been seen by the
      -- Nuzlocke mod before.
      -------------------------------------------------------------------
      if save.player and save.player.map then
          markVisited(save.player.map)
      end

      -------------------------------------------------------------------
      -- 4. Also use lastOutdoor/lastHeal when they refer to a tracked map.
      --
      -- These aren't a complete travel history, but they are reliable
      -- save-state evidence that the map was relevant to the playthrough.
      -------------------------------------------------------------------
      if type(save.lastOutdoor) == "table" then
          markVisited(save.lastOutdoor.id)
      end

      if type(save.lastHeal) == "table" then
          markVisited(save.lastHeal.map)
      end

      -------------------------------------------------------------------
      -- 5. Preserve any old mod catch log.
      --
      -- We intentionally DO NOT fabricate locations for old Pokemon.
      -------------------------------------------------------------------
      addLegacyMonsToLog(save)

      -- Restore tracker rows from persistent Pokemon catch locations before
      -- attempting any species-based legacy inference.
      importStoredCatchLocations(save, trackerLog(), caughtAreas())

      -------------------------------------------------------------------
      -- 6. Retroactive save compatibility.
      --
      -- If PALLET_TOWN has no caught entry yet, but the party/boxes
      -- contain a starter species, assign it now.  This handles saves
      -- that existed before starter tracking was added.
      --
      -- Similarly, any LEGACY-tagged Pokemon whose species exactly
      -- matches a known gift location is moved to that area's slot,
      -- provided that slot is still empty.
      -------------------------------------------------------------------
      local areas = caughtAreas()
      local log   = trackerLog()

      -- Let an active encounter provider recover its own historical data first.
      log = recoverLegacyEntriesFromProvider(save, log)

      -- Use the same defensive version detector everywhere. Keeping version
      -- logic centralized prevents another recovery-only scope/detection drift.
      local rebuildVersion = getGameVersion and getGameVersion() or "RED"

      -- 6a. Starter → PALLET_TOWN
      if not areas["PALLET_TOWN"] then
          local starterSets = {}
          if rebuildVersion == "YELLOW" then
              starterSets.PIKACHU = true
          else
              starterSets.BULBASAUR = true
              starterSets.CHARMANDER = true
              starterSets.SQUIRTLE = true
          end
          local function findStarterInList(list)
              for _, mon in ipairs(list or {}) do
                  if mon and starterSets[tostring(mon.species or ""):upper()] then
                      return mon
                  end
              end
              return nil
          end

          local starterMon = findStarterInList(save.party)
          if not starterMon then
              for _, box in ipairs(save.boxes or {}) do
                  starterMon = findStarterInList(box)
                  if starterMon then break end
              end
          end

          if starterMon then
              local sp = tostring(starterMon.species or ""):upper()
              registerArea("PALLET_TOWN")
              log["PALLET_TOWN"] = log["PALLET_TOWN"] or {}

              -- Only insert if not already in the log for this area.
              local alreadyLogged = false
              for _, entry in ipairs(log["PALLET_TOWN"]) do
                  if tostring(entry.species or ""):upper() == sp then
                      alreadyLogged = true; break
                  end
              end
              if not alreadyLogged then
                  table.insert(log["PALLET_TOWN"], {
                      species       = sp,
                      pokemonId     = Identity.ensurePokemonIdentity(starterMon, save, starterMon.nuzlockeOrigin or "LEGACY"),
                      fingerprint   = Identity.fingerprint(starterMon),
                      isShiny       = Identity.isShiny(starterMon),
                      encounterType = "gift",
                      retroactive   = true,
                  })
              end

              areas["PALLET_TOWN"] = sp
              markVisited("PALLET_TOWN")

              -- Tag the mon so future loads don't re-assign it.
              if not starterMon.catchLocation then
                  starterMon.catchLocation = "PALLET_TOWN"
                  starterMon.encounterType = "gift"
              end

              -- The old-save scan may have placed this starter in LEGACY
              -- before we recognized it. Remove exactly one matching legacy
              -- entry so it cannot later be mistaken for a second catch.
              local legacyEntries = log["__LEGACY__"]
              if type(legacyEntries) == "table" then
                  local removed = false
                  local keptLegacy = {}
                  for _, entry in ipairs(legacyEntries) do
                      if not removed
                          and tostring(entry.species or ""):upper() == sp then
                          removed = true
                      else
                          table.insert(keptLegacy, entry)
                      end
                  end
                  if #keptLegacy > 0 then
                      log["__LEGACY__"] = keptLegacy
                  else
                      log["__LEGACY__"] = nil
                  end
              end
          end
      end

      -- 6b. Recover provable legacy catches from static sources and the
      -- current encounter tables. Ambiguous catches remain in LEGACY for
      -- player-assisted recovery.
      recoverUniqueLegacyCatches(currentGame
          or { data = require("src.core.Data"), save = save },
          log, areas, rebuildVersion)

      -- Repair old bad migration data only. Red/Blue do not have a Route 24
      -- Charmander gift. Older builds could create one during migration, and
      -- older normalization could strip the retroactive marker.
      if rebuildVersion ~= "YELLOW" then
          local entries = log["ROUTE_24"]
          if type(entries) == "table" then
              local kept = {}
              for _, entry in ipairs(entries) do
                  local species = tostring(entry and entry.species or ""):upper()
                  local encounterType = tostring(entry and entry.encounterType or ""):lower()
                  local migratedCharmander =
                      species == "CHARMANDER"
                      and (entry.retroactive == true or encounterType == "gift")
                  if not migratedCharmander then
                      kept[#kept + 1] = entry
                  end
              end
              if #kept > 0 then
                  log["ROUTE_24"] = kept
              else
                  log["ROUTE_24"] = nil
                  areas["ROUTE_24"] = nil
              end
          end

          -- Red/Blue never have a Charmander gift on Route 24. Older
          -- migration code could nevertheless manufacture one. Remove every
          -- non-Pallet Charmander so the starter remains the single Charmander
          -- encounter shown by the log.
          for areaKeyValue, entries in pairs(log) do
              if areaKeyValue ~= "PALLET_TOWN" and type(entries) == "table" then
                  local kept = {}
                  for _, entry in ipairs(entries) do
                      if tostring(entry and entry.species or ""):upper() ~= "CHARMANDER" then
                          kept[#kept + 1] = entry
                      end
                  end
                  if #kept > 0 then
                      log[areaKeyValue] = kept
                  else
                      log[areaKeyValue] = nil
                      areas[areaKeyValue] = nil
                  end
              end
          end
      end

      -- De-duplicate identical species entries inside a single area. This is
      -- deliberately per-area: legitimate gift/trade species can coexist in
      -- the same city, but the same species must never be logged twice for the
      -- same encounter area.
      for areaKeyValue, entries in pairs(log) do
          if type(entries) == "table" then
              local seenSpecies = {}
              local kept = {}
              for _, entry in ipairs(entries) do
                  if type(entry) == "table" and entry.species then
                      local speciesKey = tostring(entry.species):upper()
                      if not seenSpecies[speciesKey] then
                          seenSpecies[speciesKey] = true
                          kept[#kept + 1] = entry
                      end
                  end
              end
              if #kept > 0 then
                  log[areaKeyValue] = kept
              elseif areaKeyValue ~= "__LEGACY__" then
                  log[areaKeyValue] = nil
                  areas[areaKeyValue] = nil
              end
          end
      end

      -------------------------------------------------------------------
      -- RECONCILE EXISTING POKEMON CATCH METADATA
      --
      -- Older/vanilla saves can retain catchLocation directly on the
      -- Pokemon even when this mod never saw the original catch.  The old
      -- migration only copied those Pokemon into __LEGACY__, which meant
      -- Catch Info could show ROUTE 1 while the encounter map/list showed
      -- nothing and encounter type remained UNKNOWN.
      --
      -- Treat an existing catchLocation as authoritative historical evidence.
      -- Do not infer a location from species here; use only data actually
      -- stored on the Pokemon.  This also keeps imported/edited Pokemon with
      -- no catchLocation available for player-assisted recovery.
      -------------------------------------------------------------------
      local function reconcilePokemonCatchLocations()
          local changed = false
          local mons = collectLegacyMons(save)

          local function normalizeType(mon)
              local value = mon and (mon.nuzlockeEncounterType or mon.encounterType)
              if value == nil or tostring(value) == "" then
                  return "wild"
              end
              return tostring(value):lower()
          end

          local function samePokemonEntry(entry, mon)
              return Identity.samePokemonIdentity(entry, mon)
          end

          for _, mon in ipairs(mons) do
              if type(mon) == "table" and mon.species and mon.catchLocation then
                  local area = resolveCatchLocation(mon.catchLocation)
                  if area and area ~= "" and area ~= "__LEGACY__" then
                      area = registerArea(area)
                      if area then
                          log[area] = log[area] or {}

                      local exists = false
                      for _, entry in ipairs(log[area]) do
                          if samePokemonEntry(entry, mon) then
                              exists = true
                              -- Fill missing historical metadata without
                              -- overwriting richer data already recorded.
                              entry.encounterType = entry.encounterType
                                  or mon.nuzlockeEncounterType
                                  or mon.encounterType
                                  or "wild"
                              entry.isShiny = entry.isShiny == true
                                  or (Identity.isShiny(mon))
                              entry.pokemonId = entry.pokemonId
                                  or Identity.ensurePokemonIdentity(mon, save, mon.nuzlockeOrigin or "LEGACY")
                              entry.fingerprint = entry.fingerprint or Identity.fingerprint(mon)
                              entry.retroactive = entry.retroactive or true
                              entry.recoveryStatus = entry.recoveryStatus or "LEGACY_METADATA"
                              break
                          end
                      end

                      if not exists then
                          table.insert(log[area], {
                              species = tostring(mon.species):upper(),
                              pokemonId = Identity.ensurePokemonIdentity(mon, save, mon.nuzlockeOrigin or "LEGACY"),
                              isShiny = Identity.isShiny(mon),
                              encounterType = normalizeType(mon),
                              encounterSource = mon.nuzlockeEncounterSource or "legacy_save",
                              encounterProvider = mon.nuzlockeEncounterProvider,
                              encounterProviderVersion = mon.nuzlockeEncounterProviderVersion,
                              encounterContext = mon.nuzlockeEncounterContext,
                              fingerprint = Identity.fingerprint(mon),
                              provenance = mon.nuzlockeOrigin or "LEGACY",
                              recoveryStatus = "LEGACY_METADATA",
                              retroactive = true,
                          })
                          changed = true
                      end

                      -- A catchLocation surviving from the original save is
                      -- evidence of a historical catch.  Unless this Pokemon
                      -- was already registered by the Nuzlocke tracker, keep
                      -- it classified as LEGACY rather than EDITED.
                      if mon.nuzlockeTrackerRegistered ~= true
                          and not mon.nuzlockeOrigin then
                          Identity.setPokemonOrigin(mon, "LEGACY")
                      end
                      mon.encounterType = mon.encounterType or "wild"
                      mon.nuzlockeTrackerRegistered = true
                      Identity.baselineAdd(mon, mon.nuzlockeOrigin or "LEGACY")
                      markVisited(area)

                      -- Remove one matching entry from __LEGACY__ if an older
                      -- migration placed this same Pokemon there.
                      local legacy = log.__LEGACY__
                      if type(legacy) == "table" then
                          local fp = Identity.fingerprint(mon)
                          local removed = false
                          local kept = {}
                          for _, entry in ipairs(legacy) do
                              local match = false
                              if not removed and type(entry) == "table"
                                  and tostring(entry.species or ""):upper()
                                      == tostring(mon.species or ""):upper() then
                                  if fp and entry.fingerprint then
                                      match = fp == entry.fingerprint
                                  else
                                      match = true
                                  end
                              end
                              if match then
                                  removed = true
                              else
                                  kept[#kept + 1] = entry
                              end
                          end
                          if #kept > 0 then log.__LEGACY__ = kept else log.__LEGACY__ = nil end
                          if removed then changed = true end
                      end
                  end
                  end
              end
          end

          return changed
      end

      reconcilePokemonCatchLocations()

      -- Reconcile actual party/box Pokémon one final time after all migration
      -- cleanup. Earlier passes can add authoritative entries only later in the
      -- migration (starter/gift/provider recovery), so this final pass ensures
      -- those locations are stamped back onto the actual Pokémon objects too.
      restoreKnownCatchMetadata(save, log)
      Identity.initializePokemonProvenance(save)
      mod.exports.__beta26.annotateGlitchData(currentGame, save)

      -- Re-sync the area map after the migration cleanup so a deleted bad log
      -- entry cannot leave a phantom catch on the tracker MAP.
      local normalizedAreas, areasChanged = normalizeMapTable(areas)
      if areasChanged then
          areas = normalizedAreas
      end

      mod.save:set("tracker_log",   log)
      mod.save:set("caught_areas",  areas)
  end

  ---------------------------------------------------------------------
  -- INITIAL SAVE-LOAD RECONSTRUCTION
  --
  -- save.loaded fires after the save has been restored/validated.
  -- This lets a newly installed version of the mod work with an old
  -- vanilla save that has never had Nuzlocke modData before.
  ---------------------------------------------------------------------
  mod.events:on("save.loaded", function(ev)
      if ev and ev.save then
          currentSave = ev.save
          if currentGame then currentGame.save = ev.save end
          rebuildTrackerFromSave(ev.save)
      end
  end)

  mod.events:on("game.ready", function(ev)
      local game = type(ev) == "table" and ev.game or ev
      game = game or currentGame
      if game and game.save then
          mod.exports.__beta26.annotateGlitchData(game, game.save)
      end
  end)

  ---------------------------------------------------------------------
  -- RULE DEFINITIONS
  ---------------------------------------------------------------------
  LEGENDARIES = {
      ARTICUNO = true,
      ZAPDOS   = true,
      MOLTRES  = true,
      MEWTWO   = true,
  }

  MYTHICALS = {
      MEW = true,
  }

  -- Metadata remains authoritative for modded species. These canonical
  -- pseudo-legendary final evolutions are a conservative fallback for content
  -- mods that inject later-generation species without pseudo metadata. Keep
  -- this species-based rather than BST-based so Maximum BST remains independent.
  PSEUDOS = {
      DRAGONITE = true,
      TYRANITAR = true,
      SALAMENCE = true,
      METAGROSS = true,
  }

  -- Persisted values remain numeric. Tier 4 bans the four strength-ranked
  -- standard Balls but deliberately leaves specialty/custom Balls eligible;
  -- tier 5 is the only every-Ball ban. Calling tier 4 "MASTER" made that
  -- cumulative scope look like a minimum allowed Ball instead of a ban scope.
  mod.exports.__beta26.ballBanTierLabels = {
      [0] = Strings.source("OFF"), [1] = Strings.source("POKE"),
      [2] = Strings.source("GREAT"), [3] = Strings.source("ULTRA"),
      [4] = Strings.source("STANDARD"), [5] = Strings.source("ALL"),
  }

  -- Stored as compact preset indices so active saves remain stable if the UI
  -- wording changes. 0 is literal vanilla creation (zero Stat EXP). 100% is
  -- defined as half the engine storage range so the requested 200% preset can
  -- reach, but never exceed, the native 65535-per-stat ceiling.
  mod.exports.__beta26.statExpPresetLabels = {
      [0] = Strings.source("0%"), [1] = Strings.source("25%"),
      [2] = Strings.source("50%"), [3] = Strings.source("75%"),
      [4] = Strings.source("100%"), [5] = Strings.source("200%"),
  }
  mod.exports.__beta26.statExpPresetValues = {
      [0] = 0, [1] = 8192, [2] = 16384, [3] = 24576,
      [4] = 32768, [5] = 65535,
  }

  local ruleCategories = {
      {
          title = Strings.source("- CORE -"),
          rules = {
              { key = "nuzlocke_enabled", name = Strings.source("Nuzlocke"), desc = Strings.source("Master switch for all Nuzlocke rules. Toggle this off to disable everything.") },
              { key = "permadeath",       name = Strings.source("Permadeath"), desc = Strings.source("Fainted Pokemon are considered dead and removed from the party.") },
              { key = "first_rival_forgiveness", name = Strings.source("First Rival Mercy"), desc = Strings.source("Forgive faint and Whiteout consequences during only the opening Rival battle. The battle still plays and can still be lost normally. ON by default; the Hardcore preset turns it OFF. The exception is permanently consumed when that first Rival battle begins, even if no Pokemon faints.") },
              { key = "encounter_limit",  name = Strings.source("One Per Area"), desc = Strings.source("Only the first eligible catch per area can be caught.") },
              { key = "failed_encounter", name = Strings.source("Failed Encounters"), desc = Strings.source("If ON, your first eligible wild/overworld encounter consumes the area even if you defeat it, flee, or fail to catch it. Dupes encounters do not consume the area while Dupes Clause is ON; shiny Pokemon are always allowed when Shiny Clause is ON.") },
              { key = "nickname_rule",   name = Strings.source("Nickname Rule"), desc = Strings.source("You must enter a nickname for every Pokemon you catch.") },
          }
      },
      {
          title = Strings.source("- CLAUSES -"),
          rules = {
              { key = "dupes_mode", name = Strings.source("Dupes Clause"), numeric = true, digits = 1, min = 0, max = 2, desc = Strings.source("Choose duplicate handling. OFF = duplicates count normally. SPEC = only the exact species is a dupe. FAM = the entire evolution family is a dupe. Shiny Clause can still override Dupes.") },
              { key = "shiny_clause",    name = Strings.source("Shiny Clause"), desc = Strings.source("Shiny Pokemon are always allowed as catches, even when they would otherwise violate 1st Catch or Dupes.") },
          }
      },
      {
          title = Strings.source("- AREA SPLITS -"),
          rules = {
              { key = "route_splits", name = Strings.source("Route Splits"), numeric = true, digits = 1, min = 0, max = 1, desc = Strings.source("Choose numbered-route encounter areas. OFF = each route shares one encounter. CARDINAL = every Route 1-25 is divided North/South or West/East along its natural axis. Tracker rows, counts, Catch Info, and legality update immediately.") },
              { key = "mt_moon_splits", name = Strings.source("Mt Moon Splits"), numeric = true, digits = 1, min = 0, max = 1, desc = Strings.source("Choose Mt. Moon encounter areas. OFF = the whole dungeon shares one encounter. COMMON = 1F, B1F, and B2F each receive an encounter. Tracker rows, counts, and catch legality update immediately when changed.") },
              { key = "safari_zone_splits", name = Strings.source("Safari Splits"), numeric = true, digits = 1, min = 0, max = 1, desc = Strings.source("Choose Safari Zone encounter areas. OFF = the whole Safari Zone shares one encounter. COMMON = Center, East, North, and West each receive an encounter. Tracker rows, counts, and catch legality update immediately when changed.") },
          }
      },
      {
          title = Strings.source("- RANDOMIZER -"),
          rules = {
              { key = "random_starter", name = Strings.source("Random Starter"), desc = Strings.source("Randomize only the Pokemon you receive as your starter in Red, Blue, Yellow, or Gold. The selected ball and normal story/rival choice remain intact; encounters, trainers, gifts, items, and every other table stay vanilla. Invalid and glitch species are excluded. Only applies before the starter is received.") },
          }
      },
      {
          title = Strings.source("- GENERAL -"),
          rules = {
              { key = "overworld_encounters", name = Strings.source("Overworld"), desc = Strings.source("Allow Pokemon caught from overworld spawns to count as area encounters.") },
              { key = "town_catches",         name = Strings.source("Town Catches"), desc = Strings.source("Allow Pokemon caught in towns/cities to count as encounters. Pallet Town starter slot is always tracked regardless.") },
              { key = "ban_legendaries",      name = Strings.source("No Legendaries"), desc = Strings.source("Legendary Pokemon cannot be caught, gifted, or received in trades while this rule is active. Existing Pokemon are not removed.") },
              { key = "ban_mythicals",        name = Strings.source("No Mythicals"), desc = Strings.source("Mythical Pokemon cannot be caught, gifted, or received in trades while this rule is active. Existing Pokemon are not removed.") },
              { key = "ban_pseudos",          name = Strings.source("No Pseudos"), desc = Strings.source("Pseudo-legendary Pokemon cannot be caught, gifted, or received in trades while this rule is active. Existing Pokemon are not removed. In the supported games this includes Dragonite and Tyranitar.") },
              { key = "player_start_stat_exp", name = Strings.source("Player Stat EXP"), numeric = true, digits = 1, min = 0, max = 5, desc = Strings.source("Choose starting Stat EXP for newly acquired player Pokemon. 0% is vanilla (zero Stat EXP). Presets are 25%, 50%, 75%, 100%, and 200%; 200% reaches the engine's 65535-per-stat storage ceiling. Existing Pokemon are not changed.") },
              { key = "wild_start_stat_exp", name = Strings.source("Wild Stat EXP"), numeric = true, digits = 1, min = 0, max = 5, desc = Strings.source("Choose starting Stat EXP for newly generated wild Pokemon. 0% is vanilla. Higher presets make encountered wild Pokemon stronger immediately; existing Pokemon are not changed.") },
              { key = "trainer_start_stat_exp", name = Strings.source("Trainer Stat EXP"), numeric = true, digits = 1, min = 0, max = 5, desc = Strings.source("Choose starting Stat EXP for newly generated trainer Pokemon. 0% is vanilla. Higher presets strengthen trainer parties at battle creation without changing trainer species, levels, or moves.") },
              { key = "no_player_stat_exp_gain", name = Strings.source("No Stat EXP Gain"), desc = Strings.source("Player Pokemon cannot accumulate additional Stat EXP from battles or vitamins. Their existing Stat EXP is preserved, EXP and level gain still work normally, and enemy Pokemon are unaffected.") },
              { key = "perfect_player_ivs", name = Strings.source("Perfect Player IVs"), desc = Strings.source("Newly acquired player Pokemon receive perfect Gen 1/2 DVs (15 in every DV, including derived HP). Existing Pokemon are not changed.") },
              { key = "perfect_wild_ivs", name = Strings.source("Perfect Wild IVs"), desc = Strings.source("Newly generated wild Pokemon receive perfect Gen 1/2 DVs. If caught, the Player IV rule may then apply independently to the caught Pokemon.") },
              { key = "perfect_trainer_ivs", name = Strings.source("Perfect Trainer IVs"), desc = Strings.source("Newly generated trainer Pokemon receive perfect Gen 1/2 DVs instead of the vanilla trainer DV preset. Trainer species, levels, and moves are unchanged.") },
              { key = "no_static_encounters", name = Strings.source("No Static"), desc = Strings.source("Fixed overworld and scripted wild Pokemon cannot be caught. The battle still occurs normally, gifts remain controlled by Gift Pokemon, and ordinary grass, cave, surf, fishing, and roaming encounters are unaffected.") },
              { key = "no_gambling", name = Strings.source("No Gambling"), desc = Strings.source("Blocks Game Corner wagering and prize redemption before coins or prizes change hands. Story movement, the Rocket Hideout path, coin gifts, and buying coins remain available.") },
              { key = "maximum_bst", name = Strings.source("Maximum BST"), numeric = true, digits = 3, min = 0, max = 999, desc = Strings.source("Set the highest Base Stat Total allowed for new catches, gifts, and trades. 000/OFF disables the restriction. Mandatory starters are always exempt so story progression cannot be blocked. Pokemon with missing or incomplete modded stat data are allowed rather than guessed.") },
              { key = "allow_glitch_pokemon", name = Strings.source("Allow Glitches"), desc = Strings.source("Allow MissingNo, registry-flagged glitch species, and malformed/unregistered species to be caught or received. OFF blocks new glitch acquisitions safely before mutation. Existing glitch Pokemon are never deleted and remain visible as GLITCH in tracking UI.") },
              { key = "allow_gifts",      name = Strings.source("Gift Pokemon"), desc = Strings.source("Gift Pokemon (Eevee, Lapras, Fossils, etc.) are allowed and consume the area slot where they were received.") },
              { key = "allow_trades",     name = Strings.source("In-Game Trades"), desc = Strings.source("In-game traded Pokemon are allowed and consume the area slot where the trade NPC lives. Version-specific trades (Red/Blue/Yellow) are all accounted for.") },
              { key = "wonderlocke", name = Strings.source("Wonderlocke WIP"), desc = Strings.source("WIP: Wonderlocke is not currently selectable or active. It remains disabled while Wonder Trade compatibility is being completed and tested.") },
          }
      },
      {
          title = Strings.source("- BATTLE ITEMS -"),
          rules = {
              { key = "level_cap_scope", name = Strings.source("Level Cap Scope"), numeric = true, digits = 1, min = 0, max = 4, desc = Strings.source("Choose how far level caps continue. NONE = no caps. GYMS = Gym caps only. E4 = continue through Lorelei, Bruno, Agatha, and Lance. CHAMP = also cap the Champion. POSTGAME = also accept an active post-game cap provider from another mod. Each option includes everything before it. RECOMMENDED: E4 or CHAMP for a full Kanto run; POSTGAME if another mod adds post-game content.") },
              { key = "no_healing_items", name = Strings.source("No Healing Items"), desc = Strings.source("Potions, Revives, and status-healing items cannot be used in battle.") },
              { key = "no_battle_items",  name = Strings.source("No X Items"), desc = Strings.source("X Attack, X Defend, and similar non-healing battle items cannot be used in battle. Poke Balls are unaffected.") },
              { key = "no_escape",         name = Strings.source("No Escape"), desc = Strings.source("You cannot run from wild Pokemon. The RUN command always fails and the turn is spent.") },
              { key = "ball_use_ban_tier", name = Strings.source("Ball Use Ban"), numeric = true, digits = 1, min = 0, max = 5, desc = Strings.source("Block THROW/USE for cumulative Ball categories while still allowing acquisition, storage, tossing, buying, and selling when other rules permit. OFF = none. POKE bans Poke Ball. GREAT bans Poke + Great. ULTRA bans Poke + Great + Ultra. STANDARD bans Poke + Great + Ultra + Master while leaving specialty/custom Balls eligible. ALL bans every recognized Ball.") },
          }
      },
      {
          title = Strings.source("- FIELD ITEMS -"),
          rules = {
              { key = "no_repels", name = Strings.source("No Repels"), desc = Strings.source("Repel, Super Repel, and Max Repel cannot be used in the field. They may still be obtained, stored, tossed, or sold.") },
              { key = "no_escape_rope", name = Strings.source("No Escape Rope"), desc = Strings.source("Escape Rope cannot be used. It may still be obtained, stored, tossed, or sold.") },
              { key = "no_field_healing", name = Strings.source("No Field Heal"), desc = Strings.source("HP, status, and revival medicine cannot be used outside battle. PP recovery is controlled separately by No PP Items.") },
              { key = "no_pp_items", name = Strings.source("No PP Items"), desc = Strings.source("Ether/Elixer-family PP recovery and PP Up-style PP boosters cannot be used in or out of battle. This is independent of the battle-healing rule.") },
              { key = "no_tm_use", name = Strings.source("No TMs"), desc = Strings.source("Technical Machines cannot be used to teach moves. HMs remain usable. TMs may still be obtained, stored, tossed, bought, or sold when other rules permit.") },
              { key = "no_rare_candy_use", name = Strings.source("No Rare Candy"), desc = Strings.source("Rare Candy cannot be used. It may still be obtained, stored, tossed, bought, sold, or supplied by the Gym Guide when other rules permit.") },
          }
      },
      {
          title = Strings.source("- IRONMON -"),
          rules = {
              { key = "no_buying",      name = Strings.source("No Buying"), desc = Strings.source("Items cannot be purchased from shops. Selling is still allowed.") },
              { key = "no_selling",     name = Strings.source("No Selling"), desc = Strings.source("Items cannot be sold to shops. Buying is still allowed.") },
              { key = "no_poke_center",  name = Strings.source("No Center Heal"), desc = Strings.source("Cannot heal at Pokemon Centers. Nurse Joy will turn you away.") },
              { key = "no_mom_heal",      name = Strings.source("No Mom Heal"), desc = Strings.source("Mom cannot heal your party when you visit home. She will remind you of your rules instead.") },
              { key = "whiteout_clause",  name = Strings.source("Whiteout"), desc = Strings.source("If every Pokemon in the party faints, the run ends and the save is deleted permanently. This works independently of Permadeath.") },
              { key = "solo_active",      name = Strings.source("Solo Only"), desc = Strings.source("Only one Pokemon in the active party slot. Enforced at catch time; does not block PC swaps.") },
          }
      },
      {
          title = Strings.source("- WORLD -"),
          rules = {
              { key = "world_building_tier", name = Strings.source("World Building"), numeric = true, digits = 1, min = 0, max = 3, desc = Strings.source("Adds optional Nuzlocke flavor throughout Kanto. TIER 1 = core rule feedback, TIER 2 = extra snark, TIER 3 = NPC and story flavor. OFF disables all Nuzlocke world-building dialogue. RECOMMENDED: TIER 3. This is cosmetic and can be changed at any time.") },
          }
      },
      {
          title = Strings.source("- QOL -"),
          rules = {
              { key = "automatic_default_names", name = Strings.source("Default Names"), setupOnly = true, desc = Strings.source("Skip only the new-game player and Rival naming menus and choose each game's first canonical preset. R/B/Y keep Oak's confirmation dialogue. Gold uses GOLD for the player and keeps ??? until the later police report assigns SILVER. Pokemon nickname prompts are unaffected. NEW GAME only.") },
              { key = "skip_catch_tutorial", name = Strings.source("Skip Catch Demo"), setupOnly = true, goldOnly = true, desc = Strings.source("GOLD NEW GAME only: skip the Dude's Route 29 demonstration battle while preserving his approach, dialogue, map reload, scene completion, and learned-to-catch event. Ordinary wild battles and every later story path remain unchanged.") },
          }
      },
      {
          title = Strings.source("- UI -"),
          rules = {
              { key = "catch_info", name = Strings.source("Catch Info"), desc = Strings.source("Show CATCH INFO in the party menu for Pokemon you own.") },
              { key = "area_guide_enabled", name = Strings.source("Area Guide"), desc = Strings.source("Show the second Encounter Tracker page with all catchable areas. Turn OFF to restrict the tracker to your catches only.") },
              { key = "automatic_running_shoes", name = Strings.source("B-Button Run"), desc = Strings.source("Hold B while walking to run at twice normal walking speed in R/B/Y and Gold. Bicycling, surfing, scripted movement, and menus keep their normal behavior. OFF preserves vanilla movement.") },
          }
      },
  }


  ---------------------------------------------------------------------
  -- AREA GUIDE STATE
  --
  -- Area Guide is a normal Nuzlocke setting. The creator's mod uses
  -- mod.save for Nuzlocke state, so keep the setting there rather than
  -- using a separate storage layer that can return stale data.
  ---------------------------------------------------------------------
  local areaGuideEnabled = true

  local function loadAreaGuideState()
      local saved = mod.save:get("area_guide_enabled", nil)

      if type(saved) ~= "boolean" then
          saved = mod.save:get("route_list_all_areas", nil)
      end
      if type(saved) ~= "boolean" then
          saved = mod.save:get("show_checklist", nil)
      end

      if type(saved) == "boolean" then
          areaGuideEnabled = saved
      end

      return areaGuideEnabled
  end

  local function saveAreaGuideState(value)
      areaGuideEnabled = value == true
      mod.save:set("area_guide_enabled", areaGuideEnabled)
      return areaGuideEnabled
  end

  mod.exports.__beta26.legacySetupProfileFile = "nuzlocke_setup_profile.lua"
  mod.exports.__beta26.setupProfileFiles = {
      gen1 = "nuzlocke_setup_profile_gen1.lua",
      gold = "nuzlocke_setup_profile_gold.lua",
  }

  function mod.exports.__beta26.runtimeIsGold(game)
      if game and tonumber(game.generation) == 2 then return true end
      local okVersion, GameVersion = pcall(require, "src.core.GameVersion")
      if okVersion and type(GameVersion) == "table"
          and type(GameVersion.isGold) == "function" then
          local okGold, isGold = pcall(GameVersion.isGold)
          if okGold then return isGold == true end
      end
      return false
  end

  function mod.exports.__beta26.profileScopeForGame(game)
      return mod.exports.__beta26.runtimeIsGold(game) and "gold" or "gen1"
  end

  function mod.exports.__beta26.setupProfileFilename()
      return mod.exports.__beta26.setupProfileFiles[mod.exports.__beta26.setupProfileScope]
          or mod.exports.__beta26.setupProfileFiles.gen1
  end

  -- Shared rules profile used by the title-screen setup and the active save.
  -- When no save is loaded yet this is the staged setup for the next save.
  -- When a save is active it mirrors that save, so both menus stay in sync.
  local pendingNewGameRules = nil
  local pendingRulesDirty = false
  local pendingNewGameRulesForNextSave = false
  -- Immutable snapshot captured at the instant NEW GAME is selected.
  -- This is deliberately separate from the live UI mirror so later save
  -- initialization cannot replace selected OFF->ON values with defaults.
  local newGameRulesSnapshot = nil
  local newGameRulesCommitPending = false
  local newGameCommitPassesRemaining = 0

  function mod.exports.__beta26.selectSetupProfileScope(game)
      local scope = mod.exports.__beta26.profileScopeForGame(game)
      if mod.exports.__beta26.setupProfileScope ~= scope then
          mod.exports.__beta26.setupProfileScope = scope
          pendingNewGameRules = nil
          pendingRulesDirty = false
          pendingNewGameRulesForNextSave = false
          newGameRulesSnapshot = nil
          newGameRulesCommitPending = false
          newGameCommitPassesRemaining = 0
      end
      return scope
  end

  -- These keys persist the staged setup independently of the active save-rule
  -- keys.  They are declared here and used after copyRuleProfile is defined.
  local STAGED_PROFILE_KEY = "__nuzlocke_staged_new_game_profile"
  local STAGED_INTENT_KEY = "__nuzlocke_staged_new_game_intent"

  local function stagedProfileKey()
      return STAGED_PROFILE_KEY .. ":" .. mod.exports.__beta26.setupProfileScope
  end

  local function stagedIntentKey()
      return STAGED_INTENT_KEY .. ":" .. mod.exports.__beta26.setupProfileScope
  end

  ---------------------------------------------------------------------
  -- NEW GAME STARTER SETTINGS
  -- These values are read only when a brand-new save is constructed.
  -- Existing saves are never rewritten by this hook.
  ---------------------------------------------------------------------
  mod.hooks:wrap("save.new_game", function(next, save)
      local result = next(save)
      local targetSave = result or save
      currentSave = targetSave or currentSave
      if currentGame and currentSave then currentGame.save = currentSave end

      -- Agreed defaults for a new Nuzlocke run. The player can change these
      -- in NUZLOCKE SETUP before starting the NEW GAME.
      local startingMoney = 0
      local startingBalls = 0
      local startingCandies = 0
      local profile = newGameRulesSnapshot or pendingNewGameRules
      if profile then
          startingMoney = math.max(0, math.min(9999,
              math.floor(tonumber(profile.starting_money) or 0)))
          startingBalls = math.max(0, math.min(99,
              math.floor(tonumber(profile.starting_pokeballs) or 0)))

          -- Backward compatibility with setup profiles that stored this as a
          -- retired boolean "Start with 99 Rare Candy" setup toggle.
          if type(profile.starting_rare_candies) == "boolean" then
              startingCandies = profile.starting_rare_candies and 99 or 0
          else
              startingCandies = math.max(0, math.min(99,
                  math.floor(tonumber(profile.starting_rare_candies) or 0)))
          end
      end

      if targetSave then
          -- Gold's Route 29 tutorial occurs after title staging has been
          -- cleared. Carry this NEW GAME-only choice on the save, just as the
          -- delayed Gold Rival-name shortcut does, without inventing a story
          -- flag before the real Route 29 script reaches it.
          targetSave.nuzlockeSkipCatchTutorial =
              profile and profile.skip_catch_tutorial == true or nil

          -- Starting Money / Balls / Rare Candies are currently an R/B/Y Setup
          -- feature. Gold exposes a deliberately smaller beta Setup surface, so
          -- never overwrite Gold's native starting resources from hidden/stale
          -- Gen1 profile fields. In particular, do not defer Gold Poke Balls:
          -- the R/B/Y release seam is intentionally disabled for generation 2.
          local version = getGameVersion and getGameVersion() or "RED"
          local saveVersion = tostring(targetSave.version
              or targetSave.gameVersion or ""):upper()
          local gen2Start = version == "GOLD" or version == "SILVER"
              or version == "CRYSTAL"
              or saveVersion:find("GOLD", 1, true) ~= nil
              or saveVersion:find("SILVER", 1, true) ~= nil
              or saveVersion:find("CRYSTAL", 1, true) ~= nil

          if not gen2Start then
              targetSave.money = startingMoney
              targetSave.pcItems = targetSave.pcItems or {}

              -- Immutable run-start snapshot for the Nuzlocke side of the
              -- Trainer Card. These values describe the selected NEW GAME setup,
              -- not the player's current inventory/money, and are never rewritten
              -- by normal gameplay. Keeping them on the actual save object avoids
              -- depending on title-screen mod.save state during the NEW GAME seam.
              targetSave.nuzlockeRunStartMoney = startingMoney
              targetSave.nuzlockeRunStartBalls = startingBalls
              targetSave.nuzlockeRunStartCandies = startingCandies

              -- beta.26 Soft Start: configured starting Balls are intentionally
              -- held until Oak's Pokedex handoff. This prevents the challenge
              -- from arming during the pre-Pokedex portion of a fresh R/B/Y run.
              targetSave.nuzlockeDeferredStartingBalls =
                  startingBalls > 0 and startingBalls or nil
              targetSave.pcItems.POKE_BALL = nil
              targetSave.pcItems.RARE_CANDY =
                  startingCandies > 0 and startingCandies or nil
          else
              -- Clean up only stale mod-owned deferral metadata. Do not touch
              -- Gold's money, PC items, or any other native New Game resources.
              targetSave.nuzlockeDeferredStartingBalls = nil
              targetSave.nuzlockeRunStartMoney = nil
              targetSave.nuzlockeRunStartBalls = nil
              targetSave.nuzlockeRunStartCandies = nil
          end
      end

      return result or targetSave
  end)

  ---------------------------------------------------------------------
  -- LOCKE TYPE PRESETS
  --
  -- These presets only expose playstyles the current rule engine can already
  -- enforce without inventing a new subsystem. Optional clauses (Dupes/Shiny,
  -- gifts/trades, legendary bans), UI options, world-building, Gym Guide,
  -- and starting resources remain independent of the selected preset.
  --
  -- CUSTOM    = preserve the player's hand-built rules.
  -- NUZLOCKE  = classic core: permadeath, first encounter, failed encounter,
  --             and required nicknames.
  -- HARDCORE  = NUZLOCKE + caps through Champion + no healing/X items in battle.
  --             Gen1Recomp's native Battle Style option remains authoritative;
  --             players who want full Hardcore should set it to SET.
  -- SOLO      = NUZLOCKE + Solo Only + Whiteout, so the active solo faint ends
  --             the run. PC swaps remain available because that is how the
  --             existing Solo Only rule is intentionally implemented.
  ---------------------------------------------------------------------
  local LockePreset = {
      labels = {
          [0] = Strings.source("CUSTOM"),
          [1] = Strings.source("NUZ"),
          [2] = Strings.source("HARD"),
          [3] = Strings.source("SOLO"),
      },
      names = {
          [0] = Strings.source("CUSTOM"),
          [1] = Strings.source("NUZLOCKE"),
          [2] = Strings.source("HARDCORE"),
          [3] = Strings.source("SOLO"),
      },
      managed = {
          nuzlocke_enabled = true,
          permadeath = true,
          first_rival_forgiveness = true,
          encounter_limit = true,
          failed_encounter = true,
          nickname_rule = true,
          level_cap_scope = true,
          no_healing_items = true,
          no_battle_items = true,
          no_escape = true,
          no_repels = true,
          no_escape_rope = true,
          no_field_healing = true,
          no_pp_items = true,
          ball_use_ban_tier = true,
          maximum_bst = true,
          allow_glitch_pokemon = true,
          no_tm_use = true,
          no_rare_candy_use = true,
          no_buying = true,
          no_selling = true,
          no_poke_center = true,
          no_mom_heal = true,
          whiteout_clause = true,
          solo_active = true,
      },
      presets = {
          [1] = {
              nuzlocke_enabled = true,
              permadeath = true,
              first_rival_forgiveness = true,
              encounter_limit = true,
              failed_encounter = true,
              nickname_rule = true,
              level_cap_scope = 0,
              no_healing_items = false,
              no_battle_items = false,
              no_escape = false,
              no_repels = false,
              no_escape_rope = false,
              no_field_healing = false,
              no_pp_items = false,
              ball_use_ban_tier = 0,
              maximum_bst = 0,
              allow_glitch_pokemon = false,
              no_tm_use = false,
              no_rare_candy_use = false,
              no_buying = false,
              no_selling = false,
              no_poke_center = false,
              no_mom_heal = false,
              whiteout_clause = false,
              solo_active = false,
          },
          [2] = {
              nuzlocke_enabled = true,
              permadeath = true,
              first_rival_forgiveness = false,
              encounter_limit = true,
              failed_encounter = true,
              nickname_rule = true,
              level_cap_scope = 3,
              no_healing_items = true,
              no_battle_items = true,
              no_escape = false,
              no_repels = false,
              no_escape_rope = false,
              no_field_healing = false,
              no_pp_items = false,
              ball_use_ban_tier = 0,
              maximum_bst = 0,
              allow_glitch_pokemon = false,
              no_tm_use = false,
              no_rare_candy_use = false,
              no_buying = false,
              no_selling = false,
              no_poke_center = false,
              no_mom_heal = false,
              whiteout_clause = false,
              solo_active = false,
          },
          [3] = {
              nuzlocke_enabled = true,
              permadeath = true,
              first_rival_forgiveness = true,
              encounter_limit = true,
              failed_encounter = true,
              nickname_rule = true,
              level_cap_scope = 0,
              no_healing_items = false,
              no_battle_items = false,
              no_escape = false,
              no_repels = false,
              no_escape_rope = false,
              no_field_healing = false,
              no_pp_items = false,
              ball_use_ban_tier = 0,
              maximum_bst = 0,
              allow_glitch_pokemon = false,
              no_tm_use = false,
              no_rare_candy_use = false,
              no_buying = false,
              no_selling = false,
              no_poke_center = false,
              no_mom_heal = false,
              whiteout_clause = true,
              solo_active = true,
          },
      },
      applying = false,
  }

  local function defaultRuleValue(key)
      if key == "locke_type" then
          return 0      -- CUSTOM; preserves the existing configurable defaults
      end
      if key == "starting_money" then
          return 3000   -- preserve the vanilla R/B/Y starting wallet by default
      end
      if key == "starting_pokeballs" then
          return 0      -- NEW GAME default; placed in the room PC
      end
      if key == "starting_rare_candies" then
          return 0      -- NEW GAME default; configurable 00-99 in the room PC
      end
      if key == "nuzlocke_enabled" or key == "permadeath"
          or key == "first_rival_forgiveness" then
          return true
      end
      if key == "world_building_tier" then
          return 3
      end
      if key == "level_cap_scope" then
          return 0
      end
      if key == "dupes_mode" then
          return 0
      end
      if key == "ball_use_ban_tier" then
          return 0
      end
      if key == "maximum_bst" then
          return 0
      end
      if key == "player_start_stat_exp" or key == "wild_start_stat_exp"
          or key == "trainer_start_stat_exp" then
          return 0
      end
      if key == "route_splits" or key == "mt_moon_splits"
          or key == "safari_zone_splits" then
          return 0
      end
      if key == "area_guide_enabled" then
          return true
      end
      if key == "rules_locked" then
          return false
      end
      -- Core/general defaults for a new Nuzlocke run.
      -- These are the requested startup defaults; once the save exists,
      -- the active save is authoritative and in-game toggles override them.
      if key == "encounter_limit" or key == "failed_encounter" or key == "allow_gifts"
          or key == "allow_trades" or key == "catch_info" then
          return true
      end
      if key == "overworld_encounters" or key == "town_catches"
          or key == "no_healing_items" or key == "no_battle_items"
          or key == "no_escape" or key == "no_mom_heal"
          or key == "no_buying" or key == "no_selling"
          or key == "no_repels" or key == "no_escape_rope"
          or key == "no_field_healing" or key == "no_pp_items"
          or key == "no_tm_use" or key == "no_rare_candy_use"
          or key == "allow_glitch_pokemon"
          or key == "automatic_running_shoes"
          or key == "automatic_default_names"
          or key == "skip_catch_tutorial"
          or key == "random_starter"
          or key == "infinite_rare_candies" or key == "wonderlocke" then
          return false
      end
      return false
  end

  local function normalizeRuleValue(rule, value)
      if type(rule) ~= "table" then return value end

      if rule.numeric then
          -- Old Dupes Clause saves used a boolean. Preserve ON as FAMILY,
          -- which matches the behavior those saves previously had.
          if rule.key == "dupes_mode" and type(value) == "boolean" then
              value = value and 2 or 0
          end

          local fallback = tonumber(defaultRuleValue(rule.key))
              or tonumber(rule.min) or 0
          local number = math.floor(tonumber(value) or fallback)
          local minValue = tonumber(rule.min)
          local maxValue = tonumber(rule.max)
          if minValue then number = math.max(minValue, number) end
          if maxValue then number = math.min(maxValue, number) end
          return number
      end

      return value == true
  end

  local function legacyLevelCapScope()
      local hardcore = mod.save:get("hardcore_mode", false) == true
      if not hardcore then return 0 end
      return mod.save:get("elite_four_caps", false) == true and 2 or 1
  end

  local function makeDefaultPreGameRules()
      local values = {}
      for _, cat in ipairs(ruleCategories) do
          for _, rule in ipairs(cat.rules) do
              values[rule.key] = defaultRuleValue(rule.key)
          end
      end
      values.locke_type = defaultRuleValue("locke_type")
      values.starting_money = defaultRuleValue("starting_money")
      values.starting_pokeballs = defaultRuleValue("starting_pokeballs")
      values.starting_rare_candies = defaultRuleValue("starting_rare_candies")
      values.infinite_rare_candies = defaultRuleValue("infinite_rare_candies")
      return values
  end

  local function makeRulesFromCurrentSave()
      local values = makeDefaultPreGameRules()

      for _, cat in ipairs(ruleCategories) do
          for _, rule in ipairs(cat.rules) do
              local raw = mod.save:get(rule.key, nil)
              if rule.key == "level_cap_scope" and raw == nil then
                  raw = legacyLevelCapScope()
              end
              if raw == nil then raw = defaultRuleValue(rule.key) end
              values[rule.key] = normalizeRuleValue(rule, raw)
          end
      end

      values.locke_type = math.max(0, math.min(3,
          math.floor(tonumber(mod.save:get("locke_type",
              defaultRuleValue("locke_type"))) or 0)))
      values.area_guide_enabled = loadAreaGuideState()
      values.rules_locked =
          mod.save:get("rules_locked", defaultRuleValue("rules_locked")) == true
      values.infinite_rare_candies =
          mod.save:get("infinite_rare_candies",
              defaultRuleValue("infinite_rare_candies")) == true

      return values
  end

  local function routeListShowsAll()
      return areaGuideEnabled == true
  end

  ---------------------------------------------------------------------
  -- COMMIT STAGED NEW-GAME RULES
  --
  -- NEW GAME is identified by the explicit staging flag set by the title
  -- menu. Do not inspect whether mod.save already contains rule keys: the
  -- engine may populate defaults before save.loaded, which can otherwise
  -- make valid startup selections look like they were never chosen.
  --
  -- The helper runs from BOTH save.loaded and game.ready. Whichever lifecycle
  -- event sees the staged flag first commits it; the other event simply
  -- mirrors the now-authoritative save.
  ---------------------------------------------------------------------
  local function copyRuleProfile(source)
      local copy = {}
      for _, cat in ipairs(ruleCategories) do
          for _, rule in ipairs(cat.rules) do
              local v = source and source[rule.key]
              if v == nil then v = defaultRuleValue(rule.key) end
              copy[rule.key] = normalizeRuleValue(rule, v)
          end
      end
      copy.locke_type = math.max(0, math.min(3,
          math.floor(tonumber(source and source.locke_type)
              or defaultRuleValue("locke_type"))))
      if source and source.area_guide_enabled ~= nil then
          copy.area_guide_enabled = source.area_guide_enabled == true
      else
          copy.area_guide_enabled = defaultRuleValue("area_guide_enabled")
      end
      copy.rules_locked = source and source.rules_locked == true or false
      copy.infinite_rare_candies = source and source.infinite_rare_candies == true
          or defaultRuleValue("infinite_rare_candies")
      copy.starting_money = math.max(0, math.min(9999,
          math.floor(tonumber(source and source.starting_money)
              or defaultRuleValue("starting_money"))))
      copy.starting_pokeballs = math.max(0, math.min(99,
          math.floor(tonumber(source and source.starting_pokeballs)
              or defaultRuleValue("starting_pokeballs"))))
      local rawCandies = source and source.starting_rare_candies
      if type(rawCandies) == "boolean" then rawCandies = rawCandies and 99 or 0 end
      copy.starting_rare_candies = math.max(0, math.min(99,
          math.floor(tonumber(rawCandies) or defaultRuleValue("starting_rare_candies"))))
      copy.hardcore_mode = (tonumber(copy.level_cap_scope) or 0) > 0
      copy.elite_four_caps = (tonumber(copy.level_cap_scope) or 0) >= 2
      return copy
  end

  local function serializeSetupValue(v)
      if type(v) == "boolean" then
          return v and "true" or "false"
      elseif type(v) == "number" then
          return tostring(v)
      elseif type(v) == "string" then
          return string.format("%q", v)
      end
      return "nil"
  end

  local function serializeSetupProfile(profile)
      local keys = {}
      for k, _ in pairs(profile or {}) do keys[#keys + 1] = k end
      table.sort(keys)
      local out = { "return {" }
      for _, k in ipairs(keys) do
          out[#out + 1] = "[" .. string.format("%q", k) .. "]="
              .. serializeSetupValue(profile[k]) .. ","
      end
      out[#out + 1] = "}"
      return table.concat(out, "\n")
  end

  local function saveSetupProfileToDisk(profile)
      if not (love and love.filesystem and love.filesystem.write) then
          return false
      end
      local ok = love.filesystem.write(
          mod.exports.__beta26.setupProfileFilename(),
          serializeSetupProfile(copyRuleProfile(profile))
      )
      return ok == true
  end

  local function loadSetupProfileFromDisk()
      if not (love and love.filesystem and love.filesystem.getInfo
          and love.filesystem.read) then
          return nil
      end
      local filename = mod.exports.__beta26.setupProfileFilename()
      if not love.filesystem.getInfo(filename) then
          if mod.exports.__beta26.setupProfileScope == "gen1"
              and love.filesystem.getInfo(mod.exports.__beta26.legacySetupProfileFile) then
              filename = mod.exports.__beta26.legacySetupProfileFile
          else
              return nil
          end
      end
      local raw = love.filesystem.read(filename)
      if type(raw) ~= "string" or raw == "" then return nil end
      local chunk = loadstring(raw)
      if not chunk then return nil end
      local ok, profile = pcall(chunk)
      if not ok or type(profile) ~= "table" then return nil end
      return copyRuleProfile(profile)
  end

  local function persistStagedProfile(profile)
      if not profile then return end
      mod.save:set(stagedProfileKey(), copyRuleProfile(profile))
      mod.save:set(stagedIntentKey(), true)
  end

  local function loadPersistedStagedProfile()
      if mod.save:get(stagedIntentKey(), false) ~= true then
          return nil
      end
      local profile = mod.save:get(stagedProfileKey(), nil)
      if type(profile) ~= "table" then
          return nil
      end
      return copyRuleProfile(profile)
  end

  local function clearPersistedStagedProfile()
      mod.save:set(stagedIntentKey(), false)
      mod.save:set(stagedProfileKey(), nil)
  end

  local function saveCurrentSetupProfile()
      if not pendingNewGameRules then
          pendingNewGameRules = makeDefaultPreGameRules()
      end
      local profile = copyRuleProfile(pendingNewGameRules)
      return saveSetupProfileToDisk(profile)
  end

  local function saveCurrentInGameRules()
      if not pendingNewGameRules then
          pendingNewGameRules = makeRulesFromCurrentSave()
      end

      local profile = copyRuleProfile(pendingNewGameRules)
      for _, cat in ipairs(ruleCategories) do
          for _, rule in ipairs(cat.rules) do
              mod.save:set(rule.key, normalizeRuleValue(rule, profile[rule.key]))
          end
      end
      mod.save:set("locke_type", math.max(0, math.min(3,
          math.floor(tonumber(profile.locke_type) or 0))))
      saveAreaGuideState(profile.area_guide_enabled == true)
      mod.save:set("rules_locked", profile.rules_locked == true)
      mod.save:set("infinite_rare_candies", profile.infinite_rare_candies == true)

      pendingNewGameRules = copyRuleProfile(profile)
      pendingRulesDirty = false
      areaGuideEnabled = profile.area_guide_enabled == true
      return true
  end

  local function stageNewGameProfile()
      -- The durable profile is the preferred source at the NEW GAME boundary.
      -- If the player changed the screen and did not press SAVE, use the live
      -- profile they are looking at; otherwise recover the explicitly saved
      -- profile from disk.
      local saved = loadSetupProfileFromDisk()
      if saved and not pendingRulesDirty then
          pendingNewGameRules = saved
      end
      pendingNewGameRules = copyRuleProfile(pendingNewGameRules or makeDefaultPreGameRules())
      newGameRulesSnapshot = copyRuleProfile(pendingNewGameRules)
      persistStagedProfile(newGameRulesSnapshot)
      pendingNewGameRulesForNextSave = true
      newGameRulesCommitPending = true
      newGameCommitPassesRemaining = 12
  end

  local function applyNewGameSnapshot()
      if not newGameRulesCommitPending or not newGameRulesSnapshot then
          return false
      end

      local profile = newGameRulesSnapshot
      local allVerified = true

      -- Explicitly write EVERY registered rule, including false values.
      -- This is the critical distinction from relying on missing save keys:
      -- an OFF selection is a real selection, not permission to use defaults.
      for _, cat in ipairs(ruleCategories) do
          for _, rule in ipairs(cat.rules) do
              local expected = normalizeRuleValue(rule, profile[rule.key])
              mod.save:set(rule.key, expected)
          end
      end

      saveAreaGuideState(profile.area_guide_enabled == true)
      mod.save:set("rules_locked", profile.rules_locked == true)
      mod.save:set("infinite_rare_candies", profile.infinite_rare_candies == true)

      -- Verify against the active save.  Keep the snapshot alive if another
      -- engine initialization pass overwrites it; the next lifecycle pass
      -- will stamp the same snapshot again.
      for _, cat in ipairs(ruleCategories) do
          for _, rule in ipairs(cat.rules) do
              local expected = normalizeRuleValue(rule, profile[rule.key])
              local actual = mod.save:get(rule.key, nil)
              if actual ~= expected then
                  allVerified = false
              end
          end
      end
      local lockeTypeActual = math.max(0, math.min(3,
          math.floor(tonumber(mod.save:get("locke_type", 0)) or 0)))
      if lockeTypeActual ~= math.max(0, math.min(3,
          math.floor(tonumber(profile.locke_type) or 0))) then
          allVerified = false
      end
      local guideActual = mod.save:get("area_guide_enabled", nil)
      if guideActual ~= (profile.area_guide_enabled == true) then
          allVerified = false
      end
      if mod.save:get("rules_locked", nil) ~= (profile.rules_locked == true) then
          allVerified = false
      end
      local rareCandyActual = mod.save:get("infinite_rare_candies", nil)
      if rareCandyActual ~= (profile.infinite_rare_candies == true) then
          allVerified = false
      end

      if allVerified then
          newGameRulesCommitPending = false
          pendingNewGameRulesForNextSave = false
          pendingRulesDirty = false
          pendingNewGameRules = copyRuleProfile(profile)
          areaGuideEnabled = profile.area_guide_enabled == true
          newGameRulesSnapshot = nil
          newGameCommitPassesRemaining = 0
          clearPersistedStagedProfile()
          return true
      end

      return false
  end

  local function refreshRuleMirrorFromSave()
      -- Do not replace a still-pending new-game profile with the save's
      -- defaults.  That was the source of setup choices such as Level Caps
      -- and No X Items being lost when a fresh save was first loaded.
      if pendingNewGameRulesForNextSave and pendingNewGameRules then
          return
      end
      pendingNewGameRules = makeRulesFromCurrentSave()
      areaGuideEnabled = pendingNewGameRules.area_guide_enabled ~= false
      pendingRulesDirty = false
  end

  local function recoverNewGameSnapshotIfNeeded()
      if newGameRulesCommitPending and newGameRulesSnapshot then
          return true
      end
      local persisted = loadPersistedStagedProfile()
      if persisted then
          newGameRulesSnapshot = persisted
          pendingNewGameRules = copyRuleProfile(persisted)
          pendingNewGameRulesForNextSave = true
          newGameRulesCommitPending = true
          newGameCommitPassesRemaining = math.max(newGameCommitPassesRemaining, 12)
          return true
      end
      return false
  end

  ---------------------------------------------------------------------
  -- DEFINITIVE NEW-GAME COMMIT
  --
  -- RBY exposes intro.oak_speech.finished after its introduction. It remains
  -- a useful RBY commit point. Gold uses the shared intro step-list hook below
  -- after its real post-game.ready save.created event identifies NEW GAME.
  ---------------------------------------------------------------------
  local function commitDurableSetupProfileToActiveSave()
      local profile = loadSetupProfileFromDisk()
      if not profile then return false end

      for _, cat in ipairs(ruleCategories) do
          for _, rule in ipairs(cat.rules) do
              mod.save:set(rule.key, normalizeRuleValue(rule, profile[rule.key]))
          end
      end
      mod.save:set("locke_type", math.max(0, math.min(3,
          math.floor(tonumber(profile.locke_type) or 0))))
      saveAreaGuideState(profile.area_guide_enabled == true)
      mod.save:set("rules_locked", profile.rules_locked == true)
      mod.save:set("infinite_rare_candies", profile.infinite_rare_candies == true)

      local verified = true
      for _, cat in ipairs(ruleCategories) do
          for _, rule in ipairs(cat.rules) do
              local expected = normalizeRuleValue(rule, profile[rule.key])
              if mod.save:get(rule.key, nil) ~= expected then
                  verified = false
                  break
              end
          end
          if not verified then break end
      end
      local durableLockeType = math.max(0, math.min(3,
          math.floor(tonumber(mod.save:get("locke_type", 0)) or 0)))
      if durableLockeType ~= math.max(0, math.min(3,
          math.floor(tonumber(profile.locke_type) or 0))) then
          verified = false
      end
      if mod.save:get("area_guide_enabled", nil) ~= (profile.area_guide_enabled == true) then
          verified = false
      end
      if mod.save:get("rules_locked", nil) ~= (profile.rules_locked == true) then
          verified = false
      end
      if mod.save:get("infinite_rare_candies", nil) ~= (profile.infinite_rare_candies == true) then
          verified = false
      end

      if verified then
          pendingNewGameRules = copyRuleProfile(profile)
          pendingNewGameRulesForNextSave = false
          pendingRulesDirty = false
          areaGuideEnabled = profile.area_guide_enabled == true
          newGameRulesSnapshot = nil
          newGameRulesCommitPending = false
          newGameCommitPassesRemaining = 0
          clearPersistedStagedProfile()
      end
      return verified
  end

  mod.events:on("intro.oak_speech.finished", function()
      local ver = getGameVersion and getGameVersion() or "RED"
      if ver == "RED" or ver == "BLUE" or ver == "YELLOW" then
          commitDurableSetupProfileToActiveSave()
      end
  end)

  mod.events:on("save.loaded", function(ev)
      if ev and ev.save then currentSave = ev.save end
      if recoverNewGameSnapshotIfNeeded() then
          applyNewGameSnapshot()
      else
          refreshRuleMirrorFromSave()
      end
  end)

  mod.events:on("game.ready", function(ev)
      local game = type(ev) == "table" and ev.game or ev
      currentGame = game or currentGame
      currentSave = (game and game.save) or currentSave
      if recoverNewGameSnapshotIfNeeded() then
          applyNewGameSnapshot()
      else
          refreshRuleMirrorFromSave()
      end
  end)

  -- A few engine systems initialize save-backed data during the first frames
  -- after game.ready.  Re-apply the immutable NEW GAME snapshot during that
  -- short window.  This is intentionally finite and only runs for a staged
  -- brand-new game; existing saves are never touched.
  mod.events:on("world.stepped", function()
      if recoverNewGameSnapshotIfNeeded() and newGameCommitPassesRemaining > 0 then
          newGameCommitPassesRemaining = newGameCommitPassesRemaining - 1
          applyNewGameSnapshot()
      end
  end)

  ---------------------------------------------------------------------
  -- NEW-GAME DEFAULT NAMES
  --
  -- This deliberately patches the three story-owned naming seams instead of
  -- NamingScreen itself. The shared keyboard is also used for Pokemon, boxes,
  -- and other editable strings; a global shortcut would silently rename them.
  -- Each shortcut writes through the same save fields and continuation the
  -- vanilla screen uses, so Oak's confirmations and Gold's officer script keep
  -- their ordinary order.
  ---------------------------------------------------------------------
  local function automaticDefaultNamesEnabled(game)
      local save = game and game.save
      if save and save.nuzlockeAutomaticDefaultNames == true then return true end

      local profile = newGameRulesSnapshot or pendingNewGameRules
      if profile and profile.automatic_default_names ~= nil then
          return profile.automatic_default_names == true
      end
      return mod.save:get("automatic_default_names", false) == true
  end

  local function rememberAutomaticDefaultNames(game)
      if game and game.save then
          -- Gold's Rival is named hours after Oak's speech. Carry the NEW GAME
          -- choice on the actual save so that later story special does not rely
          -- on title-menu staging state that has correctly been cleared.
          game.save.nuzlockeAutomaticDefaultNames = true
      end
  end

  local function configuredNamePreset(game, who, explicit, fallback)
      if type(explicit) == "table" and type(explicit[1]) == "string"
          and explicit[1] ~= "" then
          return explicit[1]
      end
      local boot = game and game.data and game.data.field
          and game.data.field.boot
      local presets = boot and boot.namePresets and boot.namePresets[who]
      if type(presets) == "table" and type(presets[1]) == "string"
          and presets[1] ~= "" then
          return presets[1]
      end
      return fallback
  end

  local function installAutomaticDefaultNameAdapters()
      if mod.exports.__beta26.isSaveEditorSession() then return false end

      local okRby, RbyOak = pcall(require, "src.ui.OakSpeech")
      if okRby and type(RbyOak) == "table"
          and type(RbyOak.runStep) == "function"
          and RbyOak.__nuzlockeDefaultNamesOwner ~= mod then
          if RbyOak.runStep == RbyOak.__nuzlockeDefaultNamesFunction
              and type(RbyOak.__nuzlockeDefaultNamesPrevious) == "function" then
              RbyOak.runStep = RbyOak.__nuzlockeDefaultNamesPrevious
          end
          local previous = RbyOak.runStep
          local wrapper = function(self, step)
              local game = self and self.game
              if type(step) == "table" and step.kind == "name"
                  and automaticDefaultNamesEnabled(game) then
                  local who = step.who == "rival" and "rival" or "player"
                  local fallback = who == "rival" and "BLUE" or "RED"
                  local name = configuredNamePreset(game, who, step.presets,
                      fallback)
                  if game and game.save then
                      game.save.player = game.save.player or {}
                      if who == "rival" then
                          game.save.player.rival = name
                      else
                          game.save.player.name = name
                      end
                      rememberAutomaticDefaultNames(game)
                  end
                  if type(self.recordAnswer) == "function" then
                      self:recordAnswer(step, 1, name, name)
                  end
                  if type(self.advance) == "function" then self:advance() end
                  return
              end
              return previous(self, step)
          end
          RbyOak.runStep = wrapper
          RbyOak.__nuzlockeDefaultNamesOwner = mod
          RbyOak.__nuzlockeDefaultNamesPrevious = previous
          RbyOak.__nuzlockeDefaultNamesFunction = wrapper
      end

      local okGoldOak, GoldOak = pcall(require, "src.ui.gen2.OakSpeech")
      if okGoldOak and type(GoldOak) == "table"
          and type(GoldOak.openNamePick) == "function"
          and GoldOak.__nuzlockeDefaultNamesOwner ~= mod then
          if GoldOak.openNamePick == GoldOak.__nuzlockeDefaultNamesFunction
              and type(GoldOak.__nuzlockeDefaultNamesPrevious) == "function" then
              GoldOak.openNamePick = GoldOak.__nuzlockeDefaultNamesPrevious
          end
          local previous = GoldOak.openNamePick
          local wrapper = function(self, step)
              local game = self and self.game
              if automaticDefaultNamesEnabled(game) then
                  local name = configuredNamePreset(game, "player",
                      step and step.presets, "GOLD")
                  if game and game.save then
                      game.save.player = game.save.player or {}
                      game.save.player.name = name
                      rememberAutomaticDefaultNames(game)
                  end
                  if type(self.recordAnswer) == "function" then
                      self:recordAnswer(step or {}, 1, name, name)
                  end
                  self.busy = false
                  if type(self.advance) == "function" then self:advance() end
                  return
              end
              return previous(self, step)
          end
          GoldOak.openNamePick = wrapper
          GoldOak.__nuzlockeDefaultNamesOwner = mod
          GoldOak.__nuzlockeDefaultNamesPrevious = previous
          GoldOak.__nuzlockeDefaultNamesFunction = wrapper
      end

      local okWorld, GoldWorld = pcall(require, "src.world.gen2.World")
      if okWorld and type(GoldWorld) == "table"
          and type(GoldWorld.nameRival) == "function"
          and GoldWorld.__nuzlockeDefaultNamesOwner ~= mod then
          if GoldWorld.nameRival == GoldWorld.__nuzlockeDefaultNamesFunction
              and type(GoldWorld.__nuzlockeDefaultNamesPrevious) == "function" then
              GoldWorld.nameRival = GoldWorld.__nuzlockeDefaultNamesPrevious
          end
          local previous = GoldWorld.nameRival
          local wrapper = function(self, onDone)
              local game = self and self.game
              if automaticDefaultNamesEnabled(game) then
                  local name = "SILVER"
                  if game and game.save then
                      game.save.rival = game.save.rival or {}
                      game.save.rival.name = name
                      rememberAutomaticDefaultNames(game)
                  end
                  if onDone then onDone(name) end
                  return
              end
              return previous(self, onDone)
          end
          GoldWorld.nameRival = wrapper
          GoldWorld.__nuzlockeDefaultNamesOwner = mod
          GoldWorld.__nuzlockeDefaultNamesPrevious = previous
          GoldWorld.__nuzlockeDefaultNamesFunction = wrapper
      end
      return true
  end

  pcall(installAutomaticDefaultNameAdapters)
  mod.events:on("game.ready", function()
      pcall(installAutomaticDefaultNameAdapters)
  end)

  ---------------------------------------------------------------------
  -- ACTIVE CHECK
  ---------------------------------------------------------------------
  local function active(game, battle)
      if mod.save:get("nuzlocke_enabled", true) == false then
          return false
      end

      if not (game and game.save) then
          return false
      end

      if battle and (battle.demo or battle.ghost) then
          return false
      end

      return true
  end

  mod.exports.__beta26.ruleActive = function(game, key, battle)
      return active(game or currentGame or mod.game, battle)
          and mod.save:get(key, false) == true
  end

  ---------------------------------------------------------------------
  -- SHARED B-BUTTON RUNNING SHOES
  -- Gen1Recomp exposes the same composable movement.speed hook in R/B/Y and
  -- Gold. Apply the multiplier after downstream mods so no implementation is
  -- replaced, and limit it to player-controlled walking: the generations'
  -- native bike, surf, script, collision, and menu paths remain authoritative.
  ---------------------------------------------------------------------
  mod.hooks:wrap("movement.speed", function(next, frames, ctx)
      local downstream = next(frames, ctx)
      local baseFrames = tonumber(downstream) or tonumber(frames)
      if not baseFrames then return downstream end
      if mod.save:get("automatic_running_shoes", false) ~= true then
          return downstream
      end
      if type(ctx) ~= "table" or ctx.onBike == true or ctx.surfing == true then
          return downstream
      end
      local input = ctx.input
      if not (input and type(input.isDown) == "function" and input:isDown("b")) then
          return downstream
      end
      return math.max(1, math.floor(baseFrames / 2))
  end)

  ---------------------------------------------------------------------
  -- STARTER-ONLY RANDOMIZER
  -- One choice is persisted per new run so retries/reloads cannot reroll the
  -- starter. Story selection flags deliberately continue to describe the
  -- ball the player chose; this preserves every Rival and progression branch.
  ---------------------------------------------------------------------
  mod.exports.__beta26.randomStarterCandidates = function(game, original)
      local out = {}
      local pokemon = game and game.data and game.data.pokemon or {}
      local gold = mod.exports.__beta26.runtimeIsGold(game)
      original = tostring(original or ""):upper()
      for id, def in pairs(pokemon) do
          local species = tostring(id or ""):upper()
          local glitch = mod.exports.__beta26.getGlitchSpeciesInfo(game, species)
          if species ~= "" and species ~= original and species ~= "EGG"
              and species ~= "NONE" and type(def) == "table"
              and not glitch.isGlitch
              and (not gold or tonumber(def.index) ~= nil) then
              out[#out + 1] = species
          end
      end
      table.sort(out)
      return out
  end

  mod.exports.__beta26.selectRandomStarter = function(game, original)
      original = tostring(original or ""):upper()
      if mod.save:get("random_starter", false) ~= true then return original end
      local pokemon = game and game.data and game.data.pokemon or {}
      local saved = tostring(mod.save:get(
          "__nuzlocke_random_starter_choice", "") or ""):upper()
      local savedDef = pokemon[saved]
      if saved ~= "" and type(savedDef) == "table"
          and (not mod.exports.__beta26.runtimeIsGold(game)
              or tonumber(savedDef.index) ~= nil) then
          return saved
      end
      local candidates = mod.exports.__beta26.randomStarterCandidates(
          game, original)
      if #candidates == 0 then return original end
      local rng = love and love.math and love.math.random or math.random
      local choice = candidates[rng(1, #candidates)]
      mod.save:set("__nuzlocke_random_starter_choice", choice)
      mod.save:set("__nuzlocke_random_starter_original", original)
      return choice
  end

  mod.exports.starter_randomizer = {
      api = 1,
      build = "beta.29.1.0",
      select = mod.exports.__beta26.selectRandomStarter,
  }
  mod.exports.nuzlocke_compat.selectRandomStarter =
      mod.exports.__beta26.selectRandomStarter

  -- R/B/Y's supported pre-creation gift event lets the actual Pokemon be
  -- transformed without replacing Commands.give_pokemon. Restrict it to the
  -- first party acquisition and Oak's canonical starter species.
  mod.events:on("pokemon.before_give", function(gift)
      local ctx = type(gift) == "table" and gift.ctx or nil
      local game = ctx and ctx.game or currentGame or mod.game
      local save = ctx and ctx.save or game and game.save
      if mod.exports.__beta26.runtimeIsGold(game)
          or not save or #(save.party or {}) ~= 0 then return end
      local original = tostring(gift and gift.species or ""):upper()
      if original ~= "BULBASAUR" and original ~= "CHARMANDER"
          and original ~= "SQUIRTLE" and original ~= "PIKACHU" then return end
      local area = tostring((ctx and (ctx.mapId or ctx.map))
          or (ctx and ctx.overworld and ctx.overworld.map
              and ctx.overworld.map.id)
          or (save.player and save.player.map) or ""):upper()
      if area ~= "PALLET_TOWN" and not area:find("OAK", 1, true)
          and not area:find("LAB", 1, true) then return end
      gift.nuzlockeOriginalStarter = original
      gift.species = mod.exports.__beta26.selectRandomStarter(game, original)
  end)

  -- Oak's received-mon line appears immediately before give_pokemon. Rewrite
  -- only that reveal buffer so R/B/Y names the species the persisted roll will
  -- actually grant; the earlier ball/Dex preview still describes the player's
  -- chosen vanilla ball and therefore keeps the intended choice semantics.
  mod.hooks:wrap("script.command", function(next, ctx, name, args, cmd)
      if ctx and ctx.generation ~= 2 and name == "show_text"
          and type(args) == "table" and type(args[2]) == "table"
          and (args[1] == "_OaksLabReceivedMonText"
              or args[1] == "_OaksLabReceivedText")
          and ctx.save and #(ctx.save.party or {}) == 0
          and mod.save:get("random_starter", false) == true then
          local original = tostring(args[2].RAM or ""):upper()
          if original == "BULBASAUR" or original == "CHARMANDER"
              or original == "SQUIRTLE" or original == "PIKACHU" then
              local reveal = {}
              for key, value in pairs(args[2]) do reveal[key] = value end
              reveal.RAM = mod.exports.__beta26.selectRandomStarter(
                  ctx.game or currentGame or mod.game, original)
              local rewritten = {}
              for i, value in ipairs(args) do rewritten[i] = value end
              rewritten[2] = reveal
              return next(ctx, name, rewritten, cmd)
          end
      end
      return next(ctx, name, args, cmd)
  end)

  -- Static status is provenance, not a species list. Script-command adapters
  -- stamp fixed wild battles before battle.started; compatible encounter mods
  -- may also provide one of these explicit fields themselves. This keeps
  -- randomizers correct when a normally static species appears in grass.
  mod.exports.__beta26.isStaticEncounter = function(game, battle)
      if type(battle) ~= "table" then return false end
      local encounterType = tostring(battle.encounterType
          or battle.encounterSource or battle.source or ""):lower()
      return battle.nuzlockeStaticEncounter == true
          or battle.staticEncounter == true
          or battle.isStaticEncounter == true
          or battle.fixedEncounter == true
          or encounterType == "static"
          or encounterType == "fixed"
  end

  ---------------------------------------------------------------------
  -- WORLD BUILDING / FLAVOR
  -- Cosmetic only: never changes a rule result or owns an engine hook.
  -- T1 = core feedback, T2 = snark, T3 = occasional Kanto-aware flavor.
  -- T3 story lines are once-per-save where appropriate.
  ---------------------------------------------------------------------
  local function worldTier(game)
      -- Gold's reduced beta surface does not expose World Building, and the
      -- current authored lines are Kanto-specific. Hidden profile defaults
      -- must not make those lines fire in Johto.
      if mod.exports.__beta26.runtimeIsGold(game) then return 0 end
      local value = tonumber(mod.save:get("world_building_tier", 3)) or 3
      value = math.max(0, math.min(3, value))
      if not (game and game.save) then return 0 end
      if mod.save:get("nuzlocke_enabled", true) ~= true then return 0 end
      return value
  end

  local function worldFlags()
      local flags = mod.save:get("nuzlocke_world_flags", {})
      if type(flags) ~= "table" then flags = {} end
      return flags
  end

  -- Keep every mod-authored World Building line well-formed before it reaches
  -- either a TextBox or an engine message queue. This deliberately preserves
  -- explicit newlines/page breaks while removing accidental doubled spaces,
  -- spaces beside line breaks, and spaces before punctuation.
  mod.exports.__beta26.cleanWorldText = function(message)
      -- World-building, rule-denial, and item-policy callers pass their stable
      -- English source text through this shared presentation boundary.  That
      -- gives translation mods one reliable key without changing rule logic.
      local text = Strings(tostring(message or ""))
      text = text:gsub("\r\n", "\n"):gsub("\r", "\n")
      text = text:gsub("[ \t]+\n", "\n"):gsub("\n[ \t]+", "\n")
      text = text:gsub("[ \t]+\v", "\v"):gsub("\v[ \t]+", "\v")
      text = text:gsub("[ \t]+", " ")
      text = text:gsub(" +([,%.%!%?;:])", "%1")
      text = text:gsub("^%s+", ""):gsub("%s+$", "")
      return text
  end

  -- Own one active World Building TextBox at a time. Compatibility fallbacks
  -- can observe the same transaction through more than one seam; suppress an
  -- identical message only while its first box is still active, then release
  -- ownership when the player closes it so later legitimate interactions keep
  -- giving rule feedback.
  mod.exports.__beta26.pushWorldText = function(game, message, onDone)
      if not (game and game.stack) then return false end
      local text = mod.exports.__beta26.cleanWorldText(message)
      if text == "" then return false end
      local state = mod.exports.__beta26.worldPresentation
      if type(state) ~= "table" then
          state = {}
          mod.exports.__beta26.worldPresentation = state
      end
      if state.game == game and state.activeText == text then return false end
      local okText, TextBox = pcall(require, "src.render.TextBox")
      if not okText or not TextBox or type(TextBox.new) ~= "function" then
          return false
      end
      state.game, state.activeText = game, text
      local ok = pcall(function()
          game.stack:push(TextBox.new(game, text, function(...)
              if state.game == game and state.activeText == text then
                  state.activeText = nil
              end
              if type(onDone) == "function" then return onDone(...) end
          end))
      end)
      if not ok then state.activeText = nil end
      return ok
  end

  local function worldOnce(game, key, message)
      if worldTier(game) < 3 then return false end
      local flags = worldFlags()
      if flags[key] then return false end
      if not mod.exports.__beta26.pushWorldText(game, message) then return false end
      flags[key] = true
      mod.save:set("nuzlocke_world_flags", flags)
      return true
  end

  local function worldMessage(game, tier1, tier2, tier3)
      local tier = worldTier(game)
      if tier <= 0 then return false end
      local message = tier == 1 and tier1 or (tier == 2 and (tier2 or tier1) or (tier3 or tier2 or tier1))
      return message and mod.exports.__beta26.pushWorldText(game, message) or false
  end

  local function worldMechanic(game, key, tier1, tier2, tier3)
      local tier = worldTier(game)
      if tier <= 0 then return false end
      if key then
          local flags = worldFlags()
          -- One gameplay/story event speaks once for the life of the save.
          -- Changing World Building tiers later must not replay the same beat.
          if flags[key] then return false end
          if not worldMessage(game, tier1, tier2, tier3) then return false end
          flags[key] = true
          mod.save:set("nuzlocke_world_flags", flags)
          return true
      end
      return worldMessage(game, tier1, tier2, tier3)
  end

  ---------------------------------------------------------------------
  -- R/B/Y INTRO TRANSITION SAFETY (25D4-RBY2)
  --
  -- Do not push a TextBox from intro.oak_speech.finished. On the current
  -- Gen1Recomp lifecycle this event sits directly on the fade/handoff into
  -- the player's house. The beta.25 game.ready payload fix makes currentGame
  -- a live Game here, which means the old cosmetic worldOnce() call can now
  -- actually push a screen during that transition. Older builds often held
  -- the game.ready event wrapper instead, leaving this cosmetic path inert.
  --
  -- The setup-profile commit listener above remains unchanged. Only this
  -- optional T3 Oak flavor line is suppressed for the diagnostic build.
  ---------------------------------------------------------------------


  ---------------------------------------------------------------------
  -- LEVEL CAP ENFORCEMENT
  --
  -- One player-facing scope controls the entire progression:
  -- 0 NONE, 1 GYMS, 2 E4, 3 CHAMPION, 4 POSTGAME.
  -- Each higher scope includes everything before it. Legacy saves that still
  -- contain hardcore_mode / elite_four_caps are migrated on read.
  ---------------------------------------------------------------------
  -- Version-family progression. RBY keeps the established beta.20 tables.
  -- GSC uses one shared family ladder with version-specific profiles so Gold
  -- can be exercised now without turning Silver/Crystal groundwork into a
  -- support claim. Kanto stages after Lance never lower the active cap.
  local VersionCompat = {
      profiles = {
          RED={family="RBY",region="KANTO",status="supported"},
          BLUE={family="RBY",region="KANTO",status="supported"},
          YELLOW={family="RBY",region="KANTO",status="supported"},
          GOLD={family="GSC",region="JOHTO_KANTO",status="experimental"},
          SILVER={family="GSC",region="JOHTO_KANTO",status="groundwork"},
          CRYSTAL={family="GSC",region="JOHTO_KANTO",status="groundwork"},
      },
      rbyGymCaps = {
          RED={14,21,24,29,43,43,47,50}, BLUE={14,21,24,29,43,43,47,50},
          YELLOW={12,21,28,32,50,50,54,55},
      },
      rbyGymNames = {"BROCK","MISTY","LT SURGE","ERIKA","KOGA","SABRINA","BLAINE","GIOVANNI"},
      gscStages = {
          {name="FALKNER",cap=9,phase="GYM"},{name="BUGSY",cap=16,phase="GYM"},
          {name="WHITNEY",cap=20,phase="GYM"},{name="MORTY",cap=25,phase="GYM"},
          {name="CHUCK",cap=30,phase="GYM"},{name="PRYCE",cap=31,phase="GYM"},
          {name="JASMINE",cap=35,phase="GYM"},{name="CLAIR",cap=40,phase="GYM"},
          {name="WILL",cap=42,phase="E4"},{name="KOGA",cap=44,phase="E4"},
          {name="BRUNO",cap=46,phase="E4"},{name="KAREN",cap=47,phase="E4"},
          {name="LANCE",cap=50,phase="CHAMP"},
          {name="LT SURGE",cap=50,phase="POST"},{name="SABRINA",cap=50,phase="POST"},
          {name="MISTY",cap=50,phase="POST"},{name="ERIKA",cap=50,phase="POST"},
          {name="JANINE",cap=50,phase="POST"},{name="BROCK",cap=50,phase="POST"},
          {name="BLAINE",cap=50,phase="POST"},{name="BLUE",cap=58,phase="POST"},
          {name="RED",cap=81,phase="POST"},
      },
  }
  local LEVEL_CAPS_BY_VERSION = VersionCompat.rbyGymCaps
  local LEVEL_CAP_GYM_LEADERS = VersionCompat.rbyGymNames
  local ELITE_FOUR_CAPS = {
      { id = "OPP_LORELEI", name = "LORELEI", cap = 56 },
      { id = "OPP_BRUNO",   name = "BRUNO",   cap = 58 },
      { id = "OPP_AGATHA",  name = "AGATHA",  cap = 60 },
      { id = "OPP_LANCE",   name = "LANCE",   cap = 62 },
  }
  local CHAMPION_CAP = { name = "CHAMPION", cap = 65 }

  -- Live boss-cap compatibility. Content mods commonly patch the merged
  -- trainer registry without exporting a dedicated level-cap provider. Read
  -- that final registry at point of use so enforcement and every UI surface
  -- see the same ace level. A trainer.party observer also remembers a roster
  -- returned by runtime hook composition, which helps retry/rematch flows for
  -- mods whose changes are computed rather than data-patched.
  mod.exports.__beta26.levelCapBosses = {
      rbyGyms = {
          BROCK       = { id = "OPP_BROCK",     party = 1 },
          MISTY       = { id = "OPP_MISTY",     party = 1 },
          ["LT SURGE"] = { id = "OPP_LT_SURGE", party = 1 },
          ERIKA       = { id = "OPP_ERIKA",     party = 1 },
          KOGA        = { id = "OPP_KOGA",      party = 1 },
          SABRINA     = { id = "OPP_SABRINA",  party = 1 },
          BLAINE      = { id = "OPP_BLAINE",   party = 1 },
          GIOVANNI    = { id = "OPP_GIOVANNI", party = 3 },
      },
      observed = {},
  }

  mod.exports.__beta26.partyAceLevel = function(party)
      if type(party) ~= "table" then return nil end
      local ace
      for _, mon in pairs(party) do
          if type(mon) == "table" then
              local level = tonumber(mon.level or mon.lvl)
              if level and level > 0 and level <= 100
                  and (not ace or level > ace) then
                  ace = level
              end
          end
      end
      return ace
  end

  mod.exports.__beta26.trainerPartyKey = function(classId, partyIndex)
      return tostring(classId or ""):upper():gsub("[^A-Z0-9]", "")
          .. "#" .. tostring(partyIndex or 1)
  end

  mod.exports.__beta26.liveTrainerAce = function(game, classId, partyIndex)
      local observed = mod.exports.__beta26.levelCapBosses.observed
      local key = mod.exports.__beta26.trainerPartyKey(classId, partyIndex)
      if tonumber(observed[key]) then return tonumber(observed[key]), "HOOK" end

      local trainers = game and game.data and game.data.trainers
      local trainer = type(trainers) == "table" and trainers[classId] or nil
      local parties = type(trainer) == "table"
          and (trainer.parties or trainer.rosters) or nil
      local party = type(parties) == "table" and parties[partyIndex or 1]
          or (type(trainer) == "table" and trainer.party or nil)
      local ace = mod.exports.__beta26.partyAceLevel(party)
      if ace then return ace, "MERGED_DATA" end
      return nil
  end

  mod.exports.__beta26.championPartyIndex = function(game, save)
      local version = getGameVersion and getGameVersion() or "RED"
      if version == "YELLOW" then
          return math.max(1, math.min(3,
              math.floor(tonumber(save and save.rivalStarter) or 1)))
      end
      local flags = save and save.flags or {}
      local offsets = game and game.data and game.data.field
          and game.data.field.starterCounterpicks
      if type(offsets) == "table" then
          for flag, offset in pairs(offsets) do
              if flags[flag] == true or tonumber(flags[flag]) == 1 then
                  return 1 + (tonumber(offset) or 0)
              end
          end
      end
      if flags.EVENT_CHOSE_SQUIRTLE == true
          or tonumber(flags.EVENT_CHOSE_SQUIRTLE) == 1 then return 2 end
      if flags.EVENT_CHOSE_BULBASAUR == true
          or tonumber(flags.EVENT_CHOSE_BULBASAUR) == 1 then return 3 end
      return 1
  end

  mod.exports.__beta26.liveRbyBossAce = function(name, fallback, save)
      local game = currentGame
      local spec = mod.exports.__beta26.levelCapBosses.rbyGyms[name]
      if spec then
          return mod.exports.__beta26.liveTrainerAce(
              game, spec.id, spec.party) or fallback
      end
      if tostring(name) == "CHAMPION" then
          local party = mod.exports.__beta26.championPartyIndex(game, save)
          return mod.exports.__beta26.liveTrainerAce(
              game, "OPP_RIVAL3", party) or fallback
      end
      local id = tostring(name or "")
      if not id:find("^OPP_", 1) then id = "OPP_" .. id end
      return mod.exports.__beta26.liveTrainerAce(game, id, 1) or fallback
  end

  mod.exports.__beta26.liveGscStageAce = function(stageName, fallback)
      local data = currentGame and currentGame.data
      local trainers = data and data.trainers
      local classes = type(trainers) == "table"
          and (trainers.classes or trainers) or nil
      if type(classes) ~= "table" then return fallback end
      local target = tostring(stageName or ""):upper():gsub("[^A-Z0-9]", "")
      local best, bestScore
      for classId, class in pairs(classes) do
          if type(class) == "table" then
              local classKey = tostring(classId):upper():gsub("[^A-Z0-9]", "")
              local className = tostring(class.name or ""):upper():gsub("[^A-Z0-9]", "")
              for member, row in pairs(class.trainers or {}) do
                  if type(row) == "table" then
                      local rowName = tostring(row.name or row.id or ""):upper()
                          :gsub("[^A-Z0-9]", "")
                      local score = rowName == target and 3
                          or ((classKey == target or className == target) and 2)
                          or ((rowName:find(target, 1, true)
                              or target:find(rowName, 1, true)) and 1)
                      if score then
                          local observed = mod.exports.__beta26.levelCapBosses.observed
                          local observedAce = observed[
                              mod.exports.__beta26.trainerPartyKey(
                                  class.index or classId, member)]
                              or observed[mod.exports.__beta26.trainerPartyKey(
                                  classId, member)]
                          local ace = tonumber(observedAce)
                              or mod.exports.__beta26.partyAceLevel(row.party)
                          if ace and (not bestScore or score > bestScore
                              or (score == bestScore and ace > best)) then
                              best, bestScore = ace, score
                          end
                      end
                  end
              end
          end
      end
      return best or fallback
  end

  mod.hooks:wrap("trainer.party", function(next, classId, partyIndex, party)
      local resolved = next(classId, partyIndex, party) or party
      local ace = mod.exports.__beta26.partyAceLevel(resolved)
      if ace then
          mod.exports.__beta26.levelCapBosses.observed[
              mod.exports.__beta26.trainerPartyKey(classId, partyIndex)] = ace
      end
      return resolved
  end)

  mod.events:on("battle.started", function(ev)
      local battle = ev and (ev.battle or ev)
      if type(battle) ~= "table" then return end
      local trainer = battle.trainer
      local party = battle.enemyParty
          or (type(trainer) == "table" and trainer.party)
      local ace = mod.exports.__beta26.partyAceLevel(party)
      if not ace then return end
      local classId = battle.oppClass or battle.trainerClass
          or (type(trainer) == "table"
              and (trainer.classId or trainer.class or trainer.id))
          or (ev and ev.trainerId)
      local member = battle.partyIndex
          or (type(trainer) == "table"
              and (trainer.memberId or trainer.member or trainer.index))
          or 1
      if classId then
          mod.exports.__beta26.levelCapBosses.observed[
              mod.exports.__beta26.trainerPartyKey(classId, member)] = ace
      end
  end)

  if mod.exports.nuzlocke_compat then
      mod.exports.nuzlocke_compat.game_profiles = VersionCompat.profiles
      mod.exports.nuzlocke_compat.getGameVersion = function() return getGameVersion and getGameVersion() or "RED" end
      mod.exports.nuzlocke_compat.getGameProfile = function()
          local v = getGameVersion and getGameVersion() or "RED"
          return VersionCompat.profiles[v]
      end
  end

  local function levelCapScope()
      if mod.save:get("nuzlocke_enabled", true) == false then return 0 end
      local raw = mod.save:get("level_cap_scope", nil)
      if raw ~= nil then
          -- Scope is an enum, not a continuous value.  Normalize malformed
          -- or hand-edited saves before any UI/enforcement comparison.
          return math.floor(math.max(0, math.min(4, tonumber(raw) or 0)))
      end
      -- Backward compatibility with beta 6 and earlier saves.
      return legacyLevelCapScope()
  end

  mod.exports.__beta26.saveFlagTrue = function(save, name)
      local flags = save and save.flags
      local value = type(flags) == "table" and flags[name]
      return value == true or tonumber(value) == 1
  end

  local function eliteFourDefeated()
      local defeated = mod.save:get("nuzlocke_e4_defeated")
      if type(defeated) ~= "table" then
          defeated = {}
      end
      local save = currentSave or (currentGame and currentGame.save)
      local allDone = mod.exports.__beta26.saveFlagTrue(
          save, "EVENT_BEAT_CHAMPION_RIVAL")
      local flags = {
          OPP_LORELEI = "EVENT_BEAT_LORELEIS_ROOM_TRAINER_0",
          OPP_BRUNO = "EVENT_BEAT_BRUNOS_ROOM_TRAINER_0",
          OPP_AGATHA = "EVENT_BEAT_AGATHAS_ROOM_TRAINER_0",
          OPP_LANCE = "EVENT_BEAT_LANCE",
      }
      for id, flag in pairs(flags) do
          if allDone or mod.exports.__beta26.saveFlagTrue(save, flag)
              or (id == "OPP_LANCE" and mod.exports.__beta26.saveFlagTrue(
                  save, "EVENT_BEAT_LANCES_ROOM_TRAINER_0")) then
              defeated[id] = true
          end
      end
      mod.save:set("nuzlocke_e4_defeated", defeated)
      return defeated
  end

  local function championDefeated()
      if mod.save:get("nuzlocke_champion_defeated", false) == true then
          return true
      end
      local save = currentSave or (currentGame and currentGame.save)
      if mod.exports.__beta26.saveFlagTrue(
          save, "EVENT_BEAT_CHAMPION_RIVAL") then
          mod.save:set("nuzlocke_champion_defeated", true)
          return true
      end
      return false
  end

  -- Shared reader for external cap providers. Both normal and post-game
  -- providers use the same small contract, so keep parsing in one place.
  local function providerCapInfo(capability, save, fallbackName, allowMax)
      local provider = activeCompatProvider(capability, currentGame, nil)
      local value = provider and provider.value
      if not provider then return nil end

      local getter = type(value) == "function" and value
          or (type(value) == "table" and (value.get_next_cap
              or value.getNextCap or value.get_cap or value.getLevelCap
              or value.get_level_cap or value.next_cap or value.nextCap))
      if type(getter) ~= "function" then return nil end

      local ok, result = pcall(getter, currentGame, save)
      if (not ok or result == nil) and type(value) == "table" then
          ok, result = pcall(getter, value, currentGame, save)
      end
      if not ok or result == nil then return nil end

      local cap
      local name = fallbackName

      if type(result) == "table" then
          if result.enabled == false or result.active == false then return nil end
          cap = tonumber(result.cap or result.level or result.ace
              or result.max_level or result.maxLevel or result.levelCap)
          name = tostring(result.name or result.boss or result.stage
              or result.trainer or fallbackName)
      else
          cap = tonumber(result)
      end

      local maxAllowed = allowMax and 100 or 99
      if cap and cap > 0 and cap <= maxAllowed then
          return cap, name
      end

      return nil
  end

  local function postgameCapInfo(save)
      -- POSTGAME is the inclusive fourth Level Cap Scope. It is the one and
      -- only opt-in for provider stages; the retired Expanded Postgame toggle
      -- must not silently gate this newer scope.
      if levelCapScope() < 4 then return nil end
      local provider = activeCompatProvider("postgame_caps", currentGame, nil)
      local value = provider and provider.value
      if type(value) == "table" then
          local stages = value.stages or value.postgameStages
          local stageGetter = value.get_stages or value.getStages
          if type(stageGetter) == "function" then
              local ok, got = pcall(stageGetter, currentGame, save)
              if (not ok or type(got) ~= "table") then
                  ok, got = pcall(stageGetter, value, currentGame, save)
              end
              if ok and type(got) == "table" then stages = got end
          end
          if type(stages) == "table" then
              for _, stage in ipairs(stages) do
                  if type(stage) == "table" then
                      local defeated = stage.defeated
                      local done = defeated == true
                      if type(defeated) == "function" then
                          local ok, got = pcall(defeated, currentGame, save, stage)
                          done = ok and got == true
                      elseif type(defeated) == "string" then
                          done = mod.save:get(defeated, false) == true
                      end
                      if not done then
                          local cap = tonumber(stage.cap or stage.level
                              or stage.ace or stage.max_level
                              or stage.maxLevel or stage.levelCap)
                          if cap and cap > 0 and cap <= 100 then
                              return cap, tostring(stage.name or stage.id or "POSTGAME")
                          end
                      end
                  end
              end
          end
      end
      return providerCapInfo("postgame_caps", save, "POSTGAME", true)
  end

  local function nextEliteFourCapInfo(floor)
      local defeated = eliteFourDefeated()
      floor = tonumber(floor) or 0
      for _, entry in ipairs(ELITE_FOUR_CAPS) do
          local ace = mod.exports.__beta26.liveRbyBossAce(
              entry.id, entry.cap, currentSave)
          if defeated[entry.id] ~= true then
              return math.max(floor, ace), entry.name
          end
          floor = math.max(floor, ace)
      end
      return nil, nil, floor
  end

  local function currentBadgeCount(save)
      local inventory = save and save.inventory or {}
      local coreData = require("src.core.Data")
      local badges = coreData.constants and coreData.constants.badges or {
          { id = "BOULDERBADGE" }, { id = "CASCADEBADGE" },
          { id = "THUNDERBADGE" }, { id = "RAINBOWBADGE" },
          { id = "SOULBADGE" }, { id = "MARSHBADGE" },
          { id = "VOLCANOBADGE" }, { id = "EARTHBADGE" },
      }
      local count = 0
      for i, badge in ipairs(badges) do
          local id = badge.id or badge.item or badge.key
          if id and (inventory[id] == true or tonumber(inventory[id]) and tonumber(inventory[id]) > 0) then
              count = i
          else
              break
          end
      end
      return count
  end

  -- Gym progression is tracked separately from badge inventory. This keeps a
  -- later scope change from manufacturing League progress.
  local GYM_PROGRESS_KEY = "nuzlocke_gym_defeated"

  local function gymProgress(save)
      local progress = mod.save:get(GYM_PROGRESS_KEY, nil)
      if type(progress) ~= "table" then
          progress = {}
          local badgeCount = currentBadgeCount(save)
          for i = 1, math.min(badgeCount, #LEVEL_CAP_GYM_LEADERS) do
              progress[LEVEL_CAP_GYM_LEADERS[i]] = true
          end
          mod.save:set(GYM_PROGRESS_KEY, progress)
      end
      return progress
  end

  local function currentGymProgressCount(save)
      local progress = gymProgress(save)
      local count = 0
      for i, leader in ipairs(LEVEL_CAP_GYM_LEADERS) do
          if progress[leader] == true then
              count = i
          else
              break
          end
      end
      return count
  end

  local function currentGymLevelCaps()
      local version = getGameVersion and getGameVersion() or "RED"
      -- Unknown/future Gen 1 editions should degrade to the canonical Red
      -- table instead of crashing every cap consumer on a nil length/index.
      return LEVEL_CAPS_BY_VERSION[version] or LEVEL_CAPS_BY_VERSION.RED
  end

  mod.exports.__beta26.badgeOwned = function(save, store, name, index)
      local badges = save and save.player and save.player[store]
      if type(badges) ~= "table" then return false end
      local direct = badges[name]
      local positional = index and badges[index]
      return direct == true or tonumber(direct) == 1
          or positional == true or tonumber(positional) == 1
  end

  mod.exports.__beta26.gscBadgeStages = {
      FALKNER = { "badges", "ZEPHYR", 1 },
      BUGSY = { "badges", "HIVE", 2 },
      WHITNEY = { "badges", "PLAIN", 3 },
      MORTY = { "badges", "FOG", 4 },
      CHUCK = { "badges", "STORM", 6 },
      JASMINE = { "badges", "MINERAL", 5 },
      PRYCE = { "badges", "GLACIER", 7 },
      CLAIR = { "badges", "RISING", 8 },
      ["LT SURGE"] = { "kantoBadges", "THUNDER", 3 },
      SABRINA = { "kantoBadges", "MARSH", 6 },
      MISTY = { "kantoBadges", "CASCADE", 2 },
      ERIKA = { "kantoBadges", "RAINBOW", 4 },
      JANINE = { "kantoBadges", "SOUL", 5 },
      BROCK = { "kantoBadges", "BOULDER", 1 },
      BLAINE = { "kantoBadges", "VOLCANO", 7 },
      BLUE = { "kantoBadges", "EARTH", 8 },
  }

  local function gscProgress(save)
      local progress = mod.save:get("nuzlocke_gsc_defeated", nil)
      if type(progress) ~= "table" then progress = {} end
      for name, badge in pairs(mod.exports.__beta26.gscBadgeStages) do
          if mod.exports.__beta26.badgeOwned(
              save, badge[1], badge[2], badge[3])
              or mod.exports.__beta26.saveFlagTrue(
                  save, "EVENT_BEAT_" .. name:gsub(" ", "_")) then
              progress[name] = true
          end
      end
      local leagueDone = mod.exports.__beta26.saveFlagTrue(
          save, "EVENT_BEAT_ELITE_FOUR")
          or mod.exports.__beta26.saveFlagTrue(
              save, "EVENT_BEAT_CHAMPION_LANCE")
      local leagueFlags = {
          WILL = "EVENT_BEAT_ELITE_4_WILL",
          KOGA = "EVENT_BEAT_ELITE_4_KOGA",
          BRUNO = "EVENT_BEAT_ELITE_4_BRUNO",
          KAREN = "EVENT_BEAT_ELITE_4_KAREN",
          LANCE = "EVENT_BEAT_CHAMPION_LANCE",
      }
      for name, flag in pairs(leagueFlags) do
          if leagueDone or mod.exports.__beta26.saveFlagTrue(save, flag) then
              progress[name] = true
          end
      end
      mod.save:set("nuzlocke_gsc_defeated", progress)
      return progress
  end

  local function nextGscCapInfo(save, scope)
      local progress = gscProgress(save)
      local floor = 0
      for _, stage in ipairs(VersionCompat.gscStages) do
          local allowed = stage.phase == "GYM" or (stage.phase == "E4" and scope >= 2)
              or (stage.phase == "CHAMP" and scope >= 3) or (stage.phase == "POST" and scope >= 4)
          local ace = mod.exports.__beta26.liveGscStageAce(
              stage.name, stage.cap)
          if allowed and progress[stage.name] ~= true then
              return math.max(floor, ace), stage.name
          end
          if not allowed and progress[stage.name] ~= true then return 100, "MAX" end
          if progress[stage.name] == true then
              floor = math.max(floor, ace)
          end
      end
      if scope >= 4 then
          local cap, name = postgameCapInfo(save)
          if cap then return math.max(floor, cap), name end
      end
      return 100, "MAX"
  end

  local function externalLevelCapInfo(save)
      return providerCapInfo("level_caps", save, "EXTERNAL", true)
  end

  -- One authoritative calculation feeds enforcement, tracker, Trainer Card,
  -- Gym Guide text, and any other cap display.
  local function nextLevelCapInfo(save)
      local scope = levelCapScope()
      if scope <= 0 then return 100, "MAX" end

      local externalCap, externalName = externalLevelCapInfo(save)
      if externalCap then return externalCap, externalName end

      local version = getGameVersion and getGameVersion() or "RED"
      local profile = VersionCompat.profiles[version]
      if profile and profile.family == "GSC" then
          return nextGscCapInfo(save, scope)
      end

      local badges = currentGymProgressCount(save)
      local gymCaps = currentGymLevelCaps()
      local floor = 0
      for i = 1, math.min(badges, #gymCaps) do
          floor = math.max(floor, mod.exports.__beta26.liveRbyBossAce(
              LEVEL_CAP_GYM_LEADERS[i], gymCaps[i] or 100, save))
      end
      if badges < #gymCaps then
          local leader = LEVEL_CAP_GYM_LEADERS[badges + 1] or "MAX"
          return math.max(floor, mod.exports.__beta26.liveRbyBossAce(
              leader, gymCaps[badges + 1] or 100, save)), leader
      end

      if scope >= 2 then
          local e4Cap, e4Name, e4Floor = nextEliteFourCapInfo(floor)
          if e4Cap then return e4Cap, e4Name end
          floor = e4Floor or floor
      end

      if scope >= 3 and not championDefeated() then
          return math.max(floor, mod.exports.__beta26.liveRbyBossAce(
              CHAMPION_CAP.name, CHAMPION_CAP.cap, save)), CHAMPION_CAP.name
      elseif scope >= 3 and championDefeated() then
          floor = math.max(floor, mod.exports.__beta26.liveRbyBossAce(
              CHAMPION_CAP.name, CHAMPION_CAP.cap, save))
      end

      if scope >= 4 then
          local postCap, postName = postgameCapInfo(save)
          if postCap then return math.max(floor, postCap), postName end
      end

      return 100, "MAX"
  end

  local function nextLevelCap(save)
      local cap = nextLevelCapInfo(save)
      return cap
  end

  -- Stable public read surface for HUD/status mods. It is deliberately the
  -- same calculation used by EXP/Rare Candy enforcement and our own screens.
  mod.exports.__beta26.getNextLevelCapInfo = function(save)
      local cap, boss = nextLevelCapInfo(save
          or currentSave or (currentGame and currentGame.save))
      return {
          cap = cap,
          level = cap,
          boss = boss,
          name = boss,
          maximum = cap and cap >= 100 or false,
          source = "AUTHORITATIVE_LIVE",
      }
  end
  if mod.exports.nuzlocke_compat then
      mod.exports.nuzlocke_compat.getNextLevelCapInfo =
          mod.exports.__beta26.getNextLevelCapInfo
      mod.exports.nuzlocke_compat.level_cap_source =
          "provider_or_live_merged_trainer_ace"
  end

  local function capExperienceForMon(mon, cap)
      if not mon or not cap then return nil end

      -- Prefer the live merged registries so mod-added Pokemon and custom
      -- growth curves obey the same cap as vanilla species.
      local data = currentGame and currentGame.data or require("src.core.Data")
      local pokemon = data and data.pokemon
      local species = mon.species
      local def = type(pokemon) == "table"
          and (pokemon[species] or pokemon[tostring(species or ""):upper()])
          or nil
      if not def then return nil end

      local rates = data and data.growth_rates
      local ok, value = pcall(Growth.expForLevel, def.growthRate, cap, rates)
      if ok then return value end
      return nil
  end

  ---------------------------------------------------------------------
  -- STAT EXP / DV RULES (beta.28.15)
  --
  -- Keep this implementation in a lexical block and publish the two helpers
  -- that later acquisition adapters need. This is not cosmetic: main.lua is
  -- one large Lua 5.1 function. beta.28.11 crossed Lua's 200-active-local
  -- compiler limit; this lexical block is the confirmed fix that keeps the
  -- post-release Stat EXP/DV additions below that compiler ceiling.
  ---------------------------------------------------------------------
  do
      local StatRules = {}
      local STAT_KEYS = { "hp", "attack", "defense", "speed", "special" }

      local function statExpPresetValue(ruleKey)
          local idx = math.max(0, math.min(5, math.floor(tonumber(
              mod.save:get(ruleKey, 0)) or 0)))
          return mod.exports.__beta26.statExpPresetValues[idx] or 0
      end

      local function recalcMonStats(data, mon, preserveCurrentHP)
          if type(mon) ~= "table" or not data or type(data.pokemon) ~= "table" then return end
          local def = data.pokemon[mon.species]
          if not def then return end
          local ok, Stats = pcall(require, "src.pokemon.Stats")
          if not ok or type(Stats) ~= "table" or type(Stats.calc) ~= "function" then return end
          local oldHP = tonumber(mon.hp) or 0
          local oldMaxHP = type(mon.stats) == "table" and tonumber(mon.stats.hp) or nil
          local wasFullHP = oldMaxHP ~= nil and oldHP >= oldMaxHP
          mon.stats = Stats.calc(def, tonumber(mon.level) or 1, mon.dvs or {}, mon.statExp or {})
          if preserveCurrentHP then
              -- A full-health gift/starter should stay full after a rule raises
              -- its max HP; a damaged catch keeps its actual battle damage.
              mon.hp = wasFullHP and mon.stats.hp or math.min(mon.stats.hp, oldHP)
          else
              mon.hp = mon.stats.hp
          end
      end

      local function applyPerfectDVs(mon)
          if type(mon) ~= "table" then return end
          -- HP DV is 15 when all four stored Gen 1/2 DVs are 15. Keep hp in
          -- the normalized table too because Gen1Recomp Stats.calc reads it.
          mon.dvs = { hp = 15, attack = 15, defense = 15, speed = 15, special = 15 }
      end

      function StatRules.applyStarting(data, mon, statRule, perfectRule, preserveCurrentHP)
          if type(mon) ~= "table" then return end
          if mod.save:get("nuzlocke_enabled", true) == false then return end
          local amount = statExpPresetValue(statRule)
          mon.statExp = mon.statExp or {}
          for _, key in ipairs(STAT_KEYS) do mon.statExp[key] = amount end
          if mod.save:get(perfectRule, false) == true then applyPerfectDVs(mon) end
          recalcMonStats(data, mon, preserveCurrentHP == true)
      end

      function StatRules.applyPlayer(game, mon)
          game = game or currentGame or mod.game
          local data = game and game.data or (currentGame and currentGame.data)
          StatRules.applyStarting(data, mon, "player_start_stat_exp", "perfect_player_ivs", true)
      end

      -- Catches and compatible provider transactions expose the exact Pokemon.
      mod.events:on("pokemon.received", function(ev)
          if ev and ev.mon then StatRules.applyPlayer(ev.game or currentGame, ev.mon) end
      end)
      mod.events:on("pokemon.caught", function(ev)
          if ev and ev.mon then StatRules.applyPlayer(ev.game or currentGame, ev.mon) end
      end)

      local function installPokemonStatRules()
          if mod.exports.__beta26.isSaveEditorSession() then return true end
          local okBattle, BattleState = pcall(require, "src.battle.BattleState")
          if okBattle and type(BattleState) == "table" then
              if type(BattleState.newWild) == "function"
                  and not (BattleState.__nuzlockeStatWildOwner == mod
                      and BattleState.newWild == BattleState.__nuzlockeStatWildFunction) then
                  if BattleState.__nuzlockeStatWildOwner ~= nil
                      and BattleState.__nuzlockeStatWildOwner ~= mod
                      and BattleState.newWild == BattleState.__nuzlockeStatWildFunction
                      and type(BattleState.__nuzlockeStatWildPrevious) == "function" then
                      BattleState.newWild = BattleState.__nuzlockeStatWildPrevious
                  end
                  local previousWild = BattleState.newWild
                  local wildWrapper = function(game, species, level, opts)
                      local battle = previousWild(game, species, level, opts)
                      local mon = battle and battle.enemy and battle.enemy.mon
                      if mon then
                          StatRules.applyStarting(game and game.data, mon,
                              "wild_start_stat_exp", "perfect_wild_ivs", false)
                          if battle.enemy then
                              battle.enemy.curStats = mon.stats
                              battle.enemy.shownHP = mon.hp
                          end
                      end
                      return battle
                  end
                  BattleState.newWild = wildWrapper
                  BattleState.__nuzlockeStatWildOwner = mod
                  BattleState.__nuzlockeStatWildFunction = wildWrapper
                  BattleState.__nuzlockeStatWildPrevious = previousWild
              end

              if type(BattleState.newTrainer) == "function"
                  and not (BattleState.__nuzlockeStatTrainerOwner == mod
                      and BattleState.newTrainer == BattleState.__nuzlockeStatTrainerFunction) then
                  if BattleState.__nuzlockeStatTrainerOwner ~= nil
                      and BattleState.__nuzlockeStatTrainerOwner ~= mod
                      and BattleState.newTrainer == BattleState.__nuzlockeStatTrainerFunction
                      and type(BattleState.__nuzlockeStatTrainerPrevious) == "function" then
                      BattleState.newTrainer = BattleState.__nuzlockeStatTrainerPrevious
                  end
                  local previousTrainer = BattleState.newTrainer
                  local trainerWrapper = function(game, oppClass, partyIndex)
                      local battle = previousTrainer(game, oppClass, partyIndex)
                      for _, mon in ipairs((battle and battle.enemyParty) or {}) do
                          StatRules.applyStarting(game and game.data, mon,
                              "trainer_start_stat_exp", "perfect_trainer_ivs", false)
                      end
                      local activeMon = battle and battle.enemyParty
                          and battle.enemyParty[battle.enemyIndex or 1]
                      if activeMon and battle.enemy and battle.enemy.mon == activeMon then
                          battle.enemy.curStats = activeMon.stats
                          battle.enemy.shownHP = activeMon.hp
                      end
                      return battle
                  end
                  BattleState.newTrainer = trainerWrapper
                  BattleState.__nuzlockeStatTrainerOwner = mod
                  BattleState.__nuzlockeStatTrainerFunction = trainerWrapper
                  BattleState.__nuzlockeStatTrainerPrevious = previousTrainer
              end
          end

          -- Experience.apply mutates Stat EXP before the public exp.gain hook.
          -- Zero only the defeated base-stat award before predecessor mutation.
          local okExp, Experience = pcall(require, "src.battle.Experience")
          if okExp and type(Experience) == "table" and type(Experience.apply) == "function"
              and not (Experience.__nuzlockeStatExpOwner == mod
                  and Experience.apply == Experience.__nuzlockeStatExpFunction) then
              if Experience.__nuzlockeStatExpOwner ~= nil
                  and Experience.__nuzlockeStatExpOwner ~= mod
                  and Experience.apply == Experience.__nuzlockeStatExpFunction
                  and type(Experience.__nuzlockeStatExpPrevious) == "function" then
                  Experience.apply = Experience.__nuzlockeStatExpPrevious
              end
              local previousApply = Experience.apply
              local expWrapper = function(data, mon, defeatedDef, level, isTrainer, numParticipants, traded)
                  if mod.save:get("nuzlocke_enabled", true) == false
                      or mod.save:get("no_player_stat_exp_gain", false) ~= true
                      or type(mon) ~= "table" or type(defeatedDef) ~= "table" then
                      return previousApply(data, mon, defeatedDef, level, isTrainer, numParticipants, traded)
                  end
                  local blockedDef = {}
                  for k, v in pairs(defeatedDef) do blockedDef[k] = v end
                  blockedDef.baseStats = { hp = 0, attack = 0, defense = 0, speed = 0, special = 0 }
                  return previousApply(data, mon, blockedDef, level, isTrainer, numParticipants, traded)
              end
              Experience.apply = expWrapper
              Experience.__nuzlockeStatExpOwner = mod
              Experience.__nuzlockeStatExpFunction = expWrapper
              Experience.__nuzlockeStatExpPrevious = previousApply
          end
          return true
      end

      mod.exports.__beta26.StatRules = StatRules
      pcall(installPokemonStatRules)
      mod.events:on("game.ready", function() pcall(installPokemonStatRules) end)
      mod.events:on("save.loaded", function() pcall(installPokemonStatRules) end)
      mod.events:on("mods.loaded", function() pcall(installPokemonStatRules) end)
  end

  -- Experience.apply exposes exp.gain as a public hook.  The engine's EXP
  -- hook context contains the Pokemon but not the Game/Save object, so use the
  -- save reference maintained by save.loaded/save.new_game/game.ready rather
  -- than a potentially stale game object.  The level check is authoritative:
  -- once a Pokemon is at the current cap, it gets zero EXP; below the cap, its
  -- normal EXP gain is preserved and only the amount that would cross the cap
  -- is trimmed.
  mod.hooks:wrap("exp.gain", function(next, ctx)
      if not ctx or not ctx.mon then
          return next(ctx)
      end

      if levelCapScope() <= 0 then
          return next(ctx)
      end

      -- Delegate only when the active provider says it owns enforcement.
      -- A provider that explicitly declares compose may supply the cap while
      -- this gate still enforces that shared result.
      local capProvider = activeCompatProvider("level_caps", currentGame, nil)
      local capRelationship = capProvider and
          mod.exports.__beta26.compat.Mods.relationshipFor(
              capProvider.id, "level_caps")
      if capProvider and (capRelationship == "delegate"
          or capRelationship == "exclusive") then
          return next(ctx)
      end

      local save = currentSave or (currentGame and currentGame.save)
      local cap = nextLevelCap(save)
      if not cap then
          return next(ctx)
      end

      if (tonumber(ctx.mon.level) or 1) >= cap then
          local lastCap = tonumber(ctx.mon.nuzlockeWorldCapNotified) or 0
          if lastCap ~= cap then
              ctx.mon.nuzlockeWorldCapNotified = cap
              local _, leader = nextLevelCapInfo(save)
              worldMechanic(currentGame, "cap:" .. tostring(ctx.mon.species) .. ":" .. tostring(cap),
                  Strings("LEVEL CAP REACHED!\n%s cannot go past LV. %d.",
                      tostring(ctx.mon.nickname or ctx.mon.species or "Pokemon"), cap),
                  Strings("Nice try.\nThe Nuzlocke says LV. %d is enough for now.", cap),
                  Strings("Gym Guide: %s is expecting you at the current cap.\nLet's not hand them an overleveled surprise.",
                      tostring(leader)))
          end
          return 0
      end

      local maxExp = capExperienceForMon(ctx.mon, cap)
      local currentExp = tonumber(ctx.mon.exp) or 0
      local gained = next(ctx)
      if not maxExp then
          return gained
      end

      local allowed = math.max(0, maxExp - currentExp)
      return math.max(0, math.min(tonumber(gained) or 0, allowed))
  end, 1000)

  local function countTrackerCatches()
      local total = 0
      for key, entries in pairs(trackerLog()) do
          if key ~= "__LEGACY__" and type(entries) == "table" then
              for _, entry in ipairs(entries) do
                  if type(entry) == "table" and entry.species then total = total + 1 end
              end
          end
      end
      return total
  end

  local function countCaughtAreas()
      local total = 0
      for key, value in pairs(caughtAreas()) do
          if key ~= "__LEGACY__" and value ~= nil then total = total + 1 end
      end
      return total
  end

  local function countVisitedAreas(game)
      -- Historical visited data is imported from the vanilla save on load,
      -- while future visits are recorded by map.entered/world.stepped.
      -- The current map is already synchronized by the tracker lifecycle and
      -- by getDisplayRoutes() during this same draw.
      local total = 0
      for key, value in pairs(visitedAreas()) do
          if key ~= "__LEGACY__" and value == true and isTrackedArea(key) then
              total = total + 1
          end
      end
      return total
  end

  ---------------------------------------------------------------------
  -- GOLD BETA RULE SURFACE
  ---------------------------------------------------------------------
  mod.exports.__beta26.goldBetaRules = {
      nuzlocke_enabled = true,
      permadeath = true,
      first_rival_forgiveness = true,
      encounter_limit = true,
      failed_encounter = true,
      nickname_rule = true,
      dupes_mode = true,
      shiny_clause = true,
      maximum_bst = true,
      player_start_stat_exp = true,
      wild_start_stat_exp = true,
      trainer_start_stat_exp = true,
      no_player_stat_exp_gain = true,
      perfect_player_ivs = true,
      perfect_wild_ivs = true,
      perfect_trainer_ivs = true,
      allow_glitch_pokemon = true,
      no_static_encounters = true,
      no_gambling = true,
      level_cap_scope = true,
      no_escape = true,
      ball_use_ban_tier = true,
      no_tm_use = true,
      no_rare_candy_use = true,
      no_buying = true,
      no_selling = true,
      whiteout_clause = true,
      area_guide_enabled = true,
      automatic_running_shoes = true,
      automatic_default_names = true,
      skip_catch_tutorial = true,
      random_starter = true,
      no_repels = true,
      no_escape_rope = true,
      no_field_healing = true,
      no_pp_items = true,
  }

  mod.exports.__beta26.goldBetaDescriptions = {
      nuzlocke_enabled = Strings.source("GOLD BETA: experimental master switch. Only the reduced Gold rule surface shown here is exposed; every gameplay adapter remains runtime-test-required."),
      permadeath = Strings.source("GOLD BETA / TEST REQUIRED: fainted party Pokemon use Gold's battle-faint path. Keep a backup while validating this adapter."),
      first_rival_forgiveness = Strings.source("GOLD BETA / TEST REQUIRED: forgives faint and Whiteout consequences only during the opening level-5 Rival battle. The exception is consumed when that battle begins; Hardcore defaults it OFF."),
      encounter_limit = Strings.source("GOLD BETA / TEST REQUIRED: one encounter per discovered Gold area through the shared capture policy."),
      failed_encounter = Strings.source("GOLD BETA / TEST REQUIRED: a failed first eligible encounter may consume the area after Soft Start is armed."),
      nickname_rule = Strings.source("GOLD BETA / TEST REQUIRED: catches and scripted gifts must receive a non-empty nickname through Gold's native naming screen."),
      dupes_mode = Strings.source("GOLD BETA / TEST REQUIRED: duplicate handling through Gold's capture gate. OFF = normal, SPEC = species, FAM = evolution family."),
      shiny_clause = Strings.source("GOLD BETA / TEST REQUIRED: shiny catches may bypass Dupes/area restrictions where the shared Gold capture policy supports it."),
      maximum_bst = Strings.source("GOLD BETA / TEST REQUIRED: blocks new catches, ordinary gifts, and trades whose merged six-stat BST exceeds this value. 000/OFF disables it; the mandatory Johto starter remains exempt; unknown modded stat schemas fail open."),
      player_start_stat_exp = Strings.source("GOLD BETA / TEST REQUIRED: applies the selected starting Stat EXP preset to newly acquired player Pokemon only. 0% preserves vanilla zero Stat EXP; existing Pokemon are untouched."),
      wild_start_stat_exp = Strings.source("GOLD BETA / TEST REQUIRED: applies the selected starting Stat EXP preset to newly generated wild Pokemon before battle stats are used."),
      trainer_start_stat_exp = Strings.source("GOLD BETA / TEST REQUIRED: applies the selected starting Stat EXP preset to newly generated trainer Pokemon when the trainer battle party is constructed."),
      no_player_stat_exp_gain = Strings.source("GOLD BETA / TEST REQUIRED: preserves each player Pokemon's existing Stat EXP across battle awards and blocks vitamin Stat EXP increases. Normal EXP and levels remain enabled."),
      perfect_player_ivs = Strings.source("GOLD BETA / TEST REQUIRED: newly acquired player Pokemon receive perfect Gen 1/2 DVs; existing Pokemon are untouched."),
      perfect_wild_ivs = Strings.source("GOLD BETA / TEST REQUIRED: newly generated wild Pokemon receive perfect Gen 1/2 DVs before battle."),
      perfect_trainer_ivs = Strings.source("GOLD BETA / TEST REQUIRED: newly generated trainer Pokemon receive perfect Gen 1/2 DVs instead of the native trainer preset."),
      allow_glitch_pokemon = Strings.source("GOLD BETA / TEST REQUIRED: allow explicitly flagged or malformed glitch species. OFF rejects new glitch acquisitions before mutation; existing glitch Pokemon are preserved and labeled safely."),
      no_static_encounters = Strings.source("GOLD BETA / TEST REQUIRED: blocks Ball use against scripted fixed wild Pokemon while preserving the battle and its story result. Random, roaming, gift, and trade encounters use their own rules."),
      no_gambling = Strings.source("GOLD BETA / TEST REQUIRED: blocks Game Corner slot and card games plus prize-counter redemption before coins or prizes change hands. Coin vendors and unrelated Game Corner dialogue remain available."),
      level_cap_scope = Strings.source("GOLD BETA / TEST REQUIRED: Johto Gyms -> League -> Kanto -> Red progression model. Full progression validation is still open."),
      no_escape = Strings.source("GOLD BETA / TEST REQUIRED: blocks the supported Gold RUN action path."),
      ball_use_ban_tier = Strings.source("GOLD BETA / TEST REQUIRED: cumulative throw ban. POKE/GREAT/ULTRA ban the named standard Ball and weaker ones; STANDARD bans Poke, Great, Ultra, and Master while leaving specialty/custom Balls eligible; ALL blocks every recognized Ball. Ownership, storage, tossing, buying, and selling are unaffected."),
      no_tm_use = Strings.source("Blocks Gold TM use before the Pack opens party selection or teaches a move. HMs remain usable, and TMs may still be obtained, held, given, or sold when other rules permit."),
      no_rare_candy_use = Strings.source("Blocks Gold Rare Candy use before party selection, level changes, stat recalculation, or item consumption. The candy remains in the Pack."),
      no_buying = Strings.source("GOLD BETA / TEST REQUIRED: intended to block Gold Mart purchases only. Mart adapters are under active compatibility testing."),
      no_selling = Strings.source("GOLD BETA / TEST REQUIRED: intended to block Gold Mart selling only. Mart adapters are under active compatibility testing."),
      whiteout_clause = Strings.source("GOLD BETA / TEST REQUIRED: arms run-ending Whiteout when no healthy party Pokemon remain after a faint."),
      area_guide_enabled = Strings.source("GOLD BETA: toggles Gold's discovery-driven Tracker map page instead of preloading the Gen1 area list."),
      automatic_running_shoes = Strings.source("Hold B while walking to run at twice normal walking speed. Gold biking, surfing, scripts, and menus remain unchanged. OFF preserves vanilla movement."),
      automatic_default_names = Strings.source("NEW GAME only: skips Gold's player-name menu by choosing GOLD, then skips only the later police-report Rival naming screen by choosing SILVER. The first Rival battle still correctly displays ???, and Pokemon nickname prompts are unaffected."),
      skip_catch_tutorial = Strings.source("GOLD NEW GAME only: skips the Dude's Route 29 demonstration battle through its normal completion callback. His movement/dialogue and the script's map reload, scene clear, and learned-to-catch event still run."),
      random_starter = Strings.source("Randomize only the starter received from Elm's selected Poke Ball. The chosen ball, starter event flags, rival team path, and story progression remain intact. Other encounters, gifts, trainers, and items are unchanged. Only applies before the starter is received."),
      no_repels = Strings.source("Blocks Repel, Super Repel, and Max Repel from Gold's field Pack before the encounter counter or inventory changes."),
      no_escape_rope = Strings.source("Blocks Escape Rope from Gold's field Pack before warping or consuming the item."),
      no_field_healing = Strings.source("Blocks Gold field use of medicine, status cures, revival items, drinks, herbs, and healing Berries before party or inventory mutation."),
      no_pp_items = Strings.source("Blocks Gold Ether/Elixer items, PP Up/PP Max, and MysteryBerry before PP or inventory mutation, including the supported battle-item path."),
  }

  function mod.exports.__beta26.ruleForConfigSurface(rule, goldMode)
      if not goldMode then
          if rule and rule.goldOnly == true then return nil end
          return rule
      end
      if not (rule and mod.exports.__beta26.goldBetaRules[rule.key]) then return nil end
      local copy = {}
      for k, v in pairs(rule) do copy[k] = v end
      copy.desc = mod.exports.__beta26.goldBetaDescriptions[rule.key] or copy.desc
      return copy
  end

  ---------------------------------------------------------------------
  -- FLAT RULE LIST
  -- MISC contains settings that belong to the Nuzlocke utility layer.
  -- Gym Guide Rare Candy is available both during NEW GAME setup and in
  -- the active-save RULES screen.  Only settings that affect the initial
  -- inventory/state (Money, Poke Balls, and the chosen starting Rare Candy
  -- amount) are NEW-GAME ONLY.
  ---------------------------------------------------------------------
  local function buildFlatItemList(preGame, goldMode)
      local list = {}

      if not goldMode then
          table.insert(list, {
              isHeader = false, isControl = true, isLockeTypeControl = true,
              rule = {
                  key = "locke_type", name = Strings.source("Locke Type"),
                  desc = Strings.source("Choose a preset using rules already supported by this mod. CUSTOM keeps manual settings. NUZ = classic Nuzlocke. HARD = Nuzlocke plus Champion level caps and no healing/X items in battle; set Battle Style to SET in native Options for the full Hardcore format. SOLO = Nuzlocke plus Solo Only and Whiteout.")
              }
          })
      end

      table.insert(list, {
          isHeader = false, isControl = true,
          rule = {
              key = "rules_locked", name = Strings.source("Lock Rules"),
              desc = goldMode
                  and Strings.source("GOLD BETA: lock the Gold-compatible settings shown here. This control always remains usable.")
                  or Strings.source("Lock all Nuzlocke rules in place. The LOCK control itself can always be toggled.")
          }
      })

      for _, cat in ipairs(ruleCategories) do
          local visible = {}
          for _, rule in ipairs(cat.rules) do
              local r = mod.exports.__beta26.ruleForConfigSurface(rule, goldMode)
              if r and (preGame or r.setupOnly ~= true) then
                  visible[#visible + 1] = r
              end
          end
          if #visible > 0 then
              table.insert(list, { isHeader = true, name = cat.title })
              for _, rule in ipairs(visible) do
                  table.insert(list, { isHeader = false, rule = rule })
              end
          end
      end

      if not goldMode then
          table.insert(list, { isHeader = true, name = Strings.source("- MISC -") })
          table.insert(list, {
              isHeader = false,
              rule = {
                  key = "infinite_rare_candies", name = Strings.source("Gym Guide Rare Candy"),
                  desc = Strings.source("Gym Guides keep their normal dialogue, then offer repeatable Rare Candies in batches of 1, 10, 25, 50, or 99.")
              }
          })
      end

      if not preGame then
          table.insert(list, {
              isHeader = false, isControl = true, isInGameSave = true,
              alwaysVisible = true,
              rule = { key = "save_in_game_rules", name = Strings.source("Save Rules"),
                  desc = goldMode
                      and Strings.source("Save the current GOLD BETA-compatible settings to the active Gold save.")
                      or Strings.source("Save the current NUZLOCKE RULES to the active game save.") }
          })
          if not goldMode then
              table.insert(list, {
                  isHeader = false, isControl = true, isRecoveryControl = true,
                  alwaysVisible = true,
                  rule = { key = "recover_legacy_catches", name = Strings.source("Recover Catches"),
                      desc = Strings.source("Review Pokemon from older saves whose catch location could not be recovered automatically.") }
              })
          end
      elseif not goldMode then
          table.insert(list, { isHeader = false, rule = {
              key = "starting_money", name = Strings.source("Money"), numeric = true, digits = 4, min = 0, max = 9999,
              desc = Strings.source("Starting money for R/B/Y NEW GAME.") } })
          table.insert(list, { isHeader = false, rule = {
              key = "starting_pokeballs", name = Strings.source("Poke Balls"), numeric = true, digits = 2, min = 0, max = 99,
              desc = Strings.source("Starting Poke Balls for R/B/Y NEW GAME. They are placed in the room PC.") } })
          table.insert(list, { isHeader = false, rule = {
              key = "starting_rare_candies", name = Strings.source("Rare Candy"), numeric = true, digits = 2, min = 0, max = 99,
              desc = Strings.source("Starting Rare Candies for R/B/Y NEW GAME. They are placed in the room PC.") } })
      end

      if preGame then
          table.insert(list, { isHeader = false, isControl = true, isSetupSave = true,
              alwaysVisible = true,
              rule = { key = "save_setup_options", name = Strings.source("Save Setup"),
                  desc = goldMode
                      and Strings.source("Save this separate GOLD BETA profile for the next Gold NEW GAME. It does not replace the R/B/Y profile.")
                      or Strings.source("Save this separate R/B/Y profile for the next Gen1 NEW GAME. It does not replace the Gold profile.") } })
      end
      return list
  end

  local function getConfigValue(key, preGame)
      if preGame then
          if not pendingNewGameRules then
              pendingNewGameRules = makeDefaultPreGameRules()
          end
          return pendingNewGameRules[key]
      end

      if key == "area_guide_enabled" then
          return routeListShowsAll()
      end

      if key == "locke_type" then
          return math.max(0, math.min(3,
              math.floor(tonumber(mod.save:get("locke_type",
                  defaultRuleValue("locke_type"))) or 0)))
      end

      if key == "level_cap_scope" then
          local rawScope = mod.save:get("level_cap_scope", nil)
          if rawScope == nil then return legacyLevelCapScope() end
          return math.max(0, math.min(4, math.floor(tonumber(rawScope) or 0)))
      end

      if key == "dupes_mode" then
          local rawDupes = mod.save:get("dupes_mode", defaultRuleValue("dupes_mode"))
          if type(rawDupes) == "boolean" then return rawDupes and 2 or 0 end
          return math.max(0, math.min(2, math.floor(tonumber(rawDupes) or 0)))
      end

      if key == "ball_use_ban_tier" then
          return math.max(0, math.min(5, math.floor(tonumber(
              mod.save:get("ball_use_ban_tier", defaultRuleValue("ball_use_ban_tier"))) or 0)))
      end

      if key == "route_splits" or key == "mt_moon_splits"
          or key == "safari_zone_splits" then
          return math.max(0, math.min(1, math.floor(tonumber(
              mod.save:get(key, defaultRuleValue(key))) or 0)))
      end

      local stored = mod.save:get(key, defaultRuleValue(key))
      if key == "maximum_bst" then
          return math.max(0, math.min(999, math.floor(tonumber(stored) or 0)))
      elseif key == "player_start_stat_exp" or key == "wild_start_stat_exp"
          or key == "trainer_start_stat_exp" then
          return math.max(0, math.min(5, math.floor(tonumber(stored) or 0)))
      elseif key == "starting_money" then
          return math.max(0, math.min(9999, math.floor(tonumber(stored) or 0)))
      elseif key == "starting_pokeballs" or key == "starting_rare_candies" then
          if key == "starting_rare_candies" and type(stored) == "boolean" then
              return stored and 99 or 0
          end
          return math.max(0, math.min(99, math.floor(tonumber(stored) or 0)))
      elseif key == "world_building_tier" then
          return math.max(0, math.min(3, math.floor(tonumber(stored) or 3)))
      end
      return stored == true
  end


  local function setConfigValue(key, value, preGame)
      if key == "locke_type" then
          value = math.max(0, math.min(3, math.floor(tonumber(value) or 0)))
      elseif key == "starting_money" then
          value = math.max(0, math.min(9999, math.floor(tonumber(value) or 0)))
      elseif key == "starting_pokeballs" or key == "starting_rare_candies" then
          value = math.max(0, math.min(99, math.floor(tonumber(value) or 0)))
      elseif key == "world_building_tier" then
          value = math.max(0, math.min(3, math.floor(tonumber(value) or 3)))
      elseif key == "level_cap_scope" then
          value = math.max(0, math.min(4, math.floor(tonumber(value) or 0)))
      elseif key == "dupes_mode" then
          value = math.max(0, math.min(2, math.floor(tonumber(value) or 0)))
      elseif key == "ball_use_ban_tier" then
          value = math.max(0, math.min(5, math.floor(tonumber(value) or 0)))
      elseif key == "route_splits" or key == "mt_moon_splits"
          or key == "safari_zone_splits" then
          value = math.max(0, math.min(1, math.floor(tonumber(value) or 0)))
      elseif key == "maximum_bst" then
          value = math.max(0, math.min(999, math.floor(tonumber(value) or 0)))
      elseif key == "player_start_stat_exp" or key == "wild_start_stat_exp"
          or key == "trainer_start_stat_exp" then
          value = math.max(0, math.min(5, math.floor(tonumber(value) or 0)))
      else
          value = value == true
      end

      if preGame then
          if not pendingNewGameRules then
              pendingNewGameRules = makeDefaultPreGameRules()
          end
          pendingNewGameRules[key] = value
          if key ~= "locke_type" and LockePreset.managed[key]
              and not LockePreset.applying then
              pendingNewGameRules.locke_type = 0
          end
          if key == "level_cap_scope" then
              pendingNewGameRules.hardcore_mode = value > 0
              pendingNewGameRules.elite_four_caps = value >= 2
          end
          pendingRulesDirty = true

          if key == "area_guide_enabled" then
              areaGuideEnabled = value
          end
          return
      end

      if key == "area_guide_enabled" then
          saveAreaGuideState(value)
      else
          mod.save:set(key, value)
          if key == "level_cap_scope" then
              mod.save:set("hardcore_mode", value > 0)
              mod.save:set("elite_four_caps", value >= 2)
          end
      end

      if key ~= "locke_type" and LockePreset.managed[key]
          and not LockePreset.applying then
          mod.save:set("locke_type", 0)
      end

      if (key == "route_splits" or key == "mt_moon_splits"
          or key == "safari_zone_splits")
          and type(mod.exports.__beta26.reprojectEncounterAreas) == "function" then
          pcall(mod.exports.__beta26.reprojectEncounterAreas)
      end

      -- Trainer Card and other live UI consumers can use this revision as a
      -- cheap invalidation signal. The actual value remains mod.save's source
      -- of truth, so toggles take effect immediately without requiring a save.
      mod.save:set("nuzlocke_rule_revision", (tonumber(mod.save:get("nuzlocke_rule_revision", 0)) or 0) + 1)

      -- Keep the title-screen representation synchronized with the active save.
      if not pendingNewGameRules then
          pendingNewGameRules = makeDefaultPreGameRules()
      end
      pendingNewGameRules[key] = value
      if key ~= "locke_type" and LockePreset.managed[key]
          and not LockePreset.applying then
          pendingNewGameRules.locke_type = 0
      end
      if key == "level_cap_scope" then
          pendingNewGameRules.hardcore_mode = value > 0
          pendingNewGameRules.elite_four_caps = value >= 2
      end
      pendingRulesDirty = false
      if key == "infinite_rare_candies" and refreshGymGuideVisibility and currentGame then
          refreshGymGuideVisibility(currentGame)
      end
  end

  LockePreset.apply = function(mode, preGame)
      mode = math.max(0, math.min(3, math.floor(tonumber(mode) or 0)))

      -- CUSTOM is intentionally non-destructive: it only drops the preset label
      -- and keeps the player's current rule combination intact.
      if mode == 0 then
          setConfigValue("locke_type", 0, preGame)
          return true
      end

      local preset = LockePreset.presets[mode]
      if type(preset) ~= "table" then return false end

      LockePreset.applying = true
      for key, value in pairs(preset) do
          setConfigValue(key, value, preGame)
      end
      setConfigValue("locke_type", mode, preGame)
      LockePreset.applying = false
      return true
  end

  ---------------------------------------------------------------------
  -- SET MODE
  --
  -- Set Mode is intentionally NOT duplicated in the Nuzlocke rules.
  -- The game's native OPTIONS -> BATTLE STYLE setting is the sole source
  -- of truth.  This mod does not add a second Set Mode toggle or attempt
  -- to synchronize a duplicate setting.
  ---------------------------------------------------------------------

  ---------------------------------------------------------------------
  -- GENERIC MENU MARQUEE

  -- Keep text inside the original menu-width budget.  It waits 3 seconds
  -- before slowly scrolling back and forth.
  ---------------------------------------------------------------------
  local function marqueeText(text, width, elapsed, secondsPerStep)
      text = tostring(text or "")
      if #text <= width then
          return text
      end
      if elapsed < 3 then
          return text:sub(1, width)
      end
      local maxOffset = #text - width
      secondsPerStep = secondsPerStep or 2.4
      local step = math.floor((elapsed - 3) / secondsPerStep)
      local cycle = maxOffset * 2
      local pos = 0
      if cycle > 0 then
          local phase = step % cycle
          if phase <= maxOffset then
              pos = phase
          else
              pos = cycle - phase
          end
      end
      return text:sub(pos + 1, pos + width)
  end

  -- UI-only fold state. Keep Setup, active Rules, and generation surfaces
  -- independent, but do not put navigation preferences into gameplay saves.
  -- The state survives closing/reopening the screen for this mod session.
  local collapsedConfigSections = {}

  ---------------------------------------------------------------------
  -- VANILLA MENU SAFETY
  -- Do not monkey-patch src.ui.Menu.draw. Gen1Recomp v0.1.76 owns menu
  -- scrolling/anchoring there, and replacing the global draw method affects
  -- every title/start/submenu in the game. Our injected title/start entries
  -- intentionally use short labels (SETUP / RULES / TRACKER) instead.
  -- marqueeText remains local to Nuzlocke-owned screens only.
  ---------------------------------------------------------------------

  ---------------------------------------------------------------------
  -- REGISTER CONFIG SCREEN
  ---------------------------------------------------------------------
  mod.content.screens:register("NuzlockeConfigScreen", {
      new = function(game, ctx)
          local preGame = ctx and ctx.preGame == true
          local autoNewGame = ctx and ctx.autoNewGame == true
          -- Gold and R/B/Y share this screen, but their supported rule
          -- surfaces are intentionally different. Resolve the mode from the
          -- explicit caller hint first, then from the live game. B9 left this
          -- lexical undefined, which made Gold render the R/B/Y setup surface.
          local goldMode = (ctx and ctx.goldMode == true)
              or mod.exports.__beta26.runtimeIsGold(game)

          if preGame and not pendingNewGameRules then
              pendingNewGameRules = loadSetupProfileFromDisk()
                  or makeDefaultPreGameRules()
          elseif not preGame then
              discoverAllKnownAreas(game)
              -- The active save is authoritative when entering the in-game menu.
              if not pendingRulesDirty then
                  pendingNewGameRules = makeRulesFromCurrentSave()
              end
              areaGuideEnabled =
                  pendingNewGameRules.area_guide_enabled ~= false
          end

          local allItemList = buildFlatItemList(preGame, goldMode)
          local collapseSurface = (preGame and "setup:" or "rules:")
              .. (goldMode and "gold" or "rby")
          collapsedConfigSections[collapseSurface] =
              collapsedConfigSections[collapseSurface] or {}
          local collapsedSections = collapsedConfigSections[collapseSurface]
          local flatItemList = {}

          local function sectionKey(item)
              return tostring(item and item.name or "")
          end

          local function rebuildVisibleItems(preferred)
              local visible, currentSection = {}, nil
              for _, candidate in ipairs(allItemList) do
                  if candidate.isHeader then
                      currentSection = sectionKey(candidate)
                      candidate.sectionKey = currentSection
                      visible[#visible + 1] = candidate
                  elseif candidate.alwaysVisible
                      or currentSection == nil
                      or collapsedSections[currentSection] ~= true then
                      visible[#visible + 1] = candidate
                  end
              end
              flatItemList = visible
              local target = 1
              if preferred then
                  for i, candidate in ipairs(flatItemList) do
                      if candidate == preferred then target = i break end
                  end
              end
              return target
          end

          local initialCursor = rebuildVisibleItems(nil)

          local self = {
              game = game,
              isOpaque = true,
              preGame = preGame,
              goldMode = goldMode,
              autoNewGame = autoNewGame,
              onDone = ctx and ctx.onDone,
              cursor = initialCursor,
              scroll = 0,
              pageSize = 3,
              descScroll = 0,
              marqueeTime = 0,
              editingNumber = false,
              digitIndex = 1,
              inGameSaveFlash = 0
          }

          function self:update(dt)
              -- The title-screen setup has no active save.  Do not query or
              -- mutate save-backed map state while editing the staged setup.
              if not self.preGame then
                  local currentKey = areaKey(self.game, nil)
                  if currentKey then
                      markVisited(currentKey)
                  end
              end

              self.marqueeTime = self.marqueeTime + (dt or 0)
              if self.setupSaveFlash and self.setupSaveFlash > 0 then
                  self.setupSaveFlash = math.max(0, self.setupSaveFlash - (dt or 0))
              elseif self.setupSaveFlash and self.setupSaveFlash < 0 then
                  self.setupSaveFlash = math.min(0, self.setupSaveFlash + (dt or 0))
              end

              if self.inGameSaveFlash and self.inGameSaveFlash > 0 then
                  self.inGameSaveFlash = math.max(0, self.inGameSaveFlash - (dt or 0))
              elseif self.inGameSaveFlash and self.inGameSaveFlash < 0 then
                  self.inGameSaveFlash = math.min(0, self.inGameSaveFlash + (dt or 0))
              end

              if self.game.input:wasPressed("b") then
                  if self.editingNumber then
                      self.editingNumber = false
                      self.digitIndex = 1
                      self.descScroll = 0
                  else
                      if self.preGame and self.autoNewGame then
                          saveCurrentSetupProfile()
                          stageNewGameProfile()
                          applyNewGameSnapshot()
                          commitDurableSetupProfileToActiveSave()
                      end
                      self.game.stack:pop()
                      if type(self.onDone) == "function" then
                          local cb = self.onDone
                          self.onDone = nil
                          cb()
                      end
                  end
                  return
              end

              -- Declare this before moveCursor so the closure captures the local
              -- helper instead of resolving a nonexistent global on UP/DOWN.
              local function isSelectableItem(item)
                  if not item then return false end
                  if item.isHeader then return true end
                  if item.rule and item.rule.key == "wonderlocke" then return false end
                  return true
              end

              local function moveCursor(dir)
                  local target = self.cursor

                  local guard = 0
                  repeat
                      target = target + dir
                      guard = guard + 1

                      if target < 1 then
                          target = 1
                      end

                      if target > #flatItemList then
                          target = #flatItemList
                      end

                      if guard > (#flatItemList + 1) then
                          return
                      end
                  until isSelectableItem(flatItemList[target])

                  self.cursor = target
                  self.descScroll = 0
              end

              local function selectedItem()
                  return flatItemList[self.cursor]
              end

              local function setHeaderCollapsed(item, value)
                  if not (item and item.isHeader) then return false end
                  local key = item.sectionKey or sectionKey(item)
                  if value == nil then value = collapsedSections[key] ~= true end
                  collapsedSections[key] = value == true
                  self.cursor = rebuildVisibleItems(item)
                  self.scroll = math.max(0,
                      math.min(self.scroll, math.max(0, #flatItemList - 1)))
                  self.descScroll = 0
                  self.editingNumber = false
                  return true
              end

              local function activateControl(item, delta)
                  if not item or not item.isControl then return false end
                  if item.isLockeTypeControl then
                      if getConfigValue("rules_locked", self.preGame) then
                          return true
                      end
                      local current = tonumber(getConfigValue("locke_type",
                          self.preGame)) or 0
                      local step = tonumber(delta) or 1
                      local nextMode = (current + step) % 4
                      LockePreset.apply(nextMode, self.preGame)
                      self.descScroll = 0
                      return true
                  end
                  if item.isSetupSave and self.preGame then
                      local ok = saveCurrentSetupProfile()
                      self.setupSaveFlash = ok and 1.5 or -1.5
                      return true
                  end
                  if item.isInGameSave and not self.preGame then
                      local ok = saveCurrentInGameRules()
                      self.inGameSaveFlash = ok and 1.5 or -1.5
                      return true
                  end
                  if item.isRecoveryControl and not self.preGame then
                      mod.ui.push(self.game, "NuzlockeLegacyRecoveryScreen")
                      return true
                  end
                  if item.rule and item.rule.key == "rules_locked" then
                      local cur = getConfigValue("rules_locked", self.preGame)
                      setConfigValue("rules_locked", not cur, self.preGame)
                      return true
                  end
                  return false
              end

              local function canChangeSelected(item)
                  if not item or item.isHeader then
                      return false
                  end

                  -- The lock control is the one exception: it is always usable.
                  if item.isControl and (item.rule.key == "rules_locked"
                      or item.isInGameSave or item.isSetupSave
                      or item.isRecoveryControl) then
                      return true
                  end
                  if item.isLockeTypeControl then
                      return not getConfigValue("rules_locked", self.preGame)
                  end

                  if item.rule and item.rule.key == "wonderlocke" then
                      return false
                  end
                  if item.rule and item.rule.key == "world_building_tier" then
                      return true
                  end
                  return not getConfigValue("rules_locked", self.preGame)
              end

              local function isStartingResourceRule(rule)
                  if not rule then return false end
                  return rule.key == "starting_money"
                      or rule.key == "starting_pokeballs"
                      or rule.key == "starting_rare_candies"
              end

              local function cycleNumericRule(rule, dir)
                  if not rule then return false end
                  local minValue = tonumber(rule.min) or 0
                  local maxValue = tonumber(rule.max) or minValue
                  local current = tonumber(getConfigValue(rule.key, self.preGame)) or minValue
                  local step = tonumber(dir) or 1
                  local nextValue = current + step
                  if nextValue > maxValue then nextValue = minValue end
                  if nextValue < minValue then nextValue = maxValue end
                  setConfigValue(rule.key, nextValue, self.preGame)
                  self.descScroll = 0
                  return true
              end

              local item = selectedItem()
              local editingAtStart = self.editingNumber

              if self.editingNumber and item and item.rule.numeric
                  and isStartingResourceRule(item.rule) then
                  local rule = item.rule
                  local value = tonumber(getConfigValue(rule.key, self.preGame)) or rule.min
                  local digits = rule.digits or 1
                  local text = ("%0" .. tostring(digits) .. "d"):format(value)

                  if self.game.input:wasPressed("left") then
                      self.digitIndex = math.max(1, self.digitIndex - 1)
                  elseif self.game.input:wasPressed("right") then
                      self.digitIndex = math.min(digits, self.digitIndex + 1)
                  elseif self.game.input:wasPressed("up") or self.game.input:wasPressed("down") then
                      local step = self.game.input:wasPressed("up") and 1 or -1
                      local chars = {}
                      for i = 1, #text do chars[i] = tonumber(text:sub(i, i)) or 0 end
                      chars[self.digitIndex] = (chars[self.digitIndex] + step) % 10
                      local newValue = tonumber(table.concat(chars)) or 0
                      if newValue >= rule.min and newValue <= rule.max then
                          setConfigValue(rule.key, newValue, self.preGame)
                      end
                  elseif self.game.input:wasPressed("a") or self.game.input:wasPressed("select") then
                      self.editingNumber = false
                      self.digitIndex = 1
                      self.descScroll = 0
                  end

              elseif self.game.input:wasPressed("down") then
                  moveCursor(1)
              elseif self.game.input:wasPressed("up") then
                  moveCursor(-1)
              elseif self.game.input:wasPressed("right") or self.game.input:wasPressed("left") then
                  if item and item.isHeader then
                      setHeaderCollapsed(item,
                          self.game.input:wasPressed("left"))
                  elseif item and item.isLockeTypeControl and canChangeSelected(item) then
                      activateControl(item,
                          self.game.input:wasPressed("right") and 1 or -1)
                  elseif item and item.rule and item.rule.key ~= "wonderlocke"
                      and item.rule.numeric and canChangeSelected(item) then
                      if isStartingResourceRule(item.rule) then
                          self.editingNumber = true
                          self.digitIndex = 1
                          self.descScroll = 0
                      else
                          cycleNumericRule(item.rule,
                              self.game.input:wasPressed("right") and 1 or -1)
                      end
                  elseif item and item.isControl then
                      activateControl(item)
                  elseif canChangeSelected(item) then
                      local key = item.rule.key
                      local cur = getConfigValue(key, self.preGame)
                      setConfigValue(key, not cur, self.preGame)
                  end
              elseif self.game.input:wasPressed("select") then
                  if item and not item.isHeader then
                      local descLines = wrapText(Strings(item.rule.desc), 16)
                      local maxScroll = math.max(0, #descLines - 3)
                      if maxScroll > 0 then
                          self.descScroll = (self.descScroll + 1) % (maxScroll + 1)
                      end
                  end
              end

              if self.game.input:wasPressed("a") and not editingAtStart then
                  if item and item.isHeader then
                      setHeaderCollapsed(item)
                  elseif item and item.isLockeTypeControl then
                      if canChangeSelected(item) then activateControl(item, 1) end
                  elseif item and item.isControl then
                      activateControl(item)
                  elseif item and item.rule and item.rule.key ~= "wonderlocke"
                      and item.rule.numeric and canChangeSelected(item) then
                      if isStartingResourceRule(item.rule) then
                          self.editingNumber = true
                          self.digitIndex = 1
                          self.descScroll = 0
                      else
                          cycleNumericRule(item.rule, 1)
                      end
                  elseif canChangeSelected(item) then
                      local key = item.rule.key
                      local cur = getConfigValue(key, self.preGame)
                      setConfigValue(key, not cur, self.preGame)
                  end
              end
          end

          function self:draw()
              local Font = mod.ui.Font

              Font.drawBox(0, 0, 20, 11)
              Font.drawBox(0, 11, 20, 7)

              -- Title: centred in the 160px canvas (inner X=8..152=144px wide).
              -- "NUZLOCKE RULES" = 14 chars * ~10px = 140px => start at X=10.
              -- "NZLCKE SETUP"  = 12 chars * ~10px = 120px => start at X=20.
              local locked = getConfigValue("rules_locked", self.preGame)
              if self.preGame then
                  if self.goldMode then
                      Font.draw(marqueeText(Strings("NUZLOCKE GOLD"), 14,
                          self.marqueeTime), 10, 10)
                      Font.draw(marqueeText(Strings("BETA SETUP"), 14,
                          self.marqueeTime), 10, 22)
                  else
                      Font.draw(marqueeText(Strings("NUZLOCKE SETUP"), 14,
                          self.marqueeTime), 10, 10)
                      Font.draw(marqueeText(Strings("NEW GAME ONLY"), 14,
                          self.marqueeTime), 10, 22)
                  end
              else
                  Font.draw(marqueeText(Strings("NUZLOCKE RULES"), 14,
                      self.marqueeTime), 10, 10)
                  if self.goldMode then Font.draw(marqueeText(
                      Strings("GOLD BETA"), 14, self.marqueeTime), 10, 22) end
                  if locked then
                      Font.draw(Strings("[LK]"), 116, 10)
                  else
                      Font.draw(Strings("R1"), 136, 10)
                  end
              end

              if self.cursor > self.scroll + self.pageSize then
                  self.scroll = self.cursor - self.pageSize
              end

              if self.cursor <= self.scroll then
                  self.scroll = math.max(0, self.cursor - 1)
              end

              -- List starts lower in preGame to clear the two-line header.
              local startY = (self.preGame or self.goldMode) and 40 or 28

              for i = self.scroll + 1,
                  math.min(self.scroll + self.pageSize, #flatItemList) do

                  local item = flatItemList[i]
                  local drawY =
                      startY + ((i - (self.scroll + 1)) * 18)

                  if item.isHeader then
                      local isSelected = (i == self.cursor)
                      if isSelected then
                          local Theme = require("src.ui.Theme")
                          Font.drawCode(Theme.cursor, 14, drawY)
                      end
                      Font.draw(marqueeText(Strings(item.name), 11,
                          self.marqueeTime), 30, drawY)
                      local key = item.sectionKey or sectionKey(item)
                      Font.draw(collapsedSections[key] and "+" or "-",
                          138, drawY)
                  else
                      local isSelected = (i == self.cursor)
                      local key = item.rule.key
                      local val = getConfigValue(key, self.preGame)

                      local isWip = (key == "wonderlocke")
                      if isWip then
                          love.graphics.setColor(0.55, 0.55, 0.55, 1)
                      else
                          love.graphics.setColor(1, 1, 1, 1)
                      end

                      -- Use the engine's native filled menu cursor glyph.
                      -- This is the same sideways arrow family used by vanilla menus.
                      if isSelected and not isWip then
                          local Theme = require("src.ui.Theme")
                          Font.drawCode(Theme.cursor, 14, drawY)
                      end

                      -- 8-char window: 8*~10px=80px, ends at X=110.
                      -- Status starts at X=116 leaving a clean 6px gap.
                      local displayName = marqueeText(
                          Strings(item.rule.name),
                          8,
                          self.marqueeTime
                      )
                      Font.draw(displayName, 30, drawY)

                      if item.isLockeTypeControl then
                          local mode = math.max(0, math.min(3,
                              math.floor(tonumber(val) or 0)))
                          Font.draw(marqueeText(Strings(
                              LockePreset.labels[mode] or "CUSTOM"), 7,
                              self.marqueeTime),
                              108, drawY)
                      elseif item.isRecoveryControl then
                          local legacy = trackerLog().__LEGACY__
                          local count = type(legacy) == "table" and #legacy or 0
                          Font.draw(tostring(count), 118, drawY)
                      elseif item.isSetupSave then
                          local label = "SAVE"
                          if self.setupSaveFlash and self.setupSaveFlash > 0 then
                              label = "SAVED"
                          elseif self.setupSaveFlash and self.setupSaveFlash < 0 then
                              label = "ERROR"
                          end
                          Font.draw(marqueeText(Strings(label), 7,
                              self.marqueeTime), 112, drawY)
                      elseif item.isInGameSave then
                          local label = "SAVE"
                          if self.inGameSaveFlash and self.inGameSaveFlash > 0 then
                              label = "SAVED"
                          elseif self.inGameSaveFlash and self.inGameSaveFlash < 0 then
                              label = "ERROR"
                          end
                          Font.draw(marqueeText(Strings(label), 7,
                              self.marqueeTime), 112, drawY)
                      elseif item.rule.numeric then
                          local digits = item.rule.digits or 1
                          local numberText = ("%0" .. tostring(digits) .. "d"):format(tonumber(val) or item.rule.min or 0)
                          if key == "starting_money" then
                              Font.draw("$" .. numberText, 110, drawY)
                          elseif key == "world_building_tier" then
                              local labels = { [0] = "OFF", [1] = "T1", [2] = "T2", [3] = "T3" }
                              Font.draw(Strings(labels[tonumber(val) or 0] or "OFF"), 118, drawY)
                          elseif key == "level_cap_scope" then
                              local labels = { [0] = "NONE", [1] = "GYMS", [2] = "E4", [3] = "CHAMP", [4] = "POST" }
                              Font.draw(marqueeText(Strings(labels[tonumber(val) or 0]
                                  or "NONE"), 7, self.marqueeTime), 110, drawY)
                          elseif key == "dupes_mode" then
                              local labels = { [0] = "OFF", [1] = "SPEC", [2] = "FAM" }
                              Font.draw(marqueeText(Strings(labels[tonumber(val) or 0]
                                  or "OFF"), 7, self.marqueeTime), 112, drawY)
                          elseif key == "ball_use_ban_tier" then
                              Font.draw(marqueeText(Strings(
                                  mod.exports.__beta26.ballBanTierLabels[
                                      tonumber(val) or 0] or "OFF"), 8,
                                  self.marqueeTime), 104, drawY)
                          elseif key == "route_splits" then
                              local labels = { [0] = "OFF", [1] = "CARDINAL" }
                              Font.draw(marqueeText(Strings(labels[tonumber(val) or 0]
                                  or "OFF"), 9, self.marqueeTime), 96, drawY)
                          elseif key == "mt_moon_splits"
                              or key == "safari_zone_splits" then
                              local labels = { [0] = "OFF", [1] = "COMMON" }
                              Font.draw(marqueeText(Strings(labels[tonumber(val) or 0]
                                  or "OFF"), 8, self.marqueeTime), 104, drawY)
                          elseif key == "player_start_stat_exp" or key == "wild_start_stat_exp"
                              or key == "trainer_start_stat_exp" then
                              Font.draw(marqueeText(Strings(
                                  mod.exports.__beta26.statExpPresetLabels[tonumber(val) or 0]
                                      or "0%"), 7, self.marqueeTime), 112, drawY)
                          elseif key == "maximum_bst" and (tonumber(val) or 0) <= 0 then
                              Font.draw(Strings("OFF"), 118, drawY)
                          else
                              Font.draw(numberText, 118, drawY)
                          end
                          if isSelected and self.editingNumber then
                              local prefix = key == "starting_money" and 1 or 0
                              Font.draw(Strings("^"), 118 + ((self.digitIndex - 1) + prefix) * 6, drawY - 8)
                          end
                      else
                          local status = isWip and "WIP" or (val and "ON" or "OFF")
                          Font.draw(Strings(status), 118, drawY)
                      end

                      love.graphics.setColor(1, 1, 1, 1)
                  end
              end

              local selItem = flatItemList[self.cursor]

              if selItem and not selItem.isHeader then
                  local descLines = wrapText(Strings(selItem.rule.desc), 16)
                  local maxScroll = math.max(0, #descLines - 3)

                  if self.descScroll > maxScroll then
                      self.descScroll = maxScroll
                  end

                  local startLine = self.descScroll + 1
                  -- Show up to 3 lines; third line stays clear for the
                  -- scroll arrow so it never overlaps text.
                  local endLine = math.min(#descLines, startLine + 2)

                  local descY = 94
                  for li = startLine, endLine do
                      Font.draw(descLines[li], 14, descY)
                      descY = descY + 14
                  end

                  -- Blinking native Gen 1 more-below arrow when more text exists below.
                  if self.descScroll < maxScroll then
                      local blinkOn = math.floor(self.marqueeTime / 0.8) % 2 == 0
                      if blinkOn then
                          local Theme = require("src.ui.Theme")
                          Font.drawCode(Theme.moreArrow or 0xEE, 72, 132)
                      end
                  end
              else
                  -- Help text when no rule is focused (e.g. on a header row,
                  -- which shouldn't happen with the cursor skip logic, but
                  -- show sensible hints anyway).
                  if selItem and selItem.isHeader then
                      local key = selItem.sectionKey or sectionKey(selItem)
                      Font.draw(Strings(collapsedSections[key]
                          and "A: EXPAND" or "A: COLLAPSE"), 14, 102)
                      Font.draw(Strings("LEFT: CLOSE"), 14, 116)
                      Font.draw(Strings("RIGHT: OPEN"), 14, 130)
                  elseif self.editingNumber then
                      Font.draw(Strings("LR:Digit  UD:Value"), 14, 96)
                      Font.draw(Strings("A:Confirm"), 14, 112)
                  elseif locked then
                      Font.draw(Strings("Rules are LOCKED."), 14, 96)
                      Font.draw(Strings("A on Lock to open."), 14, 112)
                  else
                      Font.draw(Strings("A or LR: Toggle"), 14, 96)
                      Font.draw(Strings("SEL: Scroll desc"), 14, 110)
                      Font.draw(Strings("B: Back"), 14, 124)
                  end
              end
          end

          return self
      end
  })

  ---------------------------------------------------------------------
  -- BUILD DISPLAY ROUTE LIST
  -- RouteList OFF: only visited/caught areas are shown.
  -- RouteList ON: every tracked area is shown.
  ---------------------------------------------------------------------
  local function syncCurrentArea(game)
      if not game then
          return
      end

      discoverAllKnownAreas(game)

      -- Check every save/runtime representation of the current location.
      -- Different engine paths populate these at slightly different times
      -- during map transitions, so relying on only one of them can miss a city
      -- on an older save.
      local candidates = {}

      if game.overworld and game.overworld.map then
          candidates[#candidates + 1] = game.overworld.map.id
      end

      if game.world and game.world.map then
          candidates[#candidates + 1] = game.world.map.id
      end

      if game.save and game.save.player then
          candidates[#candidates + 1] = game.save.player.map
      end

      if game.save and type(game.save.lastOutdoor) == "table" then
          candidates[#candidates + 1] = game.save.lastOutdoor.id
      end

      for _, rawId in ipairs(candidates) do
          local key = registerArea(rawId)
          if key then
              markVisited(key)
          end
      end
  end

  local TOWN_AREA_IDS = {
      PALLET_TOWN = true, VIRIDIAN_CITY = true, PEWTER_CITY = true,
      CERULEAN_CITY = true, VERMILION_CITY = true, LAVENDER_TOWN = true,
      FUCHSIA_CITY = true, CELADON_CITY = true, SAFFRON_CITY = true,
      CINNABAR_ISLAND = true,
  }

  local TOWN_PREFIXES = {
      -- Keep "vermillion" as a common custom-map misspelling for tolerance;
      -- canonical Gen 1 IDs continue to use the correct "vermilion".
      "pallet", "viridian", "pewter", "cerulean", "vermillion",
      "vermilion", "lavender", "fuchsia", "celadon", "saffron",
      "cinnabar",
  }

  local TOWN_INTERIOR_WORDS = {
      "mart", "pokemart", "poke mart", "pokemon mart", "pkmn mart",
      "center", "pokemon center", "pokecenter", "poke center",
      "gym", "hotel", "house", "lab", "museum", "shop", "gate",
      "dept store", "department store", "game corner", "bike shop",
      "fishing guru", "name rater",
  }

  isTownArea = function(id, name)
      id = tostring(id or "")
      if TOWN_AREA_IDS[id] then return true end

      local text = tostring(name or id or ""):lower()
      text = text:gsub("_+", " ")
      text = text:gsub("([a-z])([A-Z])", "%1 %2"):lower()
      if text:find("city", 1, true)
          or text:find("town", 1, true)
          or text:find("village", 1, true) then
          return true
      end

      -- Treat named town/city interiors as town locations even when their
      -- individual map ID has no CITY/TOWN suffix (e.g. CeruleanMart4).
      local hasTownPrefix = false
      for _, prefix in ipairs(TOWN_PREFIXES) do
          if text:find(prefix, 1, true) == 1 then
              hasTownPrefix = true
              break
          end
      end
      if hasTownPrefix then
          for _, word in ipairs(TOWN_INTERIOR_WORDS) do
              if text:find(word, 1, true) then return true end
          end
      end

      return false
  end

  local function areaAllowedByConfig(area)
      if not area then
          return false
      end

      local routeMode = math.max(0, math.min(1,
          math.floor(tonumber(mod.save:get("route_splits", 0)) or 0)))
      local routeFamily = mod.exports.__beta26.splitFamilyFor(area.id)
      if routeFamily and routeFamily.selector == "route_splits" then
          return routeMode == 1
      end
      if mod.exports.__beta26.routeCardinalAxes[area.id] then
          return routeMode == 0
              or (type(trackerLog()[area.id]) == "table"
                  and #trackerLog()[area.id] > 0)
              or caughtAreas()[area.id] ~= nil
              or (type(mod.save:get("encounter_states", {})) == "table"
                  and mod.save:get("encounter_states", {})[area.id] ~= nil)
      end

      local moon = mod.exports.__beta26.encounterSplitAreas.mt_moon
      local moonMode = math.max(0, math.min(1,
          math.floor(tonumber(mod.save:get("mt_moon_splits", 0)) or 0)))
      if area.id == moon.parent then
          return moonMode == 0
              or (type(trackerLog()[moon.parent]) == "table"
                  and #trackerLog()[moon.parent] > 0)
              or caughtAreas()[moon.parent] ~= nil
              or (type(mod.save:get("encounter_states", {})) == "table"
                  and mod.save:get("encounter_states", {})[moon.parent] ~= nil)
      end
      if moon.members[area.id] then return moonMode == 1 end

      local safari = mod.exports.__beta26.encounterSplitAreas.safari
      local safariMode = math.max(0, math.min(1,
          math.floor(tonumber(mod.save:get("safari_zone_splits", 0)) or 0)))
      if area.id == safari.parent then
          return safariMode == 0
              or (type(trackerLog()[safari.parent]) == "table"
                  and #trackerLog()[safari.parent] > 0)
              or caughtAreas()[safari.parent] ~= nil
              or (type(mod.save:get("encounter_states", {})) == "table"
                  and mod.save:get("encounter_states", {})[safari.parent] ~= nil)
      end
      if safari.members[area.id] then return safariMode == 1 end

      -- Pallet Town is the mandatory starter slot. Keep it visible on the
      -- encounter MAP even when ordinary town catches are disabled.
      if area.id == "PALLET_TOWN" then
          return true
      end

      if isTownArea(area.id, area.name) and not mod.save:get("town_catches", false) then
          return false
      end
      return true
  end

  getDisplayRoutes = function(game)
      if type(mod.exports.__beta26.ensureEncounterProjection) == "function" then
          pcall(mod.exports.__beta26.ensureEncounterProjection)
      end
      syncCurrentArea(game)
      local list = {}

      for _, r in ipairs(ALL_ROUTES) do
          if areaAllowedByConfig(r) then
              table.insert(list, r)
          end
      end

      table.sort(list, function(a, b)
          local ao = ROUTE_ORDER[a.id] or 999999
          local bo = ROUTE_ORDER[b.id] or 999999
          if ao == bo then
              return tostring(a.name) < tostring(b.name)
          end
          return ao < bo
      end)

      return list
  end

  -- beta.26 canonical starter cleanup: older diagnostic runs could record
  -- the same starter in PALLET_TOWN and OAKS_LAB. Remove only the provable
  -- duplicate starter row; never delete unrelated custom-area catches.
  mod.exports.__beta26.cleanupStarterDuplicate = function()
      local log = trackerLog()
      local pallet = log["PALLET_TOWN"]
      if type(pallet) ~= "table" or #pallet == 0 then return false end

      -- Keep this helper self-contained. In earlier B7 code it referenced the
      -- later local isStarterSpecies() definition and therefore resolved a nil
      -- global from this earlier lexical position.
      local starters = {}
      for _, entry in ipairs(pallet) do
          local sp = tostring(entry and entry.species or ""):upper()
          if sp == "BULBASAUR" or sp == "CHARMANDER" or sp == "SQUIRTLE"
              or sp == "PIKACHU" then
              starters[sp] = true
          end
      end
      if next(starters) == nil then return false end

      local changed = false
      local areas = caughtAreas()
      local states = mod.save:get("encounter_states", {})
      if type(states) ~= "table" then states = {} end

      for key, entries in pairs(log) do
          local k = tostring(key or ""):upper()
          if key ~= "PALLET_TOWN" and type(entries) == "table"
              and (k:find("OAK", 1, true) or k:find("LAB", 1, true)) then
              local kept = {}
              local removedStarter = false
              for _, entry in ipairs(entries) do
                  local sp = tostring(entry and entry.species or ""):upper()
                  if starters[sp] then
                      changed = true
                      removedStarter = true
                  else
                      kept[#kept + 1] = entry
                  end
              end
              if #kept > 0 then log[key] = kept else log[key] = nil end
              if removedStarter and starters[tostring(areas[key] or ""):upper()] then
                  areas[key] = nil
              end
              local st = states[key]
              if removedStarter and type(st) == "table"
                  and starters[tostring(st.species or ""):upper()] then
                  states[key] = nil
              end
          end
      end

      if changed then
          mod.save:set("tracker_log", log)
          mod.save:set("caught_areas", areas)
          mod.save:set("encounter_states", states)
      end
      return changed
  end

  ---------------------------------------------------------------------
  -- TRACKER DISPLAY ROWS
  -- The save is grouped by area, but the tracker is displayed row-by-row.
  -- Never comma-join multiple catches from the same area.
  ---------------------------------------------------------------------
  local function getTrackerLogRows()
      if type(mod.exports.__beta26.ensureEncounterProjection) == "function" then
          pcall(mod.exports.__beta26.ensureEncounterProjection)
      end
      mod.exports.__beta26.cleanupStarterDuplicate()
      local log = trackerLog()
      local states = mod.save:get("encounter_states", {})
      if type(states) ~= "table" then states = {} end
      local keys, known = {}, {}
      for key, entries in pairs(log) do
          if type(entries) == "table" and #entries > 0 then
              table.insert(keys, key)
              known[key] = true
          end
      end
      -- Failed encounters are real route outcomes even without a catch.
      -- Surface them in LOG instead of leaving the route visually blank.
      for key, state in pairs(states) do
          if key ~= "__LEGACY__" and not known[key]
              and type(state) == "table" and state.status == "FAILED" then
              table.insert(keys, key)
              known[key] = true
          end
      end
      table.sort(keys, function(a, b)
          local ao = (a == "__LEGACY__") and 999998 or (ROUTE_ORDER[a] or 999999)
          local bo = (b == "__LEGACY__") and 999998 or (ROUTE_ORDER[b] or 999999)
          if ao == bo then return tostring(a) < tostring(b) end
          return ao < bo
      end)
      local rows = {}
      for _, key in ipairs(keys) do
          local entries = log[key]
          if type(entries) == "table" and #entries > 0 then
              for _, catch in ipairs(entries) do
                  if type(catch) == "table" then
                      table.insert(rows, { area = key, catch = catch })
                  end
              end
          else
              local state = states[key]
              if type(state) == "table" and state.status == "FAILED" then
                  table.insert(rows, { area = key, catch = {
                      species = state.species,
                      encounterType = state.encounterType or "wild",
                      failed = true,
                  } })
              end
          end
      end
      return rows
  end

  local function getTrackerMapRows(game)
      mod.exports.__beta26.cleanupStarterDuplicate()
      local log = trackerLog()
      local states = mod.save:get("encounter_states", {})
      if type(states) ~= "table" then states = {} end
      local rows = {}
      for _, route in ipairs(getDisplayRoutes(game)) do
          local catches = log[route.id]
          if type(catches) == "table" and #catches > 0 then
              for _, catch in ipairs(catches) do
                  if type(catch) == "table" then
                      table.insert(rows, { area = route, catch = catch })
                  end
              end
          else
              local state = states[route.id]
              if type(state) == "table" and state.status == "FAILED" then
                  table.insert(rows, { area = route, catch = {
                      species = state.species,
                      encounterType = state.encounterType or "wild",
                      failed = true,
                  } })
              elseif caughtAreas()[route.id] ~= nil then
                  table.insert(rows, { area = route, catch = {
                      species = caughtAreas()[route.id],
                      encounterType = "unknown",
                      retroactive = true,
                  } })
              else
                  table.insert(rows, { area = route, catch = nil })
              end
          end
      end
      return rows
  end

  ---------------------------------------------------------------------
  -- TRAINER CARD Nuzlocke status page
  --
  -- The vanilla Trainer Card remains the front page.  A flips to a live
  -- Nuzlocke status page whose rule list is read directly from mod.save.
  -- Changes made in the in-game RULES menu therefore appear immediately
  -- the next time this page is drawn.
  --
  -- MONEY intentionally stays off this page because it is already shown on
  -- the vanilla front of the Trainer Card.
  ---------------------------------------------------------------------
  mod.content.screens:register("NuzlockeTrainerCardScreen", {
      new = function(game, ctx)
          local TrainerCard = require("src.ui.TrainerCard")
          local vanilla = TrainerCard.new(game, { onCancel = nil })

          local self = {
              game = game,
              vanilla = vanilla,
              isOpaque = true,
              nuzlockeStatusPage = false,
              ruleScroll = 0,
              ruleArrowTime = 0,
              ruleMarqueeTime = 0,
              ruleRevision = tonumber(mod.save:get("nuzlocke_rule_revision", 0)) or 0,
          }

          local function activeRuleNames()
              -- The Trainer Card must use the exact same active-save state as
              -- the in-game Rules screen.  Never read the staged NEW GAME
              -- table here; once the save exists, mod.save is authoritative.
              local names = {}
              if mod.save:get("nuzlocke_enabled", true) ~= true then
                  return { Strings("Nuzlocke OFF") }
              end
              local lockeType = math.max(0, math.min(3,
                  math.floor(tonumber(mod.save:get("locke_type", 0)) or 0)))
              if lockeType > 0 then
                  names[#names + 1] = Strings("Locke %s",
                      Strings(LockePreset.names[lockeType] or "CUSTOM"))
              end
              local function boolSetting(value)
                  if value == true then return true end
                  if type(value) == "number" then return value ~= 0 end
                  if type(value) == "string" then
                      local v = value:lower()
                      return v == "true" or v == "on" or v == "yes" or tonumber(v) == 1
                  end
                  return false
              end
              local function activeLabel(rule)
                  local value = getConfigValue(rule.key, false)
                  if rule.key == "world_building_tier" then
                      local tier = tonumber(value) or 0
                      if tier > 0 then return Strings("World %s", Strings(
                          ({ [1] = "TIER 1", [2] = "TIER 2", [3] = "TIER 3" })[tier])) end
                      return nil
                  elseif rule.key == "level_cap_scope" then
                      local rawScope = mod.save:get("level_cap_scope", nil)
                      local scope = rawScope == nil and legacyLevelCapScope() or (tonumber(rawScope) or 0)
                      if scope > 0 then return Strings("Level Caps %s", Strings(
                          ({ [1] = "GYMS", [2] = "E4", [3] = "CHAMP", [4] = "POST" })[scope])) end
                      return nil
                  elseif rule.key == "dupes_mode" then
                      local mode = tonumber(value) or 0
                      if mode == 1 then return Strings("Dupes SPEC") end
                      if mode == 2 then return Strings("Dupes FAM") end
                      return nil
                  elseif rule.key == "ball_use_ban_tier" then
                      local mode = tonumber(value) or 0
                      if mode > 0 then
                          return Strings("Ball Ban %s", Strings(
                              mod.exports.__beta26.ballBanTierLabels[mode]))
                      end
                      return nil
                  elseif rule.key == "route_splits" then
                      return (tonumber(value) or 0) == 1 and Strings("Routes CARDINAL") or nil
                  elseif rule.key == "mt_moon_splits" then
                      return (tonumber(value) or 0) == 1 and Strings("Mt Moon COMMON") or nil
                  elseif rule.key == "safari_zone_splits" then
                      return (tonumber(value) or 0) == 1 and Strings("Safari COMMON") or nil
                  elseif rule.key == "maximum_bst" then
                      local limit = tonumber(value) or 0
                      return limit > 0 and Strings("Max BST %d", limit) or nil
                  elseif rule.numeric then
                      return (tonumber(value) or 0) > 0 and Strings(rule.name) or nil
                  elseif boolSetting(value) then
                      return Strings(rule.name)
                  end
                  return nil
              end
              for _, cat in ipairs(ruleCategories) do
                  for _, rule in ipairs(cat.rules) do
                      local label = activeLabel(rule)
                      if label then names[#names + 1] = label end
                  end
              end

              -- Gym Guide Rare Candy is a live gameplay toggle, but it is
              -- intentionally outside ruleCategories because it lives in the
              -- MISC utility section of the Rules screen. It still belongs on
              -- the Trainer Card when enabled. Save/Recover controls are not
              -- rules and are never listed here.
              if boolSetting(mod.save:get("infinite_rare_candies", false)) then
                  names[#names + 1] = Strings("Gym Guide Candy")
              end

              -- Immutable NEW GAME setup choices live in the same scrolling
              -- Nuzlocke status/rules list rather than creating a third Trainer
              -- Card page. These values are captured on the save at NEW GAME
              -- construction and never follow the player's current resources.
              local save = self.game and self.game.save or {}
              if save.nuzlockeRunStartMoney ~= nil then
                  names[#names + 1] = Strings("Start $%d",
                      tonumber(save.nuzlockeRunStartMoney) or 0)
              end
              if save.nuzlockeRunStartBalls ~= nil then
                  names[#names + 1] = Strings("Start Balls %d",
                      tonumber(save.nuzlockeRunStartBalls) or 0)
              end
              if save.nuzlockeRunStartCandies ~= nil then
                  names[#names + 1] = Strings("Start Candy %d",
                      tonumber(save.nuzlockeRunStartCandies) or 0)
              end

              return names
          end

          function self:update(dt)
              local input = self.game.input
              local revision = tonumber(mod.save:get("nuzlocke_rule_revision", 0)) or 0
              if revision ~= self.ruleRevision then
                  self.ruleRevision = revision
                  self.ruleScroll = 0
                  self.ruleArrowTime = 0
                  self.ruleMarqueeTime = 0
              end

              if input:wasPressed("a") then
                  self.nuzlockeStatusPage = not self.nuzlockeStatusPage
                  self.ruleScroll = 0
                  self.ruleArrowTime = 0
                  self.ruleMarqueeTime = 0
                  return
              end

              if input:wasPressed("b") then
                  self.game.stack:pop()
                  return
              end

              if self.nuzlockeStatusPage then
                  local names = activeRuleNames()
                  -- draw() has two physical rule rows in the beta.21 layout.
                  -- Keep update() on that same window size so the final rule is
                  -- reachable and the native more-arrow disappears correctly.
                  local visible = 2
                  local maxScroll = math.max(0, #names - visible)

                  if input:wasPressed("down") and self.ruleScroll < maxScroll then
                      self.ruleScroll = self.ruleScroll + 1
                      self.ruleMarqueeTime = 0
                  elseif input:wasPressed("up") and self.ruleScroll > 0 then
                      self.ruleScroll = self.ruleScroll - 1
                      self.ruleMarqueeTime = 0
                  else
                      self.ruleMarqueeTime = self.ruleMarqueeTime + (dt or 0)
                  end

                  -- Clamp the scroll position every update.  The arrow is
                  -- driven by the same condition used to advance the list,
                  -- so it cannot remain visible after the final rule.
                  if self.ruleScroll > maxScroll then
                      self.ruleScroll = maxScroll
                  end

                  local canScrollDown = (self.ruleScroll + visible) < #names
                  if canScrollDown then
                      self.ruleArrowTime = self.ruleArrowTime + (dt or 0)
                  else
                      self.ruleArrowTime = 0
                  end
              else
                  self.ruleScroll = 0
                  self.ruleArrowTime = 0
                  self.ruleMarqueeTime = 0
              end
          end

          function self:draw()
              local Font = mod.ui.Font

              if not self.nuzlockeStatusPage then
                  self.vanilla:draw()
                  -- Flip hint lives in the open band between the trainer
                  -- information/sprite area and the badge sprites.  Keep it
                  -- on the RIGHT side, clear of the WORD badges and dots.
                  Font.draw(Strings("A:NUZ"), 112, 68)
                  return
              end

              love.graphics.setColor(1, 1, 1, 1)
              love.graphics.rectangle("fill", 0, 0, 160, 144)
              Font.drawBox(0, 0, 20, 18)

              Font.draw(Strings("NUZ STATUS"), 28, 8)

              local caught = countTrackerCatches()
              local deaths = tonumber(mod.save:get("nuzlocke_losses", 0)) or 0
              local lostEncounters = 0
              local states = mod.save:get("encounter_states", {})
              if type(states) == "table" then
                  for key, state in pairs(states) do
                      if key ~= "__LEGACY__" and type(state) == "table"
                          and state.status == "FAILED" and isTrackedArea(key) then
                          lostEncounters = lostEncounters + 1
                      end
                  end
              end
              local caughtAreasCount = countCaughtAreas()
              local visitedAreasCount = countVisitedAreas(self.game)
              local totalAreas = #getDisplayRoutes(self.game)
              local cap = nextLevelCap(self.game and self.game.save)

              -- LOST ENC. means an eligible area encounter was consumed without
              -- a catch (KO, flee/escape, etc.). nuzlocke_losses has always been
              -- the Pokemon death counter, so expose it honestly as DEATHS.
              Font.draw(Strings("CAUGHT"), 16, 22)
              Font.draw(("%3d"):format(caught), 108, 22)
              Font.draw(Strings("LOST ENC."), 16, 34)
              Font.draw(("%3d"):format(lostEncounters), 108, 34)
              Font.draw(Strings("DEATHS"), 16, 46)
              Font.draw(("%3d"):format(deaths), 108, 46)
              Font.draw(Strings("CAUGHT A."), 16, 58)
              Font.draw(("%2d/%2d"):format(caughtAreasCount, totalAreas), 88, 58)
              Font.draw(Strings("VISITED A."), 16, 70)
              Font.draw(("%2d/%2d"):format(visitedAreasCount, totalAreas), 88, 70)
              Font.draw(Strings("NEXT CAP"), 16, 82)
              Font.draw(cap >= 100 and Strings("MAX")
                  or Strings("LV%d", cap), 88, 82)

              local names = activeRuleNames()
              local visible = 2
              local maxScroll = math.max(0, #names - visible)
              if self.ruleScroll > maxScroll then
                  self.ruleScroll = maxScroll
              end
              local canScrollDown = (self.ruleScroll + visible) < #names

              local rulesY = 94
              local ruleRowsY = rulesY + 10
              Font.draw(Strings("RULES"), 16, rulesY)
              if #names == 0 then
                  Font.draw(Strings("NONE"), 16, ruleRowsY)
              else
                  for row = 1, visible do
                      local idx = self.ruleScroll + row
                      local name = names[idx]
                      if name then
                          Font.draw(marqueeText(name, 14, self.ruleMarqueeTime),
                              16, ruleRowsY + (row - 1) * 10)
                      end
                  end
              end

              -- Bottom navigation strip. The down marker uses the same native Gen 1 glyph as TextBox.
              -- when the player reaches the last rule, the scroll indicator
              -- disappears completely instead of changing into another arrow.
              -- This leaves the prompts unobstructed and makes the down-arrow
              -- mean exactly one thing: more rules are available below.
              if canScrollDown then
                  local blinkOn = math.floor(self.ruleArrowTime / 0.8) % 2 == 0
                  if blinkOn then
                       local Theme = require("src.ui.Theme")
                       Font.drawCode(Theme.moreArrow or 0xEE, 94, 122)
                   end
              end

              Font.draw(Strings("A:CARD"), 8, 126)
              Font.draw(Strings("B:EXIT"), 104, 126)
          end

          return self
      end
  })


  ---------------------------------------------------------------------
  -- INFINITE RARE CANDY / GYM GUIDE
  --
  -- This is deliberately isolated from the existing Nuzlocke enforcement
  -- hooks.  When disabled, the vanilla Gym Guide handler is replayed and
  -- nothing else happens.  When enabled, the vanilla conversation finishes
  -- first, then the Guide offers a repeatable quantity menu.
  --
  -- The menu is a normal mod screen rather than a replacement for the
  -- engine's item UI.  Bag.add still enforces the normal inventory rules and
  -- the quantity is capped at 99 per conversation.
  ---------------------------------------------------------------------

  local GYM_GUIDE_TALKS = {
      PEWTER_GYM    = "TEXT_PEWTERGYM_GYM_GUIDE",
      CERULEAN_GYM  = "TEXT_CERULEANGYM_GYM_GUIDE",
      VERMILION_GYM = "TEXT_VERMILIONGYM_GYM_GUIDE",
      FUCHSIA_GYM   = "TEXT_FUCHSIAGYM_GYM_GUIDE",
      SAFFRON_GYM   = "TEXT_SAFFRONGYM_GYM_GUIDE",
      CELADON_GYM   = "TEXT_CELADONGYM_GYM_GUIDE",
      CINNABAR_GYM  = "TEXT_CINNABARGYM_GYM_GUIDE",
      VIRIDIAN_GYM  = "TEXT_VIRIDIANGYM_GYM_GUIDE",
  }

  local RARE_CANDY_CHOICES = { 1, 10, 25, 50, 99 }

  -- A small foreground screen.  It intentionally has no dependency on the
  -- Nuzlocke config screen, so it can be used safely from any Gym Guide.
  mod.content.screens:register("NuzlockeRareCandyMenu", {
      new = function(game, context)
          context = context or {}
          local self = {
              game = game,
              selected = 1,
              choices = RARE_CANDY_CHOICES,
              isOpaque = false,
              onSelect = context.onSelect,
              onCancel = context.onCancel,
          }

          function self:update(dt)
              local input = self.game.input
              if input:wasPressed("up") then
                  self.selected = self.selected - 1
                  if self.selected < 1 then self.selected = #self.choices end
              elseif input:wasPressed("down") then
                  self.selected = self.selected + 1
                  if self.selected > #self.choices then self.selected = 1 end
              elseif input:wasPressed("a") then
                  local amount = self.choices[self.selected]
                  local callback = self.onSelect
                  self.game.stack:pop()
                  if callback then callback(amount) end
                  return
              elseif input:wasPressed("b") then
                  local callback = self.onCancel
                  self.game.stack:pop()
                  if callback then callback() end
                  return
              end
          end

          function self:draw()
              local Font = mod.ui.Font
              love.graphics.setColor(1, 1, 1, 1)
              love.graphics.rectangle("fill", 16, 18, 128, 108)
              Font.drawBox(16, 18, 16, 13)
              -- Keep every row visually centered inside the 16-tile box.
              -- This helper is local to draw() so the large main chunk does not
              -- gain another long-lived top-level local. Gen1's UI font is an
              -- 8px fixed-width grid for these ASCII labels.
              local function centeredX(text)
                  return 80 - math.floor((#tostring(text) * 8) / 2)
              end

              Font.draw(Strings("RARE CANDY"), centeredX(Strings("RARE CANDY")), 26)
              Font.draw(Strings("How many?"), centeredX(Strings("How many?")), 42)

              for i, amount in ipairs(self.choices) do
                  local y = 56 + (i - 1) * 10
                  local valueText = tostring(amount)
                  local valueX = centeredX(valueText)
                  if i == self.selected then
                      local Theme = require("src.ui.Theme")
                      Font.drawCode(Theme.cursor, valueX - 12, y)
                  end
                  Font.draw(valueText, valueX, y)
              end

              Font.draw(Strings("B:CANCEL"), centeredX(Strings("B:CANCEL")), 108)
              Font.draw(Strings("A:OK"), centeredX(Strings("A:OK")), 118)
          end

          return self
      end,
  })

  -- R/B/Y-only command access. Gold deliberately does not seed the Gen 1
  -- command table, and its VM must never receive one of those handlers. Keep
  -- the private module name behind an explicit generation gate so a future
  -- shared call site cannot accidentally patch dead Gen 1 code on Gold.
  mod.exports.__beta26.rbyCommandsFor = function(game)
      if mod.exports.__beta26.runtimeIsGold(game) then return nil end
      local moduleName = "src.script." .. "Commands"
      local ok, Commands = pcall(require, moduleName)
      if not ok or type(Commands) ~= "table" then return nil end
      return Commands
  end

  mod.content.commands:register("nuzlocke:infinite_rare_candy", {
      foreground = true,
      fn = function(ctx)
          if ctx and ctx.generation == 2 then return end
          if mod.save:get("infinite_rare_candies", false) ~= true then return end
          if providerExclusive("npc_talk", ctx and ctx.game, nil) then return end

          local Commands = mod.exports.__beta26.rbyCommandsFor(ctx and ctx.game)
          if not Commands then return end
          Commands.show_text(ctx,
              "Psst... doing a Nuzlocke?\nI won't tell the League.\nHow many RARE CANDY do you want?")

          local tier = worldTier(ctx.game)
          if tier >= 2 and levelCapScope() > 0 then
              local cap, leader = nextLevelCapInfo(ctx.game.save)
              Commands.show_text(ctx,
                  tier >= 3
                      and ("Gym Guide: Careful!\nYour current cap is LV. " .. tostring(cap) .. ".\n" .. tostring(leader) .. " won't be impressed.")
                      or ("Nice try.\nRare Candies don't beat the level cap.\nCurrent cap: LV. " .. tostring(cap) .. "."))
          end

          local selectedAmount
          Commands.push_screen(ctx, "NuzlockeRareCandyMenu", {
              onSelect = function(amount) selectedAmount = tonumber(amount) end,
              onCancel = function() selectedAmount = nil end,
          })
          if not selectedAmount then return end

          local okBag, Bag = pcall(require, "src.inventory.Bag")
          if not okBag or not Bag then
              Commands.show_text(ctx, "Rare Candy service is unavailable.")
              return
          end

          local inventory = ctx.save.inventory or {}
          local room = math.max(0, 99 - (tonumber(inventory.RARE_CANDY) or 0))
          local give = math.min(selectedAmount, room)
          if give <= 0 then
              Commands.show_text(ctx, "You already have\n99 RARE CANDY!")
              return
          end
          if not Bag.add(ctx.save, "RARE_CANDY", give, ctx.game.data) then
              Commands.show_text(ctx, "Your BAG is full!")
              return
          end
          Commands.show_text(ctx,
              ("You got %d %s!"):format(give, give == 1 and "RARE CANDY" or "RARE CANDIES"))
      end,
  })

  -- Compose the actual vanilla talk rows with our post-dialogue command.
  -- This is the long-lived beta.8-beta.16 R/B/Y implementation: baseTalk()
  -- returns ScriptRunner rows, so copy those rows and append the candy command
  -- directly. Do not nest a second foreground command/runner around them.
  local function registerGymGuideCandyTalk(mapId, textId)
      local MapScripts = require("src.script.MapScripts")
      local baseRows = MapScripts.baseTalk(mapId, textId)
      local rows = {}
      if type(baseRows) == "table" then
          for i, row in ipairs(baseRows) do rows[i] = row end
      end
      rows[#rows + 1] = { "nuzlocke:infinite_rare_candy" }
      mod.content.map_scripts:register(mapId, {
          priority = 10,
          talk = { [textId] = rows },
      })
  end

  local function gymGuideObjectName(mapDef, textId, mapId)
      if not (mapDef and type(mapDef.objects) == "table") then return nil end

      local fallback
      local upperText = tostring(textId or ""):upper()
      local compactMap = tostring(mapId or ""):gsub("_", ""):upper()

      for _, obj in ipairs(mapDef.objects) do
          local name = tostring(obj.name or "")
          local upperName = name:upper()

          local text = tostring(obj.text or obj.textId or obj.textID or ""):upper()
          local sprite = tostring(obj.sprite or obj.spriteId or ""):upper()

          -- Never mistake a trainer merely because another mod reused its
          -- sprite. Actual trainer objects carry trainer metadata.
          if not isTrainerDefinition(obj) then
              -- Strongest match: the object points at this Gym Guide text.
              if text ~= "" and text == upperText then
                  return name
              end

              -- Generated object names normally preserve the ROM constant, e.g.
              -- PEWTERGYM_GYM_GUIDE.
              if compactMap ~= "" and upperName:find(compactMap, 1, true)
                  and upperName:find("GYM", 1, true)
                  and (upperName:find("GUIDE", 1, true)
                       or upperName:find("GUY", 1, true)) then
                  fallback = name
              end

              -- Some generated builds retain the sprite constant even if the
              -- object name was normalized.
              if sprite == "SPRITE_GYM_GUIDE" then
                  fallback = name
              end
          end
      end

      return fallback
  end

  refreshGymGuideVisibility = function(game)
      -- The Gym Guide candy bridge is an R/B/Y map-script feature. Gold has a
      -- separate script VM and no Gen 2 consumer for the map_scripts registry.
      if game and tonumber(game.generation) == 2 then return end
      if mod.save:get("infinite_rare_candies", false) ~= true then
          return
      end

      local save = game and game.save
      if not save then return end

      -- If another active mod explicitly owns NPC visibility, it gets the final
      -- say. Otherwise ordinary NPC visibility behavior continues to compose
      -- with the Guide.
      if providerExclusive("npc_visibility", game, nil)
          or providerExclusive("npc_behavior", game, nil) then
          return
      end

      save.objectToggles = save.objectToggles or {}

      for mapId, textId in pairs(GYM_GUIDE_TALKS) do
          local def
          if game.overworld and game.overworld.map
              and game.overworld.map.id == mapId
              and game.overworld.map.def then
              def = game.overworld.map.def
          end

          local data = game.data
          if not def and data and data.maps then def = data.maps[mapId] end
          if not def and data and data.mapsById then def = data.mapsById[mapId] end

          local objectName = gymGuideObjectName(def, textId, mapId)
          if objectName then
              save.objectToggles[mapId] = save.objectToggles[mapId] or {}
              save.objectToggles[mapId][objectName] = true

              -- Restore the live NPC immediately if the player is already in
              -- this gym. Commands.show_object uses the engine's public seam
              -- and updates the NPC/entity lists without rebuilding the map.
              local ow = game.overworld
              if ow and ow.map and ow.map.id == mapId then
                  local Commands = mod.exports.__beta26.rbyCommandsFor(game)
                  if Commands and type(Commands.show_object) == "function" then
                      pcall(Commands.show_object, {
                          game = game, save = save, overworld = ow
                      }, mapId, objectName)
                  end
              end
          end
      end
  end

  -- The Gym Guide bridge is a Gen 1 map-script feature. Determine the boot
  -- target from GameVersion rather than mod.game: at mod entry time mod.game
  -- is not guaranteed to carry the active generation, which could suppress
  -- the R/B/Y registrations entirely. This restores the established R/B/Y
  -- registration path while keeping Gold away from the Gen 1 registry.
  local gymGuideGoldBoot = false
  do
      local okVersion, GameVersion = pcall(require, "src.core.GameVersion")
      if okVersion and type(GameVersion) == "table"
          and type(GameVersion.isGold) == "function" then
          local okGold, isGold = pcall(GameVersion.isGold)
          gymGuideGoldBoot = okGold and isGold == true
      end
  end
  if not gymGuideGoldBoot then
      for mapId, textId in pairs(GYM_GUIDE_TALKS) do
          registerGymGuideCandyTalk(mapId, textId)
      end
  end

  mod.events:on("save.loaded", function(ev)
      if ev and ev.save then
          if type(mod.save:get("nuzlocke_e4_defeated")) ~= "table" then
              mod.save:set("nuzlocke_e4_defeated", {})
          end
          refreshGymGuideVisibility(currentGame)
      end
  end)

  mod.events:on("game.ready", function(ev)
      local game = type(ev) == "table" and ev.game or ev
      refreshGymGuideVisibility(game)
  end)

  mod.events:on("map.entered", function(ev)
      if refreshGymGuideVisibility and currentGame then
          refreshGymGuideVisibility(currentGame)
      end
  end)

  -- Map reloads are another way an overworld object list can be rebuilt.
  -- Reapply once after the rebuild instead of polling or fighting another mod
  -- every frame.
  mod.events:on("map.reloaded", function()
      if refreshGymGuideVisibility and currentGame then
          refreshGymGuideVisibility(currentGame)
      end
  end)

  -- Gym victory scripts can hide the Guide after the map was already entered.
  -- Refresh once at battle teardown instead of fighting other mods every frame.
  mod.events:on("battle.ended", function()
      if refreshGymGuideVisibility and currentGame then
          refreshGymGuideVisibility(currentGame)
      end
  end)


  ---------------------------------------------------------------------
  -- TRACKER SCREEN
  ---------------------------------------------------------------------
  ---------------------------------------------------------------------
  -- LEGACY CATCH RECOVERY SCREEN
  --
  -- Select a legacy Pokemon, then select one of the areas that the current
  -- encounter data says could contain that species. Choosing an area records
  -- it as a retroactive catch and removes it from LEGACY.
  ---------------------------------------------------------------------
  mod.content.screens:register("NuzlockeLegacyRecoveryScreen", {
      new = function(game)
          local self = {
              game = game,
              isOpaque = true,
              cursor = 1,
              areaCursor = 1,
              mode = "list",
              scroll = 0,
              actionCursor = 1,
              typeCursor = 1,
              pendingArea = nil,
          }

          local recoveryTypes = {
              "wild", "grass", "surf", "fishing", "overworld",
              "static", "gift", "trade", "safari", "unknown",
          }

          local function entries()
              local out = {}
              local legacy = trackerLog().__LEGACY__
              local mons = collectLegacyMons(game.save or {})
              local usedLegacyMons = {}

              if type(legacy) == "table" then
                  for _, entry in ipairs(legacy) do
                      if type(entry) == "table" then
                          entry.provenance = entry.provenance or "LEGACY"
                          -- Attach the actual save Pokemon to the recovery
                          -- entry. This makes a manual assignment update both
                          -- the tracker log and Catch Info for that Pokemon.
                          local sp = tostring(entry.species or ""):upper()
                          for i, mon in ipairs(mons) do
                              local idMatch = entry.pokemonId
                                  and Identity.pokemonIdentity(mon) == entry.pokemonId
                              local speciesMatch = tostring(mon and mon.species or ""):upper() == sp
                              if not usedLegacyMons[i]
                                  and type(mon) == "table"
                                  and (idMatch or speciesMatch)
                                  and (mon.nuzlockeOrigin == "LEGACY"
                                      or mon.nuzlockeOrigin == "EDITED"
                                      or mon.nuzlockeOrigin == "PLAYER_CONFIRMED")
                                  and not mon.catchLocation then
                                  entry.mon = mon
                                  usedLegacyMons[i] = true
                                  break
                              end
                          end
                          out[#out + 1] = entry
                      end
                  end
              end

              -- Edited Pokemon are current-save objects that were not present
              -- in the Nuzlocke baseline and were not registered by an
              -- acquisition hook. They can be recovered exactly like unknown
              -- legacy Pokemon, but retain EDITED provenance.
              for i, mon in ipairs(mons) do
                  if type(mon) == "table" and mon.species
                      and mon.nuzlockeOrigin == "EDITED"
                      and not mon.catchLocation then
                      out[#out + 1] = {
                          species = mon.species,
                          isShiny = Identity.isShiny(mon),
                          provenance = "EDITED",
                          mon = mon,
                      }
                      usedLegacyMons[i] = true
                  end
              end

              -- Recovered/player-confirmed records remain editable. Limit the
              -- editor to recovery provenance so ordinary catches cannot be
              -- rewritten accidentally from this maintenance screen.
              for area, catches in pairs(trackerLog()) do
                  if area ~= "__LEGACY__" and type(catches) == "table" then
                      for _, catch in ipairs(catches) do
                          local provenance = type(catch) == "table"
                              and tostring(catch.provenance or "") or ""
                          local editable = type(catch) == "table"
                              and (catch.retroactive == true
                                  or catch.recoveryStatus == "PLAYER_CONFIRMED"
                                  or provenance == "LEGACY"
                                  or provenance == "EDITED"
                                  or provenance == "PLAYER_CONFIRMED")
                          if editable then
                              local attached
                              for i, mon in ipairs(mons) do
                                  local idMatch = catch.pokemonId
                                      and Identity.pokemonIdentity(mon) == catch.pokemonId
                                  local locationMatch = routeKey(mon and mon.catchLocation)
                                      == routeKey(area)
                                  local speciesMatch = tostring(
                                      mon and mon.species or ""):upper()
                                      == tostring(catch.species or ""):upper()
                                  if not usedLegacyMons[i] and type(mon) == "table"
                                      and (idMatch or (locationMatch and speciesMatch)) then
                                      attached = mon
                                      usedLegacyMons[i] = true
                                      break
                                  end
                              end
                              out[#out + 1] = {
                                  assigned = true,
                                  area = area,
                                  species = catch.species,
                                  pokemonId = catch.pokemonId,
                                  fingerprint = catch.fingerprint,
                                  isShiny = catch.isShiny == true,
                                  encounterType = catch.encounterType or "unknown",
                                  provenance = provenance ~= "" and provenance
                                      or "PLAYER_CONFIRMED",
                                  possibleAreas = catch.possibleAreas,
                                  logEntry = catch,
                                  mon = attached,
                              }
                          end
                      end
                  end
              end
              return out
          end

          local function recoveryEncounterLimitApplies()
              local rules = mod.save:get("rules")
              if type(rules) ~= "table" then return true end
              if rules.nuzlocke_enabled == false then return false end
              return rules.encounter_limit ~= false
          end

          local function areaAlreadyHasEncounter(log, areas, area, ignoredCatch)
              if not area then return false end
              local catches = log[area]
              if type(catches) == "table" then
                  for _, catch in ipairs(catches) do
                      if catch ~= ignoredCatch then return true end
                  end
              end
              -- caught_areas is a summary and cannot identify ownership. It is
              -- safe to ignore only when this editor record is the sole log row.
              if areas[area] ~= nil then
                  return not (ignoredCatch ~= nil and type(catches) == "table"
                      and #catches == 1 and catches[1] == ignoredCatch)
              end
              return false
          end

          local function filterRecoveryAreas(rawAreas, entry)
              local log = trackerLog()
              local areas = caughtAreas()
              local filtered = {}
              for _, area in ipairs(rawAreas or {}) do
                  if type(area) == "table" then
                      area = area.id or area.mapId or area.key
                  end
                  if area and (not recoveryEncounterLimitApplies()
                      or not areaAlreadyHasEncounter(log, areas, area,
                          entry and entry.logEntry)) then
                      filtered[#filtered + 1] = area
                  end
              end
              return filtered
          end

          local function candidates(entry)
              if not entry then return {} end

              local raw = nil
              if not entry.assigned and type(entry.possibleAreas) == "table"
                  and #entry.possibleAreas > 0 then
                  raw = entry.possibleAreas
              end

              if not raw and not entry.assigned then
                  local providerHistory = mod.save:get("encounter_provider_history")
                  local providerWasUsed = type(providerHistory) == "table" and next(providerHistory) ~= nil
                  if not providerWasUsed and not activeCompatProvider("encounters", game, nil) then
                      local inferred = legacyCandidates(game, entry.species)
                      if #inferred > 0 then raw = inferred end
                  end
              end

              -- UNKNOWN means the engine data cannot prove a wild source.
              -- At that point the player is explicitly confirming history,
              -- so offer the full known area list instead of inventing a
              -- location automatically.
              if not raw then
                  raw = {}
                  for _, route in ipairs(getDisplayRoutes(game)) do
                      if type(route) == "table" then
                          raw[#raw + 1] = route.id
                      elseif route ~= nil then
                          raw[#raw + 1] = route
                      end
                  end
              end

              return filterRecoveryAreas(raw, entry)
          end

          local function refreshCaughtArea(log, areas, area)
              if not area then return end
              local catches = log[area]
              if type(catches) == "table" and #catches > 0 then
                  areas[area] = catches[1].species or areas[area]
              else
                  areas[area] = nil
              end
          end

          local function detachAssignedEntry(entry, keepPending)
              if not (entry and entry.assigned and entry.area and entry.logEntry) then
                  return false
              end
              local log = trackerLog()
              local areas = caughtAreas()
              local catches = log[entry.area]
              if type(catches) == "table" then
                  local remaining = {}
                  for _, catch in ipairs(catches) do
                      if catch ~= entry.logEntry then remaining[#remaining + 1] = catch end
                  end
                  log[entry.area] = #remaining > 0 and remaining or nil
              end
              refreshCaughtArea(log, areas, entry.area)

              if keepPending then
                  log.__LEGACY__ = type(log.__LEGACY__) == "table"
                      and log.__LEGACY__ or {}
                  log.__LEGACY__[#log.__LEGACY__ + 1] = {
                      species = entry.species,
                      pokemonId = entry.pokemonId,
                      fingerprint = entry.fingerprint,
                      isShiny = entry.isShiny == true,
                      possibleAreas = entry.possibleAreas,
                      provenance = entry.provenance or "PLAYER_CONFIRMED",
                      encounterType = entry.encounterType or "unknown",
                  }
              end

              if entry.mon then
                  entry.mon.catchLocation = nil
                  entry.mon.encounterType = entry.encounterType or "unknown"
                  entry.mon.nuzlockeTrackerRegistered = nil
                  local id = Identity.pokemonIdentity(entry.mon)
                  local registry = Identity.identityRegistry()
                  if id and type(registry[id]) == "table" then
                      registry[id].catchLocation = nil
                      mod.save:set(ID_REGISTRY_KEY, registry)
                  end
              end
              mod.save:set("tracker_log", log)
              mod.save:set("caught_areas", areas)
              return true
          end

          local function chooseArea(entry, area, encounterType)
              local log = trackerLog()
              local areas = caughtAreas()
              local legacy = log.__LEGACY__ or {}
              local sp = tostring(entry.species or ""):upper()
              local sourceMon = entry.mon

              -- A manual recovery is a new player confirmation, so it must not
              -- create a second current encounter in an area that already has
              -- one when the 1st Catch rule is active. Existing historical log
              -- entries are preserved; only new assignments are blocked.
              if recoveryEncounterLimitApplies()
                  and areaAlreadyHasEncounter(log, areas, area, entry.logEntry) then
                  return false
              end

              local oldArea = entry.assigned and entry.area or nil
              if entry.assigned then
                  detachAssignedEntry(entry, false)
                  log = trackerLog()
                  areas = caughtAreas()
              end

              registerArea(area)
              log[area] = log[area] or {}
              local recoveredId = sourceMon
                  and Identity.ensurePokemonIdentity(sourceMon, self.game and self.game.save, entry.provenance or "PLAYER_CONFIRMED")
                  or nil
              table.insert(log[area], {
                  species = sp,
                  pokemonId = recoveredId,
                  fingerprint = sourceMon and Identity.fingerprint(sourceMon) or entry.fingerprint,
                  isShiny = entry.isShiny == true,
                  encounterType = encounterType or entry.encounterType or "wild",
                  encounterSource = "manual",
                  recoveryStatus = "PLAYER_CONFIRMED",
                  provenance = entry.provenance or "PLAYER_CONFIRMED",
                  retroactive = true,
              })

              if sourceMon then
                  sourceMon.catchLocation = area
                  sourceMon.encounterType = encounterType
                      or entry.encounterType or "wild"
                  sourceMon.nuzlockeTrackerRegistered = true
                  Identity.setPokemonOrigin(sourceMon, "PLAYER_CONFIRMED")
                  Identity.baselineAdd(sourceMon, "PLAYER_CONFIRMED")
              end
              if areas[area] == nil then
                  areas[area] = sp
              end
              markVisited(area)
              if oldArea then refreshCaughtArea(log, areas, oldArea) end

              local remaining = {}
              local removed = false
              for _, e in ipairs(legacy) do
                  if not removed and e == entry then
                      removed = true
                  else
                      table.insert(remaining, e)
                  end
              end

              if #remaining > 0 then
                  log.__LEGACY__ = remaining
              else
                  log.__LEGACY__ = nil
              end

              mod.save:set("tracker_log", log)
              mod.save:set("caught_areas", areas)
              return true
          end

          local function updateEncounterType(entry, encounterType)
              if not (entry and entry.assigned and entry.logEntry) then return false end
              entry.logEntry.encounterType = encounterType
              entry.logEntry.encounterSource = "manual"
              entry.encounterType = encounterType
              if entry.mon then entry.mon.encounterType = encounterType end
              mod.save:set("tracker_log", trackerLog())
              return true
          end

          function self:update(dt)
              local list = entries()
              if #list == 0 then
                  if self.game.input:wasPressed("b") or self.game.input:wasPressed("a") then
                      self.game.stack:pop()
                  end
                  return
              end

              if self.game.input:wasPressed("b") then
                  if self.mode == "areas" or self.mode == "actions" then
                      self.mode = "list"
                      self.areaCursor = 1
                      self.actionCursor = 1
                      self.pendingArea = nil
                  elseif self.mode == "types" then
                      self.mode = self.pendingArea and "areas" or "actions"
                      self.typeCursor = 1
                  else
                      self.game.stack:pop()
                  end
                  return
              end

              if self.mode == "list" then
                  if self.game.input:wasPressed("down") then
                      self.cursor = math.min(#list, self.cursor + 1)
                  elseif self.game.input:wasPressed("up") then
                      self.cursor = math.max(1, self.cursor - 1)
                  elseif self.game.input:wasPressed("a") then
                      local entry = list[self.cursor]
                      if entry and entry.assigned then
                          self.mode = "actions"
                          self.actionCursor = 1
                      else
                          local c = candidates(entry)
                          if #c > 0 then
                              self.mode = "areas"
                              self.areaCursor = 1
                          end
                      end
                  end
              elseif self.mode == "actions" then
                  local entry = list[self.cursor]
                  local actions = { "CHANGE AREA", "CHANGE TYPE", "REMOVE ENTRY" }
                  if self.game.input:wasPressed("down") then
                      self.actionCursor = math.min(#actions, self.actionCursor + 1)
                  elseif self.game.input:wasPressed("up") then
                      self.actionCursor = math.max(1, self.actionCursor - 1)
                  elseif self.game.input:wasPressed("a") then
                      if self.actionCursor == 1 then
                          self.mode = "areas"
                          self.areaCursor = 1
                      elseif self.actionCursor == 2 then
                          self.pendingArea = nil
                          self.mode = "types"
                          for i, value in ipairs(recoveryTypes) do
                              if value == entry.encounterType then self.typeCursor = i end
                          end
                      elseif self.actionCursor == 3
                          and detachAssignedEntry(entry, true) then
                          self.cursor = math.min(self.cursor, math.max(1, #entries()))
                          self.mode = "list"
                      end
                  end
              elseif self.mode == "areas" then
                  local entry = list[self.cursor]
                  local c = candidates(entry)
                  if #c == 0 then
                      self.mode = "list"
                      return
                  end

                  if self.game.input:wasPressed("down") then
                      self.areaCursor = math.min(#c, self.areaCursor + 1)
                  elseif self.game.input:wasPressed("up") then
                      self.areaCursor = math.max(1, self.areaCursor - 1)
                  elseif self.game.input:wasPressed("a") then
                      local area = c[self.areaCursor]
                      if type(area) == "table" then
                          area = area.id or area.mapId or area.key
                      end
                      self.pendingArea = area
                      self.mode = "types"
                      self.typeCursor = 1
                      for i, value in ipairs(recoveryTypes) do
                          if value == (entry.encounterType or "wild") then
                              self.typeCursor = i
                          end
                      end
                  end
              elseif self.mode == "types" then
                  local entry = list[self.cursor]
                  if self.game.input:wasPressed("down") then
                      self.typeCursor = math.min(#recoveryTypes, self.typeCursor + 1)
                  elseif self.game.input:wasPressed("up") then
                      self.typeCursor = math.max(1, self.typeCursor - 1)
                  elseif self.game.input:wasPressed("a") then
                      local encounterType = recoveryTypes[self.typeCursor]
                      local ok = self.pendingArea
                          and chooseArea(entry, self.pendingArea, encounterType)
                          or updateEncounterType(entry, encounterType)
                      if ok then
                          self.cursor = math.min(self.cursor, math.max(1, #entries()))
                          self.mode = "list"
                          self.pendingArea = nil
                      end
                  end
              end
          end

          function self:draw()
              local Font = mod.ui.Font
              local list = entries()

              Font.drawBox(0, 0, 20, 18)

              if #list == 0 then
                  Font.draw(Strings("RECOVER CATCHES"), 12, 10)
                  Font.draw(Strings("ALL RECOVERED!"), 18, 52)
                  Font.draw(Strings("B:BACK"), 54, 122)
                  return
              end

              if self.mode == "list" then
                  Font.draw(Strings("RECOVER CATCHES"), 16, 10)
                  Font.draw(Strings("SELECT A POKEMON"), 12, 24)

                  local start = math.max(1, math.min(self.cursor - 3, #list - 5))
                  for i = start, math.min(#list, start + 5) do
                      local y = 40 + ((i - start) * 14)
                      if i == self.cursor then Font.drawCode((require("src.ui.Theme")).cursor, 12, y) end
                      local entry = list[i]
                      local sp = tostring(entry.species or "???")
                      local prefix = entry.assigned and "* "
                          or (entry.provenance == "EDITED" and "E " or "L ")
                      Font.draw(prefix .. sp:sub(1, 10), 30, y)
                      if entry.assigned then
                          Font.draw(Strings("EDIT"), 122, y)
                      else
                          local count = type(entry.possibleAreas) == "table"
                              and #entry.possibleAreas or 0
                          Font.draw(count > 0 and tostring(count) or "?", 128, y)
                      end
                  end

                  Font.draw(Strings("A:CHOOSE"), 16, 126)
                  Font.draw(Strings("B:BACK"), 100, 126)
              elseif self.mode == "actions" then
                  local entry = list[self.cursor]
                  Font.draw(Strings("EDIT RECOVERY"), 22, 10)
                  Font.draw(tostring(entry.species or "???"):sub(1, 12), 48, 24)
                  local actions = { "CHANGE AREA", "CHANGE TYPE", "REMOVE ENTRY" }
                  for i, action in ipairs(actions) do
                      local y = 48 + (i - 1) * 20
                      if i == self.actionCursor then
                          Font.drawCode((require("src.ui.Theme")).cursor, 12, y)
                      end
                      Font.draw(Strings(action), 30, y)
                  end
                  Font.draw(Strings("A:CHOOSE"), 16, 126)
                  Font.draw(Strings("B:BACK"), 100, 126)
              elseif self.mode == "types" then
                  local entry = list[self.cursor]
                  Font.draw(Strings("ENCOUNTER TYPE"), 16, 10)
                  Font.draw(tostring(entry.species or "???"):sub(1, 12), 48, 24)
                  local start = math.max(1,
                      math.min(self.typeCursor - 3, #recoveryTypes - 5))
                  for i = start, math.min(#recoveryTypes, start + 5) do
                      local y = 42 + ((i - start) * 14)
                      if i == self.typeCursor then
                          Font.drawCode((require("src.ui.Theme")).cursor, 12, y)
                      end
                      Font.draw(Strings(recoveryTypes[i]:upper()), 30, y)
                  end
                  Font.draw(Strings("A:CONFIRM"), 16, 126)
                  Font.draw(Strings("B:BACK"), 100, 126)
              elseif self.mode == "areas" then
                  local entry = list[self.cursor]
                  local c = candidates(entry)
                  Font.draw(Strings(entry.assigned and "CHANGE AREA?"
                      or "WHERE CAUGHT?"), 26, 10)
                  Font.draw(tostring(entry.species or "???"):sub(1, 12), 48, 24)

                  if #c == 0 then
                      Font.draw(Strings("NO AVAILABLE AREAS"), 16, 58)
                      if recoveryEncounterLimitApplies() then
                          Font.draw(Strings("AREAS ALREADY TAKEN"), 10, 76)
                      else
                          Font.draw(Strings("NO KNOWN AREAS"), 30, 76)
                      end
                      Font.draw(Strings("B:BACK"), 100, 126)
                      return
                  end

                  local start = math.max(1, math.min(self.areaCursor - 3, #c - 5))
                  for i = start, math.min(#c, start + 5) do
                      local y = 42 + ((i - start) * 14)
                      if i == self.areaCursor then Font.drawCode((require("src.ui.Theme")).cursor, 12, y) end
                      local areaId = c[i]
                      if type(areaId) == "table" then
                          areaId = areaId.id or areaId.mapId or areaId.key
                      end
                      Font.draw(routeName(areaId):sub(1, 15), 30, y)
                  end

                  Font.draw(Strings("A:ASSIGN"), 16, 126)
                  Font.draw(Strings("B:BACK"), 100, 126)
              end
          end

          return self
      end
  })

  mod.content.screens:register("NuzlockeTrackerScreen", {
      new = function(game)
          local self = {
              game = game,
              isOpaque = true,
              tab = 1,
              scroll = 0,
              log = trackerLog(),
              marqueeTime = 0,
              arrowTime = 0,
          }

          function self:update(dt)
              syncCurrentArea(self.game)

              if self.game.input:wasPressed("b") then
                  self.game.stack:pop()
                  return
              end

              local guideEnabled = mod.save:get("area_guide_enabled", true) == true
              if not guideEnabled then
                  self.tab = 1
              end

              -- A is the page toggle. It is deliberately unavailable when
              -- Area Guide is locked OFF.
              if guideEnabled and self.game.input:wasPressed("a") then
                  self.tab = (self.tab == 1) and 2 or 1
                  self.scroll = 0
                  self.marqueeTime = 0
              end

              -- Keep left/right as a convenient secondary page control only
              -- when the Area Guide is enabled.
              if guideEnabled and self.game.input:wasPressed("left") then
                  self.tab = 1
                  self.scroll = 0
                  self.marqueeTime = 0
              elseif guideEnabled and self.game.input:wasPressed("right") then
                  self.tab = 2
                  self.scroll = 0
                  self.marqueeTime = 0
              end

              local listCount = self.tab == 1
                  and #getTrackerLogRows()
                  or #getTrackerMapRows(self.game)
              local maxScroll = math.max(0, listCount - 4)

              if self.game.input:wasPressed("down") and self.scroll < maxScroll then
                  self.scroll = self.scroll + 1
                  self.marqueeTime = 0
              elseif self.game.input:wasPressed("up") and self.scroll > 0 then
                  self.scroll = self.scroll - 1
                  self.marqueeTime = 0
              end

              self.marqueeTime = self.marqueeTime + (dt or 0)

              -- The arrow has its own timer so reaching the last page makes
              -- it completely inert/invisible instead of continuing a hidden
              -- blink animation. It restarts calmly when another page exists.
              local arrowListCount = self.tab == 1
                  and #getTrackerLogRows()
                  or #getTrackerMapRows(self.game)
              local arrowMaxScroll = math.max(0, arrowListCount - 4)
              if self.scroll < arrowMaxScroll then
                  self.arrowTime = self.arrowTime + (dt or 0)
              else
                  self.arrowTime = 0
              end
          end

          function self:draw()
              syncCurrentArea(self.game)
              local Font = mod.ui.Font
              local guideEnabled = mod.save:get("area_guide_enabled", true) == true

              Font.drawBox(0, 0, 20, 18)
              -- "ENC TRACKER" = 11 chars from X=14 -> ends ~X=124, safe.
              -- Tab indicator [1]/[2] shown at right to show current page.
              Font.draw(Strings("ENC TRACKER"), 14, 8)
              local tabLabel = Strings(self.tab == 1 and "[LOG]" or "[MAP]")
              Font.draw(tabLabel, 110, 8)

              local y = 26
              local listCount

              if self.tab == 1 then
                  Font.draw(Strings("AREA      RESULT"), 16, y)
                  y = y + 12
                  local rows = getTrackerLogRows()
                  listCount = #rows

                  for i = self.scroll + 1, math.min(self.scroll + 4, #rows) do
                      local row = rows[i]
                      local catch = row.catch or {}
                      local species = catch.species or "???"
                      if catch.failed then
                          -- beta.26.4: FAIL-W/FAIL-O was compact but cryptic.
                          -- Show a plain-language result plus the encountered
                          -- species; the existing marquee now exposes the full
                          -- label in the seven-character result column.
                          species = Strings("FAILED %s", tostring(catch.species or "???"))
                      elseif catch.isShiny then
                          species = "*" .. species
                      end
                      local routeLabel = (row.area == "__LEGACY__")
                          and Strings("LEGACY") or routeName(row.area)
                      Font.draw(marqueeText(routeLabel, 8, self.marqueeTime), 16, y)
                      Font.draw(marqueeText(species, 7, self.marqueeTime), 96, y)
                      y = y + 18
                  end
              else
                  Font.draw(Strings("AREA      RESULT"), 16, y)
                  y = y + 12
                  local rows = getTrackerMapRows(self.game)
                  listCount = #rows

                  for i = self.scroll + 1, math.min(self.scroll + 4, #rows) do
                      local row = rows[i]
                      local r = row.area
                      local catch = row.catch
                      local status = "..."
                      if catch then
                          if catch.failed then
                              status = Strings("FAILED %s", tostring(catch.species or "???"))
                          elseif catch.isShiny then
                              status = "*" .. tostring(catch.species or "???")
                          else
                              status = tostring(catch.species or "???")
                          end
                      end
                      Font.draw(marqueeText(Strings(r.name), 8,
                          self.marqueeTime, 3.8), 16, y)
                      Font.draw(marqueeText(status, 7, self.marqueeTime), 96, y)
                      y = y + 18
                  end
              end

              local maxScroll = math.max(0, listCount - 4)
              local canScrollUp = self.scroll > 0
              local canScrollDown = self.scroll < maxScroll
              local blinkOn = math.floor(self.arrowTime / 1.0) % 2 == 0

              if canScrollUp and blinkOn then
                  Font.draw(Strings("^"), 72, 18)
              end

              -- Bottom bar: navigation hints + level cap reminder.
              local cap = nextLevelCap(self.game and self.game.save)
              local capStr = cap >= 100 and Strings("CAP:MAX")
                  or Strings("CAP:%d", cap)
              Font.draw(capStr, 14, 112)
              if guideEnabled then
                  Font.draw(Strings("A:PG"), 72, 112)
              end
              Font.draw(Strings("B:X"), 122, 112)

              if canScrollDown and blinkOn then
                  local Theme = require("src.ui.Theme")
                  Font.drawCode(Theme.moreArrow or 0xEE, 72, 122)
              end
          end

          return self
      end
  })

  ---------------------------------------------------------------------
  -- CATCH INFO SCREEN
  -- Uses the same compact layout as the working catch-info page, but now
  -- includes the Nuzlocke encounter type and a factual loss summary.
  ---------------------------------------------------------------------
  mod.content.screens:register("NuzlockeCatchInfoScreen", {
      new = function(game, ctx)
          local mon = ctx and ctx.mon

          -- R/B/Y starters are canonically a Pallet Town encounter. Some
          -- engine acquisition callbacks can temporarily stamp the physical
          -- Oak's Lab map onto a starter table before later tracker cleanup.
          -- Repair that metadata as soon as Catch Info receives the actual mon
          -- so the player never has to wait for the Pokedex handoff to see the
          -- canonical location. Gold remains NEW_BARK_TOWN and is untouched.
          if type(mon) == "table" and mon.species then
              local ver = getGameVersion and getGameVersion() or "RED"
              local sp = tostring(mon.species or ""):upper()
              local locText = tostring(mon.catchLocation or ""):upper()
              local rbyStarter = (ver == "YELLOW" and sp == "PIKACHU")
                  or ((ver == "RED" or ver == "BLUE")
                      and (sp == "BULBASAUR" or sp == "CHARMANDER"
                          or sp == "SQUIRTLE"))
              if rbyStarter and (locText == "" or locText == "UNKNOWN"
                  or locText:find("OAK", 1, true)
                  or locText:find("LAB", 1, true)) then
                  mon.catchLocation = "PALLET_TOWN"
                  mon.encounterType = mon.encounterType or "gift"
                  mon.nuzlockeTrackerRegistered = true
                  Identity.setPokemonOrigin(mon, mon.nuzlockeOrigin or "NORMAL")
                  Identity.baselineAdd(mon, mon.nuzlockeOrigin or "NORMAL")
              end
          end

          local self = {
              game = game,
              isOpaque = true,
              mon = mon
          }

          function self:update(dt)
              if self.game.input:wasPressed("b")
                  or self.game.input:wasPressed("a") then
                  self.game.stack:pop()
              end
          end

          local function displayOrigin(mon)
              local value = mon and mon.nuzlockeOrigin
              if value == "LEGACY" then return Strings("LEGACY") end
              if value == "EDITED" then return Strings("EDITED") end
              if value == "PLAYER_CONFIRMED" then return Strings("CONFIRMED") end
              return Strings("NORMAL")
          end

          local function displayEncounterType(mon)
              if mon and (mon.nuzlockeGlitch == true
                  or mod.exports.__beta26.getGlitchSpeciesInfo(
                      game, mon.species).isGlitch) then
                  return Strings("GLITCH")
              end
              local value = mon and (mon.encounterType or mon.nuzlockeEncounterType)
              if not value then return Strings("UNKNOWN") end
              local labels = {
                  overworld = "OVERWORLD",
                  wild = "WILD",
                  town = "TOWN",
                  safari = "SAFARI",
                  grass = "GRASS",
                  surf = "SURF",
                  fishing = "FISHING",
                  old_rod = "OLD ROD",
                  good_rod = "GOOD ROD",
                  super_rod = "SUPER ROD",
                  gift = "GIFT",
                  static = "STATIC",
                  trade = "TRADE",
                  wonder_trade = "WONDER TRADE"
              }
              return Strings(labels[value] or tostring(value):upper())
          end

          function self:draw()
              local Font = mod.ui.Font
              local mon = self.mon

              Font.drawBox(0, 0, 20, 18)
              Font.draw(Strings("CATCH INFO"), 24, 12)

              if not mon then
                  Font.draw(Strings("No data."), 16, 40)
                  Font.draw(Strings("A/B: BACK"), 40, 122)
                  return
              end

              local label = mon.nickname
              if label == nil or label == "" then
                  label = mod.exports.__beta26.safeSpeciesLabel(game, mon.species)
              end
              label = tostring(label)
              local loc = routeName(mon.catchLocation or "UNKNOWN")
              local encounter = displayEncounterType(mon)
              local origin = displayOrigin(mon)
              local dead = mon.nuzlockeDead == true

              Font.draw(Strings("CATCH"), 16, 28)
              Font.draw(label, 16, 40)

              Font.draw(Strings("LOCATION"), 16, 54)
              Font.draw(loc, 16, 66)

              Font.draw(Strings("ENCOUNTER TYPE"), 16, 80)
              Font.draw(encounter, 16, 92)

              Font.draw(Strings("ORIGIN"), 16, 104)
              Font.draw(origin, 16, 114)

              Font.draw(Strings("STATUS"), 92, 104)
              Font.draw(Strings(dead and "LOST" or "ALIVE"), 92, 114)

              if dead then
                  -- Reserve the final two 8px rows for the loss summary. The
                  -- previous y=130/142 placement clipped row two and could
                  -- overlap the back hint when the cause fit on one line.
                  local cause = Strings(tostring(
                      mon.deathCauseText or mon.deathCause or "BATTLE"))
                  local lines = wrapText(cause, 16)
                  if lines[1] then Font.draw(lines[1], 16, 126) end
                  if lines[2] then Font.draw(lines[2], 16, 136) end
              elseif Identity.isShiny(mon) then
                  -- Keep STATUS=ALIVE readable; SHINY is an additional fact,
                  -- not a replacement drawn on top of the status value.
                  Font.draw(Strings("SHINY"), 16, 126)
                  Font.draw(Strings("A/B:BACK"), 88, 126)
              else
                  Font.draw(Strings("A/B: BACK"), 40, 126)
              end
          end

          return self
      end
  })

  ---------------------------------------------------------------------
  -- TITLE MENU HOOK
  --
  -- SETUP is a NEW-GAME-only entry. The engine's own final title menu is
  -- authoritative: if it contains CONTINUE, a valid save exists for the
  -- currently selected version/slot and SETUP must stay hidden.
  ---------------------------------------------------------------------
  mod.hooks:wrap("ui.title_menu.items", function(next, game, items)
      local result = next(game, items)
      if type(result) ~= "table" then
          result = items
      end

      local goldMode = mod.exports.__beta26.runtimeIsGold(game)
      local function titleLabel(item)
          if type(item) ~= "table" then return nil end
          local label = item.label
          if type(label) == "table" then
              label = label.source or label.text or label.label
          end
          return type(label) == "string" and label:upper() or nil
      end
      local function isContinueItem(item)
          if type(item) ~= "table" then return false end
          if item.value == "continue" then return true end
          local label = titleLabel(item)
          return label == "CONTINUE" or label == tostring(Strings("CONTINUE")):upper()
      end
      local function isNewGameItem(item)
          if type(item) ~= "table" then return false end
          if item.value == "new" then return true end
          local label = titleLabel(item)
          return label == "NEW GAME" or label == tostring(Strings("NEW GAME")):upper()
      end
      local function insertSetupBeforeNewGame(setup)
          for index, item in ipairs(result) do
              if isNewGameItem(item) then
                  table.insert(result, index, setup)
                  return true
              end
          end
          return false
      end

      for _, item in ipairs(result) do
          -- NEW GAME: stage the pending rules for the upcoming save.
          -- This is the established R/B/Y callback path used by beta.20 and
          -- earlier. Gold uses its native value-dispatch adapter below.
          if isNewGameItem(item) and type(item.onSelect) == "function"
              and item.nuzlockeNewGameWrapped ~= true then
              local originalNewGame = item.onSelect
              item.nuzlockeNewGameWrapped = true
              item.onSelect = function()
                  mod.exports.__beta26.selectSetupProfileScope(game)
                  if not pendingNewGameRules then
                      pendingNewGameRules = loadSetupProfileFromDisk()
                          or makeDefaultPreGameRules()
                  end
                  saveSetupProfileToDisk(pendingNewGameRules)
                  stageNewGameProfile()
                  originalNewGame()
              end
          end

          -- CONTINUE: discard any staged setup so it can never override
          -- the existing save's rules.
          if isContinueItem(item) and type(item.onSelect) == "function"
              and item.nuzlockeContinueWrapped ~= true then
              local originalContinue = item.onSelect
              item.nuzlockeContinueWrapped = true
              item.onSelect = function()
                  pendingNewGameRulesForNextSave = false
                  pendingRulesDirty = false
                  newGameRulesSnapshot = nil
                  newGameRulesCommitPending = false
                  newGameCommitPassesRemaining = 0
                  clearPersistedStagedProfile()
                  originalContinue()
              end
          end
      end

      -- Beta.20's R/B/Y rule: trust the FINAL vanilla menu only for whether
      -- CONTINUE exists, then insert SETUP before NEW GAME. Do not require a
      -- particular NEW GAME row shape before inserting the R/B/Y entry.
      local hasContinue = false
      local hasSetup = false
      for _, item in ipairs(result) do
          if isContinueItem(item) then hasContinue = true end
          if type(item) == "table" and (item.nuzlockeSetup == true
              or item.value == "nuzlocke_setup") then hasSetup = true end
      end

      if not goldMode then
          if not hasContinue and not hasSetup then
              insertSetupBeforeNewGame({
                  label = Strings("SETUP"),
                  nuzlockeSetup = true,
                  onSelect = function()
                      mod.exports.__beta26.selectSetupProfileScope(game)
                      if not pendingNewGameRules or not pendingRulesDirty then
                          pendingNewGameRules = loadSetupProfileFromDisk()
                              or makeDefaultPreGameRules()
                          pendingRulesDirty = false
                      end
                      mod.ui.push(game, "NuzlockeConfigScreen", { preGame = true, goldMode = false })
                  end
              })
          end
      else
          -- Preserve Gold's dedicated row/value path, but obey the same
          -- NEW-GAME-only contract as R/B/Y. Gold exposes both CONTINUE and
          -- NEW GAME when a save exists, so checking only the NEW GAME value
          -- incorrectly left SETUP visible beside CONTINUE.
          local newGameRow
          for _, item in ipairs(result) do
              if isNewGameItem(item) then
                  newGameRow = item
                  break
              end
          end
          if not hasContinue and not hasSetup and newGameRow
              and newGameRow.value == "new" then
              insertSetupBeforeNewGame({
                  label = Strings("SETUP"),
                  value = "nuzlocke_setup",
                  nuzlockeSetup = true,
              })
          end
      end

      return result
  end)

  -- Gold's title list dispatches values through MainMenu:choose(). The shared
  -- title hook above can therefore add the row, while this tiny Gen2 adapter
  -- owns only the new value. Every built-in value still delegates unchanged.
  -- Keep the installer scoped in a block so this very large mod does not add
  -- another long-lived top-level local.
  do
      local function installGoldTitleSetupAdapter()
          if mod.exports.__beta26.isSaveEditorSession() then return true end
          local okVersion, GameVersion = pcall(require, "src.core.GameVersion")
          if not okVersion or type(GameVersion) ~= "table"
              or type(GameVersion.isGold) ~= "function" then return false end
          local okGold, isGold = pcall(GameVersion.isGold)
          if not okGold or isGold ~= true then return true end

          local okMenu, MainMenu = pcall(require, "src.ui.gen2.MainMenu")
          if not okMenu or type(MainMenu) ~= "table"
              or type(MainMenu.choose) ~= "function" then return false end
          if MainMenu.__nuzlockeTitleSetupOwner == mod
              and MainMenu.choose == MainMenu.__nuzlockeTitleSetupFunction then
              return true
          end
          -- If the previous Nuzlocke loader session is still the live top-level
          -- wrapper, unwrap exactly that function before composing this session.
          -- If another mod wrapped after us, preserve its live chain instead.
          if MainMenu.__nuzlockeTitleSetupOwner ~= nil
              and MainMenu.__nuzlockeTitleSetupOwner ~= mod
              and MainMenu.choose == MainMenu.__nuzlockeTitleSetupFunction
              and type(MainMenu.__nuzlockeTitleSetupPrevious) == "function" then
              MainMenu.choose = MainMenu.__nuzlockeTitleSetupPrevious
          end

          local vanillaChoose = MainMenu.choose
          local chooseWrapper
          chooseWrapper = function(self, value, ...)
              if value == "nuzlocke_setup" then
                  mod.exports.__beta26.selectSetupProfileScope(self.game)
                  pendingNewGameRules = loadSetupProfileFromDisk()
                      or makeDefaultPreGameRules()
                  pendingRulesDirty = false
                  mod.ui.push(self.game, "NuzlockeConfigScreen", { preGame = true, goldMode = true })
                  return
              elseif value == "new" then
                  mod.exports.__beta26.selectSetupProfileScope(self.game)
                  if not pendingNewGameRules then
                      pendingNewGameRules = loadSetupProfileFromDisk()
                          or makeDefaultPreGameRules()
                  end
                  saveSetupProfileToDisk(pendingNewGameRules)
                  stageNewGameProfile()
              elseif value == "continue" then
                  pendingNewGameRulesForNextSave = false
                  pendingRulesDirty = false
                  newGameRulesSnapshot = nil
                  newGameRulesCommitPending = false
                  newGameCommitPassesRemaining = 0
                  clearPersistedStagedProfile()
              end
              return vanillaChoose(self, value, ...)
          end
          MainMenu.choose = chooseWrapper
          MainMenu.__nuzlockeTitleSetupOwner = mod
          MainMenu.__nuzlockeTitleSetupPrevious = vanillaChoose
          MainMenu.__nuzlockeTitleSetupFunction = chooseWrapper
          return true
      end
      pcall(installGoldTitleSetupAdapter)
      mod.events:on("game.ready", function()
          pcall(installGoldTitleSetupAdapter)
      end)
  end


  ---------------------------------------------------------------------
  -- START MENU HOOKS
  --
  -- IMPORTANT: build from the VANILLA result first, then modify that
  -- returned list.  Calling insertBefore() on the incoming `items` and
  -- then calling next() causes the vanilla hook to rebuild the list and
  -- silently discard our inserted entries.  That was why RULES/TRACKER
  -- disappeared in the previous build.
  ---------------------------------------------------------------------
  mod.hooks:wrap("ui.start_menu.items", function(next, game, items)
      local result = next(game, items)
      if type(result) ~= "table" then
          result = items
      end

      local version = getGameVersion and getGameVersion() or "RED"
      local goldMenu = version == "GOLD"
      -- Gen 1 localizes this row before the hook; Gold currently exposes a
      -- raw label plus a stable id. Resolve the actual rendered label so both
      -- implementations and translation mods remain valid insertion anchors.
      local optionAnchor = "OPTION"
      for _, item in ipairs(result) do
          if type(item) == "table" and (item.label == "OPTION"
              or item.label == Strings("OPTION")
              or item.id == "option" or item.value == "option") then
              optionAnchor = item.label or optionAnchor
              break
          end
      end

      -- R/B/Y keeps the established Trainer Card flip/status integration.
      -- Gold's native card already owns multiple pages, so beta.27.5 stops
      -- hijacking that row and exposes a dedicated status screen through the
      -- shared public ui.start_menu.items hook instead.
      if not goldMenu then
          for _, item in ipairs(result) do
              if item and item.label == (game.save and game.save.player and game.save.player.name or "RED")
                  and type(item.onSelect) == "function" then
                  item.onSelect = function()
                      mod.ui.push(game, "NuzlockeTrainerCardScreen")
                  end
                  break
              end
          end
      else
          mod.ui.insertBefore(result, optionAnchor, {
              label = Strings("NUZ STAT"),
              desc = { Strings("Nuzlocke"), Strings("run status") },
              onSelect = function()
                  mod.ui.push(game, "NuzlockeGoldStatusScreen")
              end
          })
      end

      mod.ui.insertBefore(result, optionAnchor, {
          label = Strings("ENC TRACKER"),
          onSelect = function()
              mod.ui.push(game, "NuzlockeTrackerScreen")
          end
      })

      mod.ui.insertBefore(result, optionAnchor, {
          -- Short underlying label preserves the original start-menu width.
          label = Strings("NUZ RULES"),
          onSelect = function()
              mod.ui.push(game, "NuzlockeConfigScreen")
          end
      })

      return result
  end)

  ---------------------------------------------------------------------
  -- PARTY SUBMENU HOOK
  ---------------------------------------------------------------------
  mod.hooks:wrap("ui.party.submenu", function(next, game, items, mon, ctx)
      -- Compose from the predecessor result first. Other mods may filter,
      -- replace, or rebuild the party submenu; mutating the incoming `items`
      -- before next() can lose our row or accidentally reintroduce entries a
      -- downstream mod intentionally removed. This mirrors the start-menu
      -- composition rule used above and keeps wrapper order deterministic.
      local result = next(game, items, mon, ctx)
      if type(result) ~= "table" then result = items end
      if type(result) ~= "table" then return result end

      if mod.save:get("nuzlocke_enabled", true) and mod.save:get("catch_info", true) and mon then
          -- Avoid duplicate rows if another compatibility layer re-enters the
          -- hook or preserves a previously composed Nuzlocke row.
          for _, item in ipairs(result) do
              if type(item) == "table" and (item.nuzlockeCatchInfo == true
                  or item.id == "nuzlocke_catch_info") then
                  return result
              end
          end

          local cancelAnchor = "CANCEL"
          for _, item in ipairs(result) do
              if type(item) == "table" and (item.label == "CANCEL"
                  or item.label == Strings("CANCEL")
                  or item.id == "CANCEL" or item.id == "cancel"
                  or item.action == "cancel" or item.cancel == true) then
                  cancelAnchor = item.label or cancelAnchor
                  break
              end
          end
          mod.ui.insertBefore(result, cancelAnchor, {
              id = "nuzlocke_catch_info",
              nuzlockeCatchInfo = true,
              label = Strings("CATCH INFO"),
              onSelect = function()
                  mod.ui.push(
                      game,
                      "NuzlockeCatchInfoScreen",
                      { mon = mon }
                  )
              end
          })
      end

      return result
  end)

  ---------------------------------------------------------------------
  -- BATTLE CATCH ENFORCEMENT
  --
  -- The recomp's BagMenu calls BattleState:throwBall after consuming the
  -- selected ball. Bryan's original Nuzlocke implementation intercepts
  -- this exact method, refunds the ball, displays the rejection message,
  -- and returns before vanilla capture processing.
  --
  -- We use that same engine seam for the actual first-catch / No Dupes
  -- decision. The important difference from Bryan's strict mode is that
  -- duplicate encounters NEVER consume the area's encounter in this mod.
  -- Shinies always bypass No Dupes, and bypass 1st Catch when Shiny Clause
  -- is enabled.
  ---------------------------------------------------------------------
  mod.events:on("game.ready", function(game)
      local ok, BattleState = pcall(require, "src.battle.BattleState")
      local okBag, Bag = pcall(require, "src.inventory.Bag")
      if not ok or type(BattleState) ~= "table"
          or type(BattleState.throwBall) ~= "function"
          or not okBag or type(Bag) ~= "table"
          or type(Bag.add) ~= "function" then
          return
      end

      if BattleState.__nuzlockeFinal23Patched then
          return
      end
      BattleState.__nuzlockeFinal23Patched = true

      local vanillaThrowBall = BattleState.throwBall

      -- Current Gen1Recomp emits the public battle.ended event from finish().
      -- Older builds were less consistent, so keep a private fallback for our
      -- own bookkeeping only. Never synthesize a second public engine event:
      -- unrelated mods may treat battle.ended as a transactional boundary.
      if type(BattleState.finish) == "function"
          and not BattleState.__nuzlockeCatchFinishPatched then
          BattleState.__nuzlockeCatchFinishPatched = true
          local vanillaCatchFinish = BattleState.finish
          BattleState.finish = function(self, ...)
              local result = vanillaCatchFinish(self, ...)
              if type(finalizeNuzlockeBattle) == "function" then
                  pcall(finalizeNuzlockeBattle, self, self and self.result)
              end
              return result
          end
      end

      -- The public battle.nickname hook is not present in every recomp build.
      -- Patch the engine's actual nickname-screen seam as well, so enabling
      -- Nicknames cannot silently fall through to the normal auto-skip path.
      if not BattleState.__nuzlockeNicknameScreenPatched then
          BattleState.__nuzlockeNicknameScreenPatched = true
          local vanillaAskNicknameUI = BattleState.askNicknameUI
          local okStrings, Strings = pcall(require, "src.core.Strings")

          if type(vanillaAskNicknameUI) == "function" then
              BattleState.askNicknameUI = function(self, mon, displayName)
                  if active(self and self.game, self)
                      and mod.save:get("nickname_rule", false)
                      and okStrings and Strings then
                      self.lockedBall, self.blankForAskName = nil, false

                      local namingOpts
                      namingOpts = {
                          title = Strings("NICKNAME?"),
                          maxLen = 10,
                          onDone = function(name)
                              name = tostring(name or "")
                              if name ~= "" then
                                  mon.nickname = name
                                  mon.nuzlockeNeedsNickname = nil
                                  mon.nuzlockeNicknameRequired = nil
                                  return
                              end

                              -- NamingScreen intentionally permits an empty
                              -- confirm for vanilla's "decline nickname" flow.
                              -- Under Nickname Rule, immediately reopen it.
                              local okScreens, Screens =
                                  pcall(require, "src.ui.Screens")
                              if okScreens and Screens
                                  and type(Screens.push) == "function" then
                                  pcall(Screens.push, self.game,
                                      "NamingScreen", namingOpts)
                              end
                          end,
                      }
                      return self:buildScreen("NamingScreen", namingOpts)
                  end
                  return vanillaAskNicknameUI(self, mon, displayName)
              end
          end
      end

      -- BattleState's message queue does not soft-wrap mod-authored text on
      -- every supported recomp build. Keep Nuzlocke battle messages inside the
      -- native 18-column window and use CONT markers after the first two lines
      -- so longer messages wait for A/B instead of scrolling past automatically.
      mod.exports.__beta26.formatBattleText = function(text)
          local lines = wrapText(mod.exports.__beta26.cleanWorldText(text), 18)
          if #lines == 0 then return "" end
          if #lines == 1 then return lines[1] end
          local out = lines[1] .. "\n" .. lines[2]
          for i = 3, #lines do
              out = out .. "\v" .. lines[i]
          end
          return out
      end

      BattleState.throwBall = function(self, ball)
          local gameRef = self and self.game

          -- BagMenu has already consumed the selected Ball at this seam. Check
          -- the use-only Ball rule before Soft Start can arm, and refund on denial.
          local useAllowed, useDecision = true, nil
          if type(evaluateItemUsePolicy) == "function" then
              local okUse, allowed, decision = pcall(evaluateItemUsePolicy,
                  gameRef, gameRef and gameRef.data, gameRef and gameRef.save,
                  ball, nil, { battle = self, inBattle = true, isBall = true })
              if okUse and allowed == false then
                  useAllowed, useDecision = false, decision
              end
          end
          if not useAllowed then
              pcall(function()
                  Bag.add(gameRef.save, ball, 1, gameRef.data)
              end)
              local message = useDecision and useDecision.message
                  or Strings("That Ball is banned!")
              local tier = worldTier(gameRef)
              if tier >= 3 and useDecision and useDecision.tier3 then
                  message = useDecision.tier3
              elseif tier >= 2 and useDecision and useDecision.tier2 then
                  message = useDecision.tier2
              end
              if type(self.say) == "function" then
                  self:say(mod.exports.__beta26.formatBattleText(message))
              elseif type(self.sayNext) == "function" then
                  self:sayNext(mod.exports.__beta26.formatBattleText(message))
              end
              return
          end

          -- Possessing/using the first usable Ball permanently arms encounter
          -- bookkeeping for this run. The flag never disarms at zero Balls.
          if gameRef and mod.exports.__beta26.armEncounterRulesNow then
              mod.exports.__beta26.armEncounterRulesNow(gameRef)
          end
          local species = self and self.enemy and self.enemy.mon
              and self.enemy.mon.species

          local reason
          local reasonOk, reasonValue = pcall(function()
              return catchDeniedReason(gameRef, self, species)
          end)
          if reasonOk then
              reason = reasonValue
          end

          if reason then
              -- BagMenu has already removed the ball. Use Bryan's exact
              -- refund mechanism and original messages.
              pcall(function()
                  Bag.add(gameRef.save, ball, 1, gameRef.data)
              end)

              local message
              if reason == "area" then
                  message = worldTier(gameRef) >= 2
                      and Strings("Encounter used!\nTry another route.")
                      or Strings("Encounter used!")
              elseif reason == "dupes" then
                  message = worldTier(gameRef) >= 2
                      and Strings("Seriously? Another one?\nDupes Clause says NO.")
                      or Strings("You already have\nthis POKéMON family!")
              elseif reason == "overworld" then
                  message = worldTier(gameRef) >= 2
                      and Strings("That's not a wild encounter.\nThe Nuzlocke doesn't count it.")
                      or Strings("Overworld catches\nare turned OFF.")
              elseif reason == "town" then
                  message = worldTier(gameRef) >= 2
                      and Strings("This isn't a route.\nThe Nuzlocke doesn't count town catches.")
                      or Strings("Town catches\nare turned OFF.")
              elseif reason == "legendary" then
                  message = worldTier(gameRef) >= 2
                      and Strings("A LEGENDARY?\nIn a Nuzlocke? Absolutely not.")
                      or Strings("Legendary catches\nare turned OFF.")
              elseif reason == "mythical" then
                  message = worldTier(gameRef) >= 2
                      and Strings("Nice try, Team Rocket.\nMYTHICALS are off limits.")
                      or Strings("Mythical catches\nare turned OFF.")
              elseif reason == "pseudo" then
                  message = worldTier(gameRef) >= 2
                      and Strings("Pseudo-legendary?\nNot on this run.")
                      or Strings("Pseudo catches\nare turned OFF.")
              elseif reason == "static" then
                  message = worldTier(gameRef) >= 2
                      and Strings("Fixed encounter.\nNo Static says battle, not capture.")
                      or Strings("Static catches\nare turned OFF.")
              elseif reason == "bst" then
                  local bst = mod.exports.__beta26.getSpeciesBST(gameRef, species)
                  local limit = mod.exports.__beta26.getMaximumBST()
                  message = Strings("BST %s exceeds your maximum of %d.",
                      tostring(bst or "?"), limit)
              elseif reason == "glitch" then
                  message = Strings("GLITCH Pokemon are blocked by your rules.")
              elseif reason == "solo" then
                  message = worldTier(gameRef) >= 2
                      and Strings("One hero. No backup.\nSolo Only says that's enough.")
                      or Strings("Solo Only: only\none Pokemon allowed!")
              end

              -- Use the same message entry point as Bryan's implementation.
              -- If a stripped/older build does not expose say(), fall back
              -- to the queue-based API rather than touching phase/queue state.
              if message then
                  if type(self.say) == "function" then
                      self:say(mod.exports.__beta26.formatBattleText(message))
                  elseif type(self.sayNext) == "function" then
                      self:sayNext(mod.exports.__beta26.formatBattleText(message))
                  end
              end

              return
          end

          return vanillaThrowBall(self, ball)
      end
  end)

  ---------------------------------------------------------------------
  -- NICKNAME ENFORCEMENT
  --
  -- hooks:wrap("battle.nickname") fires after a successful catch,
  -- before the nickname prompt. Returning true forces the prompt to
  -- appear even when the player has auto-skip turned on. Returning
  -- false skips it. We always return true when the Nicknames rule is
  -- enabled so the player cannot avoid naming their catch.
  ---------------------------------------------------------------------
  mod.hooks:wrap("battle.nickname", function(next, battle, mon)
      if active(battle and battle.game, battle)
          and not mod.exports.__beta26.runtimeIsGold(battle and battle.game)
          and mod.save:get("nickname_rule", false) then
          -- Force the naming screen open regardless of options.
          return true
      end
      return next(battle, mon)
  end)

  -- Fallback for engine builds where battle.nickname is only a notification
  -- hook. If a caught Pokemon reaches the tracker without a custom nickname,
  -- mark it for the engine's nickname flow rather than silently accepting the
  -- species name. This does not invent a nickname; the player must supply it.
  mod.events:on("pokemon.caught", function(ev)
      if not (ev and ev.mon and ev.game) then return end
      if not active(ev.game, ev.battle) then return end
      if mod.exports.__beta26.runtimeIsGold(ev.game) then return end
      if not mod.save:get("nickname_rule", false) then return end
      local mon = ev.mon
      if mon.nickname == nil or mon.nickname == "" or mon.nickname == mon.species then
          mon.nuzlockeNeedsNickname = true
          mon.nuzlockeNicknameRequired = true
          -- The mandatory NamingScreen is the feedback for this rule. Do not
          -- stack another World Building box on the catch message or naming
          -- flow from this post-catch compatibility listener.
      end
  end)

  ---------------------------------------------------------------------
  -- ITEM USE ENFORCEMENT / SHARED POLICY
  --
  -- One pure legality decision feeds our engine gate and cooperative mods that
  -- want to ask BEFORE mutating inventory. Presentation stays outside policy.
  ---------------------------------------------------------------------
  local ItemPolicy = {
      fieldHealing = {
          POTION = true, SUPER_POTION = true, HYPER_POTION = true,
          MAX_POTION = true, FULL_RESTORE = true,
          REVIVE = true, MAX_REVIVE = true,
          ANTIDOTE = true, BURN_HEAL = true, ICE_HEAL = true,
          AWAKENING = true, PARLYZ_HEAL = true, PARALYZE_HEAL = true,
          FULL_HEAL = true,
          FRESH_WATER = true, SODA_POP = true, LEMONADE = true,
          MOOMOO_MILK = true,
          -- Gold's medicine, herb, and held-Berry healing families.
          ENERGYPOWDER = true, ENERGY_ROOT = true, HEAL_POWDER = true,
          REVIVAL_HERB = true,
          BERRY = true, GOLD_BERRY = true,
          BITTER_BERRY = true, MINT_BERRY = true,
          PRZCUREBERRY = true, PSNCUREBERRY = true,
          ICE_BERRY = true, BURNT_BERRY = true, MIRACLEBERRY = true,
      },
      ppRecovery = {
          ETHER = true, MAX_ETHER = true,
          ELIXER = true, MAX_ELIXER = true,
          -- Gen 1 uses PP_UP. PP_MAX is accepted for merged/later data.
          PP_UP = true, PP_MAX = true,
          -- Compatibility spellings retained for merged item datasets.
          ELIXIR = true, MAX_ELIXIR = true,
          -- Gold restores PP with MysteryBerry through the same party-target
          -- item path as Ether-family items.
          MYSTERYBERRY = true, MYSTERY_BERRY = true,
      },
      xBattle = {
          X_ATTACK = true, X_DEFEND = true, X_SPEED = true,
          X_SPECIAL = true, X_ACCURACY = true,
          DIRE_HIT = true, GUARD_SPEC = true,
      },
      repels = { REPEL = true, SUPER_REPEL = true, MAX_REPEL = true },
      vanillaBalls = {
          POKE_BALL = true, GREAT_BALL = true, ULTRA_BALL = true,
          MASTER_BALL = true, SAFARI_BALL = true,
      },
      standardBallTiers = {
          POKE_BALL = 1,
          GREAT_BALL = 2,
          ULTRA_BALL = 3,
          MASTER_BALL = 4,
      },
  }

  function ItemPolicy.normalize(item)
      local value = type(item) == "table"
          and (item.id or item.key or item.value or item.name)
          or item
      value = tostring(value or ""):upper()
      return value:gsub("[%s%-]+", "_")
  end

  -- A few UI/data paths may hand the item policy a display-facing name rather
  -- than the canonical data key.  For the two runtime-failing rule families,
  -- accept either representation without changing the already-confirmed PP or
  -- healing-item classification paths.
  function ItemPolicy.matchesSet(data, itemId, set)
      local id = ItemPolicy.normalize(itemId)
      if set[id] then return true end
      local record = ItemPolicy.record(data, itemId)
      if type(record) == "table" then
          local byName = ItemPolicy.normalize(record.name)
          if set[byName] then return true end
      end
      return false
  end

  function ItemPolicy.record(data, itemId)
      if type(itemId) == "table"
          and (itemId.ball ~= nil or itemId.machine ~= nil or itemId.effect ~= nil) then
          return itemId
      end
      local items = data and data.items
      if type(items) ~= "table" then return nil end
      local id = ItemPolicy.normalize(itemId)
      return items[id] or items[itemId]
  end

  function ItemPolicy.isBall(data, itemId, itemEffects)
      local id = ItemPolicy.normalize(itemId)
      if ItemPolicy.vanillaBalls[id] then return true end
      local record = ItemPolicy.record(data, itemId)
      if type(record) == "table" then
          if record.ball ~= nil and record.ball ~= false then return true end
          if ItemPolicy.normalize(record.pocket) == "BALL" then return true end
      end
      local balls = itemEffects and itemEffects.BALLS
      return type(balls) == "table" and balls[id] ~= nil and balls[id] ~= false
  end

  function ItemPolicy.ballBanTier()
      return math.max(0, math.min(5, math.floor(tonumber(
          mod.save:get("ball_use_ban_tier", 0)) or 0)))
  end

  function ItemPolicy.ballRank(data, itemId)
      local id = ItemPolicy.normalize(itemId)
      local rank = ItemPolicy.standardBallTiers[id]
      if rank then return rank end
      local record = ItemPolicy.record(data, itemId)
      if type(record) == "table" then
          return ItemPolicy.standardBallTiers[ItemPolicy.normalize(record.name)]
      end
      return nil
  end

  function ItemPolicy.ballUseBlocked(data, itemId, itemEffects, forceIsBall)
      local tier = ItemPolicy.ballBanTier()
      if tier <= 0 then return false end
      if forceIsBall ~= true and not ItemPolicy.isBall(data, itemId, itemEffects) then
          return false
      end
      if tier >= 5 then return true end
      local rank = ItemPolicy.ballRank(data, itemId)
      return rank ~= nil and rank <= tier
  end

  function ItemPolicy.isTM(data, itemId)
      local record = ItemPolicy.record(data, itemId)
      if type(record) == "table" and record.machine ~= nil then
          local machine = record.machine
          local kind
          if type(machine) == "table" then
              kind = ItemPolicy.normalize(machine.kind or machine.type)
          else
              kind = ItemPolicy.normalize(machine)
          end
          if kind == "HM" then return false end
          if kind == "TM" then return true end
      end
      local id = ItemPolicy.normalize(itemId)
      if id:match("^HM_?%d+") then return false end
      if id:match("^TM_?%d+") then return true end
      if type(record) == "table" then
          local name = ItemPolicy.normalize(record.name)
          if name:match("^HM_?%d+") then return false end
          if name:match("^TM_?%d+") then return true end
      end
      return false
  end

  function ItemPolicy.denied(code, key, plain, tier2, tier3, extra)
      local decision = {
          code = code, key = key, message = plain,
          tier2 = tier2 or plain, tier3 = tier3 or tier2 or plain,
      }
      if type(extra) == "table" then
          for k, v in pairs(extra) do decision[k] = v end
      end
      return false, decision
  end

  evaluateItemUsePolicy = function(game, data, save, itemId, target, context)
      context = type(context) == "table" and context or {}
      local battle = context.battle
      local inBattle = context.inBattle
      if inBattle == nil then inBattle = battle ~= nil end

      -- v0.1.79 can reach ItemEffects.use with a valid save/data pair while a
      -- convenient Game reference is absent. Legality is save-owned; presentation
      -- is the only part that needs a Game/stack. Resolve every known context but
      -- never silently allow a restricted item merely because `game` is nil.
      game = game or (battle and battle.game)
          or (context.overworld and context.overworld.game)
          or currentGame or mod.game
      save = save or (game and game.save) or currentSave
      data = data or (game and game.data)
          or (currentGame and currentGame.data)

      if mod.save:get("nuzlocke_enabled", true) == false or not save then
          return true
      end
      if battle and (battle.demo or battle.ghost) then return true end

      local id = ItemPolicy.normalize(itemId)
      if id == "" then return true end

      -- These rules prohibit USE only. Inventory acquisition, PC storage,
      -- tossing, buying, and selling remain owned by their normal/other rule paths.
      if mod.save:get("no_rare_candy_use", false) == true and id == "RARE_CANDY" then
          return ItemPolicy.denied(
              "no_rare_candy_use", "rare_candy_use",
              "RARE CANDY use is banned!",
              "Keep the candy. You just can't use it on this run.",
              "The candy can stay in your bag. Your challenge says nobody gets to eat it.")
      end

      if mod.save:get("no_player_stat_exp_gain", false) == true then
          local statVitamins = {
              HP_UP = true, PROTEIN = true, IRON = true, CARBOS = true,
              CALCIUM = true,
          }
          if statVitamins[id] then
              return ItemPolicy.denied(
                  "no_player_stat_exp_gain", "stat_exp_gain",
                  "Stat EXP gain is banned!",
                  "That vitamin would add Stat EXP, so it stays unused.",
                  "Your challenge freezes Stat EXP. Save the vitamin for another run.")
          end
      end

      if mod.save:get("no_tm_use", false) == true and ItemPolicy.isTM(data, itemId) then
          return ItemPolicy.denied(
              "no_tm_use", "tm_use",
              "TM use is banned!",
              "You may keep the TM, but you can't teach from it.",
              "Technical Machines are souvenirs on this run. HMs still handle the required field work.")
      end

      if ItemPolicy.ballUseBlocked(data, itemId, context.itemEffects,
          context.isBall == true) then
          local tier = ItemPolicy.ballBanTier()
          local scope = mod.exports.__beta26.ballBanTierLabels[tier]
              or "selected"
          local tier2, tier3
          if tier >= 5 then
              tier2 = "Every recognized Ball is banned by this rule."
              tier3 = "Your challenge has banned every Ball from being thrown."
          elseif tier == 4 then
              tier2 = "Standard Balls are banned. Specialty/custom Balls remain eligible."
              tier3 = "Poke, Great, Ultra, and Master Balls are banned. Specialty/custom Balls remain eligible."
          else
              tier2 = Strings("Ball ban through %s. Try a stronger standard Ball.",
                  Strings(scope))
              tier3 = Strings("That Ball falls inside your %s-and-weaker standard Ball ban.",
                  Strings(scope))
          end
          return ItemPolicy.denied(
              "ball_use_ban", "ball_use_ban",
              "That Ball is banned!",
              tier2, tier3,
              { tier = tier })
      end

      -- A level cap constrains level advancement, not only EXP gain.
      if id == "RARE_CANDY" and levelCapScope() > 0 and type(target) == "table" then
          local cap = nextLevelCap(save)
          local level = tonumber(target.level) or 0
          if cap < 100 and level >= cap then
              return ItemPolicy.denied(
                  "level_cap", "rare_candy_cap",
                  "The level cap blocks\nthat RARE CANDY!",
                  "Nice try. Rare Candy\ncan't break the level cap.",
                  "The League noticed that candy-shaped loophole.\nLevel cap says no.",
                  { cap = cap, level = level })
          end
      end

      if mod.save:get("no_pp_items", false) == true and ItemPolicy.matchesSet(data, itemId, ItemPolicy.ppRecovery) then
          return ItemPolicy.denied(
              "no_pp_items", "pp_items",
              "PP items are banned!",
              "No PP recovery or boosting items on this run.",
              "The Nuzlocke says your moves earn their PP the hard way.")
      end

      if not inBattle then
          if mod.save:get("no_repels", false) == true and ItemPolicy.matchesSet(data, itemId, ItemPolicy.repels) then
              return ItemPolicy.denied(
                  "no_repels", "field_repels", "Repels are banned!",
                  "No Repels. Kanto wants you to meet the locals.",
                  "The wild Pokemon have vetoed your Repel privileges.")
          end
          if mod.save:get("no_escape_rope", false) == true and id == "ESCAPE_ROPE" then
              return ItemPolicy.denied(
                  "no_escape_rope", "field_escape_rope", "Escape Rope is banned!",
                  "No shortcut out. Walk it back.",
                  "The cave has decided you are finishing this trip on foot.")
          end
          if mod.save:get("no_field_healing", false) == true
              and ItemPolicy.matchesSet(data, itemId, ItemPolicy.fieldHealing) then
              return ItemPolicy.denied(
                  "no_field_healing", "field_healing", "Field healing is banned!",
                  "Medicine waits until your rules allow it.",
                  "No roadside medicine. Your team keeps the damage it earned.")
          end
          return true
      end

      -- Catch legality is separate. Dynamic ball detection prevents custom balls
      -- from being caught by the legacy combined No Items compatibility rule.
      if ItemPolicy.isBall(data, itemId, context.itemEffects) then return true end

      if mod.save:get("no_healing_items", false) == true
          and ItemPolicy.matchesSet(data, itemId, ItemPolicy.fieldHealing) then
          return ItemPolicy.denied(
              "no_healing_items", "battle_heal_items",
              "Healing items are\nbanned in battle!",
              "Nice try.\nYour Nuzlocke says no healing in battle.",
              "The League has seen enough potion nonsense.\nPut the medicine away.")
      end
      if mod.save:get("no_battle_items", false) == true and ItemPolicy.matchesSet(data, itemId, ItemPolicy.xBattle) then
          return ItemPolicy.denied(
              "no_battle_items", "battle_x_items",
              "Battle items are\nbanned!", "No X-Item cheese!",
              "The League has banned the ancient art of X-Item nonsense.")
      end
      if mod.save:get("no_items", false) == true then
          return ItemPolicy.denied(
              "no_items", "battle_items", "Items are banned\nduring battle!")
      end
      return true
  end

  function ItemPolicy.present(game, decision)
      if type(decision) ~= "table" then return "failed", { "Item use is blocked!" } end
      game = game or currentGame or mod.game
      local tier = worldTier(game)
      local message = decision.message or "Item use is blocked!"
      if tier >= 3 then
          message = decision.tier3 or decision.tier2 or message
      elseif tier >= 2 then
          message = decision.tier2 or message
      end
      -- ItemEffects.use owns the native result-message path. Returning one
      -- tier-selected line avoids a second Nuzlocke TextBox over that result.
      return "failed", { mod.exports.__beta26.cleanWorldText(message) }
  end

  if mod.exports.nuzlocke_compat then
      mod.exports.nuzlocke_compat.canUseItem = function(game, itemId, context)
          context = type(context) == "table" and context or {}
          local allowed, decision = evaluateItemUsePolicy(
              game, context.data or (game and game.data),
              context.save or (game and game.save), itemId, context.target, context)
          return allowed, decision and decision.code or nil, decision
      end
      mod.exports.nuzlocke_compat.canPurchase = function(game, context)
          context = type(context) == "table" and context or {}
          if mod.save:get("nuzlocke_enabled", true) == false
              or not (game and game.save) then return true end
          local kind = tostring(context.kind or ""):lower()
          if (kind == "item_shop" or kind == "shop_item")
              and mod.save:get("no_buying", false) == true then
              return false, "no_buying"
          end
          return true
      end
      mod.exports.nuzlocke_compat.canSell = function(game, context)
          context = type(context) == "table" and context or {}
          if mod.save:get("nuzlocke_enabled", true) == false
              or not (game and game.save) then return true end
          local kind = tostring(context.kind or ""):lower()
          if (kind == "item_shop" or kind == "shop_item")
              and mod.save:get("no_selling", false) == true then
              return false, "no_selling"
          end
          return true
      end
  end

  function ItemPolicy.install()
      local engineState = mod.exports.__beta26.compat
          and mod.exports.__beta26.compat.Engine
          and mod.exports.__beta26.compat.Engine.state
      if mod.exports.__beta26.isSaveEditorSession() then
          if type(engineState) == "table" then
              engineState.item_use = { ok = true, environment = "save_editor", runtime_patch = "skipped" }
          end
          return true
      end
      local ok, ItemEffects = pcall(require, "src.inventory.ItemEffects")
      if not ok or type(ItemEffects) ~= "table" or type(ItemEffects.use) ~= "function" then
          if type(engineState) == "table" then
              engineState.item_use = { ok = false, reason = "ItemEffects.use unavailable" }
          end
          return false
      end

      -- Identity validation matters more than an owner string. If another mod
      -- legitimately wraps/replaces ItemEffects.use after us, a later safe
      -- lifecycle boundary composes around the *current* live function instead
      -- of assuming our old closure is still active. No per-frame rebinding.
      if ItemEffects.__nuzlockeItemRuleGateOwner == mod
          and ItemEffects.use == ItemEffects.__nuzlockeItemRuleGateFunction then
          if type(engineState) == "table" then
              engineState.item_use = { ok = true, owner = "current_session", relationship = "compose" }
          end
          return true
      end

      if ItemEffects.__nuzlockeItemRuleGateOwner ~= nil
          and ItemEffects.__nuzlockeItemRuleGateOwner ~= mod
          and ItemEffects.use == ItemEffects.__nuzlockeItemRuleGateFunction
          and type(ItemEffects.__nuzlockeItemRuleGatePrevious) == "function" then
          ItemEffects.use = ItemEffects.__nuzlockeItemRuleGatePrevious
      end

      local previousUse = ItemEffects.use
      local gate
      gate = function(data, save, itemId, target, battle, moveIndex, ow)
          local game = (battle and battle.game) or (ow and ow.game)
              or currentGame or mod.game
          local allowed, decision = evaluateItemUsePolicy(
              game, data, save, itemId, target,
              { battle = battle, inBattle = battle ~= nil, overworld = ow,
                moveIndex = moveIndex, itemEffects = ItemEffects })
          if not allowed then return ItemPolicy.present(game, decision) end
          return previousUse(data, save, itemId, target, battle, moveIndex, ow)
      end
      ItemEffects.use = gate
      ItemEffects.__nuzlockeItemRuleGateInstalled = true
      ItemEffects.__nuzlockeItemRuleGateOwner = mod
      ItemEffects.__nuzlockeItemRuleGateFunction = gate
      ItemEffects.__nuzlockeItemRuleGatePrevious = previousUse
      if type(engineState) == "table" then
          engineState.item_use = { ok = true, owner = "current_session", relationship = "compose" }
      end
      return true
  end

  pcall(ItemPolicy.install)
  -- Re-check only at coarse lifecycle boundaries. This repairs a live function
  -- replaced during startup/mod composition without introducing battle-frame work.
  mod.events:on("game.ready", function() pcall(ItemPolicy.install) end)
  mod.events:on("save.loaded", function() pcall(ItemPolicy.install) end)
  mod.events:on("mods.loaded", function() pcall(ItemPolicy.install) end)
  mod.events:on("map.entered", function() pcall(ItemPolicy.install) end)
  mod.events:on("battle.started", function() pcall(ItemPolicy.install) end)

  ---------------------------------------------------------------------
  -- BATTLE ITEM FALLBACK HOOK
  ---------------------------------------------------------------------
  mod.hooks:wrap("battle.use_item", function(next, battle, item)
      local game = battle and battle.game or currentGame
      if not active(game, battle) then return next(battle, item) end
      local okEffects, ItemEffects = pcall(require, "src.inventory.ItemEffects")
      local allowed, decision = evaluateItemUsePolicy(
          game, game and game.data, game and game.save, item,
          type(item) == "table" and item.target or nil,
          { battle = battle, inBattle = true,
            itemEffects = okEffects and ItemEffects or nil })
      if not allowed then
          local _, messages = ItemPolicy.present(game, decision)
          return false, messages and messages[1] or "Item use is blocked!"
      end
      return next(battle, item)
  end)

  ---------------------------------------------------------------------
  -- NO ESCAPE
  --
  -- BattleState exposes the Gen 1 escape calculation through the public
  -- battle.run hook. Returning false from this hook makes both the RUN
  -- command and the faint-screen "Use next POKeMON? -> NO" escape attempt
  -- fail normally, which means the player gets the vanilla "Can't escape!"
  -- result and the turn is consumed. Trainer battles never reach this hook
  -- because the engine rejects RUN before attempting the escape roll.
  ---------------------------------------------------------------------
  mod.hooks:wrap("battle.run", function(next, ctx)
      local battle = ctx and ctx.battle
      if active(battle and battle.game, battle)
          and mod.save:get("no_escape", false) == true then
          local provider = activeCompatProvider("escape", battle and battle.game or currentGame, battle)
          local relationship = provider and
              mod.exports.__beta26.compat.Mods.relationshipFor(provider.id, "escape")
          if provider and (relationship == "delegate" or relationship == "exclusive") then
              return next(ctx)
          end
          -- Returning false already produces the engine's native
          -- "Can't escape!" result and consumes the turn. Do not stack a
          -- second World Building TextBox into the battle flow.
          return false
      end
      return next(ctx)
  end)

  ---------------------------------------------------------------------
  -- MAP ENTRY
  --
  -- map.entered gives the actual engine map ID.
  -- via="boot" is important: an old save loaded in Pallet Town is
  -- immediately recorded without requiring the player to walk.
  ---------------------------------------------------------------------
  mod.events:on("map.entered", function(ev)
      if not ev or not ev.mapId then
          return
      end

      local map = ev.map
      local x, y = mod.exports.__beta26.encounterPosition(currentGame)
      local physical = mod.exports.__beta26.cardinalPhysicalArea(ev.mapId, x, y,
          map and map.widthCells, map and map.heightCells)
      local key = registerArea(mod.exports.__beta26.projectEncounterArea(physical))

      if not isTrackedArea(key) then
          return
      end

      markVisited(physical)
  end)

  ---------------------------------------------------------------------
  -- WORLD STEP
  -- Keep the tracker synchronized with the actual map the player is on.
  -- This is intentionally redundant with map.entered: world.stepped is a
  -- cheap, reliable fallback for connections/transitions and old saves.
  ---------------------------------------------------------------------
  mod.events:on("world.stepped", function(ev)
      if not ev or not ev.mapId then
          return
      end

      local map = currentGame and currentGame.overworld
          and currentGame.overworld.map
      local physical = mod.exports.__beta26.cardinalPhysicalArea(
          ev.mapId, ev.x, ev.y,
          map and map.widthCells, map and map.heightCells)
      local key = registerArea(mod.exports.__beta26.projectEncounterArea(physical))
      if key then
          markVisited(physical)
      end
  end)

  ---------------------------------------------------------------------
  -- OVERWORLD ENCOUNTER DETECTION
  --
  -- Different overworld-spawn mods may annotate the catch event/battle in
  -- different ways. Accept the common explicit flags first, then treat a
  -- catch with no battle object as an overworld capture. Normal wild battles
  -- remain eligible regardless of this setting.
  ---------------------------------------------------------------------
  local function isOverworldEncounter(ev)
      if not ev then
          return false
      end

      if ev.overworldEncounter == true
          or ev.overworld == true
          or ev.isOverworld == true
          or ev.encounterType == "overworld"
          or ev.source == "overworld" then
          return true
      end

      local battle = ev.battle
      if battle then
          if battle.overworldEncounter == true
              or battle.overworld == true
              or battle.isOverworld == true
              or battle.encounterType == "overworld"
              or battle.source == "overworld" then
              return true
          end
      else
          -- A capture event without a battle is treated as an overworld
          -- capture. This is useful for mods that spawn/capture Pokemon
          -- directly without constructing the vanilla wild-battle state.
          return true
      end

      return false
  end

  ---------------------------------------------------------------------
  -- VERSION DETECTION
  --
  -- Detects RBY and GSC-family version ids exposed by the live engine.
  -- Falls back to RED only when the engine exposes no recognizable version.
  ---------------------------------------------------------------------
  getGameVersion = function()
      local candidates = {}
      local ok, GameVersion = pcall(require, "src.core.GameVersion")
      if ok and GameVersion then
          if type(GameVersion.get) == "function" then
              local okGet, detected = pcall(GameVersion.get)
              if okGet then candidates[#candidates+1] = detected end
          end
          candidates[#candidates+1] = GameVersion.version
      end
      if currentGame then
          candidates[#candidates+1] = currentGame.version
          candidates[#candidates+1] = currentGame.gameVersion
          candidates[#candidates+1] = currentGame.data and currentGame.data.version
          candidates[#candidates+1] = currentGame.data and currentGame.data.gameVersion
      end
      for _, v in ipairs(candidates) do
          local upper = tostring(v or ""):upper()
          if upper:find("CRYSTAL",1,true) or upper:find("CRY",1,true) then return "CRYSTAL" end
          if upper:find("SILVER",1,true) or upper:find("SLV",1,true) then return "SILVER" end
          if upper:find("GOLD",1,true) or upper == "G" then return "GOLD" end
          if upper:find("YELLOW",1,true) or upper:find("YLW",1,true) then return "YELLOW" end
          if upper:find("BLUE",1,true) or upper:find("BLU",1,true) then return "BLUE" end
          if upper:find("RED",1,true) then return "RED" end
      end
      return "RED"
  end

  local function getGameProfile()
      local version = getGameVersion()
      return VersionCompat.profiles[version] or {family="UNKNOWN",region="UNKNOWN",status="unknown"}
  end

  ---------------------------------------------------------------------
  -- GOLD PRE-NEW-GAME SETUP
  --
  -- Gold Setup is handled at the title menu above through the native
  -- {label,value} row shape and MainMenu:choose() dispatch. Previous
  -- post-NEW-GAME intro insertion experiments are intentionally removed.
  ---------------------------------------------------------------------


  ---------------------------------------------------------------------
  -- GIFT POKEMON TABLE  (version-tagged)
  -- area = where the gift is received; takes up that slot.
  -- version: nil=all, "RB"=Red/Blue only, "YLW"=Yellow only
  ---------------------------------------------------------------------
  local GIFT_LOCATIONS = {
      { species = "MAGIKARP",   area = "ROUTE_4",         version = nil   },
      { species = "HITMONCHAN", area = "SAFFRON_CITY",    version = nil   },
      { species = "HITMONLEE",  area = "SAFFRON_CITY",    version = nil   },
      { species = "LAPRAS",     area = "SILPH_CO",        version = nil   },
      { species = "EEVEE",      area = "CELADON_CITY",    version = "RB"  },
      { species = "OMANYTE",    area = "CINNABAR_ISLAND", version = nil   },
      { species = "KABUTO",     area = "CINNABAR_ISLAND", version = nil   },
      { species = "AERODACTYL", area = "CINNABAR_ISLAND", version = nil   },
      { species = "SCYTHER",    area = "CELADON_CITY",    version = nil   },
      { species = "PORYGON",    area = "CELADON_CITY",    version = nil   },
      { species = "DRATINI",    area = "CELADON_CITY",    version = nil   },
      { species = "PINSIR",     area = "CELADON_CITY",    version = nil   },
      { species = "BULBASAUR",  area = "CERULEAN_CITY",   version = "YLW" },
      { species = "CHARMANDER", area = "ROUTE_24",        version = "YLW" },
      { species = "SQUIRTLE",   area = "VERMILION_CITY",  version = "YLW" },
      { species = "JOLTEON",    area = "CELADON_CITY",    version = "YLW" },
      { species = "VAPOREON",   area = "CELADON_CITY",    version = "YLW" },
      { species = "FLAREON",    area = "CELADON_CITY",    version = "YLW" },
  }

  local function buildGiftLookup()
      local ver = getGameVersion()
      local lookup = {}
      for _, g in ipairs(GIFT_LOCATIONS) do
          if g.version == nil
              or (g.version == "RB"  and (ver == "RED" or ver == "BLUE"))
              or (g.version == "YLW" and ver == "YELLOW") then
              lookup[g.species] = g.area
          end
      end
      return lookup
  end

  ---------------------------------------------------------------------
  -- IN-GAME TRADE TABLE  (version-tagged)
  -- gives = species you receive; area = where the NPC lives.
  ---------------------------------------------------------------------
  local TRADE_DATA = {
      { gives = "JYNX",       wants = "POLIWHIRL", area = "CERULEAN_CITY",   version = "RB"  },
      { gives = "FARFETCHD",  wants = "SPEAROW",   area = "VERMILION_CITY",  version = "RB"  },
      { gives = "MR_MIME",    wants = "CLEFAIRY",  area = "ROUTE_2",         version = "RB"  },
      { gives = "LICKITUNG",  wants = "SLOWBRO",   area = "FUCHSIA_CITY",    version = "RB"  },
      { gives = "ELECTRODE",  wants = "RHYDON",    area = "CINNABAR_ISLAND", version = "RB"  },
      { gives = "GOLEM",      wants = "GRAVELER",  area = "CINNABAR_ISLAND", version = "RB"  },
      { gives = "KANGASKHAN", wants = "PARASECT",  area = "SAFARI_ZONE",     version = "RB"  },
      { gives = "JYNX",       wants = "POLIWHIRL", area = "CERULEAN_CITY",   version = "YLW" },
      { gives = "FARFETCHD",  wants = "SPEAROW",   area = "VERMILION_CITY",  version = "YLW" },
      { gives = "MR_MIME",    wants = "CLEFAIRY",  area = "ROUTE_2",         version = "YLW" },
      { gives = "GOLEM",      wants = "GRAVELER",  area = "CINNABAR_ISLAND", version = "YLW" },
      { gives = "MACHOKE",    wants = "CUBONE",    area = "ROUTE_5",         version = "YLW" },
  }

  local function buildTradeLookup()
      local ver = getGameVersion()
      local lookup = {}
      for _, t in ipairs(TRADE_DATA) do
          if t.version == nil
              or (t.version == "RB"  and (ver == "RED" or ver == "BLUE"))
              or (t.version == "YLW" and ver == "YELLOW") then
              lookup[t.gives] = t.area
          end
      end
      return lookup
  end


  -- Gifts and in-game trades are transactions, not battles. Any rule that
  -- rejects one must do so BEFORE the engine removes/gives Pokemon or sets the
  -- NPC's completed-trade/gift state. Post-acquisition deletion can permanently
  -- destroy the player's offered Pokemon or burn a one-time gift.
  local function specialAreaUnavailable(area)
      area = routeKey(area) or area
      if not area or area == "UNKNOWN" or area == "__LEGACY__" then
          return false
      end
      if mod.save:get("encounter_limit", false) ~= true then
          return false
      end
      if caughtAreas()[area] ~= nil then
          return true
      end
      local state = getEncounterState and getEncounterState(area) or nil
      return state ~= nil
          and (state.status == "FAILED" or state.status == "CAUGHT")
  end

  local function currentSpecialArea(game, species, kind)
      species = tostring(species or ""):upper()
      local lookup = kind == "trade" and buildTradeLookup() or buildGiftLookup()
      local known = lookup[species]
      if known then return routeKey(known) or known end
      local current = areaKey(game, nil)
      return routeKey(current) or current or "UNKNOWN"
  end

  local function partyHasUsableSlotForSolo(save)
      local count = 0
      for _, mon in ipairs(save and save.party or {}) do
          if type(mon) == "table" and mon.nuzlockeDead ~= true then
              count = count + 1
          end
      end
      return count < 1
  end

  local function specialAcquisitionDenied(game, species, area, kind)
      if not active(game, nil) then return nil end
      local glitch = mod.exports.__beta26.getGlitchSpeciesInfo(game, species)
      species = glitch.key

      if kind == "gift" and mod.save:get("allow_gifts", false) ~= true then
          return "disabled"
      end
      if kind == "trade" and mod.save:get("allow_trades", false) ~= true then
          return "disabled"
      end
      if glitch.isGlitch and not mod.exports.__beta26.glitchCatchesAllowed() then
          return "glitch"
      end

      if Identity.isLegendarySpecies(game, species)
          and mod.save:get("ban_legendaries", false) == true then
          return "legendary"
      end
      if Identity.isMythicalSpecies(game, species)
          and mod.save:get("ban_mythicals", false) == true then
          return "mythical"
      end
      if Identity.isPseudoSpecies(game, species)
          and mod.save:get("ban_pseudos", false) == true then
          return "pseudo"
      end
      local bstLimit = mod.exports.__beta26.getMaximumBST()
      local bst = bstLimit > 0
          and mod.exports.__beta26.getSpeciesBST(game, species) or nil
      if bst and bst > bstLimit then
          return "bst"
      end
      if specialAreaUnavailable(area) then
          return "area"
      end
      if kind == "gift" and mod.save:get("solo_active", false) == true
          and not partyHasUsableSlotForSolo(game and game.save) then
          return "solo"
      end
      return nil
  end

  ---------------------------------------------------------------------
  -- STARTER SPECIES LOOKUP  (version-aware)
  ---------------------------------------------------------------------
  local STARTERS_BY_VERSION = {
      RED    = { BULBASAUR = true, CHARMANDER = true, SQUIRTLE = true },
      BLUE   = { BULBASAUR = true, CHARMANDER = true, SQUIRTLE = true },
      YELLOW = { PIKACHU   = true },
  }

  local function isStarterSpecies(species)
      local ver = getGameVersion()
      local starters = STARTERS_BY_VERSION[ver] or STARTERS_BY_VERSION["RED"]
      return starters[tostring(species or ""):upper()] == true
  end

  ---------------------------------------------------------------------
  -- REGISTER STARTER IN PALLET TOWN
  -- Always records the starter in PALLET_TOWN regardless of the
  -- town_catches toggle. Pallet Town is the one mandatory town slot.
  ---------------------------------------------------------------------
  local function registerStarterCatch(species, mon)
      if not species then return end
      species = tostring(species):upper()
      local area = "PALLET_TOWN"
      registerArea(area)
      markVisited(area)

      local areas = caughtAreas()
      if areas[area] then
          -- A starter can emit both received and caught events. If the slot is
          -- already registered, tag this event's mon as handled so the later
          -- pokemon.caught event cannot create a second log entry.
          if mon then
              mon.catchLocation = area
              mon.encounterType = "gift"
              mon.nuzlockeTrackerRegistered = true
              Identity.setPokemonOrigin(mon, "NORMAL")
              Identity.baselineAdd(mon, "NORMAL")
          end
          return
      end

      local log = trackerLog()
      log[area] = log[area] or {}
      local monId = mon and Identity.ensurePokemonIdentity(mon, currentSave, "NORMAL") or nil
      table.insert(log[area], {
          species       = species,
          pokemonId     = monId,
          fingerprint   = mon and Identity.fingerprint(mon) or nil,
          isShiny       = mon and Identity.isShiny(mon),
          encounterType = "gift",
      })
      mod.save:set("tracker_log", log)
      markCaught(area, species)

      if mon then
          mon.catchLocation = area
          mon.encounterType = "gift"
          mon.nuzlockeDead  = false
          mon.nuzlockeTrackerRegistered = true
          Identity.setPokemonOrigin(mon, "NORMAL")
          Identity.baselineAdd(mon, "NORMAL")
      end

      local history = mod.save:get("nuzlocke_history", {})
      if type(history) ~= "table" then history = {} end
      table.insert(history, {
          name          = (mon and (mon.nickname or mon.species)) or species,
          species       = species,
          pokemonId     = monId,
          catchLocation = area,
          encounterType = "gift",
          status        = "ALIVE",
      })
      mod.save:set("nuzlocke_history", history)
  end

  ---------------------------------------------------------------------
  -- REGISTER GIFT / TRADE CATCH IN ITS PROPER AREA
  ---------------------------------------------------------------------
  local function registerSpecialCatch(species, area, encounterType, mon)
      if not species or not area then return false end
      local glitch = mod.exports.__beta26.getGlitchSpeciesInfo(currentGame, species)
      local rawSpecies = species
      species = glitch.key
      area = routeKey(area) or area
      registerArea(area)
      markVisited(area)

      local log = trackerLog()
      log[area] = log[area] or {}
      local monId = mon and Identity.ensurePokemonIdentity(mon, currentSave, "NORMAL") or nil

      -- A current/future engine path may report the same acquisition through
      -- both the script command wrapper and pokemon.received. Persistent ID is
      -- authoritative; fingerprint is the pre-ID compatibility fallback.
      for _, existing in ipairs(log[area]) do
          if type(existing) == "table" then
              if monId and existing.pokemonId
                  and tostring(existing.pokemonId) == tostring(monId) then
                  if mon then mon.nuzlockeTrackerRegistered = true end
                  return true
              end
              if not monId and mon and existing.fingerprint
                  and existing.fingerprint == Identity.fingerprint(mon) then
                  if mon then mon.nuzlockeTrackerRegistered = true end
                  return true
              end
          end
      end

      table.insert(log[area], {
          species       = species,
          rawSpecies    = glitch.isGlitch and rawSpecies or nil,
          glitch        = glitch.isGlitch or nil,
          missingNo     = glitch.missingNo or nil,
          pokemonId     = monId,
          fingerprint   = mon and Identity.fingerprint(mon) or nil,
          isShiny       = mon and Identity.isShiny(mon),
          encounterType = encounterType,
      })
      mod.save:set("tracker_log", log)
      markCaught(area, species)

      if mon then
          mon.catchLocation = area
          mon.encounterType = encounterType
          mon.nuzlockeDead  = false
          mon.nuzlockeTrackerRegistered = true
          mon.nuzlockeGlitch = glitch.isGlitch or nil
          mon.nuzlockeMissingNo = glitch.missingNo or nil
          mon.nuzlockeRawSpecies = glitch.isGlitch and rawSpecies or nil
          Identity.setPokemonOrigin(mon, "NORMAL")
          Identity.baselineAdd(mon, "NORMAL")
      end

      local history = mod.save:get("nuzlocke_history", {})
      if type(history) ~= "table" then history = {} end
      table.insert(history, {
          name          = (mon and mon.nickname) or glitch.label or species,
          species       = species,
          rawSpecies    = glitch.isGlitch and rawSpecies or nil,
          glitch        = glitch.isGlitch or nil,
          missingNo     = glitch.missingNo or nil,
          pokemonId     = monId,
          catchLocation = area,
          encounterType = encounterType,
          status        = "ALIVE",
      })
      mod.save:set("nuzlocke_history", history)
      return true
  end

  -- REVIEWED: acquisition registration intentionally stays at its proven
  -- transaction point. Mandatory naming may finish afterward, so synchronize
  -- only the matching history snapshot by persistent Pokemon identity rather
  -- than moving tracker/area registration across a naming-screen yield.
  mod.exports.__beta26.syncHistoryNickname = function(mon)
      if type(mon) ~= "table" then return false end
      local nickname = tostring(mon.nickname or "")
      if not nickname:find("%S") then return false end
      local monId = Identity.pokemonIdentity(mon)
          or Identity.ensurePokemonIdentity(mon, currentSave,
              mon.nuzlockeOrigin or "NORMAL")
      if monId == nil then return false end

      local history = mod.save:get("nuzlocke_history", {})
      if type(history) ~= "table" then return false end
      local changed = false
      for _, record in ipairs(history) do
          if type(record) == "table" and record.pokemonId ~= nil
              and tostring(record.pokemonId) == tostring(monId)
              and record.status == "ALIVE" and record.name ~= nickname then
              record.name = nickname
              changed = true
          end
      end
      if changed then mod.save:set("nuzlocke_history", history) end
      return changed
  end

  ---------------------------------------------------------------------
  -- POKEMON.RECEIVED  —  starters, gifts, trades
  --
  -- ev fields (varies by engine build):
  --   ev.mon / ev.species   — the Pokemon received
  --   ev.source             — "starter" | "gift" | "trade" | "fossil" | "prize"
  --   ev.location / ev.mapId / ev.area — where it was received
  --   ev.game               — game reference
  --
  -- Priority:
  --   1. Starter        → always PALLET_TOWN, bypasses town_catches.
  --   2. Gift (allowed) → area from GIFT_LOCATIONS or current map.
  --   3. Gift (blocked) → native transaction is rejected before mutation.
  --   4. Trade (allowed)→ area from TRADE_DATA or current map.
  --   5. Trade (blocked)→ native transaction is rejected before exchange.
  ---------------------------------------------------------------------
  local function isWonderTradeEvent(ev, source)
      if type(ev) ~= "table" then return false end
      if ev.wonderTrade == true or ev.isWonderTrade == true or ev.wonder_trade == true then return true end
      source = tostring(source or ""):lower():gsub("[%s%-]", "_")
      return source == "wonder_trade" or source == "wondertrade" or source == "wt"
  end

  -- Wonderlocke is intentionally dormant. Keep the public adapter so Wonder
  -- Trade mods can probe the compatibility surface safely, but never mutate a
  -- Pokemon or transaction until the feature is completed and re-enabled.
  if mod.exports.nuzlocke_compat then
      mod.exports.nuzlocke_compat.handleWonderTrade = function(game, mon, area, providerId)
          return false
      end
  end

  mod.events:on("pokemon.received", function(ev)
      if not ev then return end
      local game    = ev.game or currentGame
      local mon     = ev.mon
      local rawSpecies = ev.species or (mon and mon.species)
      if rawSpecies == nil or rawSpecies == "" then return end
      local glitch = mod.exports.__beta26.getGlitchSpeciesInfo(game, rawSpecies)
      local species = glitch.key

      -- Post-transaction events may be emitted by external mods. Preserve the
      -- received object and annotate it; native command wrappers perform any
      -- configured rejection before mutation.
      if mon and glitch.isGlitch then
          mon.nuzlockeGlitch = true
          mon.nuzlockeMissingNo = glitch.missingNo or nil
          mon.nuzlockeRawSpecies = rawSpecies
      end

      local source = tostring(ev.source or ""):lower()

      local rawLoc = ev.location or ev.mapId or ev.area
          or (game and game.overworld and game.overworld.map
              and game.overworld.map.id)
          or (game and game.save and game.save.player
              and game.save.player.map)
      local loc = routeKey(rawLoc) or "UNKNOWN"

      -- 1. Starter (explicit flag or species+location heuristic). Some
      -- current R/B/Y event paths report Oak's Lab rather than PALLET_TOWN,
      -- and may omit source="starter". Canonicalize those opening acquisitions
      -- immediately so they cannot create a second non-Pallet encounter row.
      local locText = tostring(loc or rawLoc or ""):upper()
      local starterOpeningLoc = loc == "PALLET_TOWN" or loc == "UNKNOWN"
          or locText:find("OAK", 1, true) ~= nil
          or locText:find("LAB", 1, true) ~= nil
      local isStarter = (source == "starter")
          or (isStarterSpecies(species) and starterOpeningLoc)
      -- Yellow: Pikachu is always the starter regardless of location tag
      local isYellowPikachu = (getGameVersion() == "YELLOW")
          and species == "PIKACHU"
          and (source == "starter" or loc == "PALLET_TOWN" or loc == "UNKNOWN")

      if isStarter or isYellowPikachu then
          -- Nuzlocke must be active for tracking; but we still register
          -- even if the master toggle is off so the slot stays coherent.
          registerStarterCatch(species, mon)
          return
      end

      -- Only enforce gifts/trades when Nuzlocke is active.
      if not active(game, nil) then return end

      local giftLookup  = buildGiftLookup()
      local tradeLookup = buildTradeLookup()

      -- Fallback/external acquisition events do not always pass through the
      -- native Commands.give_pokemon / Commands.trade wrappers. Prefer an
      -- explicit event source when supplied; only use species lookup as a
      -- compatibility fallback when source is absent so a normal acquisition
      -- cannot be reclassified merely because that species is also gift/trade
      -- eligible somewhere else in the game.
      local isGift = source == "gift" or source == "fossil"
          or source == "prize"
          or (source == "" and giftLookup[species] ~= nil)
      local isTrade = source == "trade"
          or (source == "" and tradeLookup[species] ~= nil)

      -- Wonderlocke is WIP. Wonder Trade transactions belong entirely to the
      -- provider mod for now: do not block them, remove the received Pokemon,
      -- consume an encounter slot, or write Wonderlocke provenance.
      if mod.exports.__beta26.wonderlockeWip
          and isWonderTradeEvent(ev, source) then
          return
      end

      -- 2-3. Gift
      if isGift and not isTrade then
          local giftArea = giftLookup[species] or loc
          if mon and mon.nuzlockeTrackerRegistered == true then return end
          local denied = specialAcquisitionDenied(game, species, giftArea, "gift")
          if denied then
              -- Never delete a Pokemon here. pokemon.received is post-transaction
              -- in some engine/mod paths, so rollback would be unsafe. Native
              -- give_pokemon is rejected before mutation by the command wrapper.
              if mon then mon.nuzlockeInvalidAcquisition = denied end
              worldMechanic(game, "gift_post_denied:" .. tostring(species),
                  "This gift conflicts with your Nuzlocke rules.",
                  "Gift received through an external path.\nReview your rules before using it.",
                  "A mod bypassed the normal gift transaction gate.\nThe Pokemon was preserved instead of deleting data.")
              return
          end
          registerSpecialCatch(species, giftArea, "gift", mon)
          return
      end

      -- 4-5. Trade
      if isTrade then
          local tradeArea = tradeLookup[species] or loc
          if mon and mon.nuzlockeTrackerRegistered == true then return end
          local denied = specialAcquisitionDenied(game, species, tradeArea, "trade")
          if denied then
              -- Same safety rule as gifts: never attempt a destructive rollback
              -- after another mod/engine has already completed the exchange.
              if mon then mon.nuzlockeInvalidAcquisition = denied end
              worldMechanic(game, "trade_post_denied:" .. tostring(species),
                  "This trade conflicts with your Nuzlocke rules.",
                  "Trade completed through an external path.\nThe Pokemon was preserved instead of risking data loss.",
                  "A mod bypassed the normal trade gate.\nNo destructive rollback was attempted.")
              return
          end
          registerSpecialCatch(species, tradeArea, "trade", mon)
      end
  end)

  ---------------------------------------------------------------------
  -- CATCH RULE ENFORCEMENT
  ---------------------------------------------------------------------
  local function pokemonFamily(game, species)
      if mod.exports.__beta26.getGlitchSpeciesInfo(game, species).isGlitch then
          return {}
      end
      local found, pending = {}, { species }
      local data = game and game.data and game.data.pokemon or {}
      while #pending > 0 do
          local id = table.remove(pending)
          if id and not found[id] then
              found[id] = true
              local def = data[id]
              for _, evo in ipairs((def and def.evolutions) or {}) do
                  if evo and evo.species then pending[#pending + 1] = evo.species end
              end
              for parent, parentDef in pairs(data) do
                  for _, evo in ipairs((parentDef and parentDef.evolutions) or {}) do
                      if evo and evo.species == id then
                          pending[#pending + 1] = parent
                      end
                  end
              end
          end
      end
      return found
  end

  local function caughtSpeciesSet(game)
      local caught = {}

      -- Tracker history is authoritative for "previously caught", so a dead,
      -- boxed-out, released, or traded-away Pokemon still counts for Dupes.
      for area, entries in pairs(trackerLog()) do
          if area ~= "__LEGACY__" and type(entries) == "table" then
              for _, entry in ipairs(entries) do
                  local sp = type(entry) == "table"
                      and tostring(entry.species or ""):upper() or ""
                  if sp ~= "" then caught[sp] = true end
              end
          end
      end

      -- Current owned Pokemon are a safety net for imported/modded saves whose
      -- tracker reconstruction has not run yet.
      for _, mon in ipairs(Identity.allCurrentMons(game and game.save or {})) do
          local sp = type(mon) == "table"
              and tostring(mon.species or ""):upper() or ""
          if sp ~= "" then caught[sp] = true end
      end

      return caught
  end

  local function dupesMode()
      local value = mod.save:get("dupes_mode", 0)
      if type(value) == "boolean" then return value and 2 or 0 end
      return math.max(0, math.min(2, math.floor(tonumber(value) or 0)))
  end

  local function isDuplicateSpecies(game, species)
      local mode = dupesMode()
      if mode <= 0 then return false end

      -- Glitch identities are not stable evolution-family members. Treat each
      -- allowed glitch encounter independently instead of traversing missing or
      -- malformed evolution data.
      if mod.exports.__beta26.getGlitchSpeciesInfo(game, species).isGlitch then
          return false
      end

      species = tostring(species or ""):upper()
      if species == "" then return false end

      local caught = caughtSpeciesSet(game)
      if mode == 1 then
          return caught[species] == true
      end

      local members = pokemonFamily(game, species)
      for caughtSpecies in pairs(caught) do
          if members[caughtSpecies] == true then return true end
      end
      return false
  end

  ---------------------------------------------------------------------
  -- FAILED ENCOUNTER STATE
  -- A failed eligible wild encounter consumes the area's encounter slot.
  -- Dupes encounters do not consume the slot while Dupes Clause is ON.
  ---------------------------------------------------------------------
  local function encounterStates()
      local states = mod.save:get("encounter_states")
      if type(states) ~= "table" then
          states = {}
          mod.save:set("encounter_states", states)
      end
      return states
  end

  getEncounterState = function(key)
      if not key then return nil end
      return encounterStates()[key]
  end

  local function markEncounterFailed(key, species, encounterType, sourceMapId)
      if not key or mod.save:get("failed_encounter", true) ~= true then return end
      key = registerArea(key)
      if not isTrackedArea(key) then return end
      local states = encounterStates()
      local physical = routeKey(sourceMapId) or key
      states[key] = {
          status = "FAILED",
          species = species,
          encounterType = encounterType or "wild",
          encounterMapId = physical,
      }
      mod.save:set("encounter_states", states)
      local ledger = mod.save:get("encounter_area_state_ledger", {})
      if type(ledger) ~= "table" then ledger = {} end
      ledger[physical] = {
          status = "FAILED", species = species,
          encounterType = encounterType or "wild",
          encounterMapId = physical,
      }
      mod.save:set("encounter_area_state_ledger", ledger)
      -- beta.26.4: keep one lightweight "most recent failed encounter"
      -- record for story-aware TV flavor. This is presentation metadata only;
      -- encounter enforcement continues to use encounter_states above.
      mod.save:set("last_failed_encounter", {
          area = key,
          encounterMapId = physical,
          species = species,
          encounterType = encounterType or "wild",
      })
  end

  local function markEncounterCaught(key, species, encounterType, sourceMapId,
      consumedArea)
      if not key then return end
      key = registerArea(key)
      if not isTrackedArea(key) then return end
      local states = encounterStates()
      local physical = routeKey(sourceMapId) or key
      states[key] = {
          status = "CAUGHT",
          species = species,
          encounterType = encounterType or "wild",
          encounterMapId = physical,
          consumedArea = consumedArea ~= false,
      }
      mod.save:set("encounter_states", states)
      local ledger = mod.save:get("encounter_area_state_ledger", {})
      if type(ledger) ~= "table" then ledger = {} end
      ledger[physical] = {
          status = "CAUGHT", species = species,
          encounterType = encounterType or "wild",
          encounterMapId = physical,
          consumedArea = consumedArea ~= false,
      }
      mod.save:set("encounter_area_state_ledger", ledger)
  end

  -- Rebuild the active encounter views from immutable physical-map
  -- provenance. This is called on load and immediately after either split
  -- selector changes. It never deletes catch rows: COMMON separates them and
  -- OFF groups them back under the parent while preserving every row.
  mod.exports.__beta26.reprojectEncounterAreas = function()
      local oldLog = trackerLog()
      local newLog = {}
      for oldKey, entries in pairs(oldLog) do
          if oldKey == "__LEGACY__" then
              newLog[oldKey] = entries
          elseif type(entries) == "table" then
              for _, entry in ipairs(entries) do
                  if type(entry) == "table" then
                      local physical = routeKey(entry.encounterMapId)
                      local normalizedOld = routeKey(oldKey)
                      if not physical then
                          physical = normalizedOld
                          if mod.exports.__beta26.splitFamilyFor(normalizedOld) then
                              entry.encounterMapId = normalizedOld
                          end
                      end
                      local target = mod.exports.__beta26.projectEncounterArea(
                          physical) or normalizedOld or oldKey
                      newLog[target] = newLog[target] or {}
                      newLog[target][#newLog[target] + 1] = entry
                  end
              end
          else
              newLog[oldKey] = entries
          end
      end
      mod.save:set("tracker_log", newLog)

      local oldStates = encounterStates()
      local stateLedger = mod.save:get("encounter_area_state_ledger", {})
      if type(stateLedger) ~= "table" then stateLedger = {} end
      for oldKey, state in pairs(oldStates) do
          if type(state) == "table" then
              local physical = routeKey(state.encounterMapId) or routeKey(oldKey)
              if physical and (stateLedger[physical] == nil
                  or state.projectedFromSplits ~= true) then
                  local copy = {}
                  for k, v in pairs(state) do copy[k] = v end
                  copy.encounterMapId = physical
                  copy.projectedFromSplits = nil
                  stateLedger[physical] = copy
              end
          end
      end

      local newStates = {}
      for physical, state in pairs(stateLedger) do
          if type(state) == "table" then
              local target = mod.exports.__beta26.projectEncounterArea(physical)
                  or routeKey(physical)
              if target then
                  local existing = newStates[target]
                  local existingConsumes = existing and
                      (existing.status == "FAILED"
                          or existing.consumedArea ~= false)
                  local stateConsumes = state.status == "FAILED"
                      or state.consumedArea ~= false
                  if not existing or (not existingConsumes and stateConsumes)
                      or (existingConsumes == stateConsumes
                          and existing.status ~= "CAUGHT"
                          and state.status == "CAUGHT") then
                      local copy = {}
                      for k, v in pairs(state) do copy[k] = v end
                      copy.encounterMapId = routeKey(physical) or physical
                      copy.projectedFromSplits = target ~= copy.encounterMapId
                      newStates[target] = copy
                  end
              end
          end
      end
      mod.save:set("encounter_area_state_ledger", stateLedger)
      mod.save:set("encounter_states", newStates)

      local oldCaught = caughtAreas()
      local covered = {}
      for key in pairs(oldLog) do covered[key] = true end
      for key in pairs(oldStates) do covered[key] = true end
      local newCaught = {}
      for key, entries in pairs(newLog) do
          if key ~= "__LEGACY__" and type(entries) == "table" then
              for _, entry in ipairs(entries) do
                  if type(entry) == "table" and entry.species
                      and entry.consumedArea ~= false then
                      newCaught[key] = entry.species
                      break
                  end
              end
          end
      end
      for key, state in pairs(newStates) do
          if newCaught[key] == nil and type(state) == "table"
              and state.status == "CAUGHT" and state.species
              and state.consumedArea ~= false then
              newCaught[key] = state.species
          end
      end
      for oldKey, species in pairs(oldCaught) do
          if oldKey == "__LEGACY__" then
              newCaught[oldKey] = species
          elseif not covered[oldKey] then
              local target = mod.exports.__beta26.projectEncounterArea(oldKey)
                  or routeKey(oldKey) or oldKey
              if newCaught[target] == nil then newCaught[target] = species end
          end
      end
      mod.save:set("caught_areas", newCaught)

      local oldVisited = visitedAreas()
      local visitLedger = mod.save:get("encounter_visited_map_ids", {})
      if type(visitLedger) ~= "table" then visitLedger = {} end
      for key, value in pairs(oldVisited) do
          if value == true and visitLedger[key] == nil then
              local projectedParent = false
              for _, family in pairs(mod.exports.__beta26.encounterSplitAreas) do
                  if key == family.parent then
                      for member in pairs(family.members) do
                          if visitLedger[member] == true then
                              projectedParent = true
                              break
                          end
                      end
                  end
                  if projectedParent then break end
              end
              if not projectedParent then visitLedger[key] = true end
          end
      end
      local newVisited = {}
      for physical, value in pairs(visitLedger) do
          if value == true then
              local target = mod.exports.__beta26.projectEncounterArea(physical)
                  or routeKey(physical)
              if target then newVisited[target] = true end
          end
      end
      mod.save:set("encounter_visited_map_ids", visitLedger)
      mod.save:set("visited_areas", newVisited)

      -- Keep Catch Info and history aligned with the same live projection.
      -- The physical map field remains stable, while catchLocation is the
      -- current player-facing area name/key used throughout existing UI.
      for _, mon in ipairs(Identity.allCurrentMons(
          currentGame and currentGame.save or currentSave or {})) do
          if type(mon) == "table" then
              local physical = routeKey(mon.nuzlockeEncounterMapId)
              local oldLocation = routeKey(mon.catchLocation)
              if not physical
                  and mod.exports.__beta26.splitFamilyFor(oldLocation) then
                  physical = oldLocation
                  mon.nuzlockeEncounterMapId = physical
              end
              if physical then
                  mon.catchLocation = mod.exports.__beta26.projectEncounterArea(
                      physical) or mon.catchLocation
              end
          end
      end
      local history = mod.save:get("nuzlocke_history", {})
      if type(history) == "table" then
          for _, row in ipairs(history) do
              if type(row) == "table" then
                  local physical = routeKey(row.encounterMapId)
                  local oldLocation = routeKey(row.catchLocation)
                  if not physical
                      and mod.exports.__beta26.splitFamilyFor(oldLocation) then
                      physical = oldLocation
                      row.encounterMapId = physical
                  end
                  if physical then
                      row.catchLocation = mod.exports.__beta26.projectEncounterArea(
                          physical) or row.catchLocation
                  end
              end
          end
          mod.save:set("nuzlocke_history", history)
      end
      local lastFailed = mod.save:get("last_failed_encounter", {})
      if type(lastFailed) == "table" then
          local physical = routeKey(lastFailed.encounterMapId)
          if physical then
              lastFailed.area = mod.exports.__beta26.projectEncounterArea(physical)
                  or lastFailed.area
              mod.save:set("last_failed_encounter", lastFailed)
          end
      end
      mod.save:set("encounter_projection_signature",
          tostring(math.max(0, math.min(1, math.floor(tonumber(
              mod.save:get("route_splits", 0)) or 0)))) .. ":"
          .. tostring(math.max(0, math.min(1, math.floor(tonumber(
              mod.save:get("mt_moon_splits", 0)) or 0)))) .. ":"
          .. tostring(math.max(0, math.min(1, math.floor(tonumber(
              mod.save:get("safari_zone_splits", 0)) or 0)))))
      return true
  end

  mod.exports.__beta26.ensureEncounterProjection = function()
      local signature = tostring(math.max(0, math.min(1, math.floor(tonumber(
          mod.save:get("route_splits", 0)) or 0)))) .. ":"
          .. tostring(math.max(0, math.min(1, math.floor(tonumber(
          mod.save:get("mt_moon_splits", 0)) or 0)))) .. ":"
          .. tostring(math.max(0, math.min(1, math.floor(tonumber(
              mod.save:get("safari_zone_splits", 0)) or 0))))
      if mod.save:get("encounter_projection_signature", nil) ~= signature then
          return mod.exports.__beta26.reprojectEncounterAreas()
      end
      return false
  end

  mod.events:on("save.loaded", function()
      pcall(mod.exports.__beta26.reprojectEncounterAreas)
  end)
  mod.events:on("game.ready", function()
      pcall(mod.exports.__beta26.reprojectEncounterAreas)
  end)

  -- BETA.26 ENCOUNTER ARMING / SOFT START
  -- Keep this helper namespace on the existing beta export table instead of
  -- adding more long-lived locals to the main mod chunk. This is intentionally
  -- initialization-safe: the prior B5 feature batch caused the entire mod to
  -- disappear before title/start-menu hooks became usable on Blue and Gold.
  ---------------------------------------------------------------------
  mod.exports.__beta26.tableContainsOwnedBall = function(game, tbl, seen)
      if type(tbl) ~= "table" then return false end
      seen = seen or {}
      if seen[tbl] then return false end
      seen[tbl] = true
      for key, value in pairs(tbl) do
          if type(value) == "number" and value > 0 then
              local ok, result = pcall(ItemPolicy.isBall,
                  game and game.data, key, nil)
              if ok and result == true then
                  local okBlocked, blocked = pcall(ItemPolicy.ballUseBlocked,
                      game and game.data, key, nil, true)
                  if not okBlocked or blocked ~= true then return true end
              end
          elseif type(value) == "table"
              and mod.exports.__beta26.tableContainsOwnedBall(game, value, seen) then
              return true
          end
      end
      return false
  end

  mod.exports.__beta26.hasLegacyEncounterEvidence = function()
      -- Pallet Town's starter is established before the player owns Balls and
      -- MUST NOT arm Soft Start by itself. Only meaningful non-starter route
      -- history reconstructs an older save as already armed.
      -- Repair the old B7 Oak/Lab starter duplicate before using history as
      -- evidence that encounter rules should already be armed.
      mod.exports.__beta26.cleanupStarterDuplicate()

      local areas = mod.save:get("caught_areas", nil)
      if type(areas) == "table" then
          for key, value in pairs(areas) do
              if key ~= "PALLET_TOWN" and value ~= nil then
                  local k = tostring(key or ""):upper()
                  local sp = tostring(value or ""):upper()
                  local starter = sp == "BULBASAUR" or sp == "CHARMANDER"
                      or sp == "SQUIRTLE" or sp == "PIKACHU"
                  if not (starter and (k:find("OAK", 1, true)
                      or k:find("LAB", 1, true))) then
                      return true
                  end
              end
          end
      end
      local states = mod.save:get("encounter_states", nil)
      if type(states) == "table" then
          for key, state in pairs(states) do
              if key ~= "PALLET_TOWN" and type(state) == "table"
                  and (state.status == "FAILED" or state.status == "CAUGHT") then
                  return true
              end
          end
      end
      local log = mod.save:get("tracker_log", nil)
      if type(log) == "table" then
          for key, entries in pairs(log) do
              if key ~= "PALLET_TOWN" and key ~= "__LEGACY__"
                  and type(entries) == "table" and #entries > 0 then
                  local k = tostring(key or ""):upper()
                  local onlyStarter = true
                  for _, entry in ipairs(entries) do
                      local sp = tostring(entry and entry.species or ""):upper()
                      if sp ~= "BULBASAUR" and sp ~= "CHARMANDER"
                          and sp ~= "SQUIRTLE" and sp ~= "PIKACHU" then
                          onlyStarter = false
                          break
                      end
                  end
                  if not (onlyStarter and (k:find("OAK", 1, true)
                      or k:find("LAB", 1, true))) then
                      return true
                  end
              end
          end
      end
      return false
  end

  mod.exports.__beta26.clearPreArmEncounterState = function()
      -- Pre-Ball encounters are intentionally invisible to the route ledger.
      -- Clear only transient encounter-state rows; successful catch history and
      -- the starter tracker row live in separate tables and are preserved.
      mod.save:set("encounter_states", {})
  end

  mod.exports.__beta26.encounterRulesArmed = function(game)
      if mod.save:get("nuzlocke_encounters_armed", false) == true then return true end

      -- Compatibility for older saves: genuine route history means the run
      -- already passed the first-Ball boundary. A starter-only Pallet row does
      -- not count as evidence and leaves a fresh run unarmed.
      if mod.exports.__beta26.hasLegacyEncounterEvidence() then
          mod.save:set("nuzlocke_encounters_armed", true)
          return true
      end

      local save = game and game.save
      if save and (mod.exports.__beta26.tableContainsOwnedBall(game, save.inventory)
          or mod.exports.__beta26.tableContainsOwnedBall(game, save.pcItems)
          or mod.exports.__beta26.tableContainsOwnedBall(game, save.bag)
          or mod.exports.__beta26.tableContainsOwnedBall(game, save.pockets)) then
          mod.exports.__beta26.clearPreArmEncounterState()
          mod.save:set("nuzlocke_encounters_armed", true)
          worldMechanic(game, "encounter_armed",
              "Area Guide is now open.",
              "Area Guide unlocked.\nCheck your routes anytime.",
              "The Area Guide is now open.\nUse the Nuzlocke Tracker to review your routes.")
          return true
      end
      return false
  end

  mod.exports.__beta26.armEncounterRulesNow = function(game)
      if mod.save:get("nuzlocke_encounters_armed", false) ~= true then
          mod.exports.__beta26.clearPreArmEncounterState()
          mod.save:set("nuzlocke_encounters_armed", true)
      end
      return true
  end

  local activeWildEncounter = nil

  local function isTrainerBattleForNuzlocke(battle)
      if not battle then return false end
      if battle.kind == "trainer" or battle.type == "trainer" then return true end
      if battle.trainerBattle == true or battle.isTrainerBattle == true then return true end
      if battle.trainer ~= nil or battle.opponentTrainer ~= nil then return true end
      if battle.opponent and type(battle.opponent) == "table" and battle.opponent.name then return true end
      return false
  end

  -- Rival identity is deliberately behavioral and generation-neutral. Trainer
  -- IDs/classes are preferred, with the familiar default names retained as a
  -- compatibility fallback for engine builds that expose only display text.
  mod.exports.__beta26.isRivalBattle = function(battle)
      if type(battle) ~= "table" or not isTrainerBattleForNuzlocke(battle) then
          return false
      end
      local trainer = type(battle.trainer) == "table" and battle.trainer
          or type(battle.opponentTrainer) == "table" and battle.opponentTrainer
          or nil
      local fields = {
          tostring(battle.oppClass or ""),
          tostring(battle.trainerClass or ""),
          tostring(battle.opponentClass or ""),
          tostring(battle.trainerId or ""),
          tostring(battle.trainerID or ""),
          tostring(battle.opponentId or ""),
          tostring(battle.trainerName or ""),
          tostring(battle.opponentName or ""),
          tostring(trainer and trainer.class or ""),
          tostring(trainer and trainer.trainerClass or ""),
          tostring(trainer and trainer.id or ""),
          tostring(trainer and trainer.name or ""),
      }
      for _, value in ipairs(fields) do
          local compact = value:upper():gsub("[^A-Z0-9]", "")
          if compact:find("RIVAL", 1, true)
              or compact == "BLUE" or compact == "SILVER" then
              return true
          end
      end
      return false
  end

  -- Avoid granting a newly-added option to a later Rival battle on an old
  -- save. Canonical opening locations and the shared level-5/zero-badge battle
  -- profile identify Red/Blue/Yellow and Gold without depending on mod names.
  mod.exports.__beta26.isOpeningRivalBattle = function(game, battle)
      if not mod.exports.__beta26.isRivalBattle(battle) then return false end
      local key = areaKey(game, battle)
      local area = tostring(key or ""):upper():gsub("[^A-Z0-9]", "")
      local openingArea = area:find("OAKSLAB", 1, true) ~= nil
          or area:find("PALLETTOWN", 1, true) ~= nil
          or area:find("ROUTE29", 1, true) ~= nil
          or area:find("CHERRYGROVE", 1, true) ~= nil

      local enemy = battle.enemy
      if type(enemy) == "table" and type(enemy.mon) == "table" then
          enemy = enemy.mon
      end
      local enemyLevel = type(enemy) == "table"
          and tonumber(enemy.level or enemy.lv) or nil
      local badges = currentBadgeCount(game and game.save)
      return openingArea or (badges == 0 and enemyLevel ~= nil and enemyLevel <= 6)
  end

  ---------------------------------------------------------------------
  -- GENERATION-NEUTRAL BATTLE CLASSIFIER
  --
  -- This is a read-only compatibility surface. It consolidates the battle
  -- shapes already understood by individual rules without making a rule
  -- decision or invoking another mod's callbacks. Consumers should prefer
  -- flags over `kind` when categories can overlap (a Rival is also a trainer;
  -- a scripted fixed encounter is also wild/catchable).
  ---------------------------------------------------------------------
  mod.exports.__beta26.classifyBattle = function(game, battle, species)
      local wrapper = type(battle) == "table" and battle or {}
      local core = type(wrapper.battle) == "table" and wrapper.battle or wrapper
      game = game or wrapper.game or core.game or currentGame or mod.game

      local source = tostring(core.encounterType or core.encounterSource
          or core.source or wrapper.encounterType or wrapper.encounterSource
          or wrapper.source or ""):lower()
      local trainer = isTrainerBattleForNuzlocke(core)
      local tutorial = wrapper.tutorial == true or core.tutorial == true
          or wrapper.isTutorial == true or core.isTutorial == true
          or source == "tutorial" or source == "catch_tutorial"
      local demo = wrapper.demo == true or core.demo == true
      local ghost = wrapper.ghost == true or core.ghost == true
      local rival = trainer and mod.exports.__beta26.isRivalBattle(core)
      local openingRival = rival
          and mod.exports.__beta26.isOpeningRivalBattle(game, core) or false
      local static = mod.exports.__beta26.isStaticEncounter(game, core)
      local roamer = core.nuzlockeRoamingEncounter == true
          or core.roamingEncounter == true or core.isRoamer == true
          or core.roamer == true or source == "roamer" or source == "roaming"
          or source:find("roam", 1, true) ~= nil
      local scripted = static or core.scriptedEncounter == true
          or core.isScriptedEncounter == true or core.storyEncounter == true
          or source == "script" or source == "scripted" or source == "event"
          or source == "fixed"

      local enemy = core.enemy or wrapper.enemy or core.wildMon
      if type(enemy) == "table" and type(enemy.mon) == "table" then
          enemy = enemy.mon
      end
      species = species or (type(enemy) == "table"
          and (enemy.species or enemy.id or enemy.name))
          or core.species or wrapper.species
      local speciesKey = mod.exports.__beta26.getGlitchSpeciesInfo(
          game, species).key

      local kindText = tostring(core.kind or core.type or ""):lower()
      local wild = not trainer and (core.wild == true or wrapper.wild == true
          or kindText == "wild" or source == "wild" or source == "grass"
          or source == "surf" or source == "fishing" or source == "overworld"
          or static or roamer or type(enemy) == "table")
      local overworld = core.overworldEncounter == true
          or core.overworld == true or core.isOverworld == true
          or source == "overworld"
      local externalProvider = core.nuzlockeEncounterProvider
          or core.encounterProvider or wrapper.nuzlockeEncounterProvider
          or wrapper.encounterProvider
      local externalVersion = core.nuzlockeEncounterProviderVersion
          or core.encounterProviderVersion
          or wrapper.nuzlockeEncounterProviderVersion
          or wrapper.encounterProviderVersion

      local flags = {
          tutorial = tutorial,
          demo = demo,
          ghost = ghost,
          trainer = trainer,
          rival = rival,
          opening_rival = openingRival,
          wild = wild,
          ordinary_wild = wild and not static and not roamer and not scripted,
          static = static,
          fixed = static,
          roaming = roamer,
          scripted = scripted,
          overworld = overworld,
          legendary = Identity.isLegendarySpecies(game, speciesKey),
          mythical = Identity.isMythicalSpecies(game, speciesKey),
          external = externalProvider ~= nil,
      }
      flags.excluded = tutorial or demo or ghost
      flags.catchable = wild and not trainer and not flags.excluded
      flags.unknown = not trainer and not wild and not flags.excluded

      local kind = "unknown"
      if tutorial then kind = "tutorial"
      elseif demo or ghost then kind = "excluded"
      elseif rival then kind = "rival"
      elseif trainer then kind = "trainer"
      elseif roamer then kind = "roaming"
      elseif static then kind = "static"
      elseif scripted then kind = "scripted"
      elseif wild then kind = "wild"
      end

      local trainerRecord = type(core.trainer) == "table" and core.trainer
          or type(core.opponentTrainer) == "table" and core.opponentTrainer
          or nil
      return {
          api = 1,
          kind = kind,
          flags = flags,
          generation = mod.exports.__beta26.runtimeIsGold(game) and 2 or 1,
          area = areaKey(game, core),
          source = source ~= "" and source or nil,
          species = speciesKey,
          trainer = {
              id = core.trainerId or core.trainerID or core.opponentId
                  or (trainerRecord and trainerRecord.id),
              class = core.oppClass or core.trainerClass or core.opponentClass
                  or (trainerRecord and (trainerRecord.class
                      or trainerRecord.trainerClass)),
              name = core.trainerName or core.opponentName
                  or (trainerRecord and trainerRecord.name),
          },
          provider = externalProvider and {
              id = externalProvider,
              version = externalVersion,
          } or nil,
      }
  end

  mod.exports.battle_classifier = {
      api = 1,
      build = "beta.29.1.0",
      classify = function(game, battle, species)
          return mod.exports.__beta26.classifyBattle(game, battle, species)
      end,
  }

  mod.exports.__beta26.armFirstRivalForgiveness = function(game, battle)
      if not mod.exports.__beta26.isRivalBattle(battle) then return false end
      if mod.save:get("nuzlocke_first_rival_battle_seen", false) == true then
          return false
      end

      -- The first Rival encounter consumes the one-time slot regardless of
      -- whether the rule is enabled or whether anybody actually faints.
      mod.save:set("nuzlocke_first_rival_battle_seen", true)
      local opening = mod.exports.__beta26.isOpeningRivalBattle(game, battle)
      battle.nuzlockeFirstRivalBattle = opening == true
      if not opening then return false end

      local enabled = mod.save:get("first_rival_forgiveness", true) == true
      -- REVIEWED: nuzlocke_first_rival_battle_seen is the only durable
      -- one-shot state. Armed/triggered state is battle-local because no
      -- resume or status path consumes separate persisted telemetry.
      battle.nuzlockeRivalForgiveness = enabled
      return enabled
  end

  mod.exports.__beta26.isFirstRivalForgivenessActive = function(game, battle)
      return type(battle) == "table"
          and battle.nuzlockeFirstRivalBattle == true
          and battle.nuzlockeRivalForgiveness == true
          and mod.save:get("nuzlocke_enabled", true) ~= false
  end

  local function beginWildEncounter(payload)
      if not payload then return end
      local battle = payload.battle or payload
      if not battle then return end
      if not currentGame then currentGame = payload.game end
      local game = payload.game or currentGame
      local classification = mod.exports.__beta26.classifyBattle(game, battle)
      if classification.flags.trainer or classification.flags.excluded then return end
      if not active(game, battle) then return end
      if not mod.exports.__beta26.encounterRulesArmed(game) then return end

      local key = areaKey(game, battle)
      if not key then return end
      local encounterMapId = battle and battle.nuzlockeEncounterMapId
          or mod.exports.__beta26.currentPhysicalArea(game,
              game and game.save and game.save.player
              and game.save.player.map)
      local species = battle.enemy and battle.enemy.mon and battle.enemy.mon.species
          or battle.enemy and battle.enemy.species
          or payload.species
      if species == nil or species == "" then return end
      local glitch = mod.exports.__beta26.getGlitchSpeciesInfo(game, species)
      local rawSpecies = species
      species = glitch.key

      local shiny = enemyIsShiny(battle)
      local shinyClause = mod.save:get("shiny_clause", false) == true
      local town = isTownArea(key, routeName(key))
      local overworld = battle.overworldEncounter == true
          or battle.overworld == true
          or battle.isOverworld == true
          or battle.encounterType == "overworld"
          or battle.source == "overworld"
      local static = mod.exports.__beta26.isStaticEncounter(game, battle)

      if static and mod.exports.__beta26.ruleActive(
          game, "no_static_encounters", battle) then return end
      if overworld and not mod.save:get("overworld_encounters", false) then return end
      if town and not mod.save:get("town_catches", false) then return end
      if not mod.save:get("encounter_limit", false) then return end
      if mod.save:get("failed_encounter", true) ~= true then return end
      if caughtAreas()[key] ~= nil then return end

      local existing = getEncounterState(key)
      if existing and (existing.status == "FAILED" or existing.status == "CAUGHT") then return end

      if isDuplicateSpecies(game, species)
          and not (shiny and shinyClause) then
          return
      end

      local provider = activeCompatProvider("encounters", game, battle)
      if provider then rememberEncounterProvider(provider.id, provider.version) end
      activeWildEncounter = {
          battle = battle, game = game, key = key, species = species,
          encounterMapId = encounterMapId,
          rawSpecies = glitch.isGlitch and rawSpecies or nil,
          glitch = glitch.isGlitch or nil,
          missingNo = glitch.missingNo or nil,
          encounterType = static and "static"
              or (overworld and "overworld" or (town and "town" or "wild")),
          encounterSource = provider and "provider" or "vanilla",
          encounterProvider = provider and provider.id or nil,
          encounterProviderVersion = provider and provider.version or nil,
          encounterContext = providerContext(provider, game, battle),
          resolved = false,
      }
  end

  mod.events:on("battle.started", function(payload)
      local battle = payload and (payload.battle or payload)
      local game = payload and payload.game or currentGame
      local pendingStatic = mod.exports.__beta26.pendingStaticEncounter
      if battle and type(pendingStatic) == "table" then
          -- REVIEWED: pendingStaticEncounter is single-use provenance for the
          -- next battle only. Any intervening battle, including a trainer,
          -- consumes it so stale static state cannot leak into a later wild.
          mod.exports.__beta26.pendingStaticEncounter = nil
          if not isTrainerBattleForNuzlocke(battle) then
              battle.nuzlockeStaticEncounter = true
              battle.encounterType = battle.encounterType or "static"
          end
      end

      -- Gold has a separate battle model. Apply the same absolute creation
      -- presets at the shared battle.started seam when its live model exposes
      -- Pokemon tables. R/B/Y may reach this after the constructor wrapper;
      -- absolute assignment makes that harmless and idempotent.
      if battle and game and active(game, battle) then
          if isTrainerBattleForNuzlocke(battle) then
              local enemyParty = battle.enemyParty
                  or (type(battle.trainer) == "table" and battle.trainer.party)
              if type(enemyParty) == "table" then
                  for _, mon in ipairs(enemyParty) do
                      if type(mon) == "table" and mon.species then
                          mod.exports.__beta26.StatRules.applyStarting(game.data, mon,
                              "trainer_start_stat_exp", "perfect_trainer_ivs", false)
                      end
                  end
              elseif type(battle.enemy) == "table" then
                  local mon = battle.enemy.mon or battle.enemy
                  if mon.species then
                      mod.exports.__beta26.StatRules.applyStarting(game.data, mon,
                          "trainer_start_stat_exp", "perfect_trainer_ivs", false)
                  end
              end
          elseif type(battle.enemy) == "table" then
              local mon = battle.enemy.mon or battle.enemy
              if mon.species then
                  mod.exports.__beta26.StatRules.applyStarting(game.data, mon,
                      "wild_start_stat_exp", "perfect_wild_ivs", false)
              end
          end
      end

      beginWildEncounter(payload)

      if battle and game then
          pcall(mod.exports.__beta26.armFirstRivalForgiveness, game, battle)
      end
      if not battle or not game or not active(game, battle) or not isTrainerBattleForNuzlocke(battle) then return end
      local oppClass = tostring(battle.oppClass or battle.trainerClass or battle.opponentClass or ""):upper()
      local trainerName = tostring((battle.trainer and battle.trainer.name) or battle.trainerName or battle.opponentName or ""):upper()
      local label = oppClass .. " " .. trainerName

      -- battle.started fires after the vanilla intro queue is assembled but
      -- before that queue has actually played. Pushing a separate TextBox here
      -- made the rival flavor appear before the rival sprite. Queue the flavor
      -- onto the battle itself instead, so the vanilla trainer reveal/send-out
      -- sequence remains first.
      local function queueTrainerFlavor(key, message, minimumTier)
          if worldTier(game) < (minimumTier or 3) then return false end
          local flags = worldFlags()
          if flags[key] then return false end
          if type(battle.say) == "function" then
              local cleaned = mod.exports.__beta26.cleanWorldText(message)
              local ok = pcall(battle.say, battle,
                  mod.exports.__beta26.formatBattleText
                      and mod.exports.__beta26.formatBattleText(cleaned) or cleaned)
              if ok then
                  flags[key] = true
                  mod.save:set("nuzlocke_world_flags", flags)
                  return true
              end
          elseif type(battle.emit) == "function" then
              -- Gold's battle model has an event queue rather than Gen 1's
              -- say() queue.  A message emitted during battle.started is
              -- drained after the native intro, preserving story order.
              local cleaned = mod.exports.__beta26.cleanWorldText(message)
              local ok = pcall(battle.emit, battle, {
                  kind = "message", text = cleaned,
              })
              if ok then
                  flags[key] = true
                  mod.save:set("nuzlocke_world_flags", flags)
                  return true
              end
          end
          return worldOnce(game, key, message)
      end

      if battle.nuzlockeRivalForgiveness == true then
          queueTrainerFlavor("first_rival_forgiveness",
              "FIRST RIVAL BATTLE!\nFaints are forgiven this time only.", 1)
      elseif label:find("RIVAL", 1, true) or label:find("BLUE", 1, true) then
          queueTrainerFlavor("rival_notice", "Your Rival notices the rules.\n\"Only one Pokemon? You're seriously doing this to yourself?\"")
      elseif label:find("BROCK", 1, true) then
          queueTrainerFlavor("brock_notice", "Brock looks over your team.\n\"I've heard about your little challenge.\"\n\"Don't worry. My team won't go easy on you.\"")
      elseif label:find("MISTY", 1, true) then
          queueTrainerFlavor("misty_notice", "Misty smirks.\n\"Let's see how long those rules last.\"")
      elseif label:find("LT SURGE", 1, true) or label:find("LT_SURGE", 1, true) then
          queueTrainerFlavor("surge_notice", "Lt. Surge grins.\n\"Hardcore rules? Good. I like a serious challenger.\"")
      elseif label:find("ERIKA", 1, true) or label:find("KOGA", 1, true) or label:find("SABRINA", 1, true) or label:find("BLAINE", 1, true) or label:find("GIOVANNI", 1, true) then
          queueTrainerFlavor("gym_leader_notice:" .. label, "The Gym Leader has heard about your Nuzlocke.\n\"Let's see whether you can follow your own rules under pressure.\"")
      end
  end)

  -- Some composable battle-format mods temporarily narrow/reorder the player's
  -- party and restore the original Pokemon objects at battle.ended. A Pokemon
  -- that died while selected can therefore be reinserted by that later restore
  -- even though Nuzlocke removed it before vanilla faint handling. Keep this
  -- generic: dead provenance on the Pokemon object is authoritative, regardless
  -- of which mod temporarily owned the party layout.
  local function pruneRestoredDeadPokemon(game)
      local party = game and game.save and game.save.party
      if type(party) ~= "table" then return 0 end
      local removed = 0
      for i = #party, 1, -1 do
          local mon = party[i]
          if type(mon) == "table" and mon.nuzlockeDead == true then
              table.remove(party, i)
              removed = removed + 1
          end
      end
      return removed
  end
  mod.exports.__beta26.pruneRestoredDeadPokemon = pruneRestoredDeadPokemon

  -- Run after ordinary battle.ended listeners. This lets temporary-party mods
  -- restore their snapshot first, then removes only Pokemon already marked dead
  -- by Nuzlocke. Priority is intentionally lower than the normal default (0).
  mod.events:on("battle.ended", function(payload)
      local battle = payload and (payload.battle or payload)
      local game = battle and battle.game or currentGame
      if mod.save:get("nuzlocke_enabled", true) == true
          and mod.save:get("permadeath", true) == true then
          pruneRestoredDeadPokemon(game)
      end
  end, -1000)

  -- One private, idempotent battle finalizer owns every Nuzlocke task that
  -- depends on battle completion. The genuine engine battle.ended event calls
  -- it, and the BattleState.finish wrapper above is only a private fallback for
  -- older builds. External mods never see a fabricated duplicate event.
  local finalizedNuzlockeBattles = setmetatable({}, { __mode = "k" })

  local function compactTrainerIdentity(value)
      return tostring(value or ""):upper():gsub("[^A-Z0-9]", "")
  end

  local function recordLeagueProgression(battle, result)
      if not battle or not isTrainerBattleForNuzlocke(battle)
          or result ~= "win" then return end
      local game = battle.game or currentGame
      local save = game and game.save
      if not save then return end

      local trainer = battle.trainer
      local trainerId = trainer and trainer.id
      local trainerName = tostring((trainer and trainer.name)
          or battle.trainerName or battle.opponentName or ""):upper()
      local nameKey = compactTrainerIdentity(trainerName)
      local idKey = compactTrainerIdentity(trainerId)

      local ver = getGameVersion and getGameVersion() or "RED"
      local profile = VersionCompat.profiles[ver]
      if profile and profile.family == "GSC" then
          local key = nameKey .. idKey
          local progress = gscProgress(save)
          for _, stage in ipairs(VersionCompat.gscStages) do
              local stageKey = compactTrainerIdentity(stage.name)
              if stageKey ~= "" and key:find(stageKey, 1, true) then
                  progress[stage.name] = true
                  mod.save:set("nuzlocke_gsc_defeated", progress)
                  return
              end
          end
          return
      end

      -- Gym wins are persistent progression evidence, independent of badge
      -- inventory. Normalize punctuation/underscores so RED/BLUE/YELLOW and
      -- trainer-overhaul record shapes all match the same leader names.
      local gymProgressTable = gymProgress(save)
      for _, gymLeader in ipairs(LEVEL_CAP_GYM_LEADERS) do
          local leaderKey = compactTrainerIdentity(gymLeader)
          if (leaderKey ~= "" and nameKey:find(leaderKey, 1, true))
              or (leaderKey ~= "" and idKey:find(leaderKey, 1, true)) then
              gymProgressTable[gymLeader] = true
              mod.save:set(GYM_PROGRESS_KEY, gymProgressTable)
              break
          end
      end

      for _, entry in ipairs(ELITE_FOUR_CAPS) do
          local entryIdKey = compactTrainerIdentity(entry.id)
          local entryNameKey = compactTrainerIdentity(entry.name)
          if (entryIdKey ~= "" and idKey == entryIdKey)
              or (entryNameKey ~= "" and nameKey == entryNameKey) then
              local defeated = eliteFourDefeated()
              defeated[entry.id] = true
              mod.save:set("nuzlocke_e4_defeated", defeated)
              return
          end
      end

      -- Randomizers may move badges away from Gym Leaders. Live Champion
      -- progression therefore keys off recorded Gym victories + the E4, never
      -- current badge inventory. Badge count remains only a one-time legacy
      -- seed when no explicit gym-progress record exists.
      local trainerKey = nameKey .. idKey
      if currentGymProgressCount(save) >= 8
          and not nextEliteFourCapInfo()
          and (trainerKey:find("RIVAL", 1, true)
              or trainerKey:find("BLUE", 1, true)
              or trainerKey:find("CHAMPION", 1, true)) then
          mod.save:set("nuzlocke_champion_defeated", true)
      end
  end

  local function finalizeFailedEncounter(battle)
      local pending = activeWildEncounter
      activeWildEncounter = nil

      local game = (battle and battle.game) or currentGame
      if not battle or not game or not game.save then return end
      if pending and pending.battle and battle ~= pending.battle then pending = nil end
      if isTrainerBattleForNuzlocke(battle) then return end
      if not mod.exports.__beta26.encounterRulesArmed(game) then return end
      if mod.save:get("nuzlocke_enabled", true) ~= true
          or mod.save:get("encounter_limit", false) ~= true
          or mod.save:get("failed_encounter", true) ~= true then
          return
      end

      local key = areaKey(game, battle)
      local species = battle.enemy and battle.enemy.mon and battle.enemy.mon.species
      if not key or species == nil or species == "" then return end
      local glitch = mod.exports.__beta26.getGlitchSpeciesInfo(game, species)
      species = glitch.key

      local shiny = enemyIsShiny(battle)
      if shiny and mod.save:get("shiny_clause", false) == true then return end

      local town = isTownArea(key, routeName(key))
      local overworld = battle.overworldEncounter == true
          or battle.overworld == true
          or battle.isOverworld == true
          or battle.encounterType == "overworld"
          or battle.source == "overworld"
      local static = mod.exports.__beta26.isStaticEncounter(game, battle)
      if static and mod.exports.__beta26.ruleActive(
          game, "no_static_encounters", battle) then return end
      if overworld and mod.save:get("overworld_encounters", false) ~= true then return end
      if town and mod.save:get("town_catches", false) ~= true then return end
      if caughtAreas()[key] ~= nil then return end

      local state = getEncounterState(key)
      if state and (state.status == "FAILED" or state.status == "CAUGHT") then return end
      if isDuplicateSpecies(game, species) then return end

      markEncounterFailed(key, species, glitch.isGlitch and "glitch"
          or (static and "static"
              or (overworld and "overworld" or (town and "town" or "wild"))),
          battle.nuzlockeEncounterMapId
              or (pending and pending.encounterMapId))
      worldMechanic(game, "failed:" .. tostring(key),
          "ENCOUNTER FAILED.\nThat was your one shot in this area.",
          "Oof. There goes your encounter.\nThe Nuzlocke gods are keeping score.",
          "The route won't give you another chance.\nKanto has a long memory.")
  end

  finalizeNuzlockeBattle = function(battle, result)
      if type(battle) ~= "table" then return false end
      if finalizedNuzlockeBattles[battle] then return false end
      finalizedNuzlockeBattles[battle] = true

      local finalResult = result or battle.result or "run"
      recordLeagueProgression(battle, finalResult)
      finalizeFailedEncounter(battle)
      return true
  end

  mod.events:on("battle.ended", function(payload)
      local battle = payload and (payload.battle or payload)
      local result = payload and payload.result or (battle and battle.result)
      if type(finalizeNuzlockeBattle) == "function" then
          finalizeNuzlockeBattle(battle, result)
      end
  end)

  enemyIsShiny = function(battle)
      if not (battle and battle.enemy) then return false end
      local mon = battle.enemy.mon or battle.enemy
      return Identity.isShiny(mon)
  end

  catchDeniedReason = function(game, battle, species)
      if not active(game, battle) then
          return nil
      end

      -- A nil/empty species means the enemy slot is not populated yet (for
      -- example transition frames). Other malformed or numeric identities are
      -- passed through the conservative glitch classifier.
      if species == nil or species == "" then
          return nil
      end
      local glitch = mod.exports.__beta26.getGlitchSpeciesInfo(game, species)
      species = glitch.key

      local key = areaKey(game, battle)
      if not key then
          return nil
      end

      syncCaughtAreasFromLog()

      local overworld = false
      if battle then
          overworld = battle.overworldEncounter == true
              or battle.overworld == true
              or battle.isOverworld == true
              or battle.encounterType == "overworld"
              or battle.source == "overworld"
      end

      local town = isTownArea(key, routeName(key))
      local shiny = enemyIsShiny(battle)
      local shinyClause = mod.save:get("shiny_clause", false) == true
      local encounterArmed = mod.exports.__beta26.encounterRulesArmed(game)

      if glitch.isGlitch and not mod.exports.__beta26.glitchCatchesAllowed() then
          return "glitch"
      end

      -- Static is an absolute capture ban. It is checked before Shiny, area,
      -- and Dupes exceptions so those clauses cannot accidentally bypass it.
      if mod.exports.__beta26.ruleActive(game, "no_static_encounters", battle)
          and mod.exports.__beta26.isStaticEncounter(game, battle) then
          return "static"
      end

      if overworld and not mod.save:get("overworld_encounters", false) then
          return "overworld"
      end

      if town and not mod.save:get("town_catches", false) then
          return "town"
      end

      if mod.save:get("ban_legendaries", false) and Identity.isLegendarySpecies(game, species) then
          return "legendary"
      end

      if mod.save:get("ban_mythicals", false) and Identity.isMythicalSpecies(game, species) then
          return "mythical"
      end

      if mod.save:get("ban_pseudos", false) and Identity.isPseudoSpecies(game, species) then
          return "pseudo"
      end

      if encounterArmed and mod.save:get("encounter_limit", false)
          and caughtAreas()[key]
          and not (shiny and shinyClause) then
          return "area"
      end

      local encounterState = getEncounterState(key)
      if encounterArmed and mod.save:get("encounter_limit", false)
          and mod.save:get("failed_encounter", true)
          and encounterState and encounterState.status == "FAILED"
          and not (shiny and shinyClause) then
          return "area"
      end

      if isDuplicateSpecies(game, species)
          and not (shiny and shinyClause) then
          return "dupes"
      end

      -- Dupes remains the earlier eligibility decision: an over-limit species
      -- that is also a duplicate should still be treated as a free duplicate
      -- encounter rather than as the area's rejected BST encounter.
      local bstLimit = mod.exports.__beta26.getMaximumBST()
      local bst = bstLimit > 0
          and mod.exports.__beta26.getSpeciesBST(game, species) or nil
      if bst and bst > bstLimit then
          return "bst"
      end

      if mod.save:get("solo_active", false) then
          local party = game.save and game.save.party or {}
          local occupied = 0
          for _, mon in ipairs(party) do
              if mon and mon.species then occupied = occupied + 1 end
          end
          if occupied >= 1 then
              return "solo"
          end
      end

      return nil
  end

  ---------------------------------------------------------------------
  -- ENCOUNTER TYPE
  -- Stored on each Pokemon and tracker entry for Catch Info and history.
  ---------------------------------------------------------------------
  local function encounterTypeFor(ev, key)
      local rawSpecies = ev and (ev.species or (ev.mon and ev.mon.species))
      if rawSpecies ~= nil
          and mod.exports.__beta26.getGlitchSpeciesInfo(
              ev and ev.game or currentGame, rawSpecies).isGlitch then
          return "glitch"
      end
      if ev and mod.exports.__beta26.isStaticEncounter(
          ev.game or currentGame, ev.battle or ev) then return "static" end
      if isOverworldEncounter(ev) then return "overworld" end
      if ev and ev.battle and ev.battle.safari then return "safari" end
      if isTownArea(key, routeName(key)) then return "town" end
      return "wild"
  end

  ---------------------------------------------------------------------
  -- BETA.26 DEFERRED STARTING BALLS
  -- Configured starting Balls are released only after Oak's Pokedex handoff.
  ---------------------------------------------------------------------
  mod.exports.__beta26.releaseDeferredStartingBalls = function(game)
      local save = game and game.save
      if not save or tonumber(game and game.generation) == 2 then return false end
      local amount = math.max(0, math.min(99,
          math.floor(tonumber(save.nuzlockeDeferredStartingBalls) or 0)))
      if amount <= 0 then return false end
      local flags = save.flags
      local gotDex = type(flags) == "table"
          and (flags.EVENT_GOT_POKEDEX == true
               or tonumber(flags.EVENT_GOT_POKEDEX) == 1)
      if not gotDex then return false end

      save.pcItems = save.pcItems or {}
      local have = math.max(0, tonumber(save.pcItems.POKE_BALL) or 0)
      save.pcItems.POKE_BALL = math.min(99, have + amount)
      save.nuzlockeDeferredStartingBalls = nil
      mod.exports.__beta26.encounterRulesArmed(game)
      worldMechanic(game, "starting_balls_released",
          "Your starting Poke Balls are waiting in your PC at home.",
          "Pokedex ready. Your challenge Poke Balls are waiting in your PC at home.",
          "Oak finished the paperwork! Your challenge Poke Balls are waiting in your PC at home.")
      return true
  end

  mod.events:on("world.stepped", function()
      if currentGame then mod.exports.__beta26.releaseDeferredStartingBalls(currentGame) end
  end)

  ---------------------------------------------------------------------
  -- POKEMON CAUGHT
  ---------------------------------------------------------------------
  mod.events:on("pokemon.caught", function(ev)
      if not active(ev.game, ev.battle) then
          return
      end

      local key = areaKey(ev.game, ev.battle)
      if not key then return end
      local encounterMapId = ev.battle and ev.battle.nuzlockeEncounterMapId
          or (activeWildEncounter and activeWildEncounter.encounterMapId)
          or mod.exports.__beta26.currentPhysicalArea(ev.game,
              ev.game and ev.game.save and ev.game.save.player
                  and ev.game.save.player.map)

      local rawSpecies = ev.species or (ev.mon and ev.mon.species)
      if rawSpecies == nil or rawSpecies == "" then return end
      local glitch = mod.exports.__beta26.getGlitchSpeciesInfo(ev.game, rawSpecies)
      local caughtSpecies = glitch.key
      local isShiny = Identity.isShiny(ev.mon)
      local consumesArea = not isShiny
          or mod.save:get("shiny_clause", false) ~= true
      local encounterType = encounterTypeFor(ev, key)

      -- R/B/Y starter acquisition may emit received and caught events on
      -- different Pokemon tables while the player is physically in Oak's Lab.
      -- Pallet Town is the canonical starter encounter slot; never create a
      -- second Oak's Lab tracker row for the same starter.
      if key ~= "PALLET_TOWN" and isStarterSpecies(caughtSpecies) then
          local keyText = tostring(key or ""):upper()
          if keyText:find("OAK", 1, true) or keyText:find("LAB", 1, true) then
              registerStarterCatch(caughtSpecies, ev.mon)
              mod.exports.__beta26.cleanupStarterDuplicate()
              return
          end

          local pallet = trackerLog()["PALLET_TOWN"]
          local sameStarter = false
          if type(pallet) == "table" then
              for _, entry in ipairs(pallet) do
                  if tostring(entry and entry.species or ""):upper() == caughtSpecies then
                      sameStarter = true
                      break
                  end
              end
          end
          if sameStarter and (keyText:find("OAK", 1, true)
              or keyText:find("LAB", 1, true)) then
              if ev.mon then
                  ev.mon.catchLocation = "PALLET_TOWN"
                  ev.mon.encounterType = "gift"
                  ev.mon.nuzlockeTrackerRegistered = true
                  Identity.setPokemonOrigin(ev.mon, "NORMAL")
                  Identity.baselineAdd(ev.mon, "NORMAL")
              end
              return
          end
      end

      -- Snapshot encounter provenance at catch time. This is deliberately
      -- tied to the battle that generated the Pokemon, not to the provider
      -- that happens to be active later in the save.
      local encounterSource = "vanilla"
      local encounterProvider = nil
      local encounterProviderVersion = nil
      local encounterContext = nil
      if activeWildEncounter and activeWildEncounter.battle == ev.battle then
          encounterSource = activeWildEncounter.encounterSource or "vanilla"
          encounterProvider = activeWildEncounter.encounterProvider
          encounterProviderVersion = activeWildEncounter.encounterProviderVersion
          encounterContext = activeWildEncounter.encounterContext
      else
          local provider = activeCompatProvider("encounters", ev.game, ev.battle)
          if provider then
              encounterSource = "provider"
              encounterProvider = provider.id
              encounterProviderVersion = provider.version
              encounterContext = providerContext(provider, ev.game, ev.battle)
          end
      end
      rememberEncounterProvider(encounterProvider, encounterProviderVersion)

      -- Starters/gifts/trades can emit both pokemon.received and
      -- pokemon.caught in the same acquisition flow. Do not log the same mon
      -- twice or overwrite its authoritative received location.
      local alreadyRegistered = ev.mon and ev.mon.nuzlockeTrackerRegistered == true
      if alreadyRegistered then
          markVisited(encounterMapId or key)
          return
      end

      if ev.mon then
          ev.mon.catchLocation = key
          ev.mon.encounterType = encounterType
          ev.mon.nuzlockeEncounterMapId = encounterMapId
          ev.mon.nuzlockeDead = false
          ev.mon.deathCause = nil
          ev.mon.deathCauseText = nil
          ev.mon.nuzlockeTrackerRegistered = true
          ev.mon.nuzlockeGlitch = glitch.isGlitch or nil
          ev.mon.nuzlockeMissingNo = glitch.missingNo or nil
          ev.mon.nuzlockeRawSpecies = glitch.isGlitch and rawSpecies or nil
          Identity.setPokemonOrigin(ev.mon, "NORMAL")
          Identity.baselineAdd(ev.mon, "NORMAL")
          ev.mon.nuzlockeEncounterSource = encounterSource
          ev.mon.nuzlockeEncounterProvider = encounterProvider
          ev.mon.nuzlockeEncounterProviderVersion = encounterProviderVersion
          if encounterContext then ev.mon.nuzlockeEncounterContext = encounterContext end

          local history = mod.save:get("nuzlocke_history", {})
          if type(history) ~= "table" then history = {} end
          table.insert(history, {
              name = ev.mon.nickname or glitch.label,
              species = caughtSpecies,
              rawSpecies = glitch.isGlitch and rawSpecies or nil,
              glitch = glitch.isGlitch or nil,
              missingNo = glitch.missingNo or nil,
              pokemonId = Identity.pokemonIdentity(ev.mon),
              catchLocation = key,
              encounterMapId = encounterMapId,
              encounterType = encounterType,
              encounterSource = encounterSource,
              encounterProvider = encounterProvider,
              encounterProviderVersion = encounterProviderVersion,
              encounterContext = encounterContext,
              status = "ALIVE",
          })
          mod.save:set("nuzlocke_history", history)
      end

      markVisited(encounterMapId or key)
      markEncounterCaught(key, caughtSpecies, encounterType, encounterMapId,
          consumesArea)
      if activeWildEncounter and activeWildEncounter.key == key then
          activeWildEncounter.resolved = true
      end

      local log = trackerLog()
      log[key] = log[key] or {}

      -- Never append the same species twice to one area. This is especially
      -- important for acquisition flows where the engine can emit both a
      -- received event and a caught event on separate Pokemon tables.
      local duplicate = false
      local speciesKey = caughtSpecies
      local caughtId = ev.mon and Identity.ensurePokemonIdentity(ev.mon, ev.game and ev.game.save, "NORMAL") or nil
      for _, entry in ipairs(log[key]) do
          local entryId = entry and entry.pokemonId
          if caughtId and entryId then
              duplicate = tostring(entryId) == tostring(caughtId)
          elseif tostring(entry and entry.species or ""):upper() == speciesKey then
              -- Compatibility fallback for a pre-beta.19 tracker row.
              duplicate = true
              if caughtId and entry then entry.pokemonId = caughtId end
          end
          if duplicate then break end
      end

      if not duplicate then
          table.insert(log[key], {
              species = caughtSpecies,
              rawSpecies = glitch.isGlitch and rawSpecies or nil,
              glitch = glitch.isGlitch or nil,
              missingNo = glitch.missingNo or nil,
              pokemonId = caughtId,
              fingerprint = ev.mon and Identity.fingerprint(ev.mon) or nil,
              isShiny = isShiny,
              consumedArea = consumesArea,
              encounterType = encounterType,
              encounterMapId = encounterMapId,
              encounterSource = encounterSource,
              encounterProvider = encounterProvider,
              encounterProviderVersion = encounterProviderVersion,
              encounterContext = encounterContext,
              provenance = "NORMAL"
          })
          mod.save:set("tracker_log", log)
      end

      -- Only successful eligible catches consume the area's encounter.
      if consumesArea then
          if mod.save:get("encounter_limit", false) then
              markCaught(key, caughtSpecies)
          end
      end

      if isShiny and mod.save:get("shiny_clause", false) == true then
          worldMechanic(ev.game, "shiny:" .. tostring(ev.mon and (ev.mon.nickname or ev.mon.species) or ev.species),
              "SHINY!\nThe Shiny Clause says this one gets a pass.",
              "Whoa. SHINY!\nThe rules can wait for this one.",
              "Even the Nuzlocke gods make exceptions for sparkle.")
      else
          local displaySpecies = ev.mon and ev.mon.nickname or glitch.label
          worldMechanic(ev.game, "catch:" .. tostring(key) .. ":" .. caughtSpecies,
              Strings("FIRST ENCOUNTER!\n%s joins the run.", tostring(displaySpecies)),
              "New teammate acquired.\nDon't get attached. You know the rules.",
              Strings("%s is officially part of the story now.",
                  tostring(routeName(key))))
      end
  end)

  -- NOTE: Legendary and Mythical catch blocking is enforced entirely at the
  -- throwBall level via catchDeniedReason. The engine refunds the ball and
  -- the catch never registers, so no post-catch removal is needed here.
  -- A secondary removal would incorrectly consume the ball without refund.

  ---------------------------------------------------------------------
  -- WHITEOUT STATE
  ---------------------------------------------------------------------
  local function hasHealthyParty(game)
      local party = game and game.save and game.save.party or {}
      for _, mon in ipairs(party) do
          if mon then
              local hp = tonumber(mon.hp or mon.currentHp or mon.health)
              if hp ~= nil then
                  if hp > 0 then return true end
              elseif mon.fainted ~= true and mon.status ~= "fainted" then
                  return true
              end
          end
      end
      return false
  end

  ---------------------------------------------------------------------
  -- PERMADEATH / WHITEOUT ENFORCEMENT
  --
  -- Use BattleState:onFaint itself, following Bryan's implementation seam.
  -- This is important because the battle's own faint lifecycle is the point
  -- where the last usable party member is determined. The previous event-only
  -- implementation could lose the race with the vanilla blackout/restore
  -- flow, which is why a trainer loss could appear to revive the party.
  ---------------------------------------------------------------------
  mod.events:on("game.ready", function()
      local ok, BattleState = pcall(require, "src.battle.BattleState")
      local okRuntime, Runtime = pcall(require, "src.mods.Runtime")
      local okScreens, Screens = pcall(require, "src.ui.Screens")
      local okSave, SaveData = pcall(require, "src.core.SaveData")
      local okVersion, GameVersion = pcall(require, "src.core.GameVersion")

      if not ok or type(BattleState) ~= "table"
          or type(BattleState.onFaint) ~= "function"
          or type(BattleState.playerMonFainted) ~= "function"
          or type(BattleState.finish) ~= "function" then
          return
      end
      if BattleState.__nuzlockeFinal25FaintPatched then return end
      BattleState.__nuzlockeFinal25FaintPatched = true

      -------------------------------------------------------------------
      -- Capture the final damaging move exactly where Gen 1 computes it.
      -- Damage.compute returns { crit = bool }, so the death record can
      -- report a real critical hit instead of guessing.
      -------------------------------------------------------------------
      if not BattleState.__nuzlockeDamagePatched
          and type(BattleState.computeDamage) == "function" then
          BattleState.__nuzlockeDamagePatched = true
          local vanillaComputeDamage = BattleState.computeDamage
          BattleState.computeDamage = function(self, user, target, move, opts)
              local damage, result = vanillaComputeDamage(self, user, target, move, opts)
              if target and target.isPlayer and tonumber(damage) and damage > 0 then
                  self.nuzlockeLastDamage = {
                      target = target,
                      attacker = user,
                      move = move and (move.name or move.id) or "UNKNOWN",
                      moveId = move and move.id,
                      critical = result and result.crit == true or false,
                  }
              end
              return damage, result
          end
      end

      -------------------------------------------------------------------
      -- Status/residual deaths are recorded before BattleState:onFaint is
      -- reached, so poison/burn/Leech Seed can be distinguished from the
      -- previous damaging move.
      -------------------------------------------------------------------
      local okStatus, StatusModule = pcall(require, "src.battle.Status")
      if okStatus and type(StatusModule) == "table"
          and type(StatusModule.residual) == "function"
          and not StatusModule.__nuzlockeDeathStatusPatched then
          StatusModule.__nuzlockeDeathStatusPatched = true
          local vanillaResidual = StatusModule.residual
          StatusModule.residual = function(battler, opponent, battle, ...)
              local before = battler and battler.mon and tonumber(battler.mon.hp) or nil
              local result = vanillaResidual(battler, opponent, battle, ...)
              if battler and battler.isPlayer and battler.mon then
                  local after = tonumber(battler.mon.hp)
                  if before and after and before > 0 and after <= 0 then
                      local status = tostring(battler.mon.status or "")
                      local label = nil
                      if status == "POISON" or status == "PSN" or status == "BADLY_POISONED" or status == "TOX" then
                          label = "POISON"
                      elseif status == "BURN" or status == "BRN" then
                          label = "BURN"
                      elseif battler.leechSeeded then
                          label = "LEECH SEED"
                      end
                      battle.nuzlockeLastResidual = label or "STATUS DAMAGE"
                  end
              end
              return result
          end
      end

      local vanillaOnFaint = BattleState.onFaint
      BattleState.onFaint = function(self, battler)
          if not (battler and battler.isPlayer and active(self.game, self)) then
              return vanillaOnFaint(self, battler)
          end

          -- The opening Rival exception leaves the native faint/loss flow
          -- intact but skips every Nuzlocke-owned death and Whiteout mutation.
          -- This applies to all player Pokemon in that one battle only.
          if mod.exports.__beta26.isFirstRivalForgivenessActive(
              self.game, self) then
              if battler.mon then battler.mon.nuzlockeRivalForgiven = true end
              self.nuzlockeRivalForgivenessTriggered = true
              return vanillaOnFaint(self, battler)
          end

          if mod.save:get("permadeath", true) then
              local mon = battler.mon
              if mon and not mon.nuzlockeDead then
                  local key = areaKey(self.game, self)
                  local enemy = self.enemy and self.enemy.mon
                  local enemyName = self.enemy and self.enemy.name
                  local enemySpecies = enemyName or (enemy and enemy.species) or "BATTLE"
                  local source = "Wild " .. tostring(enemySpecies)
                  local trainerName = self.trainer and self.trainer.name
                  local oppClass = tostring(self.oppClass or "")

                  if self.kind == "trainer" then
                      local upperClass = oppClass:upper()
                      if upperClass:find("RIVAL", 1, true) then
                          source = "Your Rival " .. tostring(trainerName or "BLUE") .. "'s " .. tostring(enemySpecies)
                      elseif upperClass:find("BROCK", 1, true)
                          or upperClass:find("MISTY", 1, true)
                          or upperClass:find("LT_SURGE", 1, true)
                          or upperClass:find("ERIKA", 1, true)
                          or upperClass:find("KOGA", 1, true)
                          or upperClass:find("SABRINA", 1, true)
                          or upperClass:find("BLAINE", 1, true)
                          or upperClass:find("GIOVANNI", 1, true) then
                          source = "Gym Leader " .. tostring(trainerName or oppClass) .. "'s " .. tostring(enemySpecies)
                      elseif upperClass:find("LORELEI", 1, true)
                          or upperClass:find("BRUNO", 1, true)
                          or upperClass:find("AGATHA", 1, true)
                          or upperClass:find("LANCE", 1, true) then
                          source = "Elite Four " .. tostring(trainerName or oppClass) .. "'s " .. tostring(enemySpecies)
                      elseif upperClass:find("ROCKET", 1, true) then
                          source = "Team Rocket " .. tostring(trainerName or "Trainer") .. "'s " .. tostring(enemySpecies)
                      elseif trainerName then
                          source = tostring(trainerName) .. "'s " .. tostring(enemySpecies)
                      else
                          source = "Trainer's " .. tostring(enemySpecies)
                      end
                  end

                  local damage = self.nuzlockeLastDamage
                  local glitch = mod.exports.__beta26.getGlitchSpeciesInfo(
                      self.game, mon.species)
                  local monLabel = tostring(mon.nickname or glitch.label or "Pokemon")
                  local causeText
                  if self.nuzlockeLastResidual then
                      causeText = monLabel
                          .. " died to " .. source
                          .. " after " .. tostring(self.nuzlockeLastResidual) .. "."
                  elseif damage and damage.target == battler then
                      local moveName = tostring(damage.move or "UNKNOWN")
                      local critPrefix = damage.critical and "a critical " or ""
                      if damage.attacker == battler then
                          causeText = monLabel
                              .. " died after " .. critPrefix .. moveName .. "."
                      else
                          causeText = monLabel
                              .. " died to " .. source
                              .. " after " .. critPrefix .. moveName .. "."
                      end
                  else
                      causeText = monLabel
                          .. " died in battle against " .. source .. "."
                  end

                  mon.nuzlockeDead = true
                  mon.deathLocation = key
                  mon.deathCause = causeText
                  mon.deathCauseText = causeText
                  mon.deathEncounterType =
                      (self.kind == "trainer") and "trainer" or "wild"
                  mon.deathOpponentSpecies = enemySpecies
                  mon.deathMove = damage and damage.move or nil
                  mon.deathCritical = damage and damage.critical == true or false
                  mon.deathStatusCondition = self.nuzlockeLastResidual

                  local history = mod.save:get("nuzlocke_history", {})
                  if type(history) ~= "table" then history = {} end
                  table.insert(history, {
                      name = mon.nickname or glitch.label,
                      species = glitch.key,
                      rawSpecies = glitch.isGlitch and mon.species or nil,
                      glitch = glitch.isGlitch or nil,
                      missingNo = glitch.missingNo or nil,
                      pokemonId = Identity.ensurePokemonIdentity(mon, currentSave, mon.nuzlockeOrigin or "NORMAL"),
                      catchLocation = mon.catchLocation,
                      encounterType = mon.encounterType,
                      status = "LOST",
                      deathLocation = key,
                      deathCause = causeText,
                      deathOpponentSpecies = enemySpecies,
                      deathMove = mon.deathMove,
                      deathCritical = mon.deathCritical,
                      deathStatusCondition = mon.deathStatusCondition,
                  })
                  mod.save:set("nuzlocke_history", history)

                  mod.save:set(
                      "nuzlocke_losses",
                      (tonumber(mod.save:get("nuzlocke_losses", 0)) or 0) + 1
                  )

                  mod.save:set("last_loss", {
                      name = mon.nickname or glitch.label,
                      species = glitch.key,
                      rawSpecies = glitch.isGlitch and mon.species or nil,
                      glitch = glitch.isGlitch or nil,
                      missingNo = glitch.missingNo or nil,
                      pokemonId = Identity.pokemonIdentity(mon),
                      location = key,
                      cause = causeText,
                  })

                  worldMechanic(self.game, "death:" .. monLabel .. ":" .. tostring(key),
                      Strings("%s has fallen.\nThe Nuzlocke remembers.", monLabel),
                      "Ouch. Another one bites the dust.\nYou knew the rules.",
                      Strings("RIP, %s.\nKanto won't forget what happened here.",
                          monLabel))

                  -- Remove the dead mon before vanilla's playerMonFainted()
                  -- checks for a usable party. This prevents the normal
                  -- blackout routine from healing/restoring a dead member.
                  if self.game and self.game.save and self.game.save.party then
                      for i, partyMon in ipairs(self.game.save.party) do
                          if partyMon == mon then
                              table.remove(self.game.save.party, i)
                              break
                          end
                      end
                  end
              end

          end

          -- These are transient battle facts, not Permadeath state. Clear them
          -- after every player faint so toggling rules cannot reuse stale data.
          self.nuzlockeLastDamage = nil
          self.nuzlockeLastResidual = nil

          -- Whiteout is an independent rule: with Permadeath OFF a full party
          -- faint still ends the run; with Permadeath ON removed dead Pokemon
          -- naturally produce the same result.
          if mod.save:get("whiteout_clause", false)
              and not hasHealthyParty(self.game) then
              self.nuzlockeGameOver = true
          end

          -- Preserve the engine's normal faint animation, cry, text, and
          -- battle queue. We only alter the save/party state before it runs.
          return vanillaOnFaint(self, battler)
      end

      local vanillaPlayerFainted = BattleState.playerMonFainted
      BattleState.playerMonFainted = function(self)
          if self.nuzlockeGameOver then
              -- Keep the public battle result inside the engine's standard
              -- result vocabulary. The separate flag owns Nuzlocke teardown.
              self.result = "lose"
              self.afterQueue = "finish"
              -- Try every known message API in priority order.
              local msg = Strings("All of your\nPOKeMON are dead...\nYour run is over.")
              if worldTier(self.game) >= 3 then
                  local losses = tonumber(mod.save:get("nuzlocke_losses", 0)) or 0
                  msg = Strings("NUZLOCKE OVER\n%d POKéMON lost.\nThe League will remember.",
                      losses)
              end
              if type(self.sayNext) == "function" then
                  pcall(self.sayNext, self, msg)
              elseif type(self.say) == "function" then
                  pcall(self.say, self, msg)
              elseif type(self.message) == "function" then
                  pcall(self.message, self, msg)
              end
              return
          end
          return vanillaPlayerFainted(self)
      end

      -- Whiteout is still a Nuzlocke-specific run-ending flow, but battle
      -- teardown itself belongs to the engine. Call through the already-wrapped
      -- finish() chain so Mimic restoration, low-health alarm shutdown, map
      -- music restoration, stack pop, battle.ended, and our catch finalizer all
      -- execute exactly once. Suppress only onFinish so vanilla's normal
      -- blackout/heal-point warp does not run before we delete the ended run.
      local vanillaFinish = BattleState.finish
      BattleState.finish = function(self)
          if not self.nuzlockeGameOver then
              return vanillaFinish(self)
          end

          self.nuzlockeGameOver = nil
          self.nuzlockeRunEnded = true
          self.result = "lose"

          local savedOnFinish = self.onFinish
          self.onFinish = nil
          local finishOk = pcall(vanillaFinish, self)
          self.onFinish = savedOnFinish

          -- battle.ended has now run. A composable format mod may have restored
          -- healthy reserve Pokemon that were temporarily outside the battle
          -- party. Re-prune any restored dead Pokemon, then re-evaluate the
          -- destructive Whiteout decision against the real post-battle party.
          -- If a healthy reserve exists, this was an ordinary battle loss, not
          -- a Nuzlocke Whiteout: resume the engine's normal loss callback once.
          if finishOk then
              pruneRestoredDeadPokemon(self.game)
              if hasHealthyParty(self.game) then
                  self.nuzlockeRunEnded = nil
                  if savedOnFinish then pcall(savedOnFinish, "lose") end
                  return
              end
          end

          if not finishOk then
              -- Defensive fallback for an engine/API mismatch. Only reproduce
              -- the minimum teardown needed to avoid leaving a dead battle on
              -- the stack; do not synthesize a second public event if vanilla
              -- already managed to emit one before throwing.
              if type(finalizeNuzlockeBattle) == "function" then
                  pcall(finalizeNuzlockeBattle, self, "lose")
              end
              if self.game and self.game.stack
                  and self.game.stack.top and self.game.stack:top() == self then
                  pcall(function() self.game.stack:pop() end)
              end
          end

          local function showCreditsAndTitle()
              if okScreens and Screens then
                  local ending = Screens.push(self.game, "Credits", function()
                      local musicOk, Music = pcall(require, "src.core.Music")
                      if musicOk and Music then Music.stop() end
                      while self.game.stack:top() do self.game.stack:pop() end
                      if self.game.makeTitleState then
                          self.game.stack:push(self.game:makeTitleState())
                      end
                  end)
                  if ending then ending.phase, ending.timer = "end_wait", 0 end
              end
          end

          local function deleteCurrentRunSave()
              if not (okSave and SaveData) then
                  return false, "SaveData unavailable"
              end

              local version = self.game and self.game.save
                  and self.game.save.version or nil
              if okVersion and GameVersion
                  and type(GameVersion.get) == "function" then
                  local okGet, detected = pcall(GameVersion.get)
                  if okGet and detected ~= nil then version = detected end
              end
              if version == nil then
                  return false, "game version unavailable"
              end

              -- Capture the exact current path before deleteSlot changes the
              -- active-slot registry to a different surviving slot.
              local mainName
              if type(SaveData.saveFilename) == "function" then
                  local okName, value = pcall(SaveData.saveFilename, version)
                  if okName and type(value) == "string" and value ~= "" then
                      mainName = value
                  end
              end

              local slot
              if type(SaveData.activeSlot) == "function" then
                  local okSlot, value = pcall(SaveData.activeSlot, version)
                  if okSlot then slot = value end
              end

              local deleted = false
              local detail

              if slot and type(SaveData.deleteSlot) == "function" then
                  local okDelete, result, err =
                      pcall(SaveData.deleteSlot, version, slot)
                  if okDelete and result == true then
                      deleted = true
                  else
                      detail = tostring(err or result or "slot delete failed")
                  end
              end

              -- activeSlot() may legitimately be nil for an unmigrated legacy
              -- flat save. This fallback also handles a registered slot whose
              -- registry delete failed: remove only the path captured above.
              if mainName and type(SaveData.persistenceFs) == "function" then
                  local okFs, fs = pcall(SaveData.persistenceFs)
                  if okFs and fs and type(fs.remove) == "function" then
                      pcall(fs.remove, mainName)
                      pcall(fs.remove, mainName .. ".bak")
                      pcall(fs.remove, mainName .. ".tmp")

                      if type(fs.getInfo) == "function" then
                          local okInfo, info = pcall(fs.getInfo, mainName)
                          if okInfo and info == nil then deleted = true end
                      elseif not slot then
                          -- Best effort for older persistence adapters that
                          -- expose remove but not getInfo.
                          deleted = true
                      end
                  end
              end

              return deleted, detail
          end

          local function deleteSaveAndShowTitle()
              local deleted, deleteError = deleteCurrentRunSave()
              if not deleted then
                  local okText, TextBox = pcall(require, "src.render.TextBox")
                  if okText and TextBox and self.game and self.game.stack then
                      local message = Strings("SAVE DELETE FAILED.\nThis Nuzlocke run is over.\nDelete the save manually.")
                      if deleteError and deleteError ~= "" then
                          message = message .. "\n" .. tostring(deleteError)
                      end
                      self.game.stack:push(TextBox.new(self.game, message,
                          function() showCreditsAndTitle() end))
                      return
                  end
              end
              showCreditsAndTitle()
          end

          if worldTier(self.game) >= 3 then
              local losses = tonumber(mod.save:get("nuzlocke_losses", 0)) or 0
              local catches = countTrackerCatches()
              local badges = currentBadgeCount(self.game.save)
              local last = mod.save:get("last_loss", {}) or {}
              local lastName = tostring(last.name or "NONE")
              local lastLoc = routeName(last.location or "UNKNOWN")
              local summary = Strings("NUZLOCKE OVER\nBADGES: %d\nCAUGHT: %d  LOST: %d\nLAST LOSS: %s\n%s",
                  badges, catches, losses, lastName, lastLoc)
              local okText, TextBox = pcall(require, "src.render.TextBox")
              if okText and TextBox and self.game and self.game.stack then
                  self.game.stack:push(TextBox.new(self.game, summary, function()
                      deleteSaveAndShowTitle()
                  end))
                  return
              end
          end

          deleteSaveAndShowTitle()
      end
  end)

  ---------------------------------------------------------------------
  -- POKé MART / POKéMON CENTER ENFORCEMENT
  --
  -- Install the live command patch as soon as the command module is
  -- available, and retry on save.loaded/game.ready.  This avoids the
  -- previous failure mode where the map scripts had already cached their
  -- command resolver before the one-time game.ready patch ran.
  ---------------------------------------------------------------------
  local function installNuzlockeFieldCommandPatches()
      if mod.exports.__beta26.isSaveEditorSession() then return true end
      if mod.exports.__beta26.runtimeIsGold(currentGame or mod.game) then
          return true
      end
      local Commands = mod.exports.__beta26.rbyCommandsFor(currentGame or mod.game)
      if not Commands then return false end

      local priorSession = Commands.__nuzlockeRulesSession
      if type(priorSession) == "table" and priorSession.owner == mod then
          return true
      end
      if type(priorSession) == "table" and priorSession.owner ~= mod then
          for name, rec in pairs(priorSession.methods or {}) do
              if type(rec) == "table" and Commands[name] == rec.wrapper
                  and type(rec.previous) == "function" then
                  Commands[name] = rec.previous
              end
          end
      end

      local sessionMethods = {}
      local originalHeal = Commands.heal_party
      local originalFade = Commands.fade
      local originalTrade = Commands.trade
      local originalGivePokemon = Commands.give_pokemon
      local originalStaticBattle = Commands.static_battle
      if type(originalHeal) ~= "function" then
          return false
      end

      local function showRuleMessage(ctx, msg)
          msg = mod.exports.__beta26.cleanWorldText(msg)
          local shown = false
          if type(Commands.show_text) == "function" then
              local ok = pcall(Commands.show_text, ctx, msg)
              shown = ok
          elseif type(Commands.text) == "function" then
              local ok = pcall(Commands.text, ctx, msg)
              shown = ok
          elseif type(Commands.message) == "function" then
              local ok = pcall(Commands.message, ctx, msg)
              shown = ok
          end

          if not shown then
              local game = ctx and (ctx.game or (ctx.env and ctx.env.game))
              if game and game.stack then
                  local okText, TextBox = pcall(require, "src.render.TextBox")
                  if okText and TextBox then
                      pcall(function()
                          game.stack:push(TextBox.new(game, msg))
                      end)
                  end
              end
          end
      end

      -- Hook callbacks run inside the hook bus's protected call, so they must
      -- not yield.  Push the TextBox directly here; the hook returns "end"
      -- and the script is finished underneath it.
      local function showRuleMessageImmediate(ctx, msg)
          msg = mod.exports.__beta26.cleanWorldText(msg)
          local game = ctx and (ctx.game or (ctx.env and ctx.env.game))
          if not game or not game.stack then return end
          local okText, TextBox = pcall(require, "src.render.TextBox")
          if okText and TextBox then
              pcall(function()
                  game.stack:push(TextBox.new(game, msg))
              end)
          end
      end

      local function acquisitionDeniedMessage(kind, reason, area)
          local areaName = routeName(area or "UNKNOWN")
          if reason == "disabled" then
              return kind == "trade"
                  and Strings("IN-GAME TRADES are disabled\nby your Nuzlocke rules.")
                  or Strings("GIFT POKéMON are disabled\nby your Nuzlocke rules.")
          elseif reason == "area" then
              return Strings("Encounter already used!\n%s", tostring(areaName))
          elseif reason == "solo" then
              return Strings("SOLO ONLY is active.\nYour party already has a Pokemon.")
          elseif reason == "legendary" then
              return Strings("Legendary Pokemon are banned\nby your Nuzlocke rules.")
          elseif reason == "mythical" then
              return Strings("Mythical Pokemon are banned\nby your Nuzlocke rules.")
          elseif reason == "pseudo" then
              return Strings("Pseudo-legendary Pokemon are banned\nby your Nuzlocke rules.")
          elseif reason == "bst" then
              return Strings("This Pokemon exceeds\nyour Maximum BST.")
          elseif reason == "glitch" then
              return Strings("Glitch Pokemon are blocked\nby your Nuzlocke rules.")
          end
          return Strings("This Pokemon is blocked\nby your Nuzlocke rules.")
      end

      -- Native in-game trade gate. The engine's Commands.trade removes the
      -- selected outgoing Pokemon and creates the incoming Pokemon in one
      -- transaction. Reject before calling it; never try to reconstruct the
      -- outgoing Pokemon afterward.
      local function nuzlockeTrade(ctx, tradeIndex, doneFlag)
          if type(originalTrade) ~= "function" then return end

          local game = ctx and ctx.game
          local trade = game and game.data and game.data.field
              and game.data.field.trades
              and game.data.field.trades[tradeIndex]
          if not trade or not active(game, nil) then
              return originalTrade(ctx, tradeIndex, doneFlag)
          end

          local receivedSpecies = tostring(trade.get or ""):upper()
          local area = currentSpecialArea(game, receivedSpecies, "trade")
          local denied = specialAcquisitionDenied(
              game, receivedSpecies, area, "trade")

          if denied then
              showRuleMessage(ctx,
                  acquisitionDeniedMessage("trade", denied, area))
              return
          end

          -- Snapshot object identities before the transaction. Commands.trade
          -- creates a fresh Pokemon table for the received mon.
          local before = {}
          for _, mon in ipairs(ctx.save and ctx.save.party or {}) do
              before[mon] = true
          end

          local result = originalTrade(ctx, tradeIndex, doneFlag)

          local received
          for _, mon in ipairs(ctx.save and ctx.save.party or {}) do
              if not before[mon]
                  and tostring(mon and mon.species or ""):upper()
                      == receivedSpecies then
                  received = mon
                  break
              end
          end

          if received then
              mod.exports.__beta26.StatRules.applyPlayer(game, received)
              registerSpecialCatch(receivedSpecies, area, "trade", received)
          end
          return result
      end

      -- Native scripted gift gate. give_pokemon mutates party/boxes and many
      -- giver scripts set one-time flags afterward, so reject before entering
      -- the vanilla command. Starters are deliberately exempt.
      local function nuzlockeGivePokemon(ctx, species, level, skipNickname)
          if type(originalGivePokemon) ~= "function" then return end
          local game = ctx and ctx.game
          if not active(game, nil) then
              return originalGivePokemon(ctx, species, level, skipNickname)
          end

          local sp = tostring(species or ""):upper()
          local loc = areaKey(game, nil)
          local locText = tostring(loc or ""):upper()
          local starterLocation = loc == "PALLET_TOWN"
              or locText:find("OAK", 1, true) ~= nil
              or locText:find("LAB", 1, true) ~= nil
          local starter = starterLocation
              and (isStarterSpecies(sp)
                  or (getGameVersion() == "YELLOW" and sp == "PIKACHU"))

          if not starter then
              local area = currentSpecialArea(game, sp, "gift")
              local denied = specialAcquisitionDenied(game, sp, area, "gift")
              if denied then
                  -- Match give_pokemon's failure contract so scripts that check
                  -- carry/lastCheck do not burn their one-time completion flag.
                  ctx.lastCheck = false
                  showRuleMessage(ctx,
                      acquisitionDeniedMessage("gift", denied, area))
                  return
              end
          end

          -- Snapshot object identities before the transaction so we can find
          -- the exact new Pokemon even when the engine reports Oak's Lab as
          -- the physical map. This is also the reliable seam for mandatory
          -- starter/gift nicknames in current Gen1Recomp.
          local before = {}
          for _, mon in ipairs(ctx.save and ctx.save.party or {}) do before[mon] = true end
          for _, box in ipairs(ctx.save and ctx.save.boxes or {}) do
              for _, mon in ipairs(box or {}) do before[mon] = true end
          end

          local forceNickname = mod.save:get("nickname_rule", false) == true
              and ctx and ctx.runner ~= nil
          -- Suppress vanilla AskName's YES/NO prompt when the rule is active;
          -- after the Pokemon exists we open the naming screen directly and
          -- keep reopening it until at least one character is entered.
          local result = originalGivePokemon(ctx, species, level,
              forceNickname and true or skipNickname)
          if forceNickname then
              -- Vanilla AskName normally consumes this temporary substitution
              -- token. We skipped that YES/NO box, so clear it here before a
              -- later unrelated script text can accidentally inherit it.
              ctx.pendingPokemonName = nil
          end

          if ctx.lastCheck ~= true then return result end

          local received
          for _, mon in ipairs(ctx.save and ctx.save.party or {}) do
              if not before[mon] and (starter
                  or tostring(mon and mon.species or ""):upper() == sp) then
                  received = mon; break
              end
          end
          if not received then
              for _, box in ipairs(ctx.save and ctx.save.boxes or {}) do
                  for _, mon in ipairs(box or {}) do
                      if not before[mon] and (starter
                          or tostring(mon and mon.species or ""):upper() == sp) then
                          received = mon; break
                      end
                  end
                  if received then break end
              end
          end

          if received then
              mod.exports.__beta26.StatRules.applyPlayer(game, received)
              local actualSpecies = tostring(received.species or sp):upper()
              if starter then
                  registerStarterCatch(actualSpecies, received)
                  mod.exports.__beta26.cleanupStarterDuplicate()
              else
                  local area = currentSpecialArea(game, sp, "gift")
                  registerSpecialCatch(sp, area, "gift", received)
              end

              if forceNickname and type(Commands.push_screen) == "function" then
                  local nick = ""
                  repeat
                      Commands.push_screen(ctx, "NamingScreen", {
                          title = "NICKNAME?", maxLen = 10,
                          onDone = function(name) nick = tostring(name or "") end,
                      })
                  until nick ~= ""
                  received.nickname = nick
                  received.nuzlockeNeedsNickname = nil
                  received.nuzlockeNicknameRequired = nil
                  mod.exports.__beta26.syncHistoryNickname(received)
              end
          end
          return result
      end

      -- Commands.static_battle is the canonical R/B/Y fixed-wild seam. Keep
      -- its coroutine behavior untouched and carry only provenance across to
      -- battle.started, where the actual battle object becomes available.
      local function nuzlockeStaticBattle(ctx, species, level, beatFlag)
          if type(originalStaticBattle) ~= "function" then return end
          mod.exports.__beta26.pendingStaticEncounter = {
              generation = 1,
              species = species,
              level = level,
          }
          local result = originalStaticBattle(ctx, species, level, beatFlag)
          -- battle.started normally consumes this immediately. Clearing here
          -- also prevents a stale marker if an alternate engine skips battle.
          mod.exports.__beta26.pendingStaticEncounter = nil
          return result
      end

      if type(originalStaticBattle) == "function" then
          Commands.static_battle = nuzlockeStaticBattle
          sessionMethods.static_battle = {
              previous = originalStaticBattle, wrapper = nuzlockeStaticBattle,
          }
      end

  ---------------------------------------------------------------------
  -- AUTHORITATIVE SCRIPT-COMMAND HEAL GATE
  --
  -- The recomp's ScriptRunner resolves every script row through the live
  -- Runtime "script.command" hook. Mom's R/B/Y house script uses
  -- heal_party directly. Pokemon Centers use a separate overworld nurse path
  -- and are gated below; the Center test here remains only as a compatibility
  -- fallback for builds that route healing through the script command table.
  ---------------------------------------------------------------------
  local function nuzlockeMapTag(ctx)
      local ow = (ctx and ctx.overworld)
          or (currentGame and currentGame.overworld)
      local map = ow and ow.map
      local def = map and map.def
      local parts = {
          map and map.id,
          map and map.name,
          def and def.id,
          def and def.name,
          def and def.label,
      }
      local out = {}
      for _, value in ipairs(parts) do
          if value ~= nil then
              out[#out + 1] = tostring(value):upper()
          end
      end
      return table.concat(out, " ")
  end

  local function isPokemonCenterMap(ctx)
      local tag = nuzlockeMapTag(ctx)
      return (tag:find("POKEMON", 1, true) and tag:find("CENTER", 1, true))
          or (tag:find("POKE", 1, true) and tag:find("CENTER", 1, true))
  end

  local function isMomsHouseMap(ctx)
      local tag = nuzlockeMapTag(ctx)
      return tag:find("REDS_HOUSE", 1, true) ~= nil
          or tag:find("REDSHOUSE", 1, true) ~= nil
  end

  local nuzlockeScriptHealGateInstalled = false
  local function installNuzlockeScriptHealGate()
      if nuzlockeScriptHealGateInstalled then return end
      nuzlockeScriptHealGateInstalled = true

      mod.hooks:wrap("script.command", function(next, ctx, name, args)
          -- beta.26.3: when Mom healing is allowed, replace the final vanilla
          -- "looking great" beat with one T3 home-flavor line once per save.
          -- Later allowed heals keep vanilla dialogue, preventing repeated T3
          -- Mom chatter from stacking on every visit.
          if name == "show_text" and isMomsHouseMap(ctx)
              and worldTier(ctx and ctx.game) >= 3
              and mod.save:get("no_mom_heal", false) ~= true then
              local textId = type(args) == "table"
                  and (args[1] or args.textId or args.text) or args
              if tostring(textId or "") == "_RedsHouse1FMomLookingGreatText" then
                  local flags = worldFlags()
                  if not flags["mom_allowed_heal_t3"] then
                      flags["mom_allowed_heal_t3"] = true
                      mod.save:set("nuzlocke_world_flags", flags)
                      showRuleMessageImmediate(ctx,
                          "Mom: There we go!\nYour team looks great.\nNow be careful out\nthere, sweetheart!")
                      return "end"
                  end
              end
          end

          -- Own Mom's blocked-heal interaction from the first post-starter
          -- rest line. Gen1Recomp's RedsHouse1F script uses the exact
          -- _RedsHouse1FMomYouShouldRestText row immediately before fade ->
          -- heal_party. Replacing that row and ending the script prevents the
          -- vanilla "take a rest" text from playing before our refusal.
          if name == "show_text"
              and mod.exports.__beta26.ruleActive(ctx and ctx.game, "no_mom_heal")
              and isMomsHouseMap(ctx) then
              local textId = type(args) == "table"
                  and (args[1] or args.textId or args.text) or args
              if tostring(textId or "") == "_RedsHouse1FMomYouShouldRestText" then
                  local tier = worldTier(ctx and ctx.game)
                  local msg = tier >= 3
                      and "Mom: No rest stop this time, sweetheart.\nYour challenge says the team keeps moving.\nBe careful out there!"
                      or (tier >= 2
                          and "Mom: Nice try, sweetheart.\nYour Nuzlocke says no free healing today."
                          or "Mom can't heal your Pokemon while No Mom Heal is ON.")
                  showRuleMessageImmediate(ctx, msg)
                  return "end"
              end
          end

          -- Mom's vanilla heal script fades to white immediately before
          -- heal_party.  If healing is disabled, suppress both fades so the
          -- personalized refusal is shown on the normal room screen.
          if name == "fade"
              and mod.exports.__beta26.ruleActive(ctx and ctx.game, "no_mom_heal")
              and isMomsHouseMap(ctx) then
              return
          end

          if name == "heal_party" then
              if mod.exports.__beta26.ruleActive(ctx and ctx.game, "no_mom_heal")
                  and isMomsHouseMap(ctx) then
                  -- Mom's vanilla script fades to white immediately before
                  -- heal_party.  This hook runs at heal_party, so skip the
                  -- remainder and replace the heal with Mom's own message.
                  showRuleMessageImmediate(ctx, worldTier(ctx.game) >= 2
                      and "Mom: Nice try, sweetheart.\nThe Nuzlocke says I can't heal you.\nI believe in you!"
                      or "Mom: I know you need\nrest, sweetheart, but\nour Nuzlocke rules say\nI can't heal your\nPokemon right now.\nYou'll be okay!")
                  return "end"
              end

              if mod.exports.__beta26.ruleActive(ctx and ctx.game, "no_poke_center")
                  and isPokemonCenterMap(ctx) then
                  showRuleMessageImmediate(ctx, worldTier(ctx.game) >= 2
                      and "Nurse Joy: Sorry!\nYour Nuzlocke says no healing here.\nTake care of that team!"
                      or "Nurse Joy: I'm sorry,\nbut your Nuzlocke\nrules don't allow\nPokemon Center\nhealing right now.")
                  return "end"
              end
          end

          return next(ctx, name, args)
      end, 10000)
  end

  ---------------------------------------------------------------------
  -- RED'S HOUSE 1F TV - TIER 3 WORLD BUILDING
  --
  -- Gen1Recomp dispatches hidden/background interactions through the
  -- map_scripts compose chain. onInteract handlers run in priority order and
  -- the first truthy result consumes the interaction, so this contribution
  -- handles only the actual TV tile (3,1) at T3 and returns false everywhere
  -- else. That preserves the engine's vanilla TV at T0-T2 and every non-TV
  -- interaction. Keep this nested in the existing install section instead of
  -- adding another top-level helper; the large main chunk is initialization
  -- sensitive to extra top-level locals.
  ---------------------------------------------------------------------
  if mod.content and mod.content.map_scripts then
      mod.content.map_scripts:register("REDS_HOUSE_1F", {
          priority = 20,
          onInteract = function(game, ow, fx, fy)
              if tonumber(fx) ~= 3 or tonumber(fy) ~= 1 then return false end
              if worldTier(game) < 3 then return false end

              -- beta.26.4: the home TV is a live run recap rather than one
              -- static rule gag. It combines current story progression, route
              -- outcomes, team history, losses, the next active cap, and one
              -- relevant rule reminder. Nothing here changes gameplay state.
              local save = game and game.save or {}
              local flags = save.flags or {}
              local gotDex = flags.EVENT_GOT_POKEDEX == true
                  or tonumber(flags.EVENT_GOT_POKEDEX) == 1
              local caughtCount = countTrackerCatches()
              local losses = tonumber(mod.save:get("nuzlocke_losses", 0)) or 0
              local failedCount = 0
              local states = mod.save:get("encounter_states", {})
              if type(states) == "table" then
                  for _, state in pairs(states) do
                      if type(state) == "table" and state.status == "FAILED" then
                          failedCount = failedCount + 1
                      end
                  end
              end

              local latestCaught
              local history = mod.save:get("nuzlocke_history", {})
              if type(history) == "table" then
                  for i = #history, 1, -1 do
                      local row = history[i]
                      if type(row) == "table" and row.status ~= "LOST"
                          and (row.name or row.species) then
                          latestCaught = tostring(row.name or row.species)
                          break
                      end
                  end
              end

              local lastLoss = mod.save:get("last_loss", {})
              if type(lastLoss) ~= "table" then lastLoss = {} end
              local lastFailed = mod.save:get("last_failed_encounter", {})
              if type(lastFailed) ~= "table" then lastFailed = {} end
              if not lastFailed.species and type(states) == "table" then
                  for area, state in pairs(states) do
                      if type(state) == "table" and state.status == "FAILED" then
                          lastFailed = { area = area, species = state.species }
                          break
                      end
                  end
              end

              local badges = currentGymProgressCount(save)
              local cap, capName = nextLevelCapInfo(save)
              local capLine = nil
              if tonumber(cap) and tonumber(cap) < 100 then
                  capLine = "Next: " .. tostring(capName or "CAP")
                      .. " LV" .. tostring(cap) .. "."
              end

              local ruleLine
              if mod.save:get("no_mom_heal", false) == true then
                  ruleLine = "Rule watch: no home heals."
              elseif mod.save:get("no_poke_center", false) == true then
                  ruleLine = "Rule watch: Centers are off."
              elseif mod.save:get("no_field_healing", false) == true then
                  ruleLine = "Rule watch: no field heals."
              elseif mod.save:get("nickname_rule", false) == true then
                  ruleLine = "Rule watch: names required."
              elseif mod.save:get("no_buying", false) == true
                  or mod.save:get("no_selling", false) == true then
                  ruleLine = "Rule watch: Mart limits active."
              elseif mod.save:get("permadeath", true) == true then
                  ruleLine = "Rule watch: fainted means lost."
              else
                  ruleLine = "Rule watch: route ledger active."
              end

              -- Build every report that is meaningful for this save and
              -- cycle through them on repeated TV interactions. This keeps a
              -- single old failed route or loss from permanently hiding later
              -- catches/progression while still letting the TV remember it.
              local reports = {}
              local progress = {}
              if gotDex then
                  progress[#progress + 1] = "TV: AREA GUIDE LIVE"
                  progress[#progress + 1] = tostring(caughtCount) .. " caught, "
                      .. tostring(failedCount) .. " failed."
                  progress[#progress + 1] = tostring(badges) .. " badge"
                      .. (badges == 1 and "" or "s") .. " earned."
              else
                  progress[#progress + 1] = "TV: PALLET NEWS"
                  progress[#progress + 1] = "Oak's lab is busy today."
                  progress[#progress + 1] = "The journey is just starting."
              end
              if capLine then progress[#progress + 1] = capLine end
              reports[#reports + 1] = progress

              if latestCaught then
                  local caughtReport = {
                      "TV: TEAM UPDATE",
                      latestCaught .. " joined the run.",
                      tostring(caughtCount) .. " caught so far.",
                  }
                  if capLine then caughtReport[#caughtReport + 1] = capLine end
                  reports[#reports + 1] = caughtReport
              end

              if failedCount > 0 then
                  reports[#reports + 1] = {
                      "TV: ROUTE REPORT",
                      tostring(lastFailed.species or "An encounter") .. " got away.",
                      tostring(failedCount) .. " area"
                          .. (failedCount == 1 and "" or "s") .. " marked failed.",
                  }
              end

              if losses > 0 then
                  reports[#reports + 1] = {
                      "TV: KANTO REPORT",
                      tostring(lastLoss.name or lastLoss.species or "A teammate")
                          .. " was lost.",
                      tostring(losses) .. " teammate"
                          .. (losses == 1 and "" or "s") .. " lost so far.",
                  }
              end

              local cycle = math.floor(tonumber(mod.save:get("nuzlocke_tv_cycle", 0)) or 0)
              local index = (cycle % #reports) + 1
              mod.save:set("nuzlocke_tv_cycle", index)
              local parts = reports[index]
              parts[#parts + 1] = ruleLine
              local msg = table.concat(parts, "\n")

              return mod.exports.__beta26.pushWorldText(game, msg)
          end,
      })
  end

  installNuzlockeScriptHealGate()

      local function blockedHeal(ctx)
          -- Mom's R/B/Y script uses heal_party directly. Keep this command-level
          -- gate as the authoritative fallback even if hook ordering changes.
          if mod.exports.__beta26.ruleActive(ctx and ctx.game, "no_mom_heal")
              and isMomsHouseMap(ctx) then
              showRuleMessage(ctx, worldTier(ctx and ctx.game) >= 2
                  and "Mom: Nice try, sweetheart.\nThe Nuzlocke says I can't heal you.\nI believe in you!"
                  or "Mom: I know you need\nrest, sweetheart, but\nour Nuzlocke rules say\nI can't heal your\nPokemon right now.\nYou'll be okay!")
              return "end"
          end

          -- Pokemon Center healing is not implemented through heal_party in
          -- current Gen1Recomp, but retain this fallback for compatible builds.
          if mod.exports.__beta26.ruleActive(ctx and ctx.game, "no_poke_center")
              and isPokemonCenterMap(ctx) then
              showRuleMessage(ctx,
                  "Nurse Joy: I'm sorry,\nbut your Nuzlocke\nrules don't allow\nPokemon Center\nhealing right now.")
              return "end"
          end
          return originalHeal(ctx)
      end

      Commands.heal_party = blockedHeal
      sessionMethods.heal_party = { previous = originalHeal, wrapper = blockedHeal }

      -- Mom fades to white immediately before heal_party. Mirror the command
      -- gate at the fade verb too so the refusal remains on the room screen
      -- even if the public script hook is unavailable or reordered.
      local function blockedFade(ctx, ...)
          if mod.exports.__beta26.ruleActive(ctx and ctx.game, "no_mom_heal")
              and isMomsHouseMap(ctx) then
              return
          end
          if type(originalFade) == "function" then
              return originalFade(ctx, ...)
          end
      end
      if type(originalFade) == "function" then
          Commands.fade = blockedFade
          sessionMethods.fade = { previous = originalFade, wrapper = blockedFade }
      end

      -- Force the resolver to return the wrapped commands too. This is the
      -- important part for map scripts that resolve command names at runtime.
      if type(Commands.resolve) == "function" then
          local originalResolve = Commands.resolve
          local resolveWrapper
          resolveWrapper = function(data, name)
              if name == "heal_party" then
                  return blockedHeal, Commands.meta and Commands.meta[name]
              elseif name == "fade" and type(originalFade) == "function" then
                  return blockedFade, Commands.meta and Commands.meta[name]
              elseif name == "trade" and type(originalTrade) == "function" then
                  return nuzlockeTrade, Commands.meta and Commands.meta[name]
              elseif name == "give_pokemon"
                  and type(originalGivePokemon) == "function" then
                  return nuzlockeGivePokemon, Commands.meta and Commands.meta[name]
              elseif name == "static_battle"
                  and type(originalStaticBattle) == "function" then
                  return nuzlockeStaticBattle, Commands.meta and Commands.meta[name]
              end
              return originalResolve(data, name)
          end
          Commands.resolve = resolveWrapper
          sessionMethods.resolve = { previous = originalResolve, wrapper = resolveWrapper }
      end

      -- Secondary hook seams for builds that expose field healing through the
      -- public hook layer instead of the script command table.
      local function denyCenter(next, ctx, ...)
          if mod.exports.__beta26.ruleActive(ctx and ctx.game, "no_poke_center")
              and isPokemonCenterMap(ctx) then
              showRuleMessage(ctx,
                  "Nurse Joy: I'm sorry,\nbut your Nuzlocke\nrules don't allow\nPokemon Center\nhealing right now.")
              return false
          end
          return next(ctx, ...)
      end

      for _, hookName in ipairs({
          "pokemon_center.heal",
          "poke_center.heal",
          "pokemon.center.heal",
          "heal_party",
          "field.heal_party"
      }) do
          pcall(mod.hooks.wrap, mod.hooks, hookName, denyCenter, 1000)
      end

      local momMsg =
          "Mom: I'd love to\nheal your Pokemon,\nbut your Nuzlocke\nrules won't let me.\nI believe in you,\nsweetheart!"
      for _, name in ipairs({ "mom_heal", "heal_mom", "mom_rest", "mom_heals" }) do
          if type(Commands[name]) == "function" then
              local originalMom = Commands[name]
              local momWrapper
              momWrapper = function(ctx)
                  if mod.exports.__beta26.ruleActive(ctx and ctx.game, "no_mom_heal") then
                      showRuleMessage(ctx, momMsg)
                      return
                  end
                  return originalMom(ctx)
              end
              Commands[name] = momWrapper
              sessionMethods[name] = { previous = originalMom, wrapper = momWrapper }
          end
      end

      Commands.__nuzlockeRulesPatched = true
      Commands.__nuzlockeRulesOwner = mod
      Commands.__nuzlockeRulesSession = { owner = mod, methods = sessionMethods }
      return true
  end

  -- Try immediately and again at both lifecycle points.  The helper is
  -- idempotent, so whichever point sees Commands first performs the install.
  pcall(installNuzlockeFieldCommandPatches)
  mod.events:on("game.ready", function()
      pcall(installNuzlockeFieldCommandPatches)
  end)
  mod.events:on("save.loaded", function()
      pcall(installNuzlockeFieldCommandPatches)
  end)

  ---------------------------------------------------------------------
  -- R/B/Y POKEMON CENTER GATE
  --
  -- Current Gen1Recomp dispatches a nurse directly from OverworldState:talkTo
  -- after resolving the TX_SCRIPT text entry. Gate that exact transaction
  -- before nurseHeal starts. nurseHeal is also wrapped as a narrow fallback.
  ---------------------------------------------------------------------
  local function installNuzlockeCenterGate()
      if mod.exports.__beta26.isSaveEditorSession() then return true end
      local okVersion, GameVersion = pcall(require, "src.core.GameVersion")
      if okVersion and type(GameVersion) == "table"
          and type(GameVersion.isGold) == "function" then
          local okGold, gold = pcall(GameVersion.isGold)
          if okGold and gold == true then return true end
      end

      local okOverworld, OverworldState =
          pcall(require, "src.world.OverworldController")
      if not okOverworld or type(OverworldState) ~= "table"
          or type(OverworldState.talkTo) ~= "function"
          or type(OverworldState.nurseHeal) ~= "function" then
          return false
      end
      local priorSession = OverworldState.__nuzlockeCenterGateSession
      if type(priorSession) == "table" and priorSession.owner == mod
          and OverworldState.talkTo == priorSession.talkTo
          and OverworldState.nurseHeal == priorSession.nurseHeal then
          return true
      end
      if type(priorSession) == "table" and priorSession.owner ~= mod then
          if OverworldState.talkTo == priorSession.talkTo
              and type(priorSession.previousTalkTo) == "function" then
              OverworldState.talkTo = priorSession.previousTalkTo
          end
          if OverworldState.nurseHeal == priorSession.nurseHeal
              and type(priorSession.previousNurseHeal) == "function" then
              OverworldState.nurseHeal = priorSession.previousNurseHeal
          end
      end

      local vanillaTalkTo = OverworldState.talkTo
      local vanillaNurseHeal = OverworldState.nurseHeal

      local function liveGame()
          local game = mod.game
          if type(game) == "table" and game.stack and game.data then return game end
          if type(currentGame) == "table" and currentGame.stack and currentGame.data then
              return currentGame
          end
          return nil
      end

      local function denyCenter(game, self, npc, onDone)
          if npc and type(npc.facePlayer) == "function" and self and self.player then
              pcall(npc.facePlayer, npc, self.player)
          end
          local msg = worldTier(game) >= 2
              and "Nurse Joy: Sorry!\nYour Nuzlocke says no healing here.\nTake care of that team!"
              or "Nurse Joy: I'm sorry,\nbut your Nuzlocke\nrules don't allow\nPokemon Center\nhealing right now."
          if not mod.exports.__beta26.pushWorldText(game, msg, onDone)
              and onDone then
              onDone()
          end
      end

      local talkToWrapper
      talkToWrapper = function(self, npc, ...)
          local game = liveGame()
          if mod.exports.__beta26.ruleActive(game, "no_poke_center")
              and npc and type(npc.def) == "table" then
              local data = game and game.data
              local map = self and self.map
              local def = map and map.def
              local entry
              if data and def and type(data.textEntry) == "function" then
                  local okEntry, resolved = pcall(data.textEntry, data, def.label, npc.def.text)
                  if okEntry then entry = resolved end
              end
              if type(entry) == "table" and entry.nurse then
                  npc.frozen = true
                  denyCenter(game, self, npc, function() npc.frozen = false end)
                  return
              end
          end
          return vanillaTalkTo(self, npc, ...)
      end

      local nurseHealWrapper
      nurseHealWrapper = function(self, onDone, npc, ...)
          local game = liveGame()
          if mod.exports.__beta26.ruleActive(game, "no_poke_center") then
              denyCenter(game, self, npc, onDone)
              return
          end
          return vanillaNurseHeal(self, onDone, npc, ...)
      end
      OverworldState.talkTo = talkToWrapper
      OverworldState.nurseHeal = nurseHealWrapper
      OverworldState.__nuzlockeCenterGateOwner = mod
      OverworldState.__nuzlockeCenterGateSession = {
          owner = mod,
          talkTo = talkToWrapper, previousTalkTo = vanillaTalkTo,
          nurseHeal = nurseHealWrapper, previousNurseHeal = vanillaNurseHeal,
      }
      return true
  end

  pcall(installNuzlockeCenterGate)
  mod.events:on("game.ready", function()
      pcall(installNuzlockeCenterGate)
  end)
  mod.events:on("save.loaded", function()
      pcall(installNuzlockeCenterGate)
  end)

  ---------------------------------------------------------------------
  -- GAME CORNER WAGER / PRIZE GATE
  --
  -- Celadon's slot screen subtracts coins only after its bet confirmation,
  -- and its three prize-counter talk handlers grant the prize before charging
  -- coins. Block both entry points, leaving the Rocket story path, coin clerk,
  -- free-coin NPCs, and ordinary movement untouched.
  ---------------------------------------------------------------------
  -- These are intentionally different engine IDs. R/B/Y calls the room
  -- GAME_CORNER_PRIZE_ROOM; Gold's postgame Kanto data prefixes the city.
  -- Keep every Game Corner adapter on one named table so the two generations
  -- cannot be accidentally "corrected" into the same, wrong identifier.
  mod.exports.__beta26.gameCornerMapIds = {
      rbyPrizeRoom = "GAME_CORNER_PRIZE_ROOM",
      gscGoldenrod = "GOLDENROD_GAME_CORNER",
      gscCeladonPrizeRoom = "CELADON_GAME_CORNER_PRIZE_ROOM",
  }

  mod.exports.__beta26.installGameCornerRuleGate = function()
      if mod.exports.__beta26.isSaveEditorSession() then return true end

      local okWorld, OverworldState = pcall(require, "src.world.OverworldController")
      local okSlots, SlotMachine = pcall(require, "src.ui.SlotMachine")
      if not okWorld or type(OverworldState) ~= "table"
          or type(OverworldState.showMapText) ~= "function"
          or not okSlots or type(SlotMachine) ~= "table"
          or type(SlotMachine.update) ~= "function"
          or type(SlotMachine.draw) ~= "function" then
          return false
      end

      local worldSession = OverworldState.__nuzlockeGameCornerSession
      if not (type(worldSession) == "table" and worldSession.owner == mod
          and OverworldState.showMapText == worldSession.wrapper) then
          if type(worldSession) == "table" and worldSession.owner ~= mod
              and OverworldState.showMapText == worldSession.wrapper
              and type(worldSession.previous) == "function" then
              OverworldState.showMapText = worldSession.previous
          end
          local previousShowMapText = OverworldState.showMapText
          local showMapTextWrapper
          showMapTextWrapper = function(self, textConst, npc, onDone, ...)
              local mapId = self and self.map and self.map.id
              local prize = tostring(textConst or ""):find(
                  "TEXT_GAMECORNERPRIZEROOM_PRIZE_VENDOR_", 1, true) == 1
              local game = currentGame or mod.game
              if mapId == mod.exports.__beta26.gameCornerMapIds.rbyPrizeRoom
                  and prize
                  and mod.exports.__beta26.ruleActive(game, "no_gambling") then
                  if npc and type(npc.facePlayer) == "function" and self.player then
                      pcall(npc.facePlayer, npc, self.player)
                  end
                  local done = type(onDone) == "function" and onDone or function() end
                  if not mod.exports.__beta26.pushWorldText(game,
                      "Prize redemption is disabled by your No Gambling rule.", done) then
                      done()
                  end
                  return
              end
              return previousShowMapText(self, textConst, npc, onDone, ...)
          end
          OverworldState.showMapText = showMapTextWrapper
          OverworldState.__nuzlockeGameCornerSession = {
              owner = mod, previous = previousShowMapText,
              wrapper = showMapTextWrapper,
          }
      end

      local slotSession = SlotMachine.__nuzlockeGameCornerSession
      if type(slotSession) == "table" and slotSession.owner == mod
          and SlotMachine.update == slotSession.update
          and SlotMachine.draw == slotSession.draw then
          return true
      end
      if type(slotSession) == "table" and slotSession.owner ~= mod then
          if SlotMachine.update == slotSession.update
              and type(slotSession.previousUpdate) == "function" then
              SlotMachine.update = slotSession.previousUpdate
          end
          if SlotMachine.draw == slotSession.draw
              and type(slotSession.previousDraw) == "function" then
              SlotMachine.draw = slotSession.previousDraw
          end
      end

      local previousUpdate, previousDraw = SlotMachine.update, SlotMachine.draw
      local blockedUpdate, blockedDraw
      blockedUpdate = function(self, dt)
          local game = self and self.game
          if mod.exports.__beta26.ruleActive(game, "no_gambling") then
              local input = game and game.input
              if input and (input:wasPressed("a") or input:wasPressed("b"))
                  and game.stack then
                  game.stack:pop()
              end
              return
          end
          return previousUpdate(self, dt)
      end
      blockedDraw = function(self)
          local game = self and self.game
          if not mod.exports.__beta26.ruleActive(game, "no_gambling") then
              return previousDraw(self)
          end
          local okFont, Font = pcall(require, "src.render.Font")
          love.graphics.setColor(1, 1, 1, 1)
          love.graphics.rectangle("fill", 0, 0, 160, 144)
          love.graphics.setColor(0, 0, 0, 1)
          if okFont and Font then
              Font.draw(Strings("NO GAMBLING"), 32, 40)
              Font.draw(Strings("Wagering is"), 32, 64)
              Font.draw(Strings("disabled."), 40, 76)
              Font.draw(Strings("A/B: LEAVE"), 32, 104)
          end
          love.graphics.setColor(1, 1, 1, 1)
      end
      SlotMachine.update, SlotMachine.draw = blockedUpdate, blockedDraw
      SlotMachine.__nuzlockeGameCornerSession = {
          owner = mod,
          previousUpdate = previousUpdate, update = blockedUpdate,
          previousDraw = previousDraw, draw = blockedDraw,
      }
      return true
  end

  pcall(mod.exports.__beta26.installGameCornerRuleGate)
  mod.events:on("game.ready", function()
      pcall(mod.exports.__beta26.installGameCornerRuleGate)
  end)
  mod.events:on("save.loaded", function()
      pcall(mod.exports.__beta26.installGameCornerRuleGate)
  end)


  ---------------------------------------------------------------------
  -- SHOP BUY / SELL GATE
  --
  -- Keep the normal Mart menu and only replace the selected action. This is
  -- safer than blocking open_mart: BUY and SELL can be controlled separately,
  -- QUIT always works, and vanilla/custom stock handling remains untouched.
  ---------------------------------------------------------------------
  local function installShopRuleGate()
      if mod.exports.__beta26.isSaveEditorSession() then return true end
      local okShop, ShopMenu = pcall(require, "src.ui.ShopMenu")
      if not okShop or type(ShopMenu) ~= "table"
          or type(ShopMenu.new) ~= "function" then
          return false
      end
      local priorSession = ShopMenu.__nuzlockeShopRuleGateSession
      if type(priorSession) == "table" and priorSession.owner == mod
          and ShopMenu.new == priorSession.wrapper then
          return true
      end
      if type(priorSession) == "table" and priorSession.owner ~= mod
          and ShopMenu.new == priorSession.wrapper
          and type(priorSession.previous) == "function" then
          ShopMenu.new = priorSession.previous
      end

      local vanillaNew = ShopMenu.new

      local function deny(game, kind)
          local msg
          if kind == "BUY" then
              msg = worldTier(game) >= 2
                  and "Clerk: Nice try.\nYour rules say no buying today."
                  or "Buying is disabled\nby your Nuzlocke rules."
          else
              msg = worldTier(game) >= 2
                  and "Clerk: Holding onto it?\nYour rules say no selling."
                  or "Selling is disabled\nby your Nuzlocke rules."
          end

          mod.exports.__beta26.pushWorldText(game, msg)
      end

      local shopNewWrapper
      shopNewWrapper = function(game, stock, onQuit)
          local menu = vanillaNew(game, stock, onQuit)
          for _, item in ipairs(menu and menu.items or {}) do
              local label = tostring(item and item.label or ""):upper()
              if label == "BUY" and type(item.onSelect) == "function" then
                  local vanillaBuy = item.onSelect
                  item.onSelect = function(...)
                      local allowed = mod.exports.nuzlocke_compat.canPurchase(
                          game, { kind = "item_shop" })
                      if allowed == false then
                          deny(game, "BUY")
                          return
                      end
                      return vanillaBuy(...)
                  end
              elseif label == "SELL" and type(item.onSelect) == "function" then
                  local vanillaSell = item.onSelect
                  item.onSelect = function(...)
                      local allowed = mod.exports.nuzlocke_compat.canSell(
                          game, { kind = "item_shop" })
                      if allowed == false then
                          deny(game, "SELL")
                          return
                      end
                      return vanillaSell(...)
                  end
              end
          end
          return menu
      end

      ShopMenu.new = shopNewWrapper
      ShopMenu.__nuzlockeShopRuleGateInstalled = true
      ShopMenu.__nuzlockeShopRuleGateOwner = mod
      ShopMenu.__nuzlockeShopRuleGateSession = {
          owner = mod, previous = vanillaNew, wrapper = shopNewWrapper,
      }
      return true
  end

  pcall(installShopRuleGate)
  mod.events:on("game.ready", function()
      pcall(installShopRuleGate)
  end)
  mod.events:on("save.loaded", function()
      pcall(installShopRuleGate)
  end)


  ---------------------------------------------------------------------
  -- CHECKPOINT / SAVESTATE RECONCILIATION
  --
  -- Public checkpoint restores rewind canonical game state and mod.save but
  -- intentionally do not serialize arbitrary Lua locals. Rebind only our
  -- progress-derived runtime references/caches after a successful restore.
  -- Do not run migrations or reconstruct canonical tracker history here: the
  -- restored mod.save is already authoritative.
  ---------------------------------------------------------------------
  mod.events:on("checkpoint.restored", function(ev)
      local game = type(ev) == "table" and ev.game or ev
      if game then
          currentGame = game
          currentSave = game.save or currentSave
      elseif currentGame then
          currentSave = currentGame.save or currentSave
      end

      -- A restore can move backward across a battle boundary. These values are
      -- runtime-only observations and must never survive that rewind.
      activeWildEncounter = nil
      finalizedNuzlockeBattles = setmetatable({}, { __mode = "k" })
      mod.exports.__beta26.pendingStaticEncounter = nil

      -- Rebuild only mirrors/projections derived from the restored canonical
      -- save. The projection helper is additive and preserves physical catch
      -- provenance while immediately reflecting restored split settings.
      pcall(refreshRuleMirrorFromSave)
      if mod.exports.__beta26.ensureEncounterProjection then
          pcall(mod.exports.__beta26.ensureEncounterProjection)
      end
      if refreshGymGuideVisibility and currentGame then
          pcall(refreshGymGuideVisibility, currentGame)
      end
  end)

  ---------------------------------------------------------------------
  -- GOLD CORE-RULE ADAPTERS
  --
  -- Gold has a separate battle UI, script VM, naming screen and mart UI.
  -- Keep the established R/B/Y paths above untouched and bridge the same
  -- Nuzlocke policy into the live Gen 2 modules here.
  ---------------------------------------------------------------------
  do
      local G2 = {}

      function G2.isGold()
          return getGameVersion() == "GOLD"
      end

      function G2.catchMessage(game, reason, species)
          if reason == "area" then
              return worldTier(game) >= 2 and Strings("Encounter used!\nTry another route.")
                  or Strings("Encounter used!")
          elseif reason == "dupes" then
              return worldTier(game) >= 2 and Strings("Seriously? Another one?\nDupes Clause says NO.")
                  or Strings("You already have this POKEMON family!")
          elseif reason == "overworld" then
              return Strings("Overworld catches are turned OFF.")
          elseif reason == "town" then
              return Strings("Town catches are turned OFF.")
          elseif reason == "legendary" then
              return Strings("Legendary catches are turned OFF.")
          elseif reason == "mythical" then
              return Strings("Mythical catches are turned OFF.")
          elseif reason == "pseudo" then
              return Strings("Pseudo-legendary catches are turned OFF.")
          elseif reason == "static" then
              return Strings("Static catches are turned OFF.")
          elseif reason == "bst" then
              return Strings("BST %s exceeds maximum %d.",
                  tostring(mod.exports.__beta26.getSpeciesBST(game, species) or "?"),
                  mod.exports.__beta26.getMaximumBST())
          elseif reason == "glitch" then
              return Strings("Glitch Pokemon are blocked by your rules.")
          elseif reason == "solo" then
              return Strings("Solo Only: only one Pokemon allowed!")
          end
      end

      function G2.installCaptureGate()
          if not G2.isGold() then return false end
          local ok, BS = pcall(require, "src.ui.gen2.BattleState")
          if not ok or type(BS) ~= "table" or type(BS.useItem) ~= "function" then return false end
          if BS.__nuzlockeBeta22CaptureGate then return true end
          BS.__nuzlockeBeta22CaptureGate = true
          local vanilla = BS.useItem
          BS.useItem = function(self, itemId)
              local data = self and self.game and self.game.data or {}
              local def = data.items and data.items[itemId]
              if self and self.battle and not self.tutorial then
                  local allowed, decision = evaluateItemUsePolicy(
                      self.game, data, self.game and self.game.save, itemId, nil,
                      { battle = self.battle, inBattle = true,
                        generation = 2,
                        isBall = def and def.pocket == "BALL" })
                  local code = decision and decision.code
                  if allowed == false and (code == "ball_use_ban"
                      or code == "no_pp_items") then
                      local tier = worldTier(self.game)
                      local message = decision and decision.message
                          or Strings("Item use is blocked!")
                      if tier >= 3 and decision and decision.tier3 then
                          message = decision.tier3
                      elseif tier >= 2 and decision and decision.tier2 then
                          message = decision.tier2
                      end
                      self.queue = {}
                      self.message = mod.exports.__beta26.cleanWorldText(message)
                      self.messageTimer = 48
                      self.phase = "resolving"
                      return
                  end
              end
              -- Native Gold uses battle.wild for every non-trainer battle,
              -- including loadwildmon-driven static encounters. Also accept
              -- explicit static provenance for compatibility with mods that
              -- construct a fixed battle without the native opts.wild shape.
              local catchableBattle = self and self.battle
                  and (self.battle.wild
                      or mod.exports.__beta26.isStaticEncounter(
                          self.game, self.battle))
              if def and def.pocket == "BALL" and self and self.battle
                  and catchableBattle and not self.tutorial then
                  local allowed, decision = evaluateItemUsePolicy(
                      self.game, data, self.game and self.game.save, itemId, nil,
                      { battle = self.battle, inBattle = true, isBall = true })
                  if allowed == false then
                      local tier = worldTier(self.game)
                      local message = decision and decision.message
                          or Strings("That Ball is banned!")
                      if tier >= 3 and decision and decision.tier3 then
                          message = decision.tier3
                      elseif tier >= 2 and decision and decision.tier2 then
                          message = decision.tier2
                      end
                      self.queue = {}
                      self.message = mod.exports.__beta26.cleanWorldText(message)
                      self.messageTimer = 48
                      self.phase = "resolving"
                      return
                  end
                  local enemy = self.battle.enemy
                  local species = enemy and enemy.species
                  local okReason, reason = pcall(catchDeniedReason,
                      self.game, self.battle, species)
                  if okReason and reason then
                      self.queue = {}
                      self.message = G2.catchMessage(self.game, reason, species)
                          or Strings("That catch is not allowed by your Nuzlocke rules.")
                      self.messageTimer = 48
                      self.phase = "resolving"
                      return
                  end
              end
              return vanilla(self, itemId)
          end
          return true
      end

      function G2.noteDamage(ev)
          if not G2.isGold() or not ev or not ev.battle then return end
          if ev.target == ev.battle.player then
              ev.battle.nuzlockeG2LastDamage = {
                  move = ev.moveId or (ev.move and ev.move.id),
                  attacker = ev.user,
                  damage = ev.damage,
                  critical = ev.crit == true,
              }
          end
      end

      function G2.recordDeath(game, battle, mon)
          if not (game and battle and mon) or mon.nuzlockeDead then return end
          local key = areaKey(game, battle)
          local enemy = battle.enemy
          local enemySpecies = enemy and (enemy.nickname or enemy.name or enemy.species) or "BATTLE"
          local damage = battle.nuzlockeG2LastDamage
          local glitch = mod.exports.__beta26.getGlitchSpeciesInfo(game, mon.species)
          local monLabel = tostring(mon.nickname or glitch.label or "Pokemon")
          local cause = monLabel
              .. " died in battle against " .. tostring(enemySpecies) .. "."
          if damage and damage.move then
              cause = monLabel
                  .. " died to " .. tostring(enemySpecies) .. " after "
                  .. (damage.critical and "a critical " or "") .. tostring(damage.move) .. "."
          elseif mon.status then
              cause = monLabel
                  .. " died in battle while affected by " .. tostring(mon.status) .. "."
          end

          mon.nuzlockeDead = true
          mon.deathLocation = key
          mon.deathCause = cause
          mon.deathCauseText = cause
          mon.deathEncounterType = battle.trainer and "trainer" or "wild"
          mon.deathOpponentSpecies = enemySpecies
          mon.deathMove = damage and damage.move or nil
          mon.deathCritical = damage and damage.critical == true or false

          local history = mod.save:get("nuzlocke_history", {})
          if type(history) ~= "table" then history = {} end
          table.insert(history, {
              name = mon.nickname or glitch.label,
              species = glitch.key,
              rawSpecies = glitch.isGlitch and mon.species or nil,
              glitch = glitch.isGlitch or nil,
              missingNo = glitch.missingNo or nil,
              pokemonId = Identity.ensurePokemonIdentity(mon, currentSave,
                  mon.nuzlockeOrigin or "NORMAL"),
              catchLocation = mon.catchLocation,
              encounterType = mon.encounterType,
              status = "LOST",
              deathLocation = key,
              deathCause = cause,
              deathOpponentSpecies = enemySpecies,
              deathMove = mon.deathMove,
              deathCritical = mon.deathCritical,
          })
          mod.save:set("nuzlocke_history", history)
          mod.save:set("nuzlocke_losses",
              (tonumber(mod.save:get("nuzlocke_losses", 0)) or 0) + 1)
          mod.save:set("last_loss", {
              name = mon.nickname or glitch.label,
              species = glitch.key,
              rawSpecies = glitch.isGlitch and mon.species or nil,
              glitch = glitch.isGlitch or nil,
              missingNo = glitch.missingNo or nil,
              pokemonId = Identity.pokemonIdentity(mon),
              location = key,
              cause = cause,
          })

          worldMechanic(game,
              "death:g2:" .. monLabel .. ":" .. tostring(key),
              Strings("%s has fallen.\nThe Nuzlocke remembers.", monLabel))

          local party = game.save and game.save.party
          if type(party) == "table" then
              for i = #party, 1, -1 do
                  if party[i] == mon then
                      table.remove(party, i)
                      break
                  end
              end
          end
      end

      function G2.onFaint(ev)
          if not G2.isGold() or not ev or not ev.battle or not ev.battler then return end
          local battle = ev.battle
          if battle.player ~= ev.battler then return end
          local game = currentGame or mod.game
          if not active(game, battle) then return end
          if mod.exports.__beta26.isFirstRivalForgivenessActive(game, battle) then
              if ev.battler.mon then
                  ev.battler.mon.nuzlockeRivalForgiven = true
              elseif type(ev.battler) == "table" then
                  ev.battler.nuzlockeRivalForgiven = true
              end
              battle.nuzlockeRivalForgivenessTriggered = true
              return
          end
          if mod.save:get("permadeath", true) then
              G2.recordDeath(game, battle, ev.battler)
          end
          if mod.save:get("whiteout_clause", false)
              and not hasHealthyParty(game) then
              battle.nuzlockeGameOver = true
          end
      end

      function G2.installNicknameGate()
          if not G2.isGold() then return false end
          local okBS, BS = pcall(require, "src.ui.gen2.BattleState")
          local okNS, NS = pcall(require, "src.ui.gen2.NamingScreen")

          -- Module tables survive mod-loader sessions in some engine builds.
          -- Own each replacement explicitly so a reload can remove our exact
          -- old wrapper without disturbing a later wrapper from another mod.
          if okBS and type(BS) == "table"
              and type(BS.answerNickname) == "function" then
              local session = BS.__nuzlockeNicknameAnswerSession
              if type(session) == "table" and session.owner ~= mod
                  and BS.answerNickname == session.wrapper then
                  BS.answerNickname = session.previous
                  session = nil
              end
              if not (type(session) == "table" and session.owner == mod) then
                  local vanillaAnswer = BS.answerNickname
                  local wrapper = function(self, yes)
                      if active(self and self.game, self and self.battle)
                          and mod.save:get("nickname_rule", false) then
                          yes = true
                      end
                      return vanillaAnswer(self, yes)
                  end
                  BS.answerNickname = wrapper
                  BS.__nuzlockeNicknameAnswerSession = {
                      owner = mod,
                      previous = vanillaAnswer,
                      wrapper = wrapper,
                  }
                  -- Retain the historical marker for mods that inspect it.
                  BS.__nuzlockeBeta22ForceNickname = true
              end
          end
          if okNS and type(NS) == "table" and type(NS.accept) == "function" then
              local session = NS.__nuzlockeNicknameAcceptSession
              if type(session) == "table" and session.owner ~= mod
                  and NS.accept == session.wrapper then
                  NS.accept = session.previous
                  session = nil
              end
              if not (type(session) == "table" and session.owner == mod) then
                  local vanillaAccept = NS.accept
                  local wrapper = function(self)
                      local blank = not tostring(self and self.text or ""):find("%S")
                      if G2.isGold() and self and self.kind == NS.TYPES.nickname
                          and active(self.game, nil)
                          and mod.save:get("nickname_rule", false)
                          and blank then
                          return
                      end
                      return vanillaAccept(self)
                  end
                  NS.accept = wrapper
                  NS.__nuzlockeNicknameAcceptSession = {
                      owner = mod,
                      previous = vanillaAccept,
                      wrapper = wrapper,
                  }
                  NS.__nuzlockeBeta22NonEmptyNickname = true
              end
          end
          return true
      end

      -- Scripted gifts do not pass through BattleState:answerNickname. Use the
      -- VM's blocking rename seam so the story remains parked until Gold's
      -- native naming screen closes, then resumes at the exact next command.
      function G2.requireGiftNickname(game, mon, vm)
          if not (mon and active(game, nil)
              and mod.save:get("nickname_rule", false)) then
              return false
          end
          local existing = tostring(mon.nickname or "")
          local species = tostring(mon.species or mon.name or "")
          if existing:find("%S") and existing:upper() ~= species:upper() then
              mon.nuzlockeNeedsNickname = nil
              mon.nuzlockeNicknameRequired = nil
              return true
          end

          mon.nuzlockeNeedsNickname = true
          mon.nuzlockeNicknameRequired = true
          local rename = vm and vm.specials and vm.specials.renameMon
          local okSpecials, Specials = pcall(require, "src.script.gen2.Specials")
          if not (type(rename) == "function" and okSpecials
              and type(Specials) == "table"
              and type(Specials.block) == "function") then
              return false
          end

          local name = Specials.block(vm, function(done)
              rename(mon, done, { blank = true })
          end)
          name = tostring(name or "")
          if not name:find("%S") then return false end
          mon.nickname = name
          mon.nuzlockeNeedsNickname = nil
          mon.nuzlockeNicknameRequired = nil
          return true
      end

      function G2.installMartGate()
          if not G2.isGold() then return false end
          local ok, Mart = pcall(require, "src.ui.gen2.MartMenu")
          if not ok or type(Mart) ~= "table" then return false end
          if Mart.__nuzlockeBeta22MartGate then return true end
          Mart.__nuzlockeBeta22MartGate = true

          if type(Mart.offerToBuy) == "function" then
              local vanillaBuy = Mart.offerToBuy
              Mart.offerToBuy = function(self, ...)
                  local allowed = mod.exports.nuzlocke_compat.canPurchase(
                      self and self.game, { kind = "item_shop", generation = 2 })
                  if allowed == false then
                      if self and type(self.say) == "function" then
                          self:say("Buying is disabled by your Nuzlocke rules.")
                      end
                      return
                  end
                  return vanillaBuy(self, ...)
              end
          end
          if type(Mart.offerToSell) == "function" then
              local vanillaSell = Mart.offerToSell
              Mart.offerToSell = function(self, ...)
                  local allowed = mod.exports.nuzlocke_compat.canSell(
                      self and self.game, { kind = "item_shop", generation = 2 })
                  if allowed == false then
                      if self and type(self.say) == "function" then
                          self:say("Selling is disabled by your Nuzlocke rules.")
                      end
                      return
                  end
                  return vanillaSell(self, ...)
              end
          end
          return true
      end

      function G2.installFieldItemGate()
          if not G2.isGold() then return false end
          local ok, PackMenu = pcall(require, "src.ui.gen2.PackMenu")
          if not ok or type(PackMenu) ~= "table"
              or type(PackMenu.useSelected) ~= "function" then return false end

          local session = PackMenu.__nuzlockeFieldItemGateSession
          if type(session) == "table" and session.owner == mod
              and PackMenu.useSelected == session.wrapper then return true end
          if type(session) == "table" and session.owner ~= mod
              and PackMenu.useSelected == session.wrapper
              and type(session.previous) == "function" then
              PackMenu.useSelected = session.previous
          end

          local previous = PackMenu.useSelected
          local wrapper
          wrapper = function(self, ...)
              local row = self and self.rows and self.rows[self.index]
              local inBattle = self and type(self.inBattle) == "function"
                  and self:inBattle() or false
              if row and not inBattle and not self.give then
                  local game = self.game or (self.world and self.world.game)
                      or currentGame or mod.game
                  local data = game and game.data or { items = self.items }
                  local allowed, decision = evaluateItemUsePolicy(
                      game, data, game and game.save, row.id, nil,
                      { inBattle = false,
                        overworld = self.world,
                        generation = 2 })
                  local code = decision and decision.code
                  if allowed == false and (code == "no_tm_use"
                      or code == "no_rare_candy_use"
                      or code == "no_repels"
                      or code == "no_escape_rope"
                      or code == "no_field_healing"
                      or code == "no_pp_items") then
                      local _, messages = ItemPolicy.present(game, decision)
                      self.message = messages or { Strings("Item use is blocked!") }
                      self.nuzlockeItemUseBlocked = code
                      return
                  end
              end
              return previous(self, ...)
          end
          PackMenu.useSelected = wrapper
          PackMenu.__nuzlockeFieldItemGateSession = {
              owner = mod, previous = previous, wrapper = wrapper,
          }
          return true
      end

      function G2.installCatchTutorialSkip()
          if not G2.isGold() then return false end
          local ok, World = pcall(require, "src.world.gen2.World")
          if not ok or type(World) ~= "table"
              or type(World.startCatchTutorial) ~= "function" then
              return false
          end

          local session = World.__nuzlockeCatchTutorialSkipSession
          if type(session) == "table" and session.owner == mod
              and World.startCatchTutorial == session.wrapper then return true end
          if type(session) == "table" and session.owner ~= mod
              and World.startCatchTutorial == session.wrapper
              and type(session.previous) == "function" then
              World.startCatchTutorial = session.previous
          end

          local previous = World.startCatchTutorial
          local wrapper = function(self, wild, battleType, onDone)
              local save = self and self.game and self.game.save
              if save and save.nuzlockeSkipCatchTutorial == true then
                  -- Vm's catchtutorial opcode performs StopAutoInput and the
                  -- mandatory map reload after this callback. The surrounding
                  -- Route 29 script then clears its scene and sets
                  -- EVENT_LEARNED_TO_CATCH_POKEMON exactly as vanilla does.
                  if onDone then onDone() end
                  return true
              end
              return previous(self, wild, battleType, onDone)
          end
          World.startCatchTutorial = wrapper
          World.__nuzlockeCatchTutorialSkipSession = {
              owner = mod, previous = previous, wrapper = wrapper,
          }
          return true
      end

      function G2.findNewPartyMon(before, party)
          for _, mon in ipairs(party or {}) do
              if not before[mon] then return mon end
          end
      end

      -- REVIEWED: Gold givepoke may place a successful acquisition directly
      -- into PC storage when the party is full. Treat party and boxes as the
      -- owned-Pokemon pool, while preferring party detection to preserve the
      -- established party-delivered path exactly.
      function G2.snapshotOwnedPokemon(save)
          local before = {}
          for _, mon in ipairs(save and save.party or {}) do before[mon] = true end
          for _, box in ipairs(save and save.boxes or {}) do
              for _, mon in ipairs(box or {}) do before[mon] = true end
          end
          return before
      end

      function G2.findNewOwnedPokemon(before, save)
          local mon = G2.findNewPartyMon(before, save and save.party)
          if mon then return mon, "party" end
          for _, box in ipairs(save and save.boxes or {}) do
              for _, boxed in ipairs(box or {}) do
                  if not before[boxed] then return boxed, "box" end
              end
          end
      end

      function G2.installGiftTracking()
          if G2._giftHook then return true end
          G2._giftHook = true
          mod.hooks:wrap("script.command", function(next, ctx, name, args, cmd)
              if not (ctx and ctx.generation == 2 and G2.isGold() and name == "givepoke") then
                  return next(ctx, name, args, cmd)
              end

              local game = currentGame or mod.game
              local party = game and game.save and game.save.party or {}
              local beforeCount = #party
              local scriptedSpecies = (cmd and cmd.species)
                  or (type(args) == "table" and args[1]) or nil
              local upper = tostring(scriptedSpecies or ""):upper()
              if tonumber(scriptedSpecies) and game and game.data
                  and type(game.data.pokemon) == "table" then
                  for id, def in pairs(game.data.pokemon) do
                      if type(def) == "table"
                          and tonumber(def.index) == tonumber(scriptedSpecies) then
                          upper = tostring(id):upper()
                          break
                      end
                  end
              end
              local isStarter = beforeCount == 0
                  and (upper == "CHIKORITA" or upper == "CYNDAQUIL"
                      or upper == "TOTODILE")
              if isStarter and mod.save:get("random_starter", false) == true then
                  local choice = mod.exports.__beta26.selectRandomStarter(
                      game, upper)
                  local def = game and game.data and game.data.pokemon
                      and game.data.pokemon[choice]
                  local index = type(def) == "table" and tonumber(def.index) or nil
                  if index then
                      if type(cmd) == "table" then cmd.species = index end
                      if type(args) == "table" then args[1] = index end
                      scriptedSpecies = index
                  end
              end
              local area = areaKey(game, nil)
                  or (ctx and (ctx.mapId or ctx.map)) or "UNKNOWN"

              -- Gold's givepoke command is transactional just like Gen 1's
              -- give_pokemon seam. Enforce legality BEFORE the script mutates
              -- party/story state. Starters remain their own mandatory path.
              if not isStarter then
                  local denied = specialAcquisitionDenied(
                      game, upper, area, "gift")
                  if denied then
                      ctx.lastCheck = false
                      showRuleMessage(ctx,
                          acquisitionDeniedMessage("gift", denied, area))
                      return
                  end
              end

              local before = G2.snapshotOwnedPokemon(game and game.save)
              local result = next(ctx, name, args, cmd)
              local mon = G2.findNewOwnedPokemon(before, game and game.save)
              if not mon then return result end

              mod.exports.__beta26.StatRules.applyPlayer(game, mon)
              local species = mon.species or scriptedSpecies
              local actualUpper = tostring(species or ""):upper()
              if isStarter then
                  registerStarterCatch(species, mon)
              else
                  registerSpecialCatch(species, area, "gift", mon)
              end
              G2.requireGiftNickname(game, mon, ctx and ctx.vm)
              mod.exports.__beta26.syncHistoryNickname(mon)
              return result
          end)
          return true
      end

      function G2.installStaticTracking()
          if G2._staticHook then return true end
          G2._staticHook = true
          mod.hooks:wrap("script.command", function(next, ctx, name, args, cmd)
              if ctx and ctx.generation == 2 and G2.isGold() then
                  if name == "loadwildmon" then
                      mod.exports.__beta26.pendingStaticEncounter = {
                          generation = 2,
                          species = (cmd and cmd.species)
                              or (type(args) == "table" and args[1]),
                      }
                  elseif name == "randomwildmon" or name == "loadtrainer"
                      or name == "loadtemptrainer" then
                      mod.exports.__beta26.pendingStaticEncounter = nil
                  end
              end
              return next(ctx, name, args, cmd)
          end)
          return true
      end

      function G2.installGamblingGate()
          if not G2.isGold() then return false end
          local ok, Specials = pcall(require, "src.script.gen2.Specials")
          if not ok or type(Specials) ~= "table"
              or type(Specials.HANDLERS) ~= "table"
              or type(Specials.ALL) ~= "table" then return false end
          local session = Specials.__nuzlockeGamblingSession
          if type(session) == "table" and session.owner == mod then return true end
          if type(session) == "table" and session.owner ~= mod then
              for name, rec in pairs(session.methods or {}) do
                  if type(rec) == "table" then
                      -- beta.27.15 stored one shared wrapper/previous pair.
                      -- Accept that legacy session shape during an in-process
                      -- upgrade, then record independent slots below.
                      local oldHandlersWrapper = rec.wrapperHandlers or rec.wrapper
                      local oldHandlersPrevious = rec.previousHandlers or rec.previous
                      local oldAllWrapper = rec.wrapperAll or rec.wrapper
                      local oldAllPrevious = rec.previousAll or rec.previous
                      if Specials.HANDLERS[name] == oldHandlersWrapper then
                          Specials.HANDLERS[name] = oldHandlersPrevious
                      end
                      if Specials.ALL[name] == oldAllWrapper then
                          Specials.ALL[name] = oldAllPrevious
                      end
                  end
              end
          end

          -- Gold and post-game Kanto prize vendors announce their coin-case
          -- balance immediately before opening the prize menu. The coin clerk
          -- uses DisplayMoneyAndCoinBalance instead, so ending only this exact
          -- map/special combination blocks redemption without blocking coin
          -- purchases or unrelated Game Corner dialogue.
          if not G2._gamblingScriptHook then
              G2._gamblingScriptHook = true
              mod.hooks:wrap("script.command", function(next, ctx, name, args, cmd)
                  if ctx and ctx.generation == 2 and name == "special"
                      and mod.exports.__beta26.ruleActive(
                          currentGame or mod.game, "no_gambling") then
                      local vm = ctx.vm
                      local specialId = cmd and (cmd.special or cmd.id)
                          or (type(args) == "table" and args[1])
                      local specialName = vm and type(vm.specialName) == "function"
                          and vm:specialName(specialId) or nil
                      local mapId = tostring(ctx.mapId or ""):upper()
                      if specialName == "DisplayCoinCaseBalance"
                          and (mapId == mod.exports.__beta26.gameCornerMapIds.gscGoldenrod
                              or mapId == mod.exports.__beta26.gameCornerMapIds.gscCeladonPrizeRoom) then
                          if vm and type(vm.showRaw) == "function" then
                              vm:showRaw("Prize redemption is disabled by your Nuzlocke rules.")
                          end
                          return "end"
                      end
                  end
                  return next(ctx, name, args, cmd)
              end)
          end

          local methods = {}
          for _, name in ipairs({ "SlotMachine", "CardFlip" }) do
              local previousHandlers = Specials.HANDLERS[name]
              local previousAll = Specials.ALL[name]
              local function wrap(previous)
                  if type(previous) ~= "function" then return nil end
                  return function(vm)
                      local game = currentGame or mod.game
                      if mod.exports.__beta26.ruleActive(game, "no_gambling") then
                          if vm and type(vm.showRaw) == "function" then
                              vm:showRaw("Gambling is disabled by your Nuzlocke rules.")
                          end
                          return
                      end
                      return previous(vm)
                  end
              end
              local wrapperHandlers = wrap(previousHandlers)
              local wrapperAll = wrap(previousAll)
              if wrapperHandlers then Specials.HANDLERS[name] = wrapperHandlers end
              if wrapperAll then Specials.ALL[name] = wrapperAll end
              if wrapperHandlers or wrapperAll then
                  methods[name] = {
                      previousHandlers = previousHandlers,
                      wrapperHandlers = wrapperHandlers,
                      previousAll = previousAll,
                      wrapperAll = wrapperAll,
                  }
              end
          end
          Specials.__nuzlockeGamblingSession = { owner = mod, methods = methods }
          return true
      end

      -----------------------------------------------------------------
      -- GOLD WHITEOUT CONSEQUENCE
      --
      -- G2.onFaint marks the Gen 2 battle model with nuzlockeGameOver. Gold
      -- uses src.ui.gen2.BattleState rather than Gen 1's BattleState, so it
      -- needs its own finishBattle consumer. Let the native Gen 2 screen own
      -- alarm/menu/volatile cleanup, suppress only the normal overworld
      -- blackout callback, then perform the Nuzlocke run-ending flow.
      -----------------------------------------------------------------
      function G2.installWhiteoutGate()
          if not G2.isGold() then return false end
          local okBS, BS = pcall(require, "src.ui.gen2.BattleState")
          if not okBS or type(BS) ~= "table"
              or type(BS.finishBattle) ~= "function" then
              return false
          end
          if BS.__nuzlockeBeta266Whiteout then return true end
          BS.__nuzlockeBeta266Whiteout = true

          local vanillaFinishBattle = BS.finishBattle
          BS.finishBattle = function(self, ...)
              local battle = self and self.battle
              if not (battle and battle.nuzlockeGameOver) then
                  return vanillaFinishBattle(self, ...)
              end

              battle.nuzlockeGameOver = nil
              battle.nuzlockeRunEnded = true
              battle.outcome = "lose"
              if self then self.nuzlockeRunEnded = true end

              -- The native World onDone("lose") heals, halves money and warps
              -- home. Suppress only that callback while retaining Gen 2's own
              -- finishBattle cleanup: stopAlarm, cursor cleanup and volatile
              -- teardown.
              local savedOnDone = self.onDone
              self.onDone = nil
              local finishOk, finishErr = pcall(vanillaFinishBattle, self, ...)
              self.onDone = savedOnDone

              local game = self and self.game
              local world = game and game.world
              if world then
                  world.battleActive = nil
                  world.lastBattleResult = 1
              end

              -- With onDone suppressed the battle screen is still on the
              -- stack. Pop exactly this screen; never pop an unrelated one.
              if game and game.stack and game.stack.top
                  and game.stack:top() == self then
                  pcall(function() game.stack:pop() end)
              end

              local function showCreditsAndTitle()
                  local okScreens, Screens = pcall(require, "src.ui.Screens")
                  if okScreens and Screens and game and game.stack then
                      local ending = Screens.push(game, "Gen2Credits", function()
                          local musicOk, Music = pcall(require, "src.core.Music")
                          if musicOk and Music then Music.stop() end
                          while game.stack:top() do game.stack:pop() end
                          if game.makeTitleState then
                              game.stack:push(game:makeTitleState())
                          end
                      end)
                      if ending then ending.phase, ending.timer = "end_wait", 0 end
                  end
              end

              local function deleteCurrentRunSave()
                  local okSave, SaveData = pcall(require, "src.core.SaveData")
                  if not okSave or not SaveData then
                      return false, "SaveData unavailable"
                  end

                  local version = game and game.save and game.save.version or nil
                  local okVersion, GameVersion = pcall(require, "src.core.GameVersion")
                  if okVersion and GameVersion
                      and type(GameVersion.get) == "function" then
                      local okGet, detected = pcall(GameVersion.get)
                      if okGet and detected ~= nil then version = detected end
                  end
                  if version == nil then
                      return false, "game version unavailable"
                  end

                  local mainName
                  if type(SaveData.saveFilename) == "function" then
                      local okName, value = pcall(SaveData.saveFilename, version)
                      if okName and type(value) == "string" and value ~= "" then
                          mainName = value
                      end
                  end

                  local slot
                  if type(SaveData.activeSlot) == "function" then
                      local okSlot, value = pcall(SaveData.activeSlot, version)
                      if okSlot then slot = value end
                  end

                  local deleted = false
                  local detail
                  if slot and type(SaveData.deleteSlot) == "function" then
                      local okDelete, result, err =
                          pcall(SaveData.deleteSlot, version, slot)
                      if okDelete and result == true then
                          deleted = true
                      else
                          detail = tostring(err or result or "slot delete failed")
                      end
                  end

                  if mainName and type(SaveData.persistenceFs) == "function" then
                      local okFs, fs = pcall(SaveData.persistenceFs)
                      if okFs and fs and type(fs.remove) == "function" then
                          pcall(fs.remove, mainName)
                          pcall(fs.remove, mainName .. ".bak")
                          pcall(fs.remove, mainName .. ".tmp")
                          if type(fs.getInfo) == "function" then
                              local okInfo, info = pcall(fs.getInfo, mainName)
                              if okInfo and info == nil then deleted = true end
                          elseif not slot then
                              deleted = true
                          end
                      end
                  end
                  return deleted, detail
              end

              local function deleteSaveAndShowTitle()
                  local deleted, deleteError = deleteCurrentRunSave()
                  if not deleted then
                      local okText, TextBox = pcall(require, "src.render.TextBox")
                      if okText and TextBox and game and game.stack then
                          local message = Strings("SAVE DELETE FAILED.\nThis Nuzlocke run is over.\nDelete the save manually.")
                          if deleteError and deleteError ~= "" then
                              message = message .. "\n" .. tostring(deleteError)
                          end
                          game.stack:push(TextBox.new(game, message,
                              function() showCreditsAndTitle() end))
                          return
                      end
                  end
                  showCreditsAndTitle()
              end

              if not finishOk then
                  -- We still own the run-ending consequence if Gen 2 cleanup
                  -- changes under us; surface the cleanup failure only through
                  -- the diagnostic save-delete failure path rather than
                  -- invoking Gold's normal heal/warp callback.
                  battle.nuzlockeWhiteoutFinishError = tostring(finishErr or "finishBattle failed")
              end

              if worldTier(game) >= 3 then
                  local losses = tonumber(mod.save:get("nuzlocke_losses", 0)) or 0
                  local catches = countTrackerCatches()
                  local badges = game and game.save and currentBadgeCount(game.save) or 0
                  local last = mod.save:get("last_loss", {}) or {}
                  local lastName = tostring(last.name or "NONE")
                  local lastLoc = routeName(last.location or "UNKNOWN")
                  local summary = Strings("NUZLOCKE OVER\nBADGES: %d\nCAUGHT: %d  LOST: %d\nLAST LOSS: %s\n%s",
                      badges, catches, losses, lastName, lastLoc)
                  local okText, TextBox = pcall(require, "src.render.TextBox")
                  if okText and TextBox and game and game.stack then
                      game.stack:push(TextBox.new(game, summary, function()
                          deleteSaveAndShowTitle()
                      end))
                      return
                  end
              end

              deleteSaveAndShowTitle()
          end
          return true
      end

      -- Gold's starter family. The actual acquisition hook above deliberately
      -- identifies the first party member instead of trusting Elm's Lab map id.
      STARTERS_BY_VERSION.GOLD = {
          CHIKORITA = true, CYNDAQUIL = true, TOTODILE = true,
      }

      -- Keep the starter slot region-correct. R/B/Y retain PALLET_TOWN exactly.
      local beta21RegisterStarterCatch = registerStarterCatch
      registerStarterCatch = function(species, mon)
          if not G2.isGold() then return beta21RegisterStarterCatch(species, mon) end
          if not species then return end
          species = tostring(species):upper()
          local area = "NEW_BARK_TOWN"
          registerArea(area, "New Bark Town")
          markVisited(area)
          if caughtAreas()[area] then
              if mon then
                  mon.catchLocation = area
                  mon.encounterType = "starter"
                  mon.nuzlockeTrackerRegistered = true
              end
              return
          end
          registerSpecialCatch(species, area, "starter", mon)
      end

      -- Gold's tracker is discovery-driven. Do not preload the Gen 1 Kanto
      -- checklist into a Johto run; show only areas the Gold save has actually
      -- visited or registered through encounters/gifts.
      local beta21DisplayRoutes = getDisplayRoutes
      getDisplayRoutes = function(game)
          if not G2.isGold() then return beta21DisplayRoutes(game) end
          syncCurrentArea(game)
          local seen = visitedAreas()
          local caught = caughtAreas()
          local log = trackerLog()
          local list = {}
          for _, r in ipairs(ALL_ROUTES) do
              if (seen[r.id] or caught[r.id] ~= nil or (type(log[r.id]) == "table" and #log[r.id] > 0))
                  and areaAllowedByConfig(r) then
                  list[#list + 1] = r
              end
          end
          table.sort(list, function(a, b)
              return tostring(a.name or a.id) < tostring(b.name or b.id)
          end)
          return list
      end


      -----------------------------------------------------------------
      -- GOLD TRAINER CARD STATUS PAGE
      --
      -- Preserve Gold's native three-page card and expose the Nuzlocke status
      -- page behind SELECT. A/left/right remain owned by the native card.
      -----------------------------------------------------------------
      function G2.ruleNames()
          local names = {}
          if mod.save:get("nuzlocke_enabled", true) ~= true then
              return { Strings("Nuzlocke OFF") }
          end

          local function truthy(value)
              if value == true then return true end
              if type(value) == "number" then return value ~= 0 end
              if type(value) == "string" then
                  local v = value:lower()
                  return v == "true" or v == "on" or v == "yes" or tonumber(v) == 1
              end
              return false
          end

          for _, cat in ipairs(ruleCategories) do
              for _, rule in ipairs(cat.rules) do
                  -- NUZ STAT mirrors Gold's reduced, enforceable rule surface.
                  -- Never display stale R/B/Y-only values from a shared mod
                  -- profile (including deferred Gold item rules).
                  local value = mod.exports.__beta26.goldBetaRules[rule.key]
                      and getConfigValue(rule.key, false) or nil
                  local label
                  if value == nil then
                      label = nil
                  elseif rule.key == "world_building_tier" then
                      local tier = tonumber(value) or 0
                      if tier > 0 then
                          label = Strings("World %s", Strings(
                              ({ [1]="TIER 1", [2]="TIER 2", [3]="TIER 3" })[tier]))
                      end
                  elseif rule.key == "level_cap_scope" then
                      local rawScope = mod.save:get("level_cap_scope", nil)
                      local scope = rawScope == nil and legacyLevelCapScope()
                          or (tonumber(rawScope) or 0)
                      if scope > 0 then
                          label = Strings("Level Caps %s", Strings(
                              ({ [1]="GYMS", [2]="E4", [3]="CHAMP", [4]="POST" })[scope]))
                      end
                  elseif rule.key == "dupes_mode" then
                      local mode = tonumber(value) or 0
                      if mode == 1 then label = Strings("Dupes SPEC")
                      elseif mode == 2 then label = Strings("Dupes FAM") end
                  elseif rule.key == "ball_use_ban_tier" then
                      local mode = tonumber(value) or 0
                      if mode > 0 then
                          label = Strings("Ball Ban %s", Strings(
                              mod.exports.__beta26.ballBanTierLabels[mode]))
                      end
                  elseif rule.key == "player_start_stat_exp" or rule.key == "wild_start_stat_exp"
                      or rule.key == "trainer_start_stat_exp" then
                      local mode = tonumber(value) or 0
                      if mode > 0 then
                          label = Strings("%s %s", Strings(rule.name), Strings(
                              mod.exports.__beta26.statExpPresetLabels[mode] or "0%"))
                      end
                  elseif rule.key == "maximum_bst" then
                      local limit = tonumber(value) or 0
                      if limit > 0 then label = Strings("Max BST %d", limit) end
                  elseif rule.numeric then
                      if (tonumber(value) or 0) > 0 then label = Strings(rule.name) end
                  elseif truthy(value) then
                      label = Strings(rule.name)
                  end
                  if label then names[#names + 1] = label end
              end
          end
          return names
      end

      -----------------------------------------------------------------
      -- GOLD NUZ STATUS SCREEN
      --
      -- Gold's native Trainer Card has its own multi-page lifecycle. Instead
      -- of replacing/patching that engine screen, use the shared START-menu
      -- hook plus the shared screens registry. This is both more compatible
      -- with other mods and visible on the current Gold UI.
      -----------------------------------------------------------------
      mod.content.screens:register("NuzlockeGoldStatusScreen", {
          new = function(game, ctx)
              local self = {
                  game = game,
                  isOpaque = true,
                  ruleScroll = 0,
              }

              function self:update(dt)
                  local input = self.game and self.game.input
                  if not input then return end
                  local names = G2.ruleNames()
                  local visible = 3
                  local maxScroll = math.max(0, #names - visible)
                  if input:wasPressed("down") then
                      self.ruleScroll = math.min(maxScroll, (self.ruleScroll or 0) + 1)
                  elseif input:wasPressed("up") then
                      self.ruleScroll = math.max(0, (self.ruleScroll or 0) - 1)
                  elseif input:wasPressed("b") or input:wasPressed("start") then
                      if self.game and self.game.stack then self.game.stack:pop() end
                  end
              end

              function self:draw()
                  local Chrome = require("src.ui.gen2.Chrome")
                  Chrome.clear()
                  Chrome.box(0, 0, 20, 18)
                  Chrome.print(Strings("NUZ STATUS"), 2, 1)

                  local caught = countTrackerCatches()
                  local deaths = tonumber(mod.save:get("nuzlocke_losses", 0)) or 0
                  local lost = 0
                  local states = mod.save:get("encounter_states", {})
                  if type(states) == "table" then
                      for key, state in pairs(states) do
                          if key ~= "__LEGACY__" and type(state) == "table"
                              and state.status == "FAILED" then
                              lost = lost + 1
                          end
                      end
                  end
                  local cap = nextLevelCap(self.game and self.game.save)

                  Chrome.print(Strings("CAUGHT %d", caught), 2, 3)
                  Chrome.print(Strings("LOST ENC %d", lost), 2, 5)
                  Chrome.print(Strings("DEATHS %d", deaths), 2, 7)
                  Chrome.print(cap >= 100 and Strings("NEXT CAP MAX")
                      or Strings("NEXT CAP LV%d", cap), 2, 9)
                  Chrome.print(Strings("RULES"), 2, 11)

                  local names = G2.ruleNames()
                  local visible = 3
                  local maxScroll = math.max(0, #names - visible)
                  self.ruleScroll = math.max(0, math.min(self.ruleScroll or 0, maxScroll))
                  if #names == 0 then
                      Chrome.print(Strings("No rules active"), 2, 13)
                  else
                      for row = 1, visible do
                          local label = names[self.ruleScroll + row]
                          if not label then break end
                          label = tostring(label)
                          if #label > 16 then label = label:sub(1, 16) end
                          Chrome.print(label, 2, 11 + row * 1)
                      end
                  end
                  if self.ruleScroll > 0 then Chrome.print(Strings("^"), 18, 12) end
                  if self.ruleScroll + visible < #names then Chrome.print(Strings("v"), 18, 14) end
                  Chrome.print(Strings("B:EXIT"), 2, 16)
              end

              return self
          end,
      })

      -- Historical Trainer Card adapter retained for source comparison only.
      -- beta.27.5 no longer installs it; Gold status now uses the public START
      -- menu hook and dedicated screen above.
      function G2.installTrainerCard()
          if not G2.isGold() then return false end
          local okCard, TrainerCard = pcall(require, "src.ui.gen2.TrainerCard")
          local okChrome, Chrome = pcall(require, "src.ui.gen2.Chrome")
          if not okCard or not okChrome or type(TrainerCard) ~= "table"
              or type(TrainerCard.new) ~= "function"
              or type(TrainerCard.update) ~= "function"
              or type(TrainerCard.drawPanel) ~= "function" then
              return false
          end
          if TrainerCard.__nuzlockeGoldStatusInstalled then return true end
          TrainerCard.__nuzlockeGoldStatusInstalled = true

          local vanillaNew = TrainerCard.new
          local vanillaUpdate = TrainerCard.update
          local vanillaDrawPanel = TrainerCard.drawPanel

          TrainerCard.new = function(game, opts)
              local self = vanillaNew(game, opts)
              self.nuzlockeStatusPage = false
              self.nuzlockeRuleScroll = 0
              return self
          end

          TrainerCard.update = function(self, dt)
              local input = self and self.game and self.game.input
              if input and input:wasPressed("select") then
                  self.nuzlockeStatusPage = not self.nuzlockeStatusPage
                  self.nuzlockeRuleScroll = 0
                  return
              end
              if self and self.nuzlockeStatusPage then
                  local names = G2.ruleNames()
                  local visible = 6
                  local maxScroll = math.max(0, #names - visible)
                  if input and input:wasPressed("down") then
                      self.nuzlockeRuleScroll = math.min(maxScroll,
                          (self.nuzlockeRuleScroll or 0) + 1)
                  elseif input and input:wasPressed("up") then
                      self.nuzlockeRuleScroll = math.max(0,
                          (self.nuzlockeRuleScroll or 0) - 1)
                  elseif input and (input:wasPressed("b") or input:wasPressed("start")) then
                      return vanillaUpdate(self, dt)
                  end
                  return
              end
              return vanillaUpdate(self, dt)
          end

          TrainerCard.drawPanel = function(self)
              if not (self and self.nuzlockeStatusPage) then
                  return vanillaDrawPanel(self)
              end
              Chrome.clear()
              Chrome.box(0, 0, 20, 18)
              Chrome.print(Strings("NUZLOCKE STATUS"), 2, 1)
              local profile = getGameProfile()
              Chrome.print((profile and profile.region) or "JOHTO", 2, 3)

              local names = G2.ruleNames()
              local visible = 6
              local scroll = math.max(0, math.min(
                  self.nuzlockeRuleScroll or 0, math.max(0, #names - visible)))
              if #names == 0 then
                  Chrome.print(Strings("No rules active"), 2, 6)
              else
                  for row = 1, visible do
                      local name = names[scroll + row]
                      if not name then break end
                      local label = tostring(name)
                      if #label > 16 then label = label:sub(1, 16) end
                      Chrome.print(label, 2, 4 + row * 2)
                  end
              end
              if scroll > 0 then Chrome.print(Strings("^"), 18, 5) end
              if scroll + visible < #names then Chrome.print(Strings("v"), 18, 15) end
              Chrome.print(Strings("SEL:CARD"), 2, 16)
              Chrome.print(Strings("B:EXIT"), 12, 16)
          end
          return true
      end

      -----------------------------------------------------------------
      -- GEN 2 BREEDING / EGG PROVENANCE
      --
      -- These events record where an egg was created and hatched without
      -- inventing a new Egg Clause or consuming an encounter slot by itself.
      -----------------------------------------------------------------
      function G2.onEggCreated(ev)
          if not G2.isGold() or not ev or not ev.egg then return end
          local game = currentGame or mod.game
          local area = areaKey(game, nil) or "UNKNOWN"
          registerArea(area)
          markVisited(area)

          ev.egg.nuzlockeOrigin = "EGG"
          ev.egg.eggCreatedLocation = area
          ev.egg.eggCompatibility = ev.compatibility

          local records = mod.save:get("g2_egg_provenance", {})
          if type(records) ~= "table" then records = {} end
          records[#records + 1] = {
              status = "CREATED",
              area = area,
              mother = ev.mother and ev.mother.species or nil,
              father = ev.father and ev.father.species or nil,
              compatibility = ev.compatibility,
              stepsToEgg = ev.stepsToEgg,
          }
          mod.save:set("g2_egg_provenance", records)
      end

      function G2.onEggHatched(ev)
          if not G2.isGold() or not ev or not ev.mon then return end
          local game = currentGame or mod.game
          local area = areaKey(game, nil) or "UNKNOWN"
          registerArea(area)
          markVisited(area)

          local mon = ev.mon
          local glitch = mod.exports.__beta26.getGlitchSpeciesInfo(
              game, ev.species or mon.species)
          mon.nuzlockeOrigin = "EGG"
          mon.encounterType = "egg"
          mon.eggHatchLocation = area
          mon.nuzlockeGlitch = glitch.isGlitch or nil
          mon.nuzlockeMissingNo = glitch.missingNo or nil
          mon.nuzlockeRawSpecies = glitch.isGlitch
              and (ev.species or mon.species) or nil
          if ev.egg and ev.egg.eggCreatedLocation then
              mon.eggCreatedLocation = ev.egg.eggCreatedLocation
          end
          Identity.ensurePokemonIdentity(mon, game and game.save, "EGG")
          Identity.setPokemonOrigin(mon, "EGG")
          Identity.baselineAdd(mon, "EGG")

          local records = mod.save:get("g2_egg_provenance", {})
          if type(records) ~= "table" then records = {} end
          records[#records + 1] = {
              status = "HATCHED",
              species = glitch.key,
              rawSpecies = glitch.isGlitch and (ev.species or mon.species) or nil,
              glitch = glitch.isGlitch or nil,
              missingNo = glitch.missingNo or nil,
              nickname = ev.nickname or mon.nickname,
              area = area,
              createdArea = mon.eggCreatedLocation,
              pokemonId = Identity.pokemonIdentity(mon),
          }
          mod.save:set("g2_egg_provenance", records)
      end

      -----------------------------------------------------------------
      -- GEN 2 ROAMER PROVENANCE
      --
      -- A roaming encounter is still judged by the normal catch policy at the
      -- map where the Ball is thrown. These events preserve the roaming
      -- identity and map history so tracker/debug data does not treat each move
      -- as an unrelated static encounter.
      -----------------------------------------------------------------
      function G2.onRoamerMoved(ev)
          if not G2.isGold() or not ev then return end
          local state = mod.save:get("g2_roamers", {})
          if type(state) ~= "table" then state = {} end
          local key = tostring(ev.index or ev.slot or ev.species or "?")
          state[key] = state[key] or {}
          state[key].species = ev.species or state[key].species
          state[key].map = ev.to
          state[key].previous = ev.from
          state[key].reason = ev.reason
          mod.save:set("g2_roamers", state)
      end

      function G2.onRoamerEncountered(ev)
          if not G2.isGold() or not ev then return end
          local mapId = ev.mapId
          if mapId then
              registerArea(mapId)
              markVisited(mapId)
          end
          local state = mod.save:get("g2_roamers", {})
          if type(state) ~= "table" then state = {} end
          local key = tostring(ev.index or ev.slot or ev.species or "?")
          state[key] = state[key] or {}
          state[key].species = ev.species or state[key].species
          state[key].level = ev.level or state[key].level
          state[key].lastEncounter = mapId
          state[key].encounters = (tonumber(state[key].encounters) or 0) + 1
          mod.save:set("g2_roamers", state)
      end

      mod.events:on("battle.damage_dealt", G2.noteDamage)
      mod.events:on("battle.fainted", G2.onFaint)
      mod.events:on("breeding.egg_created", G2.onEggCreated)
      mod.events:on("egg.hatched", G2.onEggHatched)
      mod.events:on("roamer.moved", G2.onRoamerMoved)
      mod.events:on("roamer.encountered", G2.onRoamerEncountered)

      function G2.installAll()
          if mod.exports.__beta26.isSaveEditorSession() then return true end
          if not G2.isGold() then return end
          pcall(G2.installCaptureGate)
          pcall(G2.installNicknameGate)
          pcall(G2.installMartGate)
          pcall(G2.installFieldItemGate)
          pcall(G2.installCatchTutorialSkip)
          pcall(G2.installGiftTracking)
          pcall(G2.installStaticTracking)
          pcall(G2.installGamblingGate)
          pcall(G2.installWhiteoutGate)
          -- Gold NUZ STATUS is provided by ui.start_menu.items + screens registry.
          -- Do not install the legacy TrainerCard monkey patch.
      end

      pcall(G2.installAll)
      mod.events:on("game.ready", function() pcall(G2.installAll) end)
      mod.events:on("save.loaded", function() pcall(G2.installAll) end)
  end

end
