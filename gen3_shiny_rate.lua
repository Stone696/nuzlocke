-- Gen 3 increased shiny odds. Handles only newly generated wild/static
-- battle Pokémon, never redraw-time shiny.roll calls.
-- Native Gen 3 odds = 1/8192. No mutation of IVs/EVs/personality.
return function()
    local M = { api = 1 }
    local LABELS = { "NATIVE", "1/4096", "1/1024", "1/512",
        "1/100", "1/10", "ALWAYS" }
    local DENOMINATORS = { [1] = 4096, [2] = 1024, [3] = 512,
        [4] = 100, [5] = 10, [6] = 1 }

    -- Only a verified live mod handle can claim generation ownership. A stale
    -- registry/disabled mod is not authoritative.
    function M.externalProvider(mod)
        if not mod or type(mod.find) ~= "function" then return nil end
        for _, id in ipairs({
            "SHINY_POKEMON", "shiny_pokemon", "gen1recomp_shiny_pokemon",
        }) do
            local ok, other = pcall(mod.find, mod, id)
            if ok and type(other) == "table" and other ~= mod
                and tostring(other.id or id):upper()
                    ~= tostring(mod.id or "NUZLOCKE"):upper() then
                local exports = other.exports
                local compat = type(exports) == "table"
                    and (exports.shiny_pokemon or exports.shiny_compat)
                if (type(compat) == "table"
                    and type(compat.isShiny) == "function")
                    or (type(exports) == "table"
                        and (exports.ownsShiny == true
                            or exports.shinyOwner == true
                            or type(exports.shinyOwner) == "function")) then
                    return tostring(other.name or other.id or id)
                end
            end
        end
        return nil
    end

    function M.modeLabel(mode)
        return LABELS[(tonumber(mode) or 0) + 1] or "NATIVE"
    end

    -- This is CONDITIONAL on the native roll being false. The total odds,
    -- not a second independent whole roll, become exactly 1/denominator.
    function M.extraProbability(mode)
        local denominator = DENOMINATORS[tonumber(mode)]
        if not denominator or denominator >= 8192 then return 0 end
        if denominator == 1 then return 1 end
        return (8192 - denominator) / (denominator * 8191)
    end

    function M.isEligibleBattle(ev)
        if type(ev) ~= "table" or ev.kind ~= "wild" then return false end
        local st = ev.battle
        if type(st) ~= "table" or type(st.enemy) ~= "table"
            or type(st.enemy.mon) ~= "table" then return false end
        -- No starters, gifts, Eggs, trainers, tutorials, frontier/link, or
        -- persistent roamers (whose identity would change between battles).
        if st.link or st.oldManTutorial or st.pokedude
            or st.firstBattle or st.roamer or st.enemy.mon.roamer
            or (st.foe and st.foe.roamer) then return false end
        if type(st.kinds) == "table" and
            (st.kinds.tutorial or st.kinds.link or st.kinds.recordedLink)
            then return false end
        return true
    end

    function M.apply(mod, ev, mode, randomUnit, isNaturalShiny)
        local m = tonumber(mode) or 0
        if m < 1 or m > 6 then return false, "native" end
        if M.externalProvider(mod) then return false, "external" end
        if not M.isEligibleBattle(ev) then return false, "not_eligible" end
        local mon = ev.battle.enemy.mon
        if mon.nuzlockeShinyRateChecked then
            return mon.nuzlockeShinyRateBoosted == true, "already_checked"
        end

        local natural = false
        if type(isNaturalShiny) == "function" then
            local ok, result = pcall(isNaturalShiny, mon)
            if not ok then return false, "shiny_identity_unavailable" end
            natural = result == true
        elseif mon.isShiny ~= nil then
            natural = mon.isShiny == true
        else
            return false, "shiny_identity_unavailable"
        end
        mon.nuzlockeShinyRateChecked = true
        if natural then return false, "naturally_shiny" end

        local chance = M.extraProbability(m)
        local rng = type(randomUnit) == "function" and randomUnit
            or math.random
        local boosted = chance >= 1 or rng() < chance
        if boosted then
            -- clone_mon in Gen 3 Catching.storeCaught copies all host fields.
            -- Store on the individual once; later icon/summary/battle calls
            -- see this fixed identity rather than drawing new random odds.
            mon.isShiny = true
            mon.nuzlockeShinyRateBoosted = true
        end
        return boosted, boosted and "boosted" or "ordinary"
    end

    return M
end
