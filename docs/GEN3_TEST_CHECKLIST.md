# Gen 3 Nuzlocke — Manual test checklist

**Branch:** `feature/gen3-foundation` · **Release target:** `v3.0.0-BETA` · **Scope:** the complete Gen 3 feature matrix, native integration, UI and regression testing · **Updated:** 28 October 2026.

This is the live, human-in-the-loop test plan for the Gen 3 beta. It follows the [ported/adapted/new feature matrix](GEN3_FEATURE_MATRIX.md) and complements automated smoke tests; passing a mocked test does not replace real ROM/gameplay validation.

> **Safety:** Use backed-up **disposable** saves. These tests can permanently remove party Pokémon and mark the Nuzlocke run lost. Do not test on a valuable save. Start fresh test runs as indicated; a lost run cannot be reset with the menu.

**Reporting:** Tick a box **only after its expected behaviour passes**. For failures or blocked tests, leave the box unticked and add the test ID to the `Issues / results` section at the end. Include a screenshot, exact game edition and reproduction steps.

## Before starting

- [ ] **P01 — Install current branch.** Re-download `feature/gen3-foundation`, import into the Gen1Recomp MODS tab, and verify Nuzlocke is enabled for your game. **Expected:** Game launches without a mod-load error.
- [ ] **P02 — Prepare three disposable saves.** One for **A: catch rules**, one for **B: fainting**, one for **C: whiteouts**; separate save slots or independent backups are fine. Give yourself Master Balls, Poké Balls, Revives, and at least two Pokémon where useful. **Expected:** All tests can be restarted without risking progress.
- [ ] **P03 — Record environment.** Note the exact Gen1Recomp build/commit and game/version (FireRed, LeafGreen, Ruby, Sapphire or Emerald). **Expected:** Results can be reproduced.

## NUZ DEV test reset controls (optional, recommended)

To repeat encounters on the same route, open **Start → NUZ MENU**, hold **Select** and tap **A** (default keyboard: **Tab + Enter** or **Tab + Z**), then choose **OPEN DEV TOOLS → ENABLE DEV MODE** and confirm. Use **RE-ARM CURRENT** to reopen a route.
See [GEN3_NUZ_DEV.md](GEN3_NUZ_DEV.md) for the complete menu and safety notes.

- [ ] **V01 — Hidden dev entry.** NUZ DEV is absent from the regular NUZ MENU. Hold SELECT and tap A from the NUZ MENU home screen (or enter the older eight-direction code with distinct key presses). **Expected:** DEV ACCESS opens without changing the save; cancelling returns home; opening the tools and confirming ENABLE DEV MODE permanently flags the test save. The code is not accepted in a submenu or new-game setup.
- [ ] **V02 — Re-arm current.** After consuming an area's first encounter, select RE-ARM CURRENT and confirm. **Expected:** The area's catch slot is open again, without touching actual caught Pokémon.
- [ ] **V03 — Edit an area.** Use EDIT CURRENT AREA or EDIT ALL AREAS to mark one map OPEN, SPENT and CAUGHT. **Expected:** Area state and later catch decisions follow your edit.
- [ ] **V04 — Cancel/global reset.** Try CLEAR ALL AREAS, cancel, confirm entries remain; repeat and confirm. **Expected:** All encounter records clear **only** after explicit confirmation.
- [ ] **V05 — Inspect/export.** Open STATE INSPECTOR and PRINT DEBUG REPORT. **Expected:** Useful live values and `[NUZ DEV]` debug lines in the game console.
- [ ] **V06 — Reset guard.** Attempt to clear run failure with an empty or fully fainted party. **Expected:** Refused. With a living party, manual un-fail is permitted, but no Pokémon is restored.
- [ ] **V07 — Disable tools.** Disable NUZ DEV. **Expected:** Mutating features become inaccessible; permanent test-run marker remains. Reopening the menu or restarting requires entering the hidden code again.
- [ ] **V08 — Full archive restore.** On a disposable save, faint a Pokémon with full archive, then use NUZ DEV → RESTORE FROM GRAVE. **Expected:** confirmation, half max HP, original IVs/moves/identity/shiny, one removed graveyard entry; party-first or PC placement. Duplicate, incomplete-archive, full-PC and mid-battle cases refuse without any change. It must not unlock a permanently lost run.

**Important:** Re-arming does not reverse an actual catch or return a Ball. For example, after completing E05, use V02 before testing E07 on the same map; otherwise use a new, unused route.

## A. Menu & rule-state smoke tests (save A)

