extends PlayerStateBase

func start() -> void:
	player.play_directional_animation("idle")

func on_physics_process(delta: float) -> void:
	if player.direction != Vector2.ZERO:
		player.last_direction = player.direction.normalized()

func on_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("attack") and player.can_attack:
		state_machine.change_to(player.states.Attack)
	
	if Input.is_action_pressed("up") or Input.is_action_pressed("down") or Input.is_action_pressed("left") or Input.is_action_pressed("right"):
		state_machine.change_to(player.states.Walk)
	
