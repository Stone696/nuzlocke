-- Gen 3 MOD SUPPORT: live, read-only reporting of installed companion mods
-- and their advertised public APIs. Detection, API readiness and combined
-- in-game compatibility are independent facts; none grants hook ownership.
return function()
    local M={api=1}

    local CONTRACTS={
        nationalDex={
            id="national_dex_gen3",minVersion=2,
            required={"listSpecies","listForms","idOfSlot","baseDexOf"},
        },
        battleSprites={
            id="g9-battle-sprites-gen3",
            required={"isActive","hasSprite"},
        },
        modernSpawns={
            id="modern_spawns",minVersion=2,
            required={"isActive","tableFor","drawFor"},
        },
        hdSprites={
            id="gen3-hd-sprites",
            required={"isActive","enabled","tag"},
        },
        -- Untamed's randomiser/shiny integration is a hook contract,
        -- not a public mod.exports capability that can be inspected here.
        untamed={id="untamed_advanced"},
    }

    local function locate(mod,id)
        if type(mod)~="table" or type(mod.find)~="function" then
            return "UNKNOWN",nil
        end
        local ok,other=pcall(mod.find,mod,id)
        if not ok then return "UNKNOWN",nil end
        if type(other)=="table" and other~=mod then
            return "DETECTED",other
        end
        return "NOT FOUND",nil
    end

    local function inspectProvider(mod,spec)
        local detection,other=locate(mod,spec.id)
        local item={
            detection=detection,api="UNKNOWN",
            active="UNKNOWN",tested="NOT VERIFIED",
        }
        if detection=="NOT FOUND" then item.api="N/A";return item end
        if detection~="DETECTED" then return item end
        if not spec.required then
            item.api="NO PUBLIC API"
            item.hook="UNVERIFIED"
            return item
        end

        item.api="UNAVAILABLE"
        local exports=other.exports
        if type(exports)~="table" then return item end
        if spec.minVersion and
            (tonumber(exports.apiVersion) or 0)<spec.minVersion then
            return item
        end
        for _,name in ipairs(spec.required) do
            if type(exports[name])~="function" then return item end
        end
        item.api="READY"
        -- Pure status query only. Never call art loaders, spawn draws,
        -- hook registration or anything that may alter the running game.
        if type(exports.isActive)=="function" then
            local ok,active=pcall(exports.isActive)
            if ok and type(active)=="boolean" then
                item.active=active and "ACTIVE" or "INACTIVE"
            end
        end
        return item
    end

    function M.inspect(mod,shinyRate,randomizer,s)
        local integrations={}
        for key,spec in pairs(CONTRACTS) do
            integrations[key]=inspectProvider(mod,spec)
        end

        local provider
        if shinyRate and type(shinyRate.externalProvider)=="function" then
            local ok,value=pcall(shinyRate.externalProvider,mod)
            if ok then provider=value end
        end
        local function enabled(key)
            if not randomizer or type(randomizer.get)~="function" then
                return false
            end
            local ok,value=pcall(randomizer.get,s,key)
            return ok and value==true
        end
        return {
            -- Preserve existing callers of the original diagnostics API.
            untamed=integrations.untamed.detection,
            shiny=provider and "EXTERNAL" or "NUZLOCKE",
            shinyOwner=provider,
            otherRandomizer=(function()
                local detection=locate(mod,"pokemon_randomizer")
                return detection
            end)(),
            wildRandom=enabled("random_encounter_tables"),
            trainerRandom=enabled("random_trainers"),
            integrations=integrations,
        }
    end

    return M
end
