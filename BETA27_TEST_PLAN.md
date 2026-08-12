# Nuzlocke 2.0.0-beta.27 Test Plan

beta.27 is promoted directly from beta.26.6. Promotion itself contains no intentional gameplay change. Runtime evidence from beta.26.6 is therefore carried into the beta.27 baseline, but unresolved/test-required paths remain unresolved.

## beta.27 publication checkpoint

| Test | Status |
| --- | --- |
| Gold fresh startup / New Game -> house | **PASS (26.6)** |
| Gold RULES | **PASS (26.6)** |
| Gold TRACKER | **PASS (26.6)** |
| Gold Catch Info | **PASS (26.6)** |
| Gold Cyndaquil starter acquisition | **PASS (26.6)** |
| Gold Forced Nicknames | **FAIL / OPEN** |
| Gold NUZ STATUS Trainer Card access | **NOT AVAILABLE / REDESIGN NEEDED** |
| Yellow RULES / TRACKER | **PASS (26.6)** |
| Yellow catch behavior / encounter tracking | **PASS (26.6)** |
| Yellow 1st Catch toggle after prior encounter | **PASS (26.2)** |
| Gold ordinary gift denial | **RUNTIME TEST REQUIRED** |
| Gold Whiteout ON/OFF | **RUNTIME TEST REQUIRED** |
| Gen 1 Whiteout teardown | **RUNTIME TEST REQUIRED** |
| Yellow battle-lag A/B | **OPEN** |

## Protected release regression gate

Before beta.27.1 or later changes are promoted, do not regress:

- R/B/Y SETUP/startup and Oak -> bedroom transition.
- Yellow/Blue Soft Start and Pokédex-delayed starting Balls.
- immediate R/B/Y starter Pallet Town metadata.
- in-game RULES/TRACKER and Catch Info.
- Yellow Mom/PokéCenter/Field Heal runtime-PASS behavior.
- Red/Blue existing-save and Yellow fresh-run Mart enforcement already marked PASS.
- Gold startup/house boot, RULES, TRACKER, Catch Info, and mandatory starter acquisition.
- first-rival T3 timing accepted as complete.


beta.26.6 is built only from beta.26.5. Runtime-PASS beta.26 paths remain protected. This pass targets two Gold source-review correctness fixes: pre-transaction gift enforcement and a Gen 2-specific Whiteout run-ending consequence. beta.26.5 correctness checks and beta.26.4 Tracker/TV checks remain carried forward.

## Startup hard gate

- Blue fresh title: SETUP visible; New Game reaches bedroom.
- Yellow fresh title: SETUP visible; New Game reaches bedroom.
- Red fresh title: SETUP visible; startup smoke pass.
- Gold fresh title: NUZLOCKE GOLD / BETA SETUP visible with reduced beta-aware surface; reaches room.
- Existing Red save: RULES/TRACKER remain available.

## Newly confirmed beta.26.2 Yellow evidence

- Fresh SETUP visible and New Game reaches bedroom: **PASS**.
- Configured starting Rare Candies/resources: **PASS**.
- Pikachu Catch Info immediately reports **Pallet Town** on acquisition: **PASS**.
- No Mom Heal ON replaces the vanilla rest dialogue: **PASS**.
- PokéCenter healing behavior: **PASS**.
- First-rival Tier 3 World Building timing after trainer reveal: **PASS / COMPLETE**.
- Oak/rival duplicate or awkwardly spaced dialogue still occurs after the first rival and around the early story: **OPEN**.


## Newly confirmed beta.26.2 Yellow evidence — additional pass

- Catch Info / Area Guide UI OFF behavior: **PASS**.
- Failed first eligible Route 2 encounter records a failed route and T3 failure response: **PASS**.
- NUZ STATUS + Encounter Tracker display only the **next active cap**: **PASS**.
- Fresh-run No Buying / No Selling enforcement: **PASS**.
- 1st Catch toggle after an area already had its first encounter: **PASS**.
- Viridian Mart first-entry parcel-clerk spacing: **OPEN**.

## beta.26.6 targeted checks

### Gold gift pre-transaction enforcement

1. Start a disposable Gold run with 1st Catch / encounter limits enabled.
2. Receive the first Johto starter. Expected: starter acquisition succeeds and registers as **New Bark Town**; it is not rejected as an ordinary gift.
3. Receive an ordinary scripted `givepoke` gift in a legal unused area. Expected: acquisition succeeds and registers once as a gift.
4. Repeat with the relevant area already consumed or with another policy state that should reject the gift. Expected: the Nuzlocke denial appears **before** the Pokémon enters the party and the script check reports failure.
5. Confirm no rejected gift briefly appears in party/Tracker and no duplicate registration occurs.
6. If Gold later exposes Gift Pokémon / No Legend / No Mythic / Solo Only in the test profile, verify each routes through the same gate.

