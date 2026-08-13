# Changelog

This file is the permanent cumulative development/release history. A known revision is retained even when its exact per-build delta is only partially recoverable; uncertain history is labeled rather than guessed.

## 2.0.0-beta.29.1.0 — Gen1Recomp 0.1.83 compatibility profile

### Goal

Prepare the beta.29.0.2 gameplay candidate for release testing on the current Gen1Recomp 0.1.83 engine without rewriting protected gameplay paths merely because newer public engine surfaces exist.

### Changed

- Built directly from beta.29.0.2 with **no intended gameplay behavior change**.
- Advanced the exact source-audited Gen1Recomp profile from 0.1.81 to 0.1.83 and added explicit 0.1.82/0.1.83 engine-profile records.
- Widened the manifest engine range from `>=0.1.81 <0.1.82` to `>=0.1.81 <0.1.84` so the release candidate can run on Gen1Recomp 0.1.83 for certification.
- Preserved Gen1Recomp Mod API 2, Nuzlocke Compatibility API 25, compatibility floor 10, and Nuzlocke save schema 4.
- Kept the established ENC TRACKER implementation unchanged. Gen1Recomp 0.1.83's additive Gold `mapOverview()` API is recorded for later equivalence evaluation rather than being substituted for a runtime-proven tracker path immediately before release.

### Compatibility audit

- Exact Gen1Recomp v0.1.83 source retains the protected Gen 1 battle constructors and `throwBall`, `askNicknameUI`, `computeDamage`, `onFaint`, `playerMonFainted`, and `finish` seams used by Nuzlocke.
- `Status.residual`, `ItemEffects.use`, `ShopMenu.new`, and the SaveData persistence/slot helpers used by Nuzlocke retain compatible signatures/contracts.
- Gold retains `BattleState:finishBattle`, the blocking `Specials.block` contract, `Vm` `loadwildmon` state, shared `battle.started`/faint/end lifecycle events, and the title-menu hook shape used by Setup.
- The 0.1.82→0.1.83 engine delta is limited to launcher/importer changes plus the additive generation-neutral map-overview surface; it does not replace the protected Nuzlocke battle/item/shop/save wrappers.

### Runtime evidence carried into this build

- On Gen1Recomp 0.1.83, manual import of beta.29.0.2 was recognized with its version/category/game targets.
- The beta.29.0.2 `<0.1.82` manifest gate correctly blocked gameplay on engine 0.1.83.
- Using Update on the unpublished local candidate successfully installed the latest published Nuzlocke release, confirming repository download/install plumbing while also proving unpublished candidates must be imported manually.
- Current Gen1Recomp beta-tag release comparison can show a redundant `v2.0.0 available` notice because its release comparison uses the leading `x.y.z` triple; this is recorded as an engine update-status limitation, not a Nuzlocke gameplay failure.

### Validation / still required

- Exact-source compatibility inspection: **PASS** for the reviewed 0.1.83 seams listed above.
- Local structural release gate: **55/55 PASS**.
- Player and repository candidate ZIP integrity: **PASS**.
- Player distribution exclusion check: **PASS**; repository-only development/testing material is not present in the player ZIP.
- Lua/LuaJIT behavior smoke: **NOT EXECUTED in this workspace** because a compatible runtime executable is not installed.
- Upstream modkit validate/lint/gen2check: **NOT EXECUTED in this workspace** because a complete local Gen1Recomp 0.1.83 source/imported-data tree is not available.
- Required next step: runtime certification of beta.29.1.0 on Gen1Recomp 0.1.83, beginning with Mod Manager Ready status/startup smoke and the beta.29.0.2 four-fix regression matrix.

## 2.0.0-beta.29.0.2 — reviewed acquisition and provenance bug fixes

### Goal

Apply the four pre-runtime code-review decisions with the smallest practical changes, preserving previously established acquisition, battle, save, and compatibility behavior while making the newly touched paths explicit runtime-regression targets.

### Fixed

