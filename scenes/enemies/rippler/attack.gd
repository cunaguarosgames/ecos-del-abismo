extends RipplerStateBase

func start() -> void:
	if rippler.current_health > rippler.max_health / 2:
		rippler.play_main_animation("walk") 
	if rippler.current_health <= rippler.max_health / 2 and rippler.current_health > rippler.max_health / 4 : 
		rippler.play_main_animation("furious") 
	if rippler.current_health <= rippler.max_health / 4: 
		rippler.play_main_animation("afraid") 
	
	var overlapping_bodies = rippler.attack_area.get_overlapping_bodies()
	
	for body in overlapping_bodies:
		if body.is_in_group("player"):
			if body.has_method("take_damage"):
				
				body.take_damage(rippler.damage_melee, rippler.global_position)
				
				rippler.attack_animation_sprite.show()
				if rippler.current_health > rippler.max_health / 2:
					rippler.attack_animation_sprite.play("walk") 
				if rippler.current_health <= rippler.max_health / 2 and rippler.current_health > rippler.max_health / 4 : 
					rippler.attack_animation_sprite.play("furious") 
				if rippler.current_health <= rippler.max_health / 4: 
					rippler.attack_animation_sprite.play("afraid") 
				
				rippler.can_attack = false
				rippler.attack_cooldown_timer.start()
				
				return
	
	rippler.velocity = Vector2.ZERO

func on_physics_process(_delta: float) -> void:
	if rippler.current_health <=0: 
		state_machine.change_to("Death")

func _on_attack_cooldown_timer_timeout() -> void:
	if rippler.player:
		state_machine.change_to("Chasing")
	else:
		state_machine.change_to("Idle")

func end():
	rippler.can_attack = true
	rippler.attack_cooldown_timer.stop()
	
