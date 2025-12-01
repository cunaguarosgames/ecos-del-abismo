extends Control

@onready var panel: VBoxContainer = $Panel
@onready var panel_options: VBoxContainer = $PanelOptions
@onready var color_rect: ColorRect = $ColorRect

func _ready() -> void:
	fade_in_logo()

func _on_play_pressed():
	if GameState.game_data.last_room != "":
		get_tree().change_scene_to_file(GameState.game_data.last_room)
	else:
		get_tree().change_scene_to_file("res://scenes/rooms/room_1.tscn") 

func _on_exit_pressed() -> void:
	get_tree().quit()

func _on_options_pressed() -> void:
	panel.hide()
	panel_options.show()

func _on_reset_progress_pressed() -> void:
	GameState.reset()

func _on_back_pressed() -> void:
	panel.show()
	panel_options.hide()

func fade_in_logo() -> void:
	var t := create_tween()
	
	t.tween_property(color_rect, "modulate:a", 0.0, 1.5)
