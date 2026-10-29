-- Gen 3 Services & Economy policy plus static native guard coverage.
local Service=assert(loadfile("gen3_services_economy.lua"))()()
local Core=assert(loadfile("gen3_core_rules.lua"))()()
local s=Core.normalise({})
local keys={"no_poke_center","no_mom_heal","no_day_care",
    "shop_restrictions","no_gambling","trainer_money_multiplier"}
assert(#Service.descriptors()==6)
for _,key in ipairs(keys) do
    assert(Service.get(s,key)~=nil and Service.label(s,key))
end
assert(Service.label(s,"shop_restrictions")=="NORMAL")
assert(Service.label(s,"trainer_money_multiplier")=="100%")
assert(Service.next(s,"trainer_money_multiplier")==200)
assert(Service.get(s,"no_poke_center")==false)
assert(not Service.set(s,"shop_restrictions",5))
assert(not Service.set(s,"trainer_money_multiplier",25))
assert(not Service.set(s,"trainer_money_multiplier","200"))
assert(not Service.set(s,"no_mom_heal",1))
assert(Service.healLocation("FR_CERULEAN_CITY_POKEMON_CENTER_1F")=="center")
assert(Service.healLocation("RU_LITTLEROOT_TOWN_BRENDANS_HOUSE_1F")=="mom")
assert(Service.healLocation("EM_LITTLEROOT_TOWN_MAYS_HOUSE_1F")=="mom")
assert(Service.healLocation("FR_PALLET_TOWN_PLAYERS_HOUSE_1F")=="mom")
assert(Service.healLocation("FR_OAKS_LAB")==nil)
assert(Service.healLocation("RS_LITTLEROOT_TOWN")==nil)
assert(Service.healLocation(nil)==nil)
assert(Core.set(s,"nuzlocke_enabled",true))
assert(Service.set(s,"no_poke_center",true))
assert(Service.set(s,"no_mom_heal",true))
assert(Service.set(s,"no_day_care",true))
assert(Service.set(s,"no_gambling",true))
assert(Service.healDenial(s,Core,"FR_VIRIDIAN_CITY_POKEMON_CENTER_1F")
    :find("Center",1,true))
assert(Service.healDenial(s,Core,"SA_LITTLEROOT_TOWN_MAYS_HOUSE_1F")
    :find("Mom",1,true))
assert(Service.healDenial(s,Core,"FR_OAKS_LAB")==nil,
    "story heals must remain native")
assert(Service.daycareDenial(s,Core):find("deposits",1,true))
assert(Service.gamblingDenial(s,Core):find("Gambling",1,true))
assert(Service.shopDenial(s,Core,"buy")==nil)
assert(Service.set(s,"shop_restrictions",1))
assert(Service.shopDenial(s,Core,"buy") and
    Service.shopDenial(s,Core,"sell")==nil)
assert(Service.next(s,"shop_restrictions")==2)
assert(Service.set(s,"shop_restrictions",2))
assert(Service.shopDenial(s,Core,"sell") and
    Service.shopDenial(s,Core,"buy")==nil)
assert(Service.set(s,"shop_restrictions",3))
assert(Service.shopDenial(s,Core,"buy") and
    Service.shopDenial(s,Core,"sell"))
assert(Service.shopDenial(s,Core,"gift")==nil)
assert(Service.next(s,"shop_restrictions")==0)
for _,pct in ipairs({0,50,100,200,300}) do
    assert(Service.set(s,"trainer_money_multiplier",pct))
    assert(Service.trainerPrize(s,Core,125)
        ==math.floor(125*pct/100))
end
local persisted={enabled=s.enabled,rules=s.rules,serviceRules=s.serviceRules}
assert(Service.get(persisted,"shop_restrictions")==3)
assert(Service.get(persisted,"trainer_money_multiplier")==300)
assert(Core.set(s,"nuzlocke_enabled",false))
assert(Service.healDenial(s,Core,"FR_VIRIDIAN_CITY_POKEMON_CENTER_1F")==nil)
assert(Service.daycareDenial(s,Core)==nil)
assert(Service.gamblingDenial(s,Core)==nil)
assert(Service.shopDenial(s,Core,"buy")==nil)
assert(Service.trainerPrize(s,Core,125)==125)
s.failed=true
assert(not Service.set(s,"shop_restrictions",0))
assert(not Service.set(s,"no_poke_center",false))
local invalid={serviceRules={
    shop_restrictions=20,trainer_money_multiplier=9,no_mom_heal="yes"
}}
assert(Service.get(invalid,"shop_restrictions")==0)
assert(Service.get(invalid,"trainer_money_multiplier")==100)
assert(not Service.get(invalid,"no_mom_heal"))

local f=assert(io.open("gen3_runtime.lua","rb"))
local runtime=f:read("*a");f:close()
for _,token in ipairs({
    'readModule("gen3_services_economy.lua")',
    'Services.healDenial',
    'Services.daycareDenial',
    'Services.gamblingDenial',
    'Services.shopDenial',
    'Services.trainerPrize',
    'Shop.handleInput=guarded',
    'Daycare[name]=guarded',
    'Prize[name]=guarded',
    'installServiceGuards()',
}) do
    assert(runtime:find(token,1,true),"missing native guard "..token)
end
print("Gen 3 Services & Economy: six controls and native guards: PASS")
