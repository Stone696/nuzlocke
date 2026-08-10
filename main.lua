-- Nuzlocke Rules 2.0.0-beta.15 - Menu crash fix
return function(mod)
  local Stats = require("src.pokemon.Stats")
  local Growth = require("src.pokemon.Growth")
  local Data = require("src.core.Data")
  local catchDeniedReason
  local isTownArea
  local enemyIsShiny
  local currentGame
  local currentSave
  local refreshGymGuideVisibility

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
  local CURRENT_SAVE_SCHEMA = 2
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
          version = version + 1
          if version == 2 then
              mod.save:set("wonderlocke", false)
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

  mod.events:on("game.ready", function(game)
      currentGame = game
      currentSave = game and game.save or currentSave
      -- Wonderlocke is WIP and cannot be enabled in this beta.
      if mod.save:get("wonderlocke", false) ~= false then
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
      npc_talk = nil, npc_behavior = nil, npc_visibility = nil, npc_movement = nil, wonder_trade = nil,
  }
  local COMPAT_CAPABILITIES = {
      "level_caps", "postgame_caps", "escape", "encounters",
      "npc_talk", "npc_behavior", "npc_visibility", "npc_movement", "wonder_trade",
  }

  local function providerValue(exports, capability)
      if type(exports) ~= "table" then return nil end
      local providers = exports.nuzlocke_provider
      if type(providers) == "table" and providers[capability] ~= nil then return providers[capability] end
      return exports[capability]
  end

  local function providerIsActive(provider, game, battle)
      if not provider then return false end
      if type(provider) == "table" and type(provider.is_active) == "function" then
          local ok, result = pcall(provider.is_active, game, battle)
          return ok and result == true
      end
      return true
  end

  local function discoverCompatProviders(loader)
      for _, capability in ipairs(COMPAT_CAPABILITIES) do COMPAT_PROVIDERS[capability] = nil end
      if not loader or type(loader.status) ~= "function" then return end
      local ok, status = pcall(function() return loader:status() end)
      if not ok or type(status) ~= "table" or type(status.loaded) ~= "table" then return end
      for _, manifest in ipairs(status.loaded) do
          local id = manifest and manifest.id
          if id then
              local foundOk, other = pcall(mod.find, id)
              if foundOk and other and other.exports then
                  for _, capability in ipairs(COMPAT_CAPABILITIES) do
                      if not COMPAT_PROVIDERS[capability] then
                          local value = providerValue(other.exports, capability)
                          if value ~= nil then COMPAT_PROVIDERS[capability] = { id=id, version=other.version, value=value } end
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
  -- owning the Nuzlocke behavior. This is the important distinction for mods
  -- such as Kanto Life and NPC Bubbles, which modify/observe NPCs without
  -- owning the Gym Guide or Nuzlocke encounter rules.
  local function providerExclusive(capability, game, battle)
      local provider = activeCompatProvider(capability, game, battle)
      local value = provider and provider.value
      return provider and type(value) == "table" and value.exclusive == true
          or false
  end

  -- The engine's talk registry can tell us whether a callable talk entry came
  -- from a mod. This is safer than guessing from a mod name or description,
  -- and mirrors the useful source/provenance check used by NPC Bubbles.
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
      version = 6,
      capabilities = COMPAT_CAPABILITIES,
      ownership = {
          encounter_tracking = true,
          gym_guide_rare_candy = true,
      },
      wonderlocke = {
          capability = "wonder_trade",
          contract = "Provider may expose get_context(game) returning { area = <source encounter area> } for a Wonder Trade receipt. Event fields such as originArea/wonderTradeArea are accepted as fallback.",
      },
      -- Wonderlocke is intentionally marked BETA in the player-facing rule name/description.
   -- Keep the provider contract experimental until real Wonder Trade mods have been
   -- tested against it; do not present it as a fully certified mechanic yet.
   -- These helpers are intentionally behavioral rather than name based.
      -- Other mods may use them to decide whether a Nuzlocke feature should
      -- compose with their own NPC systems.
      isTrainerDefinition = isTrainerDefinition,
      talkEntryIsExternal = talkEntryIsExternal,
  }
  mod.events:on("mods.loaded", function(ev) discoverCompatProviders(ev and ev.loader) end)

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
      { id = "PALLET_TOWN",      name = "Pallet Town"    },
      { id = "ROUTE_1",          name = "Route 1"        },
      { id = "VIRIDIAN_CITY",    name = "Viridian City"  },
      { id = "ROUTE_22",         name = "Route 22"       },
      { id = "ROUTE_2",          name = "Route 2"        },
      { id = "VIRIDIAN_FOREST",  name = "Virid. Forest"  },
      { id = "PEWTER_CITY",      name = "Pewter City"    },
      { id = "ROUTE_3",          name = "Route 3"        },
      { id = "MT_MOON",          name = "Mt. Moon"       },
      { id = "ROUTE_4",          name = "Route 4"        },
      { id = "CERULEAN_CITY",    name = "Cerulean City"  },
      { id = "CERULEAN_GYM",     name = "Cerulean Gym"   },
      { id = "ROUTE_24",         name = "Route 24"       },
      { id = "ROUTE_25",         name = "Route 25"       },
      { id = "ROUTE_5",          name = "Route 5"        },
      { id = "ROUTE_6",          name = "Route 6"        },
      { id = "VERMILION_CITY",   name = "Vermilion City" },
      { id = "VERMILION_HARBOR", name = "Vermilion Harbor" },
      { id = "ROUTE_11",         name = "Route 11"       },
      { id = "DIGLETT_CAVE",     name = "Diglett Cave"   },
      { id = "ROUTE_9",          name = "Route 9"        },
      { id = "ROUTE_10",         name = "Route 10"       },
      { id = "ROCK_TUNNEL",      name = "Rock Tunnel"    },
      { id = "POWER_PLANT",      name = "Power Plant"    },
      { id = "LAVENDER_TOWN",    name = "Lavender Town"  },
      { id = "POKEMON_TOWER",    name = "Pkmn Tower"     },
      { id = "ROUTE_12",         name = "Route 12"       },
      { id = "ROUTE_13",         name = "Route 13"       },
      { id = "ROUTE_14",         name = "Route 14"       },
      { id = "ROUTE_15",         name = "Route 15"       },
      { id = "FUCHSIA_CITY",     name = "Fuchsia City"   },
      { id = "SAFARI_ZONE",      name = "Safari Zone"    },
      { id = "CELADON_CITY",     name = "Celadon City"   },
      { id = "ROUTE_16",         name = "Route 16"       },
      { id = "ROUTE_17",         name = "Route 17"       },
      { id = "ROUTE_18",         name = "Route 18"       },
      { id = "ROUTE_7",          name = "Route 7"        },
      { id = "ROUTE_8",          name = "Route 8"        },
      { id = "SAFFRON_CITY",     name = "Saffron City"   },
      { id = "SILPH_CO",         name = "Silph Co."      },
      { id = "ROUTE_19",         name = "Route 19"       },
      { id = "ROUTE_20",         name = "Route 20"       },
      { id = "SEAFOAM_ISLANDS",  name = "Seafoam Isls."  },
      { id = "CINNABAR_ISLAND",  name = "Cinnabar Isl."  },
      { id = "POKEMON_MANSION",  name = "Pkmn Mansion"   },
      { id = "ROUTE_21",         name = "Route 21"       },
      { id = "ROUTE_23",         name = "Route 23"       },
      { id = "VICTORY_ROAD",     name = "Victory Road"   },
      { id = "CERULEAN_CAVE",    name = "Cerulean Cave"  },
  }

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
      CeruleanCity     = "CERULEAN_CITY",
      VermilionCity    = "VERMILION_CITY",
      DiglettsCave     = "DIGLETT_CAVE",
      DiglettCave      = "DIGLETT_CAVE",
      LavenderTown     = "LAVENDER_TOWN",
      PokemonTower     = "POKEMON_TOWER",
      CeladonCity      = "CELADON_CITY",
      SafariZone       = "SAFARI_ZONE",
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
      if mapId:match("^[%w_%-]+$") then
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
      return formatAreaDisplayName(ROUTE_NAMES[id], id)
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
                  if type(entry) == "table" and entry.species then
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
  local function areaKey(game, battle)
      if battle and battle.safari then
          return "SAFARI_ZONE"
      end

      local mapId

      if game and game.overworld and game.overworld.map then
          mapId = game.overworld.map.id
      end

      if not mapId and game and game.save and game.save.player then
          mapId = game.save.player.map
      end

      return routeKey(mapId)
  end

  ---------------------------------------------------------------------
  -- MARK AREA VISITED
  ---------------------------------------------------------------------
  local function markVisited(key)
      key = registerArea(key)

      if not isTrackedArea(key) then
          return false
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
                              isShiny = catch.isShiny == true,
                              encounterType = catch.encounterType,
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
  -- POKEMON PROVENANCE
  --
  -- Gen 1 Pokemon have no native persistent identity or edit history. We
  -- therefore maintain a small Nuzlocke-owned baseline using species + DVs.
  -- The baseline is deliberately limited to identity-like fields so normal
  -- gameplay changes (level, EXP, HP, moves, etc.) do not look like edits.
  --
  -- On first initialization, every Pokemon already present is LEGACY. On
  -- later loads, a new identity that was not registered by our acquisition
  -- hooks is EDITED. Legitimate catches/gifts/trades register themselves and
  -- are added to the baseline immediately.
  ---------------------------------------------------------------------
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

  local function allCurrentMons(save)
      return collectLegacyMons(save)
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

  local function baselineAdd(mon, origin)
      local fp = pokemonFingerprint(mon)
      if not fp then return end
      origin = origin or mon.nuzlockeOrigin or "NORMAL"
      local baseline = pokemonBaseline()
      baseline[fp] = (tonumber(baseline[fp]) or 0) + 1
      local origins = originBucket(origin)
      origins[origin][fp] = (tonumber(origins[origin][fp]) or 0) + 1
      mod.save:set("nuzlocke_pokemon_baseline", baseline)
      mod.save:set("nuzlocke_pokemon_origins", origins)
  end

  local function setPokemonOrigin(mon, origin)
      if type(mon) == "table" and origin then
          mon.nuzlockeOrigin = origin
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

      if initializing then
          baseline = {}
          origins = { LEGACY = {}, NORMAL = {}, EDITED = {}, PLAYER_CONFIRMED = {} }

          -- If this is an older Nuzlocke save, its tracker log is stronger
          -- evidence than the absence of a new provenance registry. Entries
          -- recorded during the run are NORMAL; retroactive/recovered entries
          -- remain LEGACY. A completely vanilla save has no such evidence, so
          -- every Pokemon present at first initialization is LEGACY.
          local existingLog = mod.save:get("tracker_log")
          local knownNormal = {}
          local knownLegacy = {}
          if type(existingLog) == "table" then
              for area, entries in pairs(existingLog) do
                  if area ~= "__LEGACY__" and type(entries) == "table" then
                      for _, entry in ipairs(entries) do
                          if type(entry) == "table" and entry.species then
                              local sp = tostring(entry.species):upper()
                              if entry.provenance == "LEGACY" or entry.legacy == true or entry.retroactive == true then
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
              local origin = "LEGACY"
              if (usedNormal[sp] or 0) < (knownNormal[sp] or 0) then
                  usedNormal[sp] = (usedNormal[sp] or 0) + 1
                  origin = "NORMAL"
              elseif (usedLegacy[sp] or 0) < (knownLegacy[sp] or 0) then
                  usedLegacy[sp] = (usedLegacy[sp] or 0) + 1
                  origin = "LEGACY"
              end

              setPokemonOrigin(mon, origin)
              local fp = pokemonFingerprint(mon)
              if fp then
                  baseline[fp] = (baseline[fp] or 0) + 1
                  origins[origin][fp] = (origins[origin][fp] or 0) + 1
              end
          end
          mod.save:set("nuzlocke_pokemon_baseline", baseline)
          mod.save:set("nuzlocke_pokemon_origins", origins)
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

      for _, mon in ipairs(mons) do
          local fp = pokemonFingerprint(mon)
          local known = fp and remaining[fp] or 0
          if known and known > 0 then
              remaining[fp] = known - 1
              local preferred = mon.nuzlockeTrackerRegistered and "NORMAL" or nil
              local origin = fp and consumeOrigin(origins, fp, preferred)
              setPokemonOrigin(mon, origin or preferred or "LEGACY")
          elseif mon.nuzlockeTrackerRegistered == true then
              setPokemonOrigin(mon, "NORMAL")
              baselineAdd(mon, "NORMAL")
          else
              setPokemonOrigin(mon, "EDITED")
              local edited = origins.EDITED or {}
              edited[fp] = (tonumber(edited[fp]) or 0) + 1
              origins.EDITED = edited
              if fp then
                  remaining[fp] = (remaining[fp] or 0) + 1
              end
          end
      end

      local rebuilt = {}
      for _, mon in ipairs(mons) do
          local fp = pokemonFingerprint(mon)
          if fp then rebuilt[fp] = (rebuilt[fp] or 0) + 1 end
      end
      for fp, count in pairs(remaining) do
          if count > 0 then rebuilt[fp] = (rebuilt[fp] or 0) + count end
      end
      mod.save:set("nuzlocke_pokemon_baseline", rebuilt)
      mod.save:set("nuzlocke_pokemon_origins", origins)
  end
  local function restoreKnownCatchMetadata(save, log)
      -- Imported/old Gen 1 saves do not serialize our transient Pokemon fields.
      -- Rebuild those fields from the Nuzlocke tracker data when the tracker
      -- already knows the species/location. This is stronger evidence than
      -- vanilla encounter inference and prevents legitimate old catches from
      -- being demoted to LEGACY merely because the Pokemon object lost its
      -- runtime metadata during save conversion.
      local assignments = {}

      local function addEvidence(area, entry)
          if area == "__LEGACY__" or type(entry) ~= "table" or not entry.species then
              return
          end
          local sp = tostring(entry.species):upper()
          assignments[sp] = assignments[sp] or {}
          assignments[sp][#assignments[sp] + 1] = {
              area = area,
              encounterType = entry.encounterType,
              encounterSource = entry.encounterSource,
              encounterProvider = entry.encounterProvider,
              encounterProviderVersion = entry.encounterProviderVersion,
              encounterContext = entry.encounterContext,
          }
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
              local list = assignments[sp]
              local slot = list and 1 or nil
              while slot and used[sp .. ":" .. tostring(slot)] do
                  slot = slot + 1
                  if not list[slot] then slot = nil end
              end
              local evidence = slot and list[slot] or nil
              if evidence and evidence.area then
                  used[sp .. ":" .. tostring(slot)] = true
                  mon.catchLocation = evidence.area
                  mon.encounterType = evidence.encounterType or mon.encounterType or "wild"
                  mon.nuzlockeEncounterSource = evidence.encounterSource or mon.nuzlockeEncounterSource
                  mon.nuzlockeEncounterProvider = evidence.encounterProvider or mon.nuzlockeEncounterProvider
                  mon.nuzlockeEncounterProviderVersion = evidence.encounterProviderVersion or mon.nuzlockeEncounterProviderVersion
                  if evidence.encounterContext then
                      mon.nuzlockeEncounterContext = evidence.encounterContext
                  end
                  mon.nuzlockeTrackerRegistered = true
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
                  for _, entry in ipairs(log[area]) do
                      if type(entry) == "table" and tostring(entry.species or ""):upper() == sp then
                          found = true
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
                          isShiny = mon.dvs and Stats.isShiny(mon.dvs) or false,
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

      for _, entry in ipairs(legacy) do
          if type(entry) == "table" then
              local species = tostring(entry.species or "")
              existing[species] = (existing[species] or 0) + 1
          end
      end

      local currentCounts = {}

      -- A Pokemon with catchLocation was caught after the tracker was active.
      -- It must never be copied into LEGACY just because it is present in the
      -- current save's party/boxes.
      for _, mon in ipairs(collectLegacyMons(save)) do
          if not mon.catchLocation then
              local species = tostring(mon.species or "")

              currentCounts[species] = (currentCounts[species] or 0) + 1

              if currentCounts[species] > (existing[species] or 0) then
                  table.insert(legacy, {
                      species = species,
                      isShiny = mon.dvs and Stats.isShiny(mon.dvs) or false,
                      legacy = true
                  })
              end
          end
      end

      -- Remove accidental legacy entries for Pokemon that the tracker already
      -- knows were caught in a real area.  This repairs saves that were loaded
      -- by an earlier version which incorrectly added current Pokemon to
      -- LEGACY.
      local knownCaught = {}
      for area, catches in pairs(log) do
          if area ~= "__LEGACY__" and type(catches) == "table" then
              for _, catch in ipairs(catches) do
                  if type(catch) == "table" and catch.species then
                      knownCaught[tostring(catch.species)] = true
                  end
              end
          end
      end

      local cleanedLegacy = {}
      for _, entry in ipairs(legacy) do
          if type(entry) == "table"
              and entry.species
              and not knownCaught[tostring(entry.species)] then
              table.insert(cleanedLegacy, entry)
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

  local function legacyEntryKey(entry, index)
      return tostring(index) .. ":" .. tostring(entry and entry.species or "")
          .. ":" .. tostring(entry and entry.isShiny == true)
  end

  local function recoverUniqueLegacyCatches(game, log, areas)
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

      if rebuildVersion == "YELLOW" then
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

  local function canInferVanillaEncounterLocations()
      -- If this Nuzlocke save has ever observed an external encounter provider,
      -- an unknown old Pokemon may have been generated while that provider was
      -- active even if it is disabled now. Do not retroactively apply vanilla
      -- encounter tables to those saves.
      local history = mod.save:get("encounter_provider_history")
      if type(history) == "table" and next(history) ~= nil then
          return false
      end
      return activeCompatProvider("encounters", currentGame, nil) == nil
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

      local rebuildVersion = "RED"
      pcall(function()
          local GameVersion = require("src.core.GameVersion")
          local v = tostring(GameVersion.get() or "RED"):upper()
          if v:find("YELLOW", 1, true) then
              rebuildVersion = "YELLOW"
          elseif v:find("BLUE", 1, true) then
              rebuildVersion = "BLUE"
          end
      end)

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
                      isShiny       = starterMon.dvs
                          and Stats.isShiny(starterMon.dvs) or false,
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
      recoverUniqueLegacyCatches(currentGame or { data = Data, save = save }, log, areas)

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
              if type(entry) ~= "table" or type(mon) ~= "table" then return false end
              local esp = tostring(entry.species or ""):upper()
              local msp = tostring(mon.species or ""):upper()
              if esp ~= msp then return false end

              -- Prefer fingerprint identity when available.  Legacy tracker
              -- entries from older versions may not have a fingerprint, so
              -- species/location remains the compatibility fallback.
              local efp = entry.fingerprint
              local mfp = pokemonFingerprint(mon)
              if efp and mfp then return efp == mfp end
              return true
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
                                  or (mon.dvs and Stats.isShiny(mon.dvs) or false)
                              entry.fingerprint = entry.fingerprint or pokemonFingerprint(mon)
                              entry.retroactive = entry.retroactive or true
                              entry.recoveryStatus = entry.recoveryStatus or "LEGACY_METADATA"
                              break
                          end
                      end

                      if not exists then
                          table.insert(log[area], {
                              species = tostring(mon.species):upper(),
                              isShiny = mon.dvs and Stats.isShiny(mon.dvs) or false,
                              encounterType = normalizeType(mon),
                              encounterSource = mon.nuzlockeEncounterSource or "legacy_save",
                              encounterProvider = mon.nuzlockeEncounterProvider,
                              encounterProviderVersion = mon.nuzlockeEncounterProviderVersion,
                              encounterContext = mon.nuzlockeEncounterContext,
                              fingerprint = pokemonFingerprint(mon),
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
                          setPokemonOrigin(mon, "LEGACY")
                      end
                      mon.encounterType = mon.encounterType or "wild"
                      mon.nuzlockeTrackerRegistered = true
                      baselineAdd(mon, mon.nuzlockeOrigin or "LEGACY")
                      markVisited(area)

                      -- Remove one matching entry from __LEGACY__ if an older
                      -- migration placed this same Pokemon there.
                      local legacy = log.__LEGACY__
                      if type(legacy) == "table" then
                          local fp = pokemonFingerprint(mon)
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
      initializePokemonProvenance(save)

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

  ---------------------------------------------------------------------
  -- RULE DEFINITIONS
  ---------------------------------------------------------------------
  local LEGENDARIES = {
      ARTICUNO = true,
      ZAPDOS   = true,
      MOLTRES  = true,
      MEWTWO   = true,
  }

  local MYTHICALS = {
      MEW = true,
  }

  local ruleCategories = {
      {
          title = "- CORE -",
          rules = {
              { key = "nuzlocke_enabled", name = "Nuzlocke", desc = "Master switch for all Nuzlocke rules. Toggle this off to disable everything." },
              { key = "permadeath",       name = "Permadeath", desc = "Fainted Pokemon are considered dead and removed from the party." },
              { key = "encounter_limit",  name = "1st Catch", desc = "Only the first eligible catch per area can be caught." },
              { key = "failed_encounter", name = "Failed Encounters", desc = "If ON, your first eligible wild/overworld encounter consumes the area even if you defeat it, flee, or fail to catch it. Dupes encounters do not consume the area while Dupes Clause is ON; shiny Pokemon are always allowed when Shiny Clause is ON." },
              { key = "nickname_rule",   name = "Nickname Rule", desc = "You must enter a nickname for every Pokemon you catch." },
          }
      },
      {
          title = "- CLAUSES -",
          rules = {
              { key = "dupes_mode",      name = "Dupes Clause", desc = "Previously caught duplicate families do not count as the area encounter and cannot be caught, unless shiny." },
              { key = "shiny_clause",    name = "Shiny Clause", desc = "Shiny Pokemon are always allowed as catches, even when they would otherwise violate 1st Catch or Dupes." },
          }
      },
      {
          title = "- GENERAL -",
          rules = {
              { key = "overworld_encounters", name = "Overworld", desc = "Allow Pokemon caught from overworld spawns to count as area encounters." },
              { key = "town_catches",         name = "Town Catches", desc = "Allow Pokemon caught in towns/cities to count as encounters. Pallet Town starter slot is always tracked regardless." },
              { key = "ban_legendaries",      name = "No Legend", desc = "Legendary Pokemon (Articuno, Zapdos, Moltres, Mewtwo) cannot be caught or used." },
              { key = "ban_mythicals",        name = "No Mythic", desc = "Mythical Pokemon (Mew) cannot be caught or used." },
              { key = "allow_gifts",      name = "Gift Pokemon", desc = "Gift Pokemon (Eevee, Lapras, Fossils, etc.) are allowed and consume the area slot where they were received." },
              { key = "allow_trades",     name = "In-Game Trades", desc = "In-game traded Pokemon are allowed and consume the area slot where the trade NPC lives. Version-specific trades (Red/Blue/Yellow) are all accounted for." },
              { key = "wonderlocke", name = "Wonderlocke WIP", desc = "WIP: Wonderlocke is not currently selectable or active. It remains disabled while Wonder Trade compatibility is being completed and tested." },
          }
      },
      {
          title = "- HARDCORE -",
          rules = {
              { key = "level_cap_scope", name = "Level Cap Scope", numeric = true, digits = 1, min = 0, max = 4, desc = "Choose how far level caps continue. NONE = no caps. GYMS = Gym caps only. E4 = continue through Lorelei, Bruno, Agatha, and Lance. CHAMP = also cap the Champion. POSTGAME = also accept an active post-game cap provider from another mod. Each option includes everything before it. RECOMMENDED: E4 or CHAMP for a full Kanto run; POSTGAME if another mod adds post-game content." },
              { key = "no_healing_items", name = "No Healing Items", desc = "Potions, Revives, and status-healing items cannot be used in battle." },
              { key = "no_battle_items",  name = "No X Items", desc = "X Attack, X Defend, and similar non-healing battle items cannot be used in battle. Poke Balls are unaffected." },
              { key = "no_escape",         name = "No Escape", desc = "You cannot run from wild Pokemon. The RUN command always fails and the turn is spent." },
          }
      },
      {
          title = "- IRONMON -",
          rules = {
              { key = "no_shopping",     name = "No Shop", desc = "Cannot buy from Poke Marts. The clerk will politely refuse you." },
              { key = "no_poke_center",  name = "No PokeCenter", desc = "Cannot heal at Pokemon Centers. Nurse Joy will turn you away." },
              { key = "no_mom_heal",      name = "No Mom Heal", desc = "Mom cannot heal your party when you visit home. She will remind you of your rules instead." },
              { key = "whiteout_clause",  name = "Whiteout", desc = "If every Pokemon in the party is dead, the run ends and the save is deleted permanently." },
              { key = "solo_active",      name = "Solo Only", desc = "Only one Pokemon in the active party slot. Enforced at catch time; does not block PC swaps." },
          }
      },
      {
          title = "- WORLD -",
          rules = {
              { key = "world_building_tier", name = "World Building", numeric = true, digits = 1, min = 0, max = 3, desc = "Adds optional Nuzlocke flavor throughout Kanto. TIER 1 = core rule feedback, TIER 2 = extra snark, TIER 3 = NPC and story flavor. OFF disables all Nuzlocke world-building dialogue. RECOMMENDED: TIER 3. This is cosmetic and can be changed at any time." },
          }
      },
      {
          title = "- UI -",
          rules = {
              { key = "catch_info", name = "Catch Info", desc = "Show CATCH INFO in the party menu for Pokemon you own." },
              { key = "area_guide_enabled", name = "Area Guide", desc = "Show the second Encounter Tracker page with all catchable areas. Turn OFF to restrict the tracker to your catches only." },
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

  local SETUP_PROFILE_FILE = "nuzlocke_setup_profile.lua"

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

  -- These keys persist the staged setup independently of the active save-rule
  -- keys.  They are declared here and used after copyRuleProfile is defined.
  local STAGED_PROFILE_KEY = "__nuzlocke_staged_new_game_profile"
  local STAGED_INTENT_KEY = "__nuzlocke_staged_new_game_intent"

  ---------------------------------------------------------------------
  -- NEW GAME STARTER SETTINGS
  -- These values are read only when a brand-new save is constructed.
  -- Existing saves are never rewritten by this hook.
  ---------------------------------------------------------------------
  mod.hooks:wrap("save.new_game", function(next, save)
      local result = next(save)
      currentSave = result or save or currentSave
      if currentGame and currentSave then currentGame.save = currentSave end

      -- Agreed defaults for a new Nuzlocke run. The player can change these
      -- in NZLCKE SETUP before starting the NEW GAME.
      local startingMoney = 0
      local startingBalls = 0
      local profile = newGameRulesSnapshot or pendingNewGameRules
      if profile then
          startingMoney = math.max(0, math.min(9999,
              tonumber(profile.starting_money) or 0))
          startingBalls = math.max(0, math.min(99,
              tonumber(profile.starting_pokeballs) or 0))
      end

      result.money = startingMoney
      result.pcItems = result.pcItems or {}
      result.pcItems.POKE_BALL = startingBalls

      -- Optional NEW GAME utility: seed the room PC with 99 Rare Candies.
      -- This is deliberately only read from the NEW GAME setup profile, so
      -- existing saves are never modified.
      if profile and profile.starting_rare_candies == true then
          result.pcItems.RARE_CANDY = 99
      end

      return result
  end)

  local function defaultRuleValue(key)
      if key == "starting_money" then
          return 0      -- NEW GAME default; configurable in SETUP
      end
      if key == "starting_pokeballs" then
          return 0      -- NEW GAME default; placed in the room PC
      end
      if key == "starting_rare_candies" then
          return false  -- NEW GAME default; optional 99 Rare Candies in the room PC
      end
      if key == "nuzlocke_enabled" or key == "permadeath" then
          return true
      end
      if key == "world_building_tier" then
          return 3
      end
      if key == "level_cap_scope" then
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
          or key == "infinite_rare_candies" or key == "wonderlocke" then
          return false
      end
      return false
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
      values.starting_money = defaultRuleValue("starting_money")
      values.starting_pokeballs = defaultRuleValue("starting_pokeballs")
      values.starting_rare_candies = defaultRuleValue("starting_rare_candies")
      return values
  end

  local function makeRulesFromCurrentSave()
      local values = makeDefaultPreGameRules()

      for _, cat in ipairs(ruleCategories) do
          for _, rule in ipairs(cat.rules) do
              if rule.key == "level_cap_scope" then
                  local rawScope = mod.save:get("level_cap_scope", nil)
                  values[rule.key] = rawScope == nil and legacyLevelCapScope()
                      or math.max(0, math.min(4, tonumber(rawScope) or 0))
              else
                  values[rule.key] =
                      mod.save:get(rule.key, defaultRuleValue(rule.key))
              end
          end
      end

      values.area_guide_enabled = loadAreaGuideState()
      values.rules_locked =
          mod.save:get("rules_locked", defaultRuleValue("rules_locked")) == true

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
              if rule.key == "world_building_tier" then
                  copy[rule.key] = math.max(0, math.min(3, math.floor(tonumber(v) or 3)))
              elseif rule.key == "level_cap_scope" then
                  copy[rule.key] = math.max(0, math.min(4, math.floor(tonumber(v) or 0)))
              else
                  copy[rule.key] = (v == true)
              end
          end
      end
      copy.area_guide_enabled = source and source.area_guide_enabled ~= false
          or defaultRuleValue("area_guide_enabled")
      copy.rules_locked = false
      copy.starting_money = math.max(0, math.min(9999,
          tonumber(source and source.starting_money) or defaultRuleValue("starting_money")))
      copy.starting_pokeballs = math.max(0, math.min(99,
          tonumber(source and source.starting_pokeballs) or defaultRuleValue("starting_pokeballs")))
      copy.starting_rare_candies = source and source.starting_rare_candies == true
          or defaultRuleValue("starting_rare_candies")
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
          SETUP_PROFILE_FILE,
          serializeSetupProfile(copyRuleProfile(profile))
      )
      return ok == true
  end

  local function loadSetupProfileFromDisk()
      if not (love and love.filesystem and love.filesystem.getInfo
          and love.filesystem.read) then
          return nil
      end
      if not love.filesystem.getInfo(SETUP_PROFILE_FILE) then
          return nil
      end
      local raw = love.filesystem.read(SETUP_PROFILE_FILE)
      if type(raw) ~= "string" or raw == "" then return nil end
      local chunk = loadstring(raw)
      if not chunk then return nil end
      local ok, profile = pcall(chunk)
      if not ok or type(profile) ~= "table" then return nil end
      return copyRuleProfile(profile)
  end

  local function persistStagedProfile(profile)
      if not profile then return end
      mod.save:set(STAGED_PROFILE_KEY, copyRuleProfile(profile))
      mod.save:set(STAGED_INTENT_KEY, true)
  end

  local function loadPersistedStagedProfile()
      if mod.save:get(STAGED_INTENT_KEY, false) ~= true then
          return nil
      end
      local profile = mod.save:get(STAGED_PROFILE_KEY, nil)
      if type(profile) ~= "table" then
          return nil
      end
      return copyRuleProfile(profile)
  end

  local function clearPersistedStagedProfile()
      mod.save:set(STAGED_INTENT_KEY, false)
      mod.save:set(STAGED_PROFILE_KEY, nil)
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
              if rule.key == "world_building_tier" then
                  mod.save:set(rule.key, math.max(0, math.min(3, math.floor(tonumber(profile[rule.key]) or 3))))
              else
                  mod.save:set(rule.key, profile[rule.key] == true)
              end
          end
      end
      saveAreaGuideState(profile.area_guide_enabled == true)
      mod.save:set("rules_locked", profile.rules_locked == true)

      pendingNewGameRules = copyRuleProfile(profile)
      pendingRulesDirty = false
      areaGuideEnabled = profile.area_guide_enabled == true
      return true
  end

  local function loadSavedSetupIntoPending()
      local profile = loadSetupProfileFromDisk()
      if profile then
          pendingNewGameRules = profile
          pendingRulesDirty = false
          return true
      end
      return false
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
              local expected = rule.key == "world_building_tier"
                  and math.max(0, math.min(3, math.floor(tonumber(profile[rule.key]) or 3)))
                  or (profile[rule.key] == true)
              mod.save:set(rule.key, expected)
          end
      end

      saveAreaGuideState(profile.area_guide_enabled == true)
      mod.save:set("rules_locked", false)
      mod.save:set("infinite_rare_candies", profile.infinite_rare_candies == true)

      -- Verify against the active save.  Keep the snapshot alive if another
      -- engine initialization pass overwrites it; the next lifecycle pass
      -- will stamp the same snapshot again.
      for _, cat in ipairs(ruleCategories) do
          for _, rule in ipairs(cat.rules) do
              local expected = rule.key == "world_building_tier"
                  and math.max(0, math.min(3, math.floor(tonumber(profile[rule.key]) or 3)))
                  or (profile[rule.key] == true)
              local actual = mod.save:get(rule.key, nil)
              if actual ~= expected then
                  allVerified = false
              end
          end
      end
      local guideActual = mod.save:get("area_guide_enabled", nil)
      if guideActual ~= (profile.area_guide_enabled == true) then
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
  -- The example_silly_oak mod uses intro.oak_speech.finished to write
  -- answers into mod.save.  That is the important lifecycle seam here:
  -- by the time Oak's intro has finished, the new game's mod.save exists and
  -- is the correct per-save home for Nuzlocke state.  The title-screen
  -- profile is therefore only the source configuration; this event performs
  -- the definitive transfer into the actual save.
  ---------------------------------------------------------------------
  local function commitDurableSetupProfileToActiveSave()
      local profile = loadSetupProfileFromDisk()
      if not profile then return false end

      for _, cat in ipairs(ruleCategories) do
          for _, rule in ipairs(cat.rules) do
              if rule.key == "world_building_tier" then
                  mod.save:set(rule.key, math.max(0, math.min(3, math.floor(tonumber(profile[rule.key]) or 3))))
              else
                  mod.save:set(rule.key, profile[rule.key] == true)
              end
          end
      end
      saveAreaGuideState(profile.area_guide_enabled == true)
      mod.save:set("rules_locked", false)
      mod.save:set("infinite_rare_candies", profile.infinite_rare_candies == true)

      local verified = true
      for _, cat in ipairs(ruleCategories) do
          for _, rule in ipairs(cat.rules) do
              if mod.save:get(rule.key, nil) ~= (profile[rule.key] == true) then
                  verified = false
                  break
              end
          end
          if not verified then break end
      end
      if mod.save:get("area_guide_enabled", nil) ~= (profile.area_guide_enabled == true) then
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
      -- Only consume a profile when this is a NEW GAME transition.  A
      -- CONTINUE load never runs the Oak intro, so this event cannot alter an
      -- existing save.
      commitDurableSetupProfileToActiveSave()
  end)

  mod.events:on("save.loaded", function(ev)
      if ev and ev.save then currentSave = ev.save end
      if recoverNewGameSnapshotIfNeeded() then
          applyNewGameSnapshot()
      else
          refreshRuleMirrorFromSave()
      end
  end)

  mod.events:on("game.ready", function(game)
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

  ---------------------------------------------------------------------
  -- WORLD BUILDING / FLAVOR
  -- Cosmetic only: never changes a rule result or owns an engine hook.
  -- T1 = core feedback, T2 = snark, T3 = occasional Kanto-aware flavor.
  -- T3 story lines are once-per-save where appropriate.
  ---------------------------------------------------------------------
  local function worldTier(game)
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

  local function worldOnce(game, key, message)
      if worldTier(game) < 3 then return false end
      local flags = worldFlags()
      if flags[key] then return false end
      flags[key] = true
      mod.save:set("nuzlocke_world_flags", flags)
      local okText, TextBox = pcall(require, "src.render.TextBox")
      if okText and TextBox and game and game.stack then
          pcall(function() game.stack:push(TextBox.new(game, message)) end)
          return true
      end
      return false
  end

  local function worldMessage(game, tier1, tier2, tier3)
      local tier = worldTier(game)
      if tier <= 0 then return false end
      local message = tier == 1 and tier1 or (tier == 2 and (tier2 or tier1) or (tier3 or tier2 or tier1))
      local okText, TextBox = pcall(require, "src.render.TextBox")
      if okText and TextBox and game and game.stack and message then
          pcall(function() game.stack:push(TextBox.new(game, message)) end)
          return true
      end
      return false
  end

  local function worldMechanic(game, key, tier1, tier2, tier3)
      local tier = worldTier(game)
      if tier <= 0 then return false end
      if key then
          local flags = worldFlags()
          local seenTier = tonumber(flags[key]) or (flags[key] and 3 or 0)
          -- Show a mechanic reminder once, but allow a later upgrade from
          -- T1/T2 to display the richer version exactly once.
          if seenTier >= tier then return false end
          flags[key] = tier
          mod.save:set("nuzlocke_world_flags", flags)
      end
      return worldMessage(game, tier1, tier2, tier3)
  end

  mod.events:on("intro.oak_speech.finished", function()
      if worldTier(currentGame) >= 3 then
          worldOnce(currentGame, "oak_intro",
              "Professor Oak has a feeling this run will be interesting.\n\"Your Pokédex will record everything.\nYour Nuzlocke will remember the rest.\"")
      end
  end)

  ---------------------------------------------------------------------
  -- LEVEL CAP ENFORCEMENT
  --
  -- One player-facing scope controls the entire progression:
  -- 0 NONE, 1 GYMS, 2 E4, 3 CHAMPION, 4 POSTGAME.
  -- Each higher scope includes everything before it. Legacy saves that still
  -- contain hardcore_mode / elite_four_caps are migrated on read.
  ---------------------------------------------------------------------
  local LEVEL_CAPS = { 14, 21, 24, 29, 43, 43, 47, 50 }
  local LEVEL_CAP_GYM_LEADERS = {
      "BROCK", "MISTY", "LT SURGE", "ERIKA",
      "KOGA", "SABRINA", "BLAINE", "GIOVANNI"
  }
  local ELITE_FOUR_CAPS = {
      { id = "OPP_LORELEI", name = "LORELEI", cap = 54 },
      { id = "OPP_BRUNO",   name = "BRUNO",   cap = 58 },
      { id = "OPP_AGATHA",  name = "AGATHA",  cap = 60 },
      { id = "OPP_LANCE",   name = "LANCE",   cap = 62 },
  }
  local CHAMPION_CAP = { name = "CHAMPION", cap = 65 }

  local function levelCapScope()
      local raw = mod.save:get("level_cap_scope", nil)
      if raw ~= nil then
          return math.max(0, math.min(4, tonumber(raw) or 0))
      end
      -- Backward compatibility with beta 6 and earlier saves.
      return legacyLevelCapScope()
  end

  local function eliteFourDefeated()
      local defeated = mod.save:get("nuzlocke_e4_defeated")
      if type(defeated) ~= "table" then
          defeated = {}
          mod.save:set("nuzlocke_e4_defeated", defeated)
      end
      return defeated
  end

  local function championDefeated()
      return mod.save:get("nuzlocke_champion_defeated", false) == true
  end

  local function postgameCapInfo(save)
      local provider = activeCompatProvider("postgame_caps", currentGame, nil)
      local value = provider and provider.value
      if not provider or type(value) ~= "table" then return nil end
      local getter = value.get_next_cap or value.get_cap or value.next_cap
      if type(getter) ~= "function" then return nil end
      local ok, result = pcall(getter, currentGame, save)
      if not ok then return nil end
      if type(result) == "table" then
          local cap = tonumber(result.cap or result.level or result.max_level)
          if cap and cap > 0 and cap < 100 then
              return cap, tostring(result.name or result.boss or "POSTGAME")
          end
      elseif tonumber(result) and tonumber(result) > 0 and tonumber(result) < 100 then
          return tonumber(result), "POSTGAME"
      end
      return nil
  end

  local function nextEliteFourCapInfo()
      local defeated = eliteFourDefeated()
      for _, entry in ipairs(ELITE_FOUR_CAPS) do
          if defeated[entry.id] ~= true then
              return entry.cap, entry.name
          end
      end
      return nil
  end

  local function currentBadgeCount(save)
      local inventory = save and save.inventory or {}
      local badges = Data.constants and Data.constants.badges or {
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

  -- Gym progression is deliberately tracked separately from the badge
  -- inventory.  Changing the cap scope must never make the player jump to
  -- Lorelei just because the scope was switched to E4.  For an older save
  -- that has no Nuzlocke gym history yet, we seed the history once from its
  -- existing badge count; after that, actual Gym Leader victories are the
  -- authoritative progression source.
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

  local function nextLevelCap(save)
      local scope = levelCapScope()
      if scope <= 0 then return 100 end
      local badges = currentGymProgressCount(save)
      if badges < #LEVEL_CAPS then
          return LEVEL_CAPS[badges + 1] or 100
      end
      if scope >= 2 then
          local e4Cap = nextEliteFourCapInfo()
          if e4Cap then return e4Cap end
      end
      if scope >= 3 and not championDefeated() then
          return CHAMPION_CAP.cap
      end
      if scope >= 4 then
          local postCap = postgameCapInfo(save)
          if postCap then return postCap end
      end
      return 100
  end

  local function nextLevelCapInfo(save)
      local scope = levelCapScope()
      if scope <= 0 then return 100, "MAX" end
      local badges = currentGymProgressCount(save)
      if badges < #LEVEL_CAPS then
          return LEVEL_CAPS[badges + 1] or 100, LEVEL_CAP_GYM_LEADERS[badges + 1] or "MAX"
      end
      if scope >= 2 then
          local e4Cap, e4Name = nextEliteFourCapInfo()
          if e4Cap then return e4Cap, e4Name end
      end
      if scope >= 3 and not championDefeated() then
          return CHAMPION_CAP.cap, CHAMPION_CAP.name
      end
      if scope >= 4 then
          local postCap, postName = postgameCapInfo(save)
          if postCap then return postCap, postName end
      end
      return 100, "MAX"
  end

  local function capExperienceForMon(mon, cap)
      local def = Data.pokemon and Data.pokemon[mon and mon.species]
      if not def or not cap then return nil end
      local ok, value = pcall(Growth.expForLevel, def.growthRate, cap)
      if ok then return value end
      return nil
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

      -- If an active Level Cap provider owns this mechanic, let it enforce
      -- the cap. Disabled/failed installed mods are rejected by mod.find().
      if activeCompatProvider("level_caps", currentGame, nil) then
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
                  "LEVEL CAP REACHED!\n" .. tostring(ctx.mon.nickname or ctx.mon.species or "Pokemon") .. " cannot go past LV. " .. tostring(cap) .. ".",
                  "Nice try.\nThe Nuzlocke says LV. " .. tostring(cap) .. " is enough for now.",
                  "Gym Guide: " .. tostring(leader) .. " is expecting you at the current cap.\nLet's not hand them an overleveled surprise.")
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
  -- FLAT RULE LIST
  -- MISC contains settings that belong to the Nuzlocke utility layer.
  -- Gym Guide Rare Candy is available both during NEW GAME setup and in
  -- the active-save RULES screen.  Only settings that affect the initial
  -- inventory/state (Money and Poke Balls, plus the initial 99 Rare Candy
  -- option) are NEW-GAME ONLY.
  ---------------------------------------------------------------------
  local function buildFlatItemList(preGame)
      local list = {}

      table.insert(list, {
          isHeader = false,
          isControl = true,
          rule = {
              key = "rules_locked",
              name = "Lock Rules",
              desc = "Lock all Nuzlocke rules in place. The LOCK control itself can always be toggled."
          }
      })

      for _, cat in ipairs(ruleCategories) do
          table.insert(list, { isHeader = true, name = cat.title })
          for _, rule in ipairs(cat.rules) do
              table.insert(list, { isHeader = false, rule = rule })
          end
      end

      -- MISC contains only the live Gym Guide utility.  Save/Setup and
      -- Recover Catches are deliberately unheaded controls at the absolute
      -- bottom so they remain visually important without becoming another
      -- gameplay category.
      table.insert(list, { isHeader = true, name = "- MISC -" })
      table.insert(list, {
          isHeader = false,
          rule = {
              key = "infinite_rare_candies",
              name = "Gym Guide Rare Candy",
              desc = "Gym Guides keep their normal dialogue, then offer repeatable Rare Candies in batches of 1, 10, 25, 50, or 99. Can be changed at any time. Recommended for players who want convenient level-cap training."
          }
      })

      -- Bottom controls intentionally have no section header.
      if not preGame then
          table.insert(list, {
              isHeader = false, isControl = true, isInGameSave = true,
              rule = { key = "save_in_game_rules", name = "Save Rules",
                  desc = "Save the current NUZLOCKE RULES to the active game save." }
          })
          table.insert(list, {
              isHeader = false, isControl = true, isRecoveryControl = true,
              rule = { key = "recover_legacy_catches", name = "Recover Catches",
                  desc = "Review Pokemon from older saves whose catch location could not be recovered automatically." }
          })
      else
          table.insert(list, { isHeader = false, rule = {
              key = "starting_money", name = "Money", numeric = true, digits = 4, min = 0, max = 9999,
              desc = "Starting money for NEW GAME. You will have this money when the new game begins. Press A to edit; LEFT/RIGHT selects a digit; UP/DOWN changes it." } })
          table.insert(list, { isHeader = false, rule = {
              key = "starting_pokeballs", name = "Poke Balls", numeric = true, digits = 2, min = 0, max = 99,
              desc = "Starting Poke Balls for NEW GAME. They are placed in the PC in your room. Press A to edit; LEFT/RIGHT selects a digit; UP/DOWN changes it." } })
          table.insert(list, { isHeader = false, rule = {
              key = "starting_rare_candies", name = "Start with 99 Rare Candy",
              desc = "Start NEW GAME with 99 Rare Candies in the PC in your room." } })
      end

      -- Save controls always come last, with no header.
      if preGame then
          table.insert(list, { isHeader = false, isControl = true, isSetupSave = true,
              rule = { key = "save_setup_options", name = "Save Setup",
                  desc = "Save these NUZLOCKE SETUP options for the next NEW GAME. The saved profile is kept separately from your game save." } })
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

      if key == "level_cap_scope" then
          local rawScope = mod.save:get("level_cap_scope", nil)
          if rawScope == nil then return legacyLevelCapScope() end
          return math.max(0, math.min(4, tonumber(rawScope) or 0))
      end

      local stored = mod.save:get(key, defaultRuleValue(key))
      if key == "starting_money" or key == "starting_pokeballs" or key == "world_building_tier" then
          return tonumber(stored) or defaultRuleValue(key)
      end
      return stored == true
  end


  local function setConfigValue(key, value, preGame)
      if key == "starting_money" then
          value = math.max(0, math.min(9999, math.floor(tonumber(value) or 0)))
      elseif key == "starting_pokeballs" then
          value = math.max(0, math.min(99, math.floor(tonumber(value) or 0)))
      elseif key == "world_building_tier" then
          value = math.max(0, math.min(3, math.floor(tonumber(value) or 3)))
      elseif key == "level_cap_scope" then
          value = math.max(0, math.min(4, math.floor(tonumber(value) or 0)))
      else
          value = value == true
      end

      if preGame then
          if not pendingNewGameRules then
              pendingNewGameRules = makeDefaultPreGameRules()
          end
          pendingNewGameRules[key] = value
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

      -- Trainer Card and other live UI consumers can use this revision as a
      -- cheap invalidation signal. The actual value remains mod.save's source
      -- of truth, so toggles take effect immediately without requiring a save.
      mod.save:set("nuzlocke_rule_revision", (tonumber(mod.save:get("nuzlocke_rule_revision", 0)) or 0) + 1)

      -- Keep the title-screen representation synchronized with the active save.
      if not pendingNewGameRules then
          pendingNewGameRules = makeDefaultPreGameRules()
      end
      pendingNewGameRules[key] = value
      if key == "level_cap_scope" then
          pendingNewGameRules.hardcore_mode = value > 0
          pendingNewGameRules.elite_four_caps = value >= 2
      end
      pendingRulesDirty = false
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

          local flatItemList = buildFlatItemList(preGame)

          local self = {
              game = game,
              isOpaque = true,
              preGame = preGame,
              cursor = 1,
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
                      self.game.stack:pop()
                  end
                  return
              end

              -- Declare this before moveCursor so the closure captures the local
              -- helper instead of resolving a nonexistent global on UP/DOWN.
              local function isSelectableItem(item)
                  if not item or item.isHeader then return false end
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

              local function activateControl(item)
                  if not item or not item.isControl then return false end
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

                  if item.rule and item.rule.key == "wonderlocke" then
                      return false
                  end
                  if item.rule and item.rule.key == "world_building_tier" then
                      return true
                  end
                  return not getConfigValue("rules_locked", self.preGame)
              end

              local item = selectedItem()
              local editingAtStart = self.editingNumber

              if self.editingNumber and item and item.rule.numeric then
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
                  if item and item.rule and item.rule.key ~= "wonderlocke" and item.rule.numeric and (self.preGame or item.rule.key == "world_building_tier" or item.rule.key == "level_cap_scope") then
                      self.editingNumber = true
                      self.digitIndex = 1
                      self.descScroll = 0
                  elseif item and item.isControl then
                      activateControl(item)
                  elseif canChangeSelected(item) then
                      local key = item.rule.key
                      local cur = getConfigValue(key, self.preGame)
                      setConfigValue(key, not cur, self.preGame)
                  end
              elseif self.game.input:wasPressed("select") then
                  if item and not item.isHeader then
                      local descLines = wrapText(item.rule.desc, 16)
                      local maxScroll = math.max(0, #descLines - 3)
                      if maxScroll > 0 then
                          self.descScroll = (self.descScroll + 1) % (maxScroll + 1)
                      end
                  end
              end

              if self.game.input:wasPressed("a") and not editingAtStart then
                  if item and item.isControl then
                      activateControl(item)
                  elseif item and item.rule and item.rule.key ~= "wonderlocke" and item.rule.numeric and (self.preGame or item.rule.key == "world_building_tier" or item.rule.key == "level_cap_scope") then
                      self.editingNumber = true
                      self.digitIndex = 1
                      self.descScroll = 0
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
                  Font.draw("NUZLOCKE SETUP", 10, 10)
                  Font.draw("NEW GAME ONLY", 15, 22)
              else
                  Font.draw("NUZLOCKE RULES", 10, 10)
                  -- Show a lock indicator in the top-right when rules are locked.
                  if locked then
                      Font.draw("[LK]", 116, 10)
                  end
              end

              if self.cursor > self.scroll + self.pageSize then
                  self.scroll = self.cursor - self.pageSize
              end

              if self.cursor <= self.scroll then
                  self.scroll = math.max(0, self.cursor - 1)
              end

              -- List starts lower in preGame to clear the two-line header.
              local startY = self.preGame and 36 or 28

              for i = self.scroll + 1,
                  math.min(self.scroll + self.pageSize, #flatItemList) do

                  local item = flatItemList[i]
                  local drawY =
                      startY + ((i - (self.scroll + 1)) * 18)

                  if item.isHeader then
                      -- Headers at X=16 aligns with the cursor "->" start.
                      Font.draw(item.name, 16, drawY)
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
                          item.rule.name,
                          8,
                          self.marqueeTime
                      )
                      Font.draw(displayName, 30, drawY)

                      if item.isRecoveryControl then
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
                          Font.draw(label, 112, drawY)
                      elseif item.isInGameSave then
                          local label = "SAVE"
                          if self.inGameSaveFlash and self.inGameSaveFlash > 0 then
                              label = "SAVED"
                          elseif self.inGameSaveFlash and self.inGameSaveFlash < 0 then
                              label = "ERROR"
                          end
                          Font.draw(label, 112, drawY)
                      elseif item.rule.numeric then
                          local digits = item.rule.digits or 1
                          local numberText = ("%0" .. tostring(digits) .. "d"):format(tonumber(val) or item.rule.min or 0)
                          if key == "starting_money" then
                              Font.draw("$" .. numberText, 110, drawY)
                          elseif key == "world_building_tier" then
                              local labels = { [0] = "OFF", [1] = "T1", [2] = "T2", [3] = "T3" }
                              Font.draw(labels[tonumber(val) or 0] or "OFF", 118, drawY)
                          elseif key == "level_cap_scope" then
                              local labels = { [0] = "NONE", [1] = "GYMS", [2] = "E4", [3] = "CHAMP", [4] = "POST" }
                              Font.draw(labels[tonumber(val) or 0] or "NONE", 110, drawY)
                          else
                              Font.draw(numberText, 118, drawY)
                          end
                          if isSelected and self.editingNumber then
                              local prefix = key == "starting_money" and 1 or 0
                              Font.draw("^", 118 + ((self.digitIndex - 1) + prefix) * 6, drawY - 8)
                          end
                      else
                          local status = isWip and "WIP" or (val and "ON" or "OFF")
                          Font.draw(status, 118, drawY)
                      end

                      love.graphics.setColor(1, 1, 1, 1)
                  end
              end

              local selItem = flatItemList[self.cursor]

              if selItem and not selItem.isHeader then
                  local descLines = wrapText(selItem.rule.desc, 16)
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
                  if self.editingNumber then
                      Font.draw("LR:Digit  UD:Value", 14, 96)
                      Font.draw("A:Confirm", 14, 112)
                  elseif locked then
                      Font.draw("Rules are LOCKED.", 14, 96)
                      Font.draw("A on Lock to open.", 14, 112)
                  else
                      Font.draw("A or LR: Toggle", 14, 96)
                      Font.draw("SEL: Scroll desc", 14, 110)
                      Font.draw("B: Back", 14, 124)
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

      -- Pallet Town is the mandatory starter slot. Keep it visible on the
      -- encounter MAP even when ordinary town catches are disabled.
      if area.id == "PALLET_TOWN" and caughtAreas()["PALLET_TOWN"] ~= nil then
          return true
      end

      if isTownArea(area.id, area.name) and not mod.save:get("town_catches", false) then
          return false
      end
      return true
  end

  local function getDisplayRoutes(game)
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

  ---------------------------------------------------------------------
  -- TRACKER DISPLAY ROWS
  -- The save is grouped by area, but the tracker is displayed row-by-row.
  -- Never comma-join multiple catches from the same area.
  ---------------------------------------------------------------------
  local function getTrackerLogRows()
      local log = trackerLog()
      local keys = {}
      for key, entries in pairs(log) do
          if type(entries) == "table" and #entries > 0 then
              table.insert(keys, key)
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
          for _, catch in ipairs(log[key]) do
              if type(catch) == "table" then
                  table.insert(rows, { area = key, catch = catch })
              end
          end
      end
      return rows
  end

  local function getTrackerMapRows(game)
      local log = trackerLog()
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
              table.insert(rows, { area = route, catch = nil })
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
              ruleRevision = tonumber(mod.save:get("nuzlocke_rule_revision", 0)) or 0,
          }

          local function activeRuleNames()
              -- The Trainer Card must use the exact same active-save state as
              -- the in-game Rules screen.  Never read the staged NEW GAME
              -- table here; once the save exists, mod.save is authoritative.
              local names = {}
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
                      if tier > 0 then return "World " .. ({ [1] = "T1", [2] = "T2", [3] = "T3" })[tier] end
                      return nil
                  elseif rule.key == "level_cap_scope" then
                      local rawScope = mod.save:get("level_cap_scope", nil)
                      local scope = rawScope == nil and legacyLevelCapScope() or (tonumber(rawScope) or 0)
                      if scope > 0 then return "Level Caps " .. ({ [1] = "GYMS", [2] = "E4", [3] = "CHAMP", [4] = "POST" })[scope] end
                      return nil
                  elseif rule.numeric then
                      return (tonumber(value) or 0) > 0 and rule.name or nil
                  elseif boolSetting(value) then
                      return rule.name
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
                  names[#names + 1] = "Gym Guide Candy"
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
              end

              if input:wasPressed("a") then
                  self.nuzlockeStatusPage = not self.nuzlockeStatusPage
                  self.ruleScroll = 0
                  self.ruleArrowTime = 0
                  return
              end

              if input:wasPressed("b") then
                  self.game.stack:pop()
                  return
              end

              if self.nuzlockeStatusPage then
                  local names = activeRuleNames()
                  local visible = 2
                  local maxScroll = math.max(0, #names - visible)

                  if input:wasPressed("down") and self.ruleScroll < maxScroll then
                      self.ruleScroll = self.ruleScroll + 1
                  elseif input:wasPressed("up") and self.ruleScroll > 0 then
                      self.ruleScroll = self.ruleScroll - 1
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
              end
          end

          function self:draw()
              local Font = mod.ui.Font

              if not self.nuzlockeStatusPage then
                  self.vanilla:draw()
                  -- Flip hint lives in the open band between the trainer
                  -- information/sprite area and the badge sprites.  Keep it
                  -- on the RIGHT side, clear of the WORD badges and dots.
                  Font.draw("A:NUZ", 112, 68)
                  return
              end

              love.graphics.setColor(1, 1, 1, 1)
              love.graphics.rectangle("fill", 0, 0, 160, 144)
              Font.drawBox(0, 0, 20, 18)
              Font.draw("NUZ STATUS", 28, 8)

              local caught = countTrackerCatches()
              local lost = tonumber(mod.save:get("nuzlocke_losses", 0)) or 0
              local caughtAreasCount = countCaughtAreas()
              local visitedAreasCount = countVisitedAreas(self.game)
              local totalAreas = #getDisplayRoutes(self.game)
              local cap = nextLevelCap(self.game and self.game.save)

              -- Fixed rows leave a dedicated bottom navigation strip.
              -- Caught and visited areas are intentionally separate: a player
              -- can visit an area without using its encounter.
              Font.draw("CAUGHT", 16, 26)
              Font.draw(("%3d"):format(caught), 108, 26)
              Font.draw("LOST", 16, 42)
              Font.draw(("%3d"):format(lost), 108, 42)
              Font.draw("CAUGHT A.", 16, 58)
              Font.draw(("%2d/%2d"):format(caughtAreasCount, totalAreas), 88, 58)
              Font.draw("VISITED A.", 16, 70)
              Font.draw(("%2d/%2d"):format(visitedAreasCount, totalAreas), 88, 70)
              Font.draw("NEXT CAP", 16, 82)
              Font.draw(cap >= 100 and "MAX" or ("LV" .. tostring(cap)), 88, 82)

              local names = activeRuleNames()
              local visible = 1
              local maxScroll = math.max(0, #names - visible)
              if self.ruleScroll > maxScroll then
                  self.ruleScroll = maxScroll
              end
              local canScrollDown = (self.ruleScroll + visible) < #names

              local rulesY = 92
              local ruleRowsY = rulesY + 10
              Font.draw("RULES", 16, rulesY)
              if #names == 0 then
                  Font.draw("NONE", 16, ruleRowsY)
              else
                  for row = 1, visible do
                      local idx = self.ruleScroll + row
                      local name = names[idx]
                      if name then
                          Font.draw(marqueeText(name, 14, 0), 16, ruleRowsY + (row - 1) * 10)
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

              Font.draw("A:CARD", 8, 126)
              Font.draw("B:EXIT", 104, 126)
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
  local rareCandyMenuContext = nil

  mod.content.screens:register("NuzlockeRareCandyMenu", {
      new = function(game)
          local context = rareCandyMenuContext or {}
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
              Font.draw("RARE CANDY", 38, 26)
              Font.draw("How many?", 42, 42)

              for i, amount in ipairs(self.choices) do
                  local y = 56 + (i - 1) * 10
                  if i == self.selected then
                      local Theme = require("src.ui.Theme")
                      Font.drawCode(Theme.cursor, 34, y)
                  end
                  Font.draw(tostring(amount), 40, y)
              end

              Font.draw("> CANCEL: B", 40, 108)
              Font.draw("A:OK", 92, 118)
          end

          return self
      end,
  })

  mod.content.commands:register("nuzlocke:infinite_rare_candy", {
      foreground = true,
      fn = function(ctx)
          if mod.save:get("infinite_rare_candies", false) ~= true then
              return
          end

          -- A talk provider may explicitly claim exclusive ownership. Most
          -- providers should leave this false so their NPC behavior composes
          -- with the Nuzlocke reward.
          if providerExclusive("npc_talk", ctx and ctx.game, nil) then
              return
          end

          local Commands = require("src.script.Commands")
          Commands.show_text(ctx,
              "Psst... doing a Nuzlocke?\nI won't tell the League.\nHow many RARE CANDY do you want?")

          local runner = ctx.runner
          local Screens = require("src.ui.Screens")
          rareCandyMenuContext = {
              onSelect = function(amount)
                  local okBag, Bag = pcall(require, "src.inventory.Bag")
                  if not okBag or not Bag then
                      runner:resume()
                      return
                  end

                  local inventory = ctx.save.inventory or {}
                  local current = tonumber(inventory.RARE_CANDY) or 0
                  local room = math.max(0, 99 - current)
                  local give = math.min(tonumber(amount) or 0, room)

                  if give <= 0 then
                      local TextBox = require("src.render.TextBox")
                      ctx.game.stack:push(TextBox.new(ctx.game,
                          "You already have\n99 RARE CANDY!",
                          function() runner:resume() end))
                      return
                  end

                  if not Bag.add(ctx.save, "RARE_CANDY", give, ctx.game.data) then
                      local TextBox = require("src.render.TextBox")
                      ctx.game.stack:push(TextBox.new(ctx.game,
                          "Your BAG is full!",
                          function() runner:resume() end))
                      return
                  end

                  local TextBox = require("src.render.TextBox")
                  local noun = give == 1 and "RARE CANDY" or "RARE CANDIES"
                  ctx.game.stack:push(TextBox.new(ctx.game,
                      ("You got %d %s!"):format(give, noun),
                      function() runner:resume() end))
              end,
              onCancel = function()
                  runner:resume()
              end,
          }
          local function openCandyMenu()
              local pushed = Screens.push(ctx.game, "NuzlockeRareCandyMenu", function()
                  rareCandyMenuContext = nil
              end)
              if pushed == false then
                  rareCandyMenuContext = nil
                  runner:resume()
              else
                  runner:yield()
              end
          end

          local tier = worldTier(ctx.game)
          if tier >= 2 and levelCapScope() > 0 then
              local cap, leader = nextLevelCapInfo(ctx.game.save)
              ctx.game.stack:push(TextBox.new(ctx.game,
                  tier >= 3
                      and ("Gym Guide: Careful!\nYour current cap is LV. " .. tostring(cap) .. ".\n" .. tostring(leader) .. " won't be impressed.")
                      or ("Nice try.\nRare Candies don't beat the level cap.\nCurrent cap: LV. " .. tostring(cap) .. "."),
                  function() openCandyMenu() end))
              runner:yield()
          else
              openCandyMenu()
          end
      end,
  })

  -- Compose the actual vanilla talk rows with our post-dialogue command.
  -- MapScripts.baseTalk() returns the base row list, not a callable function;
  -- treating it as a function was the reason the Guide could appear but become
  -- silent on existing saves.  We copy the rows so the original script remains
  -- intact and append our reward only after vanilla finishes.
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

  mod.content.commands:register("nuzlocke:base_gym_guide", {
      foreground = true,
      fn = function(ctx, mapId, textId)
          local MapScripts = require("src.script.MapScripts")
          local base = MapScripts.baseTalk(mapId, textId)
          local runner = ctx.runner
          if base then
              base(ctx.game, ctx.overworld, ctx.npc, function()
                  runner:resume()
              end)
              runner:yield()
              return
          end

          -- Fallback for older/generated caches that do not expose the base
          -- handler. Prefer the engine's resolved text rather than leaving the
          -- NPC silent.
          local text = ctx.game.data:resolveText(ctx.overworld.map.def.label, textId)
          if text then
              local TextBox = require("src.render.TextBox")
              ctx.game.stack:push(TextBox.new(ctx.game, text, function()
                  runner:resume()
              end))
              runner:yield()
          end
      end,
  })

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
      if mod.save:get("infinite_rare_candies", false) ~= true then
          return
      end

      local save = game and game.save
      if not save then return end

      -- If another active mod explicitly owns NPC visibility, it gets the final
      -- say. Kanto Life does not currently advertise such ownership, so its
      -- nighttime behavior continues to compose with the Guide.
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
                  local Commands = require("src.script.Commands")
                  pcall(Commands.show_object, {
                      game = game, save = save, overworld = ow
                  }, mapId, objectName)
              end
          end
      end
  end

  for mapId, textId in pairs(GYM_GUIDE_TALKS) do
      registerGymGuideCandyTalk(mapId, textId)
  end

  mod.events:on("save.loaded", function(ev)
      if ev and ev.save then
          if type(mod.save:get("nuzlocke_e4_defeated")) ~= "table" then
              mod.save:set("nuzlocke_e4_defeated", {})
          end
          refreshGymGuideVisibility(currentGame)
      end
  end)

  mod.events:on("game.ready", function(game)
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
                              if not usedLegacyMons[i]
                                  and type(mon) == "table"
                                  and tostring(mon.species or ""):upper() == sp
                                  and mon.nuzlockeOrigin == "LEGACY"
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
              for _, mon in ipairs(mons) do
                  if type(mon) == "table" and mon.species
                      and mon.nuzlockeOrigin == "EDITED"
                      and not mon.catchLocation then
                      out[#out + 1] = {
                          species = mon.species,
                          isShiny = mon.dvs and Stats.isShiny(mon.dvs) or false,
                          provenance = "EDITED",
                          mon = mon,
                      }
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

          local function areaAlreadyHasEncounter(log, areas, area)
              if not area then return false end
              if areas[area] ~= nil then return true end
              local catches = log[area]
              return type(catches) == "table" and #catches > 0
          end

          local function filterRecoveryAreas(rawAreas)
              local log = trackerLog()
              local areas = caughtAreas()
              local filtered = {}
              for _, area in ipairs(rawAreas or {}) do
                  if type(area) == "table" then
                      area = area.id or area.mapId or area.key
                  end
                  if area and (not recoveryEncounterLimitApplies() or not areaAlreadyHasEncounter(log, areas, area)) then
                      filtered[#filtered + 1] = area
                  end
              end
              return filtered
          end

          local function candidates(entry)
              if not entry then return {} end

              local raw = nil
              if type(entry.possibleAreas) == "table" and #entry.possibleAreas > 0 then
                  raw = entry.possibleAreas
              end

              if not raw then
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

              return filterRecoveryAreas(raw)
          end

          local function chooseArea(entry, area)
              local log = trackerLog()
              local areas = caughtAreas()
              local legacy = log.__LEGACY__ or {}
              local sp = tostring(entry.species or ""):upper()
              local sourceMon = entry.mon

              -- A manual recovery is a new player confirmation, so it must not
              -- create a second current encounter in an area that already has
              -- one when the 1st Catch rule is active. Existing historical log
              -- entries are preserved; only new assignments are blocked.
              if recoveryEncounterLimitApplies() and areaAlreadyHasEncounter(log, areas, area) then
                  return false
              end

              registerArea(area)
              log[area] = log[area] or {}
              table.insert(log[area], {
                  species = sp,
                  isShiny = entry.isShiny == true,
                  encounterType = "wild",
                  encounterSource = "manual",
                  recoveryStatus = "PLAYER_CONFIRMED",
                  provenance = entry.provenance or "PLAYER_CONFIRMED",
                  retroactive = true,
              })

              if sourceMon then
                  sourceMon.catchLocation = area
                  sourceMon.encounterType = "wild"
                  sourceMon.nuzlockeTrackerRegistered = true
                  setPokemonOrigin(sourceMon, "PLAYER_CONFIRMED")
                  baselineAdd(sourceMon, "PLAYER_CONFIRMED")
              end
              if areas[area] == nil then
                  areas[area] = sp
              end
              markVisited(area)

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

          function self:update(dt)
              local list = entries()
              if #list == 0 then
                  if self.game.input:wasPressed("b") or self.game.input:wasPressed("a") then
                      self.game.stack:pop()
                  end
                  return
              end

              if self.game.input:wasPressed("b") then
                  if self.mode == "areas" then
                      self.mode = "list"
                      self.areaCursor = 1
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
                      local c = candidates(entry)
                      if #c > 0 then
                          self.mode = "areas"
                          self.areaCursor = 1
                      end
                  end
              else
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
                      if chooseArea(entry, area) then
                          self.cursor = math.min(self.cursor, math.max(1, #entries()))
                          self.mode = "list"
                      end
                  end
              end
          end

          function self:draw()
              local Font = mod.ui.Font
              local list = entries()

              Font.drawBox(0, 0, 20, 18)

              if #list == 0 then
                  Font.draw("RECOVER CATCHES", 12, 10)
                  Font.draw("ALL RECOVERED!", 18, 52)
                  Font.draw("B:BACK", 54, 122)
                  return
              end

              if self.mode == "list" then
                  Font.draw("RECOVER CATCHES", 16, 10)
                  Font.draw("SELECT A POKEMON", 12, 24)

                  local start = math.max(1, math.min(self.cursor - 3, #list - 5))
                  for i = start, math.min(#list, start + 5) do
                      local y = 40 + ((i - start) * 14)
                      if i == self.cursor then Font.drawCode((require("src.ui.Theme")).cursor, 12, y) end
                      local entry = list[i]
                      local sp = tostring(entry.species or "???")
                      local prefix = entry.provenance == "EDITED" and "E " or "L "
                      Font.draw(prefix .. sp:sub(1, 10), 30, y)
                      local count = type(entry.possibleAreas) == "table" and #entry.possibleAreas or 0
                      Font.draw(count > 0 and tostring(count) or "?", 128, y)
                  end

                  Font.draw("A:CHOOSE", 16, 126)
                  Font.draw("B:BACK", 100, 126)
              else
                  local entry = list[self.cursor]
                  local c = candidates(entry)
                  Font.draw("WHERE CAUGHT?", 26, 10)
                  Font.draw(tostring(entry.species or "???"):sub(1, 12), 48, 24)

                  if #c == 0 then
                      Font.draw("NO AVAILABLE AREAS", 16, 58)
                      if recoveryEncounterLimitApplies() then
                          Font.draw("AREAS ALREADY TAKEN", 10, 76)
                      else
                          Font.draw("NO KNOWN AREAS", 30, 76)
                      end
                      Font.draw("B:BACK", 100, 126)
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

                  Font.draw("A:ASSIGN", 16, 126)
                  Font.draw("B:BACK", 100, 126)
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
              Font.draw("ENC TRACKER", 14, 8)
              local tabLabel = self.tab == 1 and "[LOG]" or "[MAP]"
              Font.draw(tabLabel, 110, 8)

              local y = 26
              local listCount

              if self.tab == 1 then
                  Font.draw("AREA      CATCH", 16, y)
                  y = y + 12
                  local rows = getTrackerLogRows()
                  listCount = #rows

                  for i = self.scroll + 1, math.min(self.scroll + 4, #rows) do
                      local row = rows[i]
                      local catch = row.catch or {}
                      local species = catch.species or "???"
                      if catch.isShiny then species = "*" .. species end
                      local routeLabel = (row.area == "__LEGACY__") and "LEGACY" or routeName(row.area)
                      Font.draw(marqueeText(routeLabel, 8, self.marqueeTime), 16, y)
                      Font.draw(marqueeText(species, 7, self.marqueeTime), 96, y)
                      y = y + 18
                  end
              else
                  Font.draw("AREA      CATCH", 16, y)
                  y = y + 12
                  local rows = getTrackerMapRows(self.game)
                  listCount = #rows

                  for i = self.scroll + 1, math.min(self.scroll + 4, #rows) do
                      local row = rows[i]
                      local r = row.area
                      local catch = row.catch
                      local status = catch and (catch.isShiny and ("*" .. tostring(catch.species or "???"))
                          or tostring(catch.species or "???")) or "..."
                      Font.draw(marqueeText(r.name, 8, self.marqueeTime, 3.8), 16, y)
                      Font.draw(marqueeText(status, 7, self.marqueeTime), 96, y)
                      y = y + 18
                  end
              end

              local maxScroll = math.max(0, listCount - 4)
              local canScrollUp = self.scroll > 0
              local canScrollDown = self.scroll < maxScroll
              local blinkOn = math.floor(self.arrowTime / 1.0) % 2 == 0

              if canScrollUp and blinkOn then
                  Font.draw("^", 72, 18)
              end

              -- Bottom bar: navigation hints + level cap reminder.
              local cap = nextLevelCap(self.game and self.game.save)
              local capStr = cap >= 100 and "CAP:MAX" or ("CAP:" .. tostring(cap))
              Font.draw(capStr, 14, 112)
              if guideEnabled then
                  Font.draw("A:PG", 72, 112)
              end
              Font.draw("B:X", 122, 112)

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
          local self = {
              game = game,
              isOpaque = true,
              mon = ctx and ctx.mon
          }

          function self:update(dt)
              if self.game.input:wasPressed("b")
                  or self.game.input:wasPressed("a") then
                  self.game.stack:pop()
              end
          end

          local function displayOrigin(mon)
              local value = mon and mon.nuzlockeOrigin
              if value == "LEGACY" then return "LEGACY" end
              if value == "EDITED" then return "EDITED" end
              if value == "PLAYER_CONFIRMED" then return "CONFIRMED" end
              return "NORMAL"
          end

          local function displayEncounterType(mon)
              local value = mon and (mon.encounterType or mon.nuzlockeEncounterType)
              if not value then return "UNKNOWN" end
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
              return labels[value] or tostring(value):upper()
          end

          function self:draw()
              local Font = mod.ui.Font
              local mon = self.mon

              Font.drawBox(0, 0, 20, 18)
              Font.draw("CATCH INFO", 24, 12)

              if not mon then
                  Font.draw("No data.", 16, 40)
                  Font.draw("A/B: BACK", 40, 122)
                  return
              end

              local label = tostring(mon.nickname or mon.species or "???")
              local loc = routeName(mon.catchLocation or "UNKNOWN")
              local encounter = displayEncounterType(mon)
              local origin = displayOrigin(mon)
              local dead = mon.nuzlockeDead == true

              Font.draw("CATCH", 16, 28)
              Font.draw(label, 16, 40)

              Font.draw("LOCATION", 16, 54)
              Font.draw(loc, 16, 66)

              Font.draw("ENCOUNTER TYPE", 16, 80)
              Font.draw(encounter, 16, 92)

              Font.draw("ORIGIN", 16, 104)
              Font.draw(origin, 16, 114)

              Font.draw("STATUS", 92, 104)
              Font.draw(dead and "LOST" or "ALIVE", 92, 114)

              if dead then
                  local cause = tostring(mon.deathCauseText or mon.deathCause or "BATTLE")
                  local lines = wrapText(cause, 18)
                  if lines[1] then Font.draw(lines[1], 16, 130) end
                  if lines[2] then Font.draw(lines[2], 16, 142) end
              elseif mon.dvs and Stats.isShiny(mon.dvs) then
                  Font.draw("SHINY", 88, 114)
              end

              -- A/B remains the established back control.  It is deliberately
              -- omitted when a two-line death cause reaches the bottom edge.
              if not dead or #wrapText(tostring(mon.deathCauseText or mon.deathCause or "BATTLE"), 18) < 2 then
                  Font.draw("A/B: BACK", 40, 124)
              end
          end

          return self
      end
  })

  ---------------------------------------------------------------------
  -- TITLE MENU HOOK
  -- NZLCKE SETUP must appear whenever the title screen has NO REAL SAVE.
  --
  -- IMPORTANT: game.save is an in-memory/default save object even on a
  -- completely fresh title screen, so checking game.save.player incorrectly
  -- made SETUP disappear on fresh Red/Blue starts. The engine's own title
  -- screen uses the presence of the actual save file instead.
  ---------------------------------------------------------------------
  local function hasActualSaveFile()
      local ok, info = pcall(function()
          local SaveData = require("src.core.SaveData")
          local GameVersion = require("src.core.GameVersion")
          local filename = SaveData.saveFilename(GameVersion.get())
          if love and love.filesystem and love.filesystem.getInfo then
              return love.filesystem.getInfo(filename)
          end
          return nil
      end)
      return ok and info ~= nil
  end

  mod.hooks:wrap("ui.title_menu.items", function(next, game, items)
      local result = next(game, items)
      if type(result) ~= "table" then
          result = items
      end

      for _, item in ipairs(result) do
          -- NEW GAME: stage the pending rules for the upcoming save.
          if item and item.label == "NEW GAME" and type(item.onSelect) == "function" then
              local originalNewGame = item.onSelect
              item.onSelect = function()
                  if not pendingNewGameRules then
                      pendingNewGameRules = loadSetupProfileFromDisk()
                          or makeDefaultPreGameRules()
                  end
                  -- Save exactly what the player has configured.  The visible
                  -- SAVE SETUP control is still useful for reusing a profile
                  -- later; this automatic write also makes NEW GAME reliable
                  -- if the player forgets to press it.
                  saveSetupProfileToDisk(pendingNewGameRules)
                  stageNewGameProfile()
                  originalNewGame()
              end
          end

          -- CONTINUE: discard any staged setup so it can never override
          -- the existing save's rules.
          if item and item.label == "CONTINUE" and type(item.onSelect) == "function" then
              local originalContinue = item.onSelect
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

      -- SETUP button only appears when there is no real save file yet.
      if not hasActualSaveFile() then
          mod.ui.insertBefore(result, "NEW GAME", {
              label = "SETUP",
              onSelect = function()
                  if not pendingNewGameRules or not pendingRulesDirty then
                      pendingNewGameRules = loadSetupProfileFromDisk()
                          or makeDefaultPreGameRules()
                      pendingRulesDirty = false
                  end
                  mod.ui.push(game, "NuzlockeConfigScreen", { preGame = true })
              end
          })
      end

      return result
  end)

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

      -- Redirect the player's name row to our Trainer Card wrapper.
      -- Keep this in the same hook so there is only ONE start-menu hook
      -- and all of our modifications operate on the final vanilla list.
      for _, item in ipairs(result) do
          if item and item.label == (game.save and game.save.player and game.save.player.name or "RED")
              and type(item.onSelect) == "function" then
              item.onSelect = function()
                  mod.ui.push(game, "NuzlockeTrainerCardScreen")
              end
              break
          end
      end

      mod.ui.insertBefore(result, "OPTION", {
          label = "TRACKER",
          onSelect = function()
              mod.ui.push(game, "NuzlockeTrackerScreen")
          end
      })

      mod.ui.insertBefore(result, "OPTION", {
          -- Short underlying label preserves the original start-menu width.
          label = "RULES",
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
      if mod.save:get("nuzlocke_enabled", true) and mod.save:get("catch_info", true) and mon then
          mod.ui.insertBefore(items, "CANCEL", {
              label = "CATCH INFO",
              onSelect = function()
                  mod.ui.push(
                      game,
                      "NuzlockeCatchInfoScreen",
                      { mon = mon }
                  )
              end
          })
      end

      return next(game, items, mon, ctx)
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
      if not ok or not BattleState or not okBag or not Bag then
          return
      end

      if BattleState.__nuzlockeFinal23Patched then
          return
      end
      BattleState.__nuzlockeFinal23Patched = true

      local vanillaThrowBall = BattleState.throwBall

      -- The runtime does not reliably emit battle.ended for every normal
      -- battle in all recomp builds. Failed Encounters depends on that event,
      -- so bridge the engine's authoritative BattleState:finish seam. The
      -- nuzlocke game-over path already emits the same event later; the flag
      -- prevents a duplicate emission for that case.
      if type(BattleState.finish) == "function" and not BattleState.__nuzlockeCatchFinishPatched then
          BattleState.__nuzlockeCatchFinishPatched = true
          local vanillaCatchFinish = BattleState.finish
          BattleState.finish = function(self, ...)
              if not self.__nuzlockeCatchBattleEndedEmitted then
                  self.__nuzlockeCatchBattleEndedEmitted = true
                  local okRuntime, Runtime = pcall(require, "src.mods.Runtime")
                  if okRuntime and Runtime and type(Runtime.emit) == "function" then
                      pcall(Runtime.emit, "battle.ended", { battle = self })
                  end
              end
              return vanillaCatchFinish(self, ...)
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
              BattleState.askNicknameUI = function(self, mon)
                  if active(self and self.game, self)
                      and mod.save:get("nickname_rule", false)
                      and okStrings and Strings then
                      self.lockedBall, self.blankForAskName = nil, false
                      return self:buildScreen("NamingScreen", {
                          title = Strings("NICKNAME?"),
                          maxLen = 10,
                          onDone = function(name)
                              mon.nickname = name or "A"
                          end,
                      })
                  end
                  return vanillaAskNicknameUI(self, mon)
              end
          end
      end

      BattleState.throwBall = function(self, ball)
          local gameRef = self and self.game
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
                  message = worldTier(gameRef) >= 2 and "Nice try.\nYou already used this area's encounter." or "This area already\nhas a captured\vPOKéMON!"
              elseif reason == "dupes" then
                  message = worldTier(gameRef) >= 2 and "Seriously? Another one?\nDupes Clause says NO." or "You already have\nthis POKéMON family!"
              elseif reason == "overworld" then
                  message = worldTier(gameRef) >= 2 and "That's not a wild encounter.\nThe Nuzlocke doesn't count it." or "Overworld catches\nare turned OFF."
              elseif reason == "town" then
                  message = worldTier(gameRef) >= 2 and "This isn't a route.\nThe Nuzlocke doesn't count town catches." or "Town catches\nare turned OFF."
              elseif reason == "legendary" then
                  message = worldTier(gameRef) >= 2 and "A LEGENDARY?\nIn a Nuzlocke? Absolutely not." or "Legendary catches\nare turned OFF."
              elseif reason == "mythical" then
                  message = worldTier(gameRef) >= 2 and "Nice try, Team Rocket.\nMYTHICALS are off limits." or "Mythical catches\nare turned OFF."
              elseif reason == "solo" then
                  message = worldTier(gameRef) >= 2 and "One hero. No backup.\nSolo Only says that's enough." or "Solo Only: only\none Pokemon allowed!"
              end

              -- Use the same message entry point as Bryan's implementation.
              -- If a stripped/older build does not expose say(), fall back
              -- to the queue-based API rather than touching phase/queue state.
              if message then
                  if type(self.say) == "function" then
                      self:say(message)
                  elseif type(self.sayNext) == "function" then
                      self:sayNext(message)
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
      if not mod.save:get("nickname_rule", false) then return end
      local mon = ev.mon
      if mon.nickname == nil or mon.nickname == "" or mon.nickname == mon.species then
          mon.nuzlockeNeedsNickname = true
          mon.nuzlockeNicknameRequired = true
          worldMechanic(ev.game, "nickname",
              "Every teammate gets a nickname.\nNo exceptions.",
              "Give it a name.\nYou're going to regret it if you don't.",
              "A name makes it a teammate, not just a party slot.")
      end
  end)

  ---------------------------------------------------------------------
  -- BATTLE ITEM ENFORCEMENT
  --
  -- The engine's current BagMenu calls ItemEffects.use(...) directly when
  -- an item is selected in battle.  There is no native battle.use_item hook
  -- at that call site, so wrapping that nonexistent hook cannot prevent the
  -- item from being applied.  Intercept ItemEffects.use instead.
  --
  -- This is deliberately done at the shared item-effect layer so it covers
  -- every battle item path (HP/status medicine, PP recovery, X items,
  -- Dire Hit, Guard Spec, etc.) without consuming the item or the turn.
  ---------------------------------------------------------------------
  local function installBattleItemGate()
      local ok, ItemEffects = pcall(require, "src.inventory.ItemEffects")
      if not ok or type(ItemEffects) ~= "table"
          or type(ItemEffects.use) ~= "function" then
          return false
      end

      -- Avoid stacking wrappers if the mod is hot-reloaded.
      if ItemEffects.__nuzlockeBattleItemGateInstalled then
          return true
      end

      local vanillaUse = ItemEffects.use

      local healingItems = {
          POTION = true, SUPER_POTION = true, HYPER_POTION = true,
          MAX_POTION = true, FULL_RESTORE = true,
          REVIVE = true, MAX_REVIVE = true,
          ANTIDOTE = true, BURN_HEAL = true, ICE_HEAL = true,
          AWAKENING = true, PARLYZ_HEAL = true, FULL_HEAL = true,
          ETHER = true, MAX_ETHER = true, ELIXIR = true, MAX_ELIXIR = true,
          FRESH_WATER = true, SODA_POP = true, LEMONADE = true,
          MOOMOO_MILK = true,
      }

      local battleItems = {
          X_ATTACK = true, X_DEFEND = true, X_SPEED = true,
          X_SPECIAL = true, X_ACCURACY = true,
          DIRE_HIT = true, GUARD_SPEC = true,
      }

      ItemEffects.use = function(data, save, itemId, target, battle, moveIndex, ow)
          if battle and active(battle.game, battle) then
              local id = tostring(itemId or ""):upper()

              -- Poké Balls remain legal and continue through battle.catch.
              local isBall = id == "POKE_BALL" or id == "GREAT_BALL"
                  or id == "ULTRA_BALL" or id == "MASTER_BALL"
                  or id == "SAFARI_BALL"

              if not isBall then
                  if mod.save:get("no_healing_items", false)
                      and healingItems[id] then
                      worldMechanic(battle.game, "battle_heal_items",
                          "Healing items are\nbanned in battle!",
                          "Nice try.\nYour Nuzlocke says no healing in battle.",
                          "The League has seen enough potion nonsense.\nPut the medicine away.")
                      return "failed", { "Healing items are\nbanned in battle!" }
                  end

                  if mod.save:get("no_battle_items", false)
                      and battleItems[id] then
                      worldMechanic(battle.game, "battle_x_items",
                          "Battle items are\nbanned!",
                          "No X-Item cheese!",
                          "The League has banned the ancient art of X-Item nonsense.")
                      return "failed", { "Battle items are\nbanned!" }
                  end

                  -- Legacy compatibility: older saves may still contain the
                  -- former combined no_items key.
                  if mod.save:get("no_items", false) then
                      return "failed", {
                          "Items are banned\nduring battle!"
                      }
                  end
              end
          end

          return vanillaUse(data, save, itemId, target, battle, moveIndex, ow)
      end

      ItemEffects.__nuzlockeBattleItemGateInstalled = true
      return true
  end

  -- Install immediately; also retry at lifecycle points in case the engine
  -- has not loaded the inventory module yet.
  pcall(installBattleItemGate)
  mod.events:on("game.ready", function()
      pcall(installBattleItemGate)
  end)
  mod.events:on("save.loaded", function()
      pcall(installBattleItemGate)
  end)

  ---------------------------------------------------------------------
  -- NO ITEMS IN BATTLE
  -- hooks:wrap("battle.use_item") fires when the player selects an
  -- item from the Bag menu during battle. Returning false cancels
  -- the use and keeps the turn. Only healing/revival items are
  -- blocked; key items and Poke Balls are allowed.
  ---------------------------------------------------------------------
  mod.hooks:wrap("battle.use_item", function(next, battle, item)
      if not active(battle and battle.game, battle) then
          return next(battle, item)
      end

      local itemId = type(item) == "table"
          and (item.id or item.key or item.name)
          or tostring(item or "")
      local upper = tostring(itemId):upper()

      local healing = {
          "POTION", "SUPER_POTION", "HYPER_POTION", "MAX_POTION",
          "FULL_RESTORE", "FULL_HEAL", "REVIVE", "MAX_REVIVE",
          "ETHER", "MAX_ETHER", "ELIXIR", "MAX_ELIXIR",
          "FRESH_WATER", "SODA_POP", "LEMONADE", "MOOMOO_MILK",
          "ANTIDOTE", "BURN_HEAL", "ICE_HEAL", "AWAKENING",
          "PARALYZE_HEAL",
      }

      local isHealing = false
      for _, pattern in ipairs(healing) do
          if upper:find(pattern, 1, true) then
              isHealing = true
              break
          end
      end

      if isHealing and (mod.save:get("no_healing_items", false)
          or mod.save:get("no_items", false)) then
          worldMechanic(battle and battle.game or currentGame, "battle_heal_items",
              "Healing items are\nbanned in battle!",
              "Nice try.\nYour Nuzlocke says no healing in battle.",
              "The League has seen enough potion nonsense.\nPut the medicine away.")
          return false, "Healing items are\nbanned in battle!"
      end

      if not isHealing and mod.save:get("no_battle_items", false) then
          -- Poke Balls are handled by battle.catch.
          if not upper:find("BALL", 1, true) then
              worldMechanic(battle and battle.game or currentGame, "battle_x_items",
                  "Battle items are\nbanned!",
                  "No X-Item cheese!",
                  "The League has banned the ancient art of X-Item nonsense.")
              return false, "Battle items are\nbanned!"
          end
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
          if provider then
              return next(ctx)
          end
          worldMechanic(battle and battle.game or currentGame, "no_escape",
              "Nuzlocke Rule: NO RUNNING.\nThe turn is yours now.",
              "You wanted Hardcore.\nYou got Hardcore. You're committed now.",
              "Rival: You picked these rules.\nDon't start complaining when the wild Pokemon won't let you leave.")
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

      local key = registerArea(ev.mapId)

      local mapUpper = tostring(ev.mapId):upper()
      if mapUpper:find("CENTER", 1, true) and (mapUpper:find("POKEMON", 1, true) or mapUpper:find("POKE", 1, true)) then
          worldOnce(currentGame, "center:" .. tostring(ev.mapId), "Nurse Joy: Take care of the ones you've got.\n\"Every teammate matters in a challenge like this.\"")
      end

      if not isTrackedArea(key) then
          return
      end

      markVisited(key)
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

      local key = registerArea(ev.mapId)
      if key then
          markVisited(key)
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
  -- Detects Red, Blue, or Yellow. Falls back to "RED" on failure.
  ---------------------------------------------------------------------
  local function getGameVersion()
      local ok, GameVersion = pcall(require, "src.core.GameVersion")
      if ok and GameVersion then
          local v = type(GameVersion.get) == "function" and GameVersion.get()
              or type(GameVersion.version) == "string" and GameVersion.version
              or tostring(GameVersion)
          if v then
              local upper = tostring(v):upper()
              if upper:find("YELLOW") or upper:find("YLW") then return "YELLOW" end
              if upper:find("BLUE")   or upper:find("BLU") then return "BLUE"   end
          end
      end
      if currentGame then
          local ver = currentGame.version
              or (currentGame.data and currentGame.data.version)
          if ver then
              local u = tostring(ver):upper()
              if u:find("YELLOW") then return "YELLOW" end
              if u:find("BLUE")   then return "BLUE"   end
          end
      end
      return "RED"
  end

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
              setPokemonOrigin(mon, "NORMAL")
              baselineAdd(mon, "NORMAL")
          end
          return
      end

      local log = trackerLog()
      log[area] = log[area] or {}
      table.insert(log[area], {
          species       = species,
          isShiny       = mon and mon.dvs and Stats.isShiny(mon.dvs) or false,
          encounterType = "gift",
      })
      mod.save:set("tracker_log", log)
      markCaught(area, species)

      if mon then
          mon.catchLocation = area
          mon.encounterType = "gift"
          mon.nuzlockeDead  = false
          mon.nuzlockeTrackerRegistered = true
          setPokemonOrigin(mon, "NORMAL")
          baselineAdd(mon, "NORMAL")
      end

      local history = mod.save:get("nuzlocke_history", {})
      if type(history) ~= "table" then history = {} end
      table.insert(history, {
          name          = (mon and (mon.nickname or mon.species)) or species,
          species       = species,
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
      if not species or not area then return end
      registerArea(area)
      markVisited(area)

      local log = trackerLog()
      log[area] = log[area] or {}
      table.insert(log[area], {
          species       = species,
          isShiny       = mon and mon.dvs and Stats.isShiny(mon.dvs) or false,
          encounterType = encounterType,
      })
      mod.save:set("tracker_log", log)
      markCaught(area, species)

      if mon then
          mon.catchLocation = area
          mon.encounterType = encounterType
          mon.nuzlockeDead  = false
          mon.nuzlockeTrackerRegistered = true
          setPokemonOrigin(mon, "NORMAL")
          baselineAdd(mon, "NORMAL")
      end

      local history = mod.save:get("nuzlocke_history", {})
      if type(history) ~= "table" then history = {} end
      table.insert(history, {
          name          = (mon and (mon.nickname or mon.species)) or species,
          species       = species,
          catchLocation = area,
          encounterType = encounterType,
          status        = "ALIVE",
      })
      mod.save:set("nuzlocke_history", history)
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
  --   3. Gift (blocked) → mon removed from party.
  --   4. Trade (allowed)→ area from TRADE_DATA or current map.
  --   5. Trade (blocked)→ mon removed from party.
  ---------------------------------------------------------------------
  local function wonderTradeProviderContext(game, ev)
      local provider = activeCompatProvider("wonder_trade", game, nil)
      local context = providerContext(provider, game, nil) or {}
      if type(ev) == "table" then
          local fields = { "wonderTradeArea", "originArea", "fromArea", "sourceLocation", "tradeArea" }
          for _, field in ipairs(fields) do
              if context.area == nil and ev[field] ~= nil then
                  context.area = routeKey(ev[field]) or ev[field]
              end
          end
          if context.area == nil and ev.context and type(ev.context) == "table" then
              context.area = routeKey(ev.context.area or ev.context.originArea)
          end
      end
      return provider, context
  end

  local function isWonderTradeEvent(ev, source)
      if type(ev) ~= "table" then return false end
      if ev.wonderTrade == true or ev.isWonderTrade == true or ev.wonder_trade == true then return true end
      source = tostring(source or ""):lower():gsub("[%s%-]", "_")
      return source == "wonder_trade" or source == "wondertrade" or source == "wt"
  end

  local function registerWonderTradeCatch(game, ev, mon, species, area, provider)
      area = routeKey(area) or area
      if not area or area == "UNKNOWN" or area == "__LEGACY__" then
          return false
      end

      -- Wonderlocke is a replacement for the existing encounter, not a second
      -- catch in the same area. Prefer the outgoing Pokemon supplied by the
      -- provider and replace that tracker row in-place. If no outgoing identity
      -- is available, only replace a single existing row; never collapse a
      -- legitimately multi-attributed area.
      local context = (providerContext(provider, game, nil) or {})
      local outgoing = (type(ev) == "table" and (ev.outgoingMon or ev.sentMon or ev.tradedMon))
          or context.outgoingMon
      local log = trackerLog()
      local entries = log[area]
      local replaced = false
      local outgoingSpecies = outgoing and tostring(outgoing.species or ""):upper() or nil
      local outgoingFp = outgoing and pokemonFingerprint(outgoing) or nil

      if type(entries) == "table" and #entries > 0 then
          local replaceIndex
          if outgoingFp then
              for i, entry in ipairs(entries) do
                  if entry and entry.fingerprint and entry.fingerprint == outgoingFp then
                      replaceIndex = i; break
                  end
              end
          end
          if not replaceIndex and outgoingSpecies then
              for i, entry in ipairs(entries) do
                  if tostring(entry and entry.species or ""):upper() == outgoingSpecies then
                      replaceIndex = i; break
                  end
              end
          end
          if not replaceIndex and #entries == 1 then
              replaceIndex = 1
          end

          if replaceIndex then
              entries[replaceIndex] = {
                  species = species,
                  isShiny = mon and mon.dvs and Stats.isShiny(mon.dvs) or false,
                  encounterType = "wonder_trade",
                  encounterSource = "wonder_trade",
                  encounterProvider = provider and provider.id or nil,
                  encounterProviderVersion = provider and provider.version or nil,
                  encounterContext = context,
                  fingerprint = pokemonFingerprint(mon),
                  provenance = "NORMAL",
                  retroactive = false,
              }
              replaced = true
              mod.save:set("tracker_log", log)
              markCaught(area, species)
              markVisited(area)
          end
      end

      if not replaced then
          -- No safe outgoing match. This can happen with a provider that does
          -- not expose the sent Pokemon. Keep the encounter visible rather than
          -- guessing which existing attributed Pokemon should disappear.
          registerSpecialCatch(species, area, "wonder_trade", mon)
      end

      if mon then
          mon.catchLocation = area
          mon.encounterType = "wonder_trade"
          mon.nuzlockeEncounterSource = "wonder_trade"
          mon.nuzlockeEncounterProvider = provider and provider.id or mon.nuzlockeEncounterProvider
          mon.nuzlockeEncounterProviderVersion = provider and provider.version or mon.nuzlockeEncounterProviderVersion
          mon.nuzlockeWonderTradeOrigin = area
          mon.nuzlockeDead = false
          mon.nuzlockeTrackerRegistered = true
          setPokemonOrigin(mon, "NORMAL")
          baselineAdd(mon, "NORMAL")
      end

      local history = mod.save:get("nuzlocke_history", {})
      if type(history) ~= "table" then history = {} end
      table.insert(history, {
          name = (mon and (mon.nickname or species)) or species,
          species = species,
          catchLocation = area,
          encounterType = "wonder_trade",
          encounterSource = "wonder_trade",
          encounterProvider = provider and provider.id or nil,
          encounterProviderVersion = provider and provider.version or nil,
          status = "ALIVE",
      })
      mod.save:set("nuzlocke_history", history)

      worldMechanic(game, "wonder_trade:" .. tostring(mon and (mon.nickname or species) or species),
          "WONDER TRADE!\nThe received Pokemon counts as your encounter.",
          "Wonder Trade time.\nOne catch in, one teammate out.",
          "The Nuzlocke accepts the mystery trade.\nWhatever comes back is now part of the run.")
      return true
  end

  -- Public adapter for Wonder Trade mods that prefer an explicit integration
  -- call over emitting pokemon.received. It is intentionally data-driven and
  -- does not depend on the other mod's name.
  if mod.exports.nuzlocke_compat then
      mod.exports.nuzlocke_compat.handleWonderTrade = function(game, mon, area, providerId)
          local species = tostring(mon and mon.species or ""):upper()
          if species == "" then return false end
          if mod.save:get("wonderlocke", false) ~= true then return false end
          local provider = providerId and activeCompatProvider("wonder_trade", game, nil) or activeCompatProvider("wonder_trade", game, nil)
          return registerWonderTradeCatch(game, { wonderTradeArea = area }, mon, species, area, provider)
      end
  end

  mod.events:on("pokemon.received", function(ev)
      if not ev then return end
      local game    = ev.game or currentGame
      local mon     = ev.mon
      local species = tostring(ev.species or (mon and mon.species) or "")
      if species == "" then return end
      species = species:upper()

      local source = tostring(ev.source or ""):lower()

      local rawLoc = ev.location or ev.mapId or ev.area
          or (game and game.overworld and game.overworld.map
              and game.overworld.map.id)
          or (game and game.save and game.save.player
              and game.save.player.map)
      local loc = routeKey(rawLoc) or "UNKNOWN"

      -- 1. Starter (explicit flag or species+location heuristic)
      local isStarter = (source == "starter")
          or (isStarterSpecies(species)
              and (loc == "PALLET_TOWN" or loc == "UNKNOWN"))
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

      -- Wonder Trade is deliberately its own acquisition type. It does not
      -- consume the ordinary In-Game Trades setting. When Wonderlocke is ON,
      -- the outgoing Pokemon's encounter area is the source area for the
      -- incoming Pokemon. A compatible provider may supply that area through
      -- its get_context() export; event fields are accepted as a fallback.
      if isWonderTradeEvent(ev, source) then
          local provider, context = wonderTradeProviderContext(game, ev)
          if mod.save:get("wonderlocke", false) ~= true then
              -- Wonder Trade is a distinct acquisition mechanic. If a Nuzlocke
              -- is active and the player has not opted into Wonderlocke, do not
              -- let the trade become an untracked bypass. A provider may still
              -- perform its own rollback/transaction cleanup after this event.
              worldMechanic(game, "wonder_trade_blocked",
                  "WONDER TRADE is not enabled by your rules.",
                  "Mystery trade? Not on this run.",
                  "The Wonder Trade machine is ready...\nBut the Nuzlocke rules say NO.")
              if mon and game and game.save and game.save.party then
                  for i = #game.save.party, 1, -1 do
                      if game.save.party[i] == mon then table.remove(game.save.party, i); break end
                  end
              end
              return
          end

          local origin = context.area or ev.wonderTradeArea or ev.originArea
              or ev.fromArea or (mon and mon.nuzlockeWonderTradeOrigin)
              or (mon and mon.catchLocation)
          if not registerWonderTradeCatch(game, ev, mon, species, origin, provider) then
              -- Never invent a route. Keep the Pokemon recoverable instead of
              -- corrupting the encounter log when a provider omitted origin data.
              if mon then
                  mon.nuzlockePendingWonderTrade = true
                  mon.nuzlockeWonderTradeProvider = provider and provider.id or nil
              end
              worldMechanic(game, "wonder_trade_missing_origin",
                  "WONDER TRADE NEEDS AN ORIGIN.\nThe trade was not assigned a route.",
                  "Mystery trade, mystery route.\nWe'll recover it instead of guessing.",
                  "The Wonder Trade provider did not tell the Nuzlocke where the outgoing catch came from.")
          end
          return
      end

      local isGift  = (source == "gift" or source == "fossil"
          or source == "prize" or giftLookup[species] ~= nil)
      local isTrade = (source == "trade" or tradeLookup[species] ~= nil)

      -- 2-3. Gift
      if isGift and not isTrade then
          if not mod.save:get("allow_gifts", false) then
              if mon and game and game.save and game.save.party then
                  for i = #game.save.party, 1, -1 do
                      if game.save.party[i] == mon then
                          table.remove(game.save.party, i); break
                      end
                  end
              end
              worldMechanic(game, "gift_denied:" .. tostring(species),
                  "GIFT POKéMON are disabled by your rules.",
                  "Free Pokemon? Nice try.\nYour Nuzlocke says no gifts.",
                  "NPC: Here! Take this Pokemon!\n...Wait. Your challenge doesn't allow gifts.\nYou probably shouldn't have asked.")
              return
          end
          local giftArea = giftLookup[species] or loc
          registerSpecialCatch(species, giftArea, "gift", mon)
          return
      end

      -- 4-5. Trade
      if isTrade then
          if not mod.save:get("allow_trades", false) then
              if mon and game and game.save and game.save.party then
                  for i = #game.save.party, 1, -1 do
                      if game.save.party[i] == mon then
                          table.remove(game.save.party, i); break
                      end
                  end
              end
              worldMechanic(game, "trade_denied:" .. tostring(species),
                  "IN-GAME TRADES are disabled by your rules.",
                  "Trade? Not on this run.\nKeep your own team.",
                  "The trade almost happened...\nThen the Nuzlocke referee cleared his throat.")
              return
          end
          local tradeArea = tradeLookup[species] or loc
          registerSpecialCatch(species, tradeArea, "trade", mon)
      end
  end)

  ---------------------------------------------------------------------
  -- CATCH RULE ENFORCEMENT
  ---------------------------------------------------------------------
  local function pokemonFamily(game, species)
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

  local function ownsFamily(game, species)
      local members = pokemonFamily(game, species)
      local function owns(mon) return mon and members[mon.species] == true end
      for _, mon in ipairs((game.save and game.save.party) or {}) do
          if owns(mon) then return true end
      end
      for _, box in ipairs((game.save and game.save.boxes) or {}) do
          for _, mon in ipairs(box or {}) do
              if owns(mon) then return true end
          end
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

  local function getEncounterState(key)
      if not key then return nil end
      return encounterStates()[key]
  end

  local function markEncounterFailed(key, species, encounterType)
      if not key or mod.save:get("failed_encounter", true) ~= true then return end
      key = registerArea(key)
      if not isTrackedArea(key) then return end
      local states = encounterStates()
      states[key] = {
          status = "FAILED",
          species = species,
          encounterType = encounterType or "wild",
      }
      mod.save:set("encounter_states", states)
  end

  local function markEncounterCaught(key, species, encounterType)
      if not key then return end
      key = registerArea(key)
      if not isTrackedArea(key) then return end
      local states = encounterStates()
      states[key] = {
          status = "CAUGHT",
          species = species,
          encounterType = encounterType or "wild",
      }
      mod.save:set("encounter_states", states)
  end

  local activeWildEncounter = nil

  local function isTrainerBattleForNuzlocke(battle)
      if not battle then return false end
      if battle.trainerBattle == true or battle.isTrainerBattle == true then return true end
      if battle.trainer ~= nil or battle.opponentTrainer ~= nil then return true end
      if battle.opponent and type(battle.opponent) == "table" and battle.opponent.name then return true end
      return false
  end

  local function beginWildEncounter(payload)
      if not payload then return end
      local battle = payload.battle or payload
      if not battle or isTrainerBattleForNuzlocke(battle) then return end
      if not currentGame then currentGame = payload.game end
      local game = payload.game or currentGame
      if not active(game, battle) then return end

      local key = areaKey(game, battle)
      if not key then return end
      local species = battle.enemy and battle.enemy.mon and battle.enemy.mon.species
          or battle.enemy and battle.enemy.species
          or payload.species
      if type(species) ~= "string" or species == "" then return end

      local shiny = enemyIsShiny(battle)
      local shinyClause = mod.save:get("shiny_clause", false) == true
      local town = isTownArea(key, routeName(key))
      local overworld = battle.overworldEncounter == true
          or battle.overworld == true
          or battle.isOverworld == true
          or battle.encounterType == "overworld"
          or battle.source == "overworld"

      if overworld and not mod.save:get("overworld_encounters", false) then return end
      if town and not mod.save:get("town_catches", false) then return end
      if not mod.save:get("encounter_limit", false) then return end
      if mod.save:get("failed_encounter", true) ~= true then return end
      if caughtAreas()[key] ~= nil then return end

      local existing = getEncounterState(key)
      if existing and (existing.status == "FAILED" or existing.status == "CAUGHT") then return end

      if mod.save:get("dupes_mode", false) and ownsFamily(game, species)
          and not (shiny and shinyClause) then
          return
      end

      local provider = activeCompatProvider("encounters", game, battle)
      if provider then rememberEncounterProvider(provider.id, provider.version) end
      activeWildEncounter = {
          battle = battle, game = game, key = key, species = species,
          encounterType = overworld and "overworld" or (town and "town" or "wild"),
          encounterSource = provider and "provider" or "vanilla",
          encounterProvider = provider and provider.id or nil,
          encounterProviderVersion = provider and provider.version or nil,
          encounterContext = providerContext(provider, game, battle),
          resolved = false,
      }
  end

  mod.events:on("battle.started", function(payload)
      beginWildEncounter(payload)

      local battle = payload and (payload.battle or payload)
      local game = payload and payload.game or currentGame
      if not battle or not game or not active(game, battle) or not isTrainerBattleForNuzlocke(battle) then return end
      local oppClass = tostring(battle.oppClass or battle.trainerClass or battle.opponentClass or ""):upper()
      local trainerName = tostring((battle.trainer and battle.trainer.name) or battle.trainerName or battle.opponentName or ""):upper()
      local label = oppClass .. " " .. trainerName
      if label:find("RIVAL", 1, true) or label:find("BLUE", 1, true) then
          worldOnce(game, "rival_notice", "Your Rival notices the rules.\n\"Only one Pokemon? You're seriously doing this to yourself?\"")
      elseif label:find("BROCK", 1, true) then
          worldOnce(game, "brock_notice", "Brock looks over your team.\n\"I've heard about your little challenge.\"\n\"Don't worry. My team won't go easy on you.\"")
      elseif label:find("MISTY", 1, true) then
          worldOnce(game, "misty_notice", "Misty smirks.\n\"Let's see how long those rules last.\"")
      elseif label:find("LT SURGE", 1, true) or label:find("LT_SURGE", 1, true) then
          worldOnce(game, "surge_notice", "Lt. Surge grins.\n\"Hardcore rules? Good. I like a serious challenger.\"")
      elseif label:find("ERIKA", 1, true) or label:find("KOGA", 1, true) or label:find("SABRINA", 1, true) or label:find("BLAINE", 1, true) or label:find("GIOVANNI", 1, true) then
          worldOnce(game, "gym_leader_notice:" .. label, "The Gym Leader has heard about your Nuzlocke.\n\"Let's see whether you can follow your own rules under pressure.\"")
      end
  end)

  -- League progression is recorded whenever the Nuzlocke is active, even if
  -- the player temporarily chooses a shorter cap scope. That way changing
  -- GYMS -> E4 -> CHAMP later does not erase victories that already happened.
  -- This is independent of trainer provenance logging, so other trainer mods
  -- can safely coexist with it.
  mod.events:on("battle.ended", function(payload)
      if not payload then return end
      local battle = payload.battle or payload
      if not battle or battle.kind ~= "trainer" then return end
      if payload.result ~= "win" and battle.result ~= "win" then return end
      local trainer = battle.trainer
      local trainerId = trainer and trainer.id
      local trainerName = tostring((trainer and trainer.name) or battle.trainerName or battle.opponentName or ""):upper()
      local trainerKey = trainerName .. " " .. tostring(trainerId or ""):upper()

      -- Record Gym Leader victories independently of badge inventory. This
      -- prevents a later change from NONE -> E4 from manufacturing a League
      -- cap before the Gym progression has actually reached the League.
      local gymProgressTable = gymProgress(currentGame and currentGame.save)
      for _, gymLeader in ipairs(LEVEL_CAP_GYM_LEADERS) do
          if trainerName:find(gymLeader, 1, true)
              or tostring(trainerId or ""):upper():find(gymLeader:gsub(" ", ""), 1, true) then
              gymProgressTable[gymLeader] = true
              mod.save:set(GYM_PROGRESS_KEY, gymProgressTable)
              break
          end
      end

      if type(trainerId) == "string" then
          for _, entry in ipairs(ELITE_FOUR_CAPS) do
              if trainerId == entry.id then
                  local defeated = eliteFourDefeated()
                  defeated[entry.id] = true
                  mod.save:set("nuzlocke_e4_defeated", defeated)
                  return
              end
          end
      end
      -- Vanilla final-rival detection is intentionally conservative: only
      -- count a Rival/Blue battle as Champion progress after all four E4
      -- members are defeated and all eight badges are present. This avoids
      -- confusing earlier Rival battles with the Champion.
      if currentBadgeCount(currentGame and currentGame.save) >= 8
          and not (nextEliteFourCapInfo())
          and (trainerKey:find("RIVAL", 1, true) or trainerKey:find("BLUE", 1, true) or trainerKey:find("CHAMPION", 1, true)) then
          mod.save:set("nuzlocke_champion_defeated", true)
      end
  end)

  mod.events:on("battle.ended", function(payload)
      -- Do not rely on battle.started state surviving the battle.  The engine's
      -- authoritative finish seam emits battle.ended with the actual BattleState,
      -- so resolve the failed encounter directly from that battle.  This also
      -- works when a battle is ended by RUN, KO, or another teardown path.
      local pending = activeWildEncounter
      activeWildEncounter = nil

      local battle = payload and (payload.battle or payload)
      local game = currentGame
      if not battle or not game or not game.save then
          return
      end
      if pending and pending.battle and battle ~= pending.battle then
          pending = nil
      end
      if isTrainerBattleForNuzlocke(battle) then
          return
      end
      if mod.save:get("nuzlocke_enabled", true) ~= true
          or mod.save:get("encounter_limit", false) ~= true
          or mod.save:get("failed_encounter", true) ~= true then
          return
      end

      local key = areaKey(game, battle)
      local species = battle.enemy and battle.enemy.mon and battle.enemy.mon.species
      if not key or type(species) ~= "string" or species == "" then
          return
      end

      local shiny = enemyIsShiny(battle)
      if shiny and mod.save:get("shiny_clause", false) == true then
          return
      end

      local town = isTownArea(key, routeName(key))
      local overworld = battle.overworldEncounter == true
          or battle.overworld == true
          or battle.isOverworld == true
          or battle.encounterType == "overworld"
          or battle.source == "overworld"
      if overworld and mod.save:get("overworld_encounters", false) ~= true then
          return
      end
      if town and mod.save:get("town_catches", false) ~= true then
          return
      end
      if caughtAreas()[key] ~= nil then
          return
      end

      local state = getEncounterState(key)
      if state and (state.status == "FAILED" or state.status == "CAUGHT") then
          return
      end

      if mod.save:get("dupes_mode", false) == true
          and ownsFamily(game, species) then
          return
      end

      markEncounterFailed(key, species, overworld and "overworld"
          or (town and "town" or "wild"))
      worldMechanic(game, "failed:" .. tostring(key),
          "ENCOUNTER FAILED.\nThat was your one shot in this area.",
          "Oof. There goes your encounter.\nThe Nuzlocke gods are keeping score.",
          "The route won't give you another chance.\nKanto has a long memory.")
  end)

  enemyIsShiny = function(battle)
      return battle and battle.enemy and battle.enemy.mon
          and battle.enemy.mon.dvs
          and Stats.isShiny(battle.enemy.mon.dvs) == true
  end

  catchDeniedReason = function(game, battle, species)
      if not active(game, battle) then
          return nil
      end

      -- Guard: species must be a non-empty string. A nil species means the
      -- enemy slot is not populated yet (e.g. transition frames); let it
      -- through rather than incorrectly blocking the throw.
      if type(species) ~= "string" or species == "" then
          return nil
      end

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

      if overworld and not mod.save:get("overworld_encounters", false) then
          return "overworld"
      end

      if town and not mod.save:get("town_catches", false) then
          return "town"
      end

      if mod.save:get("ban_legendaries", false) and LEGENDARIES[species] then
          return "legendary"
      end

      if mod.save:get("ban_mythicals", false) and MYTHICALS[species] then
          return "mythical"
      end

      if mod.save:get("encounter_limit", false)
          and caughtAreas()[key]
          and not (shiny and shinyClause) then
          return "area"
      end

      local encounterState = getEncounterState(key)
      if mod.save:get("encounter_limit", false)
          and mod.save:get("failed_encounter", true)
          and encounterState and encounterState.status == "FAILED"
          and not (shiny and shinyClause) then
          return "area"
      end

      if mod.save:get("dupes_mode", false)
          and ownsFamily(game, species)
          and not shiny then
          return "dupes"
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
      if isOverworldEncounter(ev) then return "overworld" end
      if ev and ev.battle and ev.battle.safari then return "safari" end
      if isTownArea(key, routeName(key)) then return "town" end
      return "wild"
  end

  ---------------------------------------------------------------------
  -- POKEMON CAUGHT
  ---------------------------------------------------------------------
  mod.events:on("pokemon.caught", function(ev)
      if not active(ev.game, ev.battle) then
          return
      end

      local key = areaKey(ev.game, ev.battle)
      if not key then return end

      local isShiny = ev.mon and Stats.isShiny(ev.mon.dvs) or false
      local encounterType = encounterTypeFor(ev, key)

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
          markVisited(key)
          return
      end

      if ev.mon then
          ev.mon.catchLocation = key
          ev.mon.encounterType = encounterType
          ev.mon.nuzlockeDead = false
          ev.mon.deathCause = nil
          ev.mon.deathCauseText = nil
          ev.mon.nuzlockeTrackerRegistered = true
          setPokemonOrigin(ev.mon, "NORMAL")
          baselineAdd(ev.mon, "NORMAL")
          ev.mon.nuzlockeEncounterSource = encounterSource
          ev.mon.nuzlockeEncounterProvider = encounterProvider
          ev.mon.nuzlockeEncounterProviderVersion = encounterProviderVersion
          if encounterContext then ev.mon.nuzlockeEncounterContext = encounterContext end

          local history = mod.save:get("nuzlocke_history", {})
          if type(history) ~= "table" then history = {} end
          table.insert(history, {
              name = ev.mon.nickname or ev.mon.species or ev.species or "???",
              species = ev.mon.species or ev.species,
              catchLocation = key,
              encounterType = encounterType,
              encounterSource = encounterSource,
              encounterProvider = encounterProvider,
              encounterProviderVersion = encounterProviderVersion,
              encounterContext = encounterContext,
              status = "ALIVE",
          })
          mod.save:set("nuzlocke_history", history)
      end

      markVisited(key)
      markEncounterCaught(key, ev.species or (ev.mon and ev.mon.species), encounterType)
      if activeWildEncounter and activeWildEncounter.key == key then
          activeWildEncounter.resolved = true
      end

      local log = trackerLog()
      log[key] = log[key] or {}

      -- Never append the same species twice to one area. This is especially
      -- important for acquisition flows where the engine can emit both a
      -- received event and a caught event on separate Pokemon tables.
      local duplicate = false
      local speciesKey = tostring(ev.species or (ev.mon and ev.mon.species) or ""):upper()
      for _, entry in ipairs(log[key]) do
          if tostring(entry and entry.species or ""):upper() == speciesKey then
              duplicate = true
              break
          end
      end

      if not duplicate then
          table.insert(log[key], {
              species = ev.species,
              isShiny = isShiny,
              encounterType = encounterType,
              encounterSource = encounterSource,
              encounterProvider = encounterProvider,
              encounterProviderVersion = encounterProviderVersion,
              encounterContext = encounterContext,
              provenance = "NORMAL"
          })
          mod.save:set("tracker_log", log)
      end

      -- Only successful eligible catches consume the area's encounter.
      if not isShiny or not mod.save:get("shiny_clause", false) then
          if mod.save:get("encounter_limit", false) then
              markCaught(key, ev.species)
          end
      end

      if isShiny and mod.save:get("shiny_clause", false) == true then
          worldMechanic(ev.game, "shiny:" .. tostring(ev.mon and (ev.mon.nickname or ev.mon.species) or ev.species),
              "SHINY!\nThe Shiny Clause says this one gets a pass.",
              "Whoa. SHINY!\nThe rules can wait for this one.",
              "Even the Nuzlocke gods make exceptions for sparkle.")
      else
          worldMechanic(ev.game, "catch:" .. tostring(key) .. ":" .. tostring(ev.species),
              "FIRST ENCOUNTER!\n" .. tostring(ev.mon and (ev.mon.nickname or ev.species) or ev.species) .. " joins the run.",
              "New teammate acquired.\nDon't get attached. You know the rules.",
              tostring(routeName(key)) .. " is officially part of the story now.")
      end
  end)

  -- NOTE: Legendary and Mythical catch blocking is enforced entirely at the
  -- throwBall level via catchDeniedReason. The engine refunds the ball and
  -- the catch never registers, so no post-catch removal is needed here.
  -- A secondary removal would incorrectly consume the ball without refund.

  ---------------------------------------------------------------------
  -- WHITEOUT STATE
  ---------------------------------------------------------------------
  local whiteoutPending = false

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

      if not ok or not BattleState then return end
      if BattleState.__nuzlockeFinal25FaintPatched then return end
      BattleState.__nuzlockeFinal25FaintPatched = true

      -------------------------------------------------------------------
      -- Capture the final damaging move exactly where Gen 1 computes it.
      -- Damage.compute returns { crit = bool }, so the death record can
      -- report a real critical hit instead of guessing.
      -------------------------------------------------------------------
      if not BattleState.__nuzlockeDamagePatched then
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
      if okStatus and StatusModule and not StatusModule.__nuzlockeDeathStatusPatched then
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
                  local causeText
                  if self.nuzlockeLastResidual then
                      causeText = tostring(mon.nickname or mon.species or "Pokemon")
                          .. " died to " .. source
                          .. " after " .. tostring(self.nuzlockeLastResidual) .. "."
                  elseif damage and damage.target == battler then
                      local moveName = tostring(damage.move or "UNKNOWN")
                      local critPrefix = damage.critical and "a critical " or ""
                      if damage.attacker == battler then
                          causeText = tostring(mon.nickname or mon.species or "Pokemon")
                              .. " died after " .. critPrefix .. moveName .. "."
                      else
                          causeText = tostring(mon.nickname or mon.species or "Pokemon")
                              .. " died to " .. source
                              .. " after " .. critPrefix .. moveName .. "."
                      end
                  else
                      causeText = tostring(mon.nickname or mon.species or "Pokemon")
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
                      name = mon.nickname or mon.species or "???",
                      species = mon.species,
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
                      name = mon.nickname or mon.species or "???",
                      species = mon.species,
                      location = key,
                      cause = causeText,
                  })

                  worldMechanic(self.game, "death:" .. tostring(mon.nickname or mon.species) .. ":" .. tostring(key),
                      tostring(mon.nickname or mon.species or "Pokemon") .. " has fallen.\nThe Nuzlocke remembers.",
                      "Ouch. Another one bites the dust.\nYou knew the rules.",
                      "RIP, " .. tostring(mon.nickname or mon.species or "Pokemon") .. ".\nKanto won't forget what happened here.")

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

              self.nuzlockeLastDamage = nil
              self.nuzlockeLastResidual = nil

              if mod.save:get("whiteout_clause", false)
                  and not hasHealthyParty(self.game) then
                  self.nuzlockeGameOver = true
              end
          end

          -- Preserve the engine's normal faint animation, cry, text, and
          -- battle queue. We only alter the save/party state before it runs.
          return vanillaOnFaint(self, battler)
      end

      local vanillaPlayerFainted = BattleState.playerMonFainted
      BattleState.playerMonFainted = function(self)
          if self.nuzlockeGameOver then
              self.result = "nuzlocke_game_over"
              self.afterQueue = "finish"
              -- Try every known message API in priority order.
              local msg = "All of your\nPOKeMON are dead...\nYour run is over."
              if worldTier(self.game) >= 3 then
                  local losses = tonumber(mod.save:get("nuzlocke_losses", 0)) or 0
                  msg = "NUZLOCKE OVER\n" .. tostring(losses) .. " POKéMON lost.\nThe League will remember."
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

      local vanillaFinish = BattleState.finish
      BattleState.finish = function(self)
          if not self.nuzlockeGameOver then
              return vanillaFinish(self)
          end

          self.nuzlockeGameOver = nil

          if self.game and self.game.stack then
              self.game.stack:pop()
          end

          if okRuntime and Runtime then
              Runtime.emit("battle.ended", {
                  battle = self,
                  result = "nuzlocke_game_over"
              })
          end

          local function deleteSaveAndShowTitle()
              if okSave and okVersion and SaveData and GameVersion
                  and SaveData.activeSlot then
                  local version = GameVersion.get()
                  local slot = SaveData.activeSlot(version)
                  if slot then SaveData.deleteSlot(version, slot) end
              end

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

          if worldTier(self.game) >= 3 then
              local losses = tonumber(mod.save:get("nuzlocke_losses", 0)) or 0
              local catches = countTrackerCatches()
              local badges = currentBadgeCount(self.game.save)
              local last = mod.save:get("last_loss", {}) or {}
              local lastName = tostring(last.name or "NONE")
              local lastLoc = routeName(last.location or "UNKNOWN")
              local summary = "NUZLOCKE OVER\nBADGES: " .. tostring(badges)
                  .. "\nCAUGHT: " .. tostring(catches)
                  .. "  LOST: " .. tostring(losses)
                  .. "\nLAST LOSS: " .. lastName
                  .. "\n" .. lastLoc
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
      local okCommands, Commands = pcall(require, "src.script.Commands")
      if not okCommands or not Commands then
          return false
      end

      if Commands.__nuzlockeRulesPatched then
          return true
      end

      local originalHeal = Commands.heal_party
      local originalOpenMart = Commands.open_mart
      if type(originalHeal) ~= "function" then
          return false
      end

      Commands.__nuzlockeRulesPatched = true

      local function showRuleMessage(ctx, msg)
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
          local game = ctx and (ctx.game or (ctx.env and ctx.env.game))
          if not game or not game.stack then return end
          local okText, TextBox = pcall(require, "src.render.TextBox")
          if okText and TextBox then
              pcall(function()
                  game.stack:push(TextBox.new(game, msg))
              end)
          end
      end

  ---------------------------------------------------------------------
  -- AUTHORITATIVE SCRIPT-COMMAND HEAL GATE
  --
  -- The recomp's ScriptRunner resolves every script row through the live
  -- Runtime "script.command" hook.  This is more reliable than only replacing
  -- Commands.heal_party because map scripts can otherwise retain a cached
  -- function reference.  We use the map id/label to distinguish Pokémon
  -- Centers from Mom's house, since both ultimately use heal_party.
  ---------------------------------------------------------------------
  local function nuzlockeMapTag(ctx)
      local ow = ctx and ctx.overworld
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
          -- Mom's vanilla heal script fades to white immediately before
          -- heal_party.  If healing is disabled, suppress both fades so the
          -- personalized refusal is shown on the normal room screen.
          if name == "fade"
              and mod.save:get("no_mom_heal", false) == true
              and isMomsHouseMap(ctx) then
              return
          end

          if name == "heal_party" then
              if mod.save:get("no_mom_heal", false) == true
                  and isMomsHouseMap(ctx) then
                  -- Mom's vanilla script fades to white immediately before
                  -- heal_party.  This hook runs at heal_party, so skip the
                  -- remainder and replace the heal with Mom's own message.
                  showRuleMessageImmediate(ctx, worldTier(ctx.game) >= 2
                      and "Mom: Nice try, sweetheart.\nThe Nuzlocke says I can't heal you.\nI believe in you!"
                      or "Mom: I know you need\nrest, sweetheart, but\nour Nuzlocke rules say\nI can't heal your\nPokemon right now.\nYou'll be okay!")
                  return "end"
              end

              if mod.save:get("no_poke_center", false) == true
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

  installNuzlockeScriptHealGate()

      local function blockedHeal(ctx)
          -- heal_party is also used by Mom, so the Center rule must only
          -- fire while the script is actually running in a Pokemon Center.
          if mod.save:get("no_poke_center", false) == true
              and isPokemonCenterMap(ctx) then
              showRuleMessage(ctx,
                  "Nurse Joy: I'm sorry,\nbut your Nuzlocke\nrules don't allow\nPokemon Center\nhealing right now.")
              return
          end
          return originalHeal(ctx)
      end

      Commands.heal_party = blockedHeal

      if type(originalOpenMart) == "function" then
          local function blockedOpenMart(ctx, textConst)
              if mod.save:get("no_shopping", false) == true then
                  showRuleMessage(ctx, worldTier(ctx.game) >= 2
                      and "Clerk: Nice try.\nThe Nuzlocke says your wallet\nhas to suffer today."
                      or "Clerk: I'd love to\nhelp, but your Nuzlocke\nrules prevent shopping.\nYour wallet lives to\nfight another day!")
                  return
              end
              return originalOpenMart(ctx, textConst)
          end
          Commands.open_mart = blockedOpenMart
      end

      -- Force the resolver to return the wrapped command too.  This is the
      -- important part for map scripts that resolve command names at runtime.
      if type(Commands.resolve) == "function" then
          local originalResolve = Commands.resolve
          Commands.resolve = function(data, name)
              if name == "heal_party" then
                  return blockedHeal, Commands.meta and Commands.meta[name]
              end
              if name == "open_mart" and type(originalOpenMart) == "function" then
                  return Commands.open_mart, Commands.meta and Commands.meta[name]
              end
              return originalResolve(data, name)
          end
      end

      -- Secondary hook seams for builds that expose field healing through the
      -- public hook layer instead of the script command table.
      local function denyCenter(next, ctx, ...)
          if mod.save:get("no_poke_center", false) == true
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
              Commands[name] = function(ctx)
                  if mod.save:get("no_mom_heal", false) == true then
                      showRuleMessage(ctx, momMsg)
                      return
                  end
                  return originalMom(ctx)
              end
          end
      end

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

end