- [ ] **M01 — Open menu.** Press Start → NUZ MENU → NUZ RULES → CORE. **Expected:** No errors, readable labels, **exactly eight** CORE rules.
- [ ] **M02 — Supported labels.** Inspect Nuzlocke Enabled, Permadeath, One Per Area and Failed Encounters. **Expected:** Each shows an accurate ON/OFF state and can be changed independently.
- [ ] **M03 — Implemented CORE labels.** Inspect Whiteout Ends Run, Nickname, First Rival Mercy and PC Survivors. **Expected:** all show working ON/OFF controls without obsolete [WIP]/[Soon] prefixes; enforce the relevant native action. Manual edition testing remains required.
- [ ] **M04 — Navigation.** Scroll through CORE, back to NUZ RULES, open some other categories, then back to NUZ MENU and the game. **Expected:** Scrolling, cursor, A/B and reopening all work; no clipped/unreadable menu entries or stuck overlays.
- [ ] **M05 — Master toggle.** Switch NUZLOCKE OFF → ON → OFF → ON. **Expected:** Label changes immediately; rule values in other rows do not reset.
- [ ] **M06 — Compact PLAYSTYLES.** Open NUZ RULES → PLAYSTYLES. **Expected:** Exactly four rows: SHINY NUZ toggle, its DETAILS directly below, HARDCORE toggle, its DETAILS directly below. No stray rule-description lines.
- [ ] **M07 — Details and return.** Open both DETAILS screens, scroll their explanations and press B. **Expected:** Complete rules are visible in the correct details screen and the selector returns to the same row. Each toggle changes only its corresponding playstyle.
- [ ] **M08 — Advanced Rules navigation.** Open NUZ RULES → ADVANCED RULES. **Expected:** Exactly nine categories in order: CATCH RULES, BATTLE CLAUSES, STATUS BANS, VARIANTS, BATTLE ITEMS, FIELD ITEMS, SERVICES & ECONOMY, POKEMON STATS, AREA SPLITS.
- [ ] **M09 — Advanced category navigation.** Open all nine ADVANCED RULES categories, change one working setting, open its DETAILS where offered, then return twice. **Expected:** each category has implemented controls; any specifically unsupported option is inert and clearly identified. VARIANTS offers Type Locke and Catch Draft, not Wonderlocke. B returns to the selected category and then ADVANCED RULES; settings persist when unlocked.
- [ ] **M10 — Journal and Mod Support.** **Expected:** WORLD/UI planning rows are absent; **RUN JOURNAL** replaces separate Almanac, NUZ STATUS and NUZ NOTICES entries, while its EVENT HISTORY remains accessible. **MOD SUPPORT** lists Untamed, National Dex, G9 Sprites, Modern Spawns and HD Sprites plus shiny/randomiser diagnostics. It distinguishes UNKNOWN, NOT FOUND, DETECTED, API READY and INACTIVE without calling gameplay/spawn APIs or editing rules. An API READY or installed mod still reports combined runtime as NOT VERIFIED. Untamed's hook readiness is not inferred from installation. NUZ DEV is absent from the normal home menu.
- [ ] **M10a — Live companion diagnostics.** In MOD SUPPORT, check each of the five entries with only Nuzlocke enabled, then with each companion installed, disabled and re-enabled. Ensure PUBLIC API shows READY only for companions exporting the documented capabilities; state changes show ACTIVE/INACTIVE when available. Open each detail page and return; verify no Nuzlocke setting or save value changed. With all six mods present, compatibility remains NOT VERIFIED until manually tested.
- [ ] **M11 — Working Catch Rules.** Open ADVANCED RULES → CATCH RULES, toggle No Legendaries, No Mythicals, No Pseudos, No Static Encounters and No Fishing, and cycle Maximum BST. **Expected:** Those six legacy controls plus Town Catches, Alphabetlocke mode/letter, Allow Glitches, Gift Pokémon/Gift Slot Policy and In-Game Trades/Trade Slot Policy persist. Overworld Encounters must be absent, and Untamed wandering wilds must follow the normal area/catch rules automatically. With CORE → NUZLOCKE ON, supported wild-capture and fishing checks follow [Advanced Rules](GEN3_ADVANCED_RULES.md).
- [ ] **M11a — Catch bans and encounter slots.** With FAILED ENCOUNTERS ON, attempt a prohibited wild capture on an unused route. **Expected:** No catch, accurate RUN JOURNAL > EVENT HISTORY message and no spent encounter slot. Catch an allowed wild Pokémon there; the slot is then consumed.
- [ ] **M11b — Save and master switch.** Save/reload the selected bans; then disable CORE → NUZLOCKE and try a prohibited capture. **Expected:** Settings persist but native capture is allowed while master enforcement is OFF.
- [ ] **M11c — Final species.** Try a randomised Pokémon and an Untamed overworld encounter. **Expected:** The bans inspect the species actually fought, and shiny exceptions cannot override a prohibited species.
- [ ] **M11d — No Fishing.** On a water route where fishing normally works, enable No Fishing and try Old/Good/Super Rod. **Expected:** Rod use is stopped before fishing begins, and RUN JOURNAL > EVENT HISTORY explains why; surf and ordinary wild battles are unchanged. Turn OFF and verify rod use resumes.
- [ ] **M11e — No Static Encounters.** At a scripted fixed wild Pokémon, enable No Static and attempt capture. **Expected:** Ball capture is refused without ending the story battle or spending the route slot. Roamers and normal random wilds remain legal. Restore the option afterwards.
- [ ] **M11f — Battle Clauses menu.** Open ADVANCED RULES → BATTLE CLAUSES. **Expected:** OHKO toggles ON/OFF; Flinch, Trap, No Setup, Evasion, Accuracy Drops and Other Stat Drops are functional; the five side-scoped rules cycle OFF → SELF → ENEMY → ALL → OFF. Evasion cycles ON/OFF.
- [ ] **M11fa — OHKO Clause.** Enable OHKO ON and use Guillotine, Horn Drill, Fissure and Sheer Cold from both sides, including a called move and Lock-On. Each must fail after normal PP cost without reducing HP or creating a faint. OFF and master Nuzlocke OFF restore native behaviour. Save/reload persistence and LOCK FOR RUN must work.
- [ ] **M11g — Battle effect enforcement.** Using a disposable save, test Headbutt/King's Rock flinch, Wrap/Bind partial trapping, Swords Dance/Dragon Dance setup, Double Team/Minimize evasion, Sand-Attack accuracy loss and Growl/Tail Whip other stat drops. **Expected:** The selected source side's effects are suppressed but unrelated damage, PP and passive effects still work. See [Battle Clause tests](GEN3_BATTLE_CLAUSES.md).
- [ ] **M11k — Expanded Catch Rules.** Verify Town Catches OFF refuses outdoor town/city wild catches without using the route slot; ON permits native map-slot catches. Alphabetlocke CHOOSE enforces an A–Z canonical species initial, RANDOM selects/persists a represented initial, and Allow Glitches OFF refuses invalid/unregistered species. The redundant Overworld Encounters option must be absent; visible Untamed Pokémon use ordinary catch restrictions.
- [ ] **M11l — Scripted Gift Pokémon.** With Gift Pokémon OFF, an optional scripted gift must fail without adding a Pokémon or consuming a map slot. The opening starter must still be obtainable. With Gift Pokémon ON and Gift Slot Policy AREA, a successful gift consumes the current map's slot; BONUS does not.
- [ ] **M11m — NPC In-Game Trades.** With trades OFF, the native NPC trade must not reach the party exchange. With trades ON and AREA, completing an exchange spends the current map's slot, but an interrupted attempt does not. BONUS preserves that slot. Verify the outgoing Pokémon is never lost on a denied trade.
- [ ] **M11p — Overworld rule removed.** Verify no Overworld Encounters row appears anywhere in Gen 3 Catch Rules. With Untamed-Advanced installed, a wandering wild Pokémon counts as a normal map encounter with no extra enable switch.
- [ ] **M11n — PKMN BAN.** Open the paginated National Dex picker (20 entries per page); ban and unban #025 Pikachu. Verify the count/save persistence, exact National Dex mapping for Hoenn, and banned catches/gifts/NPC trades. With National Dex installed, navigate to #906 Sprigatito, ban it and check the randomiser excludes it; without National Dex, the picker stops at 386.
- [ ] **M11o — Colorlocke.** OFF/RANDOM/CHOOSE mode, CHOOSE-only colour selector; choose YELLOW to allow Pikachu but block RED Charmander. RANDOM colour must persist after restart and remain consistent for wild, Untamed overworld, gift and NPC trade acquisitions. Species with no canonical or custom colour metadata are not rejected just for being uncoloured.
- [ ] **M11q — VARIANTS Type Locke.** Choose MONO FIRE, then DUO FIRE/WATER, and try matching and off-type wild Pokémon with Failed Encounters ON. Off-type battles must not spend a route. Confirm a dual-type Pokémon can match either lane, and only 1–6 selectors appear for the active mode. Test optional gift/NPC trade rejection before mutation and Shiny Clause precedence. See [Variants](GEN3_VARIANTS.md).
- [ ] **M11r — VARIANTS RANDOM types.** With Catch Draft OFF, choose several RANDOM lanes; verify distinct types are assigned and displayed after the first encountered/acquired Pokémon, then persist across saves and reloads. Confirm manually selected types are not duplicated in RANDOM lanes. The removed trade-variant row does not appear.
- [ ] **M11s — VARIANTS Catch Draft.** With DUO and Catch Draft ON, check AWAIT CATCH type slots and DRAFT 0/2 progress. Failed Balls must not add types; two successful wild catches with different types must draft them in order. Dual types prefer an unselected secondary type; repeated already-drafted types must not fill extra lanes. During partial draft, wild catches remain free, while gifts and NPC trades may only match existing drafted types and must not fill a lane. When full, off-type wilds may not spend an area. Reload to confirm persistence; changing mode or switching Catch Draft OFF clears the draft. See [Variants](GEN3_VARIANTS.md).
- [ ] **M11t — BATTLE ITEMS.** Check No Healing Items refuses HP medicine, status cures, revives and healing berries before consumption; No X Items refuses stat boosters, Guard Spec and Dire Hit while Poke Doll still works. Both default OFF and honour the master Nuzlocke switch.
- [ ] **M11u — No Catching.** Enable with Failed Encounters ON; a wild battle on an unused route must not claim the route. Native and custom Ball use is refused before inventory/turn mutation. Gifts/NPC trades remain controlled by Catch Rules.
- [ ] **M11v — Ball Per Encounter.** Cycle OFF/1/2/3/5/10. With 2, two permitted failed Balls count, a third is refused before use, and the next wild battle begins at zero. Illegal catch bans do not consume throw budget; Hardcore still refuses non-Ball items. See [Battle Items](GEN3_BATTLE_ITEMS.md).
- [ ] **M11w — FIELD ITEMS bag and party restrictions.** Enable No Repels, No Escape Rope, No Field Heal, No PP Items, No TMs, No Rare Candy. Test each from Bag and direct Party Menu: denial must leave item count, HP/PP/level/moves, repel steps and current location unchanged. HM teaching must still work. No PP Items should also deny battle PP recovery without using a turn. See [Field Items](GEN3_FIELD_ITEMS.md).
- [ ] **M11x — Travel Restrictions.** Cycle NORMAL → NO FLY → NO FLY+TELEPORT. Check player-initiated Fly/Teleport in the party menu; Dig, story-scripted transport and other unrelated field moves must continue to work normally.
- [ ] **M11h — Status Bans menu.** Open ADVANCED RULES → STATUS BANS. **Expected:** No Status Moves and six child status bans cycle OFF/SELF/ENEMY/ALL. Parent ON synchronises/hides child rows; returning OFF resets/reveals them. Sleep Clause is a separate ON/OFF toggle that stays visible even when the parent is ON.
- [ ] **M11i — Status effects and Yawn.** With a disposable party, test Thunder Wave/ThunderPunch, Toxic/Poison Sting, Will-O-Wisp/Flamethrower, Ice Beam, Confuse Ray/Psybeam and Sleep Powder/Yawn. **Expected:** Banned status is refused for the selected source side, damaging moves still deal damage, Yawn does not schedule drowsiness when banned, Rest self-sleep remains legal. See [Status Bans](GEN3_STATUS_BANS.md).
- [ ] **M11j — Sleep Clause.** Enable Sleep Clause with Sleep Ban OFF. Sleep one opposing Pokémon, switch it out, then try sleeping a second. **Expected:** Second sleep fails until first wakes/is cured/faints. Rest does not consume the slot. Repeat for enemy-induced sleep on your party, Yawn delayed resolution, OFF/Nuzlocke-disabled behaviour and saved rule persistence.
- [ ] **M12 — Save persistence.** Enable Nuzlocke, change one rule, save **in game**, restart and reopen the menu. **Expected:** Master switch and saved rule values persist.

