# Gen 3 ADVANCED RULES — expanded Catch Rules

**Version:** v3.0.0-BETA · **Menu:** START → NUZ MENU → NUZ RULES
→ ADVANCED RULES → CATCH RULES.

These are Gen 3-only rules. The Gen 1/2 options remain separate and
unchanged; Gen 3 uses the existing `gen3_classic_v1` save namespace.
The master **CORE → NUZLOCKE** must be ON for catch bans to apply.
Settings are saved and retained when the master switch is temporarily OFF.

## Working: CATCH RULES

| Rule | Default | Meaning |
| --- | --- | --- |
| **Town Catches** | OFF | When OFF, refuses ordinary wild catches on native outdoor town/city maps (including the seven Sevii island settlements). ON allows them to use their own physical map's encounter slot. This does not classify unrelated interior or route maps as towns. |
| **No Legendaries** | OFF | Bans Articuno, Zapdos, Moltres, Mewtwo, Raikou, Entei, Suicune, Lugia, Ho-Oh, Regirock, Regice, Registeel, Latias, Latios, Kyogre, Groudon and Rayquaza. Mythicals are separate. |
| **No Mythicals** | OFF | Bans Mew, Celebi, Jirachi and Deoxys. |
| **No Pseudos** | OFF | Bans the full Dragonite, Tyranitar, Salamence and Metagross evolutionary lines, including their first and second stages. |
| **No Static Encounters** | OFF | Blocks Ball captures of native scripted wild encounters, including fixed legendary battles and Marowak; the battle itself continues normally. Roaming legendary Pokémon are excluded. |
| **No Fishing** | OFF | Blocks rod use at the native field-entry point before the fishing minigame and prevents direct fishing encounter attempts. Rod items remain in the bag; surf and other encounter methods work normally. |
| **Gift Pokémon** | ON | OFF refuses optional scripted `givemon` gifts before party/PC mutation, using the native failure result. The compulsory first starter remains exempt. |
| **Gift Slot Policy** | AREA | AREA makes successful optional gifts consume the encounter slot on the receipt map when One Per Area is enabled. BONUS records the gift without spending that slot. |
| **In-Game Trades** | ON | OFF rejects native NPC in-game trades at the requested-species preview, before the player gives up their Pokémon. This does not block linked player trades. |
| **Trade Slot Policy** | AREA | AREA makes successful NPC exchanges consume the encounter slot on their map when One Per Area is enabled. BONUS records the exchange without using the ordinary slot. |
| **PKMN BAN** | 0 BANNED | Opens a 20-species-per-page National Dex picker (#001–#386 vanilla, up to #1025 with National Dex). Select any species to toggle its individual ban. Uses National Dex rather than internal Hoenn species IDs. Applies to wild catches, optional gifts, NPC trades, and the Nuzlocke randomiser's wild/trainer replacement pools. The mandatory first starter is exempt. |
| **Colorlocke** | OFF | OFF / RANDOM / CHOOSE. Restricts new acquisitions to the canonical species colour; RANDOM picks one available colour deterministically and persists it for the run. CHOOSE uses the Colour selector. Unknown custom species with no colour metadata are allowed rather than guessing a sprite colour. |
| **Color** | BLACK | CHOOSE-only selector cycling BLACK, BLUE, BROWN, GRAY, GREEN, PINK, PURPLE, RED, WHITE and YELLOW. Based on canonical species identity, not shiny/sprite palettes. |
| **Alphabetlocke** | OFF | OFF / RANDOM / CHOOSE. Restricts new wild catches by the first letter of the species' canonical ROM identity (not nickname or translated text). RANDOM chooses an available initial deterministically for the save and stores it; CHOOSE uses the Letter selector. |
| **Letter** | A | A–Z selector, only shown when Alphabetlocke is CHOOSE; irrelevant in OFF and RANDOM modes. |
| **Allow Glitches** | OFF | OFF refuses wild catches with invalid/unregistered or explicitly glitch-marked species IDs when the native registry can verify them. ON allows them through this check; all other catch bans still apply. Valid provider-registered custom species are not classified as glitches merely for lacking a National Dex number. |
| **Maximum BST** | OFF | The total of the six native base stats (HP / Attack / Defense / Speed / Special Attack / Special Defense) must be at most the chosen cap: 300, 350, 400, 450, 500, 550, 600, 650 or 700. Exact equality is allowed. OFF is unlimited. |

The classification checks **National Pokédex IDs via native
`Pokemon.national()`**, not direct Gen 3 internal species indices.
This matters particularly for Hoenn Pokémon. The BST limit reads
**native `Pokemon.stats()`** for the final species, including randomised
species. If the native base stats cannot be verified while a cap is ON,
the catch is denied rather than silently bypassing a hard maximum.

### Encounter slots and interactions

- Species and static rules are **catch restrictions**, not encounter bans:
  you can still battle, faint, run from or observe a banned Pokémon.
  No Fishing is instead a **field-use restriction**: rod use is refused
  before the fishing attempt starts. No fish battle is generated.
- Banned Pokémon **do not claim an area's first encounter slot**, even
  when Failed Encounters Count is ON. The first eligible encounter on
  that route remains available.
- The existing `catch.rate` hook denies a prohibited capture **before**
  native ball capture, clone/storage delivery and any shiny-exception
  allowance. Native ball consumption/breakout presentation remains
  engine-owned, and RUN JOURNAL > EVENT HISTORY records the precise reason.
- The **Shiny Clause cannot override** these explicit bans.
  Shiny Nuzlocke and Hardcore apply alongside the restrictions.
- Randomised wild Pokémon and Untamed-Advanced's visible overworld
  wilds use the **final battled species**. Roamers are evaluated as
  species too; their existing roamer-slot treatment is preserved.
- If CORE → NUZLOCKE is OFF (or the run has failed), these catch
  restrictions do not change native catch or rod behaviour.
- No Static reads the native battle's `wildScripted` / `legendary`
  flags and exempts `roamer`. It does not ban ordinary wilds based
  merely on a species name; Shiny Clause cannot override it.
- No Fishing guards native `Field.startFishing` and the fallback
  `Field.tryFishingEncounter` call. It does not remove fishing rods,
  block unrelated water encounters or modify the engine's fishing data.
- Town Catches is checked before an encounter can claim a route's first
  attempt, and rechecked at the Poké Ball transaction. Town catches are
  therefore ineligible while OFF, including with Failed Encounters ON.
- **PKMN BAN** operates on National Dex numbers 1–1025 (picker stops at 386
  if the expanded provider is absent), stores
  only selected entries under `catchRules.bannedNational`, and checks the
  actual battled/received species' `Pokemon.national()` identity.
  The in-game picker is paged in groups of 20 with previous/next controls.
  Native randomiser candidates exclude banned national species while
  CORE Nuzlocke is active, including trainer-team replacements; when no
  legal replacement remains, the original species is retained rather
  than fabricating an invalid Pokémon. Already-owned Pokémon are untouched.
- **Colorlocke** maps the 386 original National Dex species to their
  canonical colour IDs (PokeAPI species-colour dataset: BLACK, BLUE, BROWN,
  GRAY, GREEN, PINK, PURPLE, RED, WHITE, YELLOW). It uses the final
  Pokémon's National Dex mapping and never samples sprites or shiny
  palettes. Explicit provider metadata can supply a colour for a custom
  Pokémon; otherwise unknown-colour customs fail open. RANDOM picks a
  represented colour from the installed species registry, saves it as
  `catchRules.colorlocke_random_color`, and displays it as RND:COLOUR
  after resolution; switching modes resets the random selection.
- RANDOM Alphabetlocke chooses from initials represented in the active
  installed National Dex registry (1–1025 when available) and persists the chosen letter in
  `statusBans`-independent `catchRules.alphabetlocke_random_letter`.
  Changing Alphabetlocke mode resets that stored choice. The selector
  is visible in the menu after resolution as `RND:X`.
- **Scripted gifts** are checked in the Gen 3 `script.command` pre-transaction
  hook. On denial, the normal `givemon` opcode does not run and the VM
  receives its native unsuccessful delivery result (`VAR_RESULT = 2`).
  Native scripts still own their own dialogue, flags and retry handling.
  The mandatory opening starter at Oak's Lab / the Route 101 rescue
  remains obtainable even when optional gifts are disabled.
- **NPC in-game trades** use the native
  `GetInGameTradeSpeciesInfo` script special for early rejection: its
  dialogue strings are left available but the requested species is
  replaced with 0, so an ordinary party Pokémon cannot match.
  The actual `Trade.tradeMons` mutation is also guarded; a completed
  swap is the only event counted as a received trade. Linked trades
  are not handled by this NPC-only rule.
- **AREA vs BONUS:** AREA applies the same physical-map key as wild
  encounters, and only commits a spent map entry following a successful
  gift or exchange; an unsuccessful / prohibited transaction does not
  spend a slot. BONUS logs the receipt without consuming the wild slot.
  Both modes retain successful `acquisitionHistory` provenance and
  mark the received species for Dupes Clause. With One Per Area OFF,
  AREA cannot block a transaction based on old route slots.
- Existing species restrictions (Legendary, Mythical, pseudo, BST and
  Alphabetlocke where a canonical name is available) also gate these
  supported new acquisitions. Gifts/trades produced by external mods
  through unrelated transaction APIs are **not** intercepted.
  Since the Gen 3 `pokemon.before_give` event does not honour veto,
  a different mod changing the species after our preflight needs
  separate compatibility testing; no destructive rollback is attempted.
- No changes are made to already-owned Pokémon retroactively.
  Gift/Trade scripts and PC-capacity handling remain native.

### Remaining advanced work

All Gen 3 Catch Rules rows are now functional. The redundant Overworld
Encounters toggle has been removed: if Untamed-Advanced supplies
wandering Pokémon, those wild battles use the same encounter-slot and
catch-legality rules as ordinary native wild encounters. Untamed controls
the visible spawns; Nuzlocke does not need a separate enable switch.

All nine Advanced Rules categories now have functioning Gen 3 controls. Their implementations and edition-specific limitations are documented separately in [Battle Clauses](GEN3_BATTLE_CLAUSES.md), [Status Bans](GEN3_STATUS_BANS.md), [Variants](GEN3_VARIANTS.md), [Battle Items](GEN3_BATTLE_ITEMS.md), [Field Items](GEN3_FIELD_ITEMS.md), [Services & Economy](GEN3_SERVICES_ECONOMY.md), [Pokémon Stats](GEN3_POKEMON_STATS.md) and [Area Splits](GEN3_AREA_SPLITS.md).

## Manual verification

1. On a disposable save, enable CORE → NUZLOCKE. Enter CATCH RULES.
   Toggle each of the three species bans, No Static Encounters and
   No Fishing, then cycle MAXIMUM BST. Save, restart, and confirm all
   settings persist.
2. With FAILED ENCOUNTERS ON, find a prohibited Pokémon on an unused
   route, throw a ball, and inspect RUN JOURNAL > EVENT HISTORY and ENC TRACKER:
   the capture is refused, and the route remains open.
3. Encounter an allowed Pokémon on the same route; verify the native
   catch succeeds and the slot is spent normally.
4. At BST 500, test a 500-BST species (legal) and one above 500
   (refused); turn BST OFF and retest normal catches.
5. Repeat with a randomised wild and an Untamed wandering wild.
   Confirm the restrictions apply to the Pokémon actually visible.
6. Disable CORE → NUZLOCKE and repeat one banned species catch.
   Native catching must resume. Restore the master switch afterwards.
7. Test Shiny Clause exceptions: they must not bypass an explicit
   legendary/mythical/pseudo/BST prohibition.
8. With No Fishing ON, use each rod in a valid fishing location.
   Confirm the rod attempt never begins and RUN JOURNAL > EVENT HISTORY explains why.
   Turn the rule OFF and confirm the native fishing minigame returns.
9. With No Static ON, attempt a scripted encounter (e.g. a legendary
   encounter on an unused route) and throw a Ball. The battle still
   proceeds normally, but capture is blocked and the route slot stays
   available. A roamer and an ordinary wild must remain unaffected.
10. Test Town Catches OFF and ON with a wild encounter on a town/city
    map and a route. OFF must prevent the town catch without using the
    area slot; ON must permit it subject to normal One Per Area rules.
    Check a Sevii settlement and an interior separately.
11. Test Alphabetlocke CHOOSE with e.g. L: Latias should be eligible
    (unless another catch ban forbids it), Salamence should be rejected.
    Switch to RANDOM; confirm a stored letter is shown after first wild
    encounter and remains fixed across reload. Changing mode resets it.
12. With Allow Glitches OFF, test a deliberately invalid/unregistered
    species from a developer/provider fixture; it must be rejected.
    ON permits it unless another rule blocks it. Ordinary Hoenn IDs
    must remain legal.
13. Set **Gift Pokémon = OFF** on a disposable save, attempt an
    optional scripted gift (e.g. the Celadon Eevee). No new Pokémon
    should enter party/PC and the game should remain playable. Then
    re-enable gifts, obtain it, and confirm exactly one receipt.
    Confirm the compulsory opening starter still works with gifts OFF.
14. Check Gift Slot **AREA**: receive a gift on an unused map, then
    verify a wild catch there is blocked by One Per Area. On a fresh
    map, select **BONUS** and verify the gift does not consume its
    encounter slot. Check unsuccessful full-PC delivery does not claim it.
15. In a native NPC trade, set **In-Game Trades = OFF** and confirm
    the exchange never takes your offered Pokémon. Enable it, set
    Trade Slot **AREA**, complete an NPC trade and confirm the source
    map slot is spent. Repeat on a fresh map with **BONUS** and
    confirm the map's normal slot remains available. Test FRLG and RSE.
16. Verify prohibitions from Legendary/Mythical/pseudo/BST/Alphabetlocke
    apply to supported optional gifts and received NPC trade Pokémon.
17. In PKMN BAN, open the National Dex picker, page forward and back,
    ban #025 Pikachu, then attempt a Pikachu catch. Confirm it is
    refused without spending a route; unban Pikachu and retry on a fresh
    route. Save/restart and verify the ban list persists. Check Treecko
    (National #252, Gen 3 internal species 277) for ID-mapping correctness.
18. With the Nuzlocke randomiser enabled, ban multiple National Dex
    species and verify neither wild nor trainer replacement results
    select them. Confirm Nuzlocke master OFF restores native/randomiser
    eligibility without deleting saved bans.
19. Set Colorlocke CHOOSE = YELLOW and verify Pikachu is eligible while
    Charmander (RED) is not. Repeat with randomised and Untamed wilds,
    plus an optional gift/NPC trade. Switch to RANDOM and confirm its
    selected colour persists after a save/reload (including if the first
    allowed acquisition is a gift).
20. Verify that Overworld Encounters no longer appears in Gen 3
    Catch Rules. With Untamed-Advanced enabled, catch a visible wandering
    wild and confirm it uses the normal map encounter slot, without any
    separate overworld toggle. Other advanced categories are implemented
    and remain subject to ROM and combination testing.

The automated smoke suite is not a substitute for exact-edition ROM
testing in FireRed, LeafGreen, Ruby, Sapphire and Emerald.

## Expanded National Dex integration (development branch)

With `national_dex_gen3` API v2 installed, the randomiser includes
registered Gen 4–9 base species up to #1025 and optionally all 128 forms.
All replacements still pass the same eligibility, BST, generation and
individual ban checks. New legendary and mythical species use the provider's
`listSpecies()` classification; pseudo-legendary restrictions cover their
known later-generation evolution families.

The **PKMN BAN** picker extends to #1025 when National Dex is registered.
Unsupported species/form entries are not fabricated. Existing used saves
keep their legacy randomisation roster to preserve seed/replacement identity.
See [Randomiser](GEN3_RANDOMIZER.md) for the mode controls and safety policy.

Colorlocke's hard-coded fallback colour table still covers the original
386 species; newer species require native colour metadata. This feature
does not claim to supply new sprite artwork or resolve Modern Spawns'
encounter-provider priority by itself.
