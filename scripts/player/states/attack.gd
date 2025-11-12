extends PlayerStateBase

func start():
	player.can_attack = false

	var attack = preload("res://scenes/player/attacks/basic_attack.tscn").instantiate()
	attack.global_position = player.global_position
	attack.direction = player.last_direction
	get_parent().add_child(attack)

	player.attack_timer.start() 


func on_physics_process(delta: float) -> void:
	player.direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	player.direction.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	player.direction = player.direction.normalized()

	player.velocity = player.direction * (player.speed / 2.0)
	player.move_and_slide()

	player.play_directional_animation("attack")

func _on_attack_timer_timeout() -> void:
	if not (Input.is_action_pressed("up")
		or Input.is_action_pressed("down")
		or Input.is_action_pressed("left")
		or Input.is_action_pressed("right")):
		state_machine.change_to(player.states.Idle)
	else:
		state_machine.change_to(player.states.Walk)

func end():
	player.can_attack = true
	player.attack_timer.stop()
