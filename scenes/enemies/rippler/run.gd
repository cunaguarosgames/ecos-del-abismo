extends RipplerStateBase

func start() -> void:
	rippler.play_main_animation("run")
	rippler.velocity = Vector2.ZERO


func on_physics_process(_delta: float) -> void:
	if rippler.current_health <= 0:
		state_machine.change_to("Death")
		return
		
	if rippler.current_health <= rippler.max_health / 2:
		state_machine.change_to("Furious")
		return

	if not rippler.player:
		state_machine.change_to("Walk")
		return

	var direction_vector = (rippler.player.position - rippler.position)
	
	rippler.velocity = direction_vector.normalized() * (rippler.speed * 1.5)
	
	rippler.move_and_slide()
	
	if rippler.can_attack_player:
		state_machine.change_to("Attack")