- Removed write-only First Rival Mercy `armed` / `triggered` save telemetry. The durable first-Rival-seen state and battle-local forgiveness flags remain authoritative; legacy values already present in older saves are harmlessly ignored.
- Added stable-identity history-name synchronization after mandatory scripted starter/gift naming completes on R/B/Y and Gold. Acquisition/tracker registration remains at its established transaction point instead of being moved across naming-screen lifecycle boundaries.
- Gold `givepoke` acquisition detection now snapshots and diffs party plus PC boxes, while still preferring a new party member first. Full-party gifts can therefore reach the same initialization, tracker/history, area-consumption, and Nickname Rule handling as party-delivered gifts.
- `pendingStaticEncounter` is now a single-use next-battle provenance token: every actual battle consumes it before trainer/wild classification, so an intervening trainer battle cannot leave stale static state for a later unrelated wild encounter.

### Protected behavior

- First Rival Mercy remains opening-battle-only and one-time.
- Existing party-delivered Gold starter/gift flow, random starter behavior, pre-mutation gift legality, Gold VM resume behavior, tracker deduplication, and stable Pokémon identity remain in place.
- R/B/Y scripted gift registration timing is unchanged; only the matching stored history name is refreshed after mandatory naming.
- Canonical R/B/Y and Gold static encounters still use the existing provenance/classification system; explicit battle-provided static metadata remains independent of the temporary pending marker.

### Validation

- Local structural release gate: **49/49 PASS**.
- Added behavior-smoke regression cases for Rival Mercy persisted-state cleanup, Gold history nickname synchronization, Gold full-party PC-routed gifts, and intervening-trainer static-provenance invalidation.
- Lua/LuaJIT behavior smoke: **NOT EXECUTED in this workspace** because a compatible runtime executable is not installed.
- Upstream modkit validate/lint/gen2check: **NOT EXECUTED in this workspace** because a complete compatible Gen1Recomp checkout/imported-data tree is not available.
- Targeted in-game runtime matrix remains required before approval.

## 2.0.0-beta.29.0.1 — release-candidate packaging and developer documentation

- Built directly from beta.29.0.0 with no intended gameplay behavior change.
- Reorganized the release around a lean player distribution and a separate repository/tooling layout.
- Added a dedicated `docs/USER_GUIDE.md` exhaustive player manual while refocusing `README.md` as the repository landing page and quick-start guide.
- Expanded the README feature highlights/recent-major-features presentation so the repository front page advertises the collective current ruleset rather than only the current packaging delta.
- Added `mod.card`, `.modkitignore`, structured issue forms, developer API documentation, feature-confidence tracking, and a versioned compatibility guide.
- Updated manifest metadata to identify the maintained repository, use the `BALANCE` category, and target Red/Blue/Yellow/Gold explicitly.
- Removed the legacy generation-wide Gen 2 target from the candidate manifest so Silver/Crystal are not implied.
- Rebuilt the cumulative changelog so every known revision remains represented, including revisions whose exact per-build delta is only partially recoverable.
- Current candidate remains targeted to the audited Gen1Recomp 0.1.81 line; newer engine compatibility is not claimed by this build.

## 2.0.0-beta.29.0.0 — beta.29 development-line baseline

- Created directly from beta.28.20 with no intended gameplay changes.
- Began the beta.29 development line and consolidated the player-facing documentation/package baseline.
- Recorded current runtime evidence for Gold Setup/collapsible sections and Yellow existing-save navigation/collapsible sections.

## 2.0.0-beta.28.20 — temporary-party compatibility hardening

- Built directly from beta.28.19.
- Hardened Permadeath against trainer systems that temporarily narrow/reorder the player party and restore it during battle teardown.
- Whiteout now re-evaluates the restored real post-battle party so healthy reserves prevent a false run-ending Whiteout.
- Restored dead Pokémon are reconciled after temporary-party restoration rather than remaining usable.

## 2.0.0-beta.28.19 — preserved development revision

- This revision is explicitly preserved by the forward source lineage.
- The exact build-specific delta has not been fully recovered from surviving release records. Preserved later history places beta.28.17–28.19 in an aggregate hardening period that included party-menu composition protection, checkpoint/savestate reconciliation of runtime-only observations, and additional wrapper/restoration safeguards before beta.28.20's temporary-party fix.
- Those aggregate changes are deliberately **not** assigned to one specific .17/.18/.19 build without stronger evidence.

## 2.0.0-beta.28.18 — preserved development revision

