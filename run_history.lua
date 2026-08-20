return function(mod, deps)
  deps = deps or {}
  ---------------------------------------------------------------------
  -- RUN HISTORY v1 (2.5.73; producer completion 2.5.85)
  --
  -- One bounded, append-only event journal for future Graveyard, Almanac,
  -- Confessional, meta-run and companion-mod surfaces.  This deliberately
  -- lives BESIDE tracker_log/nuzlocke_history in schema 4: those structures
  -- still own encounter projection and legacy death state, while Run History
  -- owns chronology.  Producers append only at already-proven transaction
  -- boundaries, so no UI needs to reverse-engineer chronology from mutable
  -- save snapshots later.
  ---------------------------------------------------------------------
  mod.exports.__beta26.RunHistory = {
      api = 1,
      storage_version = 1,
      storage_key = "run_history_v1",
      max_events = 512,
      summary_kinds = {
          ["pokemon.caught"] = "catches",
          ["pokemon.died"] = "deaths",
          ["badge.earned"] = "badges",
          ["forgiveness.awarded"] = "forgiveness_awarded",
          ["forgiveness.used"] = "forgiveness_used",
          ["run.blackout"] = "blackouts",
          ["run.completed"] = "completions",
      },
  }
  
  mod.exports.__beta26.RunHistory.safeScalar = function(value)
      local kind = type(value)
      if kind == "string" or kind == "number" or kind == "boolean" then
          return value
      end
      return nil
  end
  
  mod.exports.__beta26.RunHistory.cleanPayload = function(payload)
      local out = {}
      if type(payload) ~= "table" then return out end
      -- Keep the on-disk/event-bus contract intentionally flat.  Rich UI can
      -- join against Pokemon identity / tracker state when needed; persisting
      -- arbitrary engine objects here would make history fragile across builds.
      for key, value in pairs(payload) do
          local clean = mod.exports.__beta26.RunHistory.safeScalar(value)
          if clean ~= nil then out[tostring(key)] = clean end
      end
      return out
  end
  
  mod.exports.__beta26.RunHistory.rebuildDedupe = function(root)
      root.dedupe = {}
      for _, row in ipairs(root.events or {}) do
          if type(row) == "table" and type(row.dedupe) == "string"
              and row.dedupe ~= "" then
              root.dedupe[row.dedupe] = row.seq or true
          end
      end
      return root.dedupe
  end
  
  mod.exports.__beta26.RunHistory.ensure = function(game)
      if deps.saveBlocked() then return nil, "newer_schema" end
      local root = mod.save:get(mod.exports.__beta26.RunHistory.storage_key, {})
      if type(root) ~= "table" then root = {} end
      local changed = false
      if tonumber(root.version) ~= mod.exports.__beta26.RunHistory.storage_version then
          -- v1 is the first format. Future format upgrades should be explicit
          -- rather than interpreting unknown history rows as current data.
          local legacy = mod.save:get("nuzlocke_history", {})
          local baselineCatches = 0
          if type(deps.countTrackerCatches) == "function" then
              local okCount, count = pcall(deps.countTrackerCatches)
              if okCount then
                  baselineCatches = math.max(0, math.floor(tonumber(count) or 0))
              end
          end
          local baselineDeaths = math.max(0, math.floor(tonumber(
              mod.save:get("nuzlocke_losses", 0)) or 0))
          local progressed = baselineCatches > 0 or baselineDeaths > 0
              or (type(legacy) == "table" and #legacy > 0)
          root = {
              version = mod.exports.__beta26.RunHistory.storage_version,
              coverage_start_build = mod.exports.__beta26.build,
              partial = progressed == true,
              baseline_catches = baselineCatches,
              baseline_deaths = baselineDeaths,
          }
          changed = true
      end
      if type(root.events) ~= "table" then root.events = {}; changed = true end
      if type(root.summary) ~= "table" then root.summary = {}; changed = true end
      if type(root.dedupe) ~= "table" then
          mod.exports.__beta26.RunHistory.rebuildDedupe(root)
          changed = true
      end
      if root.coverage_start_build == nil then
          root.coverage_start_build = mod.exports.__beta26.build
          changed = true
      end
      if root.partial == nil then root.partial = false; changed = true end
      root.baseline_catches = math.max(0, math.floor(tonumber(root.baseline_catches) or 0))
      root.baseline_deaths = math.max(0, math.floor(tonumber(root.baseline_deaths) or 0))
      root.next_seq = math.max(1, math.floor(tonumber(root.next_seq) or 1))
      if root.edition == nil then
          root.edition = mod.exports.__beta26.Dev.gameId(game or deps.currentGame() or mod.game)
          changed = true
      end
      if root.generation == nil then
          local live = game or deps.currentGame() or mod.game
          root.generation = tonumber(live and live.generation)
              or (mod.exports.__beta26.runtimeIsGold(live) and 2 or 1)
          changed = true
      end
      if root.run_id == nil then
          local live = game or deps.currentGame() or mod.game
          local player = live and live.save and live.save.player
          local playerId = player and (player.id or player.name) or "unknown"
          root.run_id = tostring(root.edition) .. ":" .. tostring(playerId)
          changed = true
      end
      if changed then mod.save:set(mod.exports.__beta26.RunHistory.storage_key, root) end
      return root
  end
  
  mod.exports.__beta26.RunHistory.append = function(game, kind, payload, opts)
      opts = opts or {}
      if deps.saveBlocked() then return false, "newer_schema" end
      kind = tostring(kind or "")
      if kind == "" then return false, "missing_kind" end
      local root = mod.exports.__beta26.RunHistory.ensure(game)
      if type(root) ~= "table" then return false, "unavailable" end
      local dedupe = tostring(opts.dedupe or "")
      if dedupe ~= "" and root.dedupe[dedupe] ~= nil then
          return false, "duplicate"
      end
      local row = mod.exports.__beta26.RunHistory.cleanPayload(payload)
      row.seq = root.next_seq
      root.next_seq = root.next_seq + 1
      row.kind = kind
      row.edition = mod.exports.__beta26.Dev.gameId(game or deps.currentGame() or mod.game)
      local live = game or deps.currentGame() or mod.game
      row.generation = tonumber(live and live.generation)
          or (mod.exports.__beta26.runtimeIsGold(live) and 2 or 1)
      row.build = mod.exports.__beta26.build
      if dedupe ~= "" then row.dedupe = dedupe end
      root.events[#root.events + 1] = row
      if dedupe ~= "" then root.dedupe[dedupe] = row.seq end
      local summaryKey = mod.exports.__beta26.RunHistory.summary_kinds[kind]
      if summaryKey then
          root.summary[summaryKey] = (tonumber(root.summary[summaryKey]) or 0) + 1
      end
      while #root.events > mod.exports.__beta26.RunHistory.max_events do
          table.remove(root.events, 1)
      end
      if #root.events >= mod.exports.__beta26.RunHistory.max_events then
          mod.exports.__beta26.RunHistory.rebuildDedupe(root)
      end
      mod.save:set(mod.exports.__beta26.RunHistory.storage_key, root)
      if mod.events and type(mod.events.emit) == "function" then
          pcall(mod.events.emit, mod.events, "nuzlocke.run_history", {
              game = live, event = row, run_id = root.run_id,
          })
      end
      return true, row
  end
  
  mod.exports.__beta26.RunHistory.recordCatch = function(game, mon, fields)
      fields = fields or {}
      local species = fields.species or (mon and mon.species)
      local pokemonId = fields.pokemonId or (mon and deps.pokemonIdentity(mon))
      local shiny = fields.shiny
      if shiny == nil and mon then shiny = deps.isShiny(mon) end
      local payload = {
          species = species,
          rawSpecies = fields.rawSpecies,
          pokemonId = pokemonId,
          name = fields.name or (mon and (mon.nickname or mon.name or mon.species)),
          area = fields.area or fields.catchLocation or (mon and mon.catchLocation),
          encounterType = fields.encounterType or (mon and mon.encounterType),
          encounterMethod = fields.encounterMethod or (mon and mon.nuzlockeEncounterMethod),
          encounterTime = fields.encounterTime or (mon and mon.nuzlockeEncounterTime),
          roamerSpecies = fields.roamerSpecies or (mon and mon.nuzlockeRoamerSpecies),
          encounterSource = fields.encounterSource or (mon and mon.nuzlockeEncounterSource),
          encounterProvider = fields.encounterProvider or (mon and mon.nuzlockeEncounterProvider),
          encounterProviderVersion = fields.encounterProviderVersion
              or (mon and mon.nuzlockeEncounterProviderVersion),
          provenance = fields.provenance or (mon and mon.nuzlockeOrigin),
          consumedArea = fields.consumedArea,
          shiny = shiny,
          pcLocked = fields.pcLocked,
          pcLockReason = fields.pcLockReason,
          pcBox = fields.pcBox,
          source = fields.source,
      }
      local dedupe = fields.dedupe
          or (pokemonId ~= nil and ("catch:" .. tostring(pokemonId)) or nil)
      return mod.exports.__beta26.RunHistory.append(
          game, "pokemon.caught", payload, { dedupe = dedupe })
  end
  
  mod.exports.__beta26.RunHistory.recordDeath = function(game, mon, fields)
      fields = fields or {}
      local pokemonId = fields.pokemonId or (mon and deps.pokemonIdentity(mon))
      local payload = {
          species = fields.species or (mon and mon.species),
          rawSpecies = fields.rawSpecies,
          pokemonId = pokemonId,
          name = fields.name or (mon and (mon.nickname or mon.name or mon.species)),
          area = fields.area or fields.deathLocation or (mon and mon.deathLocation),
          catchLocation = fields.catchLocation or (mon and mon.catchLocation),
          encounterType = fields.encounterType or (mon and mon.encounterType),
          cause = fields.cause or fields.deathCause or (mon and (mon.deathCauseText or mon.deathCause)),
          opponentSpecies = fields.opponentSpecies or (mon and mon.deathOpponentSpecies),
          move = fields.move or (mon and mon.deathMove),
          critical = fields.critical ~= nil and fields.critical or (mon and mon.deathCritical),
          statusCondition = fields.statusCondition or (mon and mon.deathStatusCondition),
          source = fields.source,
      }
      local deathSequence = tonumber(fields.deathSequence
          or (mon and mon.nuzlockeDeathSequence))
      if deathSequence ~= nil then
          deathSequence = math.max(1, math.floor(deathSequence))
          payload.deathSequence = deathSequence
      end
      -- A Pokemon can legitimately die again after an F. TOKEN revival, so
      -- dedupe must identify the committed death occurrence rather than the
      -- Pokemon lifetime. The authoritative death bridges increment and
      -- persist nuzlockeDeathSequence before archiving/removing the mon.
      local dedupe = fields.dedupe
          or (pokemonId ~= nil and deathSequence ~= nil
              and ("death:" .. tostring(pokemonId) .. ":"
                  .. tostring(deathSequence)) or nil)
      return mod.exports.__beta26.RunHistory.append(
          game, "pokemon.died", payload, { dedupe = dedupe })
  end
  
  mod.exports.__beta26.RunHistory.recordForgivenessAward = function(game, source, target, fields)
      fields = fields or {}
      local payload = {
          source = tostring(source or fields.source or "unknown"),
          target = tostring(target or fields.target or ""),
          tokens = fields.tokens,
          map = fields.map,
          leader = fields.leader,
      }
      return mod.exports.__beta26.RunHistory.append(game, "forgiveness.awarded",
          payload, { dedupe = fields.dedupe })
  end

  mod.exports.__beta26.RunHistory.recordForgivenessUse = function(game, mode, target, fields)
      fields = fields or {}
      return mod.exports.__beta26.RunHistory.append(game, "forgiveness.used", {
          mode = tostring(mode or "unknown"),
          target = tostring(target or ""),
          tokens = fields.tokens,
          source = fields.source,
      }, { dedupe = fields.dedupe })
  end
  
  mod.exports.__beta26.RunHistory.list = function(game, opts)
      opts = opts or {}
      local root = mod.exports.__beta26.RunHistory.ensure(game)
      if type(root) ~= "table" then return {} end
      local out = {}
      local kind = opts.kind and tostring(opts.kind) or nil
      local after = tonumber(opts.after_seq) or 0
      local limit = math.max(1, math.min(512, math.floor(tonumber(opts.limit) or 512)))
      for _, row in ipairs(root.events or {}) do
          if (not kind or row.kind == kind) and (tonumber(row.seq) or 0) > after then
              local copy = {}
              for key, value in pairs(row) do copy[key] = value end
              out[#out + 1] = copy
              if #out >= limit then break end
          end
      end
      return out
  end
  
  mod.exports.__beta26.RunHistory.report = function(game)
      local root = mod.exports.__beta26.RunHistory.ensure(game)
      if type(root) ~= "table" then return nil end
      local summary = {}
      for key, value in pairs(root.summary or {}) do summary[key] = value end
      return {
          api = mod.exports.__beta26.RunHistory.api,
          storage_version = root.version,
          run_id = root.run_id,
          edition = root.edition,
          generation = root.generation,
          retained_events = #(root.events or {}),
          lifetime = summary,
          partial = root.partial == true,
          coverage_start_build = root.coverage_start_build,
          baseline_catches = root.baseline_catches or 0,
          baseline_deaths = root.baseline_deaths or 0,
          first_seq = root.events and root.events[1] and root.events[1].seq or nil,
          last_seq = root.events and root.events[#root.events]
              and root.events[#root.events].seq or nil,
      }
  end
  
  mod.exports.__beta26.RunHistory.audit = function()
      local root = mod.save:get(mod.exports.__beta26.RunHistory.storage_key, nil)
      if root == nil then return { ok = true, events = 0, initialized = false } end
      local failures = {}
      if type(root) ~= "table" then
          failures[#failures + 1] = "root is " .. type(root)
          return { ok = false, failures = failures, events = 0 }
      end
      if tonumber(root.version) ~= mod.exports.__beta26.RunHistory.storage_version then
          failures[#failures + 1] = "storage version mismatch"
      end
      if type(root.coverage_start_build) ~= "string" or root.coverage_start_build == "" then
          failures[#failures + 1] = "missing coverage start"
      end
      if type(root.partial) ~= "boolean" then
          failures[#failures + 1] = "partial flag is " .. type(root.partial)
      end
      if tonumber(root.baseline_catches) == nil or tonumber(root.baseline_catches) < 0
          or tonumber(root.baseline_deaths) == nil or tonumber(root.baseline_deaths) < 0 then
          failures[#failures + 1] = "invalid baseline counters"
      end
      if type(root.events) ~= "table" then
          failures[#failures + 1] = "events is " .. type(root.events)
          return { ok = false, failures = failures, events = 0 }
      end
      if #root.events > mod.exports.__beta26.RunHistory.max_events then
          failures[#failures + 1] = "event cap exceeded"
      end
      local previous = 0
      local seen = {}
      for index, row in ipairs(root.events) do
          if type(row) ~= "table" then
              failures[#failures + 1] = "row " .. tostring(index) .. " is " .. type(row)
          else
              local seq = tonumber(row.seq)
              if seq == nil or seq <= previous then
                  failures[#failures + 1] = "non-monotonic seq at " .. tostring(index)
              else
                  previous = seq
              end
              if type(row.kind) ~= "string" or row.kind == "" then
                  failures[#failures + 1] = "missing kind at " .. tostring(index)
              end
              for key, value in pairs(row) do
                  local valueType = type(value)
                  if valueType ~= "string" and valueType ~= "number"
                      and valueType ~= "boolean" then
                      failures[#failures + 1] = "non-scalar " .. tostring(key)
                          .. " at " .. tostring(index)
                  end
              end
              if type(row.dedupe) == "string" and row.dedupe ~= "" then
                  if seen[row.dedupe] then
                      failures[#failures + 1] = "duplicate dedupe " .. row.dedupe
                  end
                  seen[row.dedupe] = true
              end
          end
      end
      if type(root.summary) ~= "table" then
          failures[#failures + 1] = "summary is " .. type(root.summary)
      else
          for key, value in pairs(root.summary) do
              if tonumber(value) == nil or tonumber(value) < 0 then
                  failures[#failures + 1] = "invalid summary " .. tostring(key)
              end
          end
      end
      if tonumber(root.next_seq) ~= nil and tonumber(root.next_seq) <= previous then
          failures[#failures + 1] = "next_seq does not advance"
      end
      return { ok = #failures == 0, failures = failures, events = #root.events }
  end
  
  mod.exports.nuzlocke_run_history = {
      version = 1,
      audited_recomp = mod.exports.__beta26.recompCompatAudited,
      list = mod.exports.__beta26.RunHistory.list,
      report = mod.exports.__beta26.RunHistory.report,
      record = function(kind, payload, opts)
          return mod.exports.__beta26.RunHistory.append(
              deps.currentGame() or mod.game, kind, payload, opts)
      end,
      event = "nuzlocke.run_history",
      kinds = {
          "pokemon.caught", "pokemon.died", "badge.earned",
          "forgiveness.awarded", "forgiveness.used", "run.blackout",
          "run.completed", "note",
      },
  }
  
  -- Initialize before ordinary run events whenever possible. Gold/Silver NEW
  -- GAME can replace the mod.save backing after game.ready, so save.created is
  -- also a required boundary. This is metadata initialization only; it does
  -- not synthesize historical rows for an existing run.
  mod.events:on("game.ready", function(payload)
      pcall(mod.exports.__beta26.RunHistory.ensure,
          type(payload) == "table" and payload.game or deps.currentGame() or mod.game)
  end)
  mod.events:on("save.loaded", function(payload)
      pcall(mod.exports.__beta26.RunHistory.ensure,
          type(payload) == "table" and payload.game or deps.currentGame() or mod.game)
  end)
  mod.events:on("save.created", function(payload)
      pcall(mod.exports.__beta26.RunHistory.ensure,
          type(payload) == "table" and payload.game or deps.currentGame() or mod.game)
  end)
  return mod.exports.__beta26.RunHistory
end
