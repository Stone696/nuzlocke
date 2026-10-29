-- Gen 3 ADVANCED RULES / STATUS BANS.
-- Scope is determined by the *source* of the status, not its target.
return function()
    local M = { api = 1, schema = 1 }
    local STATUS = {
        { "status_paralysis_scope", "Paralysis" },
        { "status_confusion_scope", "Confusion" },
        { "status_sleep_scope", "Sleep Ban" },
        { "status_poison_scope", "Poison/Toxic" },
        { "status_burn_scope", "Burn Ban" },
        { "status_freeze_scope", "Freeze" },
    }
    local definitions = {
        { key="status_move_scope", label="No Status Moves",
            default=0,kind="scope",parent=true },
    }
    for _,entry in ipairs(STATUS) do
        definitions[#definitions+1]={key=entry[1],label=entry[2],
            default=0,kind="scope",child=true}
    end
    -- Sleep Clause is separate from both Sleep Ban and No Status Moves.
    -- Only sleep inflicted by the opposing side counts against the clause.
    definitions[#definitions+1]={key="sleep_clause",label="Sleep Clause",
        default=false,kind="toggle"}
    local byKey={}
    for _,d in ipairs(definitions) do byKey[d.key]=d end
    local LABELS={"OFF","SELF","ENEMY","ALL"}
    local EFFECT_KEY={
        PARALYSIS="status_paralysis_scope",PAR="status_paralysis_scope",
        CONFUSION="status_confusion_scope",
        SLEEP="status_sleep_scope",SLP="status_sleep_scope",
        POISON="status_poison_scope",PSN="status_poison_scope",
        TOXIC="status_poison_scope",TOX="status_poison_scope",
        BURN="status_burn_scope",BRN="status_burn_scope",
        FREEZE="status_freeze_scope",FRZ="status_freeze_scope",
    }
    function M.descriptors()
        local r={}
        for i,d in ipairs(definitions) do
            r[i]={key=d.key,label=d.label,default=d.default,
                kind=d.kind,status="working"}
        end
        return r
    end
    function M.get(s,key)
        if not byKey[key] then return nil end
        local rows=type(s)=="table" and s.statusBans or nil
        local v=type(rows)=="table" and rows[key] or nil
        if byKey[key].kind=="toggle" then return v==true end
        if type(v)=="number" and v>=0 and v<=3
            and v==math.floor(v) then return v end
        return 0
    end
    function M.set(s,key,value)
        if type(s) == "table" and s.runSettingsLocked == true and s._setup ~= true then
            return false, "run_settings_locked"
        end
        local def=byKey[key]
        if not def then return false,"not_implemented" end
        if type(s)~="table" then return false,"invalid_state" end
        if s.failed then return false,"run_failed" end
        if def.kind=="toggle" then
            if type(value)~="boolean" then return false,"boolean_required" end
        elseif type(value)~="number" or value~=math.floor(value)
            or value<0 or value>3 then return false,"invalid_scope" end
        if def.child and M.get(s,"status_move_scope")~=0 then
            return false,"parent_controls_children"
        end
        if type(s.statusBans)~="table" then s.statusBans={} end
        s.statusBans[key]=value
        if def.parent then
            -- The parent is a bulk setter, not an additional blanket ban
            -- on all non-damaging moves. A return to OFF resets its children
            -- to OFF; players may then configure children individually.
            for _,entry in ipairs(STATUS) do
                s.statusBans[entry[1]]=value
            end
        end
        return true
    end
    function M.next(s,key)
        local v=M.get(s,key)
        if v==nil then return nil end
        if type(v)=="boolean" then return not v end
        return (v+1)%4
    end
    function M.label(s,key)
        local v=M.get(s,key)
        if v==nil then return "UNKNOWN" end
        if type(v)=="boolean" then return v and "ON" or "OFF" end
        return LABELS[v+1]
    end
    function M.childKeys()
        local r={}
        for _,v in ipairs(STATUS) do r[#r+1]=v[1] end
        return r
    end
    function M.childrenHidden(s)
        return M.get(s,"status_move_scope")~=0
    end
    function M.applies(s,key,source,core)
        if not core or not core.active(s) then return false end
        local v=M.get(s,key)
        if not v or v==0 then return false end
        local side=type(source)=="table" and source.side or source
        if side~="player" and side~="enemy" then return false end
        return v==3 or (v==1 and side=="player")
            or (v==2 and side=="enemy")
    end
    -- Battle-local provenance: slot-indexed so a sleeping Pokemon still
    -- counts after being switched out. No engine save schema changes.
    local function sideOf(v)
        local side=type(v)=="table" and v.side or v
        if side=="player" or side=="enemy" then return side end
        return nil
    end
    function M.recordSleep(battle,target,source)
        if type(battle)~="table" or type(target)~="table" then return end
        local side=sideOf(target)
        local slot=tonumber(target.partyIndex)
        if not side or not slot or slot<1 or slot~=math.floor(slot) then
            return
        end
        battle._nuzSleepOrigins=battle._nuzSleepOrigins
            or {player={},enemy={}}
        local origins=battle._nuzSleepOrigins[side]
        if type(origins)~="table" then
            origins={}
            battle._nuzSleepOrigins[side]=origins
        end
        local sourceSide=sideOf(source)
        origins[slot]=sourceSide and sourceSide~=side and sourceSide or nil
    end
    function M.denySleepClause(s,source,target,battle,core)
        if not core or not core.active(s) or not M.get(s,"sleep_clause")
            or type(target)~="table" or type(battle)~="table" then
            return false
        end
        local from,to=sideOf(source),sideOf(target)
        local slot=tonumber(target.partyIndex)
        if not from or not to or from==to or not slot
            or slot<1 or slot~=math.floor(slot) then return false end
        local origins=battle._nuzSleepOrigins
        origins=type(origins)=="table" and origins[to] or nil
        if type(origins)~="table" then return false end
        local party=to=="player" and battle.playerParty or battle.foeParty
        if type(party)~="table" then return false end
        for i,mon in ipairs(party) do
            if i~=slot and origins[i]==from and type(mon)=="table"
                and (mon.status=="SLP" or mon.status=="SLEEP")
                and (tonumber(mon.hp) or 0)>0 then
                return true
            end
        end
        return false
    end
    function M.deny(s,effect,source,target,core)
        local key=EFFECT_KEY[effect]
        if not key then return false end
        -- Rest and other self-induced sleep are explicitly allowed.
        if (effect=="SLEEP" or effect=="SLP")
            and type(source)=="table" and source==target then
            return false
        end
        return M.applies(s,key,source,core)
    end
    return M
end