## A2. CORE gameplay integration (disposable saves; requires ROM validation)

- [ ] **N01 — Catch naming (mod-only).** With CORE → NUZLOCKE ON and NICKNAME ON, catch a wild Pokémon using the normal unmodified Gen1Recomp engine. **Expected:** No nickname Yes/No question is displayed; native naming opens immediately.
- [ ] **N01a — PC-bound capture.** Fill the party, catch a wild Pokémon, and attempt an empty/species-default nickname. **Expected:** Naming reopens; the catch cannot complete and the PC transfer message cannot finish until a custom nickname is confirmed.
- [ ] **N01b — No-bypass fallback.** If another UI mod still displays an unexpected Yes/No prompt, choose No. **Expected:** Nuzlocke still forces the naming path, never completing a catch unnamed. Record the other mod and game version for diagnosis.
- [ ] **N02 — Reject default.** Submit an empty name, whitespace-only name, cancelled name or exact species name. **Expected:** Native naming reopens; the Pokémon is not accepted unnamed. A custom name finishes normally.
- [ ] **N02a — Switch off enforcement.** Turn NICKNAME OFF and catch another wild Pokémon. **Expected:** The native Yes/No choice is offered again, and No is accepted.
- [ ] **N02b — Repeat after load.** Save/reload and catch another Pokémon with the rule ON. **Expected:** No Yes/No bypass after reopening the game.
- [ ] **N02c — Untamed compatibility.** Catch a wandering overworld Pokémon with NICKNAME ON. **Expected:** It uses the same mandatory naming flow.
- [ ] **N03 — Gift/trade/Egg.** Acquire each without a naming prompt, then open NUZ MENU → NICKNAME TASKS. **Expected:** Unnamed acquisitions appear, including those in a PC box. Rename them and confirm they disappear.
- [ ] **N04 — Persist.** Save and reload after naming a Pokémon and after leaving one name pending. **Expected:** Correct nicknames and pending entries remain consistent.
- [ ] **R01 — First rival, Kanto.** In a NEW FireRed or LeafGreen run, enable mercy before the Oak Lab rival battle and let your starter faint. **Expected:** No death/graveyard entry and no Nuzlocke failure; the native story proceeds.
- [ ] **R02 — Mercy consumed.** Win the opening rival battle, then revisit later rival battles. **Expected:** The opening fight consumes mercy on start, whether won or lost; later fainting is permanent.
- [ ] **R03 — Hoenn editions.** Repeat R01–R02 for Ruby, Sapphire and Emerald, changing starter matchups. **Expected:** Only Route 103's opening rival fight is exempt.
- [ ] **C01 — PC recovery.** With Whiteout Ends Run OFF and PC Survivors ON, box a healthy spare, then let the party wipe. **Expected:** One eligible living boxed Pokémon moves into the now-empty party; the run continues.
- [ ] **C02 — Whiteout priority.** Enable both Whiteout Ends Run and PC Survivors, then lose with a living reserve boxed. **Expected:** Run fails regardless; the reserve remains boxed.
- [ ] **C03 — No survivors.** Wipe with only Eggs, dead/fainted or ineligible boxed Pokémon. **Expected:** Run fails; no Pokémon is revived or cloned.
- [ ] **C04 — Recovery persistence.** Save and reload after C01. **Expected:** Rescued Pokémon exists exactly once, in the party, absent from its old box.

