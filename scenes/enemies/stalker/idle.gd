extends StalkerStateBase

func start() -> void:
	stalker.play_main_animation("idle") 
	stalker.velocity = Vector2.ZERO

func on_physics_process(_delta: float) -> void:
	if stalker.current_health <=0: 
		state_machine.change_to("Death")
	
	if stalker.player:
			state_machine.change_to("Attack")
				
