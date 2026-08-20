-- Nuzlocke 2.5.89
-- DEV REPORT / NZR6 diagnostic presentation extraction.
-- Behavior-preserving child of the 2.5.88 inline implementation.
return function(mod, deps)
  deps = deps or {}
  local getCurrentGame = assert(deps.currentGame, "dev_report requires currentGame getter")
  local SAVE_SCHEMA_KEY = assert(deps.SAVE_SCHEMA_KEY, "dev_report requires SAVE_SCHEMA_KEY")
  local CURRENT_SAVE_SCHEMA = assert(deps.CURRENT_SAVE_SCHEMA, "dev_report requires CURRENT_SAVE_SCHEMA")
  local function liveGame() return getCurrentGame() end
  ---------------------------------------------------------------------
  -- 2.5.67 / NZR6 DEV REPORT CODE
  --
  -- A short, deterministic, human-shareable representation of the fixed
  -- diagnostic summary. It does NOT pretend arbitrary strings/breadcrumb text
  -- are reversible in seed-sized space; instead the final fingerprint binds the
  -- code to the exact full textual report. Thus the fixed summary decodes
  -- losslessly, while any free-form detail change also changes the code.
  ---------------------------------------------------------------------
  do -- compiler-budget scope: NZR6 codec helpers
  mod.exports.__beta26.Dev.reportCodeAlphabet =
      "0123456789ABCDEFGHJKMNPQRSTVWXYZ"

  local function reportCodeClamp(value, bits)
      local maximum = (2 ^ bits) - 1
      value = math.floor(tonumber(value) or 0)
      if value < 0 then return 0 end
      if value > maximum then return maximum end
      return value
  end

  local function reportCodeHash(text, bits)
      local modulus = 2 ^ bits
      local hash = 2166136261 % modulus
      for i = 1, #tostring(text or "") do
          hash = (hash * 16777619 + string.byte(text, i)) % modulus
      end
      return math.floor(hash)
  end

  local function reportCodePushBits(bitsOut, value, count)
      value = reportCodeClamp(value, count)
      for bit = count - 1, 0, -1 do
          local power = 2 ^ bit
          bitsOut[#bitsOut + 1] =
              math.floor(value / power) % 2 == 1 and "1" or "0"
      end
  end

  local function reportCodeReadBits(bits, position, count)
      local value = 0
      for i = 0, count - 1 do
          value = value * 2
          if bits:sub(position + i, position + i) == "1" then
              value = value + 1
          end
      end
      return value, position + count
  end

  local function reportCodeBase32(bits)
      while #bits % 5 ~= 0 do bits = bits .. "0" end
      local alphabet = mod.exports.__beta26.Dev.reportCodeAlphabet
      local out = {}
      for i = 1, #bits, 5 do
          local value = 0
          for j = 0, 4 do
              value = value * 2
              if bits:sub(i + j, i + j) == "1" then value = value + 1 end
          end
          out[#out + 1] = alphabet:sub(value + 1, value + 1)
      end
      return table.concat(out)
  end

  local function reportCodeBitsFromBase32(payload)
      local alphabet = mod.exports.__beta26.Dev.reportCodeAlphabet
      payload = tostring(payload or ""):upper():gsub("[^0-9A-Z]", "")
      -- Friendly transcription aliases.
      payload = payload:gsub("O", "0"):gsub("[IL]", "1")
      local bits = {}
      for i = 1, #payload do
          local ch = payload:sub(i, i)
          local at = alphabet:find(ch, 1, true)
          if not at then return nil, "invalid_character:" .. ch end
          local value = at - 1
          for bit = 4, 0, -1 do
              bits[#bits + 1] =
                  math.floor(value / (2 ^ bit)) % 2 == 1 and "1" or "0"
          end
      end
      return table.concat(bits)
  end

  local REPORT_CODE_RESULT_IDS = {
      "dev_mode", "save_schema", "default_rule_audit",
      "encounter_slot_conflict", "shiny_clause",
      "tracker_death_projection", "species_facts",
      "mechanics_capability", "mom_heal_gate",
      "__generation__", "cap_messages_setting",
      "encounter_ball_limit_setting", "encounter_indicator_setting", "hook_health",
      "lifecycle_callbacks", "safe_stop_writes",
      "rule_effectiveness", "randomizer_integrity",
  }

  local REPORT_CODE_RANDOMIZER_STATUS = {
      INACTIVE=0, PASS=1, WARN=2, ERROR=3, DELEGATED=4,
      PAUSED=5, UNAVAILABLE=6, FALLBACK=7,
  }
  local REPORT_CODE_RANDOMIZER_LABEL = {
      [0]="INACTIVE", [1]="PASS", [2]="WARN", [3]="ERROR",
      [4]="DELEGATED", [5]="PAUSED", [6]="UNAVAILABLE", [7]="FALLBACK",
  }

  mod.exports.__beta26.Dev.reportCode = function(game, report, fullText)
      game = game or liveGame() or mod.game
      report = type(report) == "table"
          and report or mod.exports.__beta26.Dev.selfTest(game)

      local resultById = {}
      for _, row in ipairs(report.results or {}) do
          resultById[tostring(row.id or "")] = row.ok == true
      end
      local generationId = (report.generation == 2
          or report.game == "gold" or report.game == "silver"
          or report.game == "crystal") and "gold_rule_surface" or "rby_runtime"

      local bits = {}
      local major, minor, patch = tostring(report.build or "")
          :match("^(%d+)%.(%d+)%.(%d+)")
      major = tonumber(major) or 0
      minor = tonumber(minor) or 0
      patch = tonumber(patch) or 0
      reportCodePushBits(bits, major, 8)
      reportCodePushBits(bits, minor, 8)
      reportCodePushBits(bits, patch, 8)
      local editionId = ({ red=0, blue=1, yellow=2, gold=3,
          silver=4, crystal=5 })[tostring(report.game or ""):lower()] or 7
      reportCodePushBits(bits, editionId, 3)
      reportCodePushBits(bits,
          tonumber(mod.save:get(SAVE_SCHEMA_KEY, CURRENT_SAVE_SCHEMA))
              or CURRENT_SAVE_SCHEMA, 4)

      -- 2.5.53 / NZR5: the five health summaries below are already encoded
      -- later as authoritative counters/status. Do not encode a second copy;
      -- the decoder reconstructs those result flags from that evidence. This
      -- also avoids adding another top-level result-id table/local.
      for _, id in ipairs(REPORT_CODE_RESULT_IDS) do
          if id ~= "hook_health" and id ~= "lifecycle_callbacks"
              and id ~= "safe_stop_writes" and id ~= "rule_effectiveness"
              and id ~= "randomizer_integrity" then
              local ok = id == "__generation__"
                  and resultById[generationId] == true or resultById[id] == true
              reportCodePushBits(bits, ok and 1 or 0, 1)
          end
      end

      reportCodePushBits(bits, 1, 2) -- fixed cap-notice policy
      reportCodePushBits(bits,
          mod.save:get("encounter_spend_indicator", true) == true and 1 or 0, 1)
      local effectiveness = report.rule_effectiveness or {}
      reportCodePushBits(bits,
          effectiveness.nuzlocke_enabled == true and 1 or 0, 1)

      local hc = (report.hook_health or {}).counts or {}
      reportCodePushBits(bits, hc.healthy, 4)
      reportCodePushBits(bits, hc.chained, 4)
      reportCodePushBits(bits, hc.pending, 4)
      reportCodePushBits(bits, hc.missing, 4)

      local lc = report.lifecycle or {}
      reportCodePushBits(bits, lc.duplicate_callbacks, 4)
      reportCodePushBits(bits,
          reportCodeClamp((tonumber(lc.battle_delta) or 0) + 15, 5), 5)

      local sw = report.safe_stop_writes or {}
      reportCodePushBits(bits, sw.total, 6)
      reportCodePushBits(bits, sw.active == true and 1 or 0, 1)

      local rc = effectiveness.counts or {}
      reportCodePushBits(bits, rc.total, 7)
      reportCodePushBits(bits, rc.delegated, 6)
      reportCodePushBits(bits, rc.changed, 6)
      reportCodePushBits(bits, rc.errors, 4)

      local ri = report.randomizer_integrity or {}
      reportCodePushBits(bits,
          REPORT_CODE_RANDOMIZER_STATUS[tostring(ri.status or "INACTIVE")]
              or 0, 3)
      reportCodePushBits(bits, ri.active == true and 1 or 0, 1)
      reportCodePushBits(bits, ri.delegated == true and 1 or 0, 1)
      reportCodePushBits(bits, ri.scanned, 10)
      reportCodePushBits(bits, ri.violation_count, 8)
      reportCodePushBits(bits, ri.truncated == true and 1 or 0, 1)

      local assertions = report.assertions or {}
      reportCodePushBits(bits, #assertions, 5)
      local assertionText = {}
      for _, row in ipairs(assertions) do
          assertionText[#assertionText + 1] =
              tostring(row.code or "") .. "=" .. tostring(row.detail or "")
      end
      table.sort(assertionText)
      reportCodePushBits(bits,
          reportCodeHash(table.concat(assertionText, "|"), 12), 12)

      -- Bind arbitrary owners, rule rows, hook detail, breadcrumbs, etc. to the
      -- compact code without claiming those free-form strings are reversible.
      -- fullText is the report body before the report_code line is inserted;
      -- excluding that generated line avoids a circular fingerprint.
      reportCodePushBits(bits,
          reportCodeHash(tostring(fullText or ""), 20), 20)

      local payload = reportCodeBase32(table.concat(bits))
      local groups = {}
      for i = 1, #payload, 4 do
          groups[#groups + 1] = payload:sub(i, i + 3)
      end
      return "NZR6-" .. table.concat(groups, "-")
  end

  mod.exports.__beta26.Dev.decodeReportCode = function(code)
      local raw = tostring(code or ""):upper():gsub("%s+", "")
      local format = tonumber(raw:match("^NZR(%d+)%-"))
      if format ~= 4 and format ~= 5 and format ~= 6 then
          return nil, "unsupported_report_code"
      end
      local bits, err = reportCodeBitsFromBase32(raw:sub(6))
      if not bits then return nil, err end
      local pos = 1
      local out = { format=format, raw=raw }
      out.major, pos = reportCodeReadBits(bits, pos, 8)
      out.minor, pos = reportCodeReadBits(bits, pos, 8)
      out.patch, pos = reportCodeReadBits(bits, pos, 8)
      if format >= 6 then
          local edition
          edition, pos = reportCodeReadBits(bits, pos, 3)
          out.game = ({ [0]="red", [1]="blue", [2]="yellow", [3]="gold",
              [4]="silver", [5]="crystal", [7]="unknown" })[edition] or "unknown"
          out.generation = (edition == 3 or edition == 4 or edition == 5) and 2 or 1
      else
          local gold
          gold, pos = reportCodeReadBits(bits, pos, 1)
          out.game = gold == 1 and "gold" or "rby"
          out.generation = gold == 1 and 2 or 1
      end
      out.save_schema, pos = reportCodeReadBits(bits, pos, 4)
      out.results = {}
      for _, id in ipairs(REPORT_CODE_RESULT_IDS) do
          local derived = id == "hook_health" or id == "lifecycle_callbacks"
              or id == "safe_stop_writes" or id == "rule_effectiveness"
              or id == "randomizer_integrity"
          if format == 4 or not derived then
              local value
              value, pos = reportCodeReadBits(bits, pos, 1)
              out.results[id] = value == 1
          end
      end
      out.cap_messages, pos = reportCodeReadBits(bits, pos, 2)
      local value
      value, pos = reportCodeReadBits(bits, pos, 1)
      out.encounter_indicator = value == 1
      value, pos = reportCodeReadBits(bits, pos, 1)
      out.nuzlocke_enabled = value == 1

      out.hooks = {}
      out.hooks.healthy, pos = reportCodeReadBits(bits, pos, 4)
      out.hooks.chained, pos = reportCodeReadBits(bits, pos, 4)
      out.hooks.pending, pos = reportCodeReadBits(bits, pos, 4)
      out.hooks.missing, pos = reportCodeReadBits(bits, pos, 4)

      out.lifecycle = {}
      out.lifecycle.duplicate_callbacks, pos =
          reportCodeReadBits(bits, pos, 4)
      value, pos = reportCodeReadBits(bits, pos, 5)
      out.lifecycle.battle_delta = value - 15

      out.safe_stop = {}
      out.safe_stop.attempts, pos = reportCodeReadBits(bits, pos, 6)
      value, pos = reportCodeReadBits(bits, pos, 1)
      out.safe_stop.active = value == 1

      out.rules = {}
      out.rules.total, pos = reportCodeReadBits(bits, pos, 7)
      out.rules.delegated, pos = reportCodeReadBits(bits, pos, 6)
      out.rules.changed, pos = reportCodeReadBits(bits, pos, 6)
      out.rules.errors, pos = reportCodeReadBits(bits, pos, 4)

      out.randomizer = {}
      value, pos = reportCodeReadBits(bits, pos, 3)
      out.randomizer.status = REPORT_CODE_RANDOMIZER_LABEL[value] or "INACTIVE"
      value, pos = reportCodeReadBits(bits, pos, 1)
      out.randomizer.active = value == 1
      value, pos = reportCodeReadBits(bits, pos, 1)
      out.randomizer.delegated = value == 1
      out.randomizer.scanned, pos = reportCodeReadBits(bits, pos, 10)
      out.randomizer.violations, pos = reportCodeReadBits(bits, pos, 8)
      value, pos = reportCodeReadBits(bits, pos, 1)
      out.randomizer.truncated = value == 1

      out.assertion_count, pos = reportCodeReadBits(bits, pos, 5)
      out.assertion_fingerprint, pos = reportCodeReadBits(bits, pos, 12)
      out.full_report_fingerprint, pos = reportCodeReadBits(bits, pos, 20)
      out.build = tostring(out.major) .. "." .. tostring(out.minor)
          .. "." .. tostring(out.patch)

      -- NZR5 stores each health fact once. Rebuild the five player-facing
      -- result flags from the authoritative compact evidence. NZR4 remains
      -- decodable and retains its contradiction detector for old reports.
      local derived = {
          hook_health = tonumber(out.hooks.missing or 0) == 0,
          lifecycle_callbacks =
              tonumber(out.lifecycle.duplicate_callbacks or 0) == 0,
          safe_stop_writes = tonumber(out.safe_stop.attempts or 0) == 0,
          rule_effectiveness = tonumber(out.rules.errors or 0) == 0,
          randomizer_integrity = out.randomizer.status ~= "WARN"
              and out.randomizer.status ~= "ERROR",
      }
      out.consistency = {}
      out.consistent = true
      for id, ok in pairs(derived) do
          if format == 5 then
              out.results[id] = ok
              out.consistency[id] = true
          else
              local consistent = out.results[id] == ok
              out.consistency[id] = consistent
              if not consistent then out.consistent = false end
          end
      end
      return out
  end

  -- 2.5.61: compact deterministic code for unexpected runtime failures that
  -- are caught before they can escape a mod-owned screen. This fingerprint is
  -- intentionally short; Dev Mode still records the full traceback.
  mod.exports.__beta26.Dev.errorCode = function(label, err)
      local fingerprint = reportCodeHash(
          tostring(mod.exports.__beta26.build) .. "|"
              .. tostring(label or "runtime") .. "|" .. tostring(err or ""), 20)
      return string.format("NZERR-%s-%05X",
          tostring(mod.exports.__beta26.build), fingerprint)
  end
  -- selfTestText lives outside this compiler-budget scope, so expose
  -- the deterministic fingerprint operation rather than accidentally resolving
  -- the scoped helper name as a nonexistent global.
  mod.exports.__beta26.Dev.reportFingerprint = function(text, bits)
      return reportCodeHash(text, bits)
  end
  end -- NZR6 codec helper scope

  mod.exports.__beta26.Dev.selfTestText = function(game)
      local report = mod.exports.__beta26.Dev.selfTest(game)
      local lines = {
          "NUZLOCKE DEV SELF-TEST",
          "build=" .. tostring(report.build),
          "game=" .. tostring(report.game),
          "generation=" .. tostring(report.generation or
              (mod.exports.__beta26.runtimeIsGold(game) and 2 or 1)),
          "environment=" .. tostring(report.environment),
          "save_schema=" .. tostring(mod.save:get(
              SAVE_SCHEMA_KEY, CURRENT_SAVE_SCHEMA)),
          "compat_api=" .. tostring(mod.exports.__beta26.compatibilityApi),
          "audited_recomp="
              .. tostring(mod.exports.__beta26.recompCompatAudited),
      }
      local provenance = report.build_provenance
          or mod.exports.__beta26.buildProvenance()
      if type(provenance) == "table" then
          lines[#lines + 1] = "parent_build="
              .. tostring(provenance.parent_version or "?")
          lines[#lines + 1] = "parent_sha256="
              .. tostring(provenance.parent_sha256 or "?")
      end

      local storageContext =
          mod.exports.__beta26.Dev.storageContext(game)
      if type(storageContext) == "table" then
          lines[#lines + 1] = "storage_game="
              .. tostring(storageContext.gameVersion or "?")
          lines[#lines + 1] = "storage_playthrough="
              .. tostring(storageContext.playthroughId or "?")
      else
          lines[#lines + 1] = "storage_context=unavailable"
      end

      lines[#lines + 1] = ""
      lines[#lines + 1] = "[RESULTS]"
      local pass, warn = 0, 0
      for _, row in ipairs(report.results or {}) do
          if row.ok then pass = pass + 1 else warn = warn + 1 end
          lines[#lines + 1] = string.format(
              "%s %-26s [%s] %s",
              row.status, row.id, row.kind, row.detail)
      end
      lines[#lines + 1] = string.format(
          "SUMMARY pass=%d warn=%d", pass, warn)

      lines[#lines + 1] = ""
      lines[#lines + 1] = "[ASSERTIONS]"
      if #(report.assertions or {}) == 0 then
          lines[#lines + 1] = "PASS none"
      else
          for _, row in ipairs(report.assertions or {}) do
              lines[#lines + 1] = "WARN " .. tostring(row.code)
                  .. " " .. tostring(row.detail or "")
          end
      end

      lines[#lines + 1] = ""
      lines[#lines + 1] = "[CAPABILITIES]"
      for _, row in ipairs(report.capabilities or {}) do
          lines[#lines + 1] = row
      end

      lines[#lines + 1] = ""
      lines[#lines + 1] = "[RULE EFFECTIVENESS]"
      local ruleEffectiveness = report.rule_effectiveness or {}
      local ruleCounts = ruleEffectiveness.counts or {}
      lines[#lines + 1] = string.format(
          "master=%s schema_supported=%s rules=%d delegated=%d changed=%d errors=%d",
          tostring(ruleEffectiveness.nuzlocke_enabled == true),
          tostring(ruleEffectiveness.schema_supported == true),
          tonumber(ruleCounts.total or 0),
          tonumber(ruleCounts.delegated or 0),
          tonumber(ruleCounts.changed or 0),
          tonumber(ruleCounts.errors or 0))
      for _, row in ipairs(ruleEffectiveness.rows or {}) do
          lines[#lines + 1] = string.format(
              "%-28s configured=%s(%s) effective=%s owner=%s relationship=%s%s",
              tostring(row.key or "?"),
              tostring(row.configured),
              tostring(row.configured_source or "?"),
              tostring(row.effective),
              tostring(row.owner or "nuzlocke"),
              tostring(row.relationship or "owned"),
              row.error and (" error=" .. tostring(row.error)) or "")
      end

      lines[#lines + 1] = ""
      lines[#lines + 1] = "[RANDOMIZER INTEGRITY]"
      local randomizerIntegrity = report.randomizer_integrity or {}
      lines[#lines + 1] = string.format(
          "status=%s active=%s delegated=%s scanned=%d violations=%d truncated=%s",
          tostring(randomizerIntegrity.status or "?"),
          tostring(randomizerIntegrity.active == true),
          tostring(randomizerIntegrity.delegated == true),
          tonumber(randomizerIntegrity.scanned or 0),
          tonumber(randomizerIntegrity.violation_count or 0),
          tostring(randomizerIntegrity.truncated == true))
      if randomizerIntegrity.owner then
          lines[#lines + 1] = "owner=" .. tostring(randomizerIntegrity.owner)
              .. " relationship="
              .. tostring(randomizerIntegrity.relationship or "delegated")
      end
      if randomizerIntegrity.detail then
          lines[#lines + 1] = "detail=" .. tostring(randomizerIntegrity.detail)
      end
      for _, row in ipairs(randomizerIntegrity.violations or {}) do
          lines[#lines + 1] = string.format(
              "WARN %s species=%s reason=%s",
              tostring(row.path or "?"),
              tostring(row.species or "?"),
              tostring(row.reason or "?"))
      end

      lines[#lines + 1] = ""
      lines[#lines + 1] = "[HOOK HEALTH]"
      local hookHealth = report.hook_health or {}
      local hookCounts = hookHealth.counts or {}
      lines[#lines + 1] = string.format(
          "SUMMARY healthy=%d chained=%d pending=%d missing=%d",
          tonumber(hookCounts.healthy or 0),
          tonumber(hookCounts.chained or 0),
          tonumber(hookCounts.pending or 0),
          tonumber(hookCounts.missing or 0))
      for _, row in ipairs(hookHealth.rows or {}) do
          lines[#lines + 1] = string.format(
              "%-8s %-26s %s.%s %s",
              tostring(row.state or "?"),
              tostring(row.id or "?"),
              tostring(row.path or "?"),
              tostring(row.method or "?"),
              tostring(row.detail or ""))
      end

      lines[#lines + 1] = ""
      lines[#lines + 1] = "[LIFECYCLE]"
      local lifecycle = report.lifecycle or {}
      lines[#lines + 1] = string.format(
          "duplicate_callbacks=%d battle_delta=%d",
          tonumber(lifecycle.duplicate_callbacks or 0),
          tonumber(lifecycle.battle_delta or 0))
      for _, key in ipairs({
          "game.ready", "save.loaded", "battle.started", "battle.ended",
          "pokemon.caught", "pokemon.evolved",
      }) do
          lines[#lines + 1] = string.format(
              "%-18s count=%d duplicates=%d",
              key,
              tonumber((lifecycle.counts or {})[key]) or 0,
              tonumber((lifecycle.duplicate_by_event or {})[key]) or 0)
      end

      lines[#lines + 1] = ""
      lines[#lines + 1] = "[SAFE STOP WRITES]"
      local safeStopWrites = report.safe_stop_writes or {}
      lines[#lines + 1] = string.format(
          "active=%s attempts=%d first=%s last=%s",
          tostring(safeStopWrites.active == true),
          tonumber(safeStopWrites.total or 0),
          tostring(safeStopWrites.first_key or "none"),
          tostring(safeStopWrites.last_key or "none"))
      local safeKeys = {}
      for key in pairs(safeStopWrites.by_key or {}) do
          safeKeys[#safeKeys + 1] = tostring(key)
      end
      table.sort(safeKeys)
      for _, key in ipairs(safeKeys) do
          lines[#lines + 1] = string.format(
              "%s=%d", key,
              tonumber((safeStopWrites.by_key or {})[key]) or 0)
      end

      lines[#lines + 1] = ""
      lines[#lines + 1] = "[RECENT BREADCRUMBS]"
      local crumbs = mod.exports.__beta26.Dev.breadcrumbs or {}
      local first = 1
      if #crumbs == 0 then
          lines[#lines + 1] = "(none)"
      else
          for i = first, #crumbs do
              local row = crumbs[i]
              lines[#lines + 1] = string.format(
                  "#%s %s/%s %s",
                  tostring(row.seq or "?"),
                  tostring(row.game or "?"),
                  tostring(row.kind or "?"),
                  tostring(row.detail or ""))
          end
      end

      lines[#lines + 1] = ""
      lines[#lines + 1] =
          "NOTE: SELF-TEST PASS is diagnostic evidence, not a full RUNTIME PASS."

      local body = table.concat(lines, "\n")
      local reportCode = mod.exports.__beta26.Dev.reportCode(game, report, body)
      table.insert(lines, 2, "report_code=" .. tostring(reportCode))
      report.report_code = reportCode
      report.full_report_fingerprint =
          mod.exports.__beta26.Dev.reportFingerprint(body, 20)
      return table.concat(lines, "\n"), report
  end

  mod.exports.__beta26.Dev.exportSelfTest = function(game)
      if not mod.exports.__beta26.Dev.enabled() then
          return false, { error = "DEV MODE OFF" }
      end

      game = game or liveGame() or mod.game
      local text, report = mod.exports.__beta26.Dev.selfTestText(game)
      local storageKey = "dev/self_test_latest"
      local storage = mod and mod.storage
      local writeAttempted, writeReturned = false, false
      local verified, readBackMatches = false, false
      local bytesRead, storageCode, storageMessage
      local historyKey, historyWritten, historyCount
      local storageContext =
          mod.exports.__beta26.Dev.storageContext(game)

      if type(storage) == "table"
          and type(storage.writeBytes) == "function" then
          writeAttempted = true
          local ok, result, code, message = pcall(
              storage.writeBytes, storage, storageKey, text)
          if ok then
              writeReturned = result == true
              storageCode = code
              storageMessage = message
          else
              storageCode = "storage_error"
              storageMessage = tostring(result)
          end
      else
          storageCode = "storage_unavailable"
          storageMessage = "Gen1Recomp mod.storage.writeBytes is unavailable."
      end

      if writeReturned and type(storage.readBytes) == "function" then
          local ok, result, code, message = pcall(
              storage.readBytes, storage, storageKey)
          if ok and type(result) == "string" then
              bytesRead = #result
              readBackMatches = result == text
          else
              storageCode = code or storageCode
              storageMessage = message or (not ok and tostring(result))
                  or storageMessage
          end
      end

      verified = writeReturned and readBackMatches == true

      -- Keep latest for convenience plus bounded sequenced history.
      if verified and type(storage.list) == "function"
          and type(storage.delete) == "function" then
          local okList, keys = pcall(storage.list, storage, "dev")
          if okList and type(keys) == "table" then
              local numbered = {}
              local maxIndex = 0
              for _, key in ipairs(keys) do
                  local n = tostring(key):match("^dev/self_test_history_(%d+)$")
                  if n then
                      n = tonumber(n)
                      if n then
                          maxIndex = math.max(maxIndex, n)
                          numbered[#numbered + 1] = {
                              key = tostring(key), index = n,
                          }
                      end
                  end
              end

              local nextIndex = maxIndex + 1
              historyKey = string.format(
                  "dev/self_test_history_%06d", nextIndex)
              local okHistory, result = pcall(
                  storage.writeBytes, storage, historyKey, text)
              historyWritten = okHistory and result == true

              if historyWritten then
                  numbered[#numbered + 1] = {
                      key = historyKey, index = nextIndex,
                  }
                  table.sort(numbered, function(a, b)
                      return a.index < b.index
                  end)
                  while #numbered > 16 do
                      local oldest = table.remove(numbered, 1)
                      pcall(storage.delete, storage, oldest.key)
                  end
                  historyCount = #numbered
              else
                  historyCount = #numbered
              end
          end
      end

      mod.exports.__beta26.Dev.lastExportText = text
      mod.exports.__beta26.Dev.lastExportReport = report
      mod.exports.__beta26.Dev.lastExport = {
          clipboard = false,
          filename = nil,
          saveDirectory = nil,
          absolutePath = nil,
          info = nil,
          writeAttempted = writeAttempted,
          writeReturned = writeReturned,
          written = verified,
          verified = verified,
          readSucceeded = bytesRead ~= nil,
          readBackMatches = readBackMatches,
          storageKey = storageKey,
          historyKey = historyKey,
          historyWritten = historyWritten == true,
          historyCount = historyCount,
          storageContext = storageContext,
          storageCode = storageCode,
          storageMessage = storageMessage,
          bytesRead = bytesRead,
          expectedBytes = #text,
          breadcrumbCount = #(mod.exports.__beta26.Dev.breadcrumbs or {}),
          primary = verified and "storage" or "log",
      }

      pcall(function()
          mod.log:info(
              "NUZ DEV SELF-TEST EXPORT BEGIN\n%s\nNUZ DEV SELF-TEST EXPORT END",
              text)
      end)
      mod.exports.__beta26.Dev.push("self_test",
          string.format(
              "storageKey=%s history=%s verified=%s bytes=%s/%s code=%s",
              storageKey, tostring(historyKey or "none"),
              tostring(verified), tostring(bytesRead or "?"),
              tostring(#text), tostring(storageCode or "ok")), game)

      return true, {
          clipboard = false,
          filename = nil,
          saveDirectory = nil,
          absolutePath = nil,
          info = nil,
          writeAttempted = writeAttempted,
          writeReturned = writeReturned,
          written = verified,
          verified = verified,
          readSucceeded = bytesRead ~= nil,
          readBackMatches = readBackMatches,
          storageKey = storageKey,
          historyKey = historyKey,
          historyWritten = historyWritten == true,
          historyCount = historyCount,
          storageContext = storageContext,
          storageCode = storageCode,
          storageMessage = storageMessage,
          bytesRead = bytesRead,
          expectedBytes = #text,
          breadcrumbCount = #(mod.exports.__beta26.Dev.breadcrumbs or {}),
          text = text,
          report = report,
      }
  end

  -- 2.5.61: Dev Tools RUN must never be able to take down the game. Turn any
  -- unexpected exporter exception into a structured result with a reportable
  -- NZERR code; the full traceback is retained in Dev diagnostics when enabled.
  do
      local rawExportSelfTest = mod.exports.__beta26.Dev.exportSelfTest
      mod.exports.__beta26.Dev.exportSelfTest = function(game)
          local ok, result, info = xpcall(function()
              return rawExportSelfTest(game)
          end, debug and debug.traceback or tostring)
          if ok then return result, info end
          local code = mod.exports.__beta26.Dev.errorCode("dev_run", result)
          pcall(mod.exports.__beta26.Dev.recordError,
              "dev_run", result, game or liveGame() or mod.game)
          return false, {
              error = "DEV SELF-TEST ERROR",
              message = tostring(result),
              report_code = code,
          }
      end
  end

  mod.exports.__beta26.Dev.reloadStoredSelfTest = function(game, requestedKey)
      game = game or liveGame() or mod.game
      local storageKey = type(requestedKey) == "string"
          and requestedKey ~= "" and requestedKey or "dev/self_test_latest"
      local storage = mod and mod.storage
      if type(storage) ~= "table"
          or type(storage.readBytes) ~= "function" then
          return false, {
              error = "STORAGE UNAVAILABLE",
              storageKey = storageKey,
          }
      end

      local ok, text, code, message = pcall(
          storage.readBytes, storage, storageKey)
      if not ok or type(text) ~= "string" then
          return false, {
              error = tostring((not ok and text) or code or "NOT FOUND"),
              message = tostring(message or ""),
              storageKey = storageKey,
          }
      end

      mod.exports.__beta26.Dev.lastExportText = text
      local previous = mod.exports.__beta26.Dev.lastExport or {}
      previous.storageKey = storageKey
      previous.storageContext =
          mod.exports.__beta26.Dev.storageContext(game)
      previous.bytesRead = #text
      previous.readSucceeded = true
      previous.readBackMatches = nil
      mod.exports.__beta26.Dev.lastExport = previous
      mod.exports.__beta26.Dev.push("self_test_reload",
          "storageKey=" .. storageKey .. " bytes=" .. tostring(#text), game)
      return true, {
          text = text,
          storageKey = storageKey,
          storageContext = previous.storageContext,
          bytesRead = #text,
          readSucceeded = true,
          readBackMatches = nil,
      }
  end

  mod.exports.nuzlocke_dev = {
      api = mod.exports.__beta26.diagnosticsApi,
      build = mod.exports.__beta26.build,
      enabled = mod.exports.__beta26.Dev.enabled,
      breadcrumb = mod.exports.__beta26.Dev.push,
      breadcrumbs = function()
          local out = {}
          for i, row in ipairs(mod.exports.__beta26.Dev.breadcrumbs or {}) do
              out[i] = {
                  seq = row.seq, kind = row.kind, detail = row.detail,
                  build = row.build, game = row.game,
              }
          end
          return out
      end,
      assertions = mod.exports.__beta26.Dev.assertions,
      snapshot = mod.exports.__beta26.Dev.snapshot,
      hook_health = mod.exports.__beta26.Dev.hookHealth,
      rule_effectiveness = mod.exports.__beta26.Dev.ruleEffectiveness,
      randomizer_integrity = mod.exports.__beta26.Dev.randomizerIntegrity,
      lifecycle = mod.exports.__beta26.Dev.lifecycleReport,
      reset_lifecycle = mod.exports.__beta26.Dev.resetLifecycle,
      safe_stop_writes = mod.exports.__beta26.safeStopWriteReport,
      reset_safe_stop_writes = mod.exports.__beta26.resetSafeStopWrites,
      build_provenance = mod.exports.__beta26.buildProvenance,
      rule_registry = mod.exports.__beta26.ruleRegistry.describe,
      save_schema_descriptor = mod.exports.__beta26.saveSchemaDescriptor.describe,
      compatibility_contracts = function()
          local versions = {}
          for key, value in pairs(mod.exports.__beta26.compatCapabilityVersions or {}) do
              versions[key] = value
          end
          return {
              api = mod.exports.__beta26.compatibilityApi,
              capability_versions = versions,
          }
      end,
      contracts = {
          self_test = 1,
          hook_health = 1,
          rule_registry = 1,
          save_schema_descriptor = 1,
          build_provenance = 1,
          compatibility_contracts = 1,
      },
      log_snapshot = mod.exports.__beta26.Dev.logSnapshot,
      record_error = mod.exports.__beta26.Dev.recordError,
      pguard = mod.exports.__beta26.Dev.pguard,
      self_test = mod.exports.__beta26.Dev.selfTest,
      self_test_text = mod.exports.__beta26.Dev.selfTestText,
      report_code = mod.exports.__beta26.Dev.reportCode,
      decode_report_code = mod.exports.__beta26.Dev.decodeReportCode,
      error_code = mod.exports.__beta26.Dev.errorCode,
      export_self_test = mod.exports.__beta26.Dev.exportSelfTest,
      reload_self_test = mod.exports.__beta26.Dev.reloadStoredSelfTest,
      stored_self_tests = function(game)
          game = game or liveGame() or mod.game
          local storage = mod and mod.storage
          if type(storage) ~= "table" or type(storage.list) ~= "function" then
              return {}
          end
          local ok, keys = pcall(storage.list, storage, "dev")
          if not ok or type(keys) ~= "table" then return {} end
          local out = {}
          for _, key in ipairs(keys) do
              key = tostring(key)
              if key == "dev/self_test_latest"
                  or key:match("^dev/self_test_history_%d+$") then
                  out[#out + 1] = key
              end
          end
          table.sort(out)
          return out
      end,
      last_export_text = function()
          return mod.exports.__beta26.Dev.lastExportText
      end,
  }

  mod.events:on("game.ready", function(ev)
      mod.exports.__beta26.Dev.countLifecycle("game.ready", ev)
      local game = type(ev) == "table" and ev.game or ev or liveGame() or mod.game
      if mod.exports.__beta26.Dev.enabled() then
          mod.exports.__beta26.Dev.push("game.ready", "runtime ready", game)
          pcall(mod.exports.__beta26.Dev.logSnapshot, "game.ready", game)
      end
  end)
  mod.events:on("save.loaded", function(ev)
      mod.exports.__beta26.Dev.countLifecycle("save.loaded", ev)
      local game = type(ev) == "table" and ev.game or liveGame() or mod.game
      if mod.exports.__beta26.Dev.enabled() then
          mod.exports.__beta26.Dev.push("save.loaded", "save attached", game)
          pcall(mod.exports.__beta26.Dev.logSnapshot, "save.loaded", game)
      end
  end)
  mod.events:on("battle.started", function(ev)
      mod.exports.__beta26.Dev.countLifecycle("battle.started", ev)
      if mod.exports.__beta26.Dev.enabled() then
          local kind = type(ev) == "table" and (ev.kind or ev.battleType) or nil
          mod.exports.__beta26.Dev.push("battle.started", tostring(kind or "unknown"),
              type(ev) == "table" and ev.game or liveGame() or mod.game)
      end
  end)
  mod.events:on("battle.ended", function(ev)
      mod.exports.__beta26.Dev.countLifecycle("battle.ended", ev)
      if mod.exports.__beta26.Dev.enabled() then
          mod.exports.__beta26.Dev.push("battle.ended", "battle complete",
              type(ev) == "table" and ev.game or liveGame() or mod.game)
      end
  end)
  mod.events:on("pokemon.caught", function(ev)
      mod.exports.__beta26.Dev.countLifecycle("pokemon.caught", ev)
      if mod.exports.__beta26.Dev.enabled() then
          local mon = type(ev) == "table" and (ev.mon or ev.pokemon) or nil
          mod.exports.__beta26.Dev.push("pokemon.caught",
              tostring(mon and mon.species or "unknown"), liveGame() or mod.game)
      end
  end)
  mod.events:on("pokemon.evolved", function(ev)
      mod.exports.__beta26.Dev.countLifecycle("pokemon.evolved", ev)
      if mod.exports.__beta26.Dev.enabled() then
          local target = type(ev) == "table" and (ev.toSpecies or ev.species) or nil
          mod.exports.__beta26.Dev.push("pokemon.evolved", tostring(target or "unknown"),
              liveGame() or mod.game)
      end
  end)

  return mod.exports.__beta26.Dev
end
