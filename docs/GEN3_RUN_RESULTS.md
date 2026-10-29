# Gen 3 — End Run, Hall of Fame & final results (v3.0.0-BETA)

This feature is isolated to Gen 3 (FireRed/LeafGreen and Ruby/Sapphire/
Emerald). It does **not** change the Gen 1/2 UI or the native Hall of Fame
progression.

## Finishing a run

From **Start → NUZ MENU → END RUN**, select **CONFIRM END RUN**.
An explicit confirmation states that the action cannot be reversed.
**KEEP PLAYING** or B returns to gameplay without changing the run.

Manual End Run finalises as a **FORFEIT** (loss). On confirmation the mod:
1. Builds a frozen results snapshot with the party, graveyard,
   encounters, catches, location, badge count, play time, trainer,
   Pokémon species/nicknames, levels and available saved stats.
2. Marks the Nuzlocke as failed, recording `finalResult` in the existing
   `gen3_classic_v1` mod save namespace.
3. Calls the **native Gen 3** `game:saveGame()` once. The raw
   `Game3` service exposed through `mod.game` does **not** implement
   the Gen 1/2 `writeSave()` method. The native Gen 3 writer persists
   script flags, the live party and normal mod-data fields using the
   standard save hooks and save pipeline.
4. Opens a dedicated full-screen Gen 3 results UI.

If a native battle ends with a whiteout/no usable survivors and the
configured rules fail the run, exactly the same snapshot/autosave flow
starts automatically **after battle party writeback and faint retirement**.
A whiteout rescued by an allowed living PC survivor does not automatically
end the run; the existing Hardcore/CORE survival policy stays authoritative.

A failed / forfeited save is **terminal**: using CONTINUE to load the native
save immediately reopens the results screen, not the ordinary Nuzlocke
menu. The terminal screen is kept above game UI layers after map enters
and world steps. Pressing B/START cannot dismiss its root page. Available
actions are reading statistics, reading the final roster/graveyard,
exporting memorial PNGs, retrying a failed save and **QUIT TO TITLE**.
There is no CONTINUE ADVENTURE for a loss.

The native save is **kept** and can be loaded to view and export the
records again. The feature never deletes native saves.

An unsuccessful auto-save is **not** reported as successful: the results
screen shows **AUTOSAVE FAILED**, and **RETRY / SAVE RUN** attempts the
native write again. Ensure that write is successful before exiting.

## Champion victory

When the engine's Hall of Fame screen **closes after genuine induction**
(`session.game_cleared` and at least one native HoF entry present), a
Nuzlocke run creates a permanent **VICTORY** snapshot and saves it through
`game:saveGame()`. Merely winning an ordinary trainer fight does not
count, and the engine keeps control over credits and normal HoF effects.

The victory results screen contains:
- **RUN STATISTICS** — time, trainer/region, badges, claimed areas,
  successful catches, used encounters, deaths, shiny exceptions, outcome.
- **FINAL PARTY** — the team remaining at HoF, by nickname/species,
  level, stats, and moves where available.
- **GRAVEYARD / IN MEMORIAM** — every recorded permanent death, with
  captured nickname/species/level, cause, location, and preserved
  pre-retirement archive stats where available.
- **SHARE PARTY PNG** — an exportable party image using the native
  game’s Pokémon front sprite assets where available.
- **CONTINUE ADVENTURE** — dismisses the results, leaving native credits/
  postgame progression intact.
- **QUIT TO TITLE** — returns to the game's title menu.

A victory does *not* set `failed`. The result is snapshotted once and
can be reopened from **END RUN** later without ending postgame play.
Starting a genuinely new game starts a fresh run record.

## PNG export

Select **SHARE COMPLETE RUN PNG** from the final results screen, whether
the outcome is VICTORY, FAILED or FORFEIT. The menu saves **one complete
poster** rather than splitting the graveyard into pages.

The image contains all three sections on a single canvas:

1. **RUN STATISTICS:** trainer, result, region, date, time played,
   badges, catches, fallen Pokémon, encountered areas, used slots,
   run-ending reason, shiny exceptions.
2. **FINAL PARTY:** all Pokémon remaining in the party when the
   run finished, with their native front sprites, names, species,
   level, HP, available combat stats, and an explicit SHINY/NORMAL
   marker (UNKNOWN when legacy data cannot be verified). Confirmed
   shiny Pokémon use the native `Pokemon.frontPic` shiny-palette
   selector directly, not a reconstructed Pokémon's OT-dependent
   shiny roll.
3. **IN MEMORIAM:** the **entire** graveyard, also with sprites,
   nicknames, species, levels, recorded combat stats, areas and
   causes of death, including shiny status. Empty sections are
   explicitly labelled.

The poster is 1200 pixels wide, with **height automatically calculated**
from the total Pokémon count. Three Pokémon cards are drawn per row.
Unlike the previous exporter, there is **no PAGE N/M menu** and the
player does not have to export multiple PNGs for an eight-Pokémon
graveyard. Missing data is labelled instead of inventing statistics.

