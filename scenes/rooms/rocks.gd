extends StaticBody2D

@export var bpm: float = 0.0

@onready var rocks: Sprite2D = $Rocks
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var audio_stream_player: AudioStreamPlayer = $"../AudioStreamPlayer"
@onready var boss_music: AudioStreamPlayer = $"../BossMusic"

func _on_area_2d_body_entered(body: Node2D) -> void:
	rocks.visible = true
	collision_shape_2d.set_deferred("disabled", false)
	
	RhythmManager.end_music(audio_stream_player)
	
	RhythmManager.start_music(boss_music)
	if not bpm == 0.0:
		RhythmManager.set_bpm(bpm)
