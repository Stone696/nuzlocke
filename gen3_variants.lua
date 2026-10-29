-- Gen 3 VARIANTS: Type Locke and Catch Draft (successful wild catches).
return function()
    local M={api=1,schema=1}
    local MODES={"OFF","MONO","DUO","TRI","QUAD","PENTA","HEXA"}
    -- Native GBA type IDs. Type 9 is TYPE_MYSTERY: not selectable.
    local TYPES={
        {name="NORMAL",id=0},{name="FIGHTING",id=1},
        {name="FLYING",id=2},{name="POISON",id=3},
        {name="GROUND",id=4},{name="ROCK",id=5},
        {name="BUG",id=6},{name="GHOST",id=7},
        {name="STEEL",id=8},{name="FIRE",id=10},
        {name="WATER",id=11},{name="GRASS",id=12},
        {name="ELECTRIC",id=13},{name="PSYCHIC",id=14},
        {name="ICE",id=15},{name="DRAGON",id=16},
        {name="DARK",id=17},
    }
    local LANE_KEYS={
        "type_lock_primary","type_lock_secondary","type_lock_tertiary",
        "type_lock_quaternary","type_lock_quinary","type_lock_senary",
    }
    local INDEX={}
    for i,key in ipairs(LANE_KEYS) do INDEX[key]=i end
    local function rows(s)
        if type(s.variantRules)~="table" then s.variantRules={} end
        return s.variantRules
    end
    local function isNumber(n,lower,upper)
        return type(n)=="number" and n==math.floor(n)
            and n>=lower and n<=upper
    end
    local function hash(value)
        local h=5381
        value=tostring(value or "GEN3")
        for i=1,#value do h=(h*33+value:byte(i))%2147483647 end
        return h
    end
    function M.descriptors()
        local out={{key="type_lock_mode",label="Type Locke",status="working"},
            {key="type_lock_draft",label="Catch Draft",status="working"}}
        for i,key in ipairs(LANE_KEYS) do
            out[#out+1]={key=key,label="Type "..i,status="working"}
        end
        return out
    end
    function M.get(s,key)
        if type(s)~="table" then return nil end
        local r=rows(s)
        if key=="type_lock_mode" then
            return isNumber(r[key],0,6) and r[key] or 0
        end
        if key=="type_lock_draft" then
            return r[key]==true
        end
        if INDEX[key] then
            return isNumber(r[key],0,#TYPES) and r[key] or 0
        end
        return nil
    end
    function M.set(s,key,value)
        if type(s) == "table" and s.runSettingsLocked == true and s._setup ~= true then
            return false, "run_settings_locked"
        end
        if type(s)~="table" then return false,"invalid_state" end
        if s.failed then return false,"run_failed" end
        if key=="type_lock_mode" then
            if not isNumber(value,0,6) then return false,"invalid_mode" end
        elseif key=="type_lock_draft" then
            if type(value)~="boolean" then return false,"boolean_required" end
        elseif INDEX[key] then
            if M.get(s,"type_lock_draft") then
                return false,"draft_lanes_are_automatic"
            end
            if not isNumber(value,0,#TYPES) then
                return false,"invalid_type"
            end
        else return false,"not_implemented" end
        local r=rows(s)
        if r[key]~=value then
            r[key]=value
            -- Changing a preset invalidates previous random assignments.
            -- The next encounter resolves them with the same trainer seed.
            r.random_types=nil
            if key=="type_lock_mode" or key=="type_lock_draft" then
                -- Drafted types belong to the configured challenge;
                -- reconfiguring a new draft explicitly starts a new draft.
                r.drafted_types=nil
            end
        end
        return true
    end
    function M.next(s,key)
        local v=M.get(s,key)
        if v==nil then return nil end
        if key=="type_lock_mode" then return (v+1)%7 end
        if key=="type_lock_draft" then return not v end
        return (v+1)%(#TYPES+1)
    end
    function M.label(s,key)
        local v=M.get(s,key)
        if v==nil then return "UNKNOWN" end
        if key=="type_lock_mode" then return MODES[v+1] end
        if key=="type_lock_draft" then return v and "ON" or "OFF" end
        if M.get(s,"type_lock_draft") then
            local current=rows(s).drafted_types
            local choice=type(current)=="table" and current[INDEX[key]]
            for _,entry in ipairs(TYPES) do
                if entry.id==choice then return entry.name end
            end
            return "AWAIT CATCH"
        end
        if v>0 then return TYPES[v].name end
        local random=rows(s).random_types
        local choice=type(random)=="table" and random[INDEX[key]]
        if isNumber(choice,1,#TYPES) then
            return "RND:"..TYPES[choice].name
        end
        return "RANDOM"
    end
    function M.mode(s) return M.get(s,"type_lock_mode") or 0 end
    function M.keys() return LANE_KEYS end
    local TYPE_BY_ID={}
    for _,entry in ipairs(TYPES) do TYPE_BY_ID[entry.id]=entry.name end
    local function draftList(s)
        local r=rows(s)
        -- Checking a gift, menu label or progress must not initialise
        -- an empty draft in the save. Only successful wild catches write.
        return type(r.drafted_types)=="table" and r.drafted_types or {}
    end
    function M.draftProgress(s)
        local mode=M.mode(s)
        if not M.get(s,"type_lock_draft") or mode==0 then return 0,mode end
        local list=draftList(s)
        local count=0
        local seen={}
        for i=1,math.min(mode,#list) do
            local id=list[i]
            if TYPE_BY_ID[id] and not seen[id] then
                seen[id]=true
                count=count+1
            end
        end
        return count,mode
    end
    -- A registered species must have a canonical identity; the native
    -- registry returns NORMAL/NORMAL for species with no type information.
    local function speciesTypes(species,pokemon)
        local id=tonumber(species)
        if not id and pokemon and
            type(pokemon.speciesFromName)=="function" then
            local ok,value=pcall(pokemon.speciesFromName,species)
            if ok then id=tonumber(value) end
        end
        if not id or not pokemon or type(pokemon.types)~="function"
            then return nil end
        if type(pokemon.keyName)=="function" then
            local ok,name=pcall(pokemon.keyName,id)
            if not ok or type(name)~="string" or name==""
                then return nil end
        end
        local ok,types=pcall(pokemon.types,id)
        if not ok or type(types)~="table" then return nil end
        local a,b=tonumber(types[1]),tonumber(types[2])
        if a==nil or b==nil then return nil end
        return a,b
    end
    -- Only the pokemon.caught event, after successful native capture,
    -- calls this. Gifts/trades/starter/failed throws cannot fill lanes.
    function M.noteCatch(s,species,pokemon,core)
        if not core or not core.active(s) or M.mode(s)==0
            or not M.get(s,"type_lock_draft") then return false end
        local count,mode=M.draftProgress(s)
        if count>=mode then return false end
        local a,b=speciesTypes(species,pokemon)
        if a==nil then return false end
        local list=draftList(s)
        local used={}
        for i=1,#list do used[list[i]]=true end
        -- Prefer the primary type, unless it is already assigned and
        -- the secondary type would add a genuinely new lane.
        local choice
        if TYPE_BY_ID[a] and not used[a] then choice=a
        elseif TYPE_BY_ID[b] and not used[b] then choice=b end
        if choice==nil then return false end
        list[#list+1]=choice
        rows(s).drafted_types=list
        return true,TYPE_BY_ID[choice],#list,mode
    end
    local function existingTypeIds(pokemon)
        if not pokemon or type(pokemon.speciesFromNational)~="function"
            or type(pokemon.types)~="function" then return nil end
        local represented={}
        for nat=1,386 do
            local ok,id=pcall(pokemon.speciesFromNational,nat)
            if ok and tonumber(id) then
                local good,v=pcall(pokemon.types,id)
                if good and type(v)=="table" then
                    for j=1,2 do
                        local t=tonumber(v[j])
                        if t~=nil then represented[t]=true end
                    end
                end
            end
        end
        return represented
    end
    -- Return true only after new choices are saved. Random choices are
    -- unique among remaining available lanes; explicit duplicates may be
    -- selected by users and are not automatically rewritten.
    function M.prepare(s,pokemon,seed)
        local mode=M.mode(s)
        if mode==0 or M.get(s,"type_lock_draft") then return false end
        local r=rows(s)
        if type(r.random_types)=="table" then
            local ready=true
            for i=1,mode do
                if M.get(s,LANE_KEYS[i])==0
                    and not isNumber(r.random_types[i],1,#TYPES) then
                    ready=false; break
                end
            end
            if ready then return false end
        end
        local represented=existingTypeIds(pokemon)
        if not represented then return false end
        local used,selected={},{}
        for i=1,mode do
            local configured=M.get(s,LANE_KEYS[i])
            if configured>0 then used[configured]=true end
        end
        for i=1,mode do
            if M.get(s,LANE_KEYS[i])==0 then
                local choices={}
                for n,entry in ipairs(TYPES) do
                    if represented[entry.id] and not used[n] then
                        choices[#choices+1]=n
                    end
                end
                if #choices==0 then return false end
                local choice=choices[hash(tostring(seed or "GEN3")
                    ..":TYPELOCKE:"..i)%#choices+1]
                used[choice]=true
                selected[i]=choice
            end
        end
        r.random_types=selected
        return true
    end
    function M.allowedTypes(s,pokemon,seed)
        local mode=M.mode(s)
        if mode==0 then return {} end
        if M.get(s,"type_lock_draft") then
            local result={}
            local list=draftList(s)
            for i=1,math.min(mode,#list) do
                local typeId=list[i]
                if TYPE_BY_ID[typeId] then result[typeId]=true end
            end
            return result
        end
        M.prepare(s,pokemon,seed)
        local out,r={},rows(s)
        for i=1,mode do
            local choice=M.get(s,LANE_KEYS[i])
            if choice==0 then
                choice=type(r.random_types)=="table" and
                    r.random_types[i] or nil
            end
            if not choice or not TYPES[choice] then return nil end
            out[TYPES[choice].id]=true
        end
        return out
    end
    function M.check(s,species,pokemon,core,seed,source)
        if not core or not core.active(s) or M.mode(s)==0 then
            return true
        end
        if M.get(s,"type_lock_draft") then
            local done,needed=M.draftProgress(s)
            if done<needed and (source==nil or source=="wild") then
                -- Opening wild captures build the draft, even if off-type.
                return true
            end
            if done==0 and source~="wild" and source~=nil then
                return false,"Catch Draft: catch a wild Pokemon to"
                    .." establish your first type before gifts/trades."
            end
        end
        local selected=M.allowedTypes(s,pokemon,seed)
        if not selected then
            return false,"Type Locke: cannot resolve selected types."
        end
        -- The native species registry returns {0,0} for unknown species,
        -- so check canonical identity first before treating 0 as NORMAL.
        local first,second=speciesTypes(species,pokemon)
        if first==nil then return true end
        if selected[first] or selected[second] then return true end
        return false,"Type Locke: this Pokemon has no permitted type."
    end
    return M
end
