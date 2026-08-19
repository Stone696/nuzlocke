# Nuzlocke 2.5.23-DEV

Strict child of 2.5.22-DEV.

2.5.23 is a focused Yellow/fresh-New-Game correctness and process-hardening build driven by exact 2.5.22 runtime failures. It repairs Random Starter's out-of-scope helper reference, restores the R/B/Y command-wrapper tail that owns No Mom Heal and starter `give_pokemon` provenance, and executes the late-runtime phase that owns Yellow's Oak Pallet catch-demo skip and the authoritative script-command heal fallback.

Fresh `save.created` now revalidates the critical R/B/Y wrappers, a conservative opening-starter repair can recover unambiguous UNKNOWN/Oak-Lab starter provenance into Pallet Town, and DEV SELF TEST exposes the relevant setting/gate health directly.

Development gates now include structural and mutation ratchets for lexical-scope ownership, staged-phase execution, installer-tail placement, and fresh-New-Game lifecycle coverage. This addresses the process failure that allowed syntactically valid Lua to pass static checks while resolving intended locals as nil globals at runtime.

No gameplay-rule default, Save Schema, Compatibility API, Diagnostics API, Mod API, or engine-range change. Exact Yellow runtime regression testing is required.

# Nuzlocke 2.5.22-DEV

Strict child of 2.5.21-DEV.

2.5.22 lifecycle-hardens the Gen 1 kerning adapter so a persistent `Font` module cannot silently keep a stale pre-reload Nuzlocke closure as if it belonged to the current session. Exact stale Nuzlocke wrappers are safely unwrapped/rebound; ambiguous legacy or foreign wrapper chains fail closed and require a fresh process.

Starter randomization now shares the same algorithm-version-aware seeded hash path used by encounter and learnset randomization. RNG algorithm v1 produces the same starter hash input as before, so current deterministic results do not change, while future algorithm-version bumps stay synchronized across all three randomizer systems. Live RNG version labels now derive from that same source.

No gameplay-rule default, Save Schema, Compatibility API, Diagnostics API, Mod API, or engine-range change. Runtime regression testing remains required.

# Nuzlocke 2.5.21-DEV

Strict child of 2.5.20-DEV.

2.5.21 removes trainer-identity drift between Gym reward recognition and League progression bookkeeping. Both paths now share one normalized ID/class/name extractor that understands R/B/Y `oppClass`, generic compatibility aliases, and Gold trainer `classId` / `class`. Gym, Elite Four, Champion, and Gold stage progression can therefore consume the same identity evidence as reward matching instead of maintaining an id/name-only sibling path.

No gameplay-rule default, Save Schema, Compatibility API, Diagnostics API, Mod API, or engine-range change. Runtime regression testing remains required.

# Nuzlocke 2.5.20-DEV

Strict child of 2.5.19-DEV.

## Tracking / enforcement safety
2.5.20 makes battle-finalization policy explicit. Supported saves continue to record boss progression while the Nuzlocke master switch is OFF, so toggling the challenge off does not make the mod forget legitimate game progress. Challenge-only consequences remain disabled while Nuzlocke is OFF, and unsupported newer-schema saves remain fully read-only to Nuzlocke-owned persistence.

Failed Encounter, Forgiveness Tokens, trainer-money rewriting, and post-battle Permadeath cleanup now use the rule-enforcement policy; league progression uses the passive-progress/write-safety policy. Local development invariants classify these writers so future changes are checked against the intended policy rather than a one-size-fits-all `active()` rule. No Save Schema, Compatibility API, Diagnostics API, Mod API, or engine-range change.

# Nuzlocke 2.5.19-DEV

Strict child of 2.5.18-DEV.

## Save-safety / API hardening
2.5.19 makes the newer-schema safe-stop genuinely read-only across randomized-starter repair and Pokémon identity paths, makes compatibility engine reporting both fresh and defensive, expands Schema-4 migration-bookkeeping descriptors, lifecycle-hardens the final save-write barrier, and suppresses known Permanent Rule Seal repair writes while safe-stopped. No gameplay-rule contract, Save Schema, Compatibility API, Diagnostics API, Mod API, or engine range changes. Runtime regression testing remains required.

