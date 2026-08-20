# 2.6.0 release confidence

- **RUNTIME PASS carried forward:** 2.5.92 boots and DEV REPORT renders on Gen1Recomp 0.2.14.
- **STATIC PASS:** `progression_pc_catches` appears exactly once in the rule catalog and is the first QOL row; its rule definition is otherwise byte-identical to 2.5.92.
- **NO CONTRACT CHANGE:** Save Schema 4, Compatibility API 29, Diagnostics API 1, Run History API 1, and Mod API 2 remain unchanged.
- **RUNTIME UI CHECK RECOMMENDED:** open NUZ RULES/Setup and confirm PC Catches is first in QOL.

# 2.5.92 Run History death-producer confidence

- **STATIC/HARNESS PASS:** repeated `recordDeath` calls for the same Pokémon identity and death sequence produce one `pokemon.died` row and one death-summary increment.
- **STATIC/HARNESS PASS:** incrementing the sequence after a simulated F. TOKEN revival produces a second legitimate death row.
- **STATIC PASS:** R/B/Y battle, R/B/Y field-poison, and Gold/Silver battle authoritative death commits increment the sequence before archive/history journaling.
- **RUNTIME TEST RECOMMENDED:** one death, F. TOKEN revive, and second death on at least one exact edition should be used to promote this producer behavior to runtime PASS.

# 2.5.91 migration confidence

- **STATIC/HARNESS PASS:** unchanged flat and nested table values no longer appear in shadow migration diffs after a touch/write-back.
- **STATIC/HARNESS PASS:** real nested table mutations still appear in the write set.
- Save Schema 4 and migration commit/recovery ordering are unchanged.

# 2.5.90 modularization confidence

- **STATIC PASS:** Gift/Trade source catalog extraction is read-only and depends only on the existing `getGameVersion` function.
- **STATIC PASS:** transaction enforcement and special-acquisition hooks were not moved.
- **RUNTIME TEST REQUIRED:** boot and exercise a Gift/Trade compatibility lookup or normal acquisition before treating the extraction boundary as protected.

# 2.5.89 modularization confidence

- **STATIC PASS:** DEV REPORT/NZR6 source is extracted to `dev_report.lua` with only outer `currentGame` references redirected through an injected live getter and schema constants injected explicitly.
- **STATIC PASS:** Release Safety package inventory includes the new module.
- **RUNTIME TEST REQUIRED:** boot the mod, open DEV REPORT, refresh it, and confirm Report Code/self-test behavior before protecting the extraction boundary.

# 2.5.88 UI/QoL confidence

- MOD COMPAT footer-spacing cleanup: **STATIC PASS / RUNTIME UI CHECK REQUESTED**.
- ENC TRACKER last tab/row memory: **STATIC PASS / RUNTIME CHECK REQUESTED**.
- MOD COMPAT last row/detail-page memory: **STATIC PASS / RUNTIME CHECK REQUESTED**.
- DEV REPORT/Dev Tools cursor/report-scroll memory: **STATIC PASS / RUNTIME CHECK REQUESTED**.
- NUZ RULES/Setup semantic position + collapsed-section memory: existing behavior retained and centralized; prior runtime setup/rules confidence remains protected.

# 2.5.87 Compatibility cleanup confidence

- **ENC TRACKER marker experiment:** REVERTED. Presentation restored to 2.5.85 behavior; graphical symbols returned to backlog.
- **Compatibility API 29 metadata/introspection:** STATIC PASS; runtime MOD COMPAT/provider smoke remains desirable.
- **0.2.14 engine profile:** source-audited + exact boot/DEV REPORT runtime PASS carried forward; the profile metadata now resolves correctly.
- No gameplay confidence status is promoted or demoted by this pass.

# 2.5.86 Encounter Tracker status markers

> **2.5.86 note:** ENC TRACKER now uses font-safe `O CAUGHT`, `X FAILED`, `- OPEN`, `* SHINY`, and `X DEAD` labels across classic R/B/Y, native Gold/Silver, and Modern UI presentation. Text remains explicit for accessibility; encounter mechanics and stored state are unchanged.

# 2.5.85 Run History producer completion confidence

- **STATIC/HARNESS PASS — RUNTIME REQUIRED:** ordinary successful catches now append Run History after settled tracker/area registration. Dedicated starter/gift/trade/progression producers remain identity-deduped.
- **STATIC/HARNESS PASS — RUNTIME REQUIRED:** death producer audit confirms authoritative bridges at R/B/Y battle permadeath, shared field poison, and Gold/Silver battle permadeath; no new competing death path was added.
- **STATIC/HARNESS PASS — RUNTIME REQUIRED:** Gym Leader F. TOKEN awards now append `forgiveness.awarded` after committed reward state with semantic Leader dedupe; area/revive spends append `forgiveness.used` after successful decrement with remaining-token metadata.
- Harness coverage exercises both generation identities, catch dedupe, repeat-death chronology, award dedupe, token counters, summary counters, and journal integrity. Exact-edition gameplay evidence is still required independently for Gen 1 and Gen 2.

## 2.5.84 Random Starter cache-dedup confidence

> **2.5.84 note:** RS-CACHE-DEDUP-001 is fixed: unseeded Random Starter distinct-choice bookkeeping ignores scoped cache/internal marker rows and counts only canonical bare starter-slot mirrors. Seeded/deterministic starter behavior is unchanged. Gen1Recomp 0.2.14 is exact-runtime boot/DEV REPORT PASS.


- **SOURCE-AUDITED:** Gen1Recomp 0.2.14 tag delta reviewed against 0.2.13; only Android packaging and iOS app metadata changed, with no Nuzlocke-facing engine contract delta.
- **EXACT-RUNTIME PASS:** 2.5.83 boots on Gen1Recomp 0.2.14 and DEV REPORT renders normally.
- **SOURCE-CONFIRMED REPAIR:** RS-CACHE-DEDUP-001 now restricts legacy unseeded distinct-choice bookkeeping to canonical bare starter-slot mirror entries; scoped cache rows and internal markers are ignored.
- **REGRESSION SCOPE:** seeded Random Starter selection, deterministic Gold/Silver starter slate, preview identity, and award transaction are unchanged.

# 2.5.82 Public Interop modularization confidence

- **STATIC PASS:** the extracted Public Interop / Capability API block is preserved in `public_interop.lua` with only dynamic state references redirected through injected getters.
- **PROTECTED RUNTIME PASS (2.5.81):** Setup/rule catalog appears normal after the prior extraction.
- **RUNTIME TEST REQUIRED:** 2.5.82 boot/load and MOD COMPAT/provider surface smoke test.

# 2.5.81 rule-catalog modularization confidence

- **STATIC PASS:** `rule_catalog.lua` contains the extracted rule/settings metadata and established preset/fallback tables; `main.lua` rebinds the same established objects for downstream consumers.
- **PROTECTED RUNTIME PASS (2.5.80 Gold):** mod loads on Gen1Recomp 0.2.13, DEV REPORT opens, and Elm Random Starter picture + randomized award work.
- **RUNTIME TEST REQUIRED:** 2.5.81 should receive a quick boot/menu smoke test after this extraction.
- **RUNTIME TEST REQUIRED:** Silver Random Starter still requires independent confirmation.

# 2.5.80 compatibility/modularization confidence

- **SOURCE/STATIC PASS:** Gen1Recomp 0.2.13 retains Mod API 2 and the Gen 2 VM/world callback seams used by Nuzlocke.
- **REPAIR:** Release Safety package-source introspection is fail-soft and cannot by itself abort mod initialization.
- **STATIC PASS:** Run History, Release Safety, Dev assertions, and migration shadow-store logic are isolated behind package-local modules with explicit dependency injection.
- **STATIC PASS:** Stadium Prize provenance is metadata-only and does not invent or consume an encounter area.
- **RUNTIME TEST REQUIRED:** 2.5.80 must boot through the Gen1Recomp 0.2.13 Mod Manager before the modularization/boot repair is promoted to runtime PASS.
- **RUNTIME TEST REQUIRED:** Gold/Silver Random Starter preview remains independently pending exact-edition confirmation.

# 2.5.79 Johto Random Starter preview confidence

- **SOURCE/STATIC PASS:** Gen1Recomp v0.2.12 uses literal `pokepic`/`cry`, passes the expected species operands, and owns visible portrait/cry through native VM callbacks.
- **STATIC PASS:** 2.5.79 preserves the script-intent path and adds a native callback fallback using Elm Lab + empty party + canonical starter identity.
- **STATIC PASS:** the fallback reuses the existing deterministic starter choice/slate rather than rolling a second choice.
- **PROTECTED:** R/B/Y Random Starter paths are untouched; Blue 2.5.71 pre-selection portrait runtime PASS remains protected.
- **RUNTIME TEST REQUIRED:** Gold and Silver must each confirm preview portrait + cry == awarded randomized species on 2.5.79.

# 2.5.78 save/migration integrity confidence

- **STATIC/HARNESS PASS:** schema-migration shadow planning produces no live mutation and orders the schema marker last.
- **STATIC/HARNESS PASS:** bounded whole-save backup rotation keeps exactly three Nuzlocke snapshots and leaves engine `.bak`/`.tmp` files untouched.
- **STATIC/HARNESS PASS:** clean schema transitions clear the write-ahead journal; simulated pre-commit interruption rolls back; simulated post-schema-marker interruption finalizes cleanup.
- **STATIC CONTRACT PASS:** Release Safety now checks Save/Migration Integrity helper availability, schema-migration coverage through schema 4, and reserved-key namespacing.
- **SOURCE/STATIC PASS:** migration/recovery failure feeds the central persistence/enforcement pause with distinct `migration_error` diagnostics.
- **RUNTIME TEST REQUIRED:** exact-engine old-save upgrade and interruption/reload behavior still require runtime confirmation before the transaction layer is promoted beyond static/harness evidence.
- Gameplay feature confidence is otherwise carried forward unchanged from 2.5.77.

# 2.5.77 release-safety confidence update

- **STATIC RELEASE GATE:** one aggregate `releaseSafetyAudit()` now covers the encoded rule-default/registry, Save Schema descriptor, dead-fallback, catalog-snapshot, cross-table, trainer-reward active-guard, provenance, capability-version, and required-package-source contracts.
- **FAIL-FAST:** `assertReleaseSafety()` runs during module initialization and prevents a build with a failed encoded release contract from loading normally.
- **DEV VISIBILITY:** aggregate PASS/WARN status is included in Dev self-test.
- **RUNTIME EVIDENCE UNCHANGED:** no existing TEST REQUIRED/FAIL feature is promoted by this static gate. Gold/Silver Random Starter preview remains open and Run History producer runtime validation remains required.

# 2.5.76 confidence update

- Documentation-hygiene child only; runtime confidence/evidence is unchanged from 2.5.75.
- Public confidence records were sanitized for durable release/technical provenance only.

# 2.5.75 current feature-confidence snapshot

2.5.75 is process/documentation-only; gameplay confidence is unchanged from 2.5.74. The development workflow now requires exact-edition evidence, explicit cleared/unreviewed review surfaces, and regression-protection notes to be recorded durably.

