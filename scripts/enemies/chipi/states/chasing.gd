extends ChipiStateBase

var nav_agent: NavigationAgent2D

func start() -> void:
	chipi.velocity = Vector2.ZERO

	if chipi.has_node("NavigationAgent2D"):
		nav_agent = chipi.get_node("NavigationAgent2D")
		nav_agent.path_desired_distance = 10.0
		nav_agent.target_desired_distance = 30.0

func on_physics_process(_delta: float) -> void:
	if chipi.current_health <= 0:
		state_machine.change_to("Death")
		return
		
	if not chipi.player:
		state_machine.change_to("Idle")
		return
		
	nav_agent.target_position = chipi.player.global_position
	
	var distance_to_player = chipi.global_position.distance_to(chipi.player.global_position)
	var stop_range = 120
	
	if distance_to_player > stop_range:
		if not nav_agent.is_target_reached():
			chipi.play_main_animation("walk")
			var next_path_position = nav_agent.get_next_path_position()
			var direction_vector = (next_path_position - chipi.global_position).normalized()
			chipi.velocity = direction_vector * (chipi.speed * 1.25)
			chipi.direction = direction_vector
		else:
			chipi.play_main_animation("idle")
			chipi.velocity = Vector2.ZERO
	else:
		chipi.play_main_animation("idle")
		chipi.velocity = Vector2.ZERO

	chipi.move_and_slide()