# Nuzlocke 2.5.18-DEV

Strict child of 2.5.17-DEV.

## API/descriptor hardening
2.5.18 prevents Compatibility API metadata and DEV SELF TEST reports from exposing mutable aliases to Nuzlocke's internal compatibility tables. Dynamic compatibility snapshots refresh after provider discovery, and `getEffectiveRuleValue()` now uses canonical defaults when the caller supplies no fallback.

Rule Registry collisions are now recorded and surfaced by its audit; the Save Schema 4 descriptor documents active compatibility mirrors and migration-only legacy inputs. Local invariant tooling is tightened to validate the current API documentation/defensive-copy contracts and to detect authoritative boolean-only wrapper guards rather than counting harmless historical markers. Save Schema 4, Compatibility API 28, Diagnostics API 1, Mod API 2, and the engine range remain unchanged. Runtime regression testing is still required.

# Nuzlocke 2.5.17-DEV

Strict child of 2.5.16-DEV.

## Development-quality infrastructure
2.5.17 adds machine-readable lineage/provenance, a derived Rule Registry, a Save Schema 4 configuration descriptor, centralized owner-aware direct-wrapper installation, and stronger Dev SELF TEST assertions. No gameplay rule/default/loadout/encounter behavior intentionally changes from 2.5.16.

Compatibility API advances from **27 to 28** because `capability_versions` and `getCapabilityVersion(capability)` are a new public consumer-visible capability-negotiation surface. Existing API-27 capability names/meanings remain compatible, `compatible_from` remains 10, and every current capability begins at contract version 1. Save Schema remains 4, Diagnostics API remains 1, Mod API remains 2, and the engine range remains `>=0.1.86 <2.0.0`.

Repository CI/invariant files are development-only and are not included in the canonical 15-file player ZIP. Runtime priority is DEV TOOLS -> SELF TEST plus a short gameplay regression smoke against 2.5.16 behavior.

# Nuzlocke 2.5.16-DEV

Strict child of 2.5.15-DEV.

## 2.5.16 API/default/lifecycle diagnostics pass
2.5.16 repairs consistency at the compatibility boundary rather than changing any rule contract. `ruleActive()` now uses each rule's canonical missing-value default, `locke_type` readers use the same canonical NUZLOCKE fallback, and explicit saved choices are untouched.

Wrapper ownership is tightened for automatic names, Gold nickname/Mart/gambling enforcement, R/B/Y Permadeath, QoL Toggles AUTO-REPEL, and Wilds of Kanto. Wilds' pre-catch legality and post-catch tracking functions are now validated as a pair before the adapter is considered healthy. Dev Mode reports many more critical wrapper seams so a stale or replaced binding can be identified without discovering it only through gameplay.

Save Schema 4, Compatibility API 27, Diagnostics API 1, Mod API 2, and the `>=0.1.86 <2.0.0` engine range are unchanged. Runtime confirmation is required.

## 2.5.15 reliability / lifecycle hardening pass
2.5.15 closes four remaining source-level reliability gaps. Field-poison wipes now honor Whiteout independently of Permadeath in R/B/Y and Gold, while preserving the engine's poison-faint/blackout presentation and replacing only the final heal/warp continuation with the Nuzlocke run-ending save-delete/title flow. Gold No Escape now uses the generation-neutral live game instead of relying on `battle.game`, which Gold's pure battle model does not carry.

The new-game snapshot now writes `locke_type` explicitly before verifying the staged profile, so the chosen loadout cannot remain stale when the underlying rules were committed successfully. Party Size/PC withdrawal, Gold No Day Care, Gold Whiteout finish, Gold Headbutt tracking, and forgiveness-token mart-stock wrappers now use owner-aware lifecycle records so a new ModLoader session does not silently keep a closure over an obsolete mod/save object.

