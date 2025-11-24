extends StalkerStateBase

var nav_agent: NavigationAgent2D

func start() -> void:
	stalker.play_main_animation("idle")
	stalker.velocity = Vector2.ZERO

	if stalker.has_node("NavigationAgent2D"):
		nav_agent = stalker.get_node("NavigationAgent2D")
		nav_agent.path_desired_distance = 10.0
		nav_agent.target_desired_distance = 30.0

func on_physics_process(_delta: float) -> void:
	if stalker.current_health <= 0:
		state_machine.change_to("Death")
		return

	if not stalker.player:
		state_machine.change_to("Idle")
		return

	nav_agent.target_position = stalker.player.global_position

	var distance_to_player = stalker.global_position.distance_to(stalker.player.global_position)
	var stop_range = 90

	if distance_to_player > stop_range:
		if not nav_agent.is_target_reached():
			var next_path_position = nav_agent.get_next_path_position()
			var direction_vector = (next_path_position - stalker.global_position).normalized()
			stalker.velocity = direction_vector * (stalker.speed * 1.25)
		else:
			stalker.velocity = Vector2.ZERO
	else:
		stalker.velocity = Vector2.ZERO

	stalker.move_and_slide()
