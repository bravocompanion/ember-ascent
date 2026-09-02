extends RefCounted
class_name AssetResolver

const HERO_FULL_BODY_DIR := "res://assets/heroes/full_body/"
const HERO_ICON_DIR := "res://assets/heroes/icons/"
const ENEMY_DIR := "res://assets/enemies/"
const CARD_DIR := "res://assets/cards/"
const RELIC_DIR := "res://assets/relics/"

static func slugify(value: String) -> String:
	return value.strip_edges().to_lower().replace(" ", "_").replace("-", "_")

static func _first_texture(paths: Array[String]) -> Texture2D:
	for path in paths:
		if ResourceLoader.exists(path):
			var resource := load(path)
			if resource is Texture2D:
				return resource as Texture2D
	return null

static func hero_full_body(hero_id: String) -> Texture2D:
	var id := slugify(hero_id)
	return _first_texture([
		HERO_FULL_BODY_DIR + id + ".webp",
		HERO_FULL_BODY_DIR + id + ".png",
		HERO_FULL_BODY_DIR + id + ".jpg",
		HERO_FULL_BODY_DIR + id + ".jpeg"
	])

static func hero_icon(hero_id: String) -> Texture2D:
	var id := slugify(hero_id)
	return _first_texture([
		HERO_ICON_DIR + id + ".webp",
		HERO_ICON_DIR + id + ".png",
		HERO_ICON_DIR + id + ".jpg",
		HERO_ICON_DIR + id + ".jpeg"
	])

static func enemy_icon(enemy_id: String) -> Texture2D:
	var id := slugify(enemy_id)
	return _first_texture([ENEMY_DIR + id + ".webp", ENEMY_DIR + id + ".png"])

static func card_icon(card_id: String) -> Texture2D:
	var id := slugify(card_id)
	return _first_texture([CARD_DIR + id + ".webp", CARD_DIR + id + ".png"])

static func relic_icon(relic_id: String) -> Texture2D:
	var id := slugify(relic_id)
	return _first_texture([RELIC_DIR + id + ".webp", RELIC_DIR + id + ".png"])
