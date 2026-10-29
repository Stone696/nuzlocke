# Gen 3 Nuzlocke — Advanced Rules: Area Splits

**Version:** v3.0.0-BETA  
**Menu:** NUZ MENU → NUZ RULES → ADVANCED RULES → AREA SPLITS.

## Why this exists

A **native map** and a **named location** are not always the same thing.
In FireRed/LeafGreen, Mt. Moon 1F/B1F/B2F and Rock Tunnel's floors
are separate native maps. Gen 1/2-style Area Splits rules cannot just
be copied: Gen 3's native encounter ledger already treats them as
separate **by default**.

To avoid silently granting or removing historical encounters, the new
`area_scope` defaults to **NATIVE MAP**. A player can opt into one
slot per **named location** or per **floor**. Per-region and per-location
overrides refine that choice.

## Settings

| Setting | Default | Meaning |
| --- | --- | --- |
| Area Scope | NATIVE MAP | **NATIVE MAP:** established one-per-native-map behaviour; **ONE/LOCATION:** one slot across an entire named cave/building/dungeon; **PER FLOOR:** one slot for each recognised floor, not one per incidental puzzle room |
| Route 2 North/South | OFF | FRLG Route 2 can use separate northern and southern slots |
| Route 10 North/South | OFF | FRLG Route 10 split across Rock Tunnel access |
| Route 20 West/East | OFF | FRLG Route 20 split across Seafoam Islands access |
| Route 21 North/South | OFF | With ONE/LOCATION or PER FLOOR scope, join the two native Route 21 maps; ON keeps their native north/south split |
| Mt. Moon | FOLLOW SCOPE | Override the global scope with ONE LOCATION or PER FLOOR |
| Safari Zone | FOLLOW SCOPE | ONE ZONE, PER AREA, UNTIL CATCH (whole zone), AREA+CATCH (per region until catch) |
| Kanto Dungeons | FOLLOW SCOPE | Force ONE LOCATION or PER FLOOR for Kanto dungeon families |
| Sevii Dungeons | FOLLOW SCOPE | Force ONE LOCATION or PER FLOOR for Sevii dungeons |
| Hoenn Dungeons | FOLLOW SCOPE | Force ONE LOCATION or PER FLOOR for Hoenn dungeons |

**Gen 2 only** Time Split and Headbutt Split remain visible as
unavailable in the Gen 3 menu. Neither fabricates a Gen 3 mechanic.

### Supported locations

Only the explicitly recognised multi-map families are grouped. This
deliberately excludes generic towns, city buildings, route houses,
Pokémon Centres, cave entrances not belonging to a known dungeon,
and story interiors merely sharing a regional map-section ID.

**Kanto (FRLG):** Mt. Moon, Rock Tunnel, Seafoam Islands,
Victory Road, Pokémon Mansion, Cerulean Cave, Pokémon Tower,
Diglett's Cave, Silph Co., Rocket Hideout, S.S. Anne.

**Sevii (FRLG):** Mt. Ember and its Ruby Path, Icefall Cave,
Dotted Hole, Lost Cave, Navel Rock, Altering Cave.

**Hoenn (Ruby, Sapphire, Emerald):** Meteor Falls, Granite Cave,
Shoal Cave, Mt. Pyre, Cave of Origin, Seafloor Cavern, Sky Pillar,
Victory Road, New Mauville, Fiery Path, Abandoned Ship, Mirage
Tower, Desert Ruins, Island Cave, Ancient Tomb, Aqua Hideout,
Magma Hideout, Artisan Cave, Desert Underpass, Marine Cave,
and Terra Cave. Some locations exist only in specific editions.

**Route 21:** FRLG contains distinct `FR_ROUTE_21_NORTH` and
`FR_ROUTE_21_SOUTH` map identities. ONE/LOCATION combines them
unless its explicit split is ON.

### Floor and room interpretation

PER FLOOR groups all rooms on a named floor under the same key:
`FR_MT_MOON_1F` and `FR_MT_MOON_B1F` are different floors;
`RU_METEOR_FALLS_1F_1R` belongs to **Meteor Falls 1F**.
Unnumbered rooms in the same dungeon share the **MAIN** label
rather than each receiving a catch. In particular, Lost Cave's
room-numbered puzzle chambers are not 14 separate free catches.

Specific variants such as **Shoal Cave at LOW TIDE/HIGH TIDE**
can use separate named groups in PER FLOOR mode. The underlying
native map must actually exist in the edition.

The active scope affects the area **ledger key** only. It does not
change ROM map data, wild encounter tables, species, animations,
navigation, map-section IDs, randomiser output or Untamed spawns.

## Route halves: practical limitation

Routes 2, 10 and 20 are **single native map IDs** in FRLG. There is
no pre-existing north/south or west/east map boundary to inherit.