- This revision is explicitly preserved by the forward source lineage.
- The exact build-specific delta has not been fully recovered from surviving release records. Preserved later history places beta.28.17–28.19 in an aggregate hardening period that included party-menu composition protection, checkpoint/savestate reconciliation of runtime-only observations, and additional wrapper/restoration safeguards before beta.28.20's temporary-party fix.
- Those aggregate changes are deliberately **not** assigned to one specific .17/.18/.19 build without stronger evidence.

## 2.0.0-beta.28.17 — preserved development revision

- This revision is explicitly preserved by the forward source lineage.
- The exact build-specific delta has not been fully recovered from surviving release records. Preserved later history places beta.28.17–28.19 in an aggregate hardening period that included party-menu composition protection, checkpoint/savestate reconciliation of runtime-only observations, and additional wrapper/restoration safeguards before beta.28.20's temporary-party fix.
- Those aggregate changes are deliberately **not** assigned to one specific .17/.18/.19 build without stronger evidence.

## 2.0.0-beta.28.16 — menu-label clarity

- Renamed the in-game mod-menu entries to **ENC TRACKER** and **NUZ RULES**.
- No intentional gameplay behavior change was associated with the label cleanup.

## 2.0.0-beta.28.15 — numeric-rule correctness

- Corrected Maximum BST and the Player/Wild/Trainer Stat EXP selectors being treated as booleans instead of numeric/multi-state rules.
- Retained the lexically scoped Stat EXP/DV implementation used to stay below Lua 5.1 active-local limits.

## 2.0.0-beta.28.14 — compiler/runtime regression repair

- Confirmed that the reported missing Blue SETUP entry and Gold Mod Manager syntax error were one Lua compilation regression: beta.28.11's Stat EXP/DV additions crossed Lua 5.1's 200-active-local limit, so the mod failed before either UI path could register.
- Lexically scoped the Stat EXP/DV implementation behind the existing beta export namespace so the full mod could compile without adding long-lived main-function locals.
- Removed the speculative Gold `save.options`/ManagerState workaround used during diagnosis; it was not the root cause.
- Preserved robust R/B/Y and Gold NEW GAME/CONTINUE recognition.
- Preserved HP semantics when creation-time Stat EXP/DV changes alter maximum HP: full-health starters/gifts remain full, while damaged catches retain their actual battle HP.
- Preserved release-gate evidence from the test package while keeping Gold's new Stat EXP/DV paths runtime TEST REQUIRED.

## 2.0.0-beta.28.13 — compiler/runtime diagnosis iteration

- Preserved development revision in the beta.28 compiler-repair sequence.
- Exact per-build diagnostic changes are only partially recovered; the sequence addressed the active-local compiler failure introduced after beta.28.11.

## 2.0.0-beta.28.12 — compiler/runtime diagnosis iteration

- Preserved development revision in the beta.28 compiler-repair sequence.
- Exact per-build diagnostic changes are only partially recovered; the sequence addressed the active-local compiler failure introduced after beta.28.11.

## 2.0.0-beta.28.11 — Stat EXP and DV rule family

- Added independent Player/Wild/Trainer starting Stat EXP presets: 0%, 25%, 50%, 75%, 100%, and 200%.
- Added No Player Stat EXP Gain while preserving ordinary EXP and levels; battle Stat EXP is blocked before mutation and Stat EXP vitamins are vetoed before consumption.
- Added independent Perfect Player/Wild/Trainer DV controls.
- Covered supported player catches, scripted gifts/starters, in-game trades, compatible receive events, and Gold `givepoke` acquisitions.
- Added a generation-neutral battle-start fallback for Gold wild/trainer Stat EXP/DV application where R/B/Y constructors are not shared.
- Starting Stat EXP is bounded by the engine's 65,535 per-stat storage ceiling; 0% preserves the vanilla newly-created value of zero Stat EXP.
- Creation-time rules were designed not to rewrite existing Pokémon merely because the rules were loaded or enabled.
- The original layout crossed Lua 5.1's 200-active-local limit, leading to the beta.28.12–28.14 repair sequence.

## 2.0.0-beta.28.10 — No Pseudos

