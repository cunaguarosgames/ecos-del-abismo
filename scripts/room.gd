extends Node2D

@onready var player = $Player
@onready var spawn_points = $SpawnPoints.get_children()

func _ready():
	for sp in $SpawnPoints.get_children():
		if sp.name == GameState.game_data.last_entry:
			player.global_position = sp.global_position
	GameState.game_data.last_room = get_tree().current_scene.get_scene_file_path()
	GameState.save_game()
	print("last room: ", GameState.game_data.last_room)
	print("last entry: ", GameState.game_data.last_entry)
