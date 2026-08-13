# Testing beta.27.16

## Automated release gate

From the package directory:

```sh
node tests/release_gate.js main.lua /path/to/Gen1Recomp
fengari tests/smoke.lua main.lua
```

The engine path is optional for the Node gate. When provided, it checks every registered public hook/event against the engine source and verifies the Gold battle/title contracts. The smoke test uses Fengari or another Lua 5.1-compatible interpreter and does not require game assets.

Final package result:

- Lua compile/load check: PASS
- luaparse syntax check: PASS
- release gate: PASS, 66 checks
- headless interaction smoke: PASS, 49 checks
- manifest JSON parse: PASS
- ZIP integrity and packaged SHA-256 verification: PASS

## Manual disposable-save gate

Automated tests cannot validate rendering, timing, story VM pacing, controller flow, or destructive save consequences. Before a stable tag, use disposable saves and check:

### R/B/Y

- Fresh title shows Setup; a detected save shows Continue without Setup.
- Each preset stages and commits the expected complete rule profile.
- First Rival forgiveness ON/OFF and Hardcore behavior.
- First Catch, Failed Encounters, Dupes SPEC/FAM, and Shiny interactions.
- Route cardinal, Mt. Moon, and Safari toggles update legality and every tracker surface immediately in both directions.
- Maximum BST, MissingNo/glitch, static, gift, trade, legendary, mythical, and Solo acquisition interactions.
- No Escape, item-use rules, Ball Use tiers, shops, Center/Mom healing, Whiteout, and Permadeath. Confirm ULTRA permits Master, STANDARD blocks all four standard Balls but permits recognized specialty/custom Balls, and ALL blocks both groups.
- Trainer-overhaul levels appear identically in enforcement, NUZ STATUS, Trainer Card, tracker, Gym Guide, EXP, and Rare Candy behavior.
- World Building tiers do not duplicate a beat, combine vanilla/mod text incorrectly, or introduce spacing errors.

### Gold

- Fresh title shows Setup; any detected Gold save hides Setup.
- Starter and opening Rival flows complete without story softlocks. With Nickname Rule ON, the starter naming screen must reject empty/all-space names and resume Elm's script only after a non-empty name; with the rule OFF, vanilla acquisition continues.
- An ordinary wild catch cannot decline Nickname Rule when ON, while the normal YES/NO and empty-name behavior remains available when OFF.
- Permadeath and Whiteout ON/OFF on disposable saves.
- Ordinary catch, failed encounter, Dupes/Shiny, BST/glitch, and static capture policy. Verify Sudowoodo and at least one `loadwildmon` legendary/static encounter show the No Static refusal before a Ball is spent.
- Game Corner wager/prize bans and allowed coin-vendor/story paths.
- Ball Use Ban, No Escape, buying, and selling at their pre-mutation points. Confirm tier 4 is labeled STANDARD, blocks Poke/Great/Ultra/Master, permits an Apricorn Ball, and never tells the player to find a stronger Ball.
- Full Johto Gym → Elite Four → Lance → Kanto Gym → Red level-cap ladder.
- Modified boss parties update all cap displays and enforcement without restarting the run.
- NUZ STAT, Tracker, Catch Info, and native Gold Trainer Card remain navigable.

## Safety

Whiteout intentionally deletes the active run when enabled. Always use a disposable save or external backup for that test. Do not treat a headless PASS as authorization to test destructive rules on the only copy of a valued save.
