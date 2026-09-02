extends Control

const HeroArtScript = preload("res://scripts/hero_art.gd")

var hero: Dictionary
var max_hp := 1
var hp := 1
var block := 0
var energy := 3
var max_energy := 3
var turn := 1
var pending_card_index := -1
var victory_awarded := false

var hp_label: Label
var energy_label: Label
var block_label: Label
var turn_label: Label
var status_label: Label
var enemy_row: HBoxContainer
var hand_row: HBoxContainer
var end_turn_button: Button

var enemy_buttons: Array[Button] = []
var card_buttons: Array[Button] = []
var used_cards: Array[bool] = []

var enemies := [
	{"name":"Cinder Rat","hp":24,"max_hp":24,"damage":6,"intent":"Bite 6"},
	{"name":"Ash Cultist","hp":34,"max_hp":34,"damage":8,"intent":"Hex Strike 8"},
	{"name":"Ember Wisp","hp":20,"max_hp":20,"damage":5,"intent":"Scorch 5"}
]

var cards: Array[Dictionary] = []

func _ready() -> void:
	hero = GameState.hero_data()
	max_hp = int(hero["hp"]) + GameState.vitality_bonus()
	hp = max_hp
	max_energy = int(hero["energy"])
	energy = max_energy
	_build_cards()
	_build_ui()
	_refresh_all()

func _build_cards() -> void:
	var power := GameState.power_bonus()
	cards = [
		{"name":"Strike","type":"ATTACK","target":"enemy","cost":1,"damage":7 + power,"desc":"Deal %d damage" % (7 + power)},
		{"name":"Guard","type":"SKILL","target":"self","cost":1,"block":7,"desc":"Gain 7 Block"},
		{"name":"Ember Shot","type":"ATTACK","target":"enemy","cost":1,"damage":5 + power,"desc":"Deal %d fire damage" % (5 + power)},
		{"name":"Fortify","type":"SKILL","target":"self","cost":2,"block":12,"desc":"Gain 12 Block"},
		{"name":"Flame Arc","type":"ATTACK","target":"all_enemies","cost":2,"damage":4 + power,"desc":"Deal %d to ALL enemies" % (4 + power)}
	]
	used_cards.resize(cards.size())
	used_cards.fill(false)

func _build_ui() -> void:
	var bg := ColorRect.new()
	bg.color = Color("#0d0d13")
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(bg)

	var top_bar := HBoxContainer.new()
	top_bar.position = Vector2(28, 18)
	top_bar.size = Vector2(1224, 50)
	top_bar.add_theme_constant_override("separation", 30)
	add_child(top_bar)

	hp_label = _top_label()
	block_label = _top_label()
	energy_label = _top_label()
	turn_label = _top_label()
	top_bar.add_child(hp_label)
	top_bar.add_child(block_label)
	top_bar.add_child(energy_label)
	top_bar.add_child(turn_label)

	var quit := Button.new()
	quit.text = "MAIN MENU"
	quit.custom_minimum_size = Vector2(150, 44)
	quit.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/main.tscn"))
	top_bar.add_child(quit)

	# Enemy formations can grow without pushing a target outside the screen.
	var enemy_scroll := ScrollContainer.new()
	enemy_scroll.position = Vector2(340, 88)
	enemy_scroll.size = Vector2(910, 260)
	enemy_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO
	enemy_scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	enemy_scroll.follow_focus = true
	add_child(enemy_scroll)

	enemy_row = HBoxContainer.new()
	enemy_row.custom_minimum_size = Vector2(890, 245)
	enemy_row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	enemy_row.alignment = BoxContainer.ALIGNMENT_CENTER
	enemy_row.add_theme_constant_override("separation", 22)
	enemy_scroll.add_child(enemy_row)
	_build_enemy_widgets()

	var player_panel := VBoxContainer.new()
	player_panel.position = Vector2(34, 108)
	player_panel.size = Vector2(280, 300)
	player_panel.alignment = BoxContainer.ALIGNMENT_CENTER
	add_child(player_panel)

	var art := HeroArtScript.new()
	art.hero_id = str(hero.get("id", hero["name"]))
	art.accent = hero["accent"]
	art.custom_minimum_size = Vector2(190, 235)
	player_panel.add_child(art)

	var hero_name := Label.new()
	hero_name.text = str(hero["name"])
	hero_name.custom_minimum_size = Vector2(260, 30)
	hero_name.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	hero_name.add_theme_font_size_override("font_size", 20)
	player_panel.add_child(hero_name)

	status_label = Label.new()
	status_label.position = Vector2(300, 352)
	status_label.size = Vector2(680, 48)
	status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	status_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	status_label.add_theme_font_size_override("font_size", 18)
	status_label.add_theme_color_override("font_color", Color("#e7d5b8"))
	status_label.text = "Choose a card"
	add_child(status_label)

	# Cards now live inside a horizontal ScrollContainer. The current five-card
	# hand fits without scrolling, while larger future hands remain fully usable
	# instead of being cropped by the right edge of the viewport.
	var hand_scroll := ScrollContainer.new()
	hand_scroll.position = Vector2(32, 410)
	hand_scroll.size = Vector2(1068, 275)
	hand_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO
	hand_scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	hand_scroll.follow_focus = true
	add_child(hand_scroll)

	hand_row = HBoxContainer.new()
	hand_row.custom_minimum_size = Vector2(1048, 250)
	hand_row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hand_row.alignment = BoxContainer.ALIGNMENT_CENTER
	hand_row.add_theme_constant_override("separation", 12)
	hand_scroll.add_child(hand_row)
	_build_hand_widgets()

	end_turn_button = Button.new()
	end_turn_button.text = "END TURN"
	end_turn_button.position = Vector2(1110, 500)
	end_turn_button.size = Vector2(140, 90)
	end_turn_button.add_theme_font_size_override("font_size", 18)
	end_turn_button.pressed.connect(_end_turn)
	add_child(end_turn_button)

