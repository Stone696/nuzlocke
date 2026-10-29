-- Gen 4-9 catch legality and optional National Dex classifications.
local C=assert(loadfile("gen3_catch_rules.lua"))()()
local Core=assert(loadfile("gen3_core_rules.lua"))()()
local saved=Core.normalise({})
assert(Core.set(saved,"nuzlocke_enabled",true))
local names={
  [970]="SPRIGATITO",[1035]="WO_CHIEN",[1036]="CHIEN_PAO",
  [1089]="PECHARUNT",[1070]="GIMMIGHOUL",[1040]="GIBLE",
  [1100]="DRAGAPULT",[1200]="FRIGIBAX"
}
local nat={
  [970]=906,[1035]=1001,[1036]=1002,[1089]=1025,
  [1070]=999,[1040]=443,[1100]=887,[1200]=996
}
local P={
  national=function(id) return nat[id] end,
  keyName=function(id) return names[id] end,
  stats=function(id)
    if names[id] then
      return {hp=65,atk=65,def=65,spe=65,spa=65,spd=65}
    end
  end,
}
assert(C.check(saved,970,P,Core),
    "a real National Dex #906 slot is not a glitch Pokemon")
assert(not C.check(saved,99999,P,Core),"unregistered internal slot is a glitch")
assert(C.toggleNational(saved,906))
assert(C.isBannedNational(saved,906))
assert(not C.check(saved,970,P,Core),"individual bans apply to new species")
assert(C.toggleNational(saved,906))
assert(C.toggleNational(saved,1025))
assert(C.isBannedNational(saved,1025))
assert(not C.check(saved,1089,P,Core),"new mythical individual ban works")
assert(C.toggleNational(saved,1025))
assert(not C.toggleNational(saved,1026))
assert(C.banCount(saved)==0)
C.setSpeciesProvider(function() return {
  apiVersion=2,
  listSpecies=function() return {
    {dex=906,legendary=false,mythical=false},
    {dex=1001,legendary=true,mythical=false},
    {dex=1002,legendary=true,mythical=false},
    {dex=1025,legendary=false,mythical=true},
  } end,
} end)
assert(C.set(saved,"ban_legendaries",true))
assert(not C.check(saved,1035,P,Core),"Wo-Chien classified legendary")
assert(not C.check(saved,1036,P,Core),"Chien-Pao classified legendary")
assert(C.check(saved,1089,P,Core),"Pecharunt is mythical not legendary")
assert(C.set(saved,"ban_mythicals",true))
assert(not C.check(saved,1089,P,Core),"Pecharunt classified mythical")
assert(C.set(saved,"ban_legendaries",false))
assert(C.set(saved,"ban_mythicals",false))
assert(C.set(saved,"ban_pseudos",true))
assert(not C.check(saved,1040,P,Core),"Gible line is pseudo")
assert(not C.check(saved,1100,P,Core),"Dragapult line is pseudo")
assert(not C.check(saved,1200,P,Core),"Frigibax line is pseudo")
assert(C.check(saved,970,P,Core),"ordinary Paldea starter remains eligible")
C.setSpeciesProvider(nil)
assert(C.check(saved,1035,P,Core),
    "missing provider must not invent a legendary classification")
print("Gen3 National Dex catch rules and Gen 4-9 bans: PASS")
