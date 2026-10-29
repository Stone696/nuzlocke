# Gen 3 Advanced Rules — Services & Economy

**Version:** 3.0.0-BETA  
**Menu:** START → NUZ MENU → NUZ RULES → ADVANCED RULES → SERVICES & ECONOMY.

The six controls live exclusively in the Gen 3 `gen3_classic_v1.serviceRules`
namespace, with the existing CORE → NUZLOCKE master switch. All settings
persist across reloads and are suspended, not erased, when CORE is OFF.

| Rule | Default | Meaning |
| --- | --- | --- |
| **No Center Heal** | OFF | Suppresses the native `HealPlayerParty` scripted transaction inside Pokémon Centre maps. NPC dialogue/story scripts continue. |
| **No Mom Heal** | OFF | Suppresses that same transaction inside the player's home interior, independently of Centres. |
| **No Day Care** | OFF | Blocks new deposits at the native Day Care transaction boundary, including the FRLG Route 5 and two-slot Day Cares and the RSE two-slot Day Care. Retrieval of already deposited Pokémon remains permitted so the rule cannot trap party members. Existing Eggs are also unaffected. |
| **Shop Restrictions** | NORMAL | NORMAL → NO BUY → NO SELL → CLOSED. Blocks the selected merchant action before purchasing or entering the sell flow; Pokémon Mart and native RSE decoration shops are supported. Does not delete stock, money or bag items, or prevent necessary NPC dialogue. |
| **No Gambling** | OFF | Blocks native FRLG slot-machine starts and RSE slot-machine/roulette script specials before coin wagering or UI entry. Existing coins and prizes remain untouched. |
| **Trainer Money** | 100% | Cycles 100%, 200%, 300%, 0%, 50%. Modifies native trainer prize calculations before award/message creation; never scales generic script `addmoney`, shop receipts, Pay Day or story money. Native maximum cash balance still applies. |

## Compatibility and progression safeguards

The native `script.command` hook checks **specific** service scripts,
rather than disabling all `special` calls or modifying script bytecode.
For healing, it identifies Pokémon Centre and Mom's house from the actual
native interior map ID. Unknown map IDs and all other scripted heals are
left alone. This intentionally avoids suppressing a forced Hall of Fame
heal, emergency recovery or unrelated story event merely because it uses
the same `HealPlayerParty` special. If a custom map uses an unexpected
identifier, its heal will remain native pending an explicit compatibility
mapping; this is preferable to softlocking a progression script.

Day Care refuses native deposits as an additional transaction safeguard,
but **never refuses withdrawals**. Switching the rule on after a Pokémon
has been deposited will not leave it stranded. Party/mail transaction and
breeding state remain engine-owned. For native NPC interactions, the
script-level deposit special is intercepted before its post-deposit
processing.

The standard FRLG shop menu and native RSE shop/decor menu use the
same input dispatch entry point. Buying is stopped before the purchase
confirmation can mutate bag/money; selling is stopped before opening
the sell bag. Purchases made via unrelated third-party shop UIs are not
claimed to be intercepted.

Trainer Money uses the exported FRLG `Prize.calc` and RSE
`Prize.rewardRse` prize computation entry points. It does not patch
`Prize.apply`: scripted gifts, purchases and Pay Day payouts must not
accidentally inherit a trainer-only multiplier.

Denials appear in NUZ NOTICES. Gen 1/2 engine and saves are unaffected.
Do not interpret the presence of an NPC's original healing dialogue
after a refusal as a successful heal; check actual party HP/status.

## Manual validation (FR/LG/R/S/E)

1. Enter SERVICES & ECONOMY, cycle each row, and save/reload. Confirm
   defaults and persistence. Switch CORE OFF and confirm native behaviour
   returns without losing the saved choices.
2. **S01 — Centre heal:** Injure a Pokémon and add a status ailment.
   Enable No Center Heal; speak to a nurse and verify HP/status/PP remain
   unchanged. Disable and verify the same nurse heals normally. Test
   at least one Centre in FRLG and one in RSE.
3. **S02 — Mom heal:** In the player's house, enable No Mom Heal and
   interact with Mom's healing service. Ensure no HP/status/PP recovery.
   Verify Centre healing is still available if No Center Heal is OFF.
4. **S03 — Script safety:** With both heal bans ON, complete a compulsory
   story transition/Hall of Fame or other unrelated forced heal. Ensure
   story progress and native scripted recovery are unaffected.
5. **S04 — Day Care deposit:** Enable No Day Care and attempt a deposit.
   Verify the selected Pokémon remains in party with its held item/mail;
   no Day Care slot or money is altered.
6. **S05 — Day Care retrieval:** Deposit a Pokémon with the rule OFF,
   turn it ON and retrieve it. Verify there is no softlock or duplicate.
   Repeat with the Route 5 Day Care in FRLG and one RSE Day Care.
7. **S06 — Shops:** Try NORMAL, NO BUY, NO SELL and CLOSED in a normal
   shop, with sufficient money and a valid item. Confirm denied
   purchases/sales change neither bag nor cash. Check a RSE decoration
   shop, and that shopping resumes when the rule is OFF.
8. **S07 — Gambling:** Enable No Gambling, try FRLG slots, RSE slots and
   RSE roulette. No wager is consumed and none of the minigames opens.
   Toggle OFF to confirm native games return.
9. **S08 — Money:** Win trainer battles with 100%, 50%, 0%, 200% and
   300% on disposable saves and compare actual awards with normal
   payouts. Confirm two-trainer RSE battles, prize display and cash-cap
   handling, and verify a scripted cash gift and Pay Day are not scaled.
10. **S09 — Compatibility:** Repeat using the randomiser and
    Untamed-Advanced installed. Services and prices should behave as
    configured without altering encounter logic.

The Lua policy smoke suite checks save values, rule precedence and
native-guard wiring. Gameplay interactions and exact native map aliases
still require edition-specific verification.
