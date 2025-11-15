extends RipplerStateBase

func start() -> void:
	rippler.play_main_animation("furious")
	rippler.velocity = Vector2.ZERO

func on_physics_process(_delta: float) -> void:
	if not rippler.player:
		state_machine.change_to("Walk")
		return
	
	var direction_vector = (rippler.player.position - rippler.position)
	var distance = direction_vector.length()
	var stop_range = 30
	
	if distance > stop_range:
		rippler.velocity = direction_vector.normalized() * (rippler.speed * 1.25)
	else:
		rippler.velocity = Vector2.ZERO
	
	if rippler.can_attack:
		rippler.check_for_attack()
	
	rippler.move_and_slide()
	
	if rippler.current_health <= 0:
		state_machine.change_to("Death")
		return
	
	if rippler.current_health <= rippler.max_health / 4 :
		state_machine.change_to("Afraid")
	
	if rippler.current_health > rippler.max_health / 2:
		state_machine.change_to("Run")