- **Blue 2.5.71 Random Starter pre-selection portraits:** RUNTIME PASS; protected.
- **Gold/Silver Random Starter award:** randomized award path runtime-proven.
- **Silver 2.5.73 Random Starter preview:** RUNTIME FAIL; Elm pre-selection presentation remained vanilla.
- **Gold/Silver Random Starter overall:** OPEN DEFECT until preview portrait/cry == awarded species is runtime-confirmed independently on each edition.
- **Run History v1:** STATIC/HARNESS PASS — exact-edition runtime producer verification still required.

## 2.5.74 current feature-confidence snapshot

2.5.74 is documentation-only; confidence changes below reflect newly supplied runtime evidence, not new executable behavior.

| Feature | Red | Blue | Yellow | Gold | Silver | Current confidence |
|---|---|---|---|---|---|---|
| Core R/B/Y Nuzlocke enforcement | historical runtime evidence | historical runtime evidence | historical runtime evidence | — | — | STABLE / protected paths vary by rule |
| Gold/Silver shared Gen 2 architecture | — | — | — | partial runtime coverage | partial runtime coverage | BETA |
| Random Starter pre-selection portraits | TEST REQUIRED on current line | **PASS on 2.5.71** | TEST REQUIRED on current line | **FAIL on tested Gen 2 line** | **FAIL on 2.5.73** | R/B/Y path protected; Gen 2 OPEN DEFECT |
| Random Starter awarded species | historical working path | runtime working evidence | historical working path | **PASS non-vanilla award** | **PASS non-vanilla award** | Gen 2 award path PASS, presentation not PASS |
| Run History v1 | STATIC/HARNESS PASS | STATIC/HARNESS PASS | STATIC/HARNESS PASS | STATIC/HARNESS PASS | STATIC/HARNESS PASS | EXPERIMENTAL / runtime producer evidence required |
| Exact-edition Dev Report/NZR6 | TEST REQUIRED | TEST REQUIRED | runtime evidence | runtime evidence | **PASS on 2.5.67** | BETA/diagnostic |

**Rule:** a known open runtime failure prevents the affected edition/feature from being labeled Stable, regardless of static assertions. Gold and Silver evidence are tracked separately.

# 2.5.73 Run History foundation confidence

- **STATIC/COMPILER PASS:** Run History v1 storage/API and catch/death/forgiveness bridges compile with the protected late-scope budget unchanged (41 extra locals PASS / 42 expected ceiling FAIL).
- **STRUCTURAL DEV CHECK:** journal rows are audited for bounded retention, monotonic sequence IDs, scalar-only fields, dedupe uniqueness, lifetime-summary validity, coverage/baseline metadata and advancing `next_seq`.
- **RUNTIME TEST REQUIRED:** verify catches, Permadeath deaths and F. TOKEN uses append correctly across at least one Gen 1 and one Gen 2 edition before any player-facing Graveyard/Almanac/Confessional page depends on the journal.
- **SOURCE-AUDITED:** Gen1Recomp 0.2.12 compatibility marker advanced; no adapter-signature rewrite identified.
- Existing Tracker/legacy history behavior is intentionally preserved.

# 2.5.71 confidence update

- **Gen 2 candidate pool:** RUNTIME PASS on Gold 2.5.70 for real non-vanilla substitution (Smoochum awarded).
- **Preview -> award parity:** RUNTIME FAIL on Gold 2.5.70 (Cyndaquil preview, Smoochum received); 2.5.71 contains a source-confirmed transaction repair and requires runtime confirmation.
- **Dev parity regression check:** STATIC PASS; `opening_starter_preview_award_parity` reports a persisted mismatch if the selected preview and committed award diverge.

# 2.5.70 confidence update

- **Gold Random Starter 2.5.69:** RUNTIME FAIL for actual randomization / PARTIAL PASS for transaction consistency. Random Starter ON displayed the vanilla Chikorita/Cyndaquil/Totodile slate; choosing Cyndaquil awarded Cyndaquil.
- **2.5.70 candidate-pool repair:** SOURCE-CONFIRMED DEFECT FIX / RUNTIME TEST REQUIRED. The current validator had required Gen 1-only `level1Moves`/`learnset` fields from Gen 2 species; it is now generation-aware and validates Gen1Recomp 0.2.11's native `baseStats`/`levelMoves` shape.
- **Protected architecture:** deterministic slate/cache, exact native GivePoke ownership, selected Ball/story/rival branch and challenge filters were intentionally preserved; runtime later showed preview -> received consistency was not actually preserved across the early save-backing handoff.
- **Silver Random Starter:** STATIC PARITY / RUNTIME TEST REQUIRED on the same repaired Gen 2 path.

# 2.5.69 confidence update

- **Gold Random Starter:** STATIC REPAIR / RUNTIME TEST REQUIRED. The exact Elm script-command game object is now carried into the native `givePoke` transaction so early NEW GAME cannot lose the randomized species substitution through a nil/stale global game lookup.
- **Silver Random Starter:** STATIC PARITY / RUNTIME TEST REQUIRED. Silver shares the repaired Gen 2 grant path and now has an explicit Johto starter-family registration.
- **Protected behavior:** selected vanilla Ball/story/rival branch remains vanilla-owned; native construction, held item, Pokedex changes and nickname flow remain native/composed.
- **Yellow recovery reassignment:** protected RUNTIME PASS on 2.5.66 for Mankey -> Route 1 -> wild.

# 2.5.68 confidence update

- **NUZ STATUS content cleanup:** STATIC PASS / RUNTIME RETEST REQUIRED. R/B/Y and Gen 2 status row generators now exclude setup-only resources/PC kits, Gym Guide Candy/service state, and redundant master-ON rows.
- **R/B/Y Type Locke status:** STATIC PASS / RUNTIME RETEST REQUIRED. Raw Type 2/3/4/5/6 slot rows are suppressed and replaced by one player-facing Type Locke summary.
- **Status presentation lifecycle:** intentionally unchanged; R/B/Y ListMenu and Gen 2 scrolling/input/error-containment code are not rewritten.
- **Yellow recovery reassignment:** protected RUNTIME PASS on 2.5.66 for Mankey -> Route 1 -> wild.
- **Silver exact-edition Dev Report/NZR6:** RUNTIME PASS on 2.5.67 (`game silver`). Silver NUZ STATUS 2.5.67 still requires explicit runtime confirmation after the movement-assist scope repair.
- **Gold Random Starter:** remains the next known gameplay repair after this cleanup.

# 2.5.66 confidence update

- **Silver Setup:** RUNTIME PASS on 2.5.65.
- **Silver boot to bedroom:** RUNTIME PASS on 2.5.65.
- **Silver NUZ STATUS:** RUNTIME FAIL on 2.5.65 (launcher crash); 2.5.66 adds a screen-level exception boundary and report code, so runtime retest is required before PASS.
- **Yellow Encounter Tracker manual reassignment:** confirmed runtime FAIL through 2.5.64 for Mankey → Route 1 → wild (`table index is nil`). 2.5.66 makes area-key validation and tracker-row construction transactional and live-Pokémon identity enrichment best-effort; runtime retest required.
- Existing Gold and Yellow Dev Tools protected PASS evidence remains unchanged.

# 2.5.65 confidence update

- **Silver:** newly enabled BETA / TEST REQUIRED. Upstream 0.2.11 confirms Silver shares the Gen 2 engine with Gold, but Nuzlocke parity has not yet been runtime-established.
- **Gold:** existing protected runtime PASS evidence carries forward; Silver enablement does not change the intended Gold mechanics.
- **Yellow Dev Tools:** 2.5.63 RUN + VIEW REPORT + fresh NZR5 generation remain runtime PASS.
- **Yellow Encounter Tracker reassignment:** 2.5.64 remains runtime-test-required while Silver work proceeds separately.

# 2.5.64 confidence update

- **Yellow Dev Tools VIEW REPORT:** RUNTIME PASS on 2.5.63.
- **Yellow Dev Tools RUN + SAVE/report generation:** RUNTIME PASS on 2.5.63; fresh NZR5 generated.
- **NZR5 codec/runtime path:** RUNTIME PASS on 2.5.63.
- **Encounter Tracker manual reassignment:** RUNTIME FAIL on 2.5.63 (`table index is nil`); 2.5.64 repair requires retest.

## 2.5.63 runtime-repair confidence

Static/compiler validation passes for the Dev report fingerprint scope repair and nil-capability compatibility guards. Yellow runtime confirmation is still required for VIEW REPORT, RUN + SAVE, and Encounter Tracker reassignment.

## 2.5.62 runtime-hardening confidence

- **STATIC REPAIR / RUNTIME RETEST REQUIRED:** bound `mod.storage` signatures are corrected for Dev storage context/read/write/list/delete, addressing the common RUN + SAVE and VIEW REPORT failure path found on Yellow.
- **STATIC REPAIR / RUNTIME RETEST REQUIRED:** Dev and recovery-editor error feedback is now in-screen and immediately dismissible instead of pushing nested error TextBoxes.
- **SOURCE-AUDITED / RUNTIME SMOKE TEST REQUIRED:** Gen1Recomp 0.2.11 retains Mod API 2 for Nuzlocke's declared Red/Blue/Yellow/Gold targets. Silver is not yet claimed.

## 2.5.61 runtime-hardening confidence

- **RUNTIME FAIL (reported on Yellow 2.5.59):** legacy Encounter Tracker recovery/editing could crash on an invalid/stale edit path.
- **STATIC REPAIR / RUNTIME RETEST REQUIRED:** 2.5.61 validates stale/invalid recovery edits before mutation and contains unexpected update/draw exceptions behind a player-facing `NZERR` report page.
- **RUNTIME FAIL (reported on Yellow 2.5.59):** Dev Mode **RUN + SAVE** could crash the game.
- **STATIC REPAIR / RUNTIME RETEST REQUIRED:** 2.5.61 catches unexpected Dev self-test/export exceptions and returns a structured `DEV RUN ERROR` with an `NZERR` code.
- **SOURCE-AUDITED / RUNTIME SMOKE TEST REQUIRED:** published Gen1Recomp 0.2.10 retains Mod API 2 and the protected shared seams; stable audited marker advances to 0.2.10.
- Existing protected runtime-PASS paths were not intentionally changed.

## 2.5.59 Phase-B dead-fallback lint confidence

- **STATIC/LOAD CONTRACT:** literal catalog-key calls to `worldRuleTriplet()` / `worldRuleText()` cannot carry unreachable fallback arguments.
- **STATIC PASS:** packaged source contains zero catalog-backed dead-fallback call sites.
- **NEGATIVE CONTROL PASS:** reintroducing a fallback on the existing `blackout` catalog key is detected by the lint.
- **DEV DIAGNOSTIC:** `Dev.assertions()` reports `dead_fallback_lint` if the source contract drifts.
- **GAMEPLAY:** intentionally unchanged; existing catalog text already had precedence over the removed fallback arguments.

## 2.5.58 Phase-B cross-table invariant confidence

- Static GSC stage/badge reference/storage/index consistency: code-gated.
- R/B/Y Gym Leader/cap-table cardinality: code-gated.
- Runtime gameplay behavior: intentionally unchanged from 2.5.57.

## 2.5.57 Phase-B active-guard confidence

- **STATIC/INSTALL CONTRACT:** trainer-reward gameplay mutation entry points are source-audited for their required enforcement guard.
- **EXPLICIT EXCEPTIONS:** passive League/Gym progression sync and Forgiveness Token reconciliation are classified as intentional master-OFF persistence paths.
- **DEV DIAGNOSTIC:** `Dev.assertions()` reports `active_guard_contract` if the source contract drifts.
- **GAMEPLAY:** intentionally unchanged; existing protected runtime PASS paths remain protected.

