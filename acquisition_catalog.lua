-- Nuzlocke 2.5.90
-- Version-aware vanilla gift/trade acquisition source catalog.
-- Behavior-preserving extraction from the 2.5.89 inline implementation.
return function(mod, deps)
  deps = deps or {}
  local getGameVersion = assert(deps.getGameVersion, "acquisition_catalog requires getGameVersion")
  ---------------------------------------------------------------------
  -- GIFT POKEMON TABLE  (version-tagged)
  -- area = where the gift is received; takes up that slot.
  -- version: nil=all R/B/Y, RB=Red/Blue, YLW=Yellow, RY=Red/Yellow, BY=Blue/Yellow.
  -- This is a Gen-I source catalog; Gen 2 never inherits nil-tagged Gen 1 entries.
  ---------------------------------------------------------------------
  local GIFT_LOCATIONS = {
      { species = "MAGIKARP",   area = "ROUTE_4",         version = nil   },
      { species = "HITMONCHAN", area = "SAFFRON_CITY",    version = nil   },
      { species = "HITMONLEE",  area = "SAFFRON_CITY",    version = nil   },
      { species = "LAPRAS",     area = "SILPH_CO",        version = nil   },
      { species = "EEVEE",      area = "CELADON_CITY",    version = nil   },
      { species = "OMANYTE",    area = "CINNABAR_ISLAND", version = nil   },
      { species = "KABUTO",     area = "CINNABAR_ISLAND", version = nil   },
      { species = "AERODACTYL", area = "CINNABAR_ISLAND", version = nil   },
      { species = "SCYTHER",    area = "CELADON_CITY",    version = "RY"  },
      { species = "PORYGON",    area = "CELADON_CITY",    version = nil   },
      { species = "DRATINI",    area = "CELADON_CITY",    version = "RB"  },
      { species = "PINSIR",     area = "CELADON_CITY",    version = "BY"  },
      { species = "BULBASAUR",  area = "CERULEAN_CITY",   version = "YLW" },
      { species = "CHARMANDER", area = "ROUTE_24",        version = "YLW" },
      { species = "SQUIRTLE",   area = "VERMILION_CITY",  version = "YLW" },
  }

  mod.exports.__beta26.buildGiftLookup = function()
      local ver = getGameVersion()
      local lookup = {}
      if ver ~= "RED" and ver ~= "BLUE" and ver ~= "YELLOW" then
          return lookup
      end
      for _, g in ipairs(GIFT_LOCATIONS) do
          if g.version == nil
              or (g.version == "RB"  and (ver == "RED" or ver == "BLUE"))
              or (g.version == "YLW" and ver == "YELLOW")
              or (g.version == "RY" and (ver == "RED" or ver == "YELLOW"))
              or (g.version == "BY" and (ver == "BLUE" or ver == "YELLOW")) then
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
      -- English Red/Blue (pret/pokered data/events/trades.asm).
      { gives = "NIDORINA",  wants = "NIDORINO",  area = "ROUTE_11",        version = "RB"  },
      { gives = "MR_MIME",   wants = "ABRA",      area = "ROUTE_2",         version = "RB"  },
      { gives = "SEEL",      wants = "PONYTA",    area = "CINNABAR_ISLAND", version = "RB"  },
      { gives = "FARFETCHD", wants = "SPEAROW",   area = "VERMILION_CITY",  version = "RB"  },
      { gives = "LICKITUNG", wants = "SLOWBRO",   area = "ROUTE_18",        version = "RB"  },
      { gives = "JYNX",      wants = "POLIWHIRL", area = "CERULEAN_CITY",   version = "RB"  },
      { gives = "ELECTRODE", wants = "RAICHU",    area = "CINNABAR_ISLAND", version = "RB"  },
      { gives = "TANGELA",   wants = "VENONAT",   area = "CINNABAR_ISLAND", version = "RB"  },
      { gives = "NIDORAN_F", wants = "NIDORAN_M", area = "ROUTE_5",         version = "RB"  },
      -- Yellow (pret/pokeyellow data/events/trades.asm).
      { gives = "DUGTRIO",   wants = "LICKITUNG", area = "ROUTE_11",        version = "YLW" },
      { gives = "MR_MIME",   wants = "CLEFAIRY",  area = "ROUTE_2",         version = "YLW" },
      { gives = "MUK",       wants = "KANGASKHAN",area = "CINNABAR_ISLAND", version = "YLW" },
      { gives = "PARASECT",  wants = "TANGELA",   area = "ROUTE_18",        version = "YLW" },
      { gives = "RHYDON",    wants = "GOLDUCK",   area = "CINNABAR_ISLAND", version = "YLW" },
      { gives = "DEWGONG",   wants = "GROWLITHE", area = "CINNABAR_ISLAND", version = "YLW" },
      { gives = "MACHOKE",   wants = "CUBONE",    area = "ROUTE_5",         version = "YLW" },
  }

  mod.exports.__beta26.buildTradeLookup = function()
      local ver = getGameVersion()
      local lookup = {}
      if ver ~= "RED" and ver ~= "BLUE" and ver ~= "YELLOW" then
          return lookup
      end
      for _, t in ipairs(TRADE_DATA) do
          if t.version == nil
              or (t.version == "RB"  and (ver == "RED" or ver == "BLUE"))
              or (t.version == "YLW" and ver == "YELLOW") then
              lookup[t.gives] = t.area
          end
      end
      return lookup
  end

  -- When a source-less compatibility event has no usable location, infer a
  -- vanilla acquisition kind only for species whose provenance is actually
  -- deterministic in that version. Native transaction wrappers carry explicit
  -- provenance, so ambiguous prize/wild or trade/wild species do not need a
  -- guess here.
  mod.exports.__beta26.deterministicSourceFallback = function(kind, species)
      local ver = getGameVersion()
      local key = tostring(species or ""):upper()
      if kind == "gift" then
          local common = {
              HITMONCHAN = true, HITMONLEE = true, LAPRAS = true,
              EEVEE = true, OMANYTE = true, KABUTO = true,
              AERODACTYL = true, PORYGON = true,
          }
          if common[key] then return true end
          return ver == "YELLOW"
              and (key == "BULBASAUR" or key == "CHARMANDER"
                  or key == "SQUIRTLE")
      end
      if kind == "trade" then
          if ver == "YELLOW" then return key == "MR_MIME" end
          if ver == "RED" or ver == "BLUE" then
              return key == "JYNX" or key == "FARFETCHD"
                  or key == "MR_MIME" or key == "LICKITUNG"
          end
      end
      return false
  end

  return {
    buildGiftLookup = mod.exports.__beta26.buildGiftLookup,
    buildTradeLookup = mod.exports.__beta26.buildTradeLookup,
    deterministicSourceFallback = mod.exports.__beta26.deterministicSourceFallback,
  }
end
