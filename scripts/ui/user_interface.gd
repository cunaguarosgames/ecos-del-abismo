extends CanvasLayer

@onready var beat_circle = $Control/BeatCircle

func _ready():
	RhythmManager.connect("beat_signal", Callable(self, "_on_beat"))
	if beat_circle.material:
		beat_circle.material = beat_circle.material.duplicate()
		
	var new_color = Color.from_hsv(randf(), randf_range(0.5, 1.0), randf_range(0.9, 1.0))
	_set_color(0, new_color)
	
	new_color.v = 0.5
	_set_color(1, new_color)

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

func _set_color(idx: int, new_color: Color) -> void:
	var mat: ShaderMaterial = beat_circle.material
	if mat:
		var colors: Array = mat.get_shader_parameter("to_palette")
		if idx >= 0 and idx < colors.size():
			colors[idx] = new_color
			mat.set_shader_parameter("to_palette", colors)
