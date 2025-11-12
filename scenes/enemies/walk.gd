extends RipplerStateBase

func start() -> void:
	if rippler.current_health > rippler.max_health / 2:
		rippler.play_main_animation("walk") 
	if rippler.current_health <= rippler.max_health / 2 and rippler.current_health > rippler.max_health / 4 : 
		rippler.play_main_animation("furious") 
	if rippler.current_health <= rippler.max_health / 4: 
		rippler.play_main_animation("afraid") 
		
	rippler.velocity = Vector2.ZERO

func on_physics_process(_delta: float) -> void:
	if rippler.current_health <=0: 
		state_machine.change_to("Death")
	
	if rippler.player:
		if rippler.current_health > rippler.max_health / 2:
			state_machine.change_to("Run")

		if rippler.current_health <= rippler.max_health / 2 and rippler.current_health > rippler.max_health / 4 : 
			state_machine.change_to("Furious")

		if rippler.current_health <= rippler.max_health / 4: 
			state_machine.change_to("Afraid")
	