## 2.5.56 Phase-B rule coercion confidence

- **STATIC PASS:** exact modified `main.lua` compiles/loads.
- **STATIC PASS:** 41-extra-local late-scope sentinel compiles; 42 reaches the Lua 200-local emergency ceiling.
- **STATIC PASS:** all **40** ordinary numeric rule coercion paths derive from authoritative registration metadata.
- **STATIC PARITY PASS:** **1,600/1,600** representative numeric read/write cases match 2.5.55 behavior, including legacy boolean and malformed-value edge cases.
- **TEST REQUIRED:** runtime behavior is expected to remain unchanged; protected runtime-PASS evidence carries forward.
- Existing known runtime failures remain queued: NUZ STATUS content/organization and Gold Random Starter grant.

## 2.5.55 Phase-B rule-registration confidence

- **STATIC PASS:** exact modified `main.lua` compiles/loads.
- **STATIC PASS:** 41-extra-local late-scope sentinel compiles; 42 reaches the Lua 200-local emergency ceiling, preserving the measured 159-active-local outer-function state.
- **STATIC PASS:** all **114/114** ordinary rule registration rows carry explicit defaults and unique keys.
- **STATIC PASS:** ordinary `defaultRuleValue()` resolution now uses the same registration records consumed by Setup/NUZ RULES and Rule Registry descriptors.
- **TEST REQUIRED:** runtime behavior is expected to remain unchanged; protected runtime-PASS paths retain their historical evidence but this refactor has not yet received new runtime regression coverage.
- Existing known runtime failures remain queued: NUZ STATUS content/organization and Gold Random Starter grant.

## 2.5.54 compiler-budget confidence

- **STATIC PASS:** exact `main.lua` compile/load succeeds.
- **STATIC PASS:** 41-extra-local sentinel compiles; 42-extra-local sentinel reaches Lua's emergency ceiling. Derived outer active-local pressure is **159**, below the project 160 hard ceiling.
- **NO GAMEPLAY CHANGE:** no runtime PASS is invalidated by this refactor.
- **TEST REQUIRED:** fresh Dev Report code should still begin with `NZR5-` (2.5.53 diagnostic change, not modified here).
- **CONFIRMED FAIL / queued:** Gold Random Starter did not work in Gold 2.5.51.
- **CONFIRMED UI/content FAIL / queued:** Yellow 2.5.51 NUZ STATUS contains duplicate/low-quality rows such as duplicate Starting Money and raw Type 2/3/4/5 labels.
- **PROTECTED PASS:** 2.5.51 F. TOKEN redemption sequence and UI worked end-to-end in runtime.

## 2.5.53 runtime retest target

- TEST REQUIRED: mod loads successfully on R/B/Y and Gold.
- TEST REQUIRED: fresh Dev Report codes begin with `NZR5-`.
- TEST REQUIRED: decoded NZR5 health flags agree with their structured counters/status by construction.
- No gameplay confidence state changes in 2.5.53.

## 2.5.51 runtime retest target

- **Gold Random Starter: TEST REQUIRED.** On a fresh Gold New Game with Random Starter ON, preview at least two Elm balls, choose one, verify the received species matches that ball's randomized preview, confirm nickname flow still appears as configured, and confirm the selected vanilla ball/rival story branch remains correct.
- No other feature confidence state changes in 2.5.51.

## 2.5.50 runtime retest targets

- **Protected PASS — Yellow 2.5.49:** F. TOKEN full-page main selector and native sideways cursor render correctly.
- **Protected PASS — Yellow 2.5.49:** F. TOKEN reroll reopened the selected area and a subsequent Muk catch was correctly attributed to that area. Preserve this mechanic.
- **STATIC / TEST REQUIRED:** F. TOKEN → REROLL ENCOUNTER lists eligible FAILED areas from tracker state even when the player is elsewhere.
- **STATIC / TEST REQUIRED:** selecting an eligible FAILED row in ENC TRACKER exposes/launches A:REROLL and returns cleanly after cancel/spend.
- **STATIC / TEST REQUIRED:** confirmation names the selected area, starts with no selected choice, A does nothing until movement selects YES/NO, and B cancels without spending.
- **Protected mostly-PASS — Yellow 2.5.49:** most Nuzlocke battle alerts require player A/B paging. Keep monitoring exceptions.
- `DUPE:FREE` / `AREA:COUNT` is the separate Encounter Indicator feature, not legacy F. TOKEN state.

## 2.5.49 runtime retest targets

- **Yellow F. TOKEN main selector:** 2.5.48 full-page presentation is RUNTIME PASS. 2.5.49 adds the native sideways cursor; verify the arrow visibly tracks REROLL ENCOUNTER / REVIVE POKEMON.
- **Yellow F. TOKEN revive list:** verify the native sideways cursor visibly tracks the selected fallen Pokemon and scrolling remains correct.
- Forgiveness mechanics remain unchanged; reroll/revive spending still requires functional runtime validation.

## 2.5.48 runtime retest targets

- **Yellow F. TOKEN:** prior 2.5.47 presentation FAIL; 2.5.48 root-cause tile-coordinate repair is STATIC PASS / RUNTIME TEST REQUIRED. Test first selector, revive list, notices, B-cancel, reroll, revive, and return flow.
- **Yellow Gym Guide Rare Candy text:** prior runtime FAIL for page pacing; 2.5.48 explicit-page repair is STATIC PASS / RUNTIME TEST REQUIRED. Verify A/B is required between pages and before the quantity selector opens.
- Protected Yellow 2.5.46 runtime PASS: No Buying, No Selling, and No Center Heal.

## 2.5.47 F. TOKEN R/B/Y presentation — TEST REQUIRED
- **RUNTIME FAIL 2.5.46 (Yellow):** F. TOKEN still displayed as a partial custom overlay with the native USE POKEMON/item screen visible underneath.
- **STATIC FIX 2.5.47:** close the live Bag/use list before pushing the F. TOKEN selector and publish both forgiveness screens through the Nuzlocke presentation contract.
- **RUNTIME REQUIRED:** Yellow/Red/Blue open F. TOKEN, reroll, revive, B-cancel, and post-spend return flow.

## 2.5.46 Gold Dev Mode visibility — TEST REQUIRED

- **RUNTIME FAIL 2.5.44:** Dev Mode could be enabled in Gold NUZ RULES without exposing the DEV START-menu row.
- **STATIC FIX 2.5.46:** Dev Mode uses the live config reader and refreshes Nuzlocke's DEV row in the already-open Gold START menu.
- Test ON/OFF immediately after leaving NUZ RULES, START reopen, save/reload, and repeated toggles for duplicate rows.

## 2.5.45 F. TOKEN presentation repair — TEST REQUIRED
- **CONFIRMED 2.5.44 FAIL:** R/B/Y F. TOKEN selector could overlap/corrupt the underlying native item-use UI.
- **STATIC FIX 2.5.45:** both forgiveness custom screens now own the protected classic 160x144 presentation contract.
- Runtime-test REROLL ENCOUNTER, REVIVE POKEMON, B cancel, post-spend return-to-Bag, and at least one wide/modern UI combination. Gold should be smoke-tested for no regression.

## 2.5.44 Dev Report repair — TEST REQUIRED

**SOURCE/STATIC PASS, RUNTIME TEST REQUIRED.** New NZR4 codes derive hook/lifecycle/safe-stop/rule/randomizer result bits from the same detailed evidence carried in the payload, and the decoder reports internal consistency. The R/B/Y display balances code groups instead of leaving the last short group alone.

Runtime test: open VIEW REPORT on R/B/Y, confirm the complete code is visible in balanced rows with no orphaned two-character row, copy/decode the code, and verify `consistent=true`. If a historical 2.5.43 code with conflicting PASS bits/counters is decoded, it should return `consistent=false` rather than being treated as a clean diagnostic.

## 2.5.43 Gold pager state repair — TEST REQUIRED

**SOURCE/STATIC PASS, RUNTIME TEST REQUIRED.** The pager no longer writes `self.queue = {}` or calls `advanceQueue()` on completion. Test a short denial and a multi-page denial during Gold battle, then continue the turn/menu normally; also test with another battle-message/UI mod if available to confirm pending native/mod messages are not skipped.

## 2.5.42 player-paced text audit — TEST REQUIRED

Static audit: R/B/Y Nuzlocke battle/world text continues through blocking `TextBox` or battle queue pagination. Gold blocked battle-item, No Catching, illegal catch/encounter, and Encounter Ball Limit refusal text now uses a Nuzlocke-owned two-line pager and requires A/B for every page. Runtime-test one short and one multi-page denial in Gold, plus one representative R/B/Y denial, before promotion to PASS.

## 2.5.41 focused validation

**SOURCE/STATIC PASS, RUNTIME TEST REQUIRED.** Re-test F. TOKEN revival in R/B/Y and Gold with a retained dead party member after lowering Party Size Limit; it must move to PC when the party is above cap and must refuse without spending when PC storage is full. Re-test ordinary and held-item Trade Evolutions at 39->40 and confirm link/item/non-level contexts remain native. Also verify a merged failed area under disabled Area Splits reopens after one token and remains forgiven if the split is later enabled.

Version identity is numeric-only (`2.5.41`) and current docs/manifests should agree.

## 2.5.40 Forgiveness Token confidence

**SOURCE/STATIC PASS, RUNTIME TEST REQUIRED.** Token quantity is inventory-backed, legacy counts migrate, Gym Leader awards update the real item, and current Nuzlocke shop injection/price code is removed. The R/B/Y BUY/SELL filter and Gold Mart/Pack adapters keep the token out of shop presentation while preserving normal Bag/Pack use.

Runtime matrix: NEW GAME starting 0/1; migrate an existing unspent legacy token; earn one from a Gym Leader; verify no Mart BUY/SELL surface lists it; fail an eligible area then manually reroll it and catch the next encounter; verify OPEN/CAUGHT/untracked areas do not spend; record a Permadeath then revive it at half HP; repeat with a full/limited party so PC placement occurs; verify a full PC refuses without spending; verify old losses without an exact archive are not fabricated; verify battle use is refused without spending.

## 2.5.39+DEV Trade Evolutions confidence

**SOURCE/STATIC PASS, RUNTIME TEST REQUIRED.** The shared evolution hook now recognizes Gen 1 `TRADE` and Gold `EVOLVE_TRADE` rows, applies the default-OFF level-40 alternative only on non-native trade/item paths, keeps Gold Everstone authoritative, and retains/consumes required held items for trade-with-item branches. The competing Gold level branch is suppressed only while its matching trade item is held.

Runtime matrix: R/B/Y Kadabra (or another plain trade evolution) at 39->40 with OFF then ON; Gold plain trade evolution at 39->40; Gold Seadra + Dragon Scale at 39->40 and verify Dragon Scale is consumed; Slowpoke + King's Rock must not become Slowbro at 37 and must become Slowking at 40, while Slowpoke without King's Rock still follows native Slowbro; Everstone must block; native link trade must still work; Evolution Limits NO FINAL/NO EVOLUTION must still reject as configured.

## 2.5.38+DEV focused validation