Save Schema 4, Compatibility API 27, Diagnostics API 1, Mod API 2, and the `>=0.1.86 <2.0.0` engine range are unchanged. Runtime confirmation is required.

## 2.5.14 bug-fixing / lifecycle hardening pass
2.5.14 fixes three high-confidence defects found in the 2.5.12/2.5.13 source audit. The R/B/Y scripted starter/gift wrapper now binds its transaction save before using save-backed map context, so Pallet/Oak/Lab starter detection no longer depends on an unintended outer/global `save`. Core missing-key enforcement for One Per Area, Nickname Rule, Dupes Clause, Allow Gifts, and Allow Trades now uses the same canonical defaults shown by Setup/NUZ RULES; explicit persisted choices are unchanged. The Gold Pokégear World Building fallback is also sourced from that canonical default.

Critical direct wrappers that previously trusted historical boolean markers now carry owner/previous/wrapper session records: R/B/Y catch enforcement/finalization/nickname UI, the R/B/Y Permadeath/Whiteout bundle, and Gold capture useItem. This is lifecycle hardening only; the underlying catch, nickname, death, Whiteout, and Ball Per Enc. rules are unchanged. Runtime confirmation should include at least one legal/blocked catch and one player faint in R/B/Y, a Gold Ball use/catch, and an R/B/Y randomized starter with Nickname Rule.

The Gen1Recomp 0.2.7 TimeFishGroups concern was reviewed but not changed. The engine intentionally gives row-local day/night fishing slots precedence over the shared fallback table, so forcibly mirroring them would be less compatible with registry patches.

No save schema, compatibility API, diagnostics API, Mod API, or engine-range bump is introduced.

# Nuzlocke 2.5.13-DEV

Strict child of 2.5.12-DEV.

## Field-poison Permadeath repair
Gen1Recomp handles overworld poison outside `BattleState:onFaint` / `battle.fainted`. 2.5.13 adds narrow generation-specific observers at those native field-poison seams so a Pokémon that actually reaches 0 HP from overworld poison is entered into Nuzlocke's existing death history and removed from the live party before later native blackout healing can restore it.

R/B/Y keeps `OverworldState:applyFieldPoison` as the owner of HP loss, poison presentation, and blackout scheduling. Gold keeps `World:poisonFaintScript` as the owner of poison-faint happiness, text ordering, and whiteout scheduling. Nuzlocke records/prunes only after those native handlers have done their immediate work. Nuzlocke OFF and Permadeath OFF do not add any field-poison mutation. No save/API/engine-range bump is introduced. Runtime confirmation is required.


## Gen1Recomp 0.2.7 compatibility completion
A fresh published-release audit found one concrete Gold compatibility defect in Nuzlocke's public encounter-registry facade. Gen1Recomp routes the shared `encounters` registry to `game.data.gen2Encounters` on Gold, while Nuzlocke's public effective/final registry helper and `Registry.describe()` still returned only the Gen 1 `game.data.encounters` table. Gameplay encounter randomization already used the correct Gold registry; the defect affected cooperative encounter-information/provider consumers.

2.5.12 makes the public facade resolve the generation's final live table (`gen2Encounters` on Gold, `encounters` on R/B/Y). The 0.2.7 profile/docs now explicitly cover the release's Gold `TimeFishGroups` / day-night fishing schema. No randomizer tables are regenerated, no save migration is added, and reveal/selection policy semantics are unchanged. Engine range remains `>=0.1.86 <2.0.0`; Mod API 2, Save Schema 4, Compatibility API 27, and Diagnostics API 1 are unchanged. Runtime confirmation on Gold/0.2.7 is required.

# Nuzlocke 2.5.11-DEV

Strict child of 2.5.10-DEV.

## World Building default consistency repair
2.5.11 completes the earlier World Building default change from T3 to T1. Fresh/setup defaults were already T1, but the live flavor resolver could still fall back to T3 when the key was absent and the in-game description still recommended T3.

