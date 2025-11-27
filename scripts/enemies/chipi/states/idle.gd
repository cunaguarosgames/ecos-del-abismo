extends ChipiStateBase

func start() -> void:
	chipi.play_main_animation("idle") 
	chipi.velocity = Vector2.ZERO

func on_physics_process(_delta: float) -> void:
	if chipi.current_health <=0: 
		state_machine.change_to("Death")
	
	if chipi.player:
			state_machine.change_to("Chasing")
				
