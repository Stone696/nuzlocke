-- Gen 3 terminal run-results UI: native 240x160 presentation,
-- plus a single dynamic-height results poster using native Pokemon sprites.
return function()
    local M={isMenu=true}
    local ID="nuzlocke.gen3.results"
    local result,game,opts,stack,pages={},nil,{},nil,{}
    local function present(title,rows)
        pages[#pages+1]={title=title,rows=rows,index=1,scroll=0}
    end
    local function active()return pages[#pages] end
    local function row(label,fn)
        return {label=tostring(label or ""),action=fn}
    end
    local function text(v)
        local s=tostring(v==nil and "?" or v)
        return s
    end
    local function entries(mode)
        return mode=="party" and (result.party or {})
            or (result.graveyard or {})
    end
    -- Resolve late-bound display labels for older terminal saves too.
    -- A save made before National Dex integration may retain only the base
    -- species name; never rewrite the frozen result or nickname.
    local function speciesLabel(mon)
        local display=opts and opts.display
        if display and type(display.speciesName)=="function" then
            local ok,name=pcall(display.speciesName,mon)
            if ok and type(name)=="string" and name~="" then return name end
        end
        return mon.speciesName or "Unknown Pokémon"
    end
    local function pokemonLabel(mon)
        local display=opts and opts.display
        if display and type(display.pokemonName)=="function" then
            local ok,name=pcall(display.pokemonName,mon)
            if ok and type(name)=="string" and name~="" then return name end
        end
        return mon.name or mon.nickname or speciesLabel(mon)
    end
    local function formatMon(mon)
        return text(pokemonLabel(mon)).." Lv"..text(mon.level)
    end
    local function detail(mon)
        local rows={
            row("NAME: "..text(pokemonLabel(mon))),
            row("SPECIES: "..text(speciesLabel(mon))),
            row("LEVEL: "..text(mon.level)),
            row("SHINY: "..(mon.shinyKnown==true
                and (mon.shiny==true and "YES" or "NO") or "UNKNOWN")),
            row("HP: "..text(mon.hp).."/"..text(mon.maxHp)),
            row("ATK/DEF: "..text(mon.attack).."/"..text(mon.defense)),
            row("SPA/SPD: "..text(mon.spAttack).."/"..text(mon.spDefense)),
            row("SPEED: "..text(mon.speed)),
        }
        if mon.area then rows[#rows+1]=row("LOST: "..text(mon.area)) end
        if mon.cause then rows[#rows+1]=row("CAUSE: "..mon.cause) end
        if mon.ability then rows[#rows+1]=row("ABILITY ID: "..text(mon.ability)) end
        if mon.nature then rows[#rows+1]=row("NATURE: "..text(mon.nature)) end
        if type(mon.moves)=="table" then
            local moveNames={}
            local ok,Pokemon=pcall(require,"src.core.game3.pokemon")
            for _,mv in ipairs(mon.moves) do
                local id=type(mv)=="table" and (mv.id or mv.move) or mv
                local move=ok and Pokemon and Pokemon.moveName and Pokemon.moveName(id)
                moveNames[#moveNames+1]=move or text(id)
            end
            if #moveNames>0 then rows[#rows+1]=row("MOVES: "..table.concat(moveNames,",")) end
        end
        present("POKEMON RECORD",rows)
    end
    local function roster(mode)
        local members=entries(mode)
        local rows={}
        for i,mon in ipairs(members) do
            local picked=mon
            rows[#rows+1]=row(i..". "..formatMon(mon),function()
                detail(picked)
            end)
        end
        if #rows==0 then rows[1]=row("NO POKEMON RECORDED") end
        present(mode=="party" and "FINAL PARTY" or "IN MEMORIAM",rows)
    end
    local function stats()
        local rows={
            row("RESULT: "..text(result.outcome)),
            row("TIME: "..text(result.playtime)),
            row("BADGES: "..text(result.badges)),
            row("AREAS: "..text(result.encounters)),
            row("CATCHES: "..text(result.caught)),
            row("USED SLOTS: "..text(result.spent)),
            row("DEATHS: "..text(result.deaths)),
            row("SHINY EXCEPTIONS: "..text(result.shinyExceptions)),
            row("REGION: "..text(result.version)),
            row("ENDED: "..text(result.date)),
            row("REASON: "..text(result.reason)),
        }
        present("RUN STATISTICS",rows)
    end
    -- Optional native sprite; the share card is still useful if the ROM
    -- assets are not yet available (e.g. isolated test environment).
    local function drawSprite(g,mon,x,y)
        -- Use the actual saved species slot. National Dex stores regional and
        -- other alternate forms in independent slots; remapping to the base
        -- Pokedex number gives the wrong creature.
        local id=tonumber(mon.species)
        if not id then return end
        local ok,Pokemon=pcall(require,"src.core.game3.pokemon")
        if not ok or type(Pokemon)~="table" then return end
        local personality=tonumber(mon.personality) or 0
        local source={
            species=id,personality=personality,level=mon.level,
            speciesNumbering=mon.speciesNumbering,
            otId=mon.otId,otSecretId=mon.otSecretId,
            form=mon.form,formId=mon.formId,
        }
        local known=mon.shinyKnown==true
        if known then source.isShiny=mon.shiny==true end
        local pic=nil
        local function valid(candidate)
            return type(candidate)=="table" and candidate.image~=nil
        end
        local function native(species,form)
            if type(Pokemon.frontPic)~="function" then return nil end
            local good,candidate=pcall(Pokemon.frontPic,species,form,
                known and (mon.shiny==true) or false,personality,"hof",source)
            return good and valid(candidate) and candidate or nil
        end
        local visual=opts and opts.shinyVisuals
        local function romShiny()
            if not (known and mon.shiny==true and visual
                and type(visual.front)=="function") then return nil end
            local good,candidate=pcall(visual.front,Pokemon,source)
            return good and valid(candidate) and candidate or nil
        end
        -- Legacy records without a trustworthy shiny flag must let the
        -- engine resolve the Pokemon's real OT/personality (and any form).
        -- Never silently label an unknown as a confirmed normal sprite.
        if not known and type(Pokemon.monFrontPic)=="function" then
            local good,candidate=pcall(Pokemon.monFrontPic,source,nil,"hof")
            if good and valid(candidate) then pic=candidate end
        end
        -- The base-ROM extracted RGBA is only useful for base species.
        -- Extended slots and variant artwork belong to the active sprite
        -- provider (e.g. G9), which also supplies proper shiny sheets.
        if not pic then
            if id>440 then
                pic=native(id,mon.form)
                if not pic then pic=romShiny() end
            else
                pic=romShiny()
                if not pic then
                    local resolved,form=id,mon.form
                    if form==nil and type(Pokemon.picSpecies)=="function" then
                        local good,r,f=pcall(Pokemon.picSpecies,id,personality)
                        if good and tonumber(r) then resolved=r; form=f end
                    end
                    pic=native(resolved,form)
                end
            end
        end
        if not pic and type(Pokemon.monFrontPic)=="function" then
            local good,candidate=pcall(Pokemon.monFrontPic,source,nil,"hof")
            if good and valid(candidate) then pic=candidate end
        end
        if pic then
            local w,h=tonumber(pic.w) or 64,tonumber(pic.h) or 64
            if w<=0 or h<=0 then return end
            local scale=math.min(90/w,90/h)
            g.setColor(1,1,1,1)
            g.draw(pic.image,x+(90-w*scale)/2,y,0,scale,scale)
        end
    end

    -- A whole-run image, not six-Pokemon pages. Both the surviving party
    -- and every recorded death are present, even after a failed run.
    local WIDTH,EDGE,GAP=1200,42,14
    local CARD_W,CARD_H=362,190
    local ROW_STEP=204
    local function layout()
        local party=result.party or {}
        local dead=result.graveyard or {}
        local partyY=282
        local partyRows=math.max(1,math.ceil(#party/3))
        local gravesY=partyY+58+partyRows*ROW_STEP+30
        local graveRows=math.max(1,math.ceil(#dead/3))
        local height=gravesY+58+graveRows*ROW_STEP+68
        return partyY,gravesY,height
    end
    function M.posterDimensions(record)
        local previous=result
        if record then result=record end
        local _,_,height=layout()
        if record then result=previous end
        return WIDTH,height
    end
    local function clip(font,value,maxWidth)
        local str=tostring(value or "")
        if font and type(font.getWidth)=="function" then
            if font:getWidth(str)<=maxWidth then return str end
            while #str>0 and font:getWidth(str.."...")>maxWidth do
                str=str:sub(1,-2)
            end
            return str.."..."
        end
        local maxChars=math.max(3,math.floor(maxWidth/8))
        return #str>maxChars and str:sub(1,maxChars-3).."..." or str
    end
    local function exportImage()
        -- Sandbox blocks love.filesystem. ImageData:encode(path) writes
        -- into the LÖVE save directory without a filesystem permission.
        if not (love and love.graphics and love.graphics.newCanvas) then
            return false,"PNG EXPORT UNAVAILABLE"
        end
        local g=love.graphics
        local party=result.party or {}
        local graveyard=result.graveyard or {}
        local partyY,gravesY,height=layout()
        local limits=type(g.getSystemLimits)=="function"
            and g.getSystemLimits() or nil
        local maximum=type(limits)=="table"
            and tonumber(limits.texturesize) or 8192
        if WIDTH>maximum or height>maximum then
            return false,"Poster exceeds this device's maximum image size"
                .." ("..WIDTH.."x"..height..")."
        end
        local pushed=false
        local ok,filename=pcall(function()
            local canvas=g.newCanvas(WIDTH,height)
            g.push("all")
            pushed=true
            g.setCanvas(canvas)
            g.clear(.035,.06,.12,1)
            local accent=result.outcome=="VICTORY"
                and {.18,.68,.49} or {.72,.30,.39}
            local gold={.97,.78,.38}
            local main=g.newFont(38)
            local section=g.newFont(24)
            local body=g.newFont(18)
            local small=g.newFont(15)
            local statFont=g.newFont(22)
            local function color(rgb,alpha)
                g.setColor(rgb[1],rgb[2],rgb[3],alpha or 1)
            end
            local function write(font,str,x,y,rgb,maxWidth)
                g.setFont(font)
                color(rgb or {1,1,1})
                g.print(clip(font,str,maxWidth or WIDTH-2*EDGE),x,y)
            end
            local muted={.70,.80,.91}
            local soft={.90,.94,1}
            local function stat(label,value,col)
                local x=EDGE+(col-1)*188
                g.setColor(.10,.16,.25,1)
                g.rectangle("fill",x,187,174,78,7,7)
                write(small,label,x+12,198,muted,148)
                write(statFont,value,x+12,221,soft,148)
            end
            local function card(mon,index,y0,dead)
                local col=(index-1)%3
                local row=math.floor((index-1)/3)
                local x=EDGE+col*(CARD_W+GAP)
                local y=y0+58+row*ROW_STEP
                g.setColor(.10,.16,.26,1)
                g.rectangle("fill",x,y,CARD_W,CARD_H,8,8)
                color(dead and {.72,.30,.39} or {.18,.68,.49})
                g.rectangle("fill",x,y,5,CARD_H)
                drawSprite(g,mon,x+13,y+20)
                write(body,pokemonLabel(mon),
                    x+110,y+15,soft,240)
                write(small,speciesLabel(mon),
                    x+110,y+43,muted,238)
                write(small,"LEVEL "..text(mon.level),x+110,y+65,muted)
                -- Label every card explicitly. Gold indicates shiny;
                -- muted status is normal/unknown, never silently assume.
                local status=mon.shinyKnown==true
                    and (mon.shiny==true and "SHINY" or "NORMAL")
                    or "UNKNOWN"
                local shine=mon.shinyKnown==true and mon.shiny==true
                if shine then
                    color(gold)
                    g.rectangle("fill",x+244,y+66,98,24,5,5)
                end
                write(small,status,x+252,y+68,
                    shine and {.09,.12,.21} or muted,83)
                if mon.hp~=nil and mon.maxHp~=nil then
                    write(small,"HP "..text(mon.hp).."/"..text(mon.maxHp),
                        x+110,y+86,muted)
                end
                local a,d=mon.attack,mon.defense
                if a~=nil or d~=nil then
                    write(small,"ATK "..text(a).."  DEF "..text(d),
                        x+15,y+118,muted,335)
                end
                if mon.spAttack~=nil or mon.spDefense~=nil
                    or mon.speed~=nil then
                    write(small,"SPA "..text(mon.spAttack)
                        .."  SPD "..text(mon.spDefense)
                        .."  SPE "..text(mon.speed),
                        x+15,y+139,muted,335)
                elseif a==nil and d==nil then
                    write(small,"Stats not recorded",x+15,y+139,muted)
                end
                if dead then
                    if mon.area then
                        write(small,mon.area,x+15,y+160,muted,168)
                    end
                    if mon.cause then
                        write(small,mon.cause,x+190,y+160,muted,158)
                    end
                else
                    if mon.ability then
                        write(small,"ABILITY "..text(mon.ability),
                            x+15,y+160,muted,330)
                    end
                end
            end
            -- Header and all meaningful run metrics.
            color(accent)
            g.rectangle("fill",0,0,WIDTH,9)
            write(main,result.outcome=="VICTORY"
                and "CHAMPION HALL OF FAME" or "IN MEMORIAM",
                EDGE,26,gold)
            write(body,"TRAINER "..text(result.trainer),
                EDGE,91,soft,520)
            write(small,(text(result.version).."  /  "
                ..text(result.date)),EDGE,123,muted,750)
            write(small,("RESULT: "..text(result.reason)),
                EDGE,151,muted,WIDTH-2*EDGE)
            stat("PLAY TIME",text(result.playtime),1)
            stat("BADGES",text(result.badges),2)
            stat("CAUGHT",text(result.caught),3)
            stat("FAINTED",text(result.deaths),4)
            stat("AREAS",text(result.encounters),5)
            stat("SLOTS USED",text(result.spent),6)

            write(section,"FINAL PARTY  ("..#party..")",
                EDGE,partyY,gold)
            if #party==0 then
                write(body,"No Pokemon in the party at run end.",
                    EDGE+12,partyY+99,muted)
            else
                for i,mon in ipairs(party) do
                    card(mon,i,partyY,false)
                end
            end

            write(section,"IN MEMORIAM  ("..#graveyard..")",
                EDGE,gravesY,gold)
            if #graveyard==0 then
                write(body,"No fallen Pokemon recorded.",
                    EDGE+12,gravesY+99,muted)
            else
                for i,mon in ipairs(graveyard) do
                    card(mon,i,gravesY,true)
                end
            end
            color(accent)
            g.rectangle("fill",EDGE,height-53,WIDTH-2*EDGE,2)
            write(small,"NUZLOCKE  //  GEN 3",EDGE,height-39,gold)
            write(small,"SHINY EXCEPTIONS: "
                ..text(result.shinyExceptions),440,height-39,muted,320)
            write(small,text(result.date),865,height-39,muted,285)
            g.setCanvas()
            g.pop()
            pushed=false
            local name=tostring(result.trainer or "TRAINER")
                :gsub("[^%w%-_]","_")
            local suffix=os.date and os.date("!%Y%m%d_%H%M%S")
                or "run"
            local rel="nuzlocke_"..name.."_"..text(result.outcome)
                .."_"..suffix.."_FULL.png"
            canvas:newImageData():encode("png",rel)
            return rel
        end)
        if ok then return true,filename end
        if pushed then pcall(g.pop) end
        pcall(g.setCanvas)
        return false,tostring(filename)
    end
    local function exportFullRun()
        local ok,filename=exportImage()
        local rows={}
        if ok then
            rows[#rows+1]=row("COMPLETE RUN PNG SAVED")
            rows[#rows+1]=row("LOVE SAVE FOLDER")
            rows[#rows+1]=row(filename)
            rows[#rows+1]=row("PARTY + GRAVEYARD + STATS")
        else
            rows[#rows+1]=row("EXPORT FAILED")
            rows[#rows+1]=row(tostring(filename):sub(1,90))
        end
        present("SHARE RESULT",rows)
    end
    local function quit()
        local fn=opts and opts.onQuit
        if type(fn)=="function" then return fn() end
        if game and type(game.returnToTitle)=="function" then
            return game:returnToTitle()
        end
    end
    local function home()
        pages={}
        local rows={
            row("RESULT: "..text(result.outcome)),
            row("STATS / PLAY TIME",stats),
            row("FINAL PARTY",function() roster("party") end),
            row("GRAVEYARD: "..text(result.deaths),function()
                roster("graveyard")
            end),
            row("SHARE COMPLETE RUN PNG",exportFullRun),
        }
        if result.saveError then
            rows[#rows+1]=row("AUTOSAVE FAILED")
        end
        if result.outcome~="VICTORY" and opts
            and type(opts.onSave)=="function" then
            rows[#rows+1]=row("RETRY / SAVE RUN",function()
                local ok,why=opts.onSave()
                present("RUN SAVE",{
                    row(ok and "SAVE COMPLETE" or "SAVE FAILED"),
                    row(ok and "FINAL RECORD WRITTEN"
                        or tostring(why or "UNKNOWN ERROR")),
                })
            end)
        end
        if result.outcome=="VICTORY" then
            rows[#rows+1]=row("CONTINUE ADVENTURE",function()
                M.close()
                if opts and type(opts.onContinue)=="function" then
                    opts.onContinue()
                end
            end)
        end
        rows[#rows+1]=row("QUIT TO TITLE",quit)
        present("NUZ RUN RESULTS",rows)
    end
    function M.open(g,record,options)
        if type(record)~="table" then return false end
        result,game,opts=record,g,options or {}
        stack=require("src.ui.game3.stack")
        home()
        stack.push(ID,M,{hideBelow=true,fullscreen=true})
        return true
    end
    function M.isOpen()
        return stack and stack.has and stack.has(ID) or false
    end
    function M.ensureTop()
        if not M.isOpen() or not stack or not stack.top then
            return false
        end
        local top=stack.top()
        if top and top.id==ID then return true end
        -- Preserve the current result subpage if another native
        -- menu gets layered above the failed-run terminal overlay.
        stack.push(ID,M,{hideBelow=true,fullscreen=true})
        return true
    end
    function M.close()
        if stack then stack.pop(ID) end
        pages={}
    end
    function M.handleInput(input)
        if not input or not active() then return end
        local p=active()
        if input:wasPressed("up") then
            p.index=((p.index-2)%#p.rows)+1
        elseif input:wasPressed("down") then
            p.index=(p.index%#p.rows)+1
        elseif input:wasPressed("a") then
            local selected=p.rows[p.index]
            if selected and selected.action then selected.action() end
        elseif input:wasPressed("b") or input:wasPressed("start") then
            if #pages>1 then pages[#pages]=nil end
            -- Terminal failures must never dismiss the screen and enter
            -- gameplay; they can only view data/share or quit to title.
        end
        p=active()
        if p then
            if p.index<=p.scroll then p.scroll=p.index-1 end
            if p.index>p.scroll+6 then p.scroll=p.index-6 end
        end
    end
    function M.update()end
    function M.draw()
        local p=active()
        if not p then return end
        local Window=require("src.ui.game3.window")
        local Chrome=require("src.ui.game3.chrome")
        Window.fill(Window.template(0,0,30,20),1,1,1,1)
        Chrome.fixedStdFrame(1,1,28,18)
        Window.printPx(p.title,24,13,{maxWidth=190})
        Window.printPx(p.index.."/"..#p.rows,185,13,
            {maxWidth=35,small=true})
        for i=1,6 do
            local line=p.rows[p.scroll+i]
            if line then
                local y=31+(i-1)*17
                if p.scroll+i==p.index then Window.cursorPx(18,y) end
                Window.printPx(line.label,32,y,
                    {maxWidth=184,small=true})
            end
        end
        Window.printPx("A: VIEW   B: BACK",28,138,
            {maxWidth=185,small=true})
    end
    function M.model()
        local p=active()
        if not p then return nil end
        local labels={}
        for i,v in ipairs(p.rows) do labels[i]=v.label end
        return {title=p.title,rows=labels,index=p.index,
            depth=#pages,outcome=result.outcome}
    end
    return M
end
