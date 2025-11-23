extends buhoStateBase

func start() -> void:
	if !buho.target.is_in_group("player"):
		state_machine.change_to("patrol")
		return
	
	if !buho.can_attack:
		state_machine.change_to("follow")
		return
	
	if buho.long_attack:
		_do_attack_long()
	elif buho.bassic_attack:
		_do_attack_basic()
	elif buho.attack_area:
		_do_attack_area()
	else:
		state_machine.change_to("follow")
	
func _do_attack_long() -> void:
	print("long attack")
	buho.velocity = Vector2.ZERO
	buho.can_attack = false

	var projectile = buho.attack_scene.instantiate()
	projectile.global_position = buho.global_position
	projectile.target = buho.target
	projectile.damage = buho.longAttack
	buho.get_tree().current_scene.add_child(projectile)

	buho.coldown_long.start()

func _do_attack_basic() -> void:
	print("melle attack")
	buho.velocity = Vector2.ZERO
	buho.can_attack = false

	if buho.target.has_method("take_damage"):
		buho.target.take_damage(buho.attack)

	buho.coldown_basic.start()

func _do_attack_area() -> void:
	print("area attack")
	if buho.secondFase == true : 
		buho.velocity = Vector2.ZERO
		buho.can_attack = false
		
		if buho.target.has_method("take_damage"):
			buho.target.take_damage(buho.areaAttack)
		
		buho.coldown_area.start()
	 

func on_process(delta: float) -> void:
	if !buho.can_attack:
		return
	
	state_machine.change_to("attack")
