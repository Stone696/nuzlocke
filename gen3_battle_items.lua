-- Gen 3 Advanced Rules: Battle Items.
-- The runtime vetoes native battle item transactions before Bag.remove.
-- The capture hook is the authority for counting legal Ball attempts.
return function()
    local M={api=1,schema=1}
    local RULES={
        {key="no_healing_items",label="No Healing Items",default=false},
        {key="no_battle_items",label="No X Items",default=false},
        {key="no_catching",label="No Catching",default=false},
        {key="encounter_ball_limit",label="Ball Per Enc.",default=0},
    }
    local LIMITS={0,1,2,3,5,10}
    local byKey={}
    for _,r in ipairs(RULES) do byKey[r.key]=r end
    local function values(s)
        if type(s.battleItemRules)~="table" then s.battleItemRules={} end
        return s.battleItemRules
    end
    function M.descriptors()
        local d={}
        for i,r in ipairs(RULES) do
            d[i]={key=r.key,label=r.label,status="working",
                default=r.default}
        end
        return d
    end
    local function validLimit(n)
        for _,v in ipairs(LIMITS) do if n==v then return true end end
        return false
    end
    function M.get(s,key)
        if type(s)~="table" or not byKey[key] then return nil end
        local v=values(s)[key]
        if key=="encounter_ball_limit" then
            return validLimit(v) and v or 0
        end
        return type(v)=="boolean" and v or false
    end
    function M.set(s,key,value)
        if type(s) == "table" and s.runSettingsLocked == true and s._setup ~= true then
            return false, "run_settings_locked"
        end
        if type(s)~="table" then return false,"invalid_state" end
        if s.failed then return false,"run_failed" end
        if not byKey[key] then return false,"not_implemented" end
        if key=="encounter_ball_limit" then
            if not validLimit(value) then return false,"invalid_ball_limit" end
        elseif type(value)~="boolean" then
            return false,"boolean_required"
        end
        values(s)[key]=value
        return true
    end
    function M.next(s,key)
        local v=M.get(s,key)
        if v==nil then return nil end
        if key~="encounter_ball_limit" then return not v end
        for i,n in ipairs(LIMITS) do
            if n==v then return LIMITS[i%#LIMITS+1] end
        end
        return 0
    end
    function M.label(s,key)
        local v=M.get(s,key)
        if v==nil then return "UNKNOWN" end
        if key=="encounter_ball_limit" then
            return v==0 and "OFF" or tostring(v)
        end
        return v and "ON" or "OFF"
    end
    local function isBall(itemId,battleItems,itemsData)
        if battleItems and type(battleItems.isBall)=="function" then
            local ok,value=pcall(battleItems.isBall,itemId)
            if ok then return value==true end
        end
        if itemsData and type(itemsData.info)=="function" then
            local ok,info=pcall(itemsData.info,itemId)
            if ok and type(info)=="table" then
                return info.pocket=="POKE_BALLS"
            end
        end
        return false
    end
    M.isBall=isBall
    local function numericId(id,itemsData)
        if itemsData and type(itemsData.toNumericId)=="function" then
            local ok,num=pcall(itemsData.toNumericId,id)
            if ok and type(num)=="number" then return num end
        end
        return tonumber(id)
    end
    local function healItem(itemId,itemsData,itemUse)
        local kind
        if itemsData and type(itemsData.medicineKind)=="function" then
            local ok,result=pcall(itemsData.medicineKind,itemId)
            if ok then kind=result end
        end
        if kind=="heal" or kind=="status" or kind=="revive"
            or kind=="full_restore" then return true end
        if itemUse and type(itemUse.fieldUseKind)=="function" then
            local ok,result=pcall(itemUse.fieldUseKind,itemId,nil,true)
            if ok and (result=="heal" or result=="status"
                or result=="revive") then return true end
        end
        return false
    end
    local function xItem(itemId,battleItems,itemsData)
        if battleItems and type(battleItems.isStatBooster)=="function" then
            local ok,value=pcall(battleItems.isStatBooster,itemId)
            if ok and value==true then return true end
        end
        -- Dire Hit and Guard Spec. are non-healing battle boosts too.
        -- Numeric identifiers are native FRLG/RSE item IDs.
        local n=numericId(itemId,itemsData)
        if n and n>=73 and n<=79 then return true end
        local name=tostring(itemId or ""):upper():gsub("[%s%-]+","_")
        return name:match("^X_")~=nil or name=="DIRE_HIT"
            or name=="GUARD_SPEC" or name=="GUARD_SPEC."
    end
    function M.itemDenial(s,core,styles,itemId,battleItems,itemsData,itemUse,
        context)
        if not core or not core.active(s) then return nil end
        -- Story/tutorial/link action restrictions are not applied.
        local st=context and context.battle
        if st and (st.link or st.recordedLink or st.oldManTutorial
            or st.pokedude or st.firstBattle) then return nil end
        if styles and type(styles.hardcoreActive)=="function"
            and styles.hardcoreActive(s,core)
            and not isBall(itemId,battleItems,itemsData) then
            return "Hardcore: No battle items except Poke Balls."
        end
        if isBall(itemId,battleItems,itemsData) then
            if M.get(s,"no_catching") then
                return "No Catching: Ball use is disabled."
            end
            -- Avoid limiting trainer/tutorial battles or using a stale
            -- activeBattle. The native battle object must match.
            if context and context.wild==true then
                local limit=M.get(s,"encounter_ball_limit")
                local count=tonumber(context.throws) or 0
                if limit>0 and count>=limit then
                    return "Ball Per Enc.: maximum of "..limit
                        .." legal Ball throws reached."
                end
            end
            return nil
        end
        if M.get(s,"no_healing_items")
            and healItem(itemId,itemsData,itemUse) then
            return "No Healing Items: medicine is disabled in battle."
        end
        if M.get(s,"no_battle_items")
            and xItem(itemId,battleItems,itemsData) then
            return "No X Items: battle stat boosters are disabled."
        end
        return nil
    end
    function M.catchDenial(s,core,throws)
        if not core or not core.active(s) then return nil end
        if M.get(s,"no_catching") then
            return "No Catching: Ball use is disabled."
        end
        local limit=M.get(s,"encounter_ball_limit")
        if limit>0 and (tonumber(throws) or 0)>=limit then
            return "Ball Per Enc.: maximum of "..limit
                .." legal Ball throws reached."
        end
        return nil
    end
    function M.countThrow(s,core,throws)
        if M.catchDenial(s,core,throws) then return nil end
        return (tonumber(throws) or 0)+1
    end
    return M
end
