# Nuzlocke 2.0 Development Roadmap

## Versioning / baseline

**Published canonical baseline: 2.0.0-beta.27.**  
**Current development revision: 2.0.0-beta.27.**

beta.27 is promoted directly from beta.26.6 with no intentional gameplay changes during promotion. Every later revision must be created only from the immediately previous numeric revision:

- beta.27
- beta.27.1
- beta.27.2
- beta.27.3
- ...

The entire beta.26.x line is now historical/reference material. Never restore it wholesale after beta.27; only port a specific missing change after comparison.

## Runtime-tested / protected

- Gold beta.26.6 fresh startup / New Game -> house: **PASS**.
- Gold beta.26.6 in-game RULES: **PASS**.
- Gold beta.26.6 in-game TRACKER: **PASS**.
- Gold beta.26.6 Catch Info: **PASS**.
- Gold beta.26.6 Cyndaquil starter acquisition: **PASS**; mandatory starter exemption remains protected.
- Yellow beta.26.6 RULES/TRACKER smoke: **PASS**.
- Yellow beta.26.6 catch behavior / encounter tracking: **PASS**.
- Published 25D4-RBY2 startup/menu hotfix remains protected.
- Blue fresh startup through Oak -> bedroom.
- Yellow fresh startup through Oak -> bedroom from the published/startup line.
- Gold NEW GAME SETUP visibility/room boot on the published line; Gold beta-aware SETUP presentation confirmed on the beta.26 line.
- Existing Red save menus/functionality smoke-tested on published hotfix.
- Gym Guide Rare Candy selector established in earlier runtime testing.
- Earlier beta.25 passes: No PP Items, No Escape, battle healing restriction, Field Heal restriction, Nickname Rule, No PokéCenter, No Repels, No X Items.
- Yellow beta.26: starting Rare Candies and starting Money apply correctly.
- Yellow beta.26: Trainer Card has only vanilla + NUZ STATUS pages; immutable start Money/Balls/Candies appear inside NUZ STATUS.
- Yellow beta.26: forced starter nickname works.
- Yellow beta.26: pre-Ball shiny encounters with Shiny Clause ON or OFF do not consume the route.
- Yellow beta.26: PokéCenter healing toggle works correctly.
- Yellow beta.26.2 fresh run: SETUP visible and New Game reaches the bedroom.
- Yellow beta.26.2 fresh run: Pikachu Catch Info reports **Pallet Town immediately on acquisition**, before the Pokédex handoff.
- Yellow beta.26.2: No Mom Heal custom World Building correctly replaces Mom's vanilla rest dialogue.
- Yellow beta.26.2: first-rival T3 World Building timing after the trainer reveal is accepted as **complete**.
- Yellow beta.26.2: UI category controls OFF behave correctly in runtime testing.
- Yellow beta.26.2: defeating the first eligible Route 2 encounter records a failed encounter in the Tracker and produces expected T3 feedback.
- Yellow beta.26.2: NUZ STATUS and Encounter Tracker display the **next active level cap**, not the maximum possible cap in the configured scope.
- Yellow beta.26.2: toggling **1st Catch** after an area already had its first encounter behaves as expected.
- Yellow beta.26.2 fresh run: No Buying / No Selling enforcement PASS.
- Blue beta.26 line: Pokédex handoff activates the route ledger and configured starting Balls appear in the home PC.
- Mom heal ON/OFF, No Field Heal ON/OFF, No PokéCenter ON/OFF and No Escape have additional beta.26-development runtime evidence.
- Red existing save on published beta.26: No Buying ON/OFF enforcement PASS and No Selling ON/OFF enforcement PASS.
- Blue existing save on published beta.26: No Buying ON/OFF enforcement PASS and No Selling ON/OFF enforcement PASS. Fresh-run/first-entry Mart coverage remains open because earlier 0.1.79 testing failed there.
- Red existing save on published beta.26: Gym Guide Rare Candy NPC/service PASS mechanically.
- Blue existing save on published beta.26: No Field Heal blocked healing and produced expected T3 World Building feedback.
- Blue existing save on published beta.26: catch-time T3 nickname flavor appeared with Nickname Rule ON; code path is explicitly gated by `nickname_rule`.
- Regression target: verify on a clean eligible catch that Nickname Rule OFF produces no nickname-specific World Building line while ordinary catch flavor remains allowed.

## Carried into beta.27 from beta.26.6 — partially runtime-tested

