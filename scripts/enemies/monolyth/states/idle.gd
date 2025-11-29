extends MonolythStateBase

func start() -> void:
	brutalon.play_main_animation("idle") 
	brutalon.velocity = Vector2.ZERO

func on_physics_process(_delta: float) -> void:
	if brutalon.current_health <=0: 
		state_machine.change_to("Death")
	
	if brutalon.player:
			state_machine.change_to("Chasing")
				