func _top_label() -> Label:
	var label := Label.new()
	label.custom_minimum_size = Vector2(180, 44)
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", 18)
	return label

func _build_enemy_widgets() -> void:
	enemy_buttons.clear()
	for i in enemies.size():
		var enemy_button := Button.new()
		enemy_button.custom_minimum_size = Vector2(245, 220)
		enemy_button.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		enemy_button.add_theme_font_size_override("font_size", 18)
		enemy_button.tooltip_text = "%s\nHP %d / %d\nIntent: %s" % [enemies[i]["name"], enemies[i]["hp"], enemies[i]["max_hp"], enemies[i]["intent"]]
		enemy_button.pressed.connect(_on_enemy_pressed.bind(i))
		enemy_row.add_child(enemy_button)
		enemy_buttons.append(enemy_button)

func _build_hand_widgets() -> void:
	card_buttons.clear()
	for i in cards.size():
		var card := cards[i]
		var button := Button.new()
		button.custom_minimum_size = Vector2(195, 230)
		button.text = "%s\n\n%s\n\n%s\n\nCOST %d" % [card["name"], card["type"], card["desc"], card["cost"]]
		button.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		button.tooltip_text = "%s — %s — Cost %d\n%s" % [card["name"], card["type"], card["cost"], card["desc"]]
		button.add_theme_font_size_override("font_size", 15)
		button.pressed.connect(_on_card_pressed.bind(i))
		hand_row.add_child(button)
		card_buttons.append(button)

func _on_card_pressed(index: int) -> void:
	if hp <= 0 or _all_enemies_dead():
		return
	var card := cards[index]
	if used_cards[index]:
		status_label.text = "That card has already been played this turn"
		return
	if energy < int(card["cost"]):
		status_label.text = "Not enough Energy"
		_card_denied_vfx(card_buttons[index])
		return
	var target_type := str(card["target"])
	if target_type == "enemy":
		pending_card_index = index
		status_label.text = "Select an enemy target for %s" % card["name"]
		_highlight_enemy_targets(true)
		return
	_resolve_card(index, -1)

func _on_enemy_pressed(enemy_index: int) -> void:
	if pending_card_index < 0:
		status_label.text = "Choose an attack card first"
		return
	if int(enemies[enemy_index]["hp"]) <= 0:
		return
	var card_index := pending_card_index
	pending_card_index = -1
	_highlight_enemy_targets(false)
	_resolve_card(card_index, enemy_index)

func _resolve_card(index: int, enemy_index: int) -> void:
	var card := cards[index]
	energy -= int(card["cost"])
	used_cards[index] = true
	var target_type := str(card["target"])

	if target_type == "enemy":
		_damage_enemy(enemy_index, int(card.get("damage", 0)), str(card["name"]))
	elif target_type == "all_enemies":
		for i in enemies.size():
			if int(enemies[i]["hp"]) > 0:
				_damage_enemy(i, int(card.get("damage", 0)), str(card["name"]))
		status_label.text = "%s hit every living enemy" % card["name"]
	else:
		block += int(card.get("block", 0))
		hp = mini(max_hp, hp + int(card.get("heal", 0)))
		_self_card_vfx(card_buttons[index])
		status_label.text = "%s applied to %s" % [card["name"], hero["name"]]

	_refresh_all()
	_check_victory()

