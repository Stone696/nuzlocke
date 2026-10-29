-- National Dex form labels are display-only. They must never remap a
-- Pokemon's persisted species slot, erase nicknames or require the mod.
local Display=assert(loadfile("gen3_display.lua"))()()

local forms={
    {slot=1094,id="ZORUA_HISUI",name="ZORUA",form="HISUI",
        baseSpecies="ZORUA",baseDex=570},
    {slot=1095,id="ZOROARK_HISUI",name="ZOROARK",form="HISUI",
        baseSpecies="ZOROARK",baseDex=571},
    {slot=1091,id="DARMANITAN_GALAR_STANDARD",name="DARMANITAN",
        form="GALAR_STANDARD",baseDex=555},
    {slot=1105,id="TAUROS_PALDEA_COMBAT_BREED",name="TAUROS",
        form="PALDEA_COMBAT_BREED",baseDex=128},
    {slot=1062,id="ROTOM_HEAT",name="ROTOM",form="HEAT",baseDex=479},
}
local provider={
    listForms=function()return forms end,
    listSpecies=function()return {
        {slot=451,id="TURTWIG",name="TURTWIG",dex=387},
    } end,
}
local active=nil
Display.setSpeciesProvider(function()return active end)
local prior={species=1094,name="Zorua",speciesName="Zorua",level=20}
assert(Display.speciesName(prior)=="Zorua",
    "older records must still render without National Dex installed")

active=provider
assert(Display.speciesName(prior)=="Hisuian Zorua")
assert(Display.pokemonName(prior)=="Hisuian Zorua",
    "unnicknamed legacy records must not keep an outdated base name")
assert(Display.speciesName({species=1095,speciesName="Zoroark"})
    =="Hisuian Zoroark")
assert(Display.speciesName({species=1091})
    =="Galarian Darmanitan (Standard)")
assert(Display.speciesName({species=1105})
    =="Paldean Tauros (Combat Breed)")
assert(Display.speciesName({species=1062})=="Rotom (Heat)")
assert(Display.speciesName({species=451})=="Turtwig")
assert(Display.pokemonName({species=1094,nickname="Ghost",
    speciesName="Zorua",name="Zorua"})=="Ghost")
assert(Display.pokemonName({species=1094,name="Ghost",
    speciesName="Zorua"})=="Ghost",
    "nickname-only legacy memorials must remain legible")
assert(Display.speciesName({species=7,speciesName="Squirtle"})
    =="Squirtle", "vanilla species must retain their existing names")

local death=Display.memorial({species=1094,name="Zorua",
    level=20,form=0,formId="ZORUA_HISUI"}, "FR_ROUTE_1", "Fainted")
assert(death.species==1094 and death.form==0
    and death.formId=="ZORUA_HISUI")
assert(death.speciesName=="Hisuian Zorua"
    and death.name=="Hisuian Zorua")
local caught=Display.trackerCatch({caught=true,caughtSpeciesId=1094,
    caughtSpeciesName="Zorua",caughtLevel=12},nil,{})
assert(caught and caught.species=="Hisuian Zorua"
    and caught.name=="Hisuian Zorua")

local Results=assert(loadfile("gen3_run_results.lua"))()()
local saved={enabled=true,graveyard={death}}
local session={name="TEST",version="emerald",party={
    {species=1095,name="Zoroark",level=37,
        nickname="Shade",personality=123,isShiny=true},
}}
local finished=assert(Results.finish(saved,session,Display,
    "VICTORY","Champion defeated",8))
assert(finished.party[1].species==1095
    and finished.party[1].speciesName=="Hisuian Zoroark"
    and finished.party[1].name=="Shade"
    and finished.graveyard[1].species==1094
    and finished.graveyard[1].speciesName=="Hisuian Zorua")

-- An old ended run should also render correct names on its existing
-- result screen without rewriting the saved snapshot.
local Screen=assert(loadfile("gen3_results_screen.lua"))()()
package.loaded["src.ui.game3.stack"]={
    push=function()end,pop=function()end,has=function()return true end,
}
local older={outcome="FAILED",party={},graveyard={
    {species=1094,name="Zorua",speciesName="Zorua",level=20},
}}
assert(Screen.open({},older,{display=Display}))
local function press(button)
    Screen.handleInput({wasPressed=function(_,key)return key==button end})
end
local function selectRow(prefix)
    local rows=Screen.model().rows
    for i,label in ipairs(rows) do
        if label:sub(1,#prefix)==prefix then
            for _=1,#rows do
                if Screen.model().index==i then break end
                press("down")
            end
            assert(Screen.model().index==i)
            press("a")
            return
        end
    end
    error("Missing row: "..prefix)
end
selectRow("GRAVEYARD:")
assert(Screen.model().title=="IN MEMORIAM")
assert(Screen.model().rows[1]:find("Hisuian Zorua",1,true))
press("a")
local detail=table.concat(Screen.model().rows," ")
assert(detail:find("SPECIES: Hisuian Zorua",1,true))
Screen.close()

active=nil
assert(Display.speciesName(death)=="Hisuian Zorua",
    "new memorial records must retain their form label without provider")
assert(Display.speciesName(prior)=="Zorua",
    "old records fall back safely if the provider is removed")
print("Gen 3 National Dex form-aware Graveyard and results names: PASS")
