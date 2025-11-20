extends Node

var SAVE_PATH = "user://ecos_del_abismo.dat"

var game_data: Dictionary = {
	last_room = "",
	last_entry = "",
	primary_skill = "basic1",
}

func _ready() -> void:
	load_game()
	save_game()

func save_game():
	var save_file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	
	save_file.store_var(game_data)
	save_file.close()

func load_game():
	if FileAccess.file_exists(SAVE_PATH):
		var save_file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		game_data = save_file.get_var()
		save_file.close()
