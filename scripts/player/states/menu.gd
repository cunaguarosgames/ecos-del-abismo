extends PlayerStateBase

func start():
	get_tree().paused = true
	player.skills_menu.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	player.update_skill_labels()
	player.skills_menu.show()

func on_process(delta: float) -> void:
	if Input.is_action_just_pressed("down"):
		var index = player.primary_skills_list.find(player.current_first_skill)
		index = (index + 1) % player.primary_skills_list.size()
		player.current_first_skill = player.primary_skills_list[index]

		GameState.game_data.primary_skill = player.current_first_skill
		GameState.save_game()

		var vbox = $"../../SkillsMenu/VBoxContainer"
		var tween = create_tween()
		var original_pos = vbox.position
		var offset = Vector2(0, 6)
		tween.tween_property(vbox, "position", original_pos + offset, 0.06)
		tween.tween_property(vbox, "position", original_pos, 0.06)
		
		player.update_skill_labels()

	if Input.is_action_just_pressed("up"):
		var index = player.primary_skills_list.find(player.current_first_skill)
		index = (index - 1 + player.primary_skills_list.size()) % player.primary_skills_list.size()
		player.current_first_skill = player.primary_skills_list[index]

		GameState.game_data.primary_skill = player.current_first_skill
		GameState.save_game()
		
		var vbox = $"../../SkillsMenu/VBoxContainer"
		var tween = create_tween()
		var original_pos = vbox.position
		var offset = Vector2(0, -6)
		tween.tween_property(vbox, "position", original_pos + offset, 0.06)
		tween.tween_property(vbox, "position", original_pos, 0.06)
		
		player.update_skill_labels()

	if Input.is_action_just_released("menu"):
		state_machine.change_to(player.states.Idle)

func end():
	get_tree().paused = false
	player.skills_menu.hide()
