extends babosaStateBase

func start() -> void:
	print("puede atacar?: ", babosa.can_attack, " detection area: ", babosa.attack_area)

	if babosa.target and babosa.can_attack and babosa.attack_area:
		print("intentando atacar part 1 ")
		babosa.can_attack = false
		_do_attack()
		babosa.coldown_attack.start()
		state_machine.change_to("follow")
	else:
		state_machine.change_to("follow")


func _do_attack() -> void:
	print("intentando atacar")
	babosa.velocity = Vector2.ZERO
	
	if babosa.target and babosa.target.is_in_group("player") and babosa.attack_area:
		if babosa.target.has_method("take_damage"):
			babosa.target.take_damage(babosa.attack)