- Gold `givepoke` now runs shared gift legality checks **before** mutation. The first Johto starter remains a starter path; ordinary allowed gifts are logged afterward.
- Gold `G2.onFaint` Whiteout detection now has a Gen 2 `finishBattle` consumer. Native Gen 2 cleanup is preserved, the ordinary heal/money-loss/warp callback is suppressed, and the Nuzlocke save-deletion/Credits-title flow owns the ended run.
- Whiteout OFF continues through the vanilla Gold battle-end path unchanged.
- Gold starter acquisition runtime-passes and proves the mandatory starter path is not blocked. Ordinary Gold gift denial and the Gold Whiteout consequence are still **runtime-test-required**.

## Implemented in beta.26.5 — runtime test required

- `pokemon.received` now assigns gift/trade classification for fallback/external acquisition events. Explicit source wins; species tables are fallback-only when source is absent.
- R/B/Y starting Money/Balls/Rare Candy application is generation-gated. Gold/Silver/Crystal New Games keep their native starting resources and do not receive the R/B/Y deferred-Ball state.
- Gen 1 Whiteout now calls through the engine's already-wrapped `BattleState.finish` chain with `onFinish` temporarily suppressed, so engine cleanup / public `battle.ended` / Nuzlocke finalization happen once before run-summary, save deletion, Credits, and title.
- Whiteout keeps a defensive fallback only if the engine finish chain itself errors.
- These fixes are **not runtime PASS yet**. Whiteout requires a disposable-save end-to-end test before protection.

## Carried forward from beta.26.4 — runtime test required

- Carries beta.26.3 Area Guide-only second activation popup, allowed-Mom T3 de-duplication, and home-TV interaction forward unchanged.
- Failed encounter display now uses `FAILED <species>` instead of unexplained encounter-type shorthand and scrolls through the Tracker result column using the existing marquee.
- Tracker right-column heading is **RESULT** on both LOG and MAP pages.
- Tier 3 home TV now adapts to run progression and history: Pokédex state, latest catch, failed encounters, losses, badges, next active cap, and active rules; repeated interactions cycle through available run reports.
- Failed encounters store a lightweight last-failure presentation record for TV flavor; enforcement remains authoritative in `encounter_states`.
- Mod-authored dialogue strings received a spacing/join audit. The vanilla Viridian Mart parcel-clerk formatting issue remains open rather than being patched through a broad text override.

## Runtime-confirmed beta.26.1 / beta.26.2 polish

- Exact R/B/Y Mom blocked-heal dialogue ownership: **PASS on fresh Yellow beta.26.2**.
- Immediate starter Catch Info repair to Pallet Town: **PASS on fresh Yellow beta.26.2**.
- First-rival Tier 3 timing after trainer reveal: **PASS / COMPLETE on Yellow beta.26.2**.
- Gym Guide Rare Candy visual centering remains runtime-test-required.
- Battle wrapping/paging remains runtime-test-required.

## Implemented / active beta.27 systems

- Soft Start / first usable Poké Ball permanently arms encounter rules.
- Deferred configured starting Poké Balls until the verified Pokédex handoff boundary.
- Route-ledger activation at the same boundary.
- Encounter-state cleanup work around first arm.
- Starter canonicalization work toward a single Pallet Town entry.
- Failed-encounter tracker-state groundwork.
- Immutable Run Start snapshot for Money/Balls/Candies inside NUZ STATUS.
- Gold-specific reduced BETA SETUP surface and beta-aware descriptions.
- Forced scripted starter/gift naming when Nickname Rule is ON.
- Rival T3 timing after trainer reveal — runtime-confirmed on Yellow beta.26.2 and treated as complete unless regression appears.

## Performance investigation

- A beta.26.2 Yellow run reported noticeable lag, especially during battles.
- Static beta.26 -> beta.26.2 comparison shows no new per-frame Yellow `BattleState.update` or `BattleState.draw` patch. beta.26.1 battle-text formatting is message-time only; beta.26.2's gameplay/UI code delta is Gym Guide quantity-screen alignment.
- Existing baseline event/hook layers still need controlled profiling before ruling the mod out entirely. Do **not** make speculative performance rewrites on runtime-PASS paths.
- Preferred test: fully restart Gen1Recomp, use the same Yellow save and same battle, compare mod enabled vs disabled (or published beta.26 vs current revision), then compare World Building T0 vs T3. Record whether lag is constant, battle-only, message-only, or tied to specific rule toggles.

## Planned soon — beta.27.x

