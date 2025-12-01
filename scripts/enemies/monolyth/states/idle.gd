extends MonolythStateBase

func start() -> void:
	monolyth.play_main_animation("idle") 
	monolyth.velocity = Vector2.ZERO

func on_physics_process(_delta: float) -> void:
	if monolyth.current_health <=0: 
		state_machine.change_to("Death")
	
	if monolyth.player:
			state_machine.change_to("Chasing")
				
