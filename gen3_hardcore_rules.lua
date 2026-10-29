-- Gen 3 Hardcore Rules: native escape, whiteout, doors and held items.
return function()
    local M={api=1,schema=1}
    local defs={
        {key="no_escape",label="No Escape",default=false},
        {key="whiteout_clause",label="Whiteout",default=false},
        {key="gym_lock_in",label="Gym Lock-In",default=false},
        {key="dungeon_lock_in",label="Dungeon Lock-In",default=false},
        {key="no_held_items",label="No Held Items",default=false},
    }
    local byKey={}
    for _,d in ipairs(defs) do byKey[d.key]=d end
    local function data(s)
        if type(s.hardcoreRules)~="table" then s.hardcoreRules={} end
        return s.hardcoreRules
    end
    function M.descriptors()
        local list={}
        for i,d in ipairs(defs) do
            list[i]={key=d.key,label=d.label,default=d.default,
                status="working"}
        end
        return list
    end
    function M.get(s,key)
        if not byKey[key] or type(s)~="table" then return nil end
        return data(s)[key]==true
    end
    function M.set(s,key,value)
        if type(s) == "table" and s.runSettingsLocked == true and s._setup ~= true then
            return false, "run_settings_locked"
        end
        if not byKey[key] then return false,"not_implemented" end
        if type(s)~="table" then return false,"invalid_state" end
        if s.failed then return false,"run_failed" end
        if type(value)~="boolean" then return false,"boolean_required" end
        data(s)[key]=value
        return true
    end
    function M.next(s,key)
        if not byKey[key] then return nil end
        return not M.get(s,key)
    end
    function M.label(s,key)
        local value=M.get(s,key)
        if value==nil then return "UNKNOWN" end
        return value and "ON" or "OFF"
    end
    function M.on(s,core,key)
        return core and core.active(s) and M.get(s,key)==true
    end
    function M.blockRun(s,core,st)
        if not M.on(s,core,"no_escape")
            or type(st)~="table" then return false end
        if not st.wild or st.safari or st.link or st.recordedLink
            or st.oldManTutorial or st.wallyTutorial
            or st.pokedude or st.firstBattle
            or st.kinds and (st.kinds.firstBattle
                or st.kinds.tutorial or st.kinds.wallyTutorial
                or st.kinds.oldManTutorial) then return false end
        return true
    end
    function M.whiteout(s,core,result)
        if not M.on(s,core,"whiteout_clause") then return false end
        return result=="lose" or result=="whiteout"
            or result=="blackout"
    end
    function M.allowSurvivors(s,core,native,extra)
        if not M.on(s,core,"whiteout_clause")
            or type(native)~="table" then return false end
        for _,mon in ipairs(native.party or {}) do
            if type(mon)=="table" and mon.isEgg~=true
                and not mon.nuzlockeDead
                and (tonumber(mon.hp) or 0)>0 then return true end
        end
        -- Extra.rescueFromPc is the canonical verifier: it checks dead
        -- archives, PC-only locks, eggs and usable HP before transfer.
        if extra and type(extra.rescueFromPc)=="function"
            and type(native.party)=="table" then
            return extra.rescueFromPc(s,native)
        end
        return false
    end
    local function gymOf(mapId)
        if type(mapId)~="string" then return nil end
        if not mapId:match("^FR_") and not mapId:match("^RU_")
            and not mapId:match("^SA_")
            and not mapId:match("^EM_") then return nil end
        local town=mapId:match("_([A-Z]+)_CITY_GYM$")
            or mapId:match("_([A-Z]+)_TOWN_GYM$")
            or mapId:match("_([A-Z]+)_ISLAND_GYM$")
            or mapId:match("_([A-Z]+)_CITY_GYM_[B]?[0-9]+F$")
        return town
    end
    M.gymOf=gymOf
    function M.gymLocked(s,core,mapId,flags,store,gymTeamCapOn)
        if not M.on(s,core,"gym_lock_in") then return false end
        -- Team-size cap requires returning to a PC. Without native
        -- trainer-to-gym roster identification, sealing the door
        -- simultaneously would risk an unavoidable softlock.
        if gymTeamCapOn==true then return false end
        local gym=gymOf(mapId)
        if not gym or type(flags)~="table"
            or type(flags.badgeInfo)~="function"
            or type(flags.getFlag)~="function" or not store then
            return false
        end
        local info=nil
        local valid,matched=pcall(function()
            for i=1,8 do
                local row=flags.badgeInfo(i)
                if row and row.gym==gym then return row end
            end
        end)
        if valid then info=matched end
        if not info or not info.flag then return false end
        local ok,cleared=pcall(flags.getFlag,store,nil,info.flag)
        return ok and not cleared or false
    end
    local whitelist={
        MT_MOON=true,ROCK_TUNNEL=true,SEAFOAM_ISLANDS=true,
        VICTORY_ROAD=true,
    }
    function M.dungeonOf(mapId,areaSplits)
        if not areaSplits or type(areaSplits.describe)~="function" then
            return nil
        end
        local d=areaSplits.describe(mapId)
        return d and whitelist[d.group] and d
            or nil
    end
    -- Record the first concrete portal crossing. The origin must be
    -- outside and the destination inside a supported multi-exit dungeon.
    -- Coordinates are native entry landing coordinates, NOT a blanket
    -- "same outside map" ban.
    function M.entry(s,core,fromId,toId,x,y,areaSplits)
        if not M.on(s,core,"dungeon_lock_in") then return nil end
        local dst=M.dungeonOf(toId,areaSplits)
        if not dst or M.dungeonOf(fromId,areaSplits) then return nil end
        local px,py=tonumber(x),tonumber(y)
        if not px or not py or px~=math.floor(px)
            or py~=math.floor(py) or px<0 or py<0 then return nil end
        return {origin=fromId,map=toId,x=px,y=py,
            edition=dst.edition,group=dst.group}
    end
    function M.dungeonEntranceLocked(s,core,entry,fromId,toId,
        x,y,areaSplits)
        if not M.on(s,core,"dungeon_lock_in")
            or type(entry)~="table" or type(fromId)~="string"
            or type(toId)~="string"
            or type(x)~="number" or type(y)~="number"
            or type(entry.x)~="number"
            or type(entry.y)~="number"
            or fromId~=entry.map or toId~=entry.origin then
            return false
        end
        local d=M.dungeonOf(fromId,areaSplits)
        if not d or d.edition~=entry.edition
            or d.group~=entry.group then return false end
        -- The entrance arrival tile and adjacent step-off tile form a
        -- tiny safe window. Distant distinct exits to the same route
        -- remain traversable. Missing coords always fail open.
        return math.abs(x-entry.x)<=1 and math.abs(y-entry.y)<=1
    end
    function M.dungeonEscapeLocked(s,core,entry,currentMap,areaSplits)
        if not M.on(s,core,"dungeon_lock_in")
            or type(entry)~="table" then return false end
        local d=M.dungeonOf(currentMap,areaSplits)
        return d~=nil and d.group==entry.group
            and d.edition==entry.edition
    end
    function M.heldGiveDenied(s,core)
        return M.on(s,core,"no_held_items")
    end
    function M.heldEffectDenied(s,core,b)
        if not M.on(s,core,"no_held_items")
            or type(b)~="table" then return false end
        return b.side=="player" or b.user=="player"
    end
    return M
end
