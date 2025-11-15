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
	var distance = direction_vector.length()
	var stop_range = 30
	
	if distance > stop_range:
		rippler.velocity = direction_vector.normalized() * (rippler.speed * 1.5)
	else:
		rippler.velocity = Vector2.ZERO
	
	rippler.move_and_slide()
	
	if rippler.can_attack:
		rippler.check_for_attack()
