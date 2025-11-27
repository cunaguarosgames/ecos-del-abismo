extends ChipiStateBase

func start() -> void:
	chipi.can_attack = false

	var base_dir := (chipi.player.global_position - chipi.global_position).normalized()

	var angles = [-30, 0, 30]

	for angle in angles:
		_spawn_bolt(base_dir.rotated(deg_to_rad(angle)))

	chipi.attack_cooldown_timer.start()
	chipi.play_main_animation("attack")

func _on_attack_cooldown_timer_timeout() -> void:
	if chipi.current_health <= 0:
		state_machine.change_to("Death")
	elif chipi.player:
		state_machine.change_to("Chasing")
	else:
		state_machine.change_to("Idle")

func _spawn_bolt(direction: Vector2):
	var attack = preload("res://scenes/enemies/chipi/attacks/chipi_bolt.tscn").instantiate()
	attack.global_position = chipi.global_position
	attack.direction = direction
	attack.target = "player"
	get_parent().add_child(attack)

func end() -> void:
	chipi.can_attack = true
	chipi.attack_cooldown_timer.stop()