- Added the No Pseudos acquisition restriction with supported pseudo-legendary classification.
- Existing owned Pokémon are preserved rather than removed when the rule is enabled.

## 2.0.0-beta.28.9 — 0.1.81 compatibility targeting and local-scope cleanup

- Targeted the Gen1Recomp 0.1.81 compatibility profile.
- Continued removing/restructuring unreachable long-lived locals to keep the large Lua chunk within compiler limits.

## 2.0.0-beta.28.8 — preserved beta.28 development revision

- This revision is explicitly preserved by the forward source lineage.
- Exact per-build attribution is not fully recovered. The beta.28.0–28.9 line collectively expanded Gold support, compatibility/API metadata, starter randomization, default-name setup, Gold catch-demo skipping, B-button running, translation support, and engine/transaction hardening.

## 2.0.0-beta.28.7 — preserved beta.28 development revision

- This revision is explicitly preserved by the forward source lineage.
- Exact per-build attribution is not fully recovered. The beta.28.0–28.9 line collectively expanded Gold support, compatibility/API metadata, starter randomization, default-name setup, Gold catch-demo skipping, B-button running, translation support, and engine/transaction hardening.

## 2.0.0-beta.28.6 — preserved beta.28 development revision

- This revision is explicitly preserved by the forward source lineage.
- Exact per-build attribution is not fully recovered. The beta.28.0–28.9 line collectively expanded Gold support, compatibility/API metadata, starter randomization, default-name setup, Gold catch-demo skipping, B-button running, translation support, and engine/transaction hardening.

## 2.0.0-beta.28.5 — preserved beta.28 development revision

- This revision is explicitly preserved by the forward source lineage.
- Exact per-build attribution is not fully recovered. The beta.28.0–28.9 line collectively expanded Gold support, compatibility/API metadata, starter randomization, default-name setup, Gold catch-demo skipping, B-button running, translation support, and engine/transaction hardening.

## 2.0.0-beta.28.4 — preserved beta.28 development revision

- This revision is explicitly preserved by the forward source lineage.
- Exact per-build attribution is not fully recovered. The beta.28.0–28.9 line collectively expanded Gold support, compatibility/API metadata, starter randomization, default-name setup, Gold catch-demo skipping, B-button running, translation support, and engine/transaction hardening.

## 2.0.0-beta.28.3 — preserved beta.28 development revision

- This revision is explicitly preserved by the forward source lineage.
- Exact per-build attribution is not fully recovered. The beta.28.0–28.9 line collectively expanded Gold support, compatibility/API metadata, starter randomization, default-name setup, Gold catch-demo skipping, B-button running, translation support, and engine/transaction hardening.

## 2.0.0-beta.28.2 — preserved beta.28 development revision

- This revision is explicitly preserved by the forward source lineage.
- Exact per-build attribution is not fully recovered. The beta.28.0–28.9 line collectively expanded Gold support, compatibility/API metadata, starter randomization, default-name setup, Gold catch-demo skipping, B-button running, translation support, and engine/transaction hardening.

## 2.0.0-beta.28.1 — preserved beta.28 development revision

- This revision is explicitly preserved by the forward source lineage.
- Exact per-build attribution is not fully recovered. The beta.28.0–28.9 line collectively expanded Gold support, compatibility/API metadata, starter randomization, default-name setup, Gold catch-demo skipping, B-button running, translation support, and engine/transaction hardening.

## 2.0.0-beta.28 — beta.28 development-line start

- Started the beta.28 development line directly after beta.27.16.
- The early beta.28 sequence collectively expanded Gold integration, compatibility reporting, setup/QoL features, and engine-version hardening; some exact per-build allocation remains partially reconstructed.

## 2.0.0-beta.27.16 — final beta.27 reported-bug hardening

- Hardened Gold Game Corner `Specials.HANDLERS`/`Specials.ALL` capture and restoration independently, without manufacturing a handler where vanilla or another mod left a registry entry absent.
- Restored/exposed the Gold Nickname Rule and required non-empty nicknames for supported catches and scripted gifts.
- Used Gold's VM-blocking rename seam for supported `givepoke` acquisitions so story-command continuation resumes at the exact native point.
- Broadened the Gold Ball gate to accept explicit static/fixed provenance as well as the native `battle.wild` shape for compatible fixed encounters.
- Clarified Ball Use tier 4 as `STANDARD` and tier 5 as `ALL`; the change corrected presentation while preserving the already-distinct cumulative mechanics.
- Preserved the generation-specific R/B/Y versus Gold Game Corner map IDs after review showed they were intentionally different, not a typo.
- The preserved beta.27.16 package recorded an expanded **66-check structural/engine gate** and **49-check headless interaction smoke suite**.

