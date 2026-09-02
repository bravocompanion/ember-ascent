extends Control

const MAIN_SCENE := "res://scenes/main.tscn"
const MIN_LOAD_SECONDS := 10.0

var elapsed := 0.0
var progress_bar: ProgressBar
var percent_label: Label
var status_label: Label
var requested := false
var transition_started := false

func _ready() -> void:
	_build_ui()
	requested = ResourceLoader.load_threaded_request(MAIN_SCENE) == OK
	set_process(true)

func _process(delta: float) -> void:
	if transition_started:
		return
	elapsed += delta
	var time_progress := clampf(elapsed / MIN_LOAD_SECONDS, 0.0, 1.0)
	var resource_progress := 0.0
	var load_status := ResourceLoader.THREAD_LOAD_INVALID_RESOURCE

	if requested:
		var progress: Array = []
		load_status = ResourceLoader.load_threaded_get_status(MAIN_SCENE, progress)
		if not progress.is_empty():
			resource_progress = clampf(float(progress[0]), 0.0, 1.0)

	var shown_progress := minf(0.99, maxf(time_progress * 0.92, resource_progress * 0.92))
	if elapsed >= MIN_LOAD_SECONDS:
		shown_progress = 1.0
	progress_bar.value = shown_progress * 100.0
	percent_label.text = "%d%%" % int(round(shown_progress * 100.0))

	if elapsed < 3.2:
		status_label.text = "Igniting the forge..."
	elif elapsed < 6.4:
		status_label.text = "Tempering cards, relics and encounters..."
	elif elapsed < 9.2:
		status_label.text = "Preparing Ember Ascent..."
	else:
		status_label.text = "Ready."

	if elapsed < MIN_LOAD_SECONDS:
		return

	if requested and load_status == ResourceLoader.THREAD_LOAD_IN_PROGRESS:
		return

	transition_started = true
	if requested and load_status == ResourceLoader.THREAD_LOAD_LOADED:
		var packed := ResourceLoader.load_threaded_get(MAIN_SCENE) as PackedScene
		if packed != null:
			get_tree().change_scene_to_packed(packed)
			return
	get_tree().change_scene_to_file(MAIN_SCENE)

func _build_ui() -> void:
	var bg := ColorRect.new()
	bg.color = Color("#0b0d12")
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(bg)

	var glow := ColorRect.new()
	glow.color = Color("#251514")
	glow.anchor_left = 0.18
	glow.anchor_top = 0.16
	glow.anchor_right = 0.82
	glow.anchor_bottom = 0.84
	bg.add_child(glow)

	var center := VBoxContainer.new()
	center.set_anchors_preset(Control.PRESET_CENTER)
	center.position = Vector2(-320, -150)
	center.size = Vector2(640, 300)
	center.alignment = BoxContainer.ALIGNMENT_CENTER
	center.add_theme_constant_override("separation", 16)
	add_child(center)

	var mark := Label.new()
	mark.text = "EMBER ASCENT"
	mark.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	mark.add_theme_font_size_override("font_size", 46)
	mark.add_theme_color_override("font_color", Color("#f2bd7c"))
	center.add_child(mark)

	var subtitle := Label.new()
	subtitle.text = "THE LIVING FORGE AWAKENS"
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	subtitle.add_theme_font_size_override("font_size", 15)
	subtitle.add_theme_color_override("font_color", Color("#b9a79f"))
	center.add_child(subtitle)

	var spacer := Control.new()
	spacer.custom_minimum_size = Vector2(1, 22)
	center.add_child(spacer)

	progress_bar = ProgressBar.new()
	progress_bar.custom_minimum_size = Vector2(560, 24)
	progress_bar.min_value = 0.0
	progress_bar.max_value = 100.0
	progress_bar.value = 0.0
	progress_bar.show_percentage = false
	center.add_child(progress_bar)

	percent_label = Label.new()
	percent_label.text = "0%"
	percent_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	percent_label.add_theme_font_size_override("font_size", 15)
	percent_label.add_theme_color_override("font_color", Color("#e5cfb5"))
	center.add_child(percent_label)

	status_label = Label.new()
	status_label.text = "Igniting the forge..."
	status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	status_label.add_theme_font_size_override("font_size", 16)
	status_label.add_theme_color_override("font_color", Color("#c1b4b8"))
	center.add_child(status_label)

	var note := Label.new()
	note.text = "Loading core systems and warming the forge"
	note.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	note.add_theme_font_size_override("font_size", 12)
	note.add_theme_color_override("font_color", Color("#746a70"))
	center.add_child(note)
