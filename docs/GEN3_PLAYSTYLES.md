# Generation 3 playstyles — Shiny & Hardcore Nuzlocke

**Version:** v3.0.0-BETA · **Menu:** Start → NUZ MENU → NUZ RULES → PLAYSTYLES

The Playstyles menu contains only four rows, grouped into two adjacent
toggle-and-details pairs:

```text
SHINY NUZ: ON/OFF
  DETAILS: SHINY NUZ
HARDCORE: ON/OFF
  DETAILS: HARDCORE
```

Each DETAILS row opens a scrollable dedicated page containing the
requirements, capture restrictions, exceptions, level/item limits
and interoperability information for that playstyle. Press B to return
to the same toggle/details position; the details pages are read-only.

**SHINY NUZ** is an optional challenge variant. Default **OFF**. It is
enforced only while **CORE → NUZLOCKE** is ON and the run is active.

## Catch rules

1. **Only shiny wild Pokémon can be caught.** Throwing a Ball at a
   non-shiny always fails and shows **“Shiny Nuzlocke: only shiny Pokémon
   can be caught. Your route chance remains open.”** The normal native Ball
   use still occurs. The denial is also saved under RUN JOURNAL > EVENT HISTORY.
2. **Non-shiny encounters never use a route opportunity**, even with
   Failed Encounters Count ON. You can keep searching until you encounter
   an eligible shiny.
3. **An eligible shiny becomes that area's encounter.** If One Per Area
   and Failed Encounters Count are both ON, meeting an eligible shiny uses
   the route immediately, whether you catch it, KO it or flee.
4. With **Failed Encounters OFF**, a shiny encounter doesn't close its
   route unless it's successfully caught; you may search for another.
5. With **One Per Area OFF**, any number of eligible shinies may be caught,
   but non-shinies remain prohibited.
6. **Dupes and Roamer Clause still apply.** A shiny already excluded by
   Dupes is not an eligible route encounter. Roamer Clause retains the
   roamer's species-specific slot.
7. **Shiny Clause does not grant extra catches** while Shiny Nuzlocke
   is enabled, even when Shiny Clause is set to UNLIMITED. Otherwise the
   variant would effectively disable One Per Area. The Shiny Clause
   setting remains saved and becomes effective again when the playstyle
   is OFF.

### Important: Shininess versus shiny odds

Shiny Nuzlocke decides *what is legal to catch*. It does **not** change
shiny odds or automatically turn everything shiny. The optional
**CLAUSES → SHINY RATE** setting is separate (NATIVE, increased odds,
or ALWAYS). External shiny providers still own their effects where
supported; the playstyle checks the wild Pokémon's final native shiny
identity.

### Untamed Advanced and Random Wild

The challenge applies to **wild battles initiated by visible wandering
Pokémon** as well as normal step/fishing battles, provided the engine
emits a native Gen 3 wild battle and uses its ordinary `catch.rate`
transaction. Untamed still owns overworld rendering and chaining,
while Nuzlocke enforces the capture rule. Random Wild may remap species
without changing whether the individual is shiny.

With **both updated mods** installed, **CLAUSES → SHINY RATE** also
affects Untamed's ordinary **visible wandering wild Pokémon**, regardless
of whether Random Wild or Shiny Nuzlocke is enabled. The roll is made
at overworld spawn, before the sprite appears, using a real shiny
personality. The same personality is carried into battle and capture,
without a second Nuzlocke shiny roll when the wandering Pokémon is
touched. This means an overworld non-shiny does not suddenly become
shiny in battle. An already spawned Pokémon keeps its original result
even if the rate is changed while it remains on screen.

Untamed's own encounter-chain shiny bonuses remain active, and can
raise the final shiny chance above Nuzlocke's selected base rate.
Scripted encounters, roamers, Feebas, outbreaks and followers are not
changed by the new shiny spawn hook. Shiny-rate integration is inert
when Untamed is absent or the other mod hasn't been updated.

The playstyle does not restrict starters, gifts, Eggs, in-game trades
or scripted non-ball acquisition. Restricting those to shiny Pokémon
would be an additional challenge rule requiring a separate acquisition
hook; this version is specifically **shiny-only catching**.

## Save and compatibility

Playstyle state is stored at
`gen3_classic_v1.playstyles.shiny_nuzlocke` (default OFF).
It does not migrate or overwrite historical Gen 1/2 saves.

The switch is configurable during an active run, like other CORE
toggles, but switching it does **not** undo previously spent encounters
or un-catch non-shinies obtained before it was enabled. Changes are
refused once the Nuzlocke run is marked failed.

## Disposable ROM checks

- [ ] **S01:** CORE Nuzlocke ON, Shiny Nuz ON. See three ordinary wilds
      in the same route. Balls are denied with reason, and the route
      remains available even if Failed Encounters is ON.
- [ ] **S02:** Encounter a shiny in that route. With Failed Encounters ON
      the route is spent at battle start, even if you run/KO/miss it.
- [ ] **S03:** With Failed Encounters OFF, failing to catch a shiny does
      not spend the area; capturing one does.
- [ ] **S04:** After catching a shiny, another shiny in the same area
      cannot be caught, even if Shiny Clause is set to UNLIMITED.
- [ ] **S05:** Dupes Clause excludes shiny duplicates without consuming
      an unclaimed area.
- [ ] **S06:** One Per Area OFF permits multiple different shinies, but
      still denies non-shinies.
- [ ] **S07:** Turn off Shiny Nuz; ordinary catches behave as before.
      Turn off the CORE master; even a saved Shiny Nuz ON is inactive.
