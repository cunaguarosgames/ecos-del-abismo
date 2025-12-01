extends Node2D

@export var bpm: float
@onready var button: Button = $CanvasLayer/Button
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var mesh_instance_2d: MeshInstance2D = $MeshInstance2D

func _on_button_pressed() -> void:
	get_tree().reload_current_scene()
	
func _ready() -> void:
	RhythmManager.connect("beat_signal", Callable(self, "_on_beat"))
	RhythmManager.start_music(audio_stream_player)
	
	if not bpm == 0.0:
		RhythmManager.set_bpm(bpm)

func _on_beat(beat_count):
	if mesh_instance_2d.visible == false:
		mesh_instance_2d.show()
	else:
		mesh_instance_2d.hide()
	
