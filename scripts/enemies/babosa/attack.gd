extends babosaStateBase

func start() -> void:
	print("puede atacar?: ",babosa.can_attack , " detection area: ", babosa.attack_area)
	if babosa.target and babosa.can_attack and babosa.attack_area:
		print("intentando atacar part 1 ")
		babosa.can_attack = false
		
		# Ejecutar las acciones de ataque inmediatamente
		_do_attack()
		
		# Iniciar el Timer y cambiar de estado para que pueda moverse
		babosa.coldown_attack.start()
		state_machine.change_to("follow")
	
	else:
		# Si no cumple la condición, sale inmediatamente al estado de seguimiento
		state_machine.change_to("follow")


func _do_attack() -> void:
	print("intentando atacar")
	babosa.velocity = Vector2.ZERO
	
	if babosa.target and babosa.target.is_in_group("player") and babosa.attackArea:
		if babosa.target.has_method("take_damage"):
			babosa.target.take_damage(babosa.attack)
