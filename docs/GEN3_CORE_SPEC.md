# Gen 3 CORE rules — agreed contract

This document records the approved design for the eight CORE rules. **Do not
equate a stored setting with an implemented mechanic.** The menu exposes
completed mechanics without WIP badges and keeps unsupported settings
`[Soon]` and read-only. In-game edge cases still need certification.

## CORE rule matrix

| ID | Label | Default | Gen 3 stage | Behaviour |
| --- | --- | --- | --- | --- |
| `nuzlocke_enabled` | Nuzlocke Enabled | OFF (opt-in) | Working | Master rule enforcement switch; retains progress when switched off |
| `permadeath` | Permadeath | ON | Working (battle) | Record death on `battle.fainted`, deny battle revivals, retire after writeback; field revival seam still needs certification |
| `encounter_limit` | One Encounter Per Area | ON | Working (area policy) | One eligible encounter per resolved area; Area Splits supports configurable grouping of multi-map regions |
| `failed_encounter` | Failed Encounters Count | ON | Working (ordinary wild) | With area limit ON, first eligible wild attempt consumes the area even if missed; OFF means the first successful eligible catch closes it |
| `nickname_rule` | Nickname Requirement | ON | Working | Native catch naming is mandatory; unnamed party/PC Pokémon appear in Nickname Tasks |
| `first_rival_forgiveness` | First Rival Mercy | ON | Working | Opening rival battle consumes one-time mercy at start and protects Pokémon from Nuzlocke deaths |
| `whiteout_ends_run` | Whiteout Ends Run | ON | Working | Losing a qualifying battle marks run failed even if PC reserves exist; story/tutorial/link exceptions need certification |
| `pc_survivors_allowed` | PC Survivors Allowed | OFF | Working | Empty party can receive one eligible living boxed Pokémon after battle writeback; whiteout failure takes precedence |

Defaults of the last two rules were not specified by the original discussion.
For now, use conservative defaults (whiteout fails run / PC rescue OFF).
**The existing Gen 3 save schema remains `gen3_classic_v1`**, so previously
recorded attempts and deaths remain available after upgrading.

## Encounter decision table

| One Per Area | Failed Encounters | Expected consequence |
| --- | --- | --- |
| ON | ON | First eligible wild battle immediately spends area |
| ON | OFF | Wild attempts remain open until successful eligible catch |
| OFF | either | No per-area catch denial; catches are still tracked to preserve history |

Legacy `gen3_classic_v1.areas[map]` entries with no `spent` property are
considered **already consumed**. This avoids reopening previously used
encounters on upgrade. New entries contain `spent` and `attempts`.
Existing entries that recorded a successful catch remain consumed if the user
later disables/re-enables an enforcement rule.

Dupes, Shiny, gift/trade and static-catch legality is evaluated before a prohibited capture can spend an encounter slot. Area keys derive from native map sources and the [Area Splits](GEN3_AREA_SPLITS.md) policy; legacy map-only saves retain their historical records. Counting is deferred until native catching becomes possible.

## Whiteout / PC precedence (agreed)

| Whiteout Ends Run | PC Survivors Allowed | Expected result |
| --- | --- | --- |
| ON | ON | Lost battle ends run regardless of PC survivors |
| ON | OFF | Lost battle ends run; an empty party also ends it |
| OFF | ON | Can continue after party wipe only if eligible boxed Pokémon survive |
| OFF | OFF | Empty party ends run regardless of PC |

PC Survivors is **opt-in**. After native battle writeback and permadeath
retirement, the first eligible living boxed Pokémon is **moved**, not copied
or revived, into an empty party. This avoids the native empty-party softlock
while letting the engine handle normal post-loss relocation. Whiteout Ends
Run still takes precedence. A failed run only marks mod state; the native
save is never deleted.

Recovery excludes Eggs, Bad Eggs, fainted/death-marked Pokémon and creatures
matching an archived death. Explicit progression/ineligibility flags are also
honoured; compatibility with future party restrictions remains unfinished.
Native boxes are in `session.storage.boxes[boxId].mons`.

Nickname Tasks scans party and boxes for unnamed acquisitions, including
gifts, trades and hatched Eggs. Unresolved tasks are visible to the player
but **do not yet prevent use in battle**.

**Mandatory wild-capture naming is enforced entirely by Nuzlocke**, without
requiring a Gen1Recomp engine patch. With CORE → NUZLOCKE and NICKNAME ON,
the mod wraps the native capture YES/NO function, detects the
`catch_nickname_prompt` phase and follows YES without displaying the
optional selection. A secondary `Choice.yesNo` guard handles alternate
UI providers and refuses to complete the capture through NO.
Both guards resolve the battle module with `pcall(require, ...)`; direct
`package.loaded` access was broken because Gen1Recomp hides `package`
in the real mod sandbox. The native naming UI remains responsible for
showing the keyboard and storing the resulting nickname.

An optional engine hook (`battle.catch.nickname_required`) is supported
when present but is **not required** for Nuzlocke's capture enforcement.
Captured Pokémon must
enter a non-empty, non-species-default nickname before the native
catch flow can complete. Empty, cancelled or default names return to
the native naming screen; with the nickname rule OFF, native Yes/No is
restored. This applies to ordinary Gen 3 catches, including Untamed
wandering wild encounters, which use the same native battle flow.
The capture naming guard is also reinstalled if another integration
replaces the UI method after a battle starts.

Starter/gift nickname questions on **Emerald and FRLG** also use a
native field-script Yes/No rather than the battle catch callback.
The additional guard detects the *actual nickname question* from the
native field message (and only when the player has a Pokémon),
answers YES when Nickname Requirement is enforced, and validates the
native `NICKNAME` template exactly like `CAUGHT_MON`.
Unrelated choices still accept NO. The implementation is covered by
a mocked native choice/naming regression test; real-ROM checks remain
important for starter dialogue in every edition.

Opening rival mercy is consumed at battle start, restricted to the three
Oak Lab matchups in FRLG or Route 103 first matchups in R/S/E. Native battle
results, healing and story scripts are not overridden. Real ROM tests for
every starter and edition remain mandatory.

## API / compatibility

- `gen3_core_rules.lua` is the single source for the eight CORE rule IDs,
  implementation status and defaults, separate from the legacy 161-rule list.
- The mod entry remains API **2** to avoid changing Gen 1/2 compatibility.
- `mod.exports.gen3_core` exposes `api`, `schema`, `definitions()`,
  `getRule(key)` and `setRule(key, bool)`. Unsupported rules are rejected
  rather than silently accepted.
- The existing `mod.exports.gen3_classic` experimental statistics interface
  remains available; don't replace it without an explicit API migration.
- `gen3_menu.lua` consumes the shared CORE descriptors; it does not define a
  second set of rule statuses/defaults. The **other** Gen 1/2 rules are still a
  navigable set of implemented categories backed by Gen 3-specific policy
  modules and native action guards; unsupported edition-only rules stay inert.

## Next validation order

1. Verify native name-screen layering and re-prompting on a FireRed catch.
2. Verify Nickname Tasks with a gift, trade, Egg hatch and boxed Pokémon.
3. Verify the one-time opening rival exception for every edition and starter.
4. Verify PC survivor transfer after a native blackout and verify Whiteout
   Ends Run priority on a disposable save.
5. Add battle-use restrictions for pending nicknames and integrate future
   progression/party eligibility clauses.

The automated smokes include `lua5.1 tests/gen3_foundation_smoke.lua` and `lua5.1 tests/gen3_new_core_smoke.lua`; passing a
mocked test does **not** establish in-game compatibility for every edition.
