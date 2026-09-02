extends Control

const HeroArtScript = preload("res://scripts/hero_art.gd")

func _ready() -> void:
	_build_ui()

func _build_ui() -> void:
	var bg := ColorRect.new()
	bg.color = Color("#100d14")
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(bg)

	var title := Label.new()
	title.text = "CHOOSE YOUR HERO"
	title.position = Vector2(0, 20)
	title.size = Vector2(1280, 58)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 36)
	title.add_theme_color_override("font_color", Color("#f3c78c"))
	add_child(title)

	var row := HBoxContainer.new()
	row.position = Vector2(105, 82)
	row.size = Vector2(1070, 540)
	row.alignment = BoxContainer.ALIGNMENT_CENTER
	row.add_theme_constant_override("separation", 26)
	add_child(row)

	for hero in GameState.heroes:
		row.add_child(_hero_card(hero))

	var back := Button.new()
	back.text = "BACK"
	back.position = Vector2(32, 650)
	back.size = Vector2(150, 48)
	back.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/main.tscn"))
	add_child(back)

func _hero_card(hero: Dictionary) -> Control:
	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(330, 530)

	var box := VBoxContainer.new()
	box.alignment = BoxContainer.ALIGNMENT_CENTER
	box.add_theme_constant_override("separation", 7)
	panel.add_child(box)

	var art := HeroArtScript.new()
	art.hero_id = str(hero.get("id", hero["name"]))
	art.accent = hero["accent"]
	art.custom_minimum_size = Vector2(300, 330)
	art.size_flags_vertical = Control.SIZE_EXPAND_FILL
	box.add_child(art)

	var name_label := Label.new()
	name_label.text = str(hero["name"])
	name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	name_label.add_theme_font_size_override("font_size", 25)
	name_label.add_theme_color_override("font_color", hero["accent"].lightened(0.22))
	box.add_child(name_label)

	var stats := Label.new()
	stats.text = "HP %d   ENERGY %d" % [hero["hp"], hero["energy"]]
	stats.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	stats.add_theme_font_size_override("font_size", 15)
	box.add_child(stats)

	var tagline := Label.new()
	tagline.text = str(hero["tagline"])
	tagline.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	tagline.add_theme_font_size_override("font_size", 14)
	tagline.add_theme_color_override("font_color", Color("#b9acb7"))
	box.add_child(tagline)

	var choose := Button.new()
	choose.text = "SELECT"
	choose.custom_minimum_size = Vector2(240, 50)
	choose.pressed.connect(_select_hero.bind(str(hero["name"])))
	box.add_child(choose)
	return panel

func _select_hero(hero_name: String) -> void:
	GameState.start_new_run(hero_name)
	get_tree().change_scene_to_file("res://scenes/battle.tscn")
