-- Validate isolation of title drafts, irreversible run lock, and rule gates.
local Run = assert(loadfile("gen3_run_setup.lua"))()()
local old = {
    enabled = true, failed = true, runSettingsLocked = true,
    areas = { ROUTE_1 = { spent = true } },
    graveyard = { { species = 16 } },
    rules = { permadeath = true },
    catchRules = { ban_legendaries = true,
        alphabetlocke_random_letter = 5,
        colorlocke_random_color = 3 },
    setupRules = { starting_money = 5000, starting_pokeballs = 10 },
    randomizer = { random_trainers = true, runSeed = 6724, used = true },
    levels = { scope = 3, edging = true, wins = { gym1 = true } },
}
local draft = Run.newDraft(old)
assert(draft._setup and draft.failed == false and draft.runSettingsLocked == false)
assert(draft.enabled and not next(draft.areas) and not next(draft.graveyard))
assert(draft.setupRules.starting_money == 5000)
assert(draft.catchRules.ban_legendaries)
assert(draft.catchRules.alphabetlocke_random_letter == nil)
assert(draft.catchRules.colorlocke_random_color == nil)
assert(draft.randomizer.random_trainers and not draft.randomizer.used
    and not draft.randomizer.runSeed)
assert(draft.levels.scope == 3 and draft.levels.wins == nil)
draft.rules.permadeath = false
draft.setupRules.starting_money = 0
assert(old.rules.permadeath and old.setupRules.starting_money == 5000,
    "cancelled title draft must leave previously loaded save untouched")
draft.runSettingsLocked = true
assert(Run.mayEdit(draft), "setup stage can edit even if lock selected")
local policies = {
    "gen3_core_rules.lua", "gen3_clauses.lua", "gen3_catch_rules.lua",
    "gen3_battle_items.lua", "gen3_field_items.lua",
    "gen3_services_economy.lua", "gen3_pokemon_stats.lua",
    "gen3_area_splits.lua", "gen3_run_party.lua", "gen3_difficulty.lua",
    "gen3_hardcore_rules.lua", "gen3_qol.lua", "gen3_qol_setup.lua",
    "gen3_variants.lua", "gen3_battle_clauses.lua",
    "gen3_status_bans.lua", "gen3_playstyles.lua",
    "gen3_levels.lua", "gen3_randomizer.lua",
}
Run.commit(draft)
assert(not draft._setup and draft.runSettingsLocked)
assert(not Run.mayEdit(draft) and Run.lockError(draft) == "run_settings_locked")
for _, path in ipairs(policies) do
    local policy = assert(loadfile(path))()()
    local ok, reason = policy.set(draft, "nuzlocke_enabled", true)
    assert(ok == false and reason == "run_settings_locked",
        path .. " must enforce irreversible run lock")
end
local core = assert(loadfile("gen3_core_rules.lua"))()()
assert(not core.set(draft, "nuzlocke_enabled", false))
local catch = assert(loadfile("gen3_catch_rules.lua"))()()
assert(not catch.toggleNational(draft, 25), "species picker is also locked")
local open = Run.newDraft(draft)
assert(open.runSettingsLocked == false and open._setup == true)
assert(core.set(open, "nuzlocke_enabled", false))
print("Gen 3 new-run draft isolation and all category settings locks PASS")
