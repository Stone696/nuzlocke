-- Gen 3 Game Difficulty: battle-local trainer scaling.
-- Stable IDs 0..15 mirror the legacy selector range, but profiles are
-- explicitly Gen 3 EV/IV/AI presets, not a copy of Gen 1/2 Stat EXP.
-- Never mutate ROM trainer templates or player Pokemon.
return function()
    local M={api=1,schema=1}
    local p={
        {id=0, name="VANILLA",       normal=0,boss=0, iv=0,ev=0,ai=0},
        {id=1, name="NUZ MEDIUM",    normal=1,boss=2, iv=8,ev=16,ai=1},
        {id=2, name="NUZ HARD",      normal=2,boss=4, iv=16,ev=32,ai=2},
        {id=3, name="NUZ EXPERT",    normal=3,boss=6, iv=24,ev=48,ai=3},
        {id=4, name="NUZ MASTER",    normal=5,boss=8, iv=31,ev=64,ai=4},
        {id=5, name="BOSS MEDIUM",   normal=0,boss=3, iv=8,ev=16,ai=1,bossOnly=true},
        {id=6, name="BOSS HARD",     normal=0,boss=5, iv=16,ev=32,ai=2,bossOnly=true},
        {id=7, name="BOSS EXPERT",   normal=0,boss=7, iv=24,ev=48,ai=3,bossOnly=true},
        {id=8, name="BOSS MASTER",   normal=0,boss=10,iv=31,ev=64,ai=4,bossOnly=true},
        {id=9, name="TACTIC MEDIUM", normal=0,boss=0, iv=8,ev=0,ai=1},
        {id=10,name="TACTIC HARD",   normal=0,boss=0, iv=16,ev=0,ai=2},
        {id=11,name="TACTIC EXPERT", normal=0,boss=0, iv=24,ev=0,ai=3},
        {id=12,name="TACTIC MASTER", normal=0,boss=0, iv=31,ev=0,ai=4},
        {id=13,name="FULL MEDIUM",   normal=2,boss=4, iv=16,ev=32,ai=2},
        {id=14,name="FULL HARD",     normal=4,boss=7, iv=24,ev=48,ai=3},
        {id=15,name="FULL MASTER",   normal=6,boss=10,iv=31,ev=85,ai=4},
    }
    local keys={"hp","atk","def","spa","spd","spe"}
    local function data(s)
        if type(s.difficultyRules)~="table" then s.difficultyRules={} end
        return s.difficultyRules
    end
    function M.descriptors()
        return {{key="difficulty_profile",label="Game Difficulty",
            kind="profile",default=0,status="working"}}
    end
    function M.get(s,key)
        if key~="difficulty_profile" or type(s)~="table" then return nil end
        local v=data(s).difficulty_profile
        if type(v)~="number" or v~=math.floor(v)
            or v<0 or v>15 then return 0 end
        return v
    end
    function M.set(s,key,v)
        if type(s) == "table" and s.runSettingsLocked == true and s._setup ~= true then
            return false, "run_settings_locked"
        end
        if key~="difficulty_profile" then return false,"not_implemented" end
        if type(s)~="table" then return false,"invalid_state" end
        if s.failed then return false,"run_failed" end
        if type(v)~="number" or v~=math.floor(v) or v<0 or v>15 then
            return false,"invalid_profile"
        end
        data(s).difficulty_profile=v
        return true
    end
    function M.next(s,key)
        local v=M.get(s,key)
        return v and (v+1)%16 or nil
    end
    function M.profile(s)
        return p[M.get(s,"difficulty_profile")+1]
    end
    function M.label(s,key)
        local v=M.get(s,key)
        if v==nil then return "UNKNOWN" end
        return p[v+1].name
    end
    function M.active(s)
        return type(s)=="table" and M.get(s,"difficulty_profile")>0
    end
    local function copy(src)
        local dst={}
        for k,v in pairs(src) do dst[k]=v end
        return dst
    end
    local function boss(foe,opts,trainers)
        local name=opts.trainerClassName
            or (foe and foe.trainerClassName)
        if (not name or name=="") and trainers and trainers.get then
            local id=opts.trainerId or (foe and foe.trainerId)
            if id then
                local ok,row=pcall(trainers.get,id)
                if ok and type(row)=="table" then name=row.className end
            end
        end
        if type(name)~="string" then return false end
        local upper=name:upper():gsub("%s+","_")
        -- Match whole class tokens, not ordinary names such as
        -- TEAM_AQUA or BATTLE_GIRL. RIVALS are bosses but their
        -- species identities never change.
        return upper=="LEADER" or upper=="GYM_LEADER"
            or upper=="TRAINER_CLASS_LEADER"
            or upper=="TRAINER_CLASS_RS_LEADER"
            or upper:find("ELITE_FOUR",1,true)~=nil
            or upper:find("CHAMPION",1,true)~=nil
            or upper:find("RIVAL",1,true)~=nil
            or upper=="BOSS" or upper=="TRAINER_CLASS_BOSS"
            or upper:find("MAGMA_LEADER",1,true)~=nil
            or upper:find("AQUA_LEADER",1,true)~=nil
    end
    M.isBoss=boss
    local function supported(opts)
        if type(opts)~="table" or opts.wild or opts.link
            or opts.recordedLink or opts.safari or opts.roamer
            or opts.firstBattle or opts.firstBattleKind
            or opts.oldManTutorial or opts.tutorialKind
            or opts.pokedude or opts.battleTower or opts.frontier
            or opts.trainerTower or opts.eReader or opts.secretBase
            or opts.trainerHill or opts.pyramid or opts.pike
            or opts.linkParty or opts.twoOpponents
            or (opts.foe and opts.foe.link) then return false end
        -- Explicitly-owned difficulty providers can veto our scale,
        -- avoiding double boosts when they annotate the battle.
        if opts.difficultyProvider or opts.externalDifficulty
            or (type(opts.foe)=="table"
                and (opts.foe.difficultyProvider
                    or opts.foe.externalDifficulty)) then return false end
        return (type(opts.foe)=="table"
            and (type(opts.foe.party)=="table" or opts.foe.species))
            or type(opts.foeParty)=="table"
    end
    M.supported=supported
    local function mergeBits(a,b)
        local result,bit=0,1
        a=math.floor(tonumber(a) or 0)
        b=math.floor(tonumber(b) or 0)
        for _=1,32 do
            local x,y=a%2,b%2
            if x==1 or y==1 then result=result+bit end
            a=math.floor(a/2)
            b=math.floor(b/2)
            bit=bit*2
        end
        return result
    end
    -- Pokemon engine uses variant-specific AI script bit positions.
    -- Avoid blindly ORing the FRLG flags into Emerald's different
    -- CHECK_VIABILITY / TRY_TO_FAINT order.
    local bits={
        frlg={bad=0,viability=1,faint=2,setup=3,strong=5,hp=8},
        rs={bad=0,viability=1,faint=2,setup=3,strong=5,hp=8},
        emerald={bad=0,viability=2,faint=1,setup=3,strong=5,hp=8},
    }
    local function family(native)
        local id=type(native)=="table"
            and (native.version or native.edition or native.gameId)
        id=type(id)=="string" and id:lower() or ""
        if id=="emerald" or id=="em" then return "emerald" end
        if id=="ruby" or id=="sapphire" or id=="ru" or id=="sa"
            or id=="rs" then return "rs" end
        if id=="firered" or id=="leafgreen" or id=="fr" or id=="lg"
            or id=="frlg" then return "frlg" end
        return nil
    end
    M.family=family
    function M.aiMask(native,tier)
        local map=bits[family(native) or ""]
        if not map or tier<1 then return 0 end
        local mask=2^map.bad
        if tier>=2 then
            mask=mergeBits(mask,2^map.viability+2^map.faint)
        end
        if tier>=3 then mask=mergeBits(mask,2^map.strong) end
        if tier>=4 then
            mask=mergeBits(mask,2^map.setup+2^map.hp)
        end
        return mask
    end
    local function adjust(mon,profile,levels)
        if type(mon)~="table" then return mon end
        local out=copy(mon)
        local changed=false
        local lv=tonumber(mon.level)
        if levels>0 and lv and lv>=1 and lv<=100 then
            out.level=math.min(100,math.max(1,math.floor(lv)+levels))
            changed=out.level~=lv
        end
        if profile.iv>0 then
            local ivs=type(mon.ivs)=="table" and copy(mon.ivs) or {}
            for _,k in ipairs(keys) do
                local raw=tonumber(ivs[k] or mon.iv)
                ivs[k]=math.min(31,math.max(profile.iv,
                    raw and math.floor(raw) or 0))
            end
            out.ivs=ivs
            changed=true
        end
        if profile.ev>0 then
            local evs=type(mon.evs)=="table" and copy(mon.evs) or {}
            for _,k in ipairs(keys) do
                local ev=tonumber(evs[k]) or 0
                evs[k]=math.min(255,math.max(profile.ev,math.floor(ev)))
            end
            local sum=0
            for _,k in ipairs(keys) do sum=sum+evs[k] end
            -- Unusual custom EV providers might already exceed the native
            -- 510 cap; in that case do NOT invent an illegal spread.
            if sum<=510 then out.evs=evs;changed=true end
        end
        if changed then
            -- Native foe_mon_from picks the final personality/nature
            -- after we modify descriptors. Never use cached stats.
            for _,k in ipairs({"hp","maxHp","attack","defense","speed",
                "spAtk","spDef","atk","def","spa","spd","spe"}) do
                out[k]=nil
            end
        end
        return out
    end
    local function buffParty(party,profile,levels)
        if type(party)~="table" or #party==0 then return party end
        local out={}
        for i,mon in ipairs(party) do
            out[i]=adjust(mon,profile,levels)
        end
        return out
    end
    function M.prepare(s,opts,native,trainers)
        if not M.active(s) or not supported(opts) then return opts end
        local pr=M.profile(s)
        local isBoss=boss(opts.foe,opts,trainers)
        if pr.bossOnly and not isBoss then return opts end
        local delta=isBoss and pr.boss or pr.normal
        local out=copy(opts)
        local foe=opts.foe
        if type(foe)=="table" then
            out.foe=adjust(foe,pr,delta)
            if type(foe.party)=="table" then
                out.foe.party=buffParty(foe.party,pr,delta)
                local lead=out.foe.party[1]
                -- Keep top-level lead in sync for transitions; do not
                -- touch species, held items or explicit move sets.
                if lead then out.foe.level=lead.level end
            end
        end
        if type(opts.foeParty)=="table" then
            out.foeParty=buffParty(opts.foeParty,pr,delta)
        end
        local mask=M.aiMask(native,pr.ai)
        if mask>0 then
            local flags=out.aiFlags or (foe and foe.aiFlags)
            if flags==nil and trainers and trainers.get then
                local tid=opts.trainerId or (foe and foe.trainerId)
                if tid then
                    local ok,info=pcall(trainers.get,tid)
                    if ok and type(info)=="table" then
                        flags=info.aiFlags
                    end
                end
            end
            out.aiFlags=mergeBits(flags,mask)
        end
        return out
    end
    return M
end
