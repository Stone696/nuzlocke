# Internal Code Review History

Internal engineering record. This file is repository/dev-only and must never be included in player/public release packages.

Every substantive potential-bug review should record the concern, finding, decision, protected behavior, validation, and any follow-up. Preserve prior entries even if later evidence changes the decision.

## 2026-08-13 — Trainer-battle classification did not rely only on `battle.kind`

**Status:** Fixed before this review; protected behavior.

**Concern:** Generation/mod-specific trainer battles may not expose `battle.kind == "trainer"`. A literal `battle.kind ~= "trainer"` gate could therefore classify trainer battles as wild/non-trainer and apply the wrong Nuzlocke behavior.

**Current handling:** `isTrainerBattleForNuzlocke(battle)` accepts multiple engine/provider shapes (`kind`, `type`, trainer flags, trainer objects, and compatible opponent metadata), and the reviewed Nuzlocke paths use that helper rather than the earlier narrow check.

**Decision:** Keep the helper-based classification. Do not simplify back to a single `battle.kind` check unless the engine contract later guarantees one canonical trainer discriminator across supported generations/providers.

**Protected behavior:** Trainer/wild classification, Rival detection, encounter enforcement, level-cap/trainer observations, third-party trainer composition.

**Validation:** Current source inspection confirms the helper is present and used at the reviewed classification seams. Existing runtime evidence for trainer-sensitive behavior remains protected.

---

## 2026-08-13 — First Rival Mercy persisted `armed` / `triggered` markers are write-only

**Status:** Fixed in beta.29.0.2; targeted runtime regression pending.

**Concern:** `nuzlocke_first_rival_forgiveness_armed` and `nuzlocke_first_rival_forgiveness_triggered` are written but never read by current source. The actual rule gate uses `nuzlocke_first_rival_battle_seen` plus battle-local `nuzlockeFirstRivalBattle` / `nuzlockeRivalForgiveness` fields.

**Finding:** Full literal search of the current beta.29.0.1 source finds only three writes and zero reads for the two markers. They are not documented as part of `nuzlocke_compat` and do not participate in current First Rival Mercy behavior. `nuzlocke_first_rival_battle_seen` is the durable one-shot consumption state.

**Assessment:** Low severity. This is dead/inert persisted telemetry rather than a player-facing gameplay bug. Surfacing it in UI solely to justify the writes would add feature scope without fixing a user problem.

**Preferred direction:** Remove the two unused writes in the eventual fix revision, while leaving existing legacy save keys harmlessly ignored. Do not add a migration solely to delete old values. If a future run-summary/API feature needs this telemetry, add an explicit supported state model then rather than depending on undocumented legacy keys.

**Protected behavior:** First Rival Mercy must remain one-time, opening-battle-only, preserve native battle loss flow, and suppress Nuzlocke-owned faint/Whiteout consequences only for that battle.

**Validation:** Static source review; existing smoke test confirms the opening Rival mercy arms once and cannot arm again. Runtime retest required if the fix batch touches this section.

**Resolution in beta.29.0.2:** Removed both unused writes and added a structural regression check that the legacy key names no longer appear in executable source. No save migration deletes old values. The established one-shot and battle-local gate is unchanged.

---

## 2026-08-13 — Gift/starter history snapshots occur before mandatory nickname completion

**Status:** Fixed in beta.29.0.2 for R/B/Y and Gold; targeted runtime regression pending.

**Concern:** `registerStarterCatch` / `registerSpecialCatch` snapshot `mon.nickname` into `nuzlocke_history`. In Gold `G2.installGiftTracking`, registration currently runs before `G2.requireGiftNickname`, so mandatory nickname completion cannot update the already-stored history name.

**Finding:** Confirmed in current beta.29.0.1. `registerStarterCatch` stores `mon.nickname or mon.species`; `registerSpecialCatch` stores `mon.nickname or glitch.label or species`. Gold calls the registration function and only afterward blocks on the native rename seam. No later code synchronizes history names from the Pokemon identity/nickname.

**Expanded scope:** The current R/B/Y scripted gift/starter wrapper also registers the received Pokemon before its forced `NamingScreen` loop writes `received.nickname`. Therefore the stale history-name risk is not Gold-only; it can affect mandatory-nickname scripted starter/gift acquisitions on both supported generation paths.