**SOURCE/STATIC PASS, RUNTIME TEST REQUIRED.** Verify a published `2.5.38+DEV` release does not advertise itself as newer; a later numeric release still does. Verify R/B/Y and Gold retain native full-party PC messaging at Party Size Limit 6 while limits 1-5 show Nuzlocke denial. Verify the Gym Guide says `You've earned it.` after Champion completion at a true MAX cap. The battle AREA:SPENT indicator was intentionally not touched.

Manifest/main/docs remain synchronized: starting with 2.5.38, DEV builds use canonical SemVer build metadata (`+DEV`) instead of prerelease notation (`-DEV`) so updater precedence is neutral at the same numeric version.

## 2.5.37-DEV recent-feature repair confidence

- **Random Field Items / HM protection:** SOURCE/STATIC PASS. Protection now accepts canonical `HM_<MOVE>` ids and HM machine metadata. **RUNTIME TEST REQUIRED:** Gold Ice Path HM07 WATERFALL with Random Field Items ON must remain HM07; at least one ordinary field ball should still randomize.
- **Gold sparse Box traversal / Whiteout:** SOURCE/STATIC PASS. Every Nuzlocke cross-box scan now enumerates existing numeric box slots without `ipairs` truncation. **RUNTIME TEST REQUIRED:** Whiteout ON + Permadeath ON with the only legal reserve in a later box while an earlier box table is absent must survive and allow Bill's PC recovery.
- **PC-Only Catch 5->6 filing:** SOURCE/STATIC PASS. The preflight box target is retained and post-catch filing may use another Gold box after the party fills. Lock metadata is committed only after storage succeeds. **RUNTIME TEST REQUIRED:** party=5, current box full, another box has room.
- **Gold Radio Nuzlocke under Rule Lock:** SOURCE/STATIC PASS; menu runtime validation required.
- **SOLO loadout description:** SOURCE/STATIC PASS; text now matches the preset's Whiteout OFF / run-ending Blackout behavior.
- No new feature confidence claim or public contract change; Save Schema 4 / Compatibility API 28 / Diagnostics API 1 / Mod API 2 unchanged.

## 2.5.36-DEV Gen1Recomp compatibility confidence

- **Current Gen1Recomp dev head `def270f7c726ebd7bd87086ad90bc4a7b9622543`:** SOURCE/STATIC PASS; no required Nuzlocke gameplay adapter change found. Stable published audit marker remains 0.2.7.
- **Gold BattleAPI Ball/catch-preview expansion:** SOURCE/STATIC PASS; consumed automatically by the existing optional read-only BattleAPI bridge. No capture-rule ownership change.
- **Gold `ui.party.grid_navigation`:** SOURCE/STATIC PASS for non-ownership/composition; Nuzlocke installs no competing hook.
- **Android in-process game switching:** SOURCE/STATIC PASS for upstream `Runtime.reset()` plus Nuzlocke owner-aware revalidation; **RUNTIME TEST REQUIRED** for Red/Yellow -> launcher -> Gold -> launcher -> Red/Yellow. Verify Setup/NUZ RULES, Gold Random Starter, Running Shoes/Fast Surf, Unlimited Bag Space, and absence of duplicate/stale wrappers.
- Engine range, Save Schema 4, Compatibility API 28, Diagnostics API 1, and Mod API 2 unchanged.

## 2.5.35-DEV recent-feature repair confidence

- **Gold Random Starter shared-row mutation:** SOURCE/STATIC PASS; runtime repeat-New-Game validation required.
- **Gold starter slate cache identity:** SOURCE/STATIC PASS; fixed-seed repeated-preview validation required.
- **Unlimited Bag Space under Rule Lock:** SOURCE/STATIC PASS; menu runtime validation required.
- No new feature confidence claims are introduced by this bug-only build.

## 2.5.34-DEV Unlimited Bag Space confidence

**STATIC/SOURCE PASS / RUNTIME TEST REQUIRED.** The QoL defaults OFF, is exposed in R/B/Y and Gold, and resolves capacity only at the engine's distinct-slot boundary. Static expectations: OFF returns the downstream capacity exactly; R/B/Y ON raises the ordinary Bag capacity; Gold ON raises ITEM/BALL only; Gold KEY_ITEM/TM_HM remain downstream; the 99-per-item stack guard in `Bag.add` is not modified; PC storage code is untouched; stale Save Editor wrapper ownership is recoverable.

Runtime matrix: exceed native R/B/Y Bag slots; exceed Gold ITEM and BALL pockets; try a 100th copy of an existing item; toggle OFF while over capacity; verify existing inventory remains; then verify a new distinct item is refused until room exists. Check at least one story/key item and one TM/HM in Gold for unchanged behavior.

## 2.5.33-DEV Running Shoes / Fast Surf confidence

**SOURCE/STATIC PASS; R/B/Y + GOLD RUNTIME TEST REQUIRED.** Gen1Recomp's R/B/Y player sends `onBike`, `surfing`, and input through `movement.speed`; Gold's World sends the same movement-state keys for each ordinary player step. Gold scripted steps are authored separately and do not inherit the ordinary player-step speed path.

Static expectations: legacy Running Shoes `true` normalizes/migrates to HOLD B; OFF returns native step duration; HOLD B halves only with B held; ALWAYS halves without requiring B; Running Shoes never modifies Surf/bike steps; Fast Surf never modifies on-foot/bike steps; QoL Toggles `run_hold_b` does not cause the same held-B walking step to be halved twice.

Runtime matrix: test OFF/HOLD B/ALWAYS on foot and while Surfing in at least one R/B/Y game and Gold; test bike speed unchanged; test a Surf start/Waterfall or other scripted movement unchanged; optionally combine Running Shoes ALWAYS with QoL Toggles `run_hold_b`.

## 2.5.32-DEV Gold Random Starter confidence

**Static/source PASS; Gold runtime TEST REQUIRED.** The three-ball slate is generated in fixed canonical order and cached under a dedicated deterministic namespace, with duplicate avoidance where legal alternatives exist. Preview rewrites use copied command/argument tables. Runtime must verify all three Elm previews, cry/portrait agreement, accepted starter identity, and nickname enforcement.

## 2.5.31-DEV PC-aware Whiteout / Blackout confidence

### Recovered behavior and current implementation
- **DESIGN RESTORED:** Whiteout ON is the survivable branch; Whiteout OFF is Blackout/run-ending. 2.5.31 adds the new requirement that survival must have at least one legal recovery Pokemon left in party/Box storage.
- **SOURCE CONFIRMED:** Permadeath pruning happens before the full-wipe classification in both battle paths and the field-poison adapters, so recorded dead Pokemon cannot qualify as recovery reserves.
- **SOURCE CONFIRMED:** PC-Only Catch locks (`nuzlockePcLocked`) and Eggs are excluded from recovery.
- **SOURCE CONFIRMED:** Gold's native Bill's PC rejects an empty party at construction; the 2.5.31 owner-aware wrapper clears only that refusal when an eligible boxed Whiteout reserve exists.
- **MIGRATION:** existing saves invert the pre-2.5.31 stored `whiteout_clause` once to preserve selected behavior; fresh saves stamp `whiteout_semantics_restored_2531` at creation. Save Schema remains 4.

### Runtime status
**SOURCE/STATIC PASS, R/B/Y + GOLD RUNTIME TEST REQUIRED.** Priority matrix: Whiteout ON + Permadeath ON + legal boxed reserve; Whiteout ON + no reserve; Whiteout ON with only PC-locked/Egg storage; Whiteout OFF + legal boxed reserve; Permadeath OFF Whiteout; field-poison wipe; First Rival Mercy; save/reload semantic migration; Gold empty-party PC withdrawal.

## 2.5.30-DEV Gold Random Starter confidence

### Confirmed input evidence
- **RUNTIME FAIL (Gold 2.5.22):** Random Starter ON still granted the vanilla Elm starter.
- **RUNTIME PASS (same Gold 2.5.22 test):** starter nickname enforcement worked, so the nickname path is protected from this repair.

### 2.5.30 repair confidence
- **SOURCE CONFIRMED:** current Gen1Recomp's Gen 2 VM dispatches `givepoke` through its `hooks.givePoke` callback; 2.5.30 wraps that transaction rather than relying only on the earlier script-row mutation.
- **STATIC PASS / RUNTIME TEST REQUIRED:** owner identity, canonical-starter scoping, deterministic selection/commit, staged Setup handoff, and DEV health reporting passed the package static checks. A real Gold NEW GAME is still required to promote Random Starter itself back to runtime PASS.
- Existing Gold nickname enforcement remains a protected historical runtime PASS and is not intentionally changed.

## 2.5.29-DEV Gold parity confidence

### Source-confirmed behavior
- `encounter_ball_limit` is now present in `goldBetaRules`; Gold continues to use the pre-existing native battle-Pack limit counter/refusal path and the shared OFF/1/2/3/5/10 selector semantics.
- Gold resource rows use dedicated `gold_starting_money`, `gold_starting_pokeballs`, and `gold_starting_rare_candies` keys; the historical R/B/Y rows are explicitly R/B/Y-only.
- Gold Starting Money writes only the fresh save's native `player.money` and clamps to 0-999999.
- Gold Starting Rare Candy writes only fresh-save `pcItems.RARE_CANDY`.
- Gold Starting Poke Balls are stored as a one-shot deferred amount and are released to `pcItems.POKE_BALL` only after Gold's live `EVENT_GAVE_MYSTERY_EGG_TO_ELM` event is set. The native 5-Ball story transaction is not replaced or suppressed.
- Quick Start leaves the configured Gold extra-Ball amount separate from its native 5-Ball reconciliation, so the extra PC allotment can release once after the same progression flag.

### Confidence
**SOURCE/STATIC PASS, GOLD RUNTIME TEST REQUIRED.** Validate Gold Setup visibility/input, Ball Per Enc. enforcement/reset, six-digit money, PC candy, normal-story deferred extra Balls, Quick Start extra Balls, exactly-once release, and R/B/Y/Gold setup-profile isolation.

## 2.5.28-DEV PC-Only Catch confidence

### Source-confirmed behavior
- The rule defaults OFF and is available on both R/B/Y and Gold rule/setup surfaces.
- Eligible denied capture reasons can be converted to a research-only capture only when native storage capacity exists; Gold mirrors the full-party/current-Box Ball refusal boundary, and malformed/glitch safety is not in the exception allowlist.
- Ordinary No Catching is not bypassed unless a cooperative source explicitly marks the capture progression-required and exception-allowed.
- `pokemon.caught` is handled before normal catch accounting: the mon is permanently marked `nuzlockePcLocked`, moved from party to Box if necessary, omitted from ordinary encounter spend/tracker/Catch Draft accounting, and recorded in history as `PC_LOCKED`.
- The current-owned-Pokemon Dupes safety net ignores PC-locked research catches.
- R/B/Y and Gold native PC surfaces block withdraw/box-to-party/release; public PartyPC policy mirrors those refusals for compatible alternate PCs.
- A PC-lock marker survives rule changes because enforcement reads the Pokemon marker, not the current PC-Only Catches toggle.

### Confidence
**SOURCE/STATIC PASS, RUNTIME TEST REQUIRED.** Validate R/B/Y + Gold successful illegal capture -> immediate Box, area remains available, Catch Draft unchanged, withdraw/move/release refusal, same-family later encounter not treated as a Dupe solely from the locked mon, save/reload persistence, R/B/Y all-storage-full refusal, Gold full-party/current-Box refusal, and ordinary No Catching remaining absolute.

