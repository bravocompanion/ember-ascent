extends Control

const HeroArtScript = preload("res://scripts/hero_art.gd")

var shard_label: Label
var status_label: Label
var claim_button: Button
var vitality_button: Button
var power_button: Button

func _ready() -> void:
	_build_ui()
	_refresh()

func _build_ui() -> void:
	var bg := ColorRect.new()
	bg.color = Color("#120e12")
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(bg)

	var title := Label.new()
	title.text = "FORGE & UPGRADE"
	title.position = Vector2(0, 28)
	title.size = Vector2(1280, 60)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 38)
	title.add_theme_color_override("font_color", Color("#f0b875"))
	add_child(title)

	var hero := GameState.hero_data()
	var hero_panel := VBoxContainer.new()
	hero_panel.position = Vector2(120, 120)
	hero_panel.size = Vector2(300, 470)
	hero_panel.alignment = BoxContainer.ALIGNMENT_CENTER
	hero_panel.add_theme_constant_override("separation", 8)
	add_child(hero_panel)

	var art := HeroArtScript.new()
	art.hero_id = str(hero.get("id", hero["name"]))
	art.accent = hero["accent"]
	art.custom_minimum_size = Vector2(270, 350)
	hero_panel.add_child(art)

	var hero_name := Label.new()
	hero_name.text = str(hero["name"])
	hero_name.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	hero_name.add_theme_font_size_override("font_size", 24)
	hero_name.add_theme_color_override("font_color", hero["accent"].lightened(0.22))
	hero_panel.add_child(hero_name)

	var hero_note := Label.new()
	hero_note.text = "Selected Hero"
	hero_note.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	hero_note.add_theme_font_size_override("font_size", 14)
	hero_note.add_theme_color_override("font_color", Color("#aa9da8"))
	hero_panel.add_child(hero_note)

	var panel := VBoxContainer.new()
	panel.position = Vector2(500, 112)
	panel.size = Vector2(620, 500)
	panel.alignment = BoxContainer.ALIGNMENT_CENTER
	panel.add_theme_constant_override("separation", 14)
	add_child(panel)

	var info := Label.new()
	info.text = "Permanent progression"
	info.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	info.add_theme_font_size_override("font_size", 20)
	panel.add_child(info)

	shard_label = Label.new()
	shard_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	shard_label.add_theme_font_size_override("font_size", 24)
	panel.add_child(shard_label)

	status_label = Label.new()
	status_label.custom_minimum_size = Vector2(520, 28)
	status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	status_label.add_theme_font_size_override("font_size", 16)
	panel.add_child(status_label)

	claim_button = Button.new()
	claim_button.text = "CLAIM FORGE CACHE"
	claim_button.custom_minimum_size = Vector2(440, 58)
	claim_button.pressed.connect(_claim_cache)
	panel.add_child(claim_button)

	vitality_button = Button.new()
	vitality_button.custom_minimum_size = Vector2(440, 58)
	vitality_button.pressed.connect(_buy_upgrade.bind("vitality"))
	panel.add_child(vitality_button)

	power_button = Button.new()
	power_button.custom_minimum_size = Vector2(440, 58)
	power_button.pressed.connect(_buy_upgrade.bind("power"))
	panel.add_child(power_button)

	var back := Button.new()
	back.text = "BACK TO MAIN MENU"
	back.custom_minimum_size = Vector2(440, 54)
	back.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/main.tscn"))
	panel.add_child(back)

func _refresh(message := "") -> void:
	shard_label.text = "Ember Shards: %d" % GameState.ember_shards
	claim_button.disabled = not GameState.forge_claim_ready
	vitality_button.text = "UPGRADE HERO VITALITY  Lv.%d  -  25 SHARDS" % int(GameState.forge_upgrades.get("vitality", 0))
	power_button.text = "UPGRADE STARTING POWER  Lv.%d  -  40 SHARDS" % int(GameState.forge_upgrades.get("power", 0))
	if GameState.forge_claim_ready:
		status_label.text = "CLAIM AVAILABLE"
		status_label.add_theme_color_override("font_color", Color("#ff5e63"))
	else:
		status_label.text = message if not message.is_empty() else "No unclaimed cache"
		status_label.add_theme_color_override("font_color", Color("#b8aab4"))

func _claim_cache() -> void:
	if not GameState.forge_claim_ready:
		return
	GameState.ember_shards += 50
	GameState.forge_claim_ready = false
	GameState.save_meta()
	_refresh("Forge cache claimed: +50 shards")

func _buy_upgrade(kind: String) -> void:
	var cost := 25 if kind == "vitality" else 40
	if GameState.ember_shards < cost:
		_refresh("Not enough Ember Shards")
		return
	GameState.ember_shards -= cost
	GameState.add_forge_upgrade(kind)
	GameState.save_meta()
	_refresh("%s upgraded" % kind.capitalize())
