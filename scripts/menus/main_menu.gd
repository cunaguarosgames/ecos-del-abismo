extends Control

@onready var play: Button = $CenterContainer/Panel/Play

func _ready() -> void:
	print("last room: ", GameState.game_data)

func _on_play_pressed():
	print("last room: ", GameState.game_data.last_room)
	if GameState.game_data.last_room != "":
		get_tree().change_scene_to_file(GameState.game_data.last_room)
	else:
		get_tree().change_scene_to_file("res://scenes/rooms/room01.tscn") 
