-- Gen3 QOL: native presentation, movement, bag and trade evolution policy.
-- Never invent a capture-storage transaction or a Gen2-only field feature.
return function()
    local M={api=1,schema=1}
    local defs={
        {key="instant_text",label="Instant Text",
            status="working",kind="bool",default=false},
        {key="run_surf",label="Run / Surf",
            status="working",kind="mode",default=0},
        {key="unlimited_bag_space",label="Unlimited Bag Space",
            status="working",kind="bool",default=false},
        {key="trade_evolutions",label="Trade Evolutions",
            status="working",kind="bool",default=false},
    }
    local byKey={}
    for _,d in ipairs(defs) do byKey[d.key]=d end
    local function data(s)
        if type(s.qolRules)~="table" then s.qolRules={} end
        return s.qolRules
    end
    function M.descriptors()
        local out={}
        for i,d in ipairs(defs) do
            out[i]={key=d.key,label=d.label,status=d.status,
                kind=d.kind,default=d.default,detail=d.detail}
        end
        return out
    end
    function M.get(s,key)
        local d=byKey[key]
        if not d or d.status~="working" or type(s)~="table" then return nil end
        local v=data(s)[key]
        if d.kind=="mode" then
            return type(v)=="number" and v==math.floor(v)
                and v>=0 and v<=2 and v or d.default
        end
        return v==true
    end
    function M.set(s,key,value)
        if type(s) == "table" and s.runSettingsLocked == true and s._setup ~= true then
            return false, "run_settings_locked"
        end
        local d=byKey[key]
        if not d then return false,"unknown_rule" end
        if d.status~="working" then return false,"unsupported_gen3" end
        if type(s)~="table" then return false,"invalid_state" end
        if s.failed then return false,"run_failed" end
        if d.kind=="mode" then
            if type(value)~="number" or value~=math.floor(value)
                or value<0 or value>2 then return false,"invalid_mode" end
        elseif type(value)~="boolean" then return false,"boolean_required" end
        data(s)[key]=value
        return true
    end
    function M.next(s,key)
        local d=byKey[key]
        if not d or d.status~="working" then return nil end
        local v=M.get(s,key)
        return d.kind=="mode" and ((v+1)%3) or not v
    end
    function M.label(s,key)
        local d=byKey[key]
        if not d then return "UNKNOWN" end
        if d.status~="working" then
            return d.status=="soon" and "WIP" or "N/A"
        end
        local v=M.get(s,key)
        return d.kind=="mode" and ({"OFF","HOLD B","ALWAYS"})[v+1]
            or (v and "ON" or "OFF")
    end
    function M.enabled(s,key) return M.get(s,key)==true end

    function M.textOptions(s,opts)
        if not M.enabled(s,"instant_text") then return opts end
        if type(opts)=="function" then
            return {done=opts,speed=0}
        end
        local result={}
        if type(opts)=="table" then
            for k,v in pairs(opts) do result[k]=v end
        end
        result.speed=0
        return result
    end

    local function bHeld(input)
        if type(input)~="table" then return false end
        if type(input.isDown)=="function" then
            local ok,held=pcall(input.isDown,input,"b")
            return ok and held==true
        end
        return false
    end
    function M.frames(s,frames,ctx)
        local mode=M.get(s,"run_surf")
        if not mode or mode==0 or type(frames)~="number"
            or frames<1 or frames~=math.floor(frames)
            or type(ctx)~="table" or ctx.onBike or ctx.slope
            or ctx.underwater or ctx.forced
            or (type(ctx.player)=="table" and
               (ctx.player.jumping or ctx.player.surfHopping
                or ctx.player.dismounting or ctx.player.action
                or ctx.player.animDisabled))
            or not (ctx.surfing or ctx.running or ctx.walking
                or ctx.onFoot==true or ctx.player) then
            return frames
        end
        if mode==1 and not bHeld(ctx.input) then return frames end
        -- A smaller number of movement frames equals a faster step;
        -- never make a transition instant or change a bike's cadence.
        return math.max(1,math.floor(frames/2))
    end

    local allowedPockets={ITEMS=true,POKE_BALLS=true}
    -- The Gen 3 Bag's RSE ITEM/BALL pockets use split 99-item stacks,
    -- and capped_add reads ItemsData.CAPACITY directly. A canAdd-only
    -- override is insufficient. Temporarily relax ONLY the two supported
    -- pocket capacities for the duration of the native transaction.
    -- pcall/finally restores the profile, including on runtime errors.
    function M.withBagCapacity(s,itemsData,id,fn,...)
        if type(fn)~="function" then return nil end
        if not M.enabled(s,"unlimited_bag_space")
            or type(itemsData)~="table"
            or type(itemsData.CAPACITY)~="table"
            or type(itemsData.pocketOf)~="function"
            or type(itemsData.toNumericId)~="function" then
            return fn(...)
        end
        local item=itemsData.toNumericId(id)
        local pocket=itemsData.pocketOf(id)
        if not item or item==0 or not allowedPockets[pocket] then
            return fn(...)
        end
        local original=itemsData.CAPACITY[pocket]
        if type(original)~="number" then return fn(...) end
        itemsData.CAPACITY[pocket]=math.max(original,4096)
        local success,a,b,c,d=pcall(fn,...)
        itemsData.CAPACITY[pocket]=original
        if not success then error(a,0) end
        return a,b,c,d
    end
    function M.bagCanAdd(s,bag,id,qty,itemsData,nativeResult)
        if nativeResult or not M.enabled(s,"unlimited_bag_space")
            or type(bag)~="table" or type(bag.pockets)~="table"
            or type(itemsData)~="table"
            or type(itemsData.pocketOf)~="function"
            or type(itemsData.toNumericId)~="function" then
            return nativeResult
        end
        local num=itemsData.toNumericId(id)
        local pocket=itemsData.pocketOf(id)
        if not num or num==0 or not allowedPockets[pocket] then
            return nativeResult
        end
        local count=tonumber(qty) or 1
        if count~=math.floor(count) or count<1 then return nativeResult end
        -- Gen3 stacks can already hold up to 999. Only remove distinct
        -- slot pressure; never increase quantity capacity or key slots.
        local max=999
        for _,slot in ipairs(bag.pockets[pocket] or {}) do
            if itemsData.toNumericId(slot.id)==num then
                return (tonumber(slot.qty) or 0)+count<=max
            end
        end
        return count<=max
    end

    local function heldId(mon,itemsData)
        local id=mon and (mon.item or mon.heldItem)
        return (itemsData and itemsData.toNumericId
            and itemsData.toNumericId(id)) or tonumber(id) or 0
    end
    local function everstone(mon,itemsData)
        local id=heldId(mon,itemsData)
        if id==195 then return true end
        if itemsData and type(itemsData.info)=="function" then
            local ok,row=pcall(itemsData.info,id)
            if ok and type(row)=="table"
                and tonumber(row.holdEffect)==38 then return true end
        end
        return false
    end
    function M.tradeLevelTarget(s,mon,target,param,mode,session,
        evolution,pokemon,itemsData)
        if not M.enabled(s,"trade_evolutions")
            or type(mon)~="table" or type(evolution)~="table"
            or tonumber(mode or evolution.EVO_MODE_NORMAL or 0)
                ~= (evolution.EVO_MODE_NORMAL or 0)
            or (tonumber(mon.level) or 0)<40 or everstone(mon,itemsData)
            or type(pokemon)~="table"
            or type(pokemon.evolutions)~="function" then
            return target,param
        end
        local species=tonumber(mon.species or mon.speciesId)
        if not species then return target,param end
        local rows=pokemon.evolutions(species)
        if type(rows)~="table" then return target,param end
        local held=heldId(mon,itemsData)
        local candidate,cparam=nil,nil
        for _,e in ipairs(rows) do
            local method=tonumber(e.method or e[1])
            local item=tonumber(e.param or e[2]) or 0
            local dest=tonumber(e.target or e[3])
            if dest and dest>0 and
                ((method==evolution.EVO_TRADE_ITEM and held>0
                    and item==held)
                or (method==evolution.EVO_TRADE and candidate==nil)) then
                if not evolution.nationalAllows
                    or evolution.nationalAllows(dest,session) then
                    candidate,cparam=dest,item
                    -- Held-item branch has priority over base trade
                    -- or competing ordinary level evolutions.
                    if method==evolution.EVO_TRADE_ITEM then break end
                end
            end
        end
        return candidate or target,candidate and cparam or param
    end
    -- Run only AFTER the native evolution succeeds, never on a cancelled
    -- evolution scene or a failed item/trade transaction.
    function M.consumeTradeItem(s,mon,preSpecies,target,via,
        pokemon,evolution,itemsData)
        if via~="level" or not M.enabled(s,"trade_evolutions")
            or type(mon)~="table" or type(pokemon)~="table"
            or type(pokemon.evolutions)~="function" then return false end
        local held=heldId(mon,itemsData)
        if held<=0 then return false end
        local rows=pokemon.evolutions(preSpecies)
        if type(rows)~="table" then return false end
        for _,e in ipairs(rows) do
            if tonumber(e.method or e[1])==evolution.EVO_TRADE_ITEM
                and tonumber(e.param or e[2])==held
                and tonumber(e.target or e[3])==tonumber(target) then
                mon.item,mon.heldItem=0,0
                return true
            end
        end
        return false
    end
    return M
end
