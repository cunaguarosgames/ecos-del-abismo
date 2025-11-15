extends StalkerStateBase

func start() -> void:
	stalker.play_main_animation("attack") 
	stalker.velocity = Vector2.ZERO

func on_physics_process(_delta: float) -> void:
	if not stalker.player:
		state_machine.change_to("Idle") 
		return
		
	var direction_vector = (stalker.player.position - stalker.position)
	var distance = direction_vector.length()
	var stop_range = 30 
	
	if distance > stop_range:
		stalker.velocity = direction_vector.normalized() * (stalker.speed * 1.25)
	else:
		stalker.velocity = Vector2.ZERO
	
	stalker.move_and_slide()

	if stalker.can_attack:
		stalker.check_for_attack()
	
	if stalker.current_health <= 0: 
		state_machine.change_to("Death")
		return
