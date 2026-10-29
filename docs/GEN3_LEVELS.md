# Gen 3 LEVELS — level caps and EXP edging

This implements the two legacy LEVELS rules without changing the Gen 1/2
runtime or save keys. Configuration is kept inside `gen3_classic_v1.levels`.

## Menu

Start → NUZ MENU → NUZ RULES → LEVELS.

- **CAP SCOPE** cycles through NONE (0), GYMS (1), ELITE FOUR (2),
  CHAMPION (3), POSTGAME (4).
- **EXP EDGING** toggles independently; default OFF.
- CURRENT CAP and STAGE show the native badge/League progression result.
- PARTY BANK and BANKED MEMBERS show **party only**. Bank belonging to PC
  residents remains saved but does not count in these party totals.

Level caps only enforce when Nuzlocke Enabled is ON and the run has not
failed. With cap scope NONE, EXP awards are unchanged except that a saved
bank is released on the next EXP award if EXP Edging is ON.

## Scope semantics

| Scope | Behaviour |
| --- | --- |
| NONE | No cap |
| GYMS | First not-yet-earned Gym badge's boss ace; no cap after eight badges |
| ELITE FOUR | Includes Gyms; after eight badges, the next unbeaten Elite Four ace, then no cap after fourth E4 member |
| CHAMPION | Includes Gyms and E4, then Champion ace until Champion is beaten |
| POSTGAME | Includes Champion; after Hall of Fame use an explicitly provided postgame cap, otherwise unrestricted |

Boss caps per edition:

| Edition | Gym caps (badge order) | Elite Four | Champion |
| --- | --- | --- | --- |
| FireRed / LeafGreen | 14, 21, 24, 29, 43, 43, 47, 50 | 54, 56, 58, 60 | 63 |
| Ruby / Sapphire | 15, 18, 23, 28, 31, 33, 42, 43 | 49, 51, 53, 55 | 58 |
| Emerald | 15, 19, 24, 29, 31, 33, 42, 46 | 49, 51, 53, 55 | 58 |

Badge flags and native Elite Four / game-clear flags take precedence for
restored saves; ordered first-battle League trainer wins are also recorded
in the Nuzlocke save. Unknown edition or unreadable native badges means
**no cap is assumed**.

## EXP edging

The native Gen 3 `exp.gain` hook supplies the final composed amount. The
mod clamps applied EXP to one below the threshold for cap+1, preserving
`Experience.apply` for HP/stats/learnsets and UI presentation.

When EXP Edging is ON, all EXP above that threshold is saved in a per-Pokémon
bank keyed by personality and original trainer IDs (stable across evolution). That bank survives
PC transfers and reloads. On the Pokémon's next qualifying EXP award, once
the cap permits, stored EXP is added to the award (and subject to the new
cap). No extra battles are simulated. Switching EXP Edging OFF leaves
existing bank dormant instead of discarding it.

Rare Candy is blocked at or above the active cap through the native
`ItemUse.useRareCandy` path. Below cap it delegates unchanged.

## Other mods / postgame API

`mod.exports.gen3_levels` exposes `getRule`, `setRule`, `getCurrentCap`,
`getBank(mon)`, `scopes` and `setPostgameCap(levelOrNil)`.
A provider can explicitly set a cap from 1–100 or clear it with nil.
Nothing automatically sets a postgame value; POSTGAME is uncapped after
Hall of Fame without a provider.

The separate mod's usual `exp.gain` wrapper runs first through `next`.
Nuzlocke then applies its active cap to that composed amount.

## In-game testing (backed-up disposable save)

- [ ] **L01:** NONE allows native EXP and Rare Candy.
- [ ] **L02:** FireRed Gym 1 caps at 14. EXP must never cross level 14,
      even if a single wild/trainer battle awards much more than required.
- [ ] **L03:** EXP Edging OFF discards overflow; ON records overflow.
- [ ] **L04:** Earn the Boulder Badge. The active cap becomes Misty's 21.
      Another EXP award releases banked EXP without exceeding 21.
- [ ] **L05:** Move an edged Pokémon through PC storage, save, reload and
      withdraw. Its EXP bank is unchanged.
- [ ] **L06:** Rare Candy refused at cap without consumption; allowed below.
- [ ] **L07:** Switch modes 1 → 2 → 3 → 4 and verify Gym / E4 /
      Champion progression, including League flags after reload.
- [ ] **L08:** Repeat at least L02, L04 and L06 in Ruby, Sapphire and
      Emerald, validating their different Gym 2 and Gym 8 caps.
- [ ] **L09:** With mode POSTGAME after Champion, set a postgame cap via
      provider API; verify clearing the cap restores unrestricted EXP.
- [ ] **L10:** With Nuzlocke OFF, neither cap nor Candy restriction applies.

These tests need a real Gen1Recomp/ROM runtime. Passing Lua mocks does not
certify Gen 3 game behaviour. Enigma Berry or third-party item effects,
save migrations from unrelated level-cap providers, and unusual link /
battle-facility awards are not yet fully certified.
