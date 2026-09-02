# Ember Ascent — Godot Parity Contract

This file defines the gameplay/UI parity requirements to preserve while migrating Ember Ascent into Godot.

## Main Menu
- Title: **EMBER ASCENT**.
- No decorative logo above the title.
- `NEW RUN` is the primary action.
- `FORGE & UPGRADE` appears directly below `NEW RUN`.
- No anvil icon or "Quick Access" helper copy.
- Show a red claim notice when Forge has something claimable.

## Choose Hero
- Use full-body hero art whenever available.
- Do not crop portraits to the head only.
- Bottom of hero art must remain visible.
- Hero icons must be large enough for mobile and visually balanced.
- Keep consistent image framing across all heroes.

## Forge
- Hero icons follow the same art/framing rule as Choose Hero.
- Claimable upgrades/rewards must be clearly indicated.
- Avoid duplicate, clipped, missing, or mismatched icons.

## Combat VFX Targeting
Animation follows the effect target, not the card origin.

- Attack / damage / enemy debuff -> animate the affected enemy portrait/icon.
- Single-target effect -> animate only the selected enemy.
- AoE / multi-target effect -> animate every living enemy actually hit.
- DEF / Block / Heal / self-buff / self-skill -> animate on the player/card side.
- Offensive card impact must not animate on the played card.
- Target VFX must be anchored to the responsive enemy UI node, not hard-coded screen coordinates.

## Mobile
- Large touch targets.
- No clipped hero art, cards, bottom controls, or icons.
- UI remains usable at phone aspect ratios.
- Prefer GL Compatibility and lightweight 2D effects.

## Asset Parity
True 1:1 visual/audio parity requires the original images, icons, fonts, animation frames, music, and SFX. When originals are unavailable, placeholders must preserve layout dimensions and gameplay behavior so original assets can be swapped in without rewriting gameplay logic.
