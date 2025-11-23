extends CanvasLayer

@onready var beat_circle = $Control/BeatCircle

func _ready():
	RhythmManager.connect("beat_signal", Callable(self, "_on_beat"))

func _on_beat(beat_count):
	var t = create_tween()
	beat_circle.scale = Vector2.ONE
	t.tween_property(beat_circle, "scale", Vector2(1.25, 1.25), 0.02)
	t.tween_property(beat_circle, "scale", Vector2.ONE, 0.1)
