-- ROM-free Gen 3 Catch Rules: national mapping, BST, saved switches.
local Rules = assert(loadfile("gen3_catch_rules.lua"))()()
local Core = assert(loadfile("gen3_core_rules.lua"))()()
local s = Core.normalise({})
assert(#Rules.descriptors()==17)
assert(Rules.get(s,"ban_legendaries")==false)
assert(Rules.get(s,"ban_mythicals")==false)
assert(Rules.get(s,"ban_pseudos")==false)
assert(Rules.get(s,"maximum_bst")==0)
assert(not Rules.get(s,"no_fishing") and not Rules.get(s,"no_static_encounters"))
assert(Rules.get(s,"town_catches")==false)
assert(Rules.get(s,"alphabetlocke_mode")==0)
assert(Rules.get(s,"alphabetlocke_letter")==1)
assert(Rules.get(s,"allow_glitch_pokemon")==false)
assert(Rules.get(s,"pkmn_ban")==0)
assert(Rules.get(s,"colorlocke_mode")==0)
assert(Rules.get(s,"colorlocke_color")==1)
assert(not Rules.anyEnabled(s))
assert(Core.set(s,"nuzlocke_enabled",true),
    "enable the master challenge before testing catch restrictions")
local pokemon={
    national=function(id)
        return ({[277]=252,[400]=380,[401]=373,[402]=385})[id] or id
    end,
    speciesFromName=function(name)
        return ({LATIAS=400,SALAMENCE=401,JIRACHI=402,PIKACHU=25})[name]
    end,
    speciesFromNational=function(nat)
        return ({[1]=25,[2]=400,[3]=401,[4]=402})[nat]
    end,
    keyName=function(id)
        return ({[25]="PIKACHU",[400]="LATIAS",[401]="SALAMENCE",
                 [402]="JIRACHI",[277]="TREECKO"})[id]
    end,
    stats=function(id)
        if id==25 then return {35,55,40,90,50,50} end -- 320
        if id==400 then return {80,80,90,110,110,130} end -- 600
        if id==401 then return {95,135,80,100,110,80} end -- 600
        if id==402 then return {100,100,100,100,100,100} end
        if id==277 then return {40,45,35,70,65,55} end -- Treecko 310
        if id==99 then return nil end
        return {50,50,50,50,50,50}
    end
}
local function allowed(id)
    return Rules.check(s,id,pokemon,Core)
end
assert(allowed(400) and allowed(401) and allowed(402),
    "every advanced catch ban defaults OFF")
assert(Rules.set(s,"ban_legendaries",true))
assert(not allowed(150),"Mewtwo legendary banned")
assert(not allowed(400),"Latias internal id 400 -> national 380 banned")
assert(allowed(402),"Jirachi is mythical, not legendary")
assert(Rules.set(s,"ban_mythicals",true))
assert(not allowed(151) and not allowed(251),"Mew and Celebi banned")
assert(not allowed(402),"Jirachi's internal ID maps to mythical")
assert(allowed(401),"pseudo is distinct from mythical/legendary")
assert(Rules.set(s,"ban_pseudos",true))
for _,id in ipairs({147,148,149,246,247,248,371,372,376,401}) do
    assert(not allowed(id),"pseudo family banned: "..tostring(id))
end
assert(allowed(277),"Treecko internal 277 is not pseudo/legendary")
assert(Rules.set(s,"maximum_bst",500))
assert(not allowed(401),"BST 600 also banned at cap 500")
assert(allowed(25),"Pikachu 320 allowed below 500")
assert(not allowed(99),"unknown stats must fail closed only with cap")
assert(Rules.get(s,"maximum_bst")==500)
assert(Rules.nextBst(500)==550 and Rules.nextBst(700)==0)
assert(not Rules.set(s,"maximum_bst",501),"only valid UI presets accepted")
assert(not Rules.set(s,"ban_pseudos",1),"toggles must be booleans")
assert(not Rules.set(s,"pkmn_ban",true),"unported species picker not editable")
assert(Rules.set(s,"maximum_bst",0))
-- Scripted static/legendary wild battles are catch-blocked, but native
-- roamers (even legendary species) and normal/fishing/grass are not.
assert(Rules.set(s,"no_static_encounters",true))
local blocked, reason = Rules.checkBattle(s,{wildScripted=true},Core)
assert(not blocked and reason:find("No Static",1,true))
assert(not Rules.checkBattle(s,{legendary=true},Core))
assert(Rules.checkBattle(s,{legendary=true,roamer=true},Core),
    "the roamer classification overrides legendary static battle")
assert(Rules.checkBattle(s,{wildScripted=false,legendary=false},Core))
assert(Rules.checkBattle(s,nil,Core))
assert(Rules.set(s,"no_fishing",true))
assert(Rules.fishingBlocked(s,Core))
assert(Rules.set(s,"no_fishing",false))
assert(not Rules.fishingBlocked(s,Core))
assert(Rules.set(s,"no_static_encounters",false))
assert(Rules.checkBattle(s,{wildScripted=true},Core))
assert(Rules.set(s,"no_fishing",true))
assert(Rules.set(s,"no_static_encounters",true))
assert(Core.set(s,"nuzlocke_enabled",false))
assert(not Rules.fishingBlocked(s,Core)
    and Rules.checkBattle(s,{legendary=true},Core),
    "master OFF must restore native fishing and static catching")
assert(Core.set(s,"nuzlocke_enabled",true))
assert(Rules.set(s,"no_fishing",false))
assert(Rules.set(s,"no_static_encounters",false))
assert(allowed(99),"unknown stats not relevant with limit OFF")
assert(Rules.get({}, "maximum_bst")==0,"legacy saves default OFF")
assert(Rules.isTownMap("FR_PALLET_TOWN"))
assert(Rules.isTownMap("FR_CERULEAN_CITY"))
assert(Rules.isTownMap("RU_LITTLEROOT_TOWN"))
assert(Rules.isTownMap("SA_SLATEPORT_CITY"))
assert(Rules.isTownMap("EM_LILYCOVE_CITY"))
assert(Rules.isTownMap("FR_FOUR_ISLAND"))
assert(not Rules.isTownMap("FR_ROUTE_1"))
assert(not Rules.isTownMap("FR_BIRTH_ISLAND"),
    "not every island is a settlement")
assert(not Rules.isTownMap("FR_CERULEAN_CITY_POKEMON_CENTER_1F"))
assert(not Rules.isTownMap("OTHER_CITY"),
    "only verified Gen3 map-id formats count")
assert(not Rules.checkBattle(s,{},Core,"FR_PALLET_TOWN"),
    "Town Catches defaults OFF when Nuzlocke is active")
assert(not Rules.checkBattle(s,{},Core,"RU_PETALBURG_CITY"))
assert(not Rules.checkBattle(s,{},Core,"SA_PETALBURG_CITY"))
assert(Rules.checkBattle(s,{},Core,"FR_ROUTE_1"))
assert(Rules.set(s,"town_catches",true))
assert(Rules.checkBattle(s,{},Core,"FR_PALLET_TOWN"))
assert(Rules.set(s,"town_catches",false))
assert(Rules.get(s,"town_catches")==false)
assert(Core.set(s,"nuzlocke_enabled",false))
assert(Rules.checkBattle(s,{},Core,"FR_PALLET_TOWN"),
    "town bans must be inactive with CORE off")
assert(Core.set(s,"nuzlocke_enabled",true))
-- The native canonical name, never a nickname or localized display,
-- controls the Alphabetlocke choose letter.
for _,key in ipairs({"ban_legendaries","ban_mythicals","ban_pseudos"}) do
    assert(Rules.set(s,key,false))
end
assert(Rules.set(s,"maximum_bst",0))
assert(Rules.set(s,"alphabetlocke_mode",2))
assert(Rules.set(s,"alphabetlocke_letter",12))
assert(Rules.label(s,"alphabetlocke_letter")=="L")
assert(Rules.label(s,"alphabetlocke_mode")=="CHOOSE")
assert(allowed(400),"LATIAS must match letter L")
assert(not allowed(401),"SALAMENCE must fail selected letter L")
assert(not Rules.set(s,"alphabetlocke_mode",3))
assert(not Rules.set(s,"alphabetlocke_letter",27))
assert(Rules.next(s,"alphabetlocke_letter")==13)
assert(Rules.set(s,"alphabetlocke_mode",1))
assert(Rules.label(s,"alphabetlocke_mode")=="RANDOM")
assert(Rules.prepareAlphabet(s,pokemon,"trainer:1234"))
local picked=Rules.selectedLetter(s,pokemon,"trainer:1234")
assert(picked and picked>=1 and picked<=26)
assert(not Rules.prepareAlphabet(s,pokemon,"different seed"),
    "random letter must not reroll once chosen")
assert(Rules.selectedLetter(s,pokemon,"different seed")==picked)
assert(({[10]=true,[12]=true,[16]=true,[19]=true})[picked],
    "random mode must choose an initial present in the registry")
local persisted={enabled=true,catchRules=s.catchRules}
assert(Rules.selectedLetter(persisted,pokemon)==picked,
    "random initial must persist in the existing save namespace")
assert(Rules.set(s,"alphabetlocke_mode",0))
assert(Rules.selectedLetter(s,pokemon)==nil)
assert(Rules.check(s,{},pokemon,Core),
    "an absent catch-rate species id is not proof of a glitch")
assert(not allowed(0),"invalid zero species blocked by default")
assert(not allowed(9999),"unregistered species blocked by default")
assert(Rules.set(s,"allow_glitch_pokemon",true))
assert(allowed(9999),"Allow Glitches permits unregistered species")
assert(Rules.set(s,"allow_glitch_pokemon",false))
assert(Rules.get(s,"allow_glitch_pokemon")==false)
-- Native transaction policy: gifts/trades only consume AREA slots
-- on successful receipts. BONUS never spends the map catch opportunity.
assert(Rules.get(s,"allow_gifts")==true)
assert(Rules.get(s,"allow_trades")==true)
assert(Rules.get(s,"gift_slot_policy")==0)
assert(Rules.get(s,"trade_slot_policy")==0)
assert(Rules.label(s,"gift_slot_policy")=="AREA")
assert(Rules.next(s,"gift_slot_policy")==1)
assert(Rules.set(s,"allow_gifts",false))
assert(not Rules.canAcquire(s,"gift",25,"FR_ROUTE_4",pokemon,Core))
assert(Rules.canAcquire(s,"gift",25,"FR_OAKS_LAB",pokemon,Core,
    {mandatoryStarter=true}),"mandatory starter cannot be denied")
assert(Rules.canAcquire(s,"trade",25,"FR_ROUTE_4",pokemon,Core))
assert(Rules.set(s,"allow_gifts",true))
assert(Rules.set(s,"allow_trades",false))
assert(not Rules.canAcquire(s,"trade",25,"FR_ROUTE_4",pokemon,Core))
assert(Rules.set(s,"allow_trades",true))
assert(Rules.canAcquire(s,"gift",25,"FR_ROUTE_4",pokemon,Core))
assert(Rules.noteAcquired(s,"gift",25,"FR_ROUTE_4",Core))
assert(s.areas.FR_ROUTE_4.spent and s.areas.FR_ROUTE_4.caught
    and s.areas.FR_ROUTE_4.source=="gift")
assert(not Rules.canAcquire(s,"gift",25,"FR_ROUTE_4",pokemon,Core))
assert(not Rules.canAcquire(s,"trade",25,"FR_ROUTE_4",pokemon,Core))
assert(Rules.set(s,"gift_slot_policy",1))
assert(Rules.set(s,"trade_slot_policy",1))
assert(Rules.label(s,"gift_slot_policy")=="BONUS")
assert(Rules.next(s,"trade_slot_policy")==0)
assert(Rules.canAcquire(s,"gift",25,"FR_ROUTE_4",pokemon,Core))
assert(Rules.canAcquire(s,"trade",25,"FR_ROUTE_4",pokemon,Core))
assert(Rules.noteAcquired(s,"gift",25,"FR_ROUTE_5",Core))
assert(s.areas.FR_ROUTE_5==nil,"bonus gift does not use route slot")
assert(Rules.noteAcquired(s,"trade",25,"FR_ROUTE_6",Core))
assert(s.areas.FR_ROUTE_6==nil,"bonus trade does not use route slot")
assert(s.acquisitionHistory[#s.acquisitionHistory].slot=="BONUS")
assert(Rules.set(s,"trade_slot_policy",0))
assert(Rules.noteAcquired(s,"trade",25,"FR_ROUTE_7",Core))
assert(s.areas.FR_ROUTE_7.source=="trade")
assert(Rules.set(s,"ban_legendaries",true))
assert(not Rules.canAcquire(s,"trade",400,"FR_ROUTE_8",pokemon,Core),
    "species bans must apply to incoming NPC trade Pokemon")
assert(not Rules.canAcquire(s,"gift",400,"FR_ROUTE_8",pokemon,Core))
assert(Rules.set(s,"ban_legendaries",false))
assert(not Rules.set(s,"gift_slot_policy",2))
assert(not Rules.set(s,"trade_slot_policy",-1))
assert(Core.set(s,"nuzlocke_enabled",false))
assert(Rules.canAcquire(s,"gift",25,"FR_ROUTE_4",pokemon,Core))
assert(not Rules.noteAcquired(s,"gift",25,"FR_ROUTE_8",Core))
assert(s.areas.FR_ROUTE_8==nil)
assert(Core.set(s,"nuzlocke_enabled",true))
-- PKMN BAN stores National Dex identity, not ROM internal species IDs.
assert(Rules.banCount(s)==0)
assert(Rules.toggleNational(s,252))
assert(Rules.banCount(s)==1 and Rules.label(s,"pkmn_ban")=="1 BANNED")
assert(Rules.isBannedNational(s,252) and not Rules.isBannedNational(s,277))
assert(not allowed(277),"internal Treecko ID 277 maps to National #252")
assert(allowed(25),"unlisted species remain catchable")
assert(not Rules.canAcquire(s,"gift",277,"FR_ROUTE_10",pokemon,Core))
assert(not Rules.canAcquire(s,"trade",277,"FR_ROUTE_10",pokemon,Core))
local savedBan={catchRules=s.catchRules}
assert(Rules.isBannedNational(savedBan,252),"ban list persists in save")
assert(not Rules.toggleNational(s,0) and not Rules.toggleNational(s,1026))
assert(Rules.toggleNational(s,387),"Gen 4 individual species must be bannable")
assert(Rules.isBannedNational(s,387) and Rules.banCount(s)==2)
assert(Rules.toggleNational(s,387))
assert(not Rules.set(s,"pkmn_ban",1),"picker is not a boolean toggle")
assert(Rules.toggleNational(s,252))
assert(Rules.banCount(s)==0 and allowed(277))
-- Colorlocke uses canonical NATIONAL species color IDs, not shiny sprites.
assert(Rules.colorId(25,pokemon)==10,"Pikachu is YELLOW")
assert(Rules.colorId(4,pokemon)==8,"Charmander is RED")
assert(Rules.colorId(1,pokemon)==5,"Bulbasaur is GREEN")
assert(Rules.colorId(9999,pokemon)==nil,
    "unknown custom species without color metadata has no guessed color")
assert(Rules.set(s,"colorlocke_mode",2))
assert(Rules.set(s,"colorlocke_color",10))
assert(Rules.label(s,"colorlocke_mode")=="CHOOSE")
assert(Rules.label(s,"colorlocke_color")=="YELLOW")
assert(allowed(25),"Pikachu qualifies for YELLOW Colorlocke")
assert(not allowed(4),"Charmander fails YELLOW Colorlocke")
assert(not Rules.canAcquire(s,"trade",4,"FR_ROUTE_10",pokemon,Core))
assert(Rules.set(s,"allow_glitch_pokemon",true))
assert(allowed(9999),"custom species of unknown color fails open")
assert(Rules.set(s,"allow_glitch_pokemon",false))
assert(not Rules.set(s,"colorlocke_color",11))
assert(not Rules.set(s,"colorlocke_mode",3))
assert(Rules.next(s,"colorlocke_color")==1)
assert(Rules.set(s,"colorlocke_mode",1))
assert(Rules.label(s,"colorlocke_mode")=="RANDOM")
assert(Rules.prepareColor(s,pokemon,"trainer:1234"))
local chosenColor=Rules.selectedColor(s,pokemon,"trainer:1234")
assert(type(chosenColor)=="number" and chosenColor>=1
    and chosenColor<=10)
assert(not Rules.prepareColor(s,pokemon,"different trainer"),
    "RANDOM Colorlocke must not reroll")
assert(Rules.selectedColor(s,pokemon,"different trainer")==chosenColor)
assert(Rules.get({catchRules=s.catchRules},"colorlocke_mode")==1)
assert(Rules.selectedColor({catchRules=s.catchRules},pokemon)==chosenColor,
    "RANDOM Colorlocke persisted")
assert(Rules.set(s,"colorlocke_mode",0))
assert(Rules.selectedColor(s,pokemon)==nil)
assert(Rules.get(s,"colorlocke_mode")==0)
local restored={enabled=true,catchRules={ban_legendaries=true,
    ban_mythicals=true,ban_pseudos=true,maximum_bst=500}}
assert(Rules.get(restored,"ban_legendaries")
    and Rules.get(restored,"maximum_bst")==500,
    "catch settings survive reload")
assert(Core.set(s,"nuzlocke_enabled",false)==true)
assert(allowed(150) and allowed(400) and allowed(401),
    "master OFF bypasses restrictions but retains saved settings")
assert(Core.set(s,"nuzlocke_enabled",true))
s.failed=true
assert(not Rules.set(s,"ban_legendaries",false),
    "failed run cannot change rules")
assert(Rules.check(s,400,pokemon,Core),
    "failed runs do not apply live catch restrictions")
print("Gen3 Catch Rules national-dex policy/BST/save validation: PASS")
