return function(mod, deps)
  deps = deps or {}
  mod.exports.__beta26.Dev.assertions = function(game)
      game = game or deps.currentGame() or mod.game
      local warnings = {}
      local function warn(code, detail)
          warnings[#warnings + 1] = { code = code, detail = detail }
      end
  
      local schema = tonumber(mod.save:get(deps.SAVE_SCHEMA_KEY, deps.CURRENT_SAVE_SCHEMA))
      if schema ~= deps.CURRENT_SAVE_SCHEMA then
          warn("save_schema", "expected " .. tostring(deps.CURRENT_SAVE_SCHEMA)
              .. ", got " .. tostring(schema))
      end
      if deps.saveSchemaTooNew() then warn("save_schema_too_new", "newer save schema loaded") end
      if deps.saveMigrationError() then warn("save_migration", tostring(deps.saveMigrationError())) end
  
      -- 2.5.73: the chronology journal is intentionally flat/bounded.  Keep
      -- those invariants executable so future Graveyard/Almanac/Confessional
      -- work cannot accidentally persist engine objects or corrupt ordering.
      local runHistoryAudit = mod.exports.__beta26.RunHistory
          and mod.exports.__beta26.RunHistory.audit
      if type(runHistoryAudit) == "function" then
          local okHistory, historyReport = pcall(runHistoryAudit)
          if not okHistory or type(historyReport) ~= "table"
              or historyReport.ok ~= true then
              local detail = not okHistory and tostring(historyReport)
                  or table.concat(historyReport and historyReport.failures or {}, ", ")
              warn("run_history_integrity", detail ~= "" and detail or "audit failed")
          end
      end
  
      -- 2.5.57: the trainer-reward subsystem carries executable source-level
      -- contracts for every gameplay-state mutator plus explicit OFF-state
      -- exceptions. Surface any drift in DEV assertions as well as failing
      -- module installation, so the regression is visible in diagnostics.
      local rewardModule = mod.exports.__beta26.TrainerRewards
      if type(rewardModule) == "table"
          and type(rewardModule.activeGuardAudit) == "function" then
          local okGuard, guardReport = pcall(rewardModule.activeGuardAudit,
              mod:read("trainer_rewards.lua"))
          if not okGuard or type(guardReport) ~= "table" or guardReport.ok ~= true then
              local detail = not okGuard and tostring(guardReport)
                  or table.concat(guardReport and guardReport.failures or {}, ", ")
              warn("active_guard_contract", detail ~= "" and detail or "audit failed")
          end
      end
  
      -- 2.5.58: mirror the module-load cross-table invariant gate in DEV
      -- diagnostics. Static drift should already fail fast at startup, but the
      -- report makes the exact relationship visible during development too.
      local invariantAudit = mod.exports.__beta26.crossTableInvariantAudit
      if type(invariantAudit) == "function" then
          local okInvariant, invariantReport = pcall(invariantAudit)
          if not okInvariant or type(invariantReport) ~= "table"
              or invariantReport.ok ~= true then
              local detail = not okInvariant and tostring(invariantReport)
                  or table.concat(invariantReport and invariantReport.failures or {}, ", ")
              warn("cross_table_invariant", detail ~= "" and detail or "audit failed")
          end
      end
  
      -- 2.5.59: repeat the dead-fallback source lint in DEV diagnostics so
      -- unreachable fallback dialogue is visible in reports as well as being
      -- blocked by the module-load release gate.
      local deadFallbackAudit = mod.exports.__beta26.deadFallbackAudit
      if type(deadFallbackAudit) == "function" then
          local okFallback, fallbackReport = pcall(deadFallbackAudit,
              mod:read("main.lua"))
          if not okFallback or type(fallbackReport) ~= "table"
              or fallbackReport.ok ~= true then
              local detail = not okFallback and tostring(fallbackReport)
                  or table.concat(fallbackReport and fallbackReport.failures or {}, ", ")
              warn("dead_fallback_lint", detail ~= "" and detail or "audit failed")
          end
      end
  
      -- 2.5.60: catalog golden/snapshot backstop. This semantic snapshot
      -- covers every catalog row across the three presentation tiers and both
      -- supported regions without depending on source whitespace or comments.
      local catalogSnapshotAudit = mod.exports.__beta26.catalogSnapshotAudit
      if type(catalogSnapshotAudit) == "function" then
          local okSnapshot, snapshotReport = pcall(catalogSnapshotAudit)
          if not okSnapshot or type(snapshotReport) ~= "table"
              or snapshotReport.ok ~= true then
              local detail = not okSnapshot and tostring(snapshotReport)
                  or table.concat(snapshotReport and snapshotReport.failures or {}, ", ")
              warn("catalog_snapshot", detail ~= "" and detail or "audit failed")
          end
      end
  
      local safeStopWrites = mod.exports.__beta26.safeStopWriteReport()
      if tonumber(safeStopWrites.total or 0) > 0 then
          warn("safe_stop_write_attempt",
              "count=" .. tostring(safeStopWrites.total)
                  .. " first=" .. tostring(safeStopWrites.first_key or "?")
                  .. " last=" .. tostring(safeStopWrites.last_key or "?"))
      end
  
      local save = game and game.save
      local party = save and save.party or {}
      local limit = math.max(1, math.min(6, math.floor(tonumber(
          mod.save:get("party_size_limit", deps.defaultRuleValue("party_size_limit"))) or 6)))
      if mod.save:get("nuzlocke_enabled", true) == true and #party > limit then
          warn("party_over_cap", tostring(#party) .. "/" .. tostring(limit))
      end
      for i, mon in ipairs(party) do
          if type(mon) == "table" and mon.nuzlockeDead == true
              and (tonumber(mon.hp) or 0) > 0 then
              warn("dead_hp", "slot " .. tostring(i) .. " hp=" .. tostring(mon.hp))
          end
          if type(mon) == "table" and mon.nuzlockePcLocked == true then
              warn("pc_lock_in_party", "slot " .. tostring(i) .. " "
                  .. tostring(mon.species or "UNKNOWN"))
          end
          if type(mon) == "table" and mon.nuzlockeOrigin == "EDITED" then
              warn("external_mon", "slot " .. tostring(i) .. " "
                  .. tostring(mon.species or "UNKNOWN"))
          end
      end
  
      -- 2.4.59: passive integrity checks for encounter/shiny state. These are
      -- read-only and deliberately avoid treating legal rule changes (for
      -- example lowering a spent Shiny allowance mid-run) as corruption.
      if mod.save:get("encounter_limit", deps.defaultRuleValue("encounter_limit")) == true then
          local caught = mod.save:get("caught_areas", {})
          local states = mod.save:get("encounter_states", {})
          if type(caught) ~= "table" then
              warn("caught_areas_type", "expected table, got " .. type(caught))
              caught = {}
          end
          if type(states) ~= "table" then
              warn("encounter_states_type", "expected table, got " .. type(states))
              states = {}
          end
          for key, state in pairs(states) do
              if type(state) == "table" and state.status == "CAUGHT"
                  and state.consumedArea ~= false and caught[key] == nil then
                  warn("encounter_state_area_mismatch",
                      tostring(key) .. " state=CAUGHT caught_areas=missing")
              elseif type(state) == "table" and state.status == "FAILED"
                  and caught[key] ~= nil then
                  warn("encounter_state_area_conflict",
                      tostring(key) .. " state=FAILED caught_areas=present")
              end
          end
      end
  
      local rawShinyMode = mod.save:get("shiny_clause", nil)
      if rawShinyMode ~= nil then
          if type(rawShinyMode) == "boolean" then
              warn("shiny_clause_mode_boolean", tostring(rawShinyMode))
          else
              local numericMode = tonumber(rawShinyMode)
              if numericMode == nil or numericMode < 0 or numericMode > 4
                  or math.floor(numericMode) ~= numericMode then
                  warn("shiny_clause_mode_invalid", tostring(rawShinyMode))
              end
          end
      end
      local rawBallLimit = mod.save:get("encounter_ball_limit", nil)
      if rawBallLimit ~= nil then
          if type(rawBallLimit) == "boolean" then
              warn("encounter_ball_limit_boolean", tostring(rawBallLimit))
          else
              local numericBallLimit = tonumber(rawBallLimit)
              if numericBallLimit == nil or numericBallLimit < 0
                  or numericBallLimit > 5
                  or math.floor(numericBallLimit) ~= numericBallLimit then
                  warn("encounter_ball_limit_invalid", tostring(rawBallLimit))
              end
          end
      end
      -- 2.5.2 diagnostic-only hardening. randomizer_info_policy has always
      -- had a numeric setter, so there is no legitimate historical boolean
      -- encoding to migrate. If an imported/hand-edited/corrupt save contains
      -- one, report it rather than silently inventing semantics for true/false.
      local rawInfoPolicy = mod.save:get("randomizer_info_policy", nil)
      if rawInfoPolicy ~= nil then
          if type(rawInfoPolicy) == "boolean" then
              warn("randomizer_info_policy_boolean", tostring(rawInfoPolicy))
          else
              local numericInfoPolicy = tonumber(rawInfoPolicy)
              if numericInfoPolicy == nil or numericInfoPolicy < 0
                  or numericInfoPolicy > 1
                  or math.floor(numericInfoPolicy) ~= numericInfoPolicy then
                  warn("randomizer_info_policy_invalid",
                      tostring(rawInfoPolicy))
              end
          end
      end
      local rawShinyUsed = mod.save:get("shiny_clause_used", nil)
      if rawShinyUsed ~= nil then
          local numericUsed = tonumber(rawShinyUsed)
          if numericUsed == nil or numericUsed < 0
              or math.floor(numericUsed) ~= numericUsed then
              warn("shiny_clause_used_invalid", tostring(rawShinyUsed))
          end
      end
  
      local okDefaults, badDefault = pcall(mod.exports.__beta26.auditNewRuleDefaults)
      if not okDefaults then
          warn("default_audit_error", tostring(badDefault))
      elseif badDefault ~= true then
          warn("default_audit", tostring(badDefault))
      end
      return warnings
  end
  return mod.exports.__beta26.Dev.assertions
end
