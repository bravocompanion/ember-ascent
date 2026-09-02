# Migration status

## Already integrated in Godot
- Godot 4.3 project configuration.
- 10-second startup loading scene before the main menu, with threaded main-scene loading and visible progress/status.
- Main menu, Choose Hero, Forge & Upgrade, and Battle scenes.
- Persistent game state.
- Turn-based combat baseline.
- Mobile-first renderer/settings.
- Combat VFX targeting contract: offensive effects animate the affected enemy UI; self effects stay on player/card side.
- Full-body hero art uses contain scaling and bottom-safe padding so feet/weapons are not cropped.
- Choose Hero, enemy formations, and combat hands use horizontal scrolling where content can exceed the viewport.
- Shared `SafeTextureRect` helper is available for card/relic/potion/enemy UI art that must use contain rather than cover/crop.

## UI crop audit
- Current Godot hero portraits: protected against cropping.
- Current Godot combat cards: text-only buttons; no card artwork is currently imported, so artwork cropping cannot occur yet. The hand is scroll-safe if card count grows.
- Current Godot relics/potions: not yet rendered in the reconstruction, so there is no active relic/potion crop bug in Godot yet.
- Current asset folders for hero/card/relic/enemy art are placeholders until original source assets are imported.
- When original card/relic/potion/enemy artwork is integrated, use `SafeTextureRect` for any image where the entire artwork must remain visible.

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
