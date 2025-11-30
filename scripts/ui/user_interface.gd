extends CanvasLayer

@onready var beat_circle = $Control/BeatCircle
@onready var combo_circle: TextureRect = $Control/ComboCircle
@onready var combo_label: Label = $Control/ComboLabel

func _ready():
	RhythmManager.connect("beat_signal", Callable(self, "_on_beat"))
	
	if beat_circle.material:
		beat_circle.material = beat_circle.material.duplicate()
		
	var new_color = Color.from_hsv(randf(), randf_range(0.5, 1.0), randf_range(0.9, 1.0))
	_set_color(0, new_color)
	
	new_color.v = 0.5
	_set_color(1, new_color)
	
	ComboManager.combo_changed.connect(_on_combo_changed)
	ComboManager.combo_reset.connect(_on_combo_reset)

	combo_circle.visible = false
	combo_label.visible = false

func _on_beat(beat_count):
	if beat_circle.material:
		beat_circle.material = beat_circle.material.duplicate()
		
	var new_color = Color.from_hsv(randf(), randf_range(0.5, 1.0), randf_range(0.9, 1.0))
	_set_color(0, new_color)
	
	new_color.v = 0.5
	_set_color(1, new_color)
	
	var t = create_tween()
	beat_circle.scale = Vector2.ONE
	t.tween_property(beat_circle, "scale", Vector2(1.25, 1.25), 0.02)
	t.tween_property(beat_circle, "scale", Vector2.ONE, 0.1)
	
	var t2 = create_tween()
	combo_circle.scale = Vector2.ONE
	t2.tween_property(combo_circle, "scale", Vector2(1.25, 1.25), 0.02)
	t2.tween_property(combo_circle, "scale", Vector2.ONE, 0.1)
	
	var t3 = create_tween()
	combo_label.scale = Vector2.ONE
	t3.tween_property(combo_label, "scale", Vector2(1.25, 1.25), 0.02)
	t3.tween_property(combo_label, "scale", Vector2.ONE, 0.1)

func _on_combo_changed(new_combo):
	combo_circle.visible = true
	combo_label.visible = true
	combo_label.text = "x" + str(new_combo)
	
	if combo_circle.material:
		combo_circle.material = combo_circle.material.duplicate()

	var new_color = Color.from_hsv(randf(), 1.0, 1.0)
	_set_combo_color(0, new_color)
	_set_combo_color(1, new_color.darkened(0.3))

func _process(delta):
	if ComboManager.combo > 0:
		var t = ComboManager.time_since_last_hit
		var max_t = ComboManager.combo_timeout

		var fill = clamp(1.0 - (t / max_t), 0.0, 1.0)

		if combo_circle.material:
			combo_circle.material.set_shader_parameter("fill", fill)

func _on_combo_reset():
	combo_circle.visible = false
	combo_label.visible = false

func _set_color(idx: int, new_color: Color) -> void:
	var mat: ShaderMaterial = beat_circle.material
	if mat:
		var colors: Array = mat.get_shader_parameter("to_palette")
		if idx >= 0 and idx < colors.size():
			colors[idx] = new_color
			mat.set_shader_parameter("to_palette", colors)

func _set_combo_color(idx: int, new_color: Color) -> void:
	var mat: ShaderMaterial = combo_circle.material
	if mat:
		var colors: Array = mat.get_shader_parameter("to_palette")
		if idx >= 0 and idx < colors.size():
			colors[idx] = new_color
			mat.set_shader_parameter("to_palette", colors)