**User-visible impact:** Any feature reading `nuzlocke_history.name` can show the species/default label instead of the chosen nickname for affected acquisitions. Current source already uses history for run-recap/latest-catch presentation, so this is not merely hypothetical future-export metadata.

**Engine contract check:** Gen1Recomp 0.1.81 `Specials.block` starts the naming operation first, yields only if the callback is asynchronous, and resumes the same VM coroutine when naming completes. That supports placing post-acquisition history registration after the forced naming step without changing script command ordering, provided duplicate-registration behavior is preserved.

**Preferred direction:** Preserve the established acquisition/tracker registration timing, then synchronize the matching `nuzlocke_history` row after mandatory nickname completion using the Pokémon's stable Nuzlocke identity. This changes only the stale `row.name` snapshot instead of moving the larger registration operation across Gold VM or R/B/Y naming-screen yield boundaries. Apply the same synchronization to both Gold and R/B/Y scripted starter/gift paths, preserve duplicate-registration guards/failure fallbacks, and add regression assertions that the stored history row name equals the chosen nickname.

**Protected behavior:** Mandatory nickname enforcement, Gold VM blocking/resumption, starter/gift legality gates, random starter handling, tracker deduplication, Catch Info provenance, existing save compatibility.

**Validation:** Static source inspection plus the supported engine naming-block contract review. Earlier smoke coverage proved Gold naming completes but did not assert the history snapshot name.

**Resolution in beta.29.0.2:** Added stable-identity `syncHistoryNickname(mon)` after mandatory naming completion on both R/B/Y and Gold paths. Registration timing remains unchanged. Smoke coverage now asserts the Gold history row stores the completed nickname; R/B/Y exact runtime remains required.

---

## 2026-08-13 — Follow-up candidate discovered during literal save-key audit: `__nuzlocke_random_starter_original`

**Status:** Unreviewed follow-up candidate; do not change as part of the First Rival Mercy fix without separate review.

**Observation:** The same literal set/get audit found `__nuzlocke_random_starter_original` is written by `selectRandomStarter` but has no literal `mod.save:get` consumer in current source. This is separate from the reported Rival Mercy issue.

**Decision:** Preserve current behavior until reviewed on its own. Do not broaden an unrelated fix merely because the same audit surfaced it.

---

## 2026-08-13 — Gold `givepoke` tracking only detects new party members

**Status:** Fixed in beta.29.0.2; full-party/PC-route runtime confirmation pending.

**Concern:** `G2.installGiftTracking` snapshots only the pre-command party by table identity, delegates to the underlying `givepoke`, then calls `G2.findNewPartyMon(before, afterParty)`. If the acquisition succeeds but the new Pokemon is stored in a PC box rather than appended to `save.party`, the hook returns before Stat EXP initialization, tracker/history registration, area consumption, or mandatory nickname enforcement.

**Finding:** Confirmed in beta.29.0.1 source. `G2.findNewPartyMon` walks only the party. Elsewhere the Nuzlocke implementation already treats `save.party` and each list in `save.boxes` as a unified owned-Pokemon pool (`collectLegacyMons`, stored catch-location recovery), so box storage is a supported save shape and the Gold gift hook is narrower than the rest of the ownership model. Gen1Recomp also has a dedicated Gen 2 box subsystem; the Nuzlocke adapter should not assume a successful scripted acquisition must remain in the party.

**Definite impact if `givepoke` deposits outside the party:** the acquired Pokemon is not registered in `nuzlocke_history`/tracker state, its encounter area is not consumed, Player Stat EXP initialization is skipped, and the Nuzlocke mandatory Nickname Rule is not applied by this hook. The missed area consumption can also permit a later otherwise-disallowed encounter/acquisition in that area. Re-receiving the exact same vanilla gift depends on that script's own completion flags and should not be claimed generically.

**Preferred direction:** Replace the party-only before/after diff with an owned-storage diff that covers party plus PC boxes, preserving party-first selection. Snapshot Pokemon object references before delegating, then scan the post-command party and boxes for the one new object. Do not use species matching, because duplicates are legal and persistent identity is assigned after acquisition. Avoid daycare in this specific helper: `givepoke` should be detecting its destination, not arbitrary simultaneous storage changes.