## 2.5.27-DEV Maximum BST preset confidence

### Source-confirmed behavior
- The preset ladder is OFF / 300 / 350 / 400 / 450 / 500 / 550 / 600 / 650 / 700.
- Existing numeric save values still feed the same `getMaximumBST()` enforcement path and are not migrated or rounded on load.
- A non-preset legacy value remains CUSTOM until player adjustment; nearest-preset lookup only chooses the starting point for cycling.
- Preset cycling derives from the shared ladder max index rather than a hard-coded five-entry count.

### Confidence
**SOURCE/STATIC PASS, RUNTIME TEST REQUIRED.** Cycle LEFT/RIGHT/A through both ends of the ladder in R/B/Y and Gold, then verify a newly acquired Pokemon above a selected cap is rejected while one at/below it remains legal.

## 2.5.26-DEV R/B/Y Stat Info layout confidence

### Source-confirmed behavior
- STAT right-column values are preserved to a 14-glyph budget before draw instead of the generic 9-glyph Catch-page budget.
- ATK/DEF/SPE/SPC rows render from x=40 with 14 glyphs of usable width; LEVEL/HP render from x=64 with 11 glyphs.
- Catch, Move, Gold, rules, saves, and randomizer behavior are untouched.

### Confidence
**SOURCE/STATIC PASS, RUNTIME VISUAL TEST REQUIRED.** Check ordinary values and a high Stat EXP row in R/B/Y and confirm no overlap with labels/borders and no avoidable marquee.

## 2.5.25-DEV Random Field Items confidence

### Source-confirmed behavior
- R/B/Y visible item balls are intercepted only at the native `OverworldController:talkTo` item-object arm; the authored object payload is restored immediately after the native pickup call.
- Gold visible `OBJECTTYPE_ITEMBALL` pickups are intercepted only while building `HiddenItems.ballPickupScript`; hidden BG-event items use a different path and remain untouched.
- Key-item metadata, Gold KEY_ITEM pocket entries, HMs, badges, and obvious placeholder/unused records are excluded from the replacement pool. A protected original pickup always returns its original item.
- Slot selection uses the existing versioned seeded helper with stream `FIELD_ITEMS` and map/object semantic identity; no traversal-order RNG state is consumed.
- Direct wrappers use owner-aware session markers and revalidate on mods.loaded, game.ready, save.loaded, and save.created.

### Confidence
**SOURCE/STATIC IMPLEMENTATION; RUNTIME TEST REQUIRED.** Highest-value tests are ordinary R/B/Y and Gold item balls, full-bag retry, deterministic same-seed replay, and protected HM/key-item pickups. Hidden items/gifts/shops/fruit/apricorn rewards should be smoke-tested to confirm they remain vanilla.

## 2.5.24-DEV Rules/Setup position confidence

### Source-confirmed behavior
- Configuration navigation memory is isolated by the existing `setup|rules` + `rby|gold` surface key.
- Restoration uses stable rule/header identities for both the selected row and the top visible row rather than a raw index.
- Memory is module-local UI state only; it does not call `mod.save:set`, setup-profile persistence, or any save migration path.
- Existing collapsed-section state remains independent and the restored cursor is clamped by the live visible list before draw-time scroll correction.

### Confidence
**SOURCE/STATIC PASS, RUNTIME TEST REQUIRED.** Highest-value checks are deep-list close/reopen in R/B/Y and Gold, separately for Setup and active Rules, followed by collapse/expand and dependent-row visibility changes to ensure restoration remains on the intended semantic row.

## 2.5.23-DEV Yellow / fresh-New-Game confidence

### Runtime evidence that triggered this child
- **2.5.22 Yellow fresh New Game, Skip Opening Intro:** broad smoke test was stable with no crash found, but Random Starter returned vanilla Pikachu, starter provenance/logging was UNKNOWN/not Pallet Town, No Mom Heal failed to enforce, and the Yellow Oak Pallet capture demo did not skip.

### Source-confirmed repairs
- Random Starter's 2.5.22 caller referenced `Randomizer` / `seededIndex` outside the local block that owned them. 2.5.23 exposes the deterministic helper deliberately across the phase boundary; algorithm-v1 results are preserved.
- The R/B/Y `heal_party` / resolver / `give_pokemon` wrapper tail had been stranded outside `installNuzlockeFieldCommandPatches`, so the installer could not establish the complete Mom/starter transaction session. The tail is back inside its owning scope.
- Late-runtime phase 2, which owns the Yellow Oak demo skip and authoritative script-command Mom fallback, was staged and then cleared without execution. 2.5.23 executes it and records machine-readable health.
- Critical R/B/Y wrapper installers now also revalidate at `save.created`, matching the actual fresh-New-Game lifecycle.

### Confidence
**RUNTIME FAIL REPAIRED IN SOURCE / STATIC GATES PASS REQUIRED / EXACT RUNTIME RETEST REQUIRED.** Highest-value retest is the same Yellow fresh-New-Game path: Random Starter ON, Skip Catch Demo ON, No Mom Heal ON, then verify the starter is randomized/deterministic, logged as Pallet Town, Oak's demo is skipped while story continues, Mom refuses to heal, and the new DEV SELF TEST rows are healthy.

## 2.5.22-DEV kerning / randomizer-version confidence

### Source-confirmed repairs
- Gen 1 kerning previously treated a historical `Font._nuzlockeAdvanceOf` predecessor marker as proof that the live wrapper belonged to the current Nuzlocke reload. 2.5.22 records exact session token / previous / wrapper identity and only unwraps an exact top-level stale Nuzlocke session.
- Starter seeded selection previously duplicated the v1 hash input with literal `"1"` / `"v1"` strings. 2.5.22 routes starter selection through the same `Randomizer.algorithmVersion` + `seededIndex()` source used by encounters and learnsets.
- Current algorithm version remains 1, and the shared helper receives the same `1:SEED:STARTER:SCOPE` input as the old inline starter hash, so existing v1 deterministic starter results are intentionally preserved.

### Confidence
STATIC/SOURCE REPAIR / RUNTIME TEST REQUIRED. Highest-value checks: fresh-process Gen 1 kerning, a Nuzlocke reload followed by Gen 1 text rendering, and a known seed/starter comparison against 2.5.21 to confirm the v1 starter result is unchanged. A direct hot-upgrade from <=2.5.21 may request one fresh process because the old format did not record wrapper identity.

## 2.5.21-DEV trainer identity confidence
- **SOURCE/STATIC PASS, RUNTIME TEST REQUIRED:** Gym reward recognition and R/B/Y + Gold League progression now consume the same normalized trainer ID/class/name identity surface.
- Local invariants verify the shared extractor covers Gen 1 `oppClass`, generic provider class aliases, and Gold `trainer.classId` / `trainer.class`, and verify progression no longer reconstructs an id/name-only path.

## 2.5.20-DEV tracking/enforcement confidence
**SOURCE/STATIC PASS, RUNTIME TEST REQUIRED:** battle finalization now distinguishes PASSIVE_PROGRESS from RULE_ENFORCEMENT. Supported-save boss progression remains synchronized while Nuzlocke is OFF; Failed Encounter, Forgiveness Tokens, trainer-money rewriting, and post-battle Permadeath cleanup remain challenge-only; unsupported newer-schema saves are protected by the write-safety policy. Highest-value runtime checks are one Gym win with Nuzlocke OFF then ON, one failed wild encounter while OFF, and Forgiveness Token shop behavior while OFF.

## 2.5.19-DEV save/API confidence
Static/source PASS: newer-schema starter repairs and identity mutation paths now stop before direct save-backed mutation; compatibility engine reporting is defensive/fresh; schema bookkeeping descriptors and save-write wrapper ownership are strengthened. Runtime regression test remains required.


## 2.5.18-DEV infrastructure confidence
- **SOURCE/STATIC PASS, RUNTIME TEST REQUIRED:** Compatibility metadata defensive-copy hardening, effective-rule canonical fallback, Rule Registry collision reporting, Save Schema descriptor mirror/legacy metadata, and DEV SELF TEST copy safety.
## 2.5.17-DEV development-quality infrastructure

### Source/static confidence
- Build provenance binds this child to 2.5.16-DEV and the exact parent package SHA-256.
- Rule Registry descriptors are derived from the existing rule table/default resolver rather than becoming a parallel enforcement source.
- Save Schema descriptor coverage is deliberately limited to configuration/schema-control fields and does not claim full internal-save coverage.
- Compatibility API 28 adds per-capability contract-version negotiation; existing API-27 capability meanings remain compatible.
- Dev SELF TEST now audits all four development descriptors/contracts.

### Confidence
SOURCE/STATIC DEVELOPMENT-INFRASTRUCTURE PASS / GAMEPLAY RUNTIME SHOULD MATCH 2.5.16. Highest-value confirmation is DEV TOOLS -> SELF TEST showing PASS for `rule_registry_descriptor`, `save_config_descriptor`, `build_provenance`, and `compat_capability_versions`.

## 2.5.16-DEV reliability / diagnostics follow-up

### Source-confirmed repairs
- Public `ruleActive()` no longer reports a missing default-ON boolean rule as OFF.
- Missing `locke_type` reads/verification use the canonical NUZLOCKE fallback rather than historical CUSTOM/0 fallbacks.
- Remaining high-value direct wrappers verify live function identity, including AUTO-REPEL and both Wilds capture seams.
- Dev hook-health now reports substantially more enforcement/lifecycle seams.

### Confidence
STATIC/SOURCE REPAIR / RUNTIME TEST REQUIRED. Highest-value checks: missing-key/default-ON compatibility query if a safe dev seam exists; automatic names after reload; R/B/Y catch+Permadeath; Gold nickname/Mart/Game Corner; QoL AUTO-REPEL with No Repels; Wilds allowed/blocked overworld catch with tracking.

## 2.5.15-DEV reliability follow-up

**Static/source confidence: high; runtime confirmation required.**

- Confirmed: field-poison faints occur outside the battle Whiteout gates. 2.5.15 arms a generation-specific final-warp interception so **Whiteout ON** ends the run after an overworld poison wipe even with Permadeath OFF.
- Confirmed: Gold's `battle.run` payload carries a pure `Battle` object without `battle.game`; 2.5.15 resolves `currentGame/mod.game` so No Escape can activate on Gold.
- Confirmed: `applyNewGameSnapshot()` verified `locke_type` without writing it in that transaction. 2.5.15 persists the staged loadout before verification.
- Confirmed lifecycle risk: Party Size/PC withdrawal, Gold No Day Care, Gold battle Whiteout finish, Gold Headbutt tracking, and forgiveness-token mart stock still used boolean-only install markers. 2.5.15 moves those seams to owner-aware wrapper sessions.

Runtime test focus: poison full-party wipe with Whiteout ON + Permadeath OFF in one R/B/Y game and Gold; Gold ordinary wild RUN with No Escape ON/OFF; new-game preset persistence; PC party-limit withdrawal; Gold Day Care, Headbutt, Whiteout, and forgiveness-stock after a reload.

## 2.5.14-DEV bug-fixing / lifecycle follow-up

**Static/source confidence: high; runtime confirmation required.**