## 2.0.0-beta.27.15 — repository and release-candidate hardening

- Fixed Gold boss progression to recognize Gen 2 trainer-battle shapes rather than requiring Gen 1's `battle.kind == "trainer"`.
- Seeded existing R/B/Y Elite Four/Champion completion and Gold Johto/Kanto Gym/League progression from supported story/badge state.
- Corrected the Johto middle-Gym order to Chuck → Pryce → Jasmine while retaining live ace-level lookup.
- Prevented level-cap regression when an earlier defeated boss becomes stronger than the next boss through trainer overhaul mods.
- Added safe fallback for unknown/future Gen 1 version identifiers and normalized malformed fractional level-cap scope values.
- Invalidated dynamic `trainer.party` observations when the active mod set changes.
- Corrected the compatibility report to match exported Nuzlocke Compatibility API v22 and ensured every advertised capability had an explicit default relationship.
- Expanded provider method/result aliases, Gold World Building queue compatibility, and title-menu save/new-game detection while preventing duplicate Setup insertion.
- Added the first preserved dependency-free Node release gate and headless Lua smoke harness for this line.

## 2.0.0-beta.27.14 — live boss-cap compatibility

- Centralized authoritative next-cap calculation across enforcement and status UI.
- Read merged trainer rosters and observed composed trainer-party results so runtime trainer-level edits can feed cap calculation.
- Added public `getNextLevelCapInfo` compatibility output.

## 2.0.0-beta.27.13 — encounter-area splits

- Added OFF/CARDINAL splitting for Routes 1–25.
- Added OFF/COMMON Mt. Moon floor splitting and Safari Zone area splitting.
- Added physical-map provenance and reversible projection across tracker/history/catch-state views.

## 2.0.0-beta.27.12 — preserved beta.27 rule/interaction revision

- This revision is explicitly preserved by the forward source lineage.
- Exact per-build attribution is not fully recovered. The beta.27.6–27.12 sequence collectively covered World Building cleanup, Maximum BST, glitch/MissingNo handling, opening Rival mercy, static-encounter policy, Game Corner restrictions, and broader compatibility/Save Editor/item/acquisition/Gold audits.

## 2.0.0-beta.27.11 — preserved beta.27 rule/interaction revision

- This revision is explicitly preserved by the forward source lineage.
- Exact per-build attribution is not fully recovered. The beta.27.6–27.12 sequence collectively covered World Building cleanup, Maximum BST, glitch/MissingNo handling, opening Rival mercy, static-encounter policy, Game Corner restrictions, and broader compatibility/Save Editor/item/acquisition/Gold audits.

## 2.0.0-beta.27.10 — preserved beta.27 rule/interaction revision

- This revision is explicitly preserved by the forward source lineage.
- Exact per-build attribution is not fully recovered. The beta.27.6–27.12 sequence collectively covered World Building cleanup, Maximum BST, glitch/MissingNo handling, opening Rival mercy, static-encounter policy, Game Corner restrictions, and broader compatibility/Save Editor/item/acquisition/Gold audits.

## 2.0.0-beta.27.9 — preserved beta.27 rule/interaction revision

- This revision is explicitly preserved by the forward source lineage.
- Exact per-build attribution is not fully recovered. The beta.27.6–27.12 sequence collectively covered World Building cleanup, Maximum BST, glitch/MissingNo handling, opening Rival mercy, static-encounter policy, Game Corner restrictions, and broader compatibility/Save Editor/item/acquisition/Gold audits.

## 2.0.0-beta.27.8 — preserved beta.27 rule/interaction revision

- This revision is explicitly preserved by the forward source lineage.
- Exact per-build attribution is not fully recovered. The beta.27.6–27.12 sequence collectively covered World Building cleanup, Maximum BST, glitch/MissingNo handling, opening Rival mercy, static-encounter policy, Game Corner restrictions, and broader compatibility/Save Editor/item/acquisition/Gold audits.

