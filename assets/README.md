# Ember Ascent Assets

Place original migrated game assets here while preserving stable Godot resource paths.

Recommended layout:

- `assets/heroes/` — full-body hero art and portraits
- `assets/enemies/` — enemy portraits/icons
- `assets/cards/` — card art/icons
- `assets/relics/` — relic icons
- `assets/ui/` — menus, frames, buttons, badges
- `assets/vfx/` — combat VFX sprites/animations
- `assets/audio/music/` — music
- `assets/audio/sfx/` — sound effects

Combat VFX should be anchored to the effect target. Enemy-directed effects belong on the enemy portrait/icon; self-directed DEF, heal, buff, and self-skill effects stay on the player/card side.