The live resolver and configuration-value fallback now use the canonical T1 default source, and the description identifies **TIER 1** as the default. Explicit saved OFF/T1/T2/T3 selections are not rewritten. No Save Schema, Compatibility API, Diagnostics API, Mod API, engine range, or rule-enforcement semantics changed. Runtime confirmation is still required.

# Nuzlocke 2.5.10-DEV

Strict child of 2.5.9-DEV.

## Pokégear RULES and tracker empty-state repair
2.5.10 fixes two isolated presentation defects found during source review:
- Gold Pokégear NUZ RULES now advances by real four-row pages, so a partial last page (for example rules 5-6 of 6 or rule 9 of 9) is reachable instead of wrapping early. The RULES header shows the current inner page and the footer advertises A:MORE when overflow exists.
- ENC TRACKER now explicitly displays `NO ENTRIES YET` when the selected data set is empty on native R/B/Y, native Gold, and the Modern UI model. The Modern UI placeholder does not increase the real entry count or participate in selected-row metadata.

No gameplay enforcement, encounter state, save schema, compatibility/provider contract, engine range, or Gold battle semantics changed. Runtime confirmation is required for both presentation repairs.

# Nuzlocke 2.5.9-DEV

Strict child of 2.5.8-DEV.

## Yellow setup/runtime follow-up
Yellow 2.5.8 runtime testing produced two PASSes and one blocker: fresh Shiny Clause now starts at OFF/0, Type Locke menu editing no longer throws the previous NUZ RULES error, but saving the NEW GAME setup failed with an attempt to index the out-of-scope global `TYPE_LOCK_SLOT_INDEX`.

2.5.9 makes a narrow follow-up:
- routes setup/profile Type Locke slot checks through the lifecycle-stable exported slot-index accessor instead of an inaccessible lexical table;
- repairs the related Gold status-summary reference to the Type Locke slot-key table;
- makes the loadout warning scrollable with UP/DOWN so every changed loadout-owned rule can be reviewed before APPLY/CANCEL;
- converts Nuzlocke-owned setup/rules/status error dialogs to explicit manual A/B pages so diagnostic text cannot auto-scroll away;
- orders GAME DIFFICULTY then BATTLE MECHANICS immediately above AREA SPLITS.

A Gen1Recomp 0.2.7 source audit found no Gold First Rival Mercy code change is warranted: the Cherrygrove rival battle uses BATTLETYPE_CANLOSE, deliberately leaves the loser at 0 HP while its script continues, and heals later in that script. Nuzlocke therefore continues to skip death/Whiteout bookkeeping without forcing a temporary 1 HP in Gold.

No Save Schema, Compatibility API, Diagnostics API, Mod API, engine range, loadout ownership rules, or Gold battle outcome semantics changed. The setup-save repair and revised loadout/error UI remain runtime TEST REQUIRED.

# Nuzlocke 2.5.8-DEV

Strict child of 2.5.7-DEV.

## Yellow rules/setup runtime follow-up
Yellow 2.5.7 testing found the loadout confirmation still rendered unreadably on the native R/B/Y surface and Type Locke changes could still raise the generic NUZ RULES “Please report this text” error.

2.5.8 makes a narrow repair:
- keeps the R/B/Y loadout warning on a full native 160x144 surface and constrains each preview row to a 16-glyph-safe line;
- shows the destination value first and marquees long rule names rather than letting preview text cross the frame;
- routes Type Locke configuration edits and random-selection normalization through lifecycle-stable slot/default accessors;
- changes the fresh/new-profile Shiny Clause default to **OFF / 0**, while preserving explicit existing-save/profile values and historical boolean migration;
- moves **Route Forgiveness** from CLAUSES to **GENERAL** without changing token mechanics.

No Save Schema, Compatibility API, Mod API, engine range, starter/opening sequence logic, or NZR4 format changed. Runtime confirmation is required for the Type Locke edit path and the revised loadout-warning presentation.

# Nuzlocke 2.5.7-DEV

Strict child of 2.5.6-DEV.

