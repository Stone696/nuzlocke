local F = assert(loadfile("gen3_forgiveness.lua"))()()
local s = { enabled = true, areas = {
    FR_ROUTE_1 = { spent = true, caught = false },
    FR_ROUTE_2 = { spent = true, caught = true },
}, clauses = { route_forgiveness = 2 } }
local pre = { [1] = true, [2] = true }
assert(F.initialise(s, 2, pre), "start-one gives one lifetime token")
assert(F.balance(s) == 1)
assert(F.observe(s, 2, pre) == 0, "old badges not rewarded")
assert(F.balance(s) == 1)
local after = { true, true, true, false, false, false, false, false }
assert(F.observe(s, 2, after) == 1, "newly earned gym badge gives token")
assert(F.balance(s) == 2)
assert(F.observe(s, 2, after) == 0 and F.balance(s) == 2,
    "repeat gym check does not generate rewards")
assert(F.canReopen(s, "FR_ROUTE_1"), "missed route can be reopened")
assert(not F.canReopen(s, "FR_ROUTE_2"), "caught routes cannot be reopened")
assert(F.reopen(s, "FR_ROUTE_1") and F.balance(s) == 1)
assert(s.areas.FR_ROUTE_1.spent == false, "reopened route has an open slot")
assert(not F.reopen(s, "FR_ROUTE_1"), "can't buy a duplicate re-open")
assert(s.forgiveness.claimedRoutes.FR_ROUTE_1 == true)
s.areas.FR_ROUTE_1.spent = true
assert(not F.canReopen(s, "FR_ROUTE_1"),
    "the same route can never be forgiven twice")
s.areas.FR_ROUTE_3 = { spent = true, caught = false }
s.failed = true
assert(not F.reopen(s, "FR_ROUTE_3"), "completed/lost runs cannot be saved")
s.failed = false
s.clauses.route_forgiveness = 0
assert(not F.reopen(s, "FR_ROUTE_3"), "disabled clause cannot spend token")
s.clauses.route_forgiveness = 1
assert(F.reopen(s, "FR_ROUTE_3"), "earned token redeems valid missed route")
assert(F.balance(s) == 0)
local baseline = { clauses = { route_forgiveness = 1 } }
assert(F.observe(baseline, 1, { true, true, true }) == 0
    and F.balance(baseline) == 0, "enabled mid-game doesn't back-pay badges")
assert(F.observe(baseline, 1, { true, true, true, true }) == 1,
    "first genuinely new badge after activation grants one")
local delayed = { clauses = { route_forgiveness = 2 } }
assert(F.initialise(delayed, 2, nil))
assert(F.balance(delayed) == 1)
assert(F.observe(delayed, 2, { true, true }) == 0,
    "native flags resolved late must establish baseline without back-pay")
local flags = { [0x820] = true, [0x821] = 1 }
local badgeMap = F.badges({ flags = flags })
assert(badgeMap[1] == true and badgeMap[2] == true
    and badgeMap[3] == false, "real native badge flags accepted")
local devSave = { dev = { enabled = true }, forgiveness = { tokens = 0 } }
local D = assert(loadfile("gen3_dev.lua"))()({
    archive = assert(loadfile("gen3_archive.lua"))()(),
    getState = function() return devSave end,
    setState = function(updated) devSave = updated end,
    getCurrentArea = function() return "FR_ROUTE_1" end,
    inBattle = function() return false end,
    getSession = function() return { party = { { species = 25, hp = 30 } } } end,
    areaSpent = function() return true end,
})
assert(D.grantTestToken() and devSave.forgiveness.tokens == 1,
    "NUZ DEV token grant increments test balance")
assert(devSave.dev.tainted and devSave.dev.edits == 1,
    "test-token grant is audited and marks test save")
print("Gen3 Forgiveness policy smoke PASS")
