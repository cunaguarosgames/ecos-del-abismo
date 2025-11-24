extends buhoStateBase

func on_physics_process(delta: float) -> void:
	if buho.target != null:
		state_machine.change_to("follow")
		return

	if buho.wait:
		buho.velocity = Vector2.ZERO
		if buho.secondFase:
			buho.animSprite.play("idle_SF")
		else:
			buho.animSprite.play("idle")
		return

	var target_pos = buho.waypoints[buho.current_index].global_position
	var min_distance = 10.0

	if buho.global_position.distance_to(target_pos) <= min_distance:
		buho.velocity = Vector2.ZERO
		buho.wait = true

		if buho.secondFase:
			buho.animSprite.play("idle_SF")
		else:
			buho.animSprite.play("idle")

		buho.current_index = (buho.current_index + 1) % buho.waypoints.size()
		buho.TimerFollow.start()
		return

	var next_point = buho.navigation.get_next_path_position()
	var direction = (next_point - buho.global_position).normalized()
	buho.velocity = direction * buho.speed

	if direction.x != 0:
		buho.animSprite.flip_h = direction.x < 0

	if buho.secondFase:
		buho.animSprite.play("run_SF")
	else:
		buho.animSprite.play("run")
