# Gen 3 Nuzlocke — Game Difficulty

**Version:** v3.0.0-BETA  
**Menu:** NUZ MENU → NUZ RULES → GAME DIFFICULTY.  
**Save namespace:** `gen3_classic_v1.difficultyRules.difficulty_profile`.

## Overview

Gen 3 has its own battle engine and **EVs / IVs**, rather than the
Gen 1/2 Stat EXP / DV rules. Accordingly, this selector has 16
**Gen 3-specific profiles** (stable IDs 0–15). They are **not claimed
to be exact ports of any legacy Gen 1/2 difficulty preset**.

Difficulty is **independent** of the Nuzlocke master switch. It can
remain ON while CORE Nuzlocke is OFF and changes **future native NPC
trainer battles only**, never existing Pokémon, saved trainer assets
or ROM data. VANILLA (ID 0) is the default and passes through all
native values unchanged.

## Profiles

| ID | Name | Ordinary trainer levels | Boss levels | Minimum opponent IV/stat | Minimum EV/stat | AI tier |
|---:|---|---:|---:|---:|---:|---:|
| 0 | VANILLA | +0 | +0 | unchanged | unchanged | native |
| 1 | NUZ MEDIUM | +1 | +2 | 8 | 16 | 1 |
| 2 | NUZ HARD | +2 | +4 | 16 | 32 | 2 |
| 3 | NUZ EXPERT | +3 | +6 | 24 | 48 | 3 |
| 4 | NUZ MASTER | +5 | +8 | 31 | 64 | 4 |
| 5 | BOSS MEDIUM | unchanged | +3 | 8* | 16* | 1* |
| 6 | BOSS HARD | unchanged | +5 | 16* | 32* | 2* |
| 7 | BOSS EXPERT | unchanged | +7 | 24* | 48* | 3* |
| 8 | BOSS MASTER | unchanged | +10 | 31* | 64* | 4* |
| 9 | TACTIC MEDIUM | +0 | +0 | 8 | unchanged | 1 |
| 10 | TACTIC HARD | +0 | +0 | 16 | unchanged | 2 |
| 11 | TACTIC EXPERT | +0 | +0 | 24 | unchanged | 3 |
| 12 | TACTIC MASTER | +0 | +0 | 31 | unchanged | 4 |
| 13 | FULL MEDIUM | +2 | +4 | 16 | 32 | 2 |
| 14 | FULL HARD | +4 | +7 | 24 | 48 | 3 |
| 15 | FULL MASTER | +6 | +10 | 31 | 85 | 4 |

*BOSS presets affect boss-class trainers only; ordinary trainers
remain completely native.*

Boss-class detection uses the composed trainer's class name and
recognises Gym Leaders, Elite Four, Champions, rival classes,
Aqua/Magma Leaders and recognised Boss classes. Missing or
ambiguous boss metadata **fails open** to ordinary-trainer scaling
rather than guessing an identity.

- **Levels** are raised without exceeding level 100.
- **IVs** are raised to the chosen per-stat floor when weaker; existing
  stronger IVs remain unchanged. Maximum 31 per stat.
- **EVs** are raised to the selected even per-stat floor when legal.
  Their distribution must not exceed 510 total; if a custom trainer
  already has an unusual high-EV distribution that would exceed the
  cap, its existing EV distribution is kept.
- **AI** uses the native Gen 3 trainer AI flags, merging the profile
  bits with the existing flags rather than replacing those flags.
  Tier 1 adds bad-move checks; tier 2 adds viability and faint logic;
  tier 3 adds strong-move preference; tier 4 adds first-turn setup
  and HP-aware logic. Emerald's `CHECK_VIABILITY` and
  `TRY_TO_FAINT` bit positions are handled separately from FRLG/RS.
- **Moves** are left as the trainer's composed data supplied them.
  If there is no explicit moveset, the native engine still generates
  moves at the new level. This release does **not** rewrite existing
  authored movesets, item loadouts, abilities, species, personalities,
  rival choices or trainer roster counts.

## Composition and safeguards

1. Gen1Recomp composes the opponent party (including the Nuzlocke
   randomiser's `trainer.party` hook and other supported provider
   hooks) before calling native `Battle.start`.
