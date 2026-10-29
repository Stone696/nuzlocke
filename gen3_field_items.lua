-- Gen 3 Field Items: native pre-transaction policy for overworld use,
-- PP items in battle, and player-initiated Fly/Teleport only.
return function()
    local M={api=1,schema=1}
    local DEFINITIONS={
        {key="no_repels",label="No Repels",default=false,kind="toggle"},
        {key="no_escape_rope",label="No Escape Rope",default=false,kind="toggle"},
        {key="travel_restrictions",label="Travel Restrictions",default=0,kind="travel"},
        {key="no_field_healing",label="No Field Heal",default=false,kind="toggle"},
        {key="no_pp_items",label="No PP Items",default=false,kind="toggle"},
        {key="no_tm_use",label="No TMs",default=false,kind="toggle"},
        {key="no_rare_candy_use",label="No Rare Candy",default=false,kind="toggle"},
    }
    local byKey={}
    for _,v in ipairs(DEFINITIONS) do byKey[v.key]=v end
    local TRAVEL={"NORMAL","NO FLY","NO FLY+TELEPORT"}
    local function data(s)
        if type(s.fieldItemRules)~="table" then s.fieldItemRules={} end
        return s.fieldItemRules
    end
    function M.descriptors()
        local out={}
        for i,d in ipairs(DEFINITIONS) do
            out[i]={key=d.key,label=d.label,default=d.default,
                status="working"}
        end
        return out
    end
    function M.get(s,key)
        if type(s)~="table" or not byKey[key] then return nil end
        local d=byKey[key]
        local value=data(s)[key]
        if d.kind=="travel" then
            return type(value)=="number" and value==math.floor(value)
                and value>=0 and value<=2 and value or 0
        end
        return type(value)=="boolean" and value or false
    end
    function M.set(s,key,value)
        if type(s) == "table" and s.runSettingsLocked == true and s._setup ~= true then
            return false, "run_settings_locked"
        end
        if type(s)~="table" then return false,"invalid_state" end
        if s.failed then return false,"run_failed" end
        local d=byKey[key]
        if not d then return false,"not_implemented" end
        if d.kind=="travel" then
            if type(value)~="number" or value~=math.floor(value)
                or value<0 or value>2 then
                return false,"invalid_travel_mode"
            end
        elseif type(value)~="boolean" then
            return false,"boolean_required"
        end
        data(s)[key]=value
        return true
    end
    function M.next(s,key)
        local current=M.get(s,key)
        if current==nil then return nil end
        return key=="travel_restrictions" and (current+1)%3
            or not current
    end
    function M.label(s,key)
        local v=M.get(s,key)
        if v==nil then return "UNKNOWN" end
        if key=="travel_restrictions" then return TRAVEL[v+1] end
        return v and "ON" or "OFF"
    end
    local function numericId(id,items)
        if items and type(items.toNumericId)=="function" then
            local ok,n=pcall(items.toNumericId,id)
            if ok and type(n)=="number" then return n end
        end
        return tonumber(id)
    end
    local function itemName(id)
        return tostring(id or ""):upper():gsub("[%s%-]+","_")
    end
    local function safeKind(id,session,itemUse,items)
        if itemUse and type(itemUse.fieldUseKind)=="function" then
            local ok,v=pcall(itemUse.fieldUseKind,id,session,true)
            if ok and type(v)=="string" then return v end
        end
        if items and type(items.fieldUseKind)=="function" then
            local ok,v=pcall(items.fieldUseKind,id)
            if ok and type(v)=="string" then return v end
        end
        return nil
    end
    local function medicine(id,items)
        if not items or type(items.medicineKind)~="function" then
            return nil
        end
        local ok,v=pcall(items.medicineKind,id)
        return ok and v or nil
    end
    local function isTmNotHm(id,items)
        if not items or type(items.isTm)~="function"
            or type(items.isHm)~="function" then return false end
        local ok,t=pcall(items.isTm,id)
        if not ok or t~=true then return false end
        local hm,h=pcall(items.isHm,id)
        return hm and not h
    end
    M.isTmNotHm=isTmNotHm
    local function isPp(id,session,itemUse,items)
        if safeKind(id,session,itemUse,items)=="pp" then return true end
        if itemUse and type(itemUse.ppItemBoosts)=="function" then
            local ok,v=pcall(itemUse.ppItemBoosts,id)
            if ok and v==true then return true end
        end
        -- Explicit native IDs as fallback if an older engine metadata
        -- pack omits PP Up/Max's fieldKind. IDs 34-38 are Ether/Elixir.
        local num=numericId(id,items)
        if num and (num>=34 and num<=38 or num==69 or num==71) then
            return true
        end
        local n=itemName(id)
        return n=="ETHER" or n=="MAX_ETHER" or n=="ELIXIR"
            or n=="MAX_ELIXIR" or n=="PP_UP" or n=="PP_MAX"
            or n=="LEPPA_BERRY" or n=="MYSTERY_BERRY"
    end
    M.isPp=isPp
    local function isCandy(id,session,itemUse,items)
        local n=numericId(id,items)
        return n==68 or itemName(id)=="RARE_CANDY"
    end
    M.isCandy=isCandy
    function M.fieldDenial(s,core,id,session,itemUse,items)
        if not core or not core.active(s) then return nil end
        local kind=safeKind(id,session,itemUse,items)
        if M.get(s,"no_repels") and kind=="repel" then
            return "No Repels: Repel items cannot be used."
        end
        if M.get(s,"no_escape_rope") and kind=="escape" then
            return "No Escape Rope: Escape Rope cannot be used."
        end
        if M.get(s,"no_rare_candy_use") and isCandy(id,session,itemUse,items) then
            return "No Rare Candy: Rare Candy cannot be used."
        end
        if M.get(s,"no_tm_use") and isTmNotHm(id,items) then
            return "No TMs: Technical Machines cannot be used."
        end
        if M.get(s,"no_pp_items") and isPp(id,session,itemUse,items) then
            return "No PP Items: PP recovery and boosts are disabled."
        end
        if M.get(s,"no_field_healing") then
            local med=medicine(id,items)
            if med=="heal" or med=="status" or med=="revive"
                or med=="full_restore" or kind=="heal"
                or kind=="status" or kind=="revive" then
                return "No Field Heal: medicine cannot be used outside battle."
            end
        end
        return nil
    end
    function M.battleDenial(s,core,id,session,itemUse,items)
        if not core or not core.active(s)
            or not M.get(s,"no_pp_items") then return nil end
        if isPp(id,session,itemUse,items) then
            return "No PP Items: PP recovery and boosts are disabled."
        end
        return nil
    end
    function M.travelDenial(s,core,move)
        if not core or not core.active(s) then return nil end
        local value=M.get(s,"travel_restrictions")
        if move=="FLY" and value>=1 then
            return "Travel Restrictions: Fly cannot be used from the party menu."
        end
        if move=="TELEPORT" and value>=2 then
            return "Travel Restrictions: Teleport cannot be used from the party menu."
        end
        return nil
    end
    return M
end