**Known remaining limitation:** Unresolved gift/trade/Egg nicknames are tracked and can be renamed, but battle-use prevention is not yet complete for every acquisition source. All checks above need real game testing; passing a Lua smoke does not certify them.

## Rule feedback and Rare Candy regression

Follow **F01–F11** in [GEN3_FEEDBACK.md](GEN3_FEEDBACK.md), especially a capped Rare Candy from the overworld bag, cancelled catch reasons, EXP edging messages, and viewing long messages through RUN JOURNAL > EVENT HISTORY.

## RANDOMIZER smoke (disposable save)

Run **R01–R14** in [GEN3_RANDOMIZER.md](GEN3_RANDOMIZER.md): deterministic wild/fishing/trainer teams, seed editor, configuration locking, pool legality and ROM/story progression.

## LEVELS smoke (disposable save)

Run tests **L01–L10** in [GEN3_LEVELS.md](GEN3_LEVELS.md), including
scope transitions, the first Gym, bank persistence through PC/reload and
Rare Candy consumption. Mocked CI is not a replacement for ROM tests.

## B. Encounter rules (save A, Nuzlocke ON)

**Important:** `One Per Area` resolves a configured encounter-area identity from native map data using **AREA SPLITS**. Some caves, floor groups and Safari areas can share or split slots according to the selected policy. Check [Area Splits](GEN3_AREA_SPLITS.md) before reporting a grouping bug.

