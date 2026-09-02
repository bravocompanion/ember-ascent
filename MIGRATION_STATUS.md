# Migration status

## Already integrated in Godot
- Godot 4.3 project configuration and main scene.
- Main menu, Choose Hero, Forge & Upgrade, and Battle scenes.
- Persistent game state.
- Turn-based combat baseline.
- Mobile-first renderer/settings.
- Combat VFX targeting contract: offensive effects animate the affected enemy UI; self effects stay on player/card side.

## Required for true 1:1 parity
The following must be copied from the original playable build/source when available:
- Original hero full-body art and hero icons.
- Original enemy/card/relic icons.
- Original backgrounds and UI textures.
- Original fonts.
- Original VFX sprites/animation frames.
- Original music/SFX.
- Any cards, relics, enemies, progression data, encounters, shops/events, monetization/ads/purchase hooks, and save-schema details not present in the current Godot reconstruction.

The Godot code should treat these as swappable assets/data rather than bake their visuals into gameplay logic.