## 2.0.0-beta.27.7 — preserved beta.27 rule/interaction revision

- This revision is explicitly preserved by the forward source lineage.
- Exact per-build attribution is not fully recovered. The beta.27.6–27.12 sequence collectively covered World Building cleanup, Maximum BST, glitch/MissingNo handling, opening Rival mercy, static-encounter policy, Game Corner restrictions, and broader compatibility/Save Editor/item/acquisition/Gold audits.

## 2.0.0-beta.27.6 — preserved beta.27 rule/interaction revision

- This revision is explicitly preserved by the forward source lineage.
- Exact per-build attribution is not fully recovered. The beta.27.6–27.12 sequence collectively covered World Building cleanup, Maximum BST, glitch/MissingNo handling, opening Rival mercy, static-encounter policy, Game Corner restrictions, and broader compatibility/Save Editor/item/acquisition/Gold audits.

## 2.0.0-beta.27.5 — Gold compatibility-surface refinement

- Added Gen2Compat coverage/member inspection for compatibility reporting.
- Stopped trying to replace Gold's already multi-page Trainer Card for Nuzlocke status; Gold status moved to its own Start-menu screen path.

## 2.0.0-beta.27.4 — Save Editor and compatibility-layer hardening

- Detected Gen1Recomp's embedded Save Editor loader session and avoided installing gameplay-bound runtime monkey patches there.
- Separated engine-version compatibility metadata from inter-mod compatibility relationships.

## 2.0.0-beta.27.3 — shared-seam compatibility negotiation

- Expanded advertised compatibility capabilities to shared engine/UI surfaces such as item use, shops, battle finish, Trainer Card, party/start menus, screens, static encounters, trainer parties, and boss caps.

## 2.0.0-beta.27.2 — preserved beta.27 development revision

- This revision is explicitly preserved by the forward source lineage.
- The exact build-specific delta has not yet been recovered from surviving records; no history is inferred beyond its confirmed place in the sequence.

## 2.0.0-beta.27.1 — preserved beta.27 development revision

- This revision is explicitly preserved by the forward source lineage.
- The exact build-specific delta has not yet been recovered from surviving records; no history is inferred beyond its confirmed place in the sequence.

## 2.0.0-beta.27 — promoted public baseline

- Promoted directly from the runtime-tested beta.26.6 line without an intentional gameplay change during promotion.
- Gold fresh startup/New Game, RULES, TRACKER, Catch Info, and Cyndaquil starter acquisition had runtime PASS evidence at promotion.
- Yellow RULES/TRACKER/catch behavior and prior 1st Catch toggle behavior carried runtime PASS evidence.
- Save schema remained 4.

## 2.0.0-beta.26.6 — Gold gift enforcement and Whiteout consequence

- Ran supported Gold `givepoke` gift legality checks before story/party mutation while preserving mandatory starter handling.
- Added the Gen 2 `finishBattle` consumer for the Nuzlocke Whiteout path while leaving Whiteout OFF on the native path.
- Gold ordinary gift denial and destructive Whiteout still required dedicated runtime confirmation at this revision.

## 2.0.0-beta.26.5 — acquisition and Whiteout correctness

- Corrected fallback gift/trade acquisition classification and generation-gated R/B/Y starting resources.
- Reworked Whiteout teardown to preserve the engine's wrapped finish chain instead of duplicating public teardown operations.

## 2.0.0-beta.26.4 — Tracker clarity and progression-aware TV

- Replaced cryptic failed-encounter labels with `FAILED <species>` and renamed the Tracker result column for clarity.
- Added failed-result marquee presentation and progression-aware Tier 3 home-TV run recaps.
- Preserved runtime evidence for Yellow UI controls, failed encounters, next-cap display, and fresh No Buying/No Selling.

## 2.0.0-beta.26.3 — early-game dialogue and TV polish

- Clarified Pokédex activation messaging and added adaptive Tier 3 home-TV flavor.
- Preserved runtime evidence for Yellow Setup/bedroom startup, starter Catch Info, No Mom Heal, PokéCenter behavior, and opening-rival flavor timing.