- [ ] **E01 — First encounter.** On unused Route A, encounter the first wild Pokémon and use a Master Ball. **Expected:** Capture succeeds; Encounter Tracker identifies Route A as caught.
- [ ] **E02 — Repeat encounter.** On that same map, encounter another wild Pokémon and throw a Master Ball. **Expected:** Capture fails despite Master Ball (Ball may still be consumed).
- [ ] **E03 — New map.** Walk to unused Route B and catch its first wild Pokémon. **Expected:** Capture allowed, independent of Route A.
- [ ] **E04 — Revisit a used map.** Return to Route A, including after leaving and re-entering. **Expected:** Additional wild captures remain blocked.
- [ ] **E05 — Failed Encounters ON, Pokémon KO'd.** On unused Route C, leave `ONE PER AREA: ON` and `FAILED ENC.: ON`; knock out its first eligible wild Pokémon. **Expected:** The next Pokémon on Route C cannot be caught.
- [ ] **E06 — Failed Encounters ON, fleeing.** On another unused Route D, run from the first eligible wild Pokémon. **Expected:** The next Pokémon on Route D cannot be caught.
- [ ] **E07 — Failed Encounters OFF.** On unused Route E, set `FAILED ENC.: OFF`; run from or KO the first eligible wild Pokémon, then try again. **Expected:** Another encounter can be caught; an unsuccessful encounter doesn't spend the catch slot.
- [ ] **E08 — Catch after a failed attempt.** Still on Route E with `FAILED ENC.: OFF`, make a successful first catch, then throw a Ball at a subsequent Pokémon. **Expected:** Successful capture consumes the slot; later capture fails.
- [ ] **E09 — One Per Area OFF.** On any route, switch `ONE PER AREA: OFF`. **Expected:** Multiple wild Pokémon can be caught; switching it back ON restores per-area restrictions.
- [ ] **E10 — Master switch OFF.** Switch `NUZLOCKE: OFF` and try catching on a normally locked route. **Expected:** Nuzlocke no longer blocks catching. Turn it back ON afterwards; prior run records should not be wiped.
- [ ] **E11 — Tracker reflects outcomes.** Visit ENC TRACKER and RUN JOURNAL → RUN RULE DETAILS. **Expected:** Claimed areas and catches distinguish caught / spent / still-open areas, and totals do not reset when entering another map.
- [ ] **E12 — Persist encountered areas.** Save in-game, restart, revisit a previously spent map with Nuzlocke ON. **Expected:** Capture remains restricted; the tracker retains entries.
- [ ] **E13 — Trainer fights do not spend wild encounters.** Fight a trainer in a new area *before* any wild battle there. **Expected:** The area's first eligible wild catch is still available.