**Relationship to the nickname-history review:** Once a boxed gift is detectable, it should enter the same post-acquisition path as a party gift. The eventual Bug 2 fix must therefore update the final history nickname for both party- and box-delivered scripted gifts, not only party acquisitions.

**Resolution in beta.29.0.2:** Added party+box owned-object snapshot/diff helpers and retained party-first selection. The same post-acquisition initialization, registration, naming, and history synchronization now receives a box-delivered object. Smoke coverage includes a six-member party with the new gift inserted into PC storage.

**Protected behavior:** Gold scripted starter/gift legality checks must still occur before mutation; normal party-delivered gifts must retain current behavior; random starter replacement, Player Stat EXP initialization, stable Pokemon identity, tracker deduplication, area ownership, VM block/resume behavior, and forced nickname handling must not regress.

**Validation to add with fix:** Extend the headless Gold gift test with a six-member party and a `givepoke` delegate that inserts the new Pokemon into a box. Assert: party remains six; boxed object is detected; Player Stat EXP initialization runs; Catch Info/tracker metadata is attached to that boxed object; the correct area is consumed exactly once; one history row is created; mandatory nickname completes on the boxed object; and the history row carries the completed nickname after the Bug 2 synchronization fix. Also retain the existing party-delivered starter test as a regression baseline.

**Runtime test after fix:** Gold full-party scripted gift to PC, then inspect the box, Catch Info/history/Tracker, Nickname Rule result, and attempt another encounter in the same area. Exact gift NPC should be chosen from a currently functioning Gold script path whose full-party behavior is known in the audited engine build.

---

## 2026-08-13 — Gold `pendingStaticEncounter` is not invalidated by every intervening battle

**Status:** Fixed in beta.29.0.2; genuine-static and intervening-trainer runtime regression pending.

**Concern:** `G2.installStaticTracking` sets the runtime-only `pendingStaticEncounter` marker when the Gold script executes `loadwildmon`. The shared `battle.started` consumer currently clears that marker only when the started battle is classified as non-trainer and stamped static. Although the script-command hook proactively clears on `randomwildmon`, `loadtrainer`, and `loadtemptrainer`, any trainer battle or other superseding battle path that begins without one of those specific command names can leave the marker live. A later unrelated wild battle can then consume the stale marker and be mislabeled static.

**Finding:** Confirmed in beta.29.0.1 source. All current references to `pendingStaticEncounter` were reviewed. The Gold producer sets it on `loadwildmon`; three named script commands clear it; the shared `battle.started` handler clears it only inside the non-trainer stamping branch; R/B/Y's `Commands.static_battle` wrapper additionally clears after the canonical static battle returns; restore handling clears it at a rewind boundary. There is no unconditional invalidation on an arbitrary intervening `battle.started` event.

**Definite impact:** A stale Gold marker can survive a trainer/intervening battle and cause a later wild battle to receive `battle.nuzlockeStaticEncounter = true` and `encounterType = "static"`. With No Static Encounters enabled, that can produce a false-positive capture denial for an otherwise ordinary wild encounter.

**Nuance:** Merely moving `pendingStaticEncounter = nil` to the top of `battle.started` fixes the reported trainer-intervened leak because every battle consumes/invalidates the one-shot marker. It does not by itself prove that an abandoned `loadwildmon` can never be followed by an unrelated wild battle with no intervening battle. The fix should therefore clear the marker unconditionally on the next battle event and, where the live battle exposes a reliable species/generation discriminator, validate the pending marker against the battle before stamping it. The species check is defense-in-depth rather than the primary lifetime fix; identical species can occur in unrelated encounters, so lifetime remains authoritative.

**Preferred direction:** In the shared `battle.started` handler, capture the current marker into a temporary value and clear `mod.exports.__beta26.pendingStaticEncounter` immediately once a real battle object is received. Only then consider applying static provenance, and only to a non-trainer battle. Preserve explicit static provenance supplied directly by compatible battle providers. Avoid broad script-flow rewrites; the runtime marker should remain single-use and battle-scoped.

**Suggested shape:**

```lua
local pendingStatic = mod.exports.__beta26.pendingStaticEncounter
if battle then
    mod.exports.__beta26.pendingStaticEncounter = nil
end
if battle and not isTrainerBattleForNuzlocke(battle)
    and type(pendingStatic) == "table" then
    -- Optional defensive species/generation match when the battle exposes it.
    battle.nuzlockeStaticEncounter = true
    battle.encounterType = battle.encounterType or "static"
end
```

