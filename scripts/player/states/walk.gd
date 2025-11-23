extends PlayerStateBase

func on_physics_process(delta: float) -> void:
	if player.direction != Vector2.ZERO:
		player.last_direction = player.direction.normalized()
	
	player.direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	player.direction.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	
	player.direction = player.direction.normalized()
	player.velocity = player.direction * player.speed
	
	player.play_directional_animation("walk")
	
	player.move_and_slide()

func on_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("attack") and player.can_attack:
		state_machine.change_to(player.states.Attack)
		return
	
	if Input.is_action_just_pressed("x"):
		state_machine.change_to(player.states.Dash)
		return
	
	if not Input.is_action_pressed("up") and not Input.is_action_pressed("down") and not Input.is_action_pressed("left") and not Input.is_action_pressed("right"):
		state_machine.change_to(player.states.Idle)
		return
	
	if Input.is_action_just_pressed("menu") and player.can_attack:
		state_machine.change_to(player.states.Menu)
		return
	
