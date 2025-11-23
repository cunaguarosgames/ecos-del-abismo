extends buhoStateBase

func on_process(delta: float) -> void:
	if buho.target == null:
		state_machine.change_to("idle")
		buho.velocity = Vector2.ZERO
		return
		
	buho.navigation.set_target_position(buho.target.global_position) 

	var next_path_point = buho.navigation.get_next_path_position()

	if buho.navigation.is_navigation_finished() and buho.global_position.distance_to(buho.target.global_position) < 1.0:
		buho.velocity = Vector2.ZERO
		buho.animSprite.play("idle")
		return

	var direction = (next_path_point - buho.global_position).normalized()
	buho.velocity = direction * buho.speed

	if direction.x != 0:
		buho.animSprite.flip_h = direction.x < 0
	
	buho.animSprite.play("run")
