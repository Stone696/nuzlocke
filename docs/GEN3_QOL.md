# Gen 3 Nuzlocke — QOL

**Version:** v3.0.0-BETA  
**Menu:** NUZ MENU → NUZ RULES → QOL  
**Save state:** \`gen3_classic_v1.qolRules\`

The Gen 3 QOL menu deliberately contains **only four working
settings**. It does not display unsupported legacy entries, unfinished
capture exceptions, or options belonging to other generations.

All four options work independently of the CORE Nuzlocke master switch.

## Current controls

| Option | Values | Default |
| --- | --- | --- |
| Instant Text | OFF / ON | OFF |
| Run / Surf | OFF / HOLD B / ALWAYS | OFF |
| Unlimited Bag Space | OFF / ON | OFF |
| Trade Evolutions | OFF / ON | OFF |

### Instant Text

Instant Text now covers **all known native Gen 3 text-printer
paths** without rewriting save options: field and battle messages
use native speed zero; advancing a page or entering an automated
scroll reveals its new glyphs immediately. FireRed/LeafGreen's Oak
intro printer and RSE cutscene printer also receive instant speed,
while Ruby/Sapphire's independent native field auto-scroll printer
flushes its contiguous glyphs in one frame.

**Dialogue choices, paragraph boundaries, script waits and explicit
pauses are preserved.** No gameplay script is fast-forwarded. This
remains subject to real-ROM testing across all five Gen 3 editions.

### Run / Surf

Uses the native \`movement.speed\` mod hook:

- **OFF:** native movement frames.
- **HOLD B:** halve frame count when B is held while walking/surfing.
- **ALWAYS:** halve the count for supported walking/surfing steps.
- Never returns fewer than one movement frame.

Bike handling, cutscenes, scripted steps, ledges, jumps, underwater
movement and slope behaviour remain native. Other movement mods may
compose with this same hook, so cross-mod tests are required.

### Unlimited Bag Space

Removes the **distinct-slot count** cap in the ordinary Item and
Poké Ball pockets. Does not remove the per-item stack limit or
expand Key Item, TM/HM or Berry slots.

Uses the native \`Bag.canAdd\` and \`Bag.add\` transaction path with
the relevant two pocket capacities temporarily relaxed. Capacities
are restored immediately, **including on native errors**. Disabling
the rule never deletes existing Bag contents.

RSE stores native 99-item stacks in these pockets. Keep multiple
native stacks instead of raising stack caps. Test a Bag over its
original slot capacity through save/reload, sorting and item use
before relying on it in an important run.

### Trade Evolutions

Adds a **level 40+ alternative** to the native Gen 3
\`Evolution.targetSpecies\` for Pokémon with an existing trade
evolution record.

Trade-with-held-item branches still require their original item.
The matching held-item branch takes precedence over conflicting
ordinary evolutions, and the item is only consumed after a
successful level-triggered evolution. Everstone, real link trade
timing, edition evolution gates and **Run / Party → Evolution
Limits** remain authoritative.

This scans live merged evolution data instead of using a fixed
species whitelist. Custom evolution mods need their own tests.

## Quick manual checks

1. Toggle every row and check persistence after saving.
2. Turn on Instant Text; verify multi-page FRLG and RSE dialogue,
   player prompts and Hoenn auto-scroll sequences.
3. Test walking/surfing with Run / Surf OFF, HOLD B and ALWAYS.
   Confirm bike, ledge, slope and scripted movement remain native.
4. Fill the ITEM and POKE_BALLS pockets, then pick up a new item
   under Unlimited Bag Space. Check native stack caps,
   save/restore and UI item sorting.
5. Test trade evolutions at 39/40 with and without Everstone,
   with trade-required held items, cancelled evolution and
   the separate No Evolution rule.
6. Confirm the four convenience settings still work with
   CORE Nuzlocke OFF.

Automated Lua/CI tests cover policy values, the four native seams,
movement exclusions, bag capacity restoration and trade-evolution
conditions. They do **not** replace FRLG/RSE playtests.
