extends MonolythStateBase

func start() -> void:
	brutalon.can_attack = false

	var attack = preload("res://scenes/enemies/brutalon/attacks/brutalon_rock.tscn").instantiate()
	attack.target_position = brutalon.player.global_position
	attack.global_position = brutalon.global_position
	attack.target = "player"
	get_parent().add_child(attack)

	brutalon.attack_cooldown_timer.start()
	brutalon.play_main_animation("attack")

func _on_attack_cooldown_timer_timeout() -> void:
	if brutalon.current_health <= 0:
		state_machine.change_to("Death")
	elif brutalon.player:
		state_machine.change_to("Chasing")
	else:
		state_machine.change_to("Idle")

func end() -> void:
	brutalon.can_attack = true
	brutalon.attack_cooldown_timer.stop()