2. The difficulty layer **clones** the final trainer descriptors.
   It never mutates the underlying trainer roster or anyone else's
   provider-owned table.
3. The existing **Gym Team Size** rule checks the final composed
   party count. Difficulty increases team strength but does not
   manufacture new teammates.
4. Existing **Pokémon Stats** rules are applied afterward. If Perfect
   Trainer IVs or a specific Trainer Starting EV preset is enabled,
   those explicit Nuzlocke values take precedence over difficulty's
   floors.
5. The native Gen 3 battle engine generates final battle stats,
   nature, personality and AI from those cloned descriptors.
6. **Wild, Safari, link, tutorials, facilities and special challenge
   battles** do not receive difficulty boosts. Rival classes keep
   their original party species.

Explicitly annotated external difficulty owners
(`externalDifficulty` / `difficultyProvider` on the battle or
opponent descriptor) prevent this scaler from running. Other
third-party difficulty mods that do **not** identify themselves
may still have compounding effects. Those combinations require
separate compatibility testing; they are **not** assumed safe.

Selecting a profile changes upcoming battles; it does not silently
rebuild an active fight or modify already acquired Pokémon.

## Manual test matrix

1. **GD01 — Vanilla:** Select VANILLA. Compare a fresh NPC trainer's
   exact levels, AI flags, IVs, EVs and team size against the
   unmodified game.
2. **GD02 — Standard:** Choose NUZ MEDIUM, fight a normal trainer
   and verify +1 level and IV floor 8 / EV floor 16. Fight a Gym
   Leader and verify +2 levels.
3. **GD03 — Hard tiers:** Verify NUZ HARD/EXPERT/MASTER apply their
   configured values and clamp level 100 correctly.
4. **GD04 — Boss-only:** Choose BOSS MEDIUM. Ordinary trainer party
   must be unchanged. The Gym Leader party receives +3 levels,
   IV floor 8, EV floor 16, AI tier 1.
5. **GD05 — Tactical:** Choose TACTIC MASTER. Levels and EVs stay
   native while IV and AI enhancements apply.
6. **GD06 — Full Master:** Verify +6 ordinary and +10 boss levels,
   six 31 IVs, 85 EVs in each stat (total 510), and AI tier 4.
7. **GD07 — Rival identity:** Confirm rival trainer species and
   version-specific trainer rosters do not change unless the
   separate Randomiser rule changes them.
8. **GD08 — Randomiser:** With Random Trainers enabled, verify
   species randomisation happens first and difficulty applies
   to the *final* NPC party rather than the original slot.
9. **GD09 — Gym Team Size:** Set Gym Team Size ON. Its refusal
   threshold must follow the live opponent party count, unaffected
   by difficulty's level and stat changes.
10. **GD10 — Stats override:** Set a nonzero Trainer Starting EVs
    and Perfect Trainer IVs in Advanced Rules. Their explicit
    values must override the difficulty EV/IV floors.
11. **GD11 — Nuz master OFF:** Turn CORE Nuzlocke OFF while leaving
    the difficulty profile active. Trainer boosts must still apply;
    permadeath, Gym Team Size, and other Nuz-only rules must not.
12. **GD12 — Save:** Save/restart and confirm the profile persists.
    Switch back to VANILLA and compare the *next* trainer battle.
13. **GD13 — Editions:** Repeat normal trainer, Gym Leader, rival
    and AI decisions in FireRed, LeafGreen, Ruby, Sapphire and
    Emerald. Pay particular attention to Emerald AI bit positions.
14. **GD14 — Provider compatibility:** Test a third-party trainer
    difficulty provider separately. Ensure explicitly owned
    difficulty avoids double scaling and report providers that
    lack an ownership marker.
15. **GD15 — Link and facilities:** Confirm link, Battle Tower,
    Frontier, Secret Base, Safari, tutorial and other excluded
    battles remain unchanged.

The automated CI checks the 16 profiles, saved values,
immutable trainer descriptors, 510-EV ceiling, edition-aware AI
bits, provider opt-out, menu navigation and runtime wiring.
**Actual ROM-level playtesting is still necessary**, especially
for AI script behaviour and third-party provider combinations.
