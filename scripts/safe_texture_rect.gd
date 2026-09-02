extends TextureRect
class_name SafeTextureRect

# Shared rule for card, relic, potion, enemy and other UI art that must remain
# completely visible. Use this instead of STRETCH_KEEP_ASPECT_COVER whenever
# cropping would hide meaningful artwork.
func _ready() -> void:
	expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	clip_contents = false
