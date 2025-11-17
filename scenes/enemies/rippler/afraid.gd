extends RipplerStateBase

func start() -> void:
	rippler.play_main_animation("afraid") 
	rippler.velocity = Vector2.ZERO

func on_physics_process(_delta: float) -> void:
	if not rippler.player:
		state_machine.change_to("Walk")
		return
	
	var direction_vector = (rippler.player.position - rippler.position)
	
	rippler.velocity = direction_vector.normalized() * (rippler.speed / 2) * -1 
	
	if rippler.can_attack_player:
		state_machine.change_to("Attack")
	
	rippler.move_and_slide()
	
	# Transiciones de Salud
	if rippler.current_health <= 0:
		state_machine.change_to("Death")
		return
	
	if rippler.current_health <= rippler.max_health / 2 and rippler.current_health > rippler.max_health / 4 :
		state_machine.change_to("Furious")
	
	if rippler.current_health > rippler.max_health / 2:
		state_machine.change_to("Run")
