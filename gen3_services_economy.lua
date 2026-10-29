-- Gen 3 Advanced Rules: Services & Economy.
-- Only player-initiated services are denied; scripted progression is kept.
return function()
    local M={api=1,schema=1}
    local DEFINITIONS={
        {key="no_poke_center",label="No Center Heal",kind="toggle",default=false},
        {key="no_mom_heal",label="No Mom Heal",kind="toggle",default=false},
        {key="no_day_care",label="No Day Care",kind="toggle",default=false},
        {key="shop_restrictions",label="Shop Restrictions",kind="shop",default=0},
        {key="no_gambling",label="No Gambling",kind="toggle",default=false},
        {key="trainer_money_multiplier",label="Trainer Money",kind="money",default=100},
    }
    local SHOP_LABELS={"NORMAL","NO BUY","NO SELL","CLOSED"}
    local MONEY_VALUES={100,200,300,0,50}
    local byKey={}
    for _,d in ipairs(DEFINITIONS) do byKey[d.key]=d end
    local function data(s)
        if type(s.serviceRules)~="table" then s.serviceRules={} end
        return s.serviceRules
    end
    function M.descriptors()
        local out={}
        for i,d in ipairs(DEFINITIONS) do
            out[i]={key=d.key,label=d.label,default=d.default,
                kind=d.kind,status="working"}
        end
        return out
    end
    local function validMoney(n)
        for _,value in ipairs(MONEY_VALUES) do
            if value==n then return true end
        end
        return false
    end
    function M.get(s,key)
        if type(s)~="table" or not byKey[key] then return nil end
        local d=byKey[key]
        local v=data(s)[key]
        if d.kind=="toggle" then return v==true end
        if d.kind=="shop" then
            return type(v)=="number" and v==math.floor(v)
                and v>=0 and v<=3 and v or 0
        end
        return validMoney(v) and v or 100
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
        elseif d.kind=="shop" then
            if type(value)~="number" or value~=math.floor(value)
                or value<0 or value>3 then return false,"invalid_shop_mode" end
        elseif not validMoney(value) then
            return false,"invalid_money_modifier"
        end
        data(s)[key]=value
        return true
    end
    function M.next(s,key)
        local v=M.get(s,key)
        if v==nil then return nil end
        local kind=byKey[key].kind
        if kind=="toggle" then return not v end
        if kind=="shop" then return (v+1)%4 end
        for i,n in ipairs(MONEY_VALUES) do
            if n==v then return MONEY_VALUES[i%#MONEY_VALUES+1] end
        end
        return 100
    end
    function M.label(s,key)
        local v=M.get(s,key)
        if v==nil then return "UNKNOWN" end
        local kind=byKey[key].kind
        if kind=="toggle" then return v and "ON" or "OFF" end
        if kind=="shop" then return SHOP_LABELS[v+1] end
        return tostring(v).."%"
    end
    -- Game3 map IDs identify *physical* interiors, not map sections.
    -- Refuse unknown maps rather than blocking story-mandated special heals.
    function M.healLocation(mapId)
        if type(mapId)~="string" then return nil end
        local id=mapId:upper()
        if id:find("POKEMON_CENTER",1,true)
            or id:find("POKECENTER",1,true) then return "center" end
        if id:find("PLAYERS_HOUSE_1F",1,true)
            or id:find("PLAYERS_HOUSE",1,true)
            or id:find("BRENDANS_HOUSE_1F",1,true)
            or id:find("MAYS_HOUSE_1F",1,true) then return "mom" end
        return nil
    end
    function M.healDenial(s,core,mapId)
        if not core or not core.active(s) then return nil end
        local kind=M.healLocation(mapId)
        if kind=="center" and M.get(s,"no_poke_center") then
            return "No Center Heal: Pokemon Centre healing is disabled."
        end
        if kind=="mom" and M.get(s,"no_mom_heal") then
            return "No Mom Heal: healing at home is disabled."
        end
        return nil
    end
    function M.daycareDenial(s,core)
        if core and core.active(s) and M.get(s,"no_day_care") then
            return "No Day Care: new deposits are disabled. Existing Pokemon may be collected."
        end
        return nil
    end
    function M.shopDenial(s,core,action)
        if not core or not core.active(s) then return nil end
        local mode=M.get(s,"shop_restrictions")
        if (action=="buy" and (mode==1 or mode==3))
            or (action=="sell" and (mode==2 or mode==3)) then
            return "Shop Restrictions: "..(action=="buy" and "buying" or "selling")
                .." is disabled."
        end
        return nil
    end
    function M.gamblingDenial(s,core)
        if core and core.active(s) and M.get(s,"no_gambling") then
            return "No Gambling: slot machines and roulette are disabled."
        end
        return nil
    end
    -- Apply to native trainer-prize calculation only, before money credit
    -- and message formatting. Never scale arbitrary scripted money awards.
    function M.trainerPrize(s,core,amount)
        if not core or not core.active(s) then return amount end
        local original=tonumber(amount)
        if not original then return amount end
        local pct=M.get(s,"trainer_money_multiplier")
        return math.max(0,math.floor(original*pct/100))
    end
    return M
end
