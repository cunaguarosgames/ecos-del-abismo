extends CanvasLayer

func _input(event):
	if get_tree().current_scene:
		if event.is_action_pressed("escape"):
			if get_tree().paused:
				resume_game()
			else:
				pause_game()

func pause_game():
	get_tree().paused = true
	show()
	for n in get_tree().get_nodes_in_group("hard_pause"):
		n.set_process(false)
		n.set_physics_process(false)

func resume_game():
	hide()
	get_tree().paused = false
	for n in get_tree().get_nodes_in_group("hard_pause"):
		n.set_process(true)
		n.set_physics_process(true)

func _on_continue_pressed() -> void:
	resume_game()

func _on_exit_pressed() -> void:
	resume_game()
	get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn")