## C. Permadeath (save B; use at least two party Pokémon)

- [ ] **D01 — Permadeath ON, faint event.** Enable Nuzlocke and Permadeath. Let exactly one Pokémon faint during a trainer battle while another remains alive. **Expected:** It stays fainted and unavailable during the battle; no immediate party-array removal that breaks forced switching.
- [ ] **D02 — Revives denied in battle.** While that first Pokémon remains fainted and battle continues, try Revive (or Max Revive). **Expected:** Revival is refused.
- [ ] **D03 — Post-battle retirement.** Finish the battle. **Expected:** Only the fainted Pokémon disappears from the native party; the surviving Pokémon remains valid.
- [ ] **D04 — Graveyard details.** Open GRAVEYARD and RUN JOURNAL. **Expected:** One death entry, a Pokémon name (nickname or species), readable species name and location (e.g. Pidgey / Route 1), correct level, no duplicates. Internal species/map IDs should not be the primary player-facing text.
- [ ] **D05 — Permadeath OFF.** On a *fresh second faint*, disable Permadeath but keep Nuzlocke ON. **Expected:** Pokémon remains in the party after battle, isn't recorded as dead, and native revival items are usable.
- [ ] **D06 — Re-enable Permadeath.** Turn Permadeath back ON and faint another Pokémon. **Expected:** The next death is enforced normally; previous recorded deaths are retained.
- [ ] **D07 — Nuzlocke OFF.** Disable the master switch, faint a Pokémon in battle. **Expected:** Native Pokémon faint/revive behaviour; no Nuzlocke deletion or new graveyard record.
- [ ] **D08 — Restart after deaths.** Save/restart, inspect party, GRAVEYARD and RUN JOURNAL. **Expected:** Removed party members stay removed, recorded deaths persist once, and enabled rule values persist.

## D. Whiteout & run failure (save C: intentionally destructive)

Do these on separate save copies. **PC Survivors Allowed is implemented**; its native transfer and whiteout precedence must be tested. A failed run is terminal, so do not use valuable saves.

- [ ] **W01 — Whiteout ON with PC reserves.** Keep a healthy Pokémon in the PC and intentionally wipe the whole battling party with `WHITEOUT FAILS: ON`. **Expected:** Nuzlocke run is marked LOST **despite** living Pokémon in the PC; normal game save is *not* automatically deleted.
- [ ] **W02 — Lost run is locked.** After W01, revisit CORE. **Expected:** You cannot turn rule switches back on/off to reset the lost-run state.
- [ ] **W03 — Whiteout OFF, PC rescue comparison.** On one save, disable WHITEOUT FAILS and enable PC Survivors; lose the party while a healthy PC Pokémon exists. **Expected:** that existing survivor is moved to an empty party slot once. On a second save with PC Survivors OFF or no eligible survivor, an empty party cannot continue. WHITEOUT FAILS ON overrides PC rescue.
- [ ] **W04 — PC box unchanged.** After a whiteout, inspect the PC/storage if the game permits it. **Expected:** Nuzlocke has not removed or marked otherwise healthy boxed Pokémon as dead.

## CLAUSES milestone — Dupes / Shiny exceptions

Run the separate **[Gen 3 CLAUSES test matrix](GEN3_CLAUSES.md)**, which has
14 detailed checks covering SPEC/FAM/SPLIT, shiny allowances, save
persistence, NUZ DEV resets and other editions.

- [ ] **L01 — Dupes SPEC:** catch an owned species on a new route; it must be
  blocked **without spending** that route's normal catch.
- [ ] **L02 — Dupes FAM/SPLIT:** verify Caterpie-line evolutions count as
  one family, while branching Eevee evolutions differ under SPLIT.
- [ ] **L03 — Shiny exception:** on a spent route, an eligible shiny may be
  caught using an available exception, but a normal Pokémon may not.
- [ ] **L04 — Allowance accounting:** failed Balls do not spend a Shiny Clause
  allowance; a successful exceptional capture does.
- [ ] **L05 — Clauses working scopes.** Egg receipt/hatch claim modes, badge-earned/start Route Forgiveness tokens, Roamer slot and Shiny Rate can be configured and persist. Verify each native path. Ordinary Pokémon revival remains explicitly disabled; the native shiny artwork must remain correct.
- [ ] **L06 — Development reset:** NUZ DEV's RESET CLAUSE COUNTS requires
  confirmation and resets the shiny allowance count and captured-species log
  without altering party, boxes or graveyard.

## Roamer Clause (implemented; runtime certification required)

Requires an active roaming legendary, so use a disposable late-game save.
The Gen 3 engine emits `roamer.encountered` when supported, but the result
still needs confirmation in real FireRed / Hoenn gameplay. The full set of
six roamer-specific tests is [R01–R06](GEN3_CLAUSES_NEXT.md).

