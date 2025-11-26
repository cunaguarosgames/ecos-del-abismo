extends hummerStateBase

func on_process(delta: float) -> void:
	if hummer.target == null:
		state_machine.change_to("idle")
		
	var next_path_point = hummer.navigation.get_next_path_position()

	if hummer.global_position.distance_to(next_path_point) < 1.0 and hummer.navigation.is_navigation_finished():
		hummer.velocity = Vector2.ZERO
		hummer.animSprite.play("idle")
		return

	var direction = (next_path_point - hummer.global_position).normalized()
	hummer.velocity = direction * hummer.speed

	if direction.x != 0:
		hummer.animSprite.flip_h = direction.x < 0

	hummer.animSprite.play("run")
