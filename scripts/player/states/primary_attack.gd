extends PlayerStateBase

func start():
	player.can_attack = false
	var attack_file: String = player.player_attacks.primary_attacks[player.current_primary_skill]["file"]

	var attack = load(attack_file).instantiate()
	attack.global_position = player.global_position
	attack.direction = player.last_direction
	
	if RhythmManager.is_on_beat():
		attack.damage *= 2
		if player.animated_sprite_2d.material:
			var mat = player.animated_sprite_2d.material
			mat.set_shader_parameter("glow_strength", 2.5)
			var new_color = Color.from_hsv(randf(), randf_range(0.5, 1.0), randf_range(0.9, 1.0))
			mat.set_shader_parameter("outline_color", new_color)
			mat.set_shader_parameter("outline_size", 1.0)
	else:
		pass
		
	get_parent().add_child(attack)

	player.primary_attack_timer.start()
	player.play_directional_animation("attack")

func on_physics_process(delta: float) -> void:
	player.direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	player.direction.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	player.direction = player.direction.normalized()

	player.velocity = player.direction * (player.speed / 1.25)
	player.move_and_slide()

func end():
	player.can_attack = true
	player.primary_attack_timer.stop()
	if player.animated_sprite_2d.material:
		player.animated_sprite_2d.material.set_shader_parameter("glow_strength", 0.0)


func _on_primary_attack_timer_timeout() -> void:
	if not (Input.is_action_pressed("up")
		or Input.is_action_pressed("down")
		or Input.is_action_pressed("left")
		or Input.is_action_pressed("right")):
		state_machine.change_to(player.states.Idle)
	else:
		state_machine.change_to(player.states.Walk)
