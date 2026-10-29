-- National Dex API v2 roster integration contract for Gen 3 randomiser.
-- Runs without the National Dex mod; only the documented API is mocked.
local R=assert(loadfile("gen3_randomizer.lua"))()()
local entries,forms={},{}

-- Native Gen 3 base slots.
local species={}
for i=1,386 do
    species[i]={nat=i,name="MON_"..i}
end
-- 639 expanded species, registered at arbitrary, non-National engine slots.
for nat=387,1025 do
    local slot=nat+64
    species[slot]={nat=nat,name="NATIONAL_"..nat}
    entries[#entries+1]={dex=nat,slot=slot,id="NATIONAL_"..nat}
end
-- 128 form slots share the base species' National Dex number.
for i=1,128 do
    local slot=1200+i
    species[slot]={nat=906,name="FORM_"..i}
    forms[#forms+1]={slot=slot,baseDex=906,id="FORM_"..i}
end
-- This mock deliberately puts a bogus plausible ID in an unregistered
-- slot. It must not enter the pool unless advertised by listSpecies/forms.
species[1500]={nat=999,name="BOGUS"}
local P={
    national=function(id) return species[id] and species[id].nat end,
    keyName=function(id) return species[id] and species[id].name end,
    stats=function(id)
        if not species[id] then return nil end
        return {hp=50,atk=50,def=50,spe=50,spa=50,spd=50}
    end,
}
local provider={
    apiVersion=2,
    listSpecies=function() return entries end,
    listForms=function() return forms end,
}
local classic={randomizer={randomizer_seed=901234,
    random_encounter_tables=true,random_species_roster=0}}
local oldPool=R.pool(P,classic.randomizer)
assert(#oldPool==386 and oldPool[1].national==1
    and oldPool[#oldPool].national==386,
    "native-only roster keeps the Gen 1-3 species and stable order")
local oldPick=R.replace(classic,P,"ENCOUNTERS","TEST:1",1)
assert(oldPick and oldPick<=386,"classic replacements remain native")

R.setSpeciesProvider(function() return provider end)
local newRun={randomizer={randomizer_seed=901234,random_encounter_tables=true}}
local newPool=R.pool(P,newRun.randomizer)
-- The new roster is opt-in automatically for new saves with the provider.
assert(R.get(newRun,"random_species_roster")==1)
newPool=R.pool(P,newRun.randomizer)
assert(#newPool==1025,
    "National Dex base roster includes all 1025 species (including 639 new)")
local status=R.rosterInfo(newRun,P)
assert(status.provider and status.total==1025
    and status.extended==639 and status.forms==0)
assert(newPool[#newPool].national==1025)
assert(R.set(newRun,"random_species_generation",9))
local paldea=R.replace(newRun,P,"ENCOUNTERS","PALDEA:01",1)
assert(paldea and P.national(paldea)>=906 and P.national(paldea)<=1025,
    "Paldea filter must only return National Dex #906-1025")
local again=R.replace(newRun,P,"ENCOUNTERS","PALDEA:01",1)
assert(again==paldea,"the same run seed and source must reproduce a Gen 9 species")
assert(not R.set(newRun,"random_species_forms",true),
    "roster options lock once the randomiser has produced a species")

local withForms={randomizer={random_species_roster=1,
    random_species_forms=true,random_species_generation=9,
    random_encounter_tables=true,randomizer_seed=1244}}
local combined=R.pool(P,withForms.randomizer)
assert(#combined==1153,
    "forms toggle adds 128 registered alternate forms only")
local info=R.rosterInfo(withForms,P)
assert(info.total==1153 and info.forms==128 and info.extended==767)
local banState={randomizer={random_species_roster=1,
    random_species_generation=9,random_encounter_tables=true,
    randomizer_seed=777}}
local stopped=R.replace(banState,P,"ENCOUNTERS","FILTER:1",1,nil,
    function(nat) return nat>=906 end)
assert(stopped==nil,"National Dex bans must remove the entire Gen 9 pool")
local restore={randomizer={random_species_roster=1,
    random_species_generation=9,random_encounter_tables=true,
    randomizer_seed=901234}}
assert(R.replace(restore,P,"ENCOUNTERS","PALDEA:01",1)==paldea,
    "fresh matching roster + seed + source gives the same replacement")
local oldSave={randomizer={used=true,randomizer_seed=901234,
    random_encounter_tables=true}}
assert(R.get(oldSave,"random_species_roster")==0,
    "pre-upgrade used saves must be pinned to the 386-species legacy pool")
assert(R.replace(oldSave,P,"ENCOUNTERS","TEST:1",1)==oldPick,
    "old seeds must not silently reassign Pokémon after installing National Dex")

R.setSpeciesProvider(nil)
local missing={randomizer={randomizer_seed=12445,
    random_encounter_tables=true,random_species_generation=9}}
assert(not R.rosterInfo(missing,P).provider)
assert(R.replace(missing,P,"ENCOUNTERS","MAP",1)==nil,
    "gen 9 filter with absent provider safely leaves the original Pokémon")
assert(#R.pool(P,missing.randomizer)==386)
R.setSpeciesProvider(function() return {apiVersion=1,
    listSpecies=function() return entries end} end)
assert(#R.pool(P,missing.randomizer)==386,
    "unsupported National Dex API versions cannot silently affect the game")
print("Gen 3 National Dex roster: 1025 base, 128 optional forms, legacy saves: PASS")
