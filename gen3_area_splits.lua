-- Gen 3 Advanced Rules: map identity/area splits.
-- Area identities are encounter ledger keys only; never rewrite session.map.
return function()
    local M={api=1,schema=1}
    local defs={
        {key="area_scope",label="Area Scope",kind="scope",default=0},
        {key="route_2_split",label="Route 2 North/South",kind="bool",default=false},
        {key="route_10_split",label="Route 10 North/South",kind="bool",default=false},
        {key="route_20_split",label="Route 20 West/East",kind="bool",default=false},
        {key="route_21_split",label="Route 21 North/South",kind="bool",default=false},
        {key="mt_moon_splits",label="Mt. Moon",kind="override",default=0},
        {key="safari_zone_splits",label="Safari Zone",kind="safari",default=0},
        {key="kanto_dungeon_splits",label="Kanto Dungeons",kind="override",default=0},
        {key="sevii_dungeon_splits",label="Sevii Dungeons",kind="override",default=0},
        {key="hoenn_dungeon_splits",label="Hoenn Dungeons",kind="override",default=0},
    }
    local indexes={}
    for _,d in ipairs(defs) do indexes[d.key]=d end
    local labels={
        scope={"NATIVE MAP","ONE/LOCATION","PER FLOOR"},
        override={"FOLLOW SCOPE","ONE LOCATION","PER FLOOR"},
        safari={"FOLLOW SCOPE","ONE ZONE","PER AREA","UNTIL CATCH","AREA + CATCH"}
    }
    -- Only named multi-map locations. This whitelist prevents unrelated
    -- buildings sharing a city/map section from becoming one encounter.
    local places={
        {id="MT_MOON",name="Mt. Moon",zone="kanto"},
        {id="ROCK_TUNNEL",name="Rock Tunnel",zone="kanto"},
        {id="SEAFOAM_ISLANDS",name="Seafoam Islands",zone="kanto"},
        {id="VICTORY_ROAD",name="Victory Road",zone="both"},
        {id="POKEMON_MANSION",name="Pokémon Mansion",zone="kanto"},
        {id="CERULEAN_CAVE",name="Cerulean Cave",zone="kanto"},
        {id="POKEMON_TOWER",name="Pokémon Tower",zone="kanto"},
        {id="DIGLETTS_CAVE",name="Diglett's Cave",zone="kanto"},
        {id="SILPH_CO",name="Silph Co.",zone="kanto"},
        {id="ROCKET_HIDEOUT",name="Rocket Hideout",zone="kanto"},
        {id="SSANNE",name="S.S. Anne",zone="kanto"},
        {id="MT_EMBER",name="Mt. Ember",zone="sevii"},
        {id="ICEFALL_CAVE",name="Icefall Cave",zone="sevii"},
        {id="DOTTED_HOLE",name="Dotted Hole",zone="sevii"},
        {id="LOST_CAVE",name="Lost Cave",zone="sevii"},
        {id="NAVEL_ROCK",name="Navel Rock",zone="sevii"},
        {id="METEOR_FALLS",name="Meteor Falls",zone="hoenn"},
        {id="GRANITE_CAVE",name="Granite Cave",zone="hoenn"},
        {id="SHOAL_CAVE",name="Shoal Cave",zone="hoenn"},
        {id="MT_PYRE",name="Mt. Pyre",zone="hoenn"},
        {id="CAVE_OF_ORIGIN",name="Cave of Origin",zone="hoenn"},
        {id="SEAFLOOR_CAVERN",name="Seafloor Cavern",zone="hoenn"},
        {id="SKY_PILLAR",name="Sky Pillar",zone="hoenn"},
        {id="NEW_MAUVILLE",name="New Mauville",zone="hoenn"},
        {id="FIERY_PATH",name="Fiery Path",zone="hoenn"},
        {id="ABANDONED_SHIP",name="Abandoned Ship",zone="hoenn"},
        {id="MIRAGE_TOWER",name="Mirage Tower",zone="hoenn"},
        {id="DESERT_RUINS",name="Desert Ruins",zone="hoenn"},
        {id="ISLAND_CAVE",name="Island Cave",zone="hoenn"},
        {id="ANCIENT_TOMB",name="Ancient Tomb",zone="hoenn"},
        {id="AQUA_HIDEOUT",name="Aqua Hideout",zone="hoenn"},
        {id="MAGMA_HIDEOUT",name="Magma Hideout",zone="hoenn"},
        {id="ARTISAN_CAVE",name="Artisan Cave",zone="hoenn"},
        {id="DESERT_UNDERPASS",name="Desert Underpass",zone="hoenn"},
        {id="MARINE_CAVE",name="Marine Cave",zone="hoenn"},
        {id="TERRA_CAVE",name="Terra Cave",zone="hoenn"},
        {id="ALTERING_CAVE",name="Altering Cave",zone="sevii"},
    }
    local names={ROUTE_2="Route 2",ROUTE_10="Route 10",
        ROUTE_20="Route 20",ROUTE_21="Route 21",
        SAFARI_ZONE="Safari Zone"}
    for _,place in ipairs(places) do names[place.id]=place.name end
    local function data(s)
        if type(s.areaSplitRules)~="table" then s.areaSplitRules={} end
        return s.areaSplitRules
    end
    function M.descriptors()
        local out={}
        for i,d in ipairs(defs) do out[i]={key=d.key,label=d.label,
            default=d.default,status="working",kind=d.kind} end
        return out
    end
    function M.get(s,key)
        local d=indexes[key]
        if not d or type(s)~="table" then return nil end
        local v=data(s)[key]
        if d.kind=="bool" then return v==true end
        local max=d.kind=="scope" and 2 or
            d.kind=="override" and 2 or 4
        if type(v)~="number" or v~=math.floor(v)
            or v<0 or v>max then return d.default end
        return v
    end
    function M.set(s,key,v)
        if type(s) == "table" and s.runSettingsLocked == true and s._setup ~= true then
            return false, "run_settings_locked"
        end
        local d=indexes[key]
        if not d then return false,"not_implemented" end
        if type(s)~="table" then return false,"invalid_state" end
        if s.failed then return false,"run_failed" end
        if d.kind=="bool" then
            if type(v)~="boolean" then return false,"boolean_required" end
        else
            local max=d.kind=="safari" and 4 or 2
            if type(v)~="number" or v~=math.floor(v)
                or v<0 or v>max then return false,"invalid_mode" end
        end
        data(s)[key]=v
        return true
    end
    function M.next(s,key)
        local d=indexes[key]
        if not d then return nil end
        local v=M.get(s,key)
        if d.kind=="bool" then return not v end
        return (v+1)%(d.kind=="safari" and 5 or 3)
    end
    function M.label(s,key)
        local d=indexes[key]
        if not d then return "UNKNOWN" end
        local v=M.get(s,key)
        if d.kind=="bool" then return v and "ON" or "OFF" end
        return labels[d.kind][v+1]
    end
    local function canonical(mapId)
        if type(mapId)~="string" or mapId=="" then return nil end
        local prefix,body=mapId:match("^([A-Z]+)_(.+)$")
        if prefix=="FR" or prefix=="SEVII" then return "FR",body end
        if prefix=="EM" or prefix=="RU" or prefix=="SA" then
            return prefix,body
        end
        return nil
    end
    local function matchPlace(body,place)
        if body==place.id or body:sub(1,#place.id+1)==place.id.."_" then
            return true
        end
        -- Sevii maps carry the island prefix (e.g.
        -- FR_FOUR_ISLAND_ICEFALL_CAVE_B1F).
        return body:find("_"..place.id.."_",1,true)~=nil
    end
    function M.describe(mapId)
        local edition,body=canonical(mapId)
        if not edition then return nil end
        local safari=body:match("^SAFARI_ZONE_([A-Z]+)$")
        if safari=="ENTRANCE" or safari=="REST_HOUSE" then
            safari=nil
        end
        if safari then
            return {edition=edition,group="SAFARI_ZONE",
                floor=safari,zone=edition=="FR" and "kanto" or "hoenn",
                safari=true,raw=mapId}
        end
        if edition=="FR" and (body=="ROUTE_21_NORTH" or body=="ROUTE_21_SOUTH") then
            return {edition=edition,group="ROUTE_21",
                floor=body:match("_([A-Z]+)$"),zone="kanto",
                raw=mapId,route=true}
        end
        for _,place in ipairs(places) do
            if ((edition=="FR" and place.zone~="hoenn") or
                (edition~="FR" and (place.zone=="hoenn"
                    or place.zone=="both")))
                and matchPlace(body,place) then
                local _,at=body:find(place.id,1,true)
                local suffix=body:sub((at or #body)+1)
                local floor=suffix:match("_([B]?[0-9]+F)")
                    or suffix:match("^_(ROOF)")
                    or suffix:match("^_(BASE)")
                    or suffix:match("^_(SUMMIT)")
                    or suffix:match("^_(EXTERIOR)")
                    or suffix:match("^_(LOW_TIDE)")
                    or suffix:match("^_(HIGH_TIDE)")
                    or "MAIN"
                return {edition=edition,group=place.id,
                    floor=floor,zone=place.zone=="both" and
                        (edition=="FR" and "kanto" or "hoenn")
                        or place.zone,raw=mapId}
            end
        end
        return nil
    end
    local function selection(s,d)
        local mode=M.get(s,"area_scope")
        local key=d.zone=="kanto" and "kanto_dungeon_splits"
            or d.zone=="sevii" and "sevii_dungeon_splits"
            or "hoenn_dungeon_splits"
        if d.group=="MT_MOON" then
            local specific=M.get(s,"mt_moon_splits")
            if specific~=0 then return specific end
        end
        local override=M.get(s,key)
        if override~=0 then return override end
        return mode
    end
    -- For route splits, use the physical map's midline. Explicit split
    -- mode refuses to invent a position/dimension when unavailable.
    local routeAxis={ROUTE_2="y",ROUTE_10="y",ROUTE_20="x"}
    local function routeHalf(body,p)
        local axis=routeAxis[body]
        if not axis or type(p)~="table" then return nil end
        local size=tonumber(p[axis=="x" and "width" or "height"])
        local coord=tonumber(p[axis])
        if not size or size<2 or not coord
            or coord<0 or coord>=size then return nil end
        if axis=="x" then return coord<size/2 and "WEST" or "EAST" end
        return coord<size/2 and "NORTH" or "SOUTH"
    end
    function M.resolve(s,core,mapId,position)
        if not (core and core.active(s)) or type(mapId)~="string" then
            return mapId
        end
        local edition,body=canonical(mapId)
        if not edition then return mapId end
        local axis=routeAxis[body]
        if edition=="FR" and axis
            and M.get(s,"route_"..body:match("%d+").."_split") then
            local half=routeHalf(body,position)
            if half then return "SPLIT:FR:"..body..":"..half end
        end
        local d=M.describe(mapId)
        if not d then return mapId end
        if d.route then
            if M.get(s,"route_21_split")
                or M.get(s,"area_scope")==0 then return mapId end
            return "SPLIT:"..edition..":ROUTE_21"
        end
        if d.safari then
            local mode=M.get(s,"safari_zone_splits")
            if mode==1 or mode==3 then
                return "SPLIT:"..edition..":SAFARI_ZONE"
            end
            if mode==2 or mode==4 then
                return "SPLIT:"..edition..":SAFARI_ZONE:"..d.floor
            end
            -- FOLLOW SCOPE: native / shared / named Safari section.
            local base=M.get(s,"area_scope")
            if base==0 then return mapId end
            if base==1 then return "SPLIT:"..edition..":SAFARI_ZONE" end
            return "SPLIT:"..edition..":SAFARI_ZONE:"..d.floor
        end
        local mode=selection(s,d)
        if mode==0 then return mapId end
        local prefix="SPLIT:"..edition..":"..d.group
        return mode==1 and prefix or prefix..":"..d.floor
    end
    function M.safariUntilCatch(s,core,mapId)
        if not (core and core.active(s)) then return false end
        local d=M.describe(mapId)
        if not d or not d.safari then return false end
        local mode=M.get(s,"safari_zone_splits")
        return mode==3 or mode==4
    end
    local function infoOf(key)
        if type(key)~="string" then return nil end
        if key:sub(1,6)=="SPLIT:" then
            local edition,group,floor=
                key:match("^SPLIT:([^:]+):([^:]+):?(.*)$")
            if edition and group then
                return {edition=edition,group=group,
                    floor=floor~="" and floor or nil,synthetic=true}
            end
            return nil
        end
        return M.describe(key)
    end
    local function sameGroup(a,b)
        return a and b and a.edition==b.edition and a.group==b.group
    end
    -- Historical map IDs remain immutable; project earlier encounters
    -- into new scope so switching modes cannot reset spent encounters.
    function M.catchAllowed(s,core,key,raw)
        if not (core and core.enforced(s,"encounter_limit")) then
            return true
        end
        local areas=type(s)=="table" and s.areas or {}
        if core.areaSpent(areas[key]) then return false end
        local current=infoOf(key) or infoOf(raw)
        if not current then
            -- If a previously split Route 2/10/20 becomes unsplit,
            -- neither previously captured half may be caught again.
            if key==raw and raw and raw:match("^FR_ROUTE_%d+$") then
                local prefix="SPLIT:FR:"..raw:sub(4)..":"
                for history,entry in pairs(areas) do
                    if history:sub(1,#prefix)==prefix
                        and core.areaSpent(entry) then return false end
                end
            end
            return not core.areaSpent(areas[raw])
        end
        local groupKey="SPLIT:"..current.edition..":"..current.group
        if core.areaSpent(areas[groupKey]) then return false end
        local isGroup=key==groupKey
        local isNative=key==raw
        local currentFloor=(infoOf(key) or {}).floor
            or (infoOf(raw) or {}).floor
        for history,entry in pairs(areas) do
            if core.areaSpent(entry) and history~=key then
                local prev=infoOf(history)
                if sameGroup(current,prev) then
                    if isGroup or prev.synthetic and not prev.floor
                        or (not isNative and currentFloor==prev.floor)
                        or (isNative and
                            (history==raw or (prev.synthetic
                                and prev.floor==currentFloor))) then
                        return false
                    end
                end
            end
        end
        -- A pre-split single-map claim blocks both route halves.
        if key~=raw and core.areaSpent(areas[raw]) then return false end
        if key==raw and raw and raw:match("^FR_ROUTE_%d+$") then
            local group="SPLIT:FR:"..raw:sub(4)..":"
            for history,entry in pairs(areas) do
                if history:sub(1,#group)==group
                    and core.areaSpent(entry) then return false end
            end
        end
        return true
    end
    function M.name(key,fallback)
        if type(key)~="string" then return "Unknown location" end
        local d=infoOf(key)
        if d then
            local title=names[d.group] or d.group
            if d.floor and d.floor~="MAIN" then
                return title.." - "..d.floor:gsub("_"," ")
            end
            return title
        end
        if type(fallback)=="function" then return fallback(key) end
        return key
    end
    return M
end