## 2.0.0-beta.26.2 — Gym Guide alignment and runtime-evidence rollup

- Re-centered the R/B/Y Gym Guide Rare Candy quantity screen without changing service mechanics.
- Recorded runtime PASS evidence for existing Red/Blue No Buying/No Selling, Red Gym Guide service, Blue No Field Heal, and nickname-aware catch flavor.

## 2.0.0-beta.26.1 — dialogue and starter-metadata polish

- Improved No Mom Heal dialogue ownership, starting-Ball wording, early R/B/Y starter Catch Info canonicalization, and Nuzlocke battle-message wrapping/paging.

## 2.0.0-beta.26 — runtime-tested canonical baseline

- Promoted the runtime-tested 26B10 development revision and retired the prior lettered internal-revision convention.
- Carried the published 25D4-RBY2 title/startup repair, Soft Start, Pokédex handoff, starting resources, two-view R/B/Y Trainer Card, Gold beta Setup, nickname handling, and first-rival timing.
- Save schema remained 4.

## 26B10 — runtime-tested beta.26 promotion candidate

- Known internal development revision directly descended from the published 25D4-RBY2 startup/menu hotfix and promoted forward as `2.0.0-beta.26`.
- This era accumulated runtime-driven verification/fixes around Gold Setup, PP-item restrictions, Pokémon Center restrictions, No Buying/No Selling, Gym Guide behavior, Repels, X Items, startup/menu lifecycle, and related compatibility paths.
- Exact per-change attribution inside the B-series is incomplete, so only the confirmed `26B10` promotion point is given its own heading.
- Its runtime PASS evidence became protected baseline evidence for later beta.26/27 development.

## 2.0.0-beta.25 — 25D4-RBY2 — R/B/Y startup/menu hotfix

- Runtime-confirmed Blue and Yellow title SETUP plus Oak-intro-to-bedroom startup.
- Runtime-reconfirmed Gold Setup/New Game and smoke-tested an existing Red save.
- Restored the proven title Setup injection and removed an unsafe optional post-intro screen push that caused a white screen.

## 2.0.0-beta.25 — 25D2 — Gym Guide handoff diagnostic

- The Gym Guide Rare Candy offer/registration path was functioning, but runtime testing still failed at the quantity-screen handoff.
- The failure was isolated to selector lifecycle/continuation rather than the long-lived direct-row Gym Guide composition or candy policy.

## 2.0.0-beta.25 — 25D3 — Gym Guide selector lifecycle repair

- Changed only the failing quantity-screen lifecycle to use Gen1Recomp's current blocking `push_screen` script-command behavior.
- Preserved NPC registration, vanilla dialogue composition, quantity choices, and candy-grant policy.
- Runtime testing reported the 1/10/25/50/99 selector working after this repair.

## 2.0.0-beta.25 — 25D4 — item-rule and Gym Guide stabilization

- Runtime-confirmed No Repels and No X Items and retained established passes for No Escape, healing/field restrictions, nickname, Center, shops, and Gym Guide quantity selection.
- Hardened item recognition, PP-item coverage, acquisition/recovery paths, and Whiteout teardown while preserving save schema 4.

## 2.0.0-beta.24 — Gold Setup experiment

- Attempted Gold automatic New Game Setup through an intro hook; runtime evidence showed the attempt remained vanilla, leading to the later title-menu design.

## 2.0.0-beta.23 — early Gold status and provenance work

- Added experimental Gold Trainer Card status integration and Gen 2 Egg/Day Care/roaming provenance support.
- Generation-gated the R/B/Y Gym Guide integration.

## 2.0.0-beta.22 — conflicting surviving records

- A directly surviving committed beta.22 source identifies itself as **"static integrity + version/persistence hardening"**, carries save schema 4 and Nuzlocke Compatibility API v7, and does not contain the later Gold/Gen2 adapter markers visible in beta.25-era source.
- A later reconstructed beta.25 changelog attributes generation-native Gold capture, permadeath, nickname, Mart, starter/gift, area-tracking adapters, and Gen 1 + Gold manifest targeting to a beta.22 stage.
- Because these records conflict, the current history preserves both facts without pretending they describe the same exact code snapshot. The Gold adapter work was present by the later beta.23–25 line, but its precise first beta.22 build/revision is unresolved.

