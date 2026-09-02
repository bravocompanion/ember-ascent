extends Control

func _ready() -> void:
	_build_ui()

func _build_ui() -> void:
	var bg := ColorRect.new()
	bg.color = Color("#120f18")
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(bg)

	var glow := ColorRect.new()
	glow.color = Color("#251727")
	glow.position = Vector2(0, 380)
	glow.size = Vector2(1280, 340)
	bg.add_child(glow)

	var center := VBoxContainer.new()
	center.set_anchors_preset(Control.PRESET_CENTER)
	center.position = Vector2(-250, -230)
	center.size = Vector2(500, 460)
	center.alignment = BoxContainer.ALIGNMENT_CENTER
	center.add_theme_constant_override("separation", 14)
	add_child(center)

	var title := Label.new()
	title.text = "EMBER ASCENT"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 54)
	title.add_theme_color_override("font_color", Color("#f4c68b"))
	center.add_child(title)

	var subtitle := Label.new()
	subtitle.text = "Turn-Based Roguelike Deckbuilder"
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	subtitle.add_theme_font_size_override("font_size", 18)
	subtitle.add_theme_color_override("font_color", Color("#b9a7b9"))
	center.add_child(subtitle)

	var spacer := Control.new()
	spacer.custom_minimum_size = Vector2(1, 26)
	center.add_child(spacer)

	center.add_child(_menu_button("NEW RUN", _on_new_run))
	center.add_child(_menu_button("FORGE & UPGRADE", _on_forge))

	if GameState.forge_claim_ready:
		var note := Label.new()
		note.text = "CLAIM AVAILABLE IN FORGE"
		note.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		note.add_theme_font_size_override("font_size", 15)
		note.add_theme_color_override("font_color", Color("#ff5e63"))
		center.add_child(note)

	var shard := Label.new()
	shard.text = "Ember Shards: %d" % GameState.ember_shards
	shard.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	shard.add_theme_font_size_override("font_size", 16)
	shard.add_theme_color_override("font_color", Color("#e5d4c8"))
	center.add_child(shard)

	var version := Label.new()
	version.text = "Godot migration baseline"
	version.position = Vector2(24, 680)
	version.add_theme_font_size_override("font_size", 13)
	version.add_theme_color_override("font_color", Color("#786d7a"))
	add_child(version)

func _menu_button(text_value: String, callback: Callable) -> Button:
	var button := Button.new()
	button.text = text_value
	button.custom_minimum_size = Vector2(420, 62)
	button.add_theme_font_size_override("font_size", 22)
	button.pressed.connect(callback)
	return button

func _on_new_run() -> void:
	get_tree().change_scene_to_file("res://scenes/choose_hero.tscn")

func _on_forge() -> void:
	get_tree().change_scene_to_file("res://scenes/forge.tscn")
