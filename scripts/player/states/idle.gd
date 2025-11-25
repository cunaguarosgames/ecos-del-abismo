extends PlayerStateBase

func start() -> void:
	player.play_directional_animation("idle")

func on_physics_process(delta: float) -> void:
	if player.direction != Vector2.ZERO:
		player.last_direction = player.direction.normalized()

func on_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("primary_attack") and player.can_attack:
		state_machine.change_to(player.states.PrimaryAttack)
		return
	
	if Input.is_action_just_pressed("secondary_attack") and player.can_attack:
		state_machine.change_to(player.states.SecondaryAttack)
		return
	
	if Input.is_action_just_pressed("x"):
		state_machine.change_to(player.states.Dash)
		return
	
	if Input.is_action_pressed("up") or Input.is_action_pressed("down") or Input.is_action_pressed("left") or Input.is_action_pressed("right"):
		state_machine.change_to(player.states.Walk)
		return
	
	if Input.is_action_just_pressed("menu") and player.can_attack:
		state_machine.change_to(player.states.Menu)
		return
