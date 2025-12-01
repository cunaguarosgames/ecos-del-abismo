extends babosaStateBase

func start() -> void:

	if babosa.target and babosa.can_attack and babosa.attack_area:
		babosa.can_attack = false
		_do_attack()
		babosa.coldown_attack.start()
		state_machine.change_to("follow")
	else:
		state_machine.change_to("follow")


func _do_attack() -> void:
	babosa.velocity = Vector2.ZERO
	
	if babosa.target and babosa.target.is_in_group("player") and babosa.attack_area:
		if babosa.target.has_method("take_damage"):
			babosa.target.take_damage(babosa.attack)
			if is_instance_valid(babosa.attack_sfx):
				babosa.attack_sfx.play()