The PNG goes directly into the game's **LÖVE save directory**:

`nuzlocke_<trainer>_<result>_<date>_FULL.png`

The mod sandbox blocks `love.filesystem`, so the PNG is saved through
the supported `ImageData:encode("png", filename)` API.
Nothing is uploaded to an external site. If an extremely large
graveyard would exceed the current GPU's maximum texture size, the
export reports a clear error rather than silently truncating deaths.

### Expanded species and alternate-form names

When National Dex Gen 3 is installed, Nuzlocke uses the mod's public
`listSpecies` / `listForms` metadata to resolve the exact saved species
slot. The Graveyard, encounter tracker and final-results details/PNG show
labels such as **Hisuian Zorua**, **Galarian Darmanitan (Standard)** or
**Rotom (Heat)** instead of silently reverting to the base species name.
Nicknames remain unchanged and Nuzlocke never rewrites species IDs.

New memorial records preserve their resolved species label as a fallback.
Older graveyards and final results are resolved at display time when the
provider is present, without modifying the completed run. With the provider
disabled or missing, previously stored labels and standard ROM-backed names
continue to work.

### Shiny artwork

Gen 3 has no dedicated shiny mini-icon sprites. **Both shiny and
normal Pokémon use the standard native mini-icons in PC boxes and party
slots.** No resized battle sprites are substituted for mini-icons.
Confirmed shiny Pokémon still use the ROM's extracted
`pokemon/front_shiny/<species>.rgba` artwork in the complete-results
PNG and native PC portrait.

This bypasses the potentially stale/misresolved normal front-sprite
cache by reading the ROM's shiny-palette RGBA directly through the
engine's Dataset cache and converting it into a LÖVE image in memory.
No ROM rewriting, base-game PR or filesystem permission is needed.
Special personality-dependent forms such as Spinda use the native shiny
sprite selector as a fallback. Unavailable shiny assets fall back to
native rendering rather than inventing colours.

## Compatibility / caveats

- The Nuzlocke CORE rule must be enabled for End Run. Players without an
  active Nuzlocke do not accidentally forfeit a casual save.
- Full loss screens depend on the mod's existing whiteout/permadeath
  policy. If the policy allows continuing, the game does not force loss.
- The original graveyard is not discarded. Results copy small, bounded
  display snapshots; they are *not* revival sources or substitutes for
  the full existing graveyard archives.
- If an older save is already marked `failed` but has no final snapshot,
  a terminal results summary is created on load. Historic Pokémon stats
  not present in that older save remain unknown rather than invented.
- A result created once is never overwritten by later game progression
  or repeat Hall of Fame ceremonies. On an existing ended save, the
  display can repair older missing shiny flags using the original
  matching Pokémon archive (same species and personality). Unverifiable
  historic flags remain UNKNOWN instead of being reported as normal.
- The PNG card reads the native `Pokemon.monFrontPic` art available
  in the running ROM. The output may differ between FRLG and RSE.

## Manual in-game checklist

- [ ] **ER01** FireRed: choose END RUN, cancel once, then confirm. No
  save/result may be written on cancel; confirmation writes a save
  and displays FORFEIT.
- [ ] **ER02** Quit to title, use CONTINUE, verify that results appear
  immediately and pressing B/START cannot resume movement, menus,
  battling or game actions.
- [ ] **ER03** Trigger a whiteout under CORE/HARDCORE run-failure
  conditions. Confirm all fallen Pokémon appear in the memorial,
  the native save is written, and reload remains terminal.
- [ ] **ER04** Trigger a whiteout with PC Survivor rescue enabled and
  an eligible living PC Pokémon. Verify no false finalisation.
- [ ] **ER05** Deny native `save.write` intentionally: failure is visible,
  retry is available, and no false 'saved' confirmation is shown.
- [ ] **ER06** Beat the FRLG Champion, complete HoF induction, inspect
  the final six-Pokémon team and continue through native postgame.
- [ ] **ER07** Repeat for Ruby/Sapphire/Emerald. Verify native credits,
  flags and Hall of Fame save state are not suppressed.
- [ ] **ER08** Export the single complete run poster for victory
  and loss. Verify its 1200-pixel width and dynamic height, readable
  summary, final party, and **all** graveyard Pokémon (including
  eight or more deaths) in the same exported file.
- [ ] **ER09** Load an old `failed=true` save without `finalResult`;
  confirm a retrospective memorial appears without inventing metadata.
- [ ] **ER10** Save after victory, reload and use END RUN to inspect the
  stored Champion results without ending the continued adventure.

## Automated tests

- `tests/gen3_run_results_smoke.lua` exercises policy snapshots, loss
  lock, victory continuation, record navigation, the single poster
  export, native sprites, the full graveyard and run statistics.
- `tests/gen3_run_results_runtime_smoke.lua` exercises the actual
  Gen 3 runtime callback wiring: End Run confirmation, native
  `saveGame`, failed CONTINUE reload, battle whiteout and HoF close.
- Both run in `.github/workflows/gen3-smoke.yml` with Lua 5.1.
