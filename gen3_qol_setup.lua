-- Gen 3 Setup-only convenience settings.
-- This policy acts exclusively on src.core.game3.save_schema_firered's
-- save.new_game hook. It must never backfill loaded saves.
return function()
    local M={api=1,schema=1}
    local defs={
        {key="starting_pokeballs",label="Starting Poke Balls",
            kind="count",default=0,max=99,values={0,5,10,25,50,99}},
        {key="starting_rare_candies",label="Starting Rare Candy",
            kind="count",default=0,max=99,values={0,5,10,25,50,99}},
        {key="starting_money",label="Starting Money",
            kind="money",default=-1,max=999999,
            values={-1,0,1000,3000,5000,10000,50000,100000,999999}},
        {key="pc_starting_heal_items",label="Heal Loadout",
            kind="bool",default=false},
        {key="pc_starting_vitamins",label="PC Vitamins",
            kind="bool",default=false},
    }
    local byKey={}
    for _,d in ipairs(defs) do byKey[d.key]=d end
    local function data(s)
        if type(s.setupRules)~="table" then s.setupRules={} end
        return s.setupRules
    end
    function M.descriptors()
        local out={}
        for i,d in ipairs(defs) do
            out[i]={key=d.key,label=d.label,kind=d.kind,
                default=d.default,status="working",max=d.max}
        end
        return out
    end
    function M.get(s,key)
        local d=byKey[key]
        if not d or type(s)~="table" then return nil end
        local v=data(s)[key]
        if d.kind=="bool" then return v==true end
        if type(v)=="number" and v==math.floor(v)
            and v>=(d.kind=="money" and -1 or 0)
            and v<=d.max then return v end
        return d.default
    end
    function M.set(s,key,v)
        if type(s) == "table" and s.runSettingsLocked == true and s._setup ~= true then
            return false, "run_settings_locked"
        end
        local d=byKey[key]
        if not d then return false,"unknown_rule" end
        if type(s)~="table" then return false,"invalid_state" end
        -- Setup configures the *next* new game, even after a lost run.
        if d.kind=="bool" then
            if type(v)~="boolean" then return false,"boolean_required" end
        elseif type(v)~="number" or v~=math.floor(v)
            or v<(d.kind=="money" and -1 or 0) or v>d.max then
            return false,"invalid_resource_amount"
        end
        data(s)[key]=v
        return true
    end
    function M.next(s,key)
        local d=byKey[key]
        if not d then return nil end
        local value=M.get(s,key)
        if d.kind=="bool" then return not value end
        for i,v in ipairs(d.values) do
            if v==value then return d.values[i%#d.values+1] end
            if v>value then return v end
        end
        return d.default
    end
    function M.label(s,key)
        local d=byKey[key]
        if not d then return "UNKNOWN" end
        local v=M.get(s,key)
        if d.kind=="money" then
            return v==-1 and "NATIVE" or tostring(v)
        end
        return d.kind=="bool" and (v and "ON" or "OFF")
            or tostring(v)
    end

    local heal={
        {13,10}, -- Potion
        {22,10}, -- Super Potion
        {20,10}, -- Max Potion
        {14,10}, -- Antidote
        {15,10}, -- Burn Heal
        {16,10}, -- Ice Heal
        {17,10}, -- Awakening
        {18,10}, -- Parlyz Heal
        {23,10}, -- Full Heal
    }
    -- Numeric item ID values verified against current FRLG/RSE constants.
    -- Include Zinc as a native sixth vitamin for all Gen3 games.
    local vitamins={
        {63,10}, -- HP Up
        {64,10}, -- Protein
        {65,10}, -- Iron
        {66,10}, -- Carbos
        {67,10}, -- Calcium
        {70,10}, -- Zinc
    }
    function M.pack(s,includeBalls)
        local entries={}
        local function add(id,qty)
            if qty>0 then entries[#entries+1]={id=id,qty=qty} end
        end
        if includeBalls~=false then
            add(4,M.get(s,"starting_pokeballs") or 0)
        end
        add(68,M.get(s,"starting_rare_candies") or 0)
        if M.get(s,"pc_starting_heal_items") then
            for _,r in ipairs(heal) do add(r[1],r[2]) end
        end
        if M.get(s,"pc_starting_vitamins") then
            for _,r in ipairs(vitamins) do add(r[1],r[2]) end
        end
        return entries
    end
    function M.plan(s)
        return {money=M.get(s,"starting_money"),items=M.pack(s)}
    end

    -- Preserve actual native PC storage item limits, including stack limits
    -- and existing native single Potion. If not enough space, abort *all*
    -- PC grants, not a partial kit; keep the new game playable.
    function M.apply(s,session,storage)
        if type(session)~="table" or session.engine~="game3"
            or session.generation~=3 or type(storage)~="table"
            or type(storage.addPcItem)~="function"
            or type(storage.pcItemsCount)~="function"
            or type(storage.ensure)~="function" then
            return false,"unsupported_session"
        end
        -- The native first Ball/quest reward unlocks catching. Supplying
        -- extra Balls in PC before that boundary could arm encounters early.
        local pack={money=M.get(s,"starting_money"),items=M.pack(s,false)}
        local pc=storage.ensure(session)
        if type(pc)~="table" or type(pc.items)~="table" then
            return false,"pc_missing"
        end
        if session.modData and session.modData.nuzQolSetupApplied then
            return false,"already_applied"
        end
        local staged={}
        for i,row in ipairs(pc.items) do
            staged[i]={id=row.id,qty=row.qty}
        end
        local max=tonumber(storage.MAX_ITEM_QTY) or 999
        for _,row in ipairs(pack.items) do
            local at
            for i,item in ipairs(staged) do
                if tonumber(item.id)==row.id then at=i;break end
            end
            if at then
                local total=(tonumber(staged[at].qty) or 0)+row.qty
                if total>max then return false,"pc_stack_full" end
                staged[at].qty=total
            else
                staged[#staged+1]={id=row.id,qty=row.qty}
            end
        end
        local capacity=storage.pcItemsCount(session)
        if #staged>capacity then return false,"pc_full" end
        local money=pack.money
        if money~=-1 and money~=nil then
            session.money=money
        end
        -- Commit after validation, never on an existing save load.
        pc.items=staged
        session.modData=session.modData or {}
        session.modData.nuzQolSetupApplied=true
        session.modData.nuzQolDeferredBalls=
            M.get(s,"starting_pokeballs") or 0
        session.modData.nuzQolSetupSummary={
            money=money,pcItemTypes=#pack.items}
        return true
    end

    -- Release additional PC Balls ONLY after native capture unlock. Preserve
    -- pending delivery in the native save so a load or full PC cannot lose it.
    function M.deliverBalls(s,session,storage)
        if type(session)~="table" or type(session.modData)~="table"
            or not session.modData.nuzQolSetupApplied then
            return false,"not_new_game_grant"
        end
        local pending=tonumber(session.modData.nuzQolDeferredBalls) or 0
        if pending<=0 then return false,"nothing_pending" end
        if type(s)~="table" or s.captureUnlocked~=true then
            return false,"capture_not_unlocked"
        end
        if type(storage)~="table" or type(storage.addPcItem)~="function" then
            return false,"native_pc_missing"
        end
        local ok,why=storage.addPcItem(session,4,pending)
        if not ok then return false,why or "pc_full" end
        session.modData.nuzQolDeferredBalls=0
        session.modData.nuzQolExtraBallsGranted=true
        return true
    end
    return M
end
