return function(mod, deps)
  deps=deps or {}
  -- 2.5.78: a shadow store gives schema migrators a read/write surface with
  -- mod.save semantics while keeping the real save untouched.  Every touched
  -- key retains both its pre-migration state and intended post-migration state
  -- so the same write set can power dry-run diagnostics and atomic-ish commit.
  -- Structural equality for serialized save values. Lua table equality is
  -- identity-based, but migration dry-runs need value equality so a touched
  -- table that is written back unchanged does not produce a false diff.
  local function shadowValuesEqual(a, b, seen)
      if rawequal(a, b) then return true end
      if type(a) ~= type(b) then return false end
      if type(a) ~= "table" then return a == b end

      seen = seen or {}
      local byLeft = seen[a]
      if byLeft ~= nil and byLeft[b] then return true end
      if byLeft == nil then
          byLeft = {}
          seen[a] = byLeft
      end
      byLeft[b] = true

      for key, value in pairs(a) do
          if not shadowValuesEqual(value, b[key], seen) then return false end
      end
      for key in pairs(b) do
          if a[key] == nil and b[key] ~= nil then return false end
      end
      return true
  end

  mod.exports.__beta26.saveUpgrade.newShadowStore = function(baseStore)
      baseStore = baseStore or mod.save
      local entries, order = {}, {}
      local shadow = {}
      function shadow:get(key, fallback)
          local row = entries[key]
          if row ~= nil then
              if row.after_present then return row.after_value end
              return fallback
          end
          return deps.copy(baseStore:get(key, fallback))
      end
      function shadow:set(key, value)
          local row = entries[key]
          if row == nil then
              local sentinel = {}
              local before = baseStore:get(key, sentinel)
              row = {
                  key = key,
                  before_present = before ~= sentinel,
                  before_value = before ~= sentinel and deps.copy(before) or nil,
              }
              entries[key] = row
              order[#order + 1] = key
          end
          row.after_present = value ~= nil
          row.after_value = deps.copy(value)
          return true
      end
      function shadow:changes()
          -- Commit ordinary migration writes first, then the human-readable
          -- checkpoint, and the schema marker LAST.  That ordering is the
          -- transaction boundary: seeing target schema on the next load means
          -- every earlier write in this transition reached mod.save.
          table.sort(order, function(a, b)
              local ar = a == deps.SAVE_SCHEMA_KEY and 3
                  or (a == deps.SAVE_MIGRATION_KEY and 2 or 1)
              local br = b == deps.SAVE_SCHEMA_KEY and 3
                  or (b == deps.SAVE_MIGRATION_KEY and 2 or 1)
              if ar ~= br then return ar < br end
              return tostring(a) < tostring(b)
          end)
          local out = {}
          for _, key in ipairs(order) do
              local row = entries[key]
              local changed = row.before_present ~= row.after_present
                  or (row.before_present and row.after_present
                      and not shadowValuesEqual(row.before_value, row.after_value))
              if changed then
                  out[#out + 1] = {
                      key = row.key,
                      before_present = row.before_present == true,
                      before_value = deps.copy(row.before_value),
                      after_present = row.after_present == true,
                      after_value = deps.copy(row.after_value),
                  }
              end
          end
          return out
      end
      return shadow
  end
  return mod.exports.__beta26.saveUpgrade.newShadowStore
end
