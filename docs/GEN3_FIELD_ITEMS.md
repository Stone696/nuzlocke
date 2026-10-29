# Gen 3 Advanced Rules — Field Items

**Version:** 3.0.0-BETA  
**Menu:** START → NUZ MENU → NUZ RULES → ADVANCED RULES → FIELD ITEMS.

All seven rules are saved independently in `gen3_classic_v1.fieldItemRules`
and are enforced only with CORE → NUZLOCKE enabled. Each defaults OFF
except Travel Restrictions (NORMAL). Disabling the Nuzlocke master
suspends restrictions without clearing your choices.

## Rules

| Setting | Default | Enforced behaviour |
| --- | --- | --- |
| No Repels | OFF | Blocks Repel, Super Repel and Max Repel before the repel counter or inventory changes. |
| No Escape Rope | OFF | Prevents using Escape Rope; the item remains in the bag. |
| Travel Restrictions | NORMAL | NORMAL: native field moves. NO FLY: disallows player-initiated Fly. NO FLY+TELEPORT: disallows both player-initiated Fly and Teleport. Dig, scripted/story warps, ferry transport and other field moves remain native. |
| No Field Heal | OFF | Blocks direct outside-battle HP recovery, status cures, Full Restore, revives and healing berries. Does not disable battle use, which is governed by Battle Items → No Healing Items. |
| No PP Items | OFF | Blocks Ether/Elixir-family PP recovery, Leppa Berry, PP Up/PP Max and native PP-effect items both outside and inside battle. |
| No TMs | OFF | Prevents using Technical Machines to teach moves. HMs are explicitly exempt, preserving progression. TM acquisition/storage/trading/selling is unaffected. |
| No Rare Candy | OFF | Blocks all normal Gen 3 Rare Candy use, including native party-menu direct leveling and `ItemUse.useRareCandy`. Level caps are independently enforced by LEVELS. |

### Native protection and compatibility

The `item.use` hook guards the standard overworld `ItemUse.useField`
transaction before native party, bag or map mutations. The native
Gen 3 Party Menu directly teaches TM moves and applies Rare Candy
without calling `item.use`; a guarded A-button selection blocks
those cases (and PP/healing items) before native execution.
Direct `ItemUse.useTm`, `useEscapeRope` and `applyPpItem`
paths are also protected.

**No PP Items** additionally guards native battle item availability,
target eligibility and the final `BattleItems.use` transaction,
before bag depletion and turn advancement. It is separate from
No Healing Items.

Fly and Teleport are blocked through
`FieldMoves.MENU_HANDLERS` and their named party-menu handlers.
The rest of the travel engine is not modified. This avoids
interfering with story-driven teleports, scripted progression,
native Dig, Escape Rope or other unrelated field actions.

Disallowed use produces a rule explanation and does not consume
an item. Obtaining, storing or disposing of restricted items
is not itself prohibited. Held-item activation and other
automatic battle effects are not field-item use and are unchanged.

Gen 1/2 behaviour and save data remain untouched.

## Manual smoke checklist (FR/LG/R/S/E)

1. Open FIELD ITEMS with a fresh Gen 3 save: verify six OFF switches
   plus Travel Restrictions: NORMAL. Toggle each, save/reload and
   confirm persistence.
2. Enable No Repels. Try all three repel strengths before any
   repel effect is active; confirm inventory and repel steps stay
   unchanged. Toggle OFF and confirm native repel use.
3. Enable No Escape Rope. Try it inside a valid dungeon. Confirm
   no warp and no item consumption. Turn OFF and verify normal use.
4. Cycle Travel Restrictions through NORMAL, NO FLY and
   NO FLY+TELEPORT. In the party menu, test Fly and Teleport,
   then Dig and story-scripted transport. Only the configured
   player-initiated moves should be refused.
5. Enable No Field Heal. Test Potion, Full Heal, Full Restore,
   Revive, Oran/Sitrus/Lum Berry on relevant Pokémon outside
   battle. Confirm no party/bag changes. Verify regular healing
   inside battle still works if the independent battle rule is OFF.
6. Enable No PP Items. Test Ether, Max Ether, Elixir, Max Elixir,
   PP Up, PP Max and Leppa Berry from Bag/Party Menu, then a
   PP recovery item inside battle. Denied actions must not
   consume a turn or an item.
7. Enable No TMs. Try TM teaching with fewer than four moves
   and a full move set (replacement flow), via both Bag and TM
   Case. Confirm teaching fails before any move or item changes.
   Check that HM teaching remains fully functional.
8. Enable No Rare Candy. Try it on a Pokémon below the active
   level cap from Bag/Party Menu. Confirm no level or inventory
   changes. Toggle OFF to confirm the existing LEVELS cap still
   independently blocks Candy above the configured threshold.
9. Check that ordinary held-item effects, native scripted warps,
   gifts and unrelated items are not interfered with.
10. Turn CORE → NUZLOCKE OFF. The native items and field moves
    should work again without resetting the saved rule choices.

The automated Lua smoke tests check rule validation, module
classification, native hook interception, menu interception
and travel dispatch. Exact ROM and mod-compatibility verification
is still required before claiming full in-game certification.
