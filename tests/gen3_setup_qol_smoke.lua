-- Gen 3 setup-only resource contract: no engine/ROM required.
local Qol = assert(loadfile("gen3_setup_qol.lua"))()()
local s = { _setup = true, runSettingsLocked = true }
assert(Qol.get(s, "starting_money") == 3000)
assert(Qol.get(s, "starting_pokeballs") == 0)
assert(Qol.set(s, "starting_money", 0))
assert(Qol.set(s, "starting_pokeballs", 20))
assert(Qol.set(s, "starting_rare_candies", 25))
assert(Qol.set(s, "pc_starting_heal_items", true))
assert(Qol.set(s, "pc_starting_vitamins", true))
assert(Qol.set(s, "starting_money", 12345) == false,
    "numeric presets must reject unlisted values")
local native = {
    money = 3000,
    storage = { items = { { id = 13, qty = 1 } } },
    bag = { pockets = { POKE_BALLS = {} } },
}
local Store = {
    addPcItem = function(session, id, qty)
        local items = session.storage.items
        for _, entry in ipairs(items) do
            if entry.id == id then
                entry.qty = entry.qty + qty
                return true
            end
        end
        if #items >= 30 then return false, "pc_full" end
        items[#items + 1] = { id = id, qty = qty }
        return true
    end,
    pcItemsCount = function() return 30 end,
}
s._setup = nil
assert(not Qol.set(s, "starting_money", 3000),
    "setup-only QoL cannot change after the run has begun")
assert(Qol.applyNewGame(s, native, Store), "new-game grant must apply")
assert(native.money == 0, "zero starting money must be preserved")
local counts = {}
for _, entry in ipairs(native.storage.items) do
    counts[entry.id] = entry.qty
end
assert(counts[13] == 11, "medicine kit adds to vanilla PC Potion")
assert(counts[68] == 25, "Candy goes to native PC")
assert(counts[63] == 10 and counts[64] == 10 and counts[65] == 10
    and counts[66] == 10 and counts[67] == 10 and counts[70] == 10,
    "Gen 3 six-vitamin kit must use native item IDs")
assert(#native.storage.items == 16, "native PC contains 16 unique kit items")
assert(s.qolBallsPending == 20, "starting Balls must be deferred")
assert(not Qol.deliverBalls(s, native, Store),
    "scripted pre-Ball Emerald opener may not receive Balls")
assert(Qol.applyNewGame(s, native, Store) == false,
    "repeated creation event must not double-grant items")
-- The engine already observed a usable Ball, but it has since been spent.
s.captureUnlocked = true
assert(Qol.deliverBalls(s, native, Store),
    "first native usable Ball unlocks extra PC Balls")
assert(s.qolBallsPending == 0 and s.qolBallsDelivered == true)
local ballQty = 0
for _, entry in ipairs(native.storage.items) do
    if entry.id == 4 then ballQty = entry.qty end
end
assert(ballQty == 20, "extra Balls must be in PC, never early Bag")
assert(not Qol.deliverBalls(s, native, Store),
    "repeated triggers must never duplicate the reward")
local existing = { setupQol = { starting_money = 3000 } }
assert(Qol.get(existing, "starting_pokeballs") == 0
    and Qol.get(existing, "pc_starting_vitamins") == false,
    "legacy saves receive safe inert defaults")
print("Gen 3 setup-only QoL smoke PASS")