## 2.0.0-beta.21 — Gold/GSC architecture groundwork

- Added version-profile architecture and experimental Gold targeting groundwork.
- Expanded progression architecture through Red/postgame-provider concepts and the R/B/Y Trainer Card active-rule display.

## 2.0.0-beta.20 — compatibility and regression hardening

- Built as a surgical update from beta.19 rather than a branch replacement.
- Centralized item/capture/shop policy exports, improved provider surfaces, persistent identity/recovery, Trainer Card/Catch Info, and Gym Guide behavior while preserving save schema 4.

## 2.0.0-beta.19 — protected reconciliation baseline

- Served as the protected baseline for the beta.20 surgical update line.
- Complete per-change details are not fully recovered in the current archive; this entry is retained rather than replaced with inferred history.

## 2.0.0-beta.16 — reconstructed from surviving source/release records

- Fixed Setup-menu helper scoping/order behavior and retained the established Gym Guide architecture.

## 2.0.0-beta.15 — surviving source with conflicting later reconstruction

- The directly surviving committed beta.15 source identifies itself as **"Menu crash fix"**, carries **save schema 2**, and exports **Nuzlocke Compatibility API v6**.
- A later reconstructed beta.25 changelog instead attributes a Gen1Recomp 0.1.77 compatibility pass and the move to save schema 3 to beta.15.
- The conflict is retained explicitly. Current evidence does not safely identify which later beta.15/internal revision first carried schema 3, so the changelog no longer states that transition as certain.
- Wonderlocke remained disabled/dormant through the surviving records.

## 2.0.0-beta.14 — reconstructed save-schema revision

- Surviving history shows the future-safe migration framework at **save schema 2** by this snapshot.
- Continued tracker/recovery hardening while keeping unfinished Wonderlocke behavior non-active.

## 2.0.0-beta.12 — first surviving versioned save-schema baseline

- Added the first surviving future-safe persistent save-schema baseline at **schema 1**.
- Used an idempotent marker-only migration so older/vanilla saves could establish a versioned migration boundary without rewriting unrelated gameplay data.
- Preserved the established beta.8-era Gym Guide direct-row composition/selector and the existing Setup, provenance/recovery, level-cap, Tracker/Catch Info, and Trainer Card systems.

## 2.0.0-beta.11 — surviving development snapshot

- Improved catch-location recovery for human-readable saved locations.
- Changed the Rare Candy selector cursor presentation to the native theme cursor without changing selector lifecycle.
- Only source-supported history is retained; broader exact delta is not inferred.

## 2.0.0-beta.10 — surviving development snapshot

- Added native cursor/scroll presentation work and Trainer Card refinements.
- Continued the established Gym Guide direct-row + dedicated-selector behavior and dormant Wonderlocke-era infrastructure.
- Only source-supported history is retained; broader exact delta is not inferred.

## 2.0.0-beta.8 — surviving development snapshot

- Experimental provider/Wonderlocke-era infrastructure was present by this revision.
- The Gym Guide direct-row composition architecture that survived into later releases was already established by this period.

## 2.0.0-beta.5 — surviving legacy-reconciliation snapshot

- Added legacy catch-location reconciliation/recovery work.
- Gym Guide behavior remained on the earlier implementation of that period.
- Only source-supported history is retained; broader exact delta is not inferred.

## 2.0.0-beta.4 — World Building introduction

- Added World Building tiers and associated optional flavor/mechanic messaging.
- Added level-cap-aware Gym Guide feedback before the Rare Candy selector.

## 2.0.0-beta.3 — surviving logic-audit snapshot

- Added/expanded provenance-aware catch recovery and compatibility work by this surviving snapshot.
- The Gym Guide Rare Candy feature was already present with its dedicated **1 / 10 / 25 / 50 / 99** quantity selector.
- Only source-supported history is retained; broader exact delta is not inferred.

## 2.0.0-beta.1 — surviving Whiteout-fix snapshot

- A surviving source snapshot identifies this revision as an early Whiteout-fix stage.
- Only source-supported history is retained; broader exact delta is not inferred.
