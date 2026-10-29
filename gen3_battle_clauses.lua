-- Gen 3 ADVANCED RULES / BATTLE CLAUSES.
-- Disable only move-caused secondary effects; preserve native damage, PP,
-- targeting, field/status handling, abilities and held-item ownership.
return function()
    local M = { api = 1, schema = 1 }
    local definitions = {
        -- Prevents the four native one-hit KO moves for both sides.
        { key="ohko_clause", label="OHKO Clause",
          default=false, kind="toggle" },
        { key="flinch_clause_scope", label="Flinch Clause",
          default=0, kind="scope" },
        { key="trap_clause_scope", label="Trap Clause",
          default=0, kind="scope" },
        { key="setup_move_scope", label="No Setup Moves",
          default=0, kind="scope" },
        { key="evasion_clause", label="Evasion Clause",
          default=false, kind="toggle" },
        { key="status_accuracy_scope", label="Accuracy Drops",
          default=0, kind="scope" },
        { key="other_stat_drop_scope", label="Other Stat Drops",
          default=0, kind="scope" },
    }
    local labels = {"OFF","SELF","ENEMY","ALL"}
    local byKey = {}
    for _,d in ipairs(definitions) do byKey[d.key]=d end

    function M.descriptors()
        local result = {}
        for i,d in ipairs(definitions) do
            result[i] = {key=d.key,label=d.label,kind=d.kind,
                default=d.default,status="working"}
        end
        return result
    end
    function M.get(s,key)
        local d = byKey[key]
        if not d then return nil end
        local v = type(s)=="table" and type(s.battleClauses)=="table"
            and s.battleClauses[key] or nil
        if d.kind=="toggle" then
            return type(v)=="boolean" and v or false
        end
        return type(v)=="number" and v>=0 and v<=3
            and v==math.floor(v) and v or 0
    end
    function M.set(s,key,v)
        if type(s) == "table" and s.runSettingsLocked == true and s._setup ~= true then
            return false, "run_settings_locked"
        end
        local d = byKey[key]
        if not d then return false,"not_implemented" end
        if type(s)~="table" then return false,"invalid_state" end
        if s.failed then return false,"run_failed" end
        if d.kind=="toggle" then
            if type(v)~="boolean" then return false,"boolean_required" end
        elseif type(v)~="number" or v<0 or v>3 or v~=math.floor(v) then
            return false,"invalid_scope"
        end
        s.battleClauses=s.battleClauses or {}
        s.battleClauses[key]=v
        return true
    end
    function M.label(s,key)
        local d=byKey[key]
        if not d then return "UNKNOWN" end
        local v=M.get(s,key)
        return d.kind=="toggle" and (v and "ON" or "OFF")
            or labels[v+1]
    end
    function M.next(s,key)
        local d=byKey[key]
        if not d then return nil end
        local v=M.get(s,key)
        if d.kind=="toggle" then return not v end
        return (v+1)%4
    end
    function M.applies(s,key,userSide,core)
        if not core or not core.active(s) then return false end
        local scope=M.get(s,key)
        if scope==nil then return false end
        if type(scope)=="boolean" then return scope end
        local side=type(userSide)=="table" and userSide.side or userSide
        if scope==3 then return side=="player" or side=="enemy" end
        return (scope==1 and side=="player")
            or (scope==2 and side=="enemy") or false
    end
    function M.denyOHKO(s,userSide,core)
        local side=type(userSide)=="table" and userSide.side or userSide
        if side~="player" and side~="enemy" then return false end
        return M.applies(s,"ohko_clause",side,core)
    end
    function M.denyEffect(s,effect,userSide,core)
        if effect=="FLINCH" and M.applies(s,"flinch_clause_scope",userSide,core)
            then return true end
        if effect=="WRAP" and M.applies(s,"trap_clause_scope",userSide,core)
            then return true end
        return false
    end
    function M.denyStat(s,stat,delta,userSide,core)
        if type(delta)~="number" or delta==0 then return false end
        if delta>0 then
            return (stat=="evasion"
                and M.applies(s,"evasion_clause",userSide,core))
                or M.applies(s,"setup_move_scope",userSide,core)
        end
        return (stat=="accuracy"
            and M.applies(s,"status_accuracy_scope",userSide,core))
            or (stat~="accuracy"
                and M.applies(s,"other_stat_drop_scope",userSide,core))
            or false
    end
    return M
end
