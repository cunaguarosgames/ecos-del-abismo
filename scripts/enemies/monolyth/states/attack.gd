extends MonolythStateBase

@onready var attack_1: AudioStreamPlayer = $"../../Attack1"

func start() -> void:
	monolyth.can_attack = false

	var attack = preload("res://scenes/enemies/monolyth/attacks/monolyth_rock.tscn").instantiate()
	attack.target_position = monolyth.player.global_position
	attack.global_position = monolyth.global_position
	attack.target = "player"
	get_parent().add_child(attack)
	
	if monolyth.animated_sprite_2d.material:
			var mat = monolyth.animated_sprite_2d.material
			mat.set_shader_parameter("glow_strength", 2.5)
			var new_color = Color.from_rgba8(181, 59, 53, 255)
			mat.set_shader_parameter("outline_color", new_color)
			mat.set_shader_parameter("outline_size", 1.0)
	
	monolyth.attack_cooldown_timer.start()
	monolyth.play_main_animation("attack")
	attack_1.play()

func _on_attack_cooldown_timer_timeout() -> void:
	if monolyth.current_health <= 0:
		state_machine.change_to("Death")
	elif monolyth.player:
		state_machine.change_to("Chasing")
	else:
		state_machine.change_to("Idle")

func end() -> void:
	monolyth.can_attack = true
	monolyth.attack_cooldown_timer.stop()
	if monolyth.animated_sprite_2d.material:
		monolyth.animated_sprite_2d.material.set_shader_parameter("glow_strength", 0.0)
