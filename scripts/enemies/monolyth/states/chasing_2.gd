extends MonolythStateBase

var nav_agent: NavigationAgent2D

func start() -> void:
	monolyth.velocity = Vector2.ZERO

	if monolyth.has_node("NavigationAgent2D"):
		nav_agent = monolyth.get_node("NavigationAgent2D")
		nav_agent.path_desired_distance = 10.0
		nav_agent.target_desired_distance = 30.0

func on_physics_process(_delta: float) -> void:
	if monolyth.current_health <= 0:
		state_machine.change_to("Death2")
		return
		
	if not monolyth.player:
		state_machine.change_to("Idle2")
		return
		
	nav_agent.target_position = monolyth.player.global_position
	
	var distance_to_player = monolyth.global_position.distance_to(monolyth.player.global_position)
	var stop_range = 120
	
	if distance_to_player > stop_range:
		if not nav_agent.is_target_reached():
			monolyth.play_main_animation("walk2")
			var next_path_position = nav_agent.get_next_path_position()
			var direction_vector = (next_path_position - monolyth.global_position).normalized()
			monolyth.velocity = direction_vector * (monolyth.speed * 1.25)
			monolyth.direction = direction_vector
		else:
			monolyth.play_main_animation("idle2")
			monolyth.velocity = Vector2.ZERO
	else:
		monolyth.play_main_animation("idle2")
		monolyth.velocity = Vector2.ZERO

	monolyth.move_and_slide()
