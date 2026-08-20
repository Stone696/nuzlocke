return function(mod, deps)
  deps = deps or {}
  local API = {
    version = 1,
    key = "stadium_prize",
    display = "STADIUM PRIZE",
  }
  local function normalizeOrigin(origin)
    local raw = tostring(origin or ""):lower()
    if raw == "stadium1" or raw == "stadium_1" or raw == "stadium 1" then return "stadium_1" end
    if raw == "stadium2" or raw == "stadium_2" or raw == "stadium 2" then return "stadium_2" end
    return nil
  end
  function API.mark(mon, origin)
    if type(mon) ~= "table" then return false, "missing_pokemon" end
    if type(deps.canWrite) == "function" and deps.canWrite() ~= true then
      return false, "persistence_blocked"
    end
    deps.setPokemonOrigin(mon, "STADIUM_PRIZE")
    mon.nuzlockeEncounterSource = "STADIUM_PRIZE"
    mon.nuzlockeAcquisitionSource = "stadium_prize"
    local normalized = normalizeOrigin(origin)
    if normalized then mon.nuzlockeAcquisitionOrigin = normalized end
    return true, {
      source = "stadium_prize",
      origin = normalized,
      display = API.display,
    }
  end
  function API.describe(mon)
    if type(mon) ~= "table" then return nil end
    if mon.nuzlockeAcquisitionSource == "stadium_prize"
        or mon.nuzlockeOrigin == "STADIUM_PRIZE" then
      return {
        source = "stadium_prize",
        origin = normalizeOrigin(mon.nuzlockeAcquisitionOrigin),
        display = API.display,
      }
    end
    return nil
  end
  mod.exports.nuzlocke_acquisition_provenance = API
  mod.exports.__beta26.StadiumPrize = API
  return API
end