Their optional splits classify the player's native coordinates using
the map's **geometric halfway line** (Y for Routes 2 and 10, X for
Route 20). This is a deterministic initial implementation, **not**
an exact terrain/entrance-based cut validated against every tile.
If coordinates or dimensions are unavailable, the policy keeps the
original native map key instead of guessing.

**These three route cuts specifically require ROM-level testing** on
both sides of Viridian Forest, Rock Tunnel and Seafoam Islands.
If the midpoint falls in traversable grass/water on a particular
map, it may divide that route imperfectly; calibrated boundaries
can be introduced later after checking actual native layouts.

## Safari Clause

- **FOLLOW SCOPE:** native Safari subareas when NATIVE MAP is
  selected, one whole zone at ONE/LOCATION, one slot per named
  Safari section at PER FLOOR.
- **ONE ZONE:** one encounter for the entire Safari Zone.
- **PER AREA:** centre/east/north/west in FRLG and the recognised
  native Safari subarea identifiers in Hoenn.
- **UNTIL CATCH:** one whole Safari Zone encounter slot. Fleeing,
  failed throws and battles that end without capture do not spend it,
  even if Failed Encounters is ON.
- **AREA + CATCH:** same until-catch rule, but independent by
  Safari subarea.

Safari rules govern encounter accounting. They do not refill Safari
Balls, alter the step counter, guarantee a capture, or bypass
species bans or the one-catch limit.

## Save safety and migrations

All controls persist under `gen3_classic_v1.areaSplitRules`.
Defaults are conservative. Existing `s.areas[mapId]` records remain
exactly where they were.

A **projection** checks historical spent keys before permitting
a new encounter. For example:

- A previously spent `FR_MT_MOON_1F` blocks the entire Mt. Moon
  when ONE LOCATION is selected.
- A previously spent whole-Mt.-Moon key prevents gaining a free
  B1F encounter by subsequently switching to PER FLOOR.
- If only 1F was previously spent and the player switches to
  PER FLOOR, a never-used B1F remains legitimately available.
- A pre-split Route 2 claim blocks both new halves. Disabling the
  route split after catching on one side does not reset Route 2.
- A previously used Safari subarea counts against the entire Safari
  Zone if grouped later.

The tracker displays human-readable **location and floor** labels
for new keys; the Nuz Dev **EDIT CURRENT AREA** action edits the
current effective split key. Existing raw records remain editable
from EDIT ALL AREAS.

## Manual in-game checklist

1. **AS01 — Default:** Existing run with a consumed Mt. Moon 1F
   remains unchanged with NATIVE MAP. No save migration deletes
   or renames its entry.
2. **AS02 — Mt. Moon shared:** Set Mt. Moon = ONE LOCATION,
   spend 1F, then try B1F/B2F. No second encounter is available.
3. **AS03 — Mt. Moon floors:** Set Mt. Moon = PER FLOOR.
   Newly reached 1F/B1F/B2F have distinct catch slots.
4. **AS04 — Kanto:** Test Rock Tunnel, Seafoam Islands,
   Pokémon Mansion, Victory Road, Cerulean Cave and Pokémon Tower
   in ONE LOCATION and PER FLOOR.
5. **AS05 — Sevii:** Test Mt. Ember Ruby Path B floors,
   Icefall Cave and Lost Cave; ensure arbitrary room/puzzle
   movement does not create extra slots.
6. **AS06 — Hoenn:** Test Meteor Falls, Granite Cave, Shoal Cave,
   Mt. Pyre, Sky Pillar and Seafloor Cavern in Ruby/Sapphire/Emerald.
7. **AS07 — Route cuts:** For Routes 2, 10 and 20, inspect actual
   coordinates on both sides of the divider; validate that map
   midpoints match the intended physical separation.
8. **AS08 — Safari:** With Failed Encounters ON, test ONE ZONE
   vs PER AREA and both UNTIL CATCH variants in FRLG and Emerald.
9. **AS09 — Area gifts/trades:** When Gift Slot Policy / Trade Slot
   Policy is AREA, confirm consumed location keys prevent further
   acquisitions. BONUS acquisitions remain unaffected.
10. **AS10 — Existing claims:** Change from native map to location
    and back, and location to per-floor and back, after spending
    slots. No switch should re-arm an already spent logical slot.
11. **AS11 — Randomiser and Untamed:** Encounter identity must be
    based on the physical map, not the randomised replacement species.
    Visible overworld spawns continue to use native world behaviour.
12. **AS12 — Master switch and dev:** Turning Nuzlocke OFF disables
    enforcement but leaves the settings. The current area in Nuz Dev
    must match the active effective split key.

Automated policy and menu smoke tests exist, but these do not replace
ROM-level tests for geographic coordinates or edition-specific maps.
