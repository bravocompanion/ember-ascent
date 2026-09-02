# Ember Ascent

Godot 4.x migration baseline for **Ember Ascent**, a mobile-first turn-based roguelike deckbuilder.

## Open in Godot

1. Install Godot 4.3 or newer.
2. Clone this repository.
3. In Godot Project Manager choose **Import**.
4. Select `project.godot`.
5. Run the project with F6/F5.

No external addons are required for the current baseline.

## Implemented

- Main Menu with `NEW RUN` and `FORGE & UPGRADE`.
- Red Forge claim notice when a reward is available.
- Persistent Ember Shards and Forge upgrades via `ConfigFile`.
- Choose Hero screen with three heroes.
- Full-body procedural hero art so portraits do not crop to head-only.
- Playable turn-based card battle.
- Energy, HP, Block, enemy intents, end-turn enemy attacks, victory reward.
- Single-target and multi-target attack cards.
- Mobile-friendly large touch targets.
- GL Compatibility renderer for broad mobile support.

## Combat VFX targeting rule

The animation anchor follows the **effect target**:

- Attack / damage / enemy debuff: animate the enemy portrait/icon that receives the effect.
- Multi-target attack: animate every living enemy actually hit.
- DEF / Block / Heal / self-buff / self-skill: animate the played card itself.
- Offensive cards do not use the card as their impact anchor.

This behavior lives in `scripts/battle.gd`, primarily `_enemy_target_vfx()` and `_self_card_vfx()`.

## Project structure

```text
project.godot
scenes/
  main.tscn
  choose_hero.tscn
  forge.tscn
  battle.tscn
scripts/
  game_state.gd
  main.gd
  hero_art.gd
  choose_hero.gd
  forge.gd
  battle.gd
```

## Migration status

This repository is a clean Godot-ready reconstruction from the Ember Ascent project design and gameplay context available to ChatGPT. Source files and binary art that existed only inside another chat/session are not directly accessible as files here, so the current repository uses procedural placeholder hero art and a reconstructed playable combat baseline.

When original Ember Ascent art/audio/source assets are available as files, place them under `assets/` and replace the procedural placeholders without changing the combat targeting contract above.
