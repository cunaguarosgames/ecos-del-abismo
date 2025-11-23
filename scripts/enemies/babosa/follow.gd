extends babosaStateBase

func on_process(delta: float) -> void:
	if babosa.target == null:
		state_machine.change_to("idle")
		babosa.velocity = Vector2.ZERO
		return
		
	var next_path_point = babosa.navigation.get_next_path_position()

	if babosa.global_position.distance_to(next_path_point) < 1.0 and babosa.navigation.is_navigation_finished():
		babosa.velocity = Vector2.ZERO
		babosa.animSprite.play("idle")
		return

	var direction = (next_path_point - babosa.global_position).normalized()
	if babosa.current_health <= babosa.max_health/2:
		babosa.velocity = direction * babosa.followSpeed
	else:
		babosa.velocity = direction * babosa.speed

	if direction.x != 0:
		babosa.animSprite.flip_h = direction.x < 0

	if babosa.target != null \
	   and babosa.target.is_in_group("player") \
	   and babosa.can_attack and babosa.attack_area:
		state_machine.change_to("attack")
	
	if babosa.current_health <= babosa.max_health/2:
		babosa.animSprite.play("run W_S")
	else:
		babosa.animSprite.play("run")
