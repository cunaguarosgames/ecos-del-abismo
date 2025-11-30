extends StalkerStateBase

func start() -> void:
	stalker.can_attack = false
	if is_instance_valid(stalker.attack_sfx):
			stalker.attack_sfx.play()

	var attack = preload("res://scenes/enemies/stalker/attack_stalker.tscn").instantiate()
	attack.global_position = stalker.global_position
	attack.direction = (stalker.player.global_position - stalker.global_position).normalized()
	attack.target = "player"
	get_parent().add_child(attack)

	stalker.attack_cooldown_timer.start()
	stalker.play_main_animation("attack")

func _on_attack_cooldown_timer_timeout() -> void:
	if stalker.current_health <= 0:
		state_machine.change_to("Death")
	elif stalker.player:
		state_machine.change_to("Chasing")
	else:
		state_machine.change_to("Idle")

func end() -> void:
	stalker.can_attack = true
	stalker.attack_cooldown_timer.stop()