## Dev Report readability repair
Blue 2.5.6 runtime testing cleared the saved-report **DEV TOOLS -> VIEW REPORT** crash across a full game restart, but exposed a separate presentation failure: report text, the NZR4 code, playthrough IDs, and Storage Info identifiers could extend beyond the native R/B/Y viewport.

2.5.7 makes a narrow diagnostic-UI repair:
- uses a 16-character-safe content width on R/B/Y Dev Report and Storage Info pages;
- hard-wraps long unbroken diagnostic tokens instead of relying on the normal word-only wrapper;
- renders `report_code=NZR4-...` as a dedicated **REPORT CODE:** block and preserves the existing hyphen groups while splitting them into viewport-safe lines;
- keeps the 2.5.6 forward-declared report helper/crash repair intact.

No Report Code bits, fingerprints, decoder behavior, gameplay rules, save schema, compatibility API, Mod API, or engine range changed. Runtime confirmation should verify that every NZR4 character and long Storage Info identifier stays on-screen and that scrolling still reaches the final rows.

The shared 2.5.6 NUZ RULES edit repair is still runtime TEST REQUIRED. The setup loadout-warning popup remains a separate confirmed UI backlog item and is not changed here.

# Nuzlocke 2.5.6-DEV

Strict child of 2.5.5-DEV.

## Blue runtime repair pass
Blue 2.5.5 runtime testing found two additional release-blocking UI/diagnostic regressions while the opening-sequence validation was still in progress.

- **NUZ RULES update crash:** changing No Mom Heal and other ordinary rules could show `bad argument #1 to 'ipairs' (table expected, got nil)` after the live save write. The post-write title/setup Type Locke mirror now uses a canonical local slot/default fallback instead of allowing an unavailable shared table reference to crash unrelated edits.
- **DEV -> VIEW REPORT crash:** the Dev screen update closure referenced the report-wrapping helper before that local function entered scope. The helper is now forward-declared and assigned before the screen is returned.
- **MOD COMPAT presentation:** removed the duplicate one-pixel draw that made the left rule-name column bold. The right OWNER column and title behavior are otherwise unchanged.

These are targeted static repairs. Runtime re-test is required. The existing 2.5.5 Blue starter/Nickname/Pallet provenance/First Rival Mercy repair remains unverified and was not rewritten in this build.

# Nuzlocke 2.5.5-DEV

Strict child of 2.5.4-DEV.

## Blue opening-sequence repair attempt
Runtime evidence on Blue / 2.5.4 identified a connected opening cluster:
- Nickname Rule could be skipped for a randomized starter.
- Randomized Exeggcute starter was not attributed to Pallet Town.
- First Rival Mercy dialogue appeared, but losing the opening Rival battle could restart/rewind the opening flow.
- On the repeated starter sequence, the player starter randomized again while the Rival starter no longer matched the expected randomized relationship.

### Fix attempt
- Starter detection in the scripted `give_pokemon` wrapper now uses the same robust `ctx.mapId` / overworld map / save-player-map context as the pre-give randomizer seam, instead of relying only on `areaKey()`.
- This is intended to restore both mandatory R/B starter Nickname enforcement and immediate Pallet Town starter provenance for randomized species.
- First Rival Mercy now has a finish-level invariant: once mercy actually triggers, Nuzlocke destructive Whiteout state is cleared, the forgiven starter is restored if another wrapper removed it, transient death metadata is cleared, and the native Oak-lab finish/onFinish script is allowed to perform its normal heal + story flag advancement.
- Normal post-battle dead-party pruning skips the one mercy battle so it cannot undo that restoration.
- Added Dev visibility for the committed randomized starter original/choice pair.

This is intentionally an attempted runtime repair, not a claimed PASS. Re-test Blue from a fresh game.

# Nuzlocke 2.5.4-DEV

Strict child of 2.5.3-DEV.

