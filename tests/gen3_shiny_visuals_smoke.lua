-- Read true shiny ROM art for portraits and results; keep mini-icons native.
-- A standard Gen 3 icon must never be replaced by a scaled front sprite.
local Visual=assert(loadfile("gen3_shiny_visuals.lua"))()()
local rgba=string.rep(string.char(20,220,35,255),4096)
local fetched={}
local store={
    read=function(_,path)
        fetched[#fetched+1]=path
        if path=="data/generated/gba/pokemon/front_shiny/56.rgba"
            then return rgba end
    end,
}
package.loaded["src.core.game3.dataset"]={
    cache=function()return store end,
}
package.loaded["src.core.game3.cache_paths"]={
    CACHE_ROOT="data/generated/gba",
}
local generated,draws,diamonds=0,0,0
local createdImages,drawn={},{};
local gfx={
    newImage=function(data)
        assert(data.rawShiny==true)
        local image={nativeShiny=true}
        function image:setFilter(min,mag)
            assert(min=="nearest" and mag=="nearest")
        end
        createdImages[#createdImages+1]=image
        return image
    end,
    newCanvas=function()error("mini-icon canvas must never be created")end,
    newQuad=function()error("mini-icon quads must never be created")end,
    push=function()end,pop=function()end,setCanvas=function()end,
    clear=function()end,setColor=function()end,
    draw=function(img,...)
        draws=draws+1
        drawn[#drawn+1]=img
    end,
    polygon=function(mode,...)
        assert(mode=="fill");diamonds=diamonds+1
    end,
}
local oldLove=love
love={graphics=gfx,image={
    newImageData=function(w,h,fmt,bytes)
        assert(w==64 and h==64 and fmt=="rgba8" and bytes==rgba)
        generated=generated+1
        return {rawShiny=true}
    end
}}
local native,normal=0,0
local Pokemon={
    _front={},
    isShiny=function(mon)return mon.isShiny==true end,
    picSpecies=function(species)return species end,
    frontPic=function(id,form,shiny,pid)
        native=native+1
        assert(shiny==true)
        return {image={nativeFallback=true},w=64,h=64}
    end,
    monIcon=function(mon)
        normal=normal+1
        return {vanilla=true}
    end,
}
local shiny={species=56,personality=921,isShiny=true}
local regular={species=56,personality=921,isShiny=false}
assert(Visual.isShiny(Pokemon,shiny)==true)
assert(Visual.isShiny(Pokemon,regular)==false)
assert(Visual.front(Pokemon,regular)==nil,
    "native normal icon is not replaced")
local pic=assert(Visual.front(Pokemon,shiny))
assert(pic.image.nativeShiny==true and generated==1)
assert(#fetched==1 and fetched[1]=="data/generated/gba/pokemon/front_shiny/56.rgba")
assert(native==0,"shiny artwork should come from actual ROM RGBA")
assert(Visual.front(Pokemon,shiny)==pic and generated==1,
    "decoded shiny palette texture must be cached per ROM/species")
assert(Visual.icon==nil,
    "there must be no custom shiny mini-icon renderer")
assert(Pokemon.monIcon(shiny).vanilla and Pokemon.monIcon(regular).vanilla
    and normal==2, "native icons remain valid for shiny and normal Pokemon")
assert(Visual.drawPcPortrait(Pokemon,shiny)==true)
assert(draws==1 and drawn[#drawn]==pic.image and diamonds==1,
    "native PC preview must redraw exact shiny ROM palette image")
local source= {species=56,shinyKnown=true,shiny=true,personality=15}
assert(Visual.isShiny(Pokemon,source)==true)
assert(Visual.front(Pokemon,source)==pic)
-- Missing/unavailable extracted art falls back to native frontPic(true)
local alternative={species=44,personality=11,isShiny=true}
local fallback=assert(Visual.front(Pokemon,alternative))
assert(fallback.image.nativeFallback==true and native==1)
-- Do not turn a record explicitly known NORMAL into shiny just because
-- the engine's dynamic roll is different for an incomplete snapshot.
local knownNormal={species=56,shinyKnown=true,shiny=false,isShiny=true}
assert(Visual.isShiny(Pokemon,knownNormal)==false)
assert(Visual.front(Pokemon,knownNormal)==nil)
-- Dataset switch must invalidate the shiny front image cache.
local newStore={read=function()return rgba end}
package.loaded["src.core.game3.dataset"].cache=function()return newStore end
assert(Visual.front(Pokemon,shiny).image~=pic.image
    and generated==2,"ROM switch requires fresh shiny assets")
local previous=Visual.front(Pokemon,shiny)
Pokemon._front={} -- engine's Pokemon.install() on a new ROM
assert(Visual.front(Pokemon,shiny).image~=previous.image
    and generated==3,"shared Dataset cache must also detect ROM reload")
love=oldLove
print("Gen 3 shiny ROM artwork and PC portrait/native icons: PASS")
