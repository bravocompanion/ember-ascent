# Ember Ascent UI crop / overflow audit

## Current Godot build

### Fixed / protected
- Hero full-body art uses contain scaling with bottom-safe padding; feet and weapons should remain visible.
- Choose Hero roster is horizontally scrollable if the number of heroes or available width exceeds the current layout.
- Battle enemy formation is horizontally scrollable if the enemy count grows.
- Battle hand is horizontally scrollable if the number of cards grows beyond the visible area.
- Hero/tagline/status text uses reserved height and smart wrapping where longer copy could otherwise be clipped.
- `SafeTextureRect` provides a shared contain-mode texture component for future card/relic/potion/enemy art.

### Not yet testable in Godot
- Card artwork: current reconstructed battle cards are text-only and the card art folder has not been populated.
- Relic artwork/UI: relic rendering from the original game has not yet been migrated.
- Potion artwork/UI: potion rendering from the original game has not yet been migrated.
- Enemy artwork: original enemy assets have not yet been populated in the repository.

These are parity gaps rather than confirmed Godot crop bugs. When the original art is imported, use contain-mode rendering unless a crop is explicitly intentional.

## Original HTML parity target findings

The uploaded v2.9.7 source contains several image classes that use `object-fit: cover`. `cover` intentionally fills the box by cropping image edges, so meaningful parts of artwork can be lost depending on source aspect ratio.

Potential crop points to reproduce differently in Godot:
- Card artwork (`.ea-card-art`).
- Relic artwork (`.ea-relic-img`).
- Enemy portraits (`.ea-enemy-art`).
- Choice/reward artwork (`.ea-choice-art`).
- Potion icons and some header/menu images.

The HTML combat hand already uses horizontal overflow scrolling and modals use scrollable max-height, which are good patterns to retain.

### Important mobile parity issue
At the base responsive breakpoint (`max-width: 880px`), the original HTML hides the second and third sidebar panels. In the base sidebar order these are Relics and Potions. Unless another mobile control exposes them, this makes those panels unavailable rather than merely clipped. The Godot migration should not copy this behavior; use a compact drawer, tab, or scrollable strip instead.

### Other layout risks
- Fixed-height cards combined with longer descriptions can create text crowding/overflow, especially in shop-scaled and mobile variants.
- Any map/collection grid with a minimum width must stay inside a ScrollContainer/scrollable modal on narrow screens.
- Hover/impact scaling needs enough visual margin so enlarged controls are not clipped by a parent with clipping enabled.

## Rule for future integration
Use `SafeTextureRect` (contain) for art where the whole image matters. Use cover/crop only for decorative backgrounds or intentionally framed thumbnails.
