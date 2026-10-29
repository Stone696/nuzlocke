-- Gen 3 Advanced Rules: Pokemon Stats.
-- Gen 3 has six IVs (0..31) and six EVs (0..255; total <=510).
-- The Gen 1/2 "Stat EXP" save keys are retained for UI compatibility,
-- but Gen 3 presets use legal per-stat EVs, never Gen 2 Stat EXP.
return function()
    local M={api=1,schema=1}
    local KEYS={"hp","atk","def","spe","spa","spd"}
    -- Even spreads avoid hidden priorities and never exceed 510 total.
    local EV_PRESETS={0,16,32,48,64,85}
    local DEFINITIONS={
        {key="player_start_stat_exp",label="Player Starting EVs",
            kind="preset",default=0},
        {key="wild_start_stat_exp",label="Wild Starting EVs",
            kind="preset",default=0},
        {key="trainer_start_stat_exp",label="Trainer Starting EVs",
            kind="preset",default=0},
        {key="no_player_stat_exp_gain",label="No EV Gain",
            kind="toggle",default=false},
        {key="perfect_player_ivs",label="Perfect Player IVs",
            kind="toggle",default=false},
        {key="perfect_wild_ivs",label="Perfect Wild IVs",
            kind="toggle",default=false},
        {key="perfect_trainer_ivs",label="Perfect Trainer IVs",
            kind="toggle",default=false},
    }
    local byKey={}
    for _,d in ipairs(DEFINITIONS) do byKey[d.key]=d end
    local function data(s)
        if type(s.statRules)~="table" then s.statRules={} end
        return s.statRules
    end
    function M.descriptors()
        local out={}
        for i,d in ipairs(DEFINITIONS) do
            out[i]={key=d.key,label=d.label,default=d.default,
                kind=d.kind,status="working"}
        end
        return out
    end
    function M.get(s,key)
        if type(s)~="table" or not byKey[key] then return nil end
        local v=data(s)[key]
        if byKey[key].kind=="toggle" then return v==true end
        return type(v)=="number" and v==math.floor(v)
            and v>=0 and v<=5 and v or 0
    end
    function M.set(s,key,value)
        if type(s) == "table" and s.runSettingsLocked == true and s._setup ~= true then
            return false, "run_settings_locked"
        end
        if type(s)~="table" then return false,"invalid_state" end
        if s.failed then return false,"run_failed" end
        local d=byKey[key]
        if not d then return false,"not_implemented" end
        if d.kind=="toggle" then
            if type(value)~="boolean" then return false,"boolean_required" end
        elseif type(value)~="number" or value~=math.floor(value)
            or value<0 or value>5 then return false,"invalid_ev_preset" end
        data(s)[key]=value
        return true
    end
    function M.next(s,key)
        local value=M.get(s,key)
        if value==nil then return nil end
        if byKey[key].kind=="toggle" then return not value end
        return (value+1)%6
    end
    function M.label(s,key)
        local value=M.get(s,key)
        if value==nil then return "UNKNOWN" end
        if byKey[key].kind=="toggle" then return value and "ON" or "OFF" end
        return tostring(EV_PRESETS[value+1]).." EV/STAT"
    end
    function M.presetAmount(index)
        return EV_PRESETS[index+1] or 0
    end
    local function available(s,core)
        return core and core.active(s)
    end
    local function copy(src)
        local out={}
        for key,v in pairs(src) do out[key]=v end
        return out
    end
    local function adjust(mon,preset,perfect,pokemon)
        if type(mon)~="table" or (not preset or preset==0)
            and not perfect then return false end
        local oldHp,oldMax=tonumber(mon.hp),tonumber(mon.maxHp)
        if preset and preset>0 then
            mon.evs={}
            for _,k in ipairs(KEYS) do
                mon.evs[k]=EV_PRESETS[preset+1]
            end
        end
        if perfect then
            mon.ivs={}
            for _,k in ipairs(KEYS) do mon.ivs[k]=31 end
        end
        if pokemon and type(pokemon.applyStats)=="function" then
            pokemon.applyStats(mon)
            -- Never revive a fainted mon or heal a damaged roamer.
            if oldHp~=nil then
                if oldMax and oldMax>0 and oldHp>0 then
                    mon.hp=math.max(1,math.min(mon.maxHp,
                        oldHp+(mon.maxHp-oldMax)))
                else
                    mon.hp=math.max(0,math.min(mon.maxHp,oldHp))
                end
            end
        end
        return true
    end
    -- Fresh player acquisitions only. A zero preset preserves native EVs.
    function M.player(s,core,mon,pokemon)
        if not available(s,core) then return false end
        return adjust(mon,M.get(s,"player_start_stat_exp"),
            M.get(s,"perfect_player_ivs"),pokemon)
    end
    -- Only alter the constructor descriptor for foes. The native battle
    -- generator selects personality/nature *after* this boundary; forcing
    -- applyStats here would calculate stats with the wrong nature.
    function M.foe(s,core,source,mon,pokemon)
        if not available(s,core) or
            (source~="wild" and source~="trainer")
            or type(mon)~="table" then return mon end
        local preset=M.get(s,source=="wild" and
            "wild_start_stat_exp" or "trainer_start_stat_exp")
        local perfect=M.get(s,source=="wild" and
            "perfect_wild_ivs" or "perfect_trainer_ivs")
        if preset==0 and not perfect then return mon end
        local result=copy(mon)
        adjust(result,preset,perfect,nil)
        -- Native Damage.ensureStats must recalculate using the final
        -- personality even if a provider handed in cached battle stats.
        for _,key in ipairs({"maxHp","maxhp","attack","defense",
            "speed","spAtk","spDef","atk","def","spe","spa","spd"}) do
            result[key]=nil
        end
        return result
    end
    function M.noGain(s,core)
        return available(s,core) and M.get(s,"no_player_stat_exp_gain")
    end
    -- Only suppress native EV growth on actual player party references.
    function M.playerMon(s,core,session,mon)
        if not M.noGain(s,core) or not session or
            type(session.party)~="table" then return false end
        for _,member in ipairs(session.party) do
            if member==mon then return true end
        end
        return false
    end
    return M
end
