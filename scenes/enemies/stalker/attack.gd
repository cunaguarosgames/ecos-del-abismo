extends StalkerStateBase 

func start() -> void:
	stalker.play_main_animation("Attack") 
	stalker.velocity = Vector2.ZERO

func on_physics_process(_delta: float) -> void:
	if not stalker.player:
		state_machine.change_to("Idle") 
		return
		
	var direction = (stalker.player.position - stalker.position).normalized()
	stalker.velocity = direction * (stalker.speed * 1.25)
	

	stalker.move_and_slide()

	if stalker.can_attack:
		stalker.check_for_attack()
	
	if stalker.current_health <= 0: 
		state_machine.change_to("Death")
		return
