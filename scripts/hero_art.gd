extends Control
class_name HeroArt

@export var accent := Color("#d86b3d"):
	set(value):
		accent = value
		queue_redraw()

func _ready() -> void:
	custom_minimum_size = Vector2(190, 300)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	queue_redraw()

func _draw() -> void:
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
