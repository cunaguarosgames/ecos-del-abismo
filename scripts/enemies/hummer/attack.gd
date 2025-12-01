extends hummerStateBase

func start() -> void:
	if hummer.target and hummer.attack_area and hummer.can_attack:
		hummer.can_attack = false 
		_do_attack()
	else:
		state_machine.change_to("follow")

func _do_attack() -> void:
	hummer.velocity = Vector2.ZERO

	if not hummer.attack_scene:
		state_machine.change_to("follow")
		return

	var projectile = hummer.attack_scene.instantiate()
	projectile.global_position = hummer.global_position
	projectile.target = hummer.target
	projectile.damage = hummer.attack

	hummer.get_tree().current_scene.add_child(projectile)
	
	if is_instance_valid(hummer.attack_sfx):
			hummer.attack_sfx.play()

	hummer.attackTimer.start()

	# luego que dispare → volver al follow
	state_machine.change_to("follow")
