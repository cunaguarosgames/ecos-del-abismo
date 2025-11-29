extends MonolythStateBase

func start() -> void:
	brutalon.can_attack = false

	var attack = preload("res://scenes/enemies/monolyth/attacks/monolyth_rock.tscn").instantiate()
	attack.target_position = brutalon.player.global_position
	attack.global_position = brutalon.global_position
	attack.target = "player"
	get_parent().add_child(attack)
	
	if brutalon.animated_sprite_2d.material:
			var mat = brutalon.animated_sprite_2d.material
			mat.set_shader_parameter("glow_strength", 4.5)
			var new_color = Color.from_rgba8(181, 59, 53, 255)
			mat.set_shader_parameter("outline_color", new_color)
			mat.set_shader_parameter("outline_size", 1.0)
	
	brutalon.attack_cooldown_timer2.start()
	brutalon.play_main_animation("attack2")

func end() -> void:
	brutalon.can_attack = true
	brutalon.attack_cooldown_timer2.stop()

func _on_attack_cooldown_timer_2_timeout() -> void:
	if brutalon.current_health <= 0:
		state_machine.change_to("Death2")
	elif brutalon.player:
		state_machine.change_to("Chasing2")
	else:
		state_machine.change_to("Idle2")
	if brutalon.animated_sprite_2d.material:
		brutalon.animated_sprite_2d.material.set_shader_parameter("glow_strength", 0.0)
