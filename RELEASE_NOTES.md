# Nuzlocke 2.4.10

2.4.10 is the direct release child of 2.4.9 RC.

## Forgiveness Token
The intended shop price remains **¥1,000,000**. Because Gen1Recomp's native wallet tops out at ¥999,999, the token now uses a special cap-aware settlement contract: a full native wallet satisfies the synthetic million-price purchase and is consumed completely. The Mart still advertises ¥1,000,000. This does not raise the wallet cap or alter normal item prices.

## Hardening retained from 2.4.9
- `noBadgeBoosts` is independent of `aiTier`.
- R/B/Y Forgiveness confirmation uses its corrected opaque panel.

## Compatibility
- Gen1Recomp declared range: `>=0.1.86 <0.2.5`
- Audited through: 0.1.99
- Mod API: 2
- Save schema: unchanged
- R/B/Y million-price Mart transaction: TEST REQUIRED
- Gold native Mart transaction: TEST REQUIRED

