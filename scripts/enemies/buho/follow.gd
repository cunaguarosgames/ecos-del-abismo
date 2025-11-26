extends buhoStateBase

func start():
	if buho.current_health <= 0 :
		state_machine.change_to("Death")
		return

func on_process(delta: float) -> void:
	
	if buho.target == null:
		state_machine.change_to("idle")
		buho.velocity = Vector2.ZERO
		return

	var next_path_point = buho.navigation.get_next_path_position()

	if buho.global_position.distance_to(next_path_point) < 1.0 and buho.navigation.is_navigation_finished():
		buho.velocity = Vector2.ZERO
		if buho.secondFase:
			buho.animSprite.play("idle_SF")
		else:
			buho.animSprite.play("idle")
		return

	var direction = (next_path_point - buho.global_position).normalized()
	buho.velocity = direction * buho.speed

	if direction.x != 0:
		buho.animSprite.flip_h = direction.x < 0

	if buho.secondFase:
		buho.animSprite.play("run_SF")
	else:
		buho.animSprite.play("run")