## Rules cleanup
- World Building now defaults to **T1** instead of T3.
- Removed the **Cap Messages** selector. Cap feedback is fixed to **once per battle**, on the first EXP award actually blocked or banked by the active level cap.
- Crossing a cap now produces that notice immediately rather than waiting for a later EXP award.
- Removed the separate **Solo Only** rule.
- **Party Size Limit = 1** is now the sole Solo-run mechanic.
- SOLO and IRON loadouts set Party Size Limit to 1; VANILLA, NUZ and HARD use 6.
- Legacy saves with `solo_active=true` are migrated to Party Size Limit 1.
- Removed duplicate Solo-specific catch/gift/trade rejection paths.

# Nuzlocke 2.5.3-DEV

Strict child of 2.5.2-DEV.

## Blue runtime menu follow-up
Runtime source: Pokémon Blue on Gen1Recomp 0.2.7.

- Renamed **Ball Limit** to **Ball Per Enc.**
- Moved **No Catching** and **Ball Per Enc.** from GENERAL to **BATTLE ITEMS**.
- **Ball Per Enc.** is hidden and therefore not configurable while **No Catching** is ON.
- Turning **No Catching** OFF immediately restores the Ball Per Enc. row.
- Ball Per Enc. remains **OFF** by default, preserving vanilla unlimited Ball throws.
- Existing saved Ball Per Enc. selections are preserved while hidden rather than destructively reset.
- Aligned the Ball Per Enc. value display with the other right-side selector/toggle values.
- Moved **GAME DIFFICULTY** and **BATTLE MECHANICS** above **GENERAL** in the Rules/Setup section order.

# Nuzlocke 2.5.2-DEV

Strict child of 2.5.1-DEV.

## Diagnostic hardening
- Added a Dev assertion for raw `randomizer_info_policy` storage.
- Boolean values now produce `randomizer_info_policy_boolean`; malformed/out-of-range numeric values produce `randomizer_info_policy_invalid`.
- This is deliberately diagnostic-only. Historical versions already wrote this selector numerically, so no boolean migration or invented `true`/`false` meaning was added.

## Gen1Recomp compatibility audit
- Reviewed the published engine deltas sequentially from 0.2.1 through 0.2.7.
- Advanced the source-audited compatibility marker to 0.2.7 and added explicit profiles for 0.2.2–0.2.7.
- 0.2.2 adds the shared Gold `battle.move_grid_navigation` hook; Nuzlocke records it as available but does not own or alter it.
- 0.2.3 expands Gold `mod.battle` snapshots with Ball inventory and catch previews and extends catching registry plumbing. Nuzlocke's read-only battle snapshot helper already composes with this automatically.
- 0.2.4 is primarily link/session security hardening.
- 0.2.5–0.2.7 contain platform/audio/cache/Gold UI/world fixes; no protected Nuzlocke enforcement seam required a behavioral adapter change.
- Engine Mod API remains 2 and engine save format remains 4 through 0.2.7.
- Manifest engine range remains `>=0.1.86 <2.0.0`; no floor/ceiling change is justified by this audit.

# Nuzlocke 2.5.1-DEV

Strict child of the unreleased 2.5.0 candidate.

This build exists specifically for another runtime validation pass before any public 2.5.x release. It carries forward the complete 2.5.0 stabilization candidate unchanged in gameplay logic; only version/release-status documentation has changed.

## Test focus

Please runtime-check the recent high-risk fixes before publication:
- Yellow No Mom Heal ON/OFF.
- No Field Heal / No Rare Candy rejection pacing.
- Randomized starter correctly shown as the Pallet Town encounter in ENC TRACKER and map.
- Shiny Clause cycling and persistence.
- Encounter Ball Limit cycling/persistence and 1/2/3/5/10 enforcement.
- Randomizer Info Policy OPEN INFO / BLIND INFO display persistence.
- Dev Report `species_facts` no longer showing the stale false WARN.
- NZR4 Report Code generation/refresh on the 2.5.x version line.
- Any Gold or multi-mod combinations you can reasonably cover.

## Compatibility / format

- Save Schema: 4
- Compatibility API: 28
- Diagnostics API: 1
- Mod API: 2
- Gen1Recomp: >=0.1.86 <2.0.0
- Package file set unchanged

Do not publish this DEV build as the final 2.5.x release until runtime validation is complete.
