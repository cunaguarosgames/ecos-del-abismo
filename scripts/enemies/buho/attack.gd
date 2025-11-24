extends buhoStateBase

var attackDirection = "left"

func change(): 
	state_machine.change_to("follow")

func start() -> void:
	if buho.current_health <= 0 :
		state_machine.change_to("Death")
		
	if !buho.target and !buho.can_attack:
		state_machine.change_to("patrol")
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
	if buho.secondFase: 
		buho.animSprite.play("long_SF")
	else: 
		buho.animSprite.play("long_attack")
		
	buho.velocity = Vector2.ZERO
	buho.can_attack = false

	var projectile = buho.attack_scene.instantiate()
	projectile.global_position = buho.global_position
	projectile.target = buho.target
	projectile.damage = buho.longAttack
	buho.get_tree().current_scene.add_child(projectile)

	buho.coldown_long.start()
	buho.animSprite.animation_finished.connect(change)

func _do_attack_basic() -> void:
	if attackDirection == "left": 
		attackDirection = "right"
		if buho.secondFase : 
			buho.animSprite.play("melle_L_SF")
		else: 
			buho.animSprite.play("melle_attack_L")
			
	else:
		attackDirection = "left"
		if buho.secondFase : 
			buho.animSprite.play("melle_r_SF")
		else: 
			buho.animSprite.play("melle_attack_R")
			
	buho.velocity = Vector2.ZERO
	buho.can_attack = false
	
	if buho.target.has_method("take_damage"):
		buho.target.take_damage(buho.attack)

	buho.coldown_basic.start()
	buho.animSprite.animation_finished.connect(change)

func _do_attack_area() -> void:
	
	if buho.secondFase == true : 
		buho.animSprite.play("area_attack")
		buho.animArea.play("default")
		buho.velocity = Vector2.ZERO
		buho.can_attack = false
		
		if buho.target.has_method("take_damage"):
			buho.target.take_damage(buho.areaAttack)
		else:
			state_machine.change_to("follow")

		buho.coldown_area.start()
		buho.animSprite.animation_finished.connect(change)
		buho.animArea.animation_finished.connect(change)
	 
