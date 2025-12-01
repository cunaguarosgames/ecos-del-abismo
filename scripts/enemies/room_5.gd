extends Node2D


@export var bpm: float
@onready var player = $Player
@onready var spawn_points = $SpawnPoints.get_children()
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var audio_stream_player_boss: AudioStreamPlayer = $AudioStreamPlayer2
@onready var doorNextLevel = $DoorToNextLevel
@onready var Boss = $entities/buho 

var bossFight = false 

func _ready() -> void:
	for sp in $SpawnPoints.get_children():
		if sp.name == GameState.game_data.last_entry:
			player.global_position = sp.global_position
	GameState.game_data.last_room = get_tree().current_scene.get_scene_file_path()
	GameState.save_game()
	
	RhythmManager.start_music(audio_stream_player)
		
	if not bpm == 0.0:
		RhythmManager.set_bpm(bpm)
	
	doorNextLevel.hide()
	_conectar_senales()
	

func _conectar_senales():
	if is_instance_valid(Boss):
		Boss.enemigo_derrotado.connect(_abrir_puerta)

func _abrir_puerta():
	doorNextLevel.show()


func _on_detect_boss_fight_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		bossFight = true
		RhythmManager.end_music(audio_stream_player)
		RhythmManager.start_music(audio_stream_player_boss)