**Protected behavior:** Canonical R/B/Y static battles must remain correctly labeled; Gold fixed/scripted wild encounters must still be labeled static; random wild encounters must remain non-static; provider-supplied explicit static metadata must remain authoritative; trainer classification must continue through `isTrainerBattleForNuzlocke`; No Static Encounters must deny only genuine static encounters.

**Validation to add with fix:** Headless regression cases should assert: (1) Gold `loadwildmon` followed by intended wild `battle.started` stamps exactly that battle and clears the marker; (2) `loadwildmon` followed by a trainer `battle.started` clears the marker without stamping the trainer, then a later ordinary wild battle remains non-static; (3) `loadwildmon` followed by `randomwildmon` clears before battle start; (4) R/B/Y canonical static wrapper still stamps and clears correctly; (5) an ordinary wild battle with No Static Encounters enabled is catchable after an intervening trainer scenario; (6) explicit provider/static fields continue to classify correctly even when no pending marker exists.

**Runtime retest after fix:** Gold genuine scripted/static encounter, Gold ordinary wild encounter immediately after a trainer battle, and R/B/Y known static encounter + normal grass encounter. The Gold ordinary wild test should be run with No Static Encounters enabled to prove the false-positive capture denial is gone.

**Resolution in beta.29.0.2:** The shared `battle.started` handler now consumes the pending marker before trainer/wild classification whenever a real battle object arrives, and stamps only a non-trainer battle. Smoke coverage includes the reported intervening-trainer sequence and a genuine next-wild consume-once case. A separate species-mismatch heuristic was deliberately not added because lifecycle ownership is authoritative and numeric/string species representations can differ across script/battle layers.

## 2026-08-13 — Compatibility review: Gen1Recomp 0.1.81 through 0.1.83 seam drift

**Status:** REVIEWED / NO GAMEPLAY FIX REQUIRED in beta.29.1.0.

**Concern:** Gen1Recomp 0.1.82 changed several engine modules Nuzlocke wraps, and 0.1.83 became the current release immediately before runtime certification. Widening the manifest without checking those exact contracts could turn a metadata-only compatibility claim into a hidden gameplay regression.

**Finding:** Exact v0.1.83 source inspection confirms the protected Gen 1 `BattleState` methods used by Nuzlocke retain compatible signatures, as do `Status.residual`, `ItemEffects.use`, `ShopMenu.new`, and the SaveData persistence/slot helpers. Gold retains `BattleState:finishBattle`, the `Specials.block` asynchronous naming contract, `Vm` `loadwildmon` state, shared battle lifecycle events, and the title-menu hook shape. Gen1Recomp Mod API remains 2 and engine save format remains 4. The 0.1.82→0.1.83 delta adds Gold `mapOverview()` and launcher/importer work but does not remove the currently protected Nuzlocke seams.

**Decision:** Do not rewrite gameplay wrappers or replace the established ENC TRACKER path for beta.29.1.0. Add explicit 0.1.82/0.1.83 engine profiles, advance the audited engine identifier to 0.1.83, widen the manifest through `<0.1.84`, and require exact 0.1.83 runtime testing before release approval. The new Gold map-overview surface is a future migration candidate only after equivalence is demonstrated.

**Why unchanged:** Runtime-proven behavior is stronger evidence than architectural novelty. The current source review provides no concrete failure requiring a wrapper rewrite, and changing those paths immediately before release would create unnecessary regression risk.

**Protected behavior:** All previously runtime-confirmed R/B/Y and Gold paths; beta.29.0.2's four reviewed fixes; Save Editor isolation; temporary-party Permadeath/Whiteout handling; item/shop enforcement; battle classification/static provenance; Setup/Rules/Tracker/Catch Info surfaces.

**Validation:** Exact-source inspection completed for the listed 0.1.83 seams. Runtime evidence already confirms Mod Manager import/discovery and the older manifest gate behavior on 0.1.83. beta.29.1.0 gameplay runtime, Lua smoke, and upstream modkit checks remain separate obligations.

**Reconsider when:** An exact 0.1.83 runtime test fails on one of these seams, a later Gen1Recomp release changes the contract, or an equivalence test demonstrates that a stable public seam can replace a protected private path without behavior loss.