- [ ] **S08:** Set Shiny Rate to ALWAYS on a disposable save. Encounters
      are eligible if native shiny identification agrees. Turn it back
      to NATIVE on a new run for real shiny hunting.
- [ ] **S09:** With compatible Untamed-Advanced installed, shiny
      overworld wandering encounters can be captured and non-shiny
      wandering encounters cannot. Their sprites/battles match, and
      encounter chaining shows the actual species.
- [ ] **S09a:** Set Shiny Rate ALWAYS and spawn a normal wandering
      Untamed Pokémon. It should already have shiny colours/sparkle
      before battle, then remain shiny in battle and after capture.
- [ ] **S09b:** Set Shiny Rate NATIVE, let a non-shiny wandering
      Pokémon spawn, then switch the rate to ALWAYS before touching it.
      That existing Pokémon must remain non-shiny in battle.
- [ ] **S09c:** With a lower boosted rate, confirm normal wandering
      Pokémon remain normal when battled, with no surprise reroll.
- [ ] **S10:** Confirm save/reload preserves the toggle and its
      encounter history, and RUN JOURNAL > EVENT HISTORY shows denied-catch reasons.
- [ ] **S11:** Test FRLG, Ruby, Sapphire and Emerald separately, including
      an actual naturally shiny wild Pokémon.

Automated Lua smoke tests cover menu/state/hook policy. Native ROM,
battle animation, special encounters and external shiny-provider
interactions require in-game validation.

---

## Hardcore Nuzlocke

**Version:** v3.0.0-BETA · **Menu:** Start → NUZ MENU → NUZ RULES → PLAYSTYLES → **HARDCORE**

Hardcore is an optional **policy overlay**: enabling it never changes the
player's original CORE, LEVELS, or Options settings. It only enforces the
following while **CORE → NUZLOCKE is ON** and the run has not failed:

- **Permadeath**, **One Per Area**, **Failed Encounters Count**, and
  **Whiteout Ends Run** are effectively enabled, even if the original
  CORE toggles are OFF. Attempts to disable those options during an active
  Hardcore run are rejected. Any original OFF values are restored when
  Hardcore is disabled.
- **No bag items during battle, except Poké Balls**. Medicine, X items,
  Poké Dolls and battle-usable modded consumables are denied before their
  inventory can change. Poké Balls still use the existing Catch/Area/Shiny
  restrictions. Held items and overworld healing remain allowed.
- **SET battle style** is forced for normal trainer battles, so the game
  does not offer a free switch after the opponent's Pokémon faints. Normal
  player-chosen switches and forced switches remain available. The
  underlying game Options setting is untouched.
- **Boss level caps through Champion** apply even when LEVELS → CAP SCOPE
  is NONE, preserving existing EXP and Rare Candy protections. The player's
  original cap scope and EXP Edging preference remain saved. The familiar
  game's edition, badges and league progress determine caps.

Hardcore works alongside **Shiny Nuzlocke**. If both are ON, only shiny
Pokémon may be captured, and the first eligible shiny is subject to
Hardcore's One Per Area and Failed Encounters rules. Shininess odds remain
controlled separately under CLAUSES → SHINY RATE.

**Exclusions/limits:** Hardcore does not affect trading, gifts, scripted
acquisitions, or player-held items. The current level-cap system caps EXP
and blocks Rare Candy; it does not yet remove a previously over-levelled
Pokémon from the battle party. Forced SET applies through the native
battleStyle query and should be confirmed in a real trainer battle.
Multiplayer/tutorial battle item interactions are excluded. No existing
save schema is replaced; playstyle state is
`gen3_classic_v1.playstyles.hardcore_nuzlocke` (default OFF).

### Hardcore ROM test checklist (disposable save)

- [ ] **H01:** Set CORE → NUZLOCKE ON, switch Permadeath, One Per Area,
      Failed Encounters and Whiteout OFF, then enable Hardcore. The CORE
      page displays **FORCED ON**; an attempt to turn a forced rule OFF
      shows an explanation.
- [ ] **H02:** In trainer battle, opponent's first Pokémon faints. The
      game sends its next Pokémon with no SHIFT prompt (even if saved
      Options → Battle Style says SHIFT).
- [ ] **H03:** In battle, attempt Potion, X Attack, Poké Doll and Revive.
      They cannot be used and are not removed from the bag; no turn lost.
      A wild Poké Ball remains usable (subject to catch rules).
- [ ] **H04:** Set LEVELS scope NONE then enable Hardcore. The cap
      becomes Brock's ace (FRLG Lv14) or the local first Gym's ace.
      EXP stops at cap and Rare Candy cannot exceed it.
- [ ] **H05:** On a disposable save after earning eight badges, caps
      progress through the Elite Four and Champion.
- [ ] **H06:** With Failed Encounters originally OFF, flee an eligible
      first wild encounter. Hardcore consumes the route anyway.
- [ ] **H07:** A fainted Pokémon retires and a whiteout loses the run
      while Hardcore is enforced, even if the underlying rules were OFF.
- [ ] **H08:** Turn Hardcore OFF. Previously saved CORE toggles, LEVELS
      scope and SHIFT style resume without requiring a restart.
- [ ] **H09:** Enable Shiny and Hardcore together: normal wilds do not
      spend a route, first eligible shiny does.
- [ ] **H10:** Turn Nuzlocke master OFF while Hardcore is toggled ON:
      normal battle items, SHIFT and original level settings apply.
- [ ] **H11:** Check FRLG, Ruby, Sapphire, Emerald and, separately,
      Untamed-Advanced wandering wild battles.

Automated Lua smoke tests validate policy overrides, native battle item
transaction guards, SET-style query behaviour, level caps, and restoration.
They cannot certify full ROM rendering or progression.