### Gold Whiteout consequence — disposable save only

1. Use a disposable Gold save with Whiteout ON.
2. Lose the last healthy Pokémon in a normal non-CANLOSE battle.
3. Expected: Gold's normal heal / half-money / whiteout-spawn warp does **not** occur.
4. Expected: native Gen 2 battle cleanup completes; the battle screen closes once with no stuck alarm, menu cursor, volatile state, or frozen screen.
5. Expected: Nuzlocke run-end summary appears at T3 when available; the ended save is deleted and Credits/title flow follows.
6. Start another disposable Gold run/battle after returning to title. Expected: controls, stack, music, and battle state are healthy.
7. Whiteout OFF regression: lose a normal Gold battle. Expected: vanilla Gold blackout/heal behavior remains unchanged.
8. If convenient, repeat Whiteout ON with Permadeath OFF to confirm Whiteout remains independent.

## Performance investigation — beta.26.2 Yellow report

Static review does **not** show a new continuously-running Yellow battle update/draw hook in beta.26.1 or beta.26.2, so do not treat the mod as confirmed cause yet. Use a controlled A/B:

1. Fully quit/relaunch Gen1Recomp before each leg so hook hot-reload/stacking cannot contaminate the result.
2. Use the same Yellow save, same area, and ideally the same type of battle.
3. Compare current mod enabled vs mod disabled. If practical, compare published beta.26 vs beta.26.2/current too.
4. Compare World Building T0 vs T3.
5. Note whether lag is constant through battle animation/menu input, occurs only when Nuzlocke text is queued, appears after faint/catch events, or also exists in overworld movement.
6. If the lag only appears after repeatedly replacing builds without a full process restart, record that separately as a possible reload/wrapper issue.

## beta.26.5 targeted checks

### Fallback gift / trade classification

- Native gift regression: receive at least one normal scripted gift with Gift Pokémon enabled. Expected: acquisition succeeds and records the intended gift provenance/area once.
- Native trade regression: complete one in-game trade with Trades enabled. Expected: acquisition succeeds and records intended trade provenance once.
- If a test harness/cooperating mod can emit `pokemon.received` directly with `source="gift"`, `source="trade"`, or no source for a known gift/trade species, verify the fallback handler classifies it and does not double-register a Pokémon already marked `nuzlockeTrackerRegistered`.
- Negative classification check: an explicitly sourced non-gift/non-trade acquisition of a species that also exists in a gift/trade lookup must not be reclassified by species fallback.

### Gold New Game starting-resource safety

1. In an R/B/Y Setup profile, configure non-zero starting Money, Poké Balls, and Rare Candies.
2. Start a fresh Gold New Game using Gold's reduced beta Setup.
3. Expected: hidden R/B/Y starting-resource choices are **not** applied to Gold.
4. Expected: Gold's native New Game money / PC item state is not zeroed or rewritten by the Nuzlocke starting-resource hook.
5. Expected: no stranded `nuzlockeDeferredStartingBalls` behavior appears later in the Gold run.
6. Recheck a fresh R/B/Y run afterward. Expected: R/B/Y configured resources and Pokédex-delayed starting Balls still behave exactly as before.

### Whiteout teardown — disposable save only

1. Use a disposable fresh save with Whiteout ON. Test with Permadeath ON if possible, then repeat with Permadeath OFF if convenient.
2. Lose the last usable Pokémon in a normal battle.
3. Expected: Nuzlocke game-over messaging appears once.
4. Expected: battle closes cleanly; no frozen battle state, stuck low-HP alarm, duplicate battle-end message/event symptom, or normal blackout/heal-point warp occurs.
5. Expected: T3 run summary appears when applicable, then the ended run save is deleted and Credits/title flow proceeds.
6. From the title screen, start/load another disposable run and enter a battle. Expected: stack, music, battle state, and controls are healthy.
7. Whiteout OFF regression: lose a normal battle with Whiteout OFF. Expected: vanilla blackout/heal behavior remains unchanged.

## Carried-forward beta.26.4 targeted checks

### Failed-result clarity / marquee

1. Enable Failed Encounters and lose the first eligible encounter on an unused route.
2. Open Tracker LOG and MAP.
3. Expected: the right-column heading reads **RESULT**.
4. Expected: the failed row begins with `FAILED` rather than `FAIL-W`.
5. Leave the row selected/visible long enough for marquee movement.
6. Expected: the result scrolls to reveal the failed species, e.g. `FAILED RATTATA`.