- Confirmed: R/B/Y `nuzlockeGivePokemon()` referenced `save.player.map` before its intended local `save = ctx.save` declaration. 2.5.14 fixes the ordering without changing gift/starter policy.
- Confirmed: several core enforcement reads used old inline OFF defaults despite the canonical fresh profile using One Per Area ON, Nickname Rule ON, Dupes FAMILY, Allow Gifts ON, and Allow Trades ON. 2.5.14 routes missing keys through the canonical default source; explicit saved values are untouched.
- Confirmed lifecycle risk: older R/B/Y catch/Permadeath and Gold capture wrappers relied on boolean install markers that can outlive a ModLoader's `mod` object. 2.5.14 records wrapper ownership/predecessors for future loader-session cleanup.
- Reviewed/no change: Gen1Recomp 0.2.7 TimeFishGroups row-local day/night values intentionally outrank the shared fallback table, so forced synchronization is not a safe compatibility fix.

Runtime test focus: starter provenance/nickname, R/B/Y catch refund/spend, R/B/Y faint/Whiteout, and Gold Ball/catch behavior.

## 2.5.13-DEV field-poison Permadeath follow-up

### Source-confirmed defect / static repair
- Gen1Recomp R/B/Y applies overworld poison directly in `OverworldState:applyFieldPoison`; the field path does not enter `BattleState:onFaint`.
- Gen1Recomp Gold `StepEvents.poisonStep` returns `poisonFaint` indices and `World:poisonFaintScript` owns the happiness/text/whiteout sequence; this path does not emit `battle.fainted`.
- Before 2.5.13, Nuzlocke's Permadeath bookkeeping was battle-faint driven, so a field-poison faint could remain outside `nuzlocke_history`/loss projection and be eligible for a later native heal.
- 2.5.13 records the exact field-fainted Pokémon through the existing death-history contract and removes those same live objects from the party while preserving native presentation and whiteout scheduling.
- Nuzlocke OFF and Permadeath OFF are unchanged; the new wrappers are owner-aware across loader sessions.

### Confidence
SOURCE/STATIC PERMADEATH REPAIR / RUNTIME TEST REQUIRED. Highest-value checks: one non-party-wipe poison faint and one full-party poison wipe in R/B/Y, then the same two cases in Gold. Confirm death count/history increments once per faint, the dead Pokémon is not restored by blackout healing, and Permadeath OFF leaves native behavior unchanged.

## 2.5.12-DEV Gen1Recomp 0.2.7 compatibility follow-up

### Source-confirmed defect / static repair
- Gold's shared `encounters` registry is merged into `game.data.gen2Encounters`; Nuzlocke's public `effectiveEncounters()` / `Registry.describe()` still exposed only `game.data.encounters`.
- 2.5.12 exposes the generation-correct final live table while preserving the existing randomizer/reveal/selection semantics.
- The final 0.2.7 Gold fishing schema (`TimeFishGroups`, `day`/`nite`) was reviewed. Nuzlocke's existing recursive randomizer and variadic fishing hook preserve the structure/signature; no encounter-generation rewrite is required.

### Confidence
STATIC/SOURCE COMPATIBILITY REPAIR / GOLD RUNTIME TEST REQUIRED. Useful smoke tests: Gold OPEN INFO + encounter-information consumer, day/night fishing with Good/Super Rod, No Catching/Ball Per Enc., and Gold mart restrictions.

## 2.5.11-DEV World Building T1 consistency follow-up

### Source-confirmed defect
- The canonical/default-rule path already returned World Building T1, but `worldTier()` still used a historical inline T3 fallback when the save key was absent.
- The generic numeric-value path also retained an inline T3 fallback for a missing/non-numeric World Building value.
- The rule description still said `RECOMMENDED: TIER 3`, contradicting the 2.5.4 default change.

### 2.5.11 static repair / TEST REQUIRED
- Live flavor resolution and configuration-value fallback now share `defaultRuleValue("world_building_tier")`.
- Rule copy now says `DEFAULT: TIER 1`.
- Explicit saved OFF/T1/T2/T3 selections are unchanged.

### Confidence
STATIC CONSISTENCY REPAIR / RUNTIME TEST REQUIRED. No enforcement, provider, API, schema, or engine-range semantics changed.

## 2.5.10-DEV Pokégear / tracker UI follow-up

### 2.5.9 source-confirmed defects
- Gold Pokégear NUZ RULES advanced by four rows but compared against a sliding-window max offset, making a non-multiple-of-four final page unreachable.
- The Pokégear RULES page gave no visible affordance that A advances the inner rule list.
- ENC TRACKER native and Modern UI views could show a blank list with no explicit empty-state explanation.

### 2.5.10 static repair / TEST REQUIRED
- Pokégear RULES uses true four-row page offsets, reaches final partial pages, shows `RULES x/y`, and advertises `A:MORE` when applicable.
- Native R/B/Y, native Gold, and Modern UI tracker views show translated `NO ENTRIES YET` for a genuinely empty selected data set.
- Modern UI still reports zero real entries and excludes the placeholder from selected detail/provider semantics.

### Confidence
STATIC UI REPAIR / RUNTIME TEST REQUIRED. No encounter/enforcement/save/provider semantics changed.

## 2.5.9-DEV Yellow setup follow-up

### Yellow 2.5.8 runtime PASS
- Fresh/new-profile Shiny Clause defaults to OFF/0.
- Type Locke can be edited in NUZ RULES without the prior generic update error.

### Yellow 2.5.8 runtime FAIL
- Saving NEW GAME setup failed with an attempt to index global `TYPE_LOCK_SLOT_INDEX`; the setup/profile code lived outside the lexical Type Locke owner block.
- Loadout warning readability improved, but it still hid additional owned-rule changes behind a `+N MORE` summary instead of allowing full review.

### 2.5.9 static repair / TEST REQUIRED
- Setup/profile Type Locke slot tests use the stable exported index accessor; Gold status Type Locke labels use the stable key accessor.
- Loadout warning scrolls through every changed owned rule with UP/DOWN.
- Nuzlocke-owned setup/rules/status errors use explicit manual pages.
- GAME DIFFICULTY then BATTLE MECHANICS are immediately above AREA SPLITS.

### Gold First Rival Mercy audit
NO CODE CHANGE. Gen1Recomp 0.2.7's `gen2_canlose_test.lua` pins the Cherrygrove battle to `BATTLETYPE_CANLOSE`: a loss resumes the script at the battle site with the starter still at 0 HP, and `.FinishRival` later runs `HealParty`. The existing G2 early return is therefore source-consistent; adding R/B/Y's temporary 1-HP bridge would be unnecessary divergence. Runtime Gold coverage remains useful, but this is not a confirmed defect.

## 2.5.8-DEV Yellow setup/rules repair

### Yellow 2.5.7 runtime FAIL
- Loadout-change warning remained visually broken: long preview rows crossed/clipped the modal frame.
- Changing Type Locke triggered the generic NUZ RULES update-error dialog (“Please report this text”).

### 2.5.8 static repair
- R/B/Y loadout preview rows are bounded to a native-width line; long rule names marquee inside their budget instead of drawing through the frame.
- Type Locke edit/update paths use lifecycle-stable exported slot/default accessors, including random Type Locke resolution.
- Fresh/new-profile Shiny Clause default is OFF/0; explicit existing values are not migrated or reset.
- Route Forgiveness is listed under GENERAL with mechanics unchanged.

### Confidence
STATIC REPAIR / RUNTIME TEST REQUIRED. Re-test Yellow loadout warning rendering and Type Locke OFF/MONO/DUO editing before promotion to PASS. The 2.5.7 Dev Report layout repair also remains runtime TEST REQUIRED.

## 2.5.7-DEV Dev Report presentation repair

### Blue 2.5.6 runtime PASS
- DEV TOOLS -> VIEW REPORT opened a previously saved report after a full game exit/relaunch without crashing. The 2.5.6 saved-report View Report crash repair is runtime PASS for that path.

### Blue 2.5.6 runtime FAIL / UI
- Dev Report text and the NZR4 Report Code overflow/clipped past the native R/B/Y viewport.
- Storage Info long identifiers such as the playthrough ID likewise overflowed.

### 2.5.7 static repair
- R/B/Y diagnostic content width reduced to 16 characters.
- Dev-only wrapping now hard-splits unbroken identifiers while preserving ordinary menu wrapping elsewhere.
- NZR4 is displayed beneath `REPORT CODE:` using the existing hyphen groups as safe break points.

### Confidence
STATIC UI REPAIR / RUNTIME TEST REQUIRED for layout. Verify full code visibility, Storage Info wrapping, scroll bounds, and no View Report crash regression. The shared 2.5.6 NUZ RULES edit fix is still TEST REQUIRED. The loadout warning popup remains a separate runtime-confirmed UI defect.

## 2.5.6-DEV Blue runtime repair attempt

### Confirmed 2.5.5 runtime FAIL
- NUZ RULES: toggling No Mom Heal and other ordinary rules can fail in the shared update path with `ipairs(nil)` after the live save write.
- DEV TOOLS: choosing VIEW REPORT crashes the game on the following update frame.

### 2.5.6 static repair
- NUZ RULES title/setup synchronization now has a canonical Type Locke slot/default fallback instead of crashing unrelated rule edits when the shared table reference is unavailable.
- DEV report rendering now captures a forward-declared local helper rather than an unresolved global.
- MOD COMPAT left rule-name rows are no longer pseudo-bolded by drawing the same label twice.

### Confidence
STATIC REPAIR / RUNTIME TEST REQUIRED. Do not mark either crash as PASS until exercised on Blue 2.5.6-DEV. The 2.5.5 opening-sequence repair remains separately TEST REQUIRED.

## 2.5.5-DEV Blue opening repair attempt

### 2.5.4 runtime PASS carried forward
- Blue Oak intro skip.
- Starting Balls.
- Starting Rare Candies.
- Starting healing items.
- Starting vitamins.
- Random starter selection presented correct randomized choices.
- BASE starter-style filter.

### 2.5.4 runtime FAIL / regression cluster
- Randomized Blue starter could skip mandatory Nickname Rule.
- Randomized Exeggcute starter was not attributed to Pallet Town.
- First Rival Mercy dialogue fired but opening Rival loss could restart/rewind opening progression.
- Repeated starter acquisition occurred.
- On the repeat, player starter randomized again while Rival starter synchronization was lost.

### 2.5.5 repair status carried into 2.5.6
Static repair attempted in 2.5.5 and carried forward without an intentional opening-sequence rewrite in 2.5.6. Runtime validation is REQUIRED on 2.5.6-DEV before any item is promoted to PASS.

## 2.5.4-DEV rules consolidation

Static PASS:
- World Building new-run default is T1.
- Cap Messages removed from the rule catalog.
- Cap notice policy fixed to once per battle on the first blocked/banked EXP award.
- Solo Only removed from rule catalog and duplicate enforcement.
- Party Size Limit is authoritative; SOLO/IRON use limit 1.
- Legacy Solo saves migrate to Party Size Limit 1.

Runtime retest:
- New setup shows World Building T1.
- First capped EXP event shows one notice; later capped EXP in the same battle stays quiet.
- SOLO preset sets Party Size Limit to 1 and all standard party-growth gates use that cap.

## 2.5.3-DEV Blue menu runtime follow-up

