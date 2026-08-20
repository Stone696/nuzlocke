return function(mod, deps)
  deps = deps or {}
  local function safeRead(path)
    local ok, content = pcall(mod.read, mod, path)
    if ok and type(content) == "string" and #content > 0 then
      return content, nil
    end
    return nil, tostring(content)
  end

  mod.exports.__beta26.releaseSafetyAudit = function()
    local report = {
      ok = true, build = mod.exports.__beta26.build, checks = {},
      failures = {}, warnings = {}, check_count = 0, pass_count = 0,
    }
    local function add(id, ok, detail, fatal)
      report.check_count = report.check_count + 1
      if ok == true then report.pass_count = report.pass_count + 1 end
      report.checks[#report.checks + 1] = {
        id = tostring(id), ok = ok == true, detail = tostring(detail or ""),
        fatal = fatal ~= false,
      }
      if ok ~= true then
        local msg = tostring(id) .. ":" .. tostring(detail or "failed")
        if fatal == false then
          report.warnings[#report.warnings + 1] = msg
        else
          report.ok = false
          report.failures[#report.failures + 1] = msg
        end
      end
    end
    local function run(id, fn, arg)
      if type(fn) ~= "function" then add(id, false, "audit unavailable"); return nil end
      local ok, result
      if arg ~= nil then ok, result = pcall(fn, arg) else ok, result = pcall(fn) end
      if not ok then add(id, false, result); return nil end
      local passed = result == true or (type(result) == "table" and result.ok == true)
      local detail = result
      if type(result) == "table" then
        detail = table.concat(result.failures or result.errors or {}, "; ")
        if detail == "" then detail = "ok" end
      end
      add(id, passed, detail)
      return result
    end

    run("rule_defaults", mod.exports.__beta26.auditNewRuleDefaults)
    run("rule_registry", mod.exports.__beta26.ruleRegistry and mod.exports.__beta26.ruleRegistry.audit)
    run("save_schema_descriptor", mod.exports.__beta26.saveSchemaDescriptor and mod.exports.__beta26.saveSchemaDescriptor.audit)
    run("save_migration_integrity", mod.exports.__beta26.saveUpgrade and mod.exports.__beta26.saveUpgrade.audit)

    local mainSource, mainErr = safeRead("main.lua")
    if mainSource then
      run("dead_fallback_lint", mod.exports.__beta26.deadFallbackAudit, mainSource)
    else
      add("dead_fallback_lint", false, "source introspection unavailable: " .. tostring(mainErr), false)
    end
    run("catalog_snapshot", mod.exports.__beta26.catalogSnapshotAudit)
    run("cross_table_invariants", mod.exports.__beta26.crossTableInvariantAudit)

    local rewardsSource, rewardsErr = safeRead("trainer_rewards.lua")
    if rewardsSource then
      run("active_guard_contract",
        mod.exports.__beta26.TrainerRewards and mod.exports.__beta26.TrainerRewards.activeGuardAudit,
        rewardsSource)
    else
      add("active_guard_contract", false, "source introspection unavailable: " .. tostring(rewardsErr), false)
    end

    local provenance = mod.exports.__beta26.buildProvenance()
    add("build_provenance", type(provenance) == "table"
      and provenance.version == mod.exports.__beta26.build
      and provenance.parent_version == mod.exports.__beta26.parentVersion
      and type(provenance.parent_sha256) == "string"
      and #provenance.parent_sha256 == 64,
      type(provenance) == "table"
        and ("parent=" .. tostring(provenance.parent_version)
          .. " sha=" .. tostring(provenance.parent_sha256):sub(1, 12))
        or "build provenance unavailable")

    local capabilities = deps.compatCapabilities or {}
    local advertised, versioned = #capabilities, 0
    for _, capability in ipairs(capabilities) do
      if mod.exports.__beta26.compatCapabilityVersions[capability] ~= nil then
        versioned = versioned + 1
      end
    end
    add("compat_capability_versions", versioned == advertised,
      string.format("versioned=%d advertised=%d", versioned, advertised))

    local engineCompat = mod.exports.__beta26.compat and mod.exports.__beta26.compat.Engine
    local activeProfile = engineCompat and engineCompat.active_profile
    local activeRow = engineCompat and engineCompat.profiles
      and engineCompat.profiles[activeProfile] or nil
    add("compat_active_engine_profile", type(activeProfile) == "string"
      and activeProfile ~= "" and type(activeRow) == "table",
      "active=" .. tostring(activeProfile))

    -- Engine/runtime source introspection is diagnostic only. A supported
    -- launcher may legitimately deny mod:read() for package files; that must
    -- never make the gameplay mod unbootable.
    for _, path in ipairs(deps.packagePaths or {}) do
      local content, err = safeRead(path)
      add("package_read:" .. path, content ~= nil,
        content and ("bytes=" .. tostring(#content))
          or ("unavailable: " .. tostring(err)), false)
    end
    return report
  end

  mod.exports.__beta26.assertReleaseSafety = function()
    local report = mod.exports.__beta26.releaseSafetyAudit()
    if not report.ok then
      return false, report
    end
    return true, report
  end

  local ok, report = pcall(mod.exports.__beta26.releaseSafetyAudit)
  if ok then
    mod.exports.__beta26.releaseSafetyBootReport = report
  else
    mod.exports.__beta26.releaseSafetyBootReport = {
      ok = false, failures = { "release_safety_runner:" .. tostring(report) },
      warnings = {}, checks = {},
    }
  end
  return mod.exports.__beta26.releaseSafetyBootReport
end