- [ ] **R01 — Flee without spending route.** ROAMER SLOT + Failed Encounters ON. Flee a native roaming encounter; the normal route remains open.
- [ ] **R02 — Catch later.** Encounter the same roamer on a second route and catch it. The roamer's species slot closes but the second route's grass slot remains available.
- [ ] **R03 — Stable results.** Save and load; the roamer claim remains closed. NUZ DEV clause reset clears the debug claim only, not the actual Pokémon.

## Shiny Rate & future Forgiveness archive

Use a **disposable save** and the new [Shiny Rate contract](GEN3_CLAUSES_NEXT.md)
for the scope and provider-ownership decisions. The 1/8192 native chance is
not something you can validate with a handful of normal encounters; use
**ALWAYS** to verify the enhancement path deterministically.

- [ ] **SR01 — Six-entry CLAUSES menu.** Open CLAUSES. **Expected:** Dupes,
  Shiny Clause, Shiny Rate, Roamer Clause, Egg Encounter and Route Forgiveness.
  Shiny Colours and Shiny Intro should **not** appear; original Gen 3
  shiny palettes/animations are unchanged.
- [ ] **SR02 — ALWAYS on a fresh wild encounter.** Set Shiny Rate ALWAYS.
  Enter a new normal wild battle. **Expected:** The Pokémon is visibly shiny
  even without any Shiny Clause catch allowance.
- [ ] **SR03 — Saved individual shiny.** Catch that enhanced shiny and save,
  then restart and view its summary/party sprite. **Expected:** It remains
  shiny, with the same personality, species and original IVs/stats.
- [ ] **SR04 — Master OFF doesn't suppress odds.** Switch Nuzlocke OFF but
  leave Shiny Rate ALWAYS; encounter a new wild Pokémon. **Expected:** Still
  shiny; the independent difficulty/visual configuration does not depend on
  hardcore enforcement.
- [ ] **SR05 — No trainer/tutorial boost.** Battle a trainer, and, if
  available, check a scripted tutorial battle. **Expected:** Shiny Rate
  doesn't artificially change the opponent's or tutorial Pokémon's identity.
- [ ] **SR06 — Roamer exclusion.** If available, test a persistent roaming
  Pokémon while Shiny Rate ALWAYS. **Expected:** The enhanced rate does not
  randomly change that same roamer's shiny identity between encounters.
- [ ] **SR07 — External ownership.** If a compatible external shiny provider
  is active, open Shiny Rate. **Expected:** EXTERNAL is displayed; selecting
  it doesn't alter that provider's rate or stack another roll.
- [ ] **SR08 — Native mode.** Set Shiny Rate back to NATIVE. **Expected:**
  No forced-shiny behaviour on normal non-shiny Pokémon.
- [ ] **AR01 — Death archives.** Let a new Pokémon faint and open the Graveyard.
  **Expected:** The existing readable memorial remains correct; archived
  Pokémon data is retained; a developer-only full-archive restore is available via the hidden NUZ DEV screen. Ordinary revival remains disabled.
- [ ] **AR02 — Legacy deaths.** Reopen an older graveyard entry without the
  complete archive. **Expected:** It still shows species, level, nickname (if
  stored) and location, but does **not** offer approximate restoration.

**Egg Encounter and Route Forgiveness are implemented for provenance, badge tokens and missed-route redemption.** Ordinary Pokémon revival with a Forgiveness token is not implemented; the separate developer-only full-archive restore is not part of this clause.

## Egg Encounter & Route Forgiveness

See [GEN3_EGGS_FORGIVENESS.md](GEN3_EGGS_FORGIVENESS.md) for the full
twelve-case checklist and exact [WIP] limitations.

- [ ] **EG01 — Receipt claim:** With RECEIVED selected, tag an Egg on Route A
  then hatch on Route B. The A encounter slot is spent *at hatch*.
- [ ] **EG02 — Hatch claim:** With HATCHED selected, the hatch location's
  encounter slot is spent when the Egg hatches.
- [ ] **EG03 — Occupied area:** Hatching into an already spent area records
  the Pokémon as INELIGIBLE without deleting it; using the Pokémon in battle
  is **not enforced yet**.
- [ ] **FG01 — Starting token:** START 1 grants a single token once; toggling
  it or restarting does not grant another.
- [ ] **FG02 — Badge reward:** A new Gym Badge after enabling grants one
  token, not multiple tokens on map transitions.
- [ ] **FG03 — Route redemption:** Spend one token to reopen a failed route.
  Test CANCEL first, then YES; caught routes and previously forgiven routes
  cannot be reopened again.
- [ ] **FG04 — Development testing:** NUZ DEV → ADD TEST TOKEN grants one
  test token after confirmation, leaving the test-run marker set.
- [ ] **FG05 — Recovery limitation:** The ordinary Route Forgiveness Pokémon-revival option remains
  [Soon] and must never spend a token.

## E. Compatibility & known pending features