Runtime evidence: Pokémon Blue / Gen1Recomp 0.2.7 showed the pre-fix GENERAL layout and Ball Limit alignment.

Static PASS:
- No Catching + Ball Per Enc. now belong to BATTLE ITEMS.
- Ball Per Enc. is hidden whenever No Catching is ON.
- No Catching changes rebuild dependent rows immediately.
- Ball Per Enc. default remains OFF.
- GAME DIFFICULTY and BATTLE MECHANICS precede GENERAL.

Runtime retest:
- No Catching ON -> Ball Per Enc. disappears immediately.
- No Catching OFF -> Ball Per Enc. reappears immediately.
- Ball Per Enc. value column visually aligns with other controls.
- Confirm section order: GAME DIFFICULTY, BATTLE MECHANICS, AREA SPLITS.

## 2.5.2-DEV engine/diagnostic audit

### Static PASS
- `randomizer_info_policy` boolean/out-of-range diagnostic detection.
- No save migration added for that selector because the historical setter was already numeric.
- Gen1Recomp 0.2.1 → 0.2.7 release deltas reviewed sequentially.
- 0.2.2 shared Gold move-grid hook classified as additive/not-owned.
- 0.2.3 Gold BattleAPI item/catch-preview expansion requires no Nuzlocke enforcement change.
- Mod API 2 / engine save format 4 retained through 0.2.7.
- Engine range remains `>=0.1.86 <2.0.0`.

### Runtime retest
- Normal Yellow/Gold smoke test on Gen1Recomp 0.2.7 remains recommended.
- Gold mart rules and encounter/catch restrictions are especially useful smoke-test targets after upstream Gold UI/catching changes.

## 2.5.1-DEV validation status

This is a runtime-validation child of the unreleased 2.5.0 candidate. No gameplay logic changed from that candidate.

Priority runtime retests:
- Yellow Mom Heal ON/OFF.
- Field-item rejection pacing.
- Randomized starter Pallet Town Tracker/map projection.
- Shiny Clause persistence.
- Encounter Ball Limit persistence/enforcement.
- Randomizer Info Policy display persistence.
- Dev Report Species Facts row.
- NZR4 Report Code on the 2.5.x version line.
- Gold and multi-mod compatibility where practical.

## 2.5.0 publication confidence

### Static PASS
- Strict parent lineage from 2.4.100-DEV verified by SHA-256.
- Lua syntax validation (when `luac` is available).
- ZIP integrity.
- Exact 15-file package set preserved.
- Manifest/main/mod.card/docs version synchronization.
- All 36 `numeric = true` rules represented in default/get/set config plumbing.
- No duplicate rule keys in the 108-rule catalog.
- Dev Species Facts check targets the live `getSpeciesFacts` resolver.
- NZR4 encodes/decodes full major/minor/patch.
- Public exported build fields resolve to the current authoritative build.
- Engine range remains `<2.0.0`.

### Runtime evidence carried forward
- Yellow / AYN Thor / recent dev: No Field Heal enforcement with Potion — PASS.
- Several recent defects were found through Yellow runtime testing and repaired in the 2.4.94–2.4.100 line.

### Runtime retests still valuable
- Mom Heal ON/OFF after stale-wrapper repair.
- Player-paced field-item rejection pages.
- Randomized starter Pallet Town Tracker/map projection.
- Shiny Clause and Encounter Ball Limit persistence/cycling.
- OPEN INFO / BLIND INFO display persistence.
- Gold parity and multi-mod combinations.

Static PASS is not presented as a substitute for these runtime checks.

## 2.4.100-DEV Randomizer Info Policy
- Gameplay enforcement read: previously correct.
- setConfigValue 0/1 persistence: previously correct.
- getConfigValue 0/1 UI readback: static PASS after repair.
- Full numeric-rule default/get/set coverage sweep: static PASS.
- Runtime OPEN INFO ↔ BLIND INFO display persistence: RETEST REQUIRED.

## 2.4.99-DEV Encounter Ball Limit config plumbing
- defaultRuleValue OFF default: static PASS.
- getConfigValue numeric 0..5 readback: static PASS.
- setConfigValue numeric 0..5 persistence: inherited static PASS from 2.4.98.
- default audit coverage: static PASS.
- Dev stored/read comparison row: static PASS.
- Runtime cycle + leave/reopen persistence: REQUIRED.

## 2.4.98-DEV numeric selector setter repair
- `shiny_clause` setConfigValue numeric branch: static PASS.
- `encounter_ball_limit` setConfigValue numeric branch: static PASS.
- Boolean-artifact semantic repair: static PASS.
- Numeric-selector sweep identified these as the two missing branches in the current rule catalog.
- R/B/Y + Gold runtime selector cycling/persistence: RETEST REQUIRED.

## 2.4.97-DEV compact legacy mod IDs
- `CatchHelper` → `CATCHHELPER` capability detection: static PASS.
- Joined/separated fallback coverage for all multi-word hints in `detectCapabilities`: static PASS.
- Runtime legacy-adapter scan with compact IDs: TEST REQUIRED.

## 2.4.96-DEV randomized starter provenance
- Yellow/AYN Thor Tangela Pallet Town Tracker/map: prior runtime FAIL.
- Provenance-based starter resolver: static PASS.
- Existing-save narrow repair: static PASS.
- Yellow randomized starter Tracker + map runtime retest: REQUIRED.

## 2.4.95-DEV field-item rejection presentation
- Yellow/AYN Thor No Field Heal enforcement: RUNTIME PASS.
- Yellow/AYN Thor No Field Heal message pacing: prior runtime FAIL; repair static PASS, retest required.
- Yellow/AYN Thor No Rare Candy message pacing: prior runtime FAIL; repair static PASS, retest required.
- Battle rejection path unchanged.

## 2.4.94-DEV No Mom Heal
- Yellow/AYN Thor regression report: runtime FAIL on last release build.
- Stale-session/live-wrapper repair: static PASS.
- Dev `mom_heal_gate` health row: static PASS.
- Yellow No Mom Heal ON/OFF runtime retest: REQUIRED.
- Previous historical No Mom Heal runtime PASS remains evidence of intended behavior, not evidence that this regression is fixed.

## 2.4.93-DEV Report Code
- Bit-pack/base32 codec: static PASS.
- Live VIEW REPORT without storage/export: static PASS.
- Fixed-summary decode round-trip: source/static validated.
- Full free-form report binding: 20-bit fingerprint.
- Yellow/AYN Thor runtime: TEST REQUIRED.

## 2.4.92-DEV diagnostic UI layout
- Yellow/AYN Thor Storage Info overflow: confirmed runtime issue on last release build.
- Storage Info wrapped-row repair: static PASS; runtime retest required.
- Dev Report wrapped scrolling consistency: static PASS; runtime retest required.
- Diagnostic contents and gameplay remain unchanged.

## 2.4.91-DEV Dev Report layout
- Yellow/AYN Thor overflow report: confirmed runtime issue on last release build.
- Wrapped narrow-layout repair: static PASS; runtime retest required.
- Dev Report diagnostic contents are unchanged.

## 2.4.90-DEV Yellow Skip Catch Tutorial
- Static/source validation: PASS.
- Yellow opening Oak demo: RUNTIME RETEST REQUIRED.
- Yellow Viridian Old Man demo: TEST REQUIRED.

## 2.4.89-DEV Cap Messages
- Setter/type repair: static PASS.
- Default BATTLE: static PASS.
- Boolean-artifact migration: static PASS.
- Yellow A/LEFT/RIGHT runtime retest: REQUIRED.
- Level-cap enforcement itself is unchanged.

## 2.4.87-DEV menu runtime evidence
- Yellow: holding SELECT pages section headers — RUNTIME PASS.
- Yellow: SELECT + LEFT/RIGHT opens/closes all headers — RUNTIME PASS.
- Party Size Limit / Gym Team Size relocation — static PASS, presentation TEST REQUIRED.
- Existing rule enforcement is unchanged.

## 2.4.85-DEV Encounter Ball Limit
- Static/package validation: PASS.
- R/B/Y runtime: TEST REQUIRED.
- Gold runtime: TEST REQUIRED.
- Interaction tests required: No Catching, illegal encounter/species, successful catch before limit, failed throws through limit, new encounter reset.
- Prior runtime PASS evidence remains protected.

## 2.4.84-DEV old-save selector migration
- Static/package validation: PASS.
- Legacy `shiny_clause=true` migration to numeric 4: static PASS; runtime old-save TEST REQUIRED.
- Fresh-save Shiny selector behavior is unchanged.
- No Permanent Seal behavior changed.

## 2.4.83-DEV Yellow starter nickname
- Upstream Yellow native prompt: source/test confirmed.
- Nuzlocke Yellow composition: static PASS, runtime TEST REQUIRED.
- Red starter nickname prompt: prior runtime PASS preserved.
- Quick Start / intro-skip Yellow naming: TEST REQUIRED.

## 2.4.82-DEV PT-BR compatibility
- Static/source compatibility audit: PASS.
- `gen1_pt-br` v0.1.5 runtime combination: TEST REQUIRED.
- Priority tests: Yellow setup/starter naming, NUZ RULES, ENC TRACKER, Trainer Card/Nuz Info, battle UI, item lists, accented long text.
- Existing runtime PASS evidence remains protected.

## 2.4.81-DEV upstream compatibility
- Package/static validation: PASS.
- New BattleAPI snapshot consumption: TEST REQUIRED on a current engine.
- Yellow starter nickname flow: TEST REQUIRED.
- Prior runtime PASS behavior is not superseded.

## 2.4.80-DEV localization
- Static/package validation: PASS.
- Runtime translation-mod validation: TEST REQUIRED.
- No prior runtime PASS is superseded by this static pass.

# Nuzlocke 2.4.79 DEV feature-confidence ledger

**STATIC/SOURCE PASS is not RUNTIME PASS.**

## 2.4.79 — GEN1 BETTER MENUS SOURCE/STATIC COMPATIBILITY PASS; RUNTIME TEST REQUIRED

No gameplay feature receives a new runtime PASS. Gen1 Better Menus 1.0.3 shared UI seams were source-audited; deterministic optional-dependency ordering and descriptive compose metadata were added. R/B/Y combination remains TEST REQUIRED. Protected 2.4.78 Type Locke/Catch Draft behavior is unchanged.

## 2.4.78 — TYPE LOCKE EXPANSION / STATIC PASS, RUNTIME TEST REQUIRED
Source/static validation covers the 1-6 lane rule surface and Catch Draft state transitions. No runtime PASS is claimed yet for Quadlocke, Pentalocke, Hexalocke, Catch Draft completion, dual-type draft preference, or Gold draft behavior. Existing protected runtime PASS behavior remains protected.

## 2.4.77 — DOCUMENTATION-ONLY COMPATIBILITY AUDIT CONSOLIDATION

No gameplay feature receives a new runtime PASS in 2.4.77. The completed external-mod audit wave is consolidated in `docs/COMPATIBILITY.md`; all source/static/expected classifications remain below runtime certification. Protected historical PASS entries are unchanged.

## 2.4.76 — DOCUMENTATION-ONLY COMPATIBILITY LEDGER REFRESH

No gameplay feature receives a new runtime PASS in 2.4.76. Recent external-mod audits are recorded in `docs/COMPATIBILITY.md` as source/static/expected-compatibility classifications with explicit runtime-test requirements. Protected historical PASS entries are unchanged.

