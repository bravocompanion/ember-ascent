extends Control
class_name HeroArt

const AssetResolverScript = preload("res://scripts/asset_resolver.gd")

@export var hero_id := "ashwarden":
	set(value):
		hero_id = value
		_refresh_texture()

@export var accent := Color("#d86b3d"):
	set(value):
		accent = value
		queue_redraw()

var hero_texture: Texture2D

func _ready() -> void:
	custom_minimum_size = Vector2(190, 300)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	clip_contents = true
	_refresh_texture()

func _refresh_texture() -> void:
	hero_texture = AssetResolverScript.hero_full_body(hero_id)
	queue_redraw()

func _draw() -> void:
	if hero_texture != null:
		_draw_full_body_texture(hero_texture)
		return
	_draw_procedural_fallback()

func _draw_full_body_texture(texture: Texture2D) -> void:
	var tex_size := texture.get_size()
	if tex_size.x <= 0.0 or tex_size.y <= 0.0:
		return
	# Contain, never cover: the feet/bottom of full-body art must stay visible.
	var available := Vector2(maxf(1.0, size.x - 8.0), maxf(1.0, size.y - 8.0))
	var scale_factor := minf(available.x / tex_size.x, available.y / tex_size.y)
	var draw_size := tex_size * scale_factor
	var draw_pos := Vector2((size.x - draw_size.x) * 0.5, size.y - draw_size.y - 4.0)
	draw_texture_rect(texture, Rect2(draw_pos, draw_size), false)

func _draw_procedural_fallback() -> void:
	var s := size
	var cx := s.x * 0.5
	var top := maxf(12.0, s.y * 0.04)
	var head_r := minf(s.x, s.y) * 0.12
	var body_top := top + head_r * 2.2
	var body_bottom := s.y * 0.76
	var leg_bottom := s.y * 0.96
	var glow := Color(accent, 0.22)
	draw_circle(Vector2(cx, s.y * 0.48), s.x * 0.42, glow)
	draw_circle(Vector2(cx, top + head_r), head_r, accent.lightened(0.15))
	var torso := PackedVector2Array([
		Vector2(cx - s.x * 0.19, body_top),
		Vector2(cx + s.x * 0.19, body_top),
		Vector2(cx + s.x * 0.14, body_bottom),
		Vector2(cx - s.x * 0.14, body_bottom)
	])
	draw_colored_polygon(torso, accent)
	draw_line(Vector2(cx - s.x * 0.17, body_top + 12), Vector2(cx - s.x * 0.34, s.y * 0.62), accent.lightened(0.08), 18.0, true)
	draw_line(Vector2(cx + s.x * 0.17, body_top + 12), Vector2(cx + s.x * 0.34, s.y * 0.62), accent.lightened(0.08), 18.0, true)
	draw_line(Vector2(cx - s.x * 0.08, body_bottom), Vector2(cx - s.x * 0.16, leg_bottom), accent.darkened(0.12), 22.0, true)
	draw_line(Vector2(cx + s.x * 0.08, body_bottom), Vector2(cx + s.x * 0.16, leg_bottom), accent.darkened(0.12), 22.0, true)
