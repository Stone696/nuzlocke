-- Future recovery safeguards. This does not create a Pokemon or token.
local Archive = assert(loadfile("gen3_archive.lua"))()()
local mon = {
    species = 25, personality = 4444, otId = 777,
    hp = 0, maxHp = 88, level = 38, nickname = "Bolt",
    ivs = { hp = 31, attack = 27 }, evs = { speed = 180 },
    moves = { { id = 85, pp = 8 }, { id = 98, pp = 18 } },
    nuzlockeDead = true, nuzlockeDeathRecorded = true,
}
local saved, complete = Archive.snapshot(mon)
assert(complete and saved, "complete Pokemon can be snapshotted")
assert(saved.personality == 4444 and saved.otId == 777
    and saved.ivs.hp == 31 and saved.moves[1].pp == 8,
    "recovery archive should include original individual data")
assert(saved.nuzlockeDead == nil and saved.nuzlockeDeathRecorded == nil,
    "do not archive Nuzlocke-only death state")
mon.moves[1].pp = 0
mon.ivs.hp = 1
assert(saved.moves[1].pp == 8 and saved.ivs.hp == 31,
    "archive must deep-copy mutable nested Pokemon data")
local old, ok = Archive.snapshot({ species = 16, hp = 0 })
assert(old == nil and not ok,
    "incomplete old graveyard data must not be treated as restorable")
local cyclic = { species = 16, personality = 3333 }
cyclic.extra = cyclic
local partial, completeCycle = Archive.snapshot(cyclic)
assert(partial ~= nil and completeCycle == false,
    "cycles must not crash saving or produce revival-ready archives")
print("Gen3 archive policy smoke PASS")
