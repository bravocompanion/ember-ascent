extends Node

const SAVE_PATH := "user://ember_ascent.cfg"

var selected_hero := "Ashwarden"
var ember_shards := 120
var forge_claim_ready := true
var run_seed := 0
var forge_upgrades := {"vitality": 0, "power": 0}

var heroes := [
	{"id":"ashwarden","name":"Ashwarden","hp":82,"energy":3,"tagline":"Balanced defender","accent":Color("#d86b3d")},
	{"id":"cinderblade","name":"Cinderblade","hp":70,"energy":4,"tagline":"Fast aggressive striker","accent":Color("#e34d4d")},
	{"id":"emberseer","name":"Emberseer","hp":66,"energy":3,"tagline":"Skills and burn synergy","accent":Color("#9c66e4")}
]

func _ready() -> void:
	load_meta()

func start_new_run(hero_name: String) -> void:
	selected_hero = hero_name
	run_seed = int(Time.get_unix_time_from_system())
	save_meta()

func hero_data() -> Dictionary:
	for hero in heroes:
		if hero["name"] == selected_hero:
			return hero
	return heroes[0]

func add_forge_upgrade(kind: String) -> void:
	if not forge_upgrades.has(kind):
		forge_upgrades[kind] = 0
	forge_upgrades[kind] = int(forge_upgrades[kind]) + 1

func vitality_bonus() -> int:
	return int(forge_upgrades.get("vitality", 0)) * 4

func power_bonus() -> int:
	return int(forge_upgrades.get("power", 0))

func save_meta() -> void:
	var cfg := ConfigFile.new()
	cfg.set_value("profile", "selected_hero", selected_hero)
	cfg.set_value("profile", "ember_shards", ember_shards)
	cfg.set_value("profile", "forge_claim_ready", forge_claim_ready)
	cfg.set_value("forge", "vitality", int(forge_upgrades.get("vitality", 0)))
	cfg.set_value("forge", "power", int(forge_upgrades.get("power", 0)))
	cfg.save(SAVE_PATH)

func load_meta() -> void:
	var cfg := ConfigFile.new()
	if cfg.load(SAVE_PATH) != OK:
		return
	selected_hero = str(cfg.get_value("profile", "selected_hero", selected_hero))
	ember_shards = int(cfg.get_value("profile", "ember_shards", ember_shards))
	forge_claim_ready = bool(cfg.get_value("profile", "forge_claim_ready", forge_claim_ready))
	forge_upgrades["vitality"] = int(cfg.get_value("forge", "vitality", 0))
	forge_upgrades["power"] = int(cfg.get_value("forge", "power", 0))
