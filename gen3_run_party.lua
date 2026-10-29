-- Gen 3 RUN / PARTY: one persisted policy for gym cap, party cap and evolutions.
return function()
    local M={api=1,schema=1}
    local defs={
        {key="gym_team_size",label="Gym Team Size",kind="bool",default=false},
        {key="party_size_limit",label="Party Size Limit",kind="cap",default=6},
        {key="evolution_limit",label="Evolution Limits",kind="mode",default=0},
    }
    local byKey={}
    for _,d in ipairs(defs) do byKey[d.key]=d end
    local modes={"NORMAL","NO FINAL","NO EVOLUTION"}
    local function data(s)
        if type(s.runPartyRules)~="table" then s.runPartyRules={} end
        return s.runPartyRules
    end
    function M.descriptors()
        local out={}
        for i,d in ipairs(defs) do
            out[i]={key=d.key,label=d.label,default=d.default,
                kind=d.kind,status="working"}
        end
        return out
    end
    function M.get(s,key)
        local d=byKey[key]
        if not d or type(s)~="table" then return nil end
        local v=data(s)[key]
        if d.kind=="bool" then return v==true end
        if type(v)~="number" or v~=math.floor(v) then return d.default end
        if d.kind=="cap" then return v>=1 and v<=6 and v or d.default end
        return v>=0 and v<=2 and v or d.default
    end
    function M.set(s,key,v)
        if type(s) == "table" and s.runSettingsLocked == true and s._setup ~= true then
            return false, "run_settings_locked"
        end
        local d=byKey[key]
        if not d then return false,"not_implemented" end
        if type(s)~="table" then return false,"invalid_state" end
        if s.failed then return false,"run_failed" end
        if d.kind=="bool" then
            if type(v)~="boolean" then return false,"boolean_required" end
        elseif type(v)~="number" or v~=math.floor(v)
            or (d.kind=="cap" and (v<1 or v>6))
            or (d.kind=="mode" and (v<0 or v>2)) then
            return false,"invalid_value"
        end
        data(s)[key]=v
        return true
    end
    function M.next(s,key)
        local d=byKey[key]
        if not d then return nil end
        local v=M.get(s,key)
        if d.kind=="bool" then return not v end
        if d.kind=="cap" then return v==6 and 1 or v+1 end
        return (v+1)%3
    end
    function M.label(s,key)
        local d=byKey[key]
        if not d then return "UNKNOWN" end
        local v=M.get(s,key)
        if d.kind=="bool" then return v and "ON" or "OFF" end
        if d.kind=="cap" then return tostring(v).."/6" end
        return modes[v+1]
    end
    local function active(s,core)
        return core and core.active(s)
    end
    function M.partyCap(s,core)
        return active(s,core) and M.get(s,"party_size_limit") or 6
    end
    function M.partyCount(native)
        if type(native)~="table"
            or type(native.party)~="table" then return nil end
        local n=0
        for _,mon in pairs(native.party) do
            if type(mon)=="table" then n=n+1 end
        end
        return n
    end
    -- Only additions to the party are blocked; direct-to-PC captures
    -- and one-for-one PC swaps do not increase active party size.
    function M.addDenied(s,core,native)
        local count=M.partyCount(native)
        if count==nil then return nil end
        local cap=M.partyCap(s,core)
        if count<cap then return nil end
        if cap>=6 then return nil end -- vanilla PC auto-transfer
        return "Party Size Limit: "..count.."/"..cap
            .." active. Deposit Pokemon before adding another."
    end
    local function edition(native)
        local raw=type(native)=="table" and
            (native.edition or native.version or native.gameId)
        raw=type(raw)=="string" and raw:lower() or ""
        if raw:find("fire",1,true) or raw:find("leaf",1,true)
            or raw=="frlg" then return "frlg" end
        if raw:find("emerald",1,true) or raw=="em" then return "emerald" end
        if raw:find("ruby",1,true) or raw=="ru" or
            raw:find("sapphire",1,true) or raw=="sa" then return "rs" end
        return nil
    end
    function M.isGymLeader(native,foe,opts,trainers)
        opts=opts or {}
        if opts.wild or opts.link or opts.battleTower or opts.frontier
            or opts.trainerTower or opts.eReader or opts.secretBase
            or opts.firstBattle or opts.firstBattleKind
            or opts.oldManTutorial or opts.tutorialKind
            or opts.twoOpponents then return false end
        local id=opts.trainerId or (foe and foe.trainerId)
        local info=nil
        if trainers and type(trainers.get)=="function" and id then
            local ok,value=pcall(trainers.get,id)
            if ok and type(value)=="table" then info=value end
        end
        -- A recognised class is sufficient; it must be exactly the Gym
        -- Leader class, not Aqua/Magma leader, champion or generic boss.
        local name=opts.trainerClassName
            or (foe and foe.trainerClassName)
            or (info and info.className)
        if type(name)=="string" and name~="" then
            local normalized=name:upper():gsub("%s+","_")
            if normalized=="LEADER" or normalized=="GYM_LEADER"
                or normalized=="TRAINER_CLASS_LEADER"
                or normalized=="TRAINER_CLASS_RS_LEADER" then
                return true
            end
            return false
        end
        local class=tonumber(opts.trainerClass
            or (foe and foe.trainerClass) or (info and info.class))
        local family=edition(native)
        return (family=="frlg" and class==84)
            or (family=="emerald" and class==32)
            or (family=="rs" and class==25) or false
    end
    function M.gymDenial(s,core,native,foe,opts,trainers)
        if not active(s,core) or not M.get(s,"gym_team_size")
            or not M.isGymLeader(native,foe,opts,trainers) then
            return nil
        end
        local count=M.partyCount(native)
        if not count then return nil end
        local party=opts and opts.foeParty
            or (foe and foe.party)
        if type(party)~="table" then return nil end
        local opponent=0
        for _,mon in ipairs(party) do
            if type(mon)=="table" then opponent=opponent+1 end
        end
        if opponent<1 or opponent>6 then return nil end
        if count<=opponent then return nil end
        return "Gym Team Size: your party has "..count
            .." Pokemon; this Leader has "..opponent
            ..". Box "..(count-opponent).." and challenge again."
    end
    function M.evoDenied(s,core,mon,target,pokemon)
        if not active(s,core) then return false end
        local mode=M.get(s,"evolution_limit")
        local species=tonumber(target)
        if mode==0 or not species or species<=0 then return false end
        if mode==2 then return true end
        -- NO FINAL checks the selected target, not the species being
        -- evolved. Fail open if a modded target is not fully recognised.
        if not pokemon or type(pokemon.evolutions)~="function"
            or type(pokemon.stats)~="function" then return false end
        local ok,known=pcall(pokemon.stats,species)
        if not ok or type(known)~="table" then return false end
        local success,rows=pcall(pokemon.evolutions,species)
        if not success or type(rows)~="table" then return false end
        for _,e in ipairs(rows) do
            if type(e)~="table" then return false end
            local nextId=tonumber(e.target or e[3])
            if not nextId or nextId<=0 then return false end
            local found,nextStats=pcall(pokemon.stats,nextId)
            if not found or type(nextStats)~="table" then return false end
            return false -- further known evolution exists
        end
        return true
    end
    return M
end