## 2.4.75 — KANTO REFORGED 1.2.0 CAP INTEROP STATIC PASS
- Source-confirmed KR `level_caps_on` storage and `LevelCaps.capFor(...)` calculation are adapted read-only.
- Simultaneous Nuzlocke + KR caps select the stricter live cap.
- Nuzlocke caps OFF leaves KR solely responsible.
- Runtime TEST REQUIRED for Gen1 and Gold combinations, including cases where Nuzlocke is stricter, KR is stricter, and both are equal.


## 2.4.74 — IPC 1.1.0 STATIC COMPATIBILITY PASS / GOLD RUNTIME TEST REQUIRED
- Indigo Plateau Conference adapter marker updated to 1.1.0.
- Existing priority -1000 post-battle dead-party prune structurally composes after IPC's ordinary survivor-heal listener.
- No new compatibility listener added.
- Runtime Gold combination still required: tournament win, tournament loss with a living survivor, and tournament loss involving a Nuzlocke-marked death.


## 2.4.73 — QUICK START USER RUNTIME PASS RECORDED
- R/B/Y Quick Nuzlocke Start / intro bypass: **USER RUNTIME PASS**.
- Observed caveat: handoff may occur outside before bedroom-PC item pickup; player can walk back inside and collect those items.
- Classified as a recoverable convenience issue, not a progression failure.
- Gold Quick Start remains separately runtime-test-required.


## 2.4.72 — STATIC POLICY CORRECTION PASS
- Restores the protected engine maximum `<2.0.0`.
- No runtime behavior changes relative to 2.4.71.


## 2.4.71 — STATIC COMPATIBILITY PASS / RUNTIME TEST REQUIRED
- Audited against released Gen1Recomp 0.2.0.
- Existing hook/event and storage contracts used by Nuzlocke remain present upstream.
- No gameplay adapter was changed solely for API novelty.
- Runtime smoke tests on Gen1Recomp 0.2.0 are still required for R/B/Y and Gold.


## 2.4.70 — STATIC STRUCTURAL PASS / RUNTIME TEST REQUIRED
- Newer-schema escaped `mod.save:set(...)` attempts are now blocked after being counted; normal supported-schema writes still delegate.
- Direct Randomizer learnset application and Quick Start/default-name shortcut paths now fail closed while the newer-schema safe-stop is active.
- Deferred Starting Balls release and Skip Catch Tutorial are also guarded against newer-schema execution.
- Randomizer integrity recognizes the intentional zero-candidate vanilla fallback.
- Runtime tests required for schema-5+ write blocking, ordinary schema-4 save writes, Quick Start/default-name regression, Random Learnsets, and Randomizer-integrity FALLBACK reporting.


## 2.4.69 — PUBLISHED RELEASE / PRIOR STATIC RC PASS
- No new gameplay behavior relative to 2.4.68 DEV.
- RC packages the sequential development head for broad runtime validation.
- All protected historical runtime-PASS items remain protected expectations, but are not reclassified as freshly runtime-tested by this static RC pass.
- Recent 2.4.62–2.4.68 changes remain runtime-test-required where previously marked.


## 2.4.68 — STATIC STRUCTURAL PASS / RUNTIME TEST REQUIRED
- Randomizer integrity audit is read-only and recursively scans the live encounter registry.
- The legality check composes generation mode, glitch/runtime safety, and canonical Nuzlocke acquisition legality.
- Delegated/opted-out content is excluded from Nuzlocke-owned violation judgments.
- Runtime validation required for inactive, owned-active, delegated, and intentionally constrained Random Encounter configurations.


## 2.4.67 — STATIC STRUCTURAL PASS / RUNTIME TEST REQUIRED
- Rule-effectiveness audit is read-only and reuses canonical config normalization and delegation resolution.
- Applicable rules are generation-filtered; master/schema state is reported separately.
- Runtime validation required with clean ownership and at least one external delegated rule.


## 2.4.66 — STATIC STRUCTURAL PASS / RUNTIME TEST REQUIRED
- `mod.save:set(...)` is transparently observed only for future-schema safe-stop diagnostics; delegated write semantics remain unchanged.
- Any observed write attempt becomes a Dev assertion warning and is exported with per-key evidence.
- Runtime downgrade test target: synthetic/copied schema 5+ save with `safe_stop_writes.attempts == 0` throughout ordinary play/navigation.


## 2.4.65 — STATIC STRUCTURAL PASS / RUNTIME TEST REQUIRED
- Six lifecycle counters are updated only by the existing Dev diagnostic listeners.
- Weak payload identity tracking detects repeated delivery without retaining event payloads indefinitely.
- `duplicate_callbacks > 0` is a self-test warning; `battle_delta` is context only.
- Runtime hot-reload/listener-stacking test still required.


## 2.4.64 — STATIC STRUCTURAL PASS / RUNTIME TEST REQUIRED
- `Dev.hookHealth()` inspects only `package.loaded` modules and therefore does not import/install a subsystem as a side effect of diagnostics.
- 13 generation-aware observable adapters are covered.
- CHAINED is informational; only MISSING contributes to the self-test warning aggregate.
- Runtime validation required in clean R/B/Y, clean Gold, and at least one compatibility stack where another mod wraps above Nuzlocke.


## 2.4.63 — STATIC STRUCTURAL PASS / RUNTIME TEST REQUIRED
- Source review confirms `saveSchemaTooNew` now disables the shared `active(...)` enforcement gate.
- Known lifecycle writers identified in the downgrade audit are explicitly suppressed while the safe stop is active.
- Player warning is session-only and does not write acknowledgement into the newer-schema save.
- Runtime test required with a copied/synthetic save declaring schema 5+; verify no enforcement/repair writes and verify normal schema-4 saves remain unchanged.


## 2.4.62 — STATIC STRUCTURAL PASS / RUNTIME TEST REQUIRED
- Random Encounter species pool now composes with canonical Nuzlocke acquisition legality before balance filtering.
- Static source review confirms persisted slot validation checks membership in the current candidate pool, so newly illegal saved choices cannot remain active; relevant mid-run legality edits also enter the existing randomizer reapply path.
- Static source review confirms an empty pool returns safely from encounter randomization after restoring the encounter snapshot.
- Runtime matrix still required for MONO/DUO/TRI Type Locke, each species ban, Maximum BST, balance modes, rule toggles mid-run, R/B/Y, and Gold.

## 2.4.60 — STATIC PASS / RUNTIME TEST REQUIRED

- Config/Setup and NUZ STATUS runtime crash handlers preserve full `xpcall` tracebacks in Dev diagnostics when enabled.
- Existing deferred recovery/dialog behavior remains unchanged.
- Runtime fault-injection is still required to confirm update/draw failures produce the expected breadcrumb/snapshot labels in R/B/Y and Gold.

## 2.4.59 — STATIC PASS / RUNTIME TEST REQUIRED
- Recursion-safe `Dev.pguard()` exists and preserves guarded-call result tuples.
- Ten selected high-value failure seams feed Dev error breadcrumbs/snapshots when Dev Mode is enabled.
- Provider species-metadata alternate-signature fallback remains intentional and does not warn when fallback succeeds.
- Encounter-ledger contradiction and malformed Shiny-state assertions are read-only.
- Mechanics-capability calculation remains unwrapped to avoid diagnostic recursion.
- 2.4.58 export/history logic is unchanged.
- Runtime test: force a synthetic provider/storage callback throw with Dev Mode ON and verify one bounded error + snapshot appears without a crash or recursive flood.

## 2.4.58 — STATIC PASS / RUNTIME TEST REQUIRED
- Pin-once battle encounter provenance.
- Full 48-breadcrumb export.
- Bounded 16-report history plus latest.
- Bare reload no longer fabricates readback verification.
- Test split-boundary catch/failure, Gold time split, save/reload, >16 exports/history pruning, READ/READBACK display.

## 2.4.57 launcher range + capture ledger — STATIC PASS / RUNTIME TEST REQUIRED
- Manifest accepts `>=0.1.86 <2.0.0`.
- Successful consumed-catch evidence is protected from FAILED downgrade.
- Capture ledger reconciliation runs before projection and save writes.
- Runtime save/reload tests are required on R/B/Y and Gold.

## 2.4.56 documentation integrity — STATIC PASS
- Documentation/metadata-only child of 2.4.55.
- Exact packaged `main.lua` load gate required.
- Auxiliary integrations and package tree unchanged.
- No runtime confidence is promoted by this build.

## Current TEST REQUIRED
- Gen1Recomp 0.2.1 R/B/Y + Gold smoke + Dev storage.
- Gold No Held Items (introduced 2.4.51).
- Historical Difficulty deepening (2.4.52 mechanics / 2.4.53 final profile set).
- Rules navigation (2.4.54–2.4.55).
- Limited Shiny / encounter-slot combinations.
- Encounter Tracker death projection.
- Save Editor/external-save reconciliation.
- Gold shared-rule parity.
- Forgiveness Token ¥1,000,000 settlement.
- Modern UI + Encounter Tracker historical crash regression.
- Gen9Dex/QoL/alternate UI/provider combinations.

## Historical build validity
- 2.4.38: compiler-invalid (>200 locals).
- 2.4.39: inherited compiler-invalid state.
- 2.4.40: repaired loadability.
- Current canonical packaged `main.lua` must pass the exact Lua load gate before handoff.

## Current historical Difficulty profile set
- Red: SHIN HARD*, PURE RGB*
- Blue: SHIN HARD*, BLUE KAIZO*
- Yellow: YELLOW LEGACY*, SHIN-STYLE*
- Gold: POLISHED*, LEGACY-STYLE*

## Backlog governance
Implemented features leave Planned in the same cycle. Live-but-unvalidated work belongs under Implemented / TEST REQUIRED, not Planned.

## 2.5.66 runtime targets
- Silver Setup + boot to bedroom: RUNTIME PASS on 2.5.65.
- Silver NUZ STATUS: 2.5.65 RUNTIME FAIL (launcher crash); 2.5.66 static repair, RETEST REQUIRED.
- Yellow manual Mankey -> Route 1 -> wild recovery assignment: prior guarded FAIL; 2.5.66 maintenance-safe identity/provider fallback, RETEST REQUIRED.
- Yellow R/B/Y F. TOKEN presentation: oversized residual title seen on 2.5.64; 2.5.66 native-font repair, RETEST REQUIRED.


## 2.5.66 runtime evidence carried into 2.5.67

- Yellow save: Encounter Tracker manual reassignment **Mankey → Route 1 → wild** is runtime PASS.
- Silver: NEW GAME Nuzlocke Setup appears and boot to the player's bedroom are runtime PASS.
- Silver: MOD COMPAT opens; ENC TRACKER MAP opens; ENC TRACKER LOG opens; NUZ RULES opens; DEV REPORT opens.
- Silver: NUZ STATUS 2.5.66 is a contained runtime FAIL exposing `normalizeMovementAssistMode` as an out-of-scope nil global. 2.5.67 repairs every stale post-scope callsite; runtime retest required.
- Silver 2.5.66 UI/diagnostics defects: NUZ RULES mislabeled the edition as GOLD BETA and DEV REPORT collapsed Silver to `game gold`. 2.5.67 changes all edition-facing diagnostics/UI to exact game identity.
