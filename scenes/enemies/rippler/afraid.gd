extends RipplerStateBase

func start() -> void:
	rippler.play_main_animation("afraid") 
	rippler.velocity = Vector2.ZERO

func on_physics_process(_delta: float) -> void:
	if not rippler.player:
		state_machine.change_to("Walk")
		return
	
	var direction = (rippler.player.position - rippler.position).normalized()
	rippler.velocity = direction * (rippler.speed / 2)
	
	if rippler.can_attack:
		rippler.check_for_attack()
	
	rippler.move_and_slide()
	
	if rippler.current_health <=0: 
		state_machine.change_to("Death")
	
	if rippler.current_health <= rippler.max_health / 2 and rippler.current_health > rippler.max_health / 4 : 
		state_machine.change_to("Furious")
	
	if rippler.current_health > rippler.max_health / 2:
		state_machine.change_to("Run")