func _damage_enemy(index: int, amount: int, source_name: String) -> void:
	enemies[index]["hp"] = maxi(0, int(enemies[index]["hp"]) - amount)
	_enemy_target_vfx(index)
	status_label.text = "%s dealt %d damage to %s" % [source_name, amount, enemies[index]["name"]]

func _enemy_target_vfx(index: int) -> void:
	# Offensive card VFX belongs to the enemy portrait/icon, never the played card.
	var target := enemy_buttons[index]
	target.pivot_offset = target.size * 0.5
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(target, "scale", Vector2(1.10, 1.10), 0.08)
	tween.parallel().tween_property(target, "modulate", Color("#ff9a79"), 0.08)
	tween.tween_property(target, "scale", Vector2.ONE, 0.13)
	tween.parallel().tween_property(target, "modulate", Color.WHITE, 0.13)

func _self_card_vfx(card_button: Button) -> void:
	# DEF/heal/self-skill VFX stays on the card itself by design.
	card_button.pivot_offset = card_button.size * 0.5
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_BACK)
	tween.tween_property(card_button, "scale", Vector2(1.07, 1.07), 0.09)
	tween.parallel().tween_property(card_button, "modulate", Color("#b7e5ff"), 0.09)
	tween.tween_property(card_button, "scale", Vector2.ONE, 0.16)
	tween.parallel().tween_property(card_button, "modulate", Color.WHITE, 0.16)

func _card_denied_vfx(card_button: Button) -> void:
	var start_x := card_button.position.x
	var tween := create_tween()
	tween.tween_property(card_button, "position:x", start_x - 7.0, 0.04)
	tween.tween_property(card_button, "position:x", start_x + 7.0, 0.07)
	tween.tween_property(card_button, "position:x", start_x, 0.04)

func _highlight_enemy_targets(enabled: bool) -> void:
	for i in enemy_buttons.size():
		if int(enemies[i]["hp"]) <= 0:
			continue
		enemy_buttons[i].modulate = Color("#fff1b8") if enabled else Color.WHITE

func _end_turn() -> void:
	if hp <= 0 or _all_enemies_dead():
		return
	pending_card_index = -1
	_highlight_enemy_targets(false)
	var total_damage := 0
	for enemy in enemies:
		if int(enemy["hp"]) <= 0:
			continue
		var incoming := int(enemy["damage"])
		var absorbed := mini(block, incoming)
		block -= absorbed
		incoming -= absorbed
		hp = maxi(0, hp - incoming)
		total_damage += incoming
	block = 0
	turn += 1
	energy = max_energy
	used_cards.fill(false)
	status_label.text = "Enemies dealt %d HP damage. Your turn." % total_damage
	_refresh_all()
	if hp <= 0:
		status_label.text = "RUN ENDED - return to Main Menu"
		end_turn_button.disabled = true

func _refresh_all() -> void:
	hp_label.text = "HP  %d / %d" % [hp, max_hp]
	block_label.text = "BLOCK  %d" % block
	energy_label.text = "ENERGY  %d / %d" % [energy, max_energy]
	turn_label.text = "TURN  %d" % turn
	for i in enemies.size():
		var enemy := enemies[i]
		var dead := int(enemy["hp"]) <= 0
		enemy_buttons[i].text = "%s\n\nHP %d / %d\n\nINTENT\n%s" % [enemy["name"], enemy["hp"], enemy["max_hp"], enemy["intent"]]
		enemy_buttons[i].disabled = dead
		enemy_buttons[i].modulate = Color("#6b6670") if dead else Color.WHITE
	for i in card_buttons.size():
		card_buttons[i].disabled = used_cards[i] or hp <= 0
		card_buttons[i].modulate = Color("#7d7880") if used_cards[i] else Color.WHITE

func _check_victory() -> void:
	if not _all_enemies_dead() or victory_awarded:
		return
	victory_awarded = true
	GameState.ember_shards += 15
	GameState.save_meta()
	status_label.text = "VICTORY - +15 Ember Shards"
	end_turn_button.disabled = true
	for button in card_buttons:
		button.disabled = true

func _all_enemies_dead() -> bool:
	for enemy in enemies:
		if int(enemy["hp"]) > 0:
			return false
	return true
