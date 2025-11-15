extends StalkerStateBase

func start() -> void:
	stalker.can_attack = false

	var attack = preload("res://scenes/player/attacks/basic_attack.tscn").instantiate()
	attack.global_position = stalker.global_position
	attack.direction = (stalker.player.global_position - stalker.global_position).normalized()
	attack.target = "player"
	get_parent().add_child(attack)

	stalker.attack_cooldown_timer.start()
	stalker.play_main_animation("attack")

func _on_attack_cooldown_timer_timeout() -> void:
	if stalker.player:
		var direction_vector = (stalker.player.position - stalker.position)
		var distance = direction_vector.length()
		var attack_range = 60
		
		if distance <= attack_range:
			state_machine.change_to("Attack")
			return
			state_machine.change_to("Chasing")
			state_machine.change_to("Idle")

func end():
	stalker.can_attack = true
	stalker.attack_cooldown_timer.stop()
	
func on_physics_process(_delta: float) -> void:
	if stalker.current_health <=0: 
		state_machine.change_to("Death")
