extends BrutalonStateBase

var nav_agent: NavigationAgent2D

func start() -> void:
	brutalon.velocity = Vector2.ZERO

	if brutalon.has_node("NavigationAgent2D"):
		nav_agent = brutalon.get_node("NavigationAgent2D")
		nav_agent.path_desired_distance = 10.0
		nav_agent.target_desired_distance = 30.0

func on_physics_process(_delta: float) -> void:
	if brutalon.current_health <= 0:
		state_machine.change_to("Death")
		return
		
	if not brutalon.player:
		state_machine.change_to("Idle")
		return
		
	nav_agent.target_position = brutalon.player.global_position
	
	var distance_to_player = brutalon.global_position.distance_to(brutalon.player.global_position)
	var stop_range = 120
	
	if distance_to_player > stop_range:
		if not nav_agent.is_target_reached():
			brutalon.play_main_animation("walk")
			var next_path_position = nav_agent.get_next_path_position()
			var direction_vector = (next_path_position - brutalon.global_position).normalized()
			brutalon.velocity = direction_vector * (brutalon.speed * 1.25)
			brutalon.direction = direction_vector
		else:
			brutalon.play_main_animation("idle")
			brutalon.velocity = Vector2.ZERO
	else:
		brutalon.play_main_animation("idle")
		brutalon.velocity = Vector2.ZERO

	brutalon.move_and_slide()