### Progression-aware home TV

1. Set World Building to T3 and interact with the home TV before the Pokédex. Expected: early Pallet/story-aware flavor plus an active-rule reminder.
2. After receiving the Pokédex and catching a Pokémon, interact several times. Expected: the TV cycles through progression and catch/team reports.
3. Record a failed encounter and interact several times. Expected: a route-failure report joins the cycle without permanently replacing catch/progression reports.
4. If a party member is lost under Permadeath, interact several times. Expected: a loss-history report joins the cycle.
5. With level caps active, expected: TV may include the **next active cap** and stage name.
6. Change a high-priority rule (No Mom Heal / No PokéCenter / No Field Heal / Nickname / Mart restriction) and confirm the rule reminder adapts.
7. Set World Building T0-T2. Expected: vanilla TV interaction remains untouched.

### Dialogue spacing regression

- Exercise the new TV states above and inspect every page for joined words or missing spaces.
- Recheck Nuzlocke-authored Mom / catch-failure / Soft Start messages for spacing.
- Recheck the Viridian Mart parcel-clerk sequence separately. It remains a known vanilla/story-text formatting issue and is not claimed fixed in beta.26.4.

## Carried-forward beta.26.3 targeted checks

### Pokédex Soft Start notification clarity

1. Configure starting Poké Balls and start a fresh R/B/Y run.
2. Confirm the Balls remain withheld before the Pokédex, as in the protected beta.26 flow.
3. Receive the Pokédex.
4. Expected first Nuzlocke popup: explicitly says the challenge Poké Balls are **waiting in the PC at home**.
5. Expected second Nuzlocke popup: talks **only about the Area Guide / Nuzlocke Tracker**. It must not say that Balls were received or imply they are in the player's bag.
6. Confirm the configured Balls are actually in the home PC and encounter rules are armed.

### Mom allowed-heal Tier 3 de-duplication

1. Set World Building to T3 and **No Mom Heal OFF**.
2. Heal with Mom.
3. Expected: healing succeeds and at most one custom Tier 3 Mom post-heal flavor line appears.
4. Heal with Mom again.
5. Expected: the same custom Tier 3 line does not stack/repeat again; later allowed heals use normal dialogue.
6. Turn **No Mom Heal ON** and retest once. Expected: the already-PASS Nuzlocke refusal still replaces the vanilla rest text and no heal occurs.

### Home TV Tier 3 World Building

1. In Red's House 1F, set World Building to **T3** and interact with the TV.
2. Expected: a Nuzlocke-aware TV line appears.
3. Test at least two rule profiles, such as Nickname Rule ON and No Mom Heal ON. Expected: the TV flavor changes to reflect an active rule.
4. Set World Building to T0, T1, or T2 and interact again. Expected: vanilla TV behavior is preserved; the beta.26.3 custom TV line does not consume the interaction.
5. Interact with Mom/other nearby objects. Expected: no TV flavor leaks into non-TV interactions.

### Protected early-game regression

- Starter immediately remains Pallet Town before Pokédex.
- First-rival T3 line still occurs after trainer reveal; treat timing as complete unless a regression appears.
- No Mom Heal ON still owns the blocked interaction.
- PokéCenter ON/OFF remains functional.
- Pre-Ball encounters still do not consume routes with Shiny Clause ON or OFF.

## Carried-forward checks

### Gym Guide Rare Candy alignment

- `RARE CANDY`, `How many?`, 1 / 10 / 25 / 50 / 99, cursor, and A/B hints are centered consistently.
- Selecting a quantity still grants the correct amount.

### Battle wrapping / paging

- Used-area catch denial remains inside the battle textbox.
- Longer Nuzlocke battle flavor wraps and advances cleanly without spilling outside the box.

### Nickname-aware World Building guard

- With Nickname Rule OFF, nickname-specific catch flavor must not appear. Ordinary catch flavor may still appear.
- With Nickname Rule ON, nickname-specific flavor may appear as designed.

## Known issues not claimed fixed by beta.26.6

- Oak/rival/story duplicate dialogue and spacing around the early game / Pokédex sequence.
- Yellow Viridian Mart first-entry Shop Clerk spacing.
- Fresh Yellow No Buying / No Selling now passes; fresh Red/Blue parity remains recommended because of older conflicting Blue evidence.
- Gold gameplay adapters remain individually runtime-test-required.

- Possible beta.26.2 Yellow performance lag, especially during battles: **OPEN / controlled A-B test required**.