- Re-test **No Buying / No Selling** on fresh Red/Blue for parity. Existing Red/Blue saves and a fresh Yellow beta.26.2 run now pass; an older fresh Blue failure remains conflicting historical evidence.
- Finish the **opening dialogue cleanup**:
  - investigate repeated/near-duplicate Oak and rival lines around the opening/Pokédex handoff;
  - fix missing spacing/line breaks where the source is confirmed;
  - fix Viridian Mart first-entry Shop Clerk formatting.
- Add T2/T3 dialogue variety for Mom, Pokémon Center, Buying and Selling denial paths after the underlying ownership/enforcement paths are stable.
- Runtime-test beta.26.5 gift/trade fallback classification, then continue gift/trade recovery type-preservation work.
- Expandable/collapsible rule categories and navigation improvements.
- No TMs; HMs unaffected.
- Player No Status Moves.
- Trainer No Status Moves.
- Permanent Lock beta with two-step confirmation and beta warning.
- Conservative MissingNo/glitch handling.
- Mt. Moon / dungeon encounter grouping: one encounter for whole dungeon vs per-floor.

## Planned future

- Rare Candy use restriction: block **using** Rare Candy while still allowing acquisition/storage/tossing and buying/selling when other rules permit, mirroring the No TMs philosophy.
- Trainer Team Boost / difficulty scaling: stronger and/or expanded trainer teams, provider-aware and version-safe.
- No Exit dungeon/gym challenge with explicit softlock safeguards.
- Field-item randomization.
- Gym Leader TM reward randomization.
- Broader Ironmon-style randomized resource/item/move options with separate toggles.
- Maximum BST restriction.
- No Catching.
- No Evolution.
- No Trade Evolutions.
- Static encounter controls.
- Trainer item restrictions.
- Perfect DV/EV/IV options where supported.
- Game Corner prize controls.
- Alternate-start capability/provider integration.
- Special battle classifier.
- Recovery editor improvements.
- Safari Zone / route-split research beyond Mt. Moon.
- Pseudo-legendary classification controls.
- Town Map / richer encounter-history integration.
- Older Gen1Recomp compatibility through feature detection rather than version assumptions.

## Known bugs / open regressions

- Gold Forced Nicknames **FAIL** in beta.26.6 runtime testing: the Cyndaquil starter was acquired without any nickname prompt.
- Gold NUZ STATUS Trainer Card presentation is an architecture gap: base Gold already uses both native Trainer Card sides, so a generation-native access path must be designed instead of replacing a back side.
- Gold ordinary gift rejection and Gold Whiteout consequence remain runtime-test-required even though Gold starter acquisition passes.
- No Buying / No Selling have improving but still mixed runtime history: existing Red/Blue beta.26 saves and fresh Yellow beta.26.2 now PASS, while an older fresh Blue run failed. Fresh Red/Blue parity is still recommended before declaring the path universally closed.
- Opening Professor Oak / rival/story dialogue can still repeat, appear as slightly different duplicates, or have bad spacing, including directly after the first rival fight and around the Pokédex sequence.
- Yellow Viridian Pokémart first-entry Shop Clerk dialogue has a spacing/line-break problem.
- No Mom Heal ON dialogue ownership is runtime-PASS on Yellow; Mom-healing-allowed Tier 3 flavor duplication is being addressed in beta.26.3 and still needs testing.
- beta.26.1 battle wrapping/paging is **unverified** until catch denial and trainer flavor are exercised in battle.
- Gold gameplay options remain individually runtime-test-required unless separately marked passed.
- Actual-money vs Trainer Card current-money mismatch was observed once in a save-editor-contaminated test and remains unconfirmed.

## Development rules

- Every new revision is created only from the immediately previous revision. **beta.27 is now the canonical baseline; the next build must be beta.27.1 created directly from beta.27.** Runtime-passing paths are protected. Older branches are never restored wholesale; only specific missing changes may be ported after comparison.
- **Documentation style is now protected:** `README.md` and `CHANGELOG.md` must always remain separate files. Unless the user explicitly requests a different format, every future build must keep the README/Changelog structure and presentation style established by the 25D4-RBY2 documentation: plain `# Nuzlocke` README title, concise version/status introduction, Requirements, Installation / update, current revision summary, runtime confirmation tables, Game support, New Game setup, presets/rules, level caps where applicable, protected runtime behavior, save/API/validation sections, and Credits. `CHANGELOG.md` stays newest-first with version headings, concise bullet changes, runtime evidence, and targeted matrices where useful. Do not silently redesign the documentation format from build to build.
