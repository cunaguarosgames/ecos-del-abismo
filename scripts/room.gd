extends Node2D

@export var bpm: float
@onready var player = $Player
@onready var spawn_points = $SpawnPoints.get_children()
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

func _ready():
	for sp in $SpawnPoints.get_children():
		if sp.name == GameState.game_data.last_entry:
			player.global_position = sp.global_position
	GameState.game_data.last_room = get_tree().current_scene.get_scene_file_path()
	GameState.save_game()
	
	audio_stream_player.process_mode = Node.PROCESS_MODE_ALWAYS
	
	RhythmManager.start_music(audio_stream_player)
	if not bpm == 0.0:
		RhythmManager.set_bpm(bpm)
