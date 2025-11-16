extends hummerStateBase

func on_physics_process(delta: float) -> void:
	if hummer.wait:
		hummer.velocity = Vector2.ZERO
		return

	var min_distance = 10.0
	var target = hummer.waypoints[hummer.current_index].global_position
	var distance_to_target_sq = hummer.global_position.distance_squared_to(target)
	
	if distance_to_target_sq <= min_distance * min_distance:
		hummer.velocity = Vector2.ZERO
		hummer.wait = true
		hummer.current_index = (hummer.current_index + 1) % hummer.waypoints.size() 
		
		hummer.TimerFollow.start() 
		state_machine.change_to("idle")
		return
	var next_path_point = hummer.navigation.get_next_path_position()
	var direction = (next_path_point - hummer.global_position).normalized()
	hummer.velocity = direction * hummer.speed