- [ ] **C01 — Gen 1 regression.** If you have an original Red/Blue/Yellow setup, open the original Nuzlocke UI. **Expected:** Established Gen 1 menu and rules unchanged.
- [ ] **C02 — Gen 2 regression.** If you have Gold/Silver/Crystal configured, open its Nuzlocke UI. **Expected:** Established Gen 2 menu unaffected.
- [ ] **C03 — Second Gen 3 edition.** Repeat **M01, E01–E03 and D01–D03** in another edition (ideally Emerald after FireRed). **Expected:** Same basic results; record the exact edition.
- [ ] **C04 — Double battle stress test.** If convenient, faint one player Pokémon during a native double battle. **Expected:** Forced switching does not crash or shift the wrong party slot; death is recorded exactly once.
- [ ] **C05 — Implemented versus unsupported controls.** Inspect Nickname, First Rival Mercy, PC Survivors, Gifts, Shiny Rate and Randomiser. **Expected:** implemented controls show live values and enforce their working paths; only explicitly unsupported individual options are marked inert. No Wonderlocke, obsolete Almanac, standalone NUZ NOTICES or Overworld Encounters toggle remains in the Gen 3 menu.

### Current known limitations (not automatic regressions)

- Encounter areas use native map evidence with configurable **Area Splits**. Test floor/group policies per edition and with third-party maps.
- Field revival routes and custom item-provider mods require separate review.
- Early rival mercy, catch naming, PC survivors, supported gifts/statics, Dupes/Shiny clauses and the Gen 3 randomiser are implemented. Remaining issues are live-ROM and third-party edge-case certification, not blanket unimplemented features.
- Whiteout handling and Gen 3 special battle types (Safari, link/multi, scripted/tutor battles, Battle Frontier) need edition-specific certification.
- The source repository's general legacy CI has outdated manifest assertions; the dedicated Gen 3 Lua smoke is a separate check.

## Issues / results

**Tester:**  
**Date:**  
**Gen1Recomp build or commit:**  
**Nuzlocke branch commit:**  
**Game / edition:**  
**Other mods enabled:**  

| Test ID | PASS / FAIL / BLOCKED / SKIP | Notes / actual behaviour / screenshot |
| --- | --- | --- |
| | | |
| | | |
| | | |
| | | |
| | | |

**Crash/error log:**  
**Reproduction steps for any failure:**  
**Save backup available?** Yes / No

When reporting, send me the **test ID(s)** and observed result, e.g.:
`E07 FAIL — FireRed, Failed Encounters OFF, ran from Pidgey, next wild capture still blocked.`


## Shiny Nuzlocke playstyle (v3.0.0-BETA)

Follow tests **S01–S11** in [Gen 3 Playstyles](GEN3_PLAYSTYLES.md):
non-shiny Ball rejection and unused route slots, eligible shiny
encounters with Failed Encounters ON/OFF, Shiny Clause precedence,
shiny-rate independence, saves and Untamed wandering wild captures.

## Hardcore Nuzlocke playstyle (v3.0.0-BETA)

Use **H01–H11** in [Gen 3 Playstyles](GEN3_PLAYSTYLES.md). Verify
effective CORE overrides, native battle bag refusal (Poké Balls allowed),
forced SET response, boss EXP/Rare Candy caps, mode combinations and
instant restoration on Hardcore OFF. Use a disposable ROM save.

## Expanded National Dex randomiser (new development feature)

- [ ] **ND01 — Optional provider.** Start with only Nuzlocke installed. RANDOMIZER → ROSTER: NATIONAL DEX must report NAT DEX NOT DETECTED and the vanilla species count, not crash or propose non-existent Pokémon.
- [ ] **ND02 — Expanded roster.** Install National Dex and restart, start a disposable new run. RANDOMIZER should report up to 1025 eligible base species and 639 newer species. Forms OFF by default; turning them ON permits the registered alternate forms.
- [ ] **ND03 — Generation filters.** Use PALDEA, SINNOH and GALAR filters with Random Wild ON and known seed. Confirm every resulting species belongs to the chosen National generation, even with multiple maps and reboots.
- [ ] **ND04 — Legacy save.** Reload a pre-expansion save that has already randomised Pokémon. Its roster must remain GEN 1-3 and earlier encounter mappings must remain identical; current-run changes must be denied.
- [ ] **ND05 — Species bans.** Apply individual #906 ban, No Legendaries, No Mythicals and No Pseudos to relevant registered new Pokémon and verify catch/award denial where those rules are active.
- [ ] **ND06 — Forms and identities.** Enable ALT FORMS on a new save; confirm generated species remains the correct form in battle, party/PC, graveyard and results, with no raw internal IDs on player-facing screens.
- [ ] **ND07 — Six-mod stack.** Install National Dex, Modern Spawns, G9 Battle Sprites, Gen3 HD Sprites, Untamed Advanced and Nuzlocke. Test Nuzlocke Random Wild independently from Modern Spawns; when both are ON, record any load-order/encounter priority mismatch. Overworld Pokémon identity must match battle/catch/shiny sprites.
