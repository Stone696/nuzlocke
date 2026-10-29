# Gen 3 — Advanced Battle Clauses

**Release:** Nuzlocke v3.0.0-BETA  
**Menu:** Start → NUZ MENU → NUZ RULES → ADVANCED RULES → BATTLE CLAUSES

Seven battle clauses are implemented, default OFF, and saved in the
existing `gen3_classic_v1` state under `battleClauses`.
They require **CORE → NUZLOCKE ON**. The older Gen 1/2 implementation
remains unchanged.

| Rule | Values | Behaviour |
| --- | --- | --- |
| OHKO Clause | OFF / ON | Both sides' native one-hit KO moves (Guillotine, Horn Drill, Fissure, Sheer Cold) fail after their normal PP cost, before OHKO damage. This also applies when called through another move. |
| Flinch Clause | OFF / SELF / ENEMY / ALL | Suppresses move-caused flinches, including King's Rock's shared effect path. The damaging hit is preserved. |
| Trap Clause | OFF / SELF / ENEMY / ALL | Suppresses the partial-trapping `WRAP` effect (Wrap, Bind, etc.) while preserving the move's initial damage. |
| No Setup Moves | OFF / SELF / ENEMY / ALL | Suppresses move-caused positive stat-stage changes. |
| Evasion Clause | OFF / ON | Suppresses positive evasion stages for both sides, including Minimize's special volatile state. |
| Accuracy Drops | OFF / SELF / ENEMY / ALL | Suppresses move-caused negative accuracy stages, not other stat changes. |
| Other Stat Drops | OFF / SELF / ENEMY / ALL | Suppresses move-caused negative stages other than accuracy. |

Scope values are defined by **the Pokémon causing the effect**, not
the affected Pokémon: SELF = the player's side; ENEMY = opponents;
ALL = both. Evasion Clause is symmetric.

OHKO is handled at the native move-context accuracy boundary: the
one-hit KO resolver calls it **after** displaying the move and spending
PP, but **before** rolling OHKO damage. The mod returns the native
failed-move path only for effect ID 38 while the clause is enabled.
It does not alter the stored move, the move power, PP consumption,
damage calculation, or the ROM. All OHKO moves are covered by effect
type, including those called by Metronome and similar effects.
It has no effect when CORE Nuzlocke is disabled or the run has ended.

The other six clauses intercept the Gen 3 engine's existing
`battle.effects.secondary.set` and `changeStat` functions and the
native Minimize effect dispatcher, without changing ROM move definitions,
damage calculation, PP use, or the native battle turn resolver.
Only effects whose move source is known are scope-filtered; unrelated
stat changes (e.g. certain passive ability/item effects) are left native.

This work does not introduce new public Gen1Recomp hooks.
As with other Gen 3 beta mechanics, smoke coverage tests the relevant
native-shaped calls but **in-game ROM verification is still required**
for all five Gen 3 editions, especially multi-target stat changes,
King's Rock, and unusual scripted or provider-owned effects.

## Manual tests (disposable save)

1. Open the Battle Clauses menu. Check that OHKO toggles OFF/ON and
   the other six rules cycle correctly. Save/reload and verify persistence.
   With OHKO ON, Guillotine, Horn Drill, Fissure and Sheer Cold must
   fail for both sides, spending PP once but causing no damage or faint,
   even with Lock-On/Mind Reader or when called by Metronome. The
   native behaviour must return immediately when OFF or Nuzlocke OFF.
2. Enable Flinch Clause = SELF. Attack with Headbutt/Bite or King's
   Rock. Damage should apply, but the opposing Pokémon should never
   flinch from the player's move. ENEMY should reverse whose moves
   are filtered, and ALL should affect both.
3. Enable Trap Clause = SELF. Hit with Wrap/Bind/Clamp/Fire Spin:
   damage should remain, but the foe should not receive partial
   trapping turns. Test ENEMY and ALL too.
4. Enable No Setup Moves = SELF. Swords Dance and Dragon Dance should
   not raise the player's stages. ENEMY should block the foe's setup,
   while damage from damaging moves should remain.
5. Evasion Clause = ON must prevent Double Team's evasion increase and
   Minimize's evasion **and** minimized state on either side.
6. Accuracy Drops = SELF should suppress Sand-Attack accuracy loss
   caused by the player, but not other stat drops. Test ENEMY and ALL.
7. Other Stat Drops = SELF should suppress Growl/Tail Whip's non-accuracy
   reductions caused by the player while preserving accuracy changes.
   Damaging moves with stat secondary effects must still inflict damage.
8. Turn CORE → NUZLOCKE OFF and confirm all native effects work again,
   while stored rule selections remain unchanged. Verify an ordinary
   item/ability-induced stat change still functions when move-only
   restrictions are ON.

Do not treat automated CI as proof of ROM-level compatibility. The
engine is responsible for native graphics and messages; if an effect
is suppressed, the Pokémon's final status/stages must be inspected
rather than relying on battle animations alone.
