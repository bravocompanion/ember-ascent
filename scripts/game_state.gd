extends Node

const SAVE_PATH := "user://ember_ascent.cfg"

var selected_hero := "Ashwarden"
var ember_shards := 120
var forge_claim_ready := true
var run_seed := 0

var heroes := [
	{"name":"Ashwarden","hp":82,"energy":3,"tagline":"Balanced defender","accent":Color("#d86b3d")},
	{"name":"Cinderblade","hp":70,"energy":4,"tagline":"Fast aggressive striker","accent":Color("#e34d4d")},
	{"name":"Emberseer","hp":66,"energy":3,"tagline":"Skills and burn synergy","accent":Color("#9c66e4")}
]

func _ready() -> void:
	load_meta()

func start_new_run(hero_name: String) -> void:
	selected_hero = hero_name
	run_seed = int(Time.get_unix_time_from_system())
	save_meta()

func hero_data() -> Dictionary:
	for hero in heroes:
		if hero.name == selected_hero:
			return hero
	return heroes[0]

func save_meta() -> void:
	var cfg := ConfigFile.new()
	cfg.set_value("profile", "selected_hero", selected_hero)
	cfg.set_value("profile", "ember_shards", ember_shards)
	cfg.set_value("profile", "forge_claim_ready", forge_claim_ready)
	cfg.save(SAVE_PATH)

func load_meta() -> void:
	var cfg := ConfigFile.new()
	if cfg.load(SAVE_PATH) != OK:
		return
	selected_hero = str(cfg.get_value("profile", "selected_hero", selected_hero))
	ember_shards = int(cfg.get_value("profile", "ember_shards", ember_shards))
	forge_claim_ready = bool(cfg.get_value("profile", "forge_claim_ready", forge_claim_ready))
