# Ember Ascent Assets

Place original migrated game assets here while preserving stable Godot resource paths.

Recommended layout:

- `assets/heroes/full_body/` — original full-body hero art. Use IDs such as `ashwarden.png`, `cinderblade.png`, `emberseer.png`.
- `assets/heroes/icons/` — square hero icons using the same IDs.
- `assets/enemies/` — enemy portraits/icons.
- `assets/cards/` — card art/icons.
- `assets/relics/` — relic icons.
- `assets/ui/` — menus, frames, buttons, badges.
- `assets/vfx/` — combat VFX sprites/animations.
- `assets/audio/music/` — music.
- `assets/audio/sfx/` — sound effects.
- `assets/fonts/` — original UI/display fonts.

`AssetResolver` accepts PNG/WebP for gameplay art and also JPG/JPEG for hero full-body images. Full-body hero art is rendered with **contain** sizing and bottom alignment so feet are not cropped.

Combat VFX must remain anchored to the effect target. Enemy-directed effects belong on the affected enemy portrait/icon; self-directed DEF, heal, buff, and self-skill effects stay on the player/card side.
