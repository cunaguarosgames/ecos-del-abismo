extends Control

func _ready() -> void:
	pass

func _on_play_pressed():
	if GameState.game_data.last_room != "":
		get_tree().change_scene_to_file(GameState.game_data.last_room)
	else:
		get_tree().change_scene_to_file("res://scenes/rooms/room01.tscn") 

func _on_exit_pressed() -> void:
	get_tree().quit()
