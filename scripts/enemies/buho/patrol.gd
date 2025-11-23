extends buhoStateBase

func on_physics_process(delta: float) -> void:

	# Si hay jugador → pasar a follow
	if buho.target != null:
		state_machine.change_to("follow")
		return

	# Si está esperando
	if buho.wait:
		buho.velocity = Vector2.ZERO
		buho.animSprite.play("idle")
		return

	# Patrulla normal
	var target_position = buho.waypoints[buho.current_index].global_position
	var min_distance = 10.0

	# Llegó al waypoint
	if buho.global_position.distance_to(target_position) <= min_distance:
		buho.velocity = Vector2.ZERO
		buho.wait = true
		buho.animSprite.play("idle")

		# Cambiar siguiente waypoint
		buho.current_index = (buho.current_index + 1) % buho.waypoints.size()

		# Timer de espera
		buho.TimerFollow.start()
		return

	# Movimiento hacia el waypoint
	buho.navigation.set_target_position(target_position)

	var next_point = buho.navigation.get_next_path_position()
	var direction = (next_point - buho.global_position).normalized()
	buho.velocity = direction * buho.speed

	if direction.x != 0:
		buho.animSprite.flip_h = direction.x < 0

	buho.animSprite.play("run")
