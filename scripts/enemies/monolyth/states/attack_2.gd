extends MonolythStateBase

@onready var attack_1: AudioStreamPlayer = $"../../Attack1"

func start() -> void:
	monolyth.can_attack = false

	var attack = preload("res://scenes/enemies/monolyth/attacks/monolyth_power.tscn").instantiate()
	attack.target_position = monolyth.player.global_position
	attack.global_position = monolyth.global_position
	attack.target = "player"
	get_parent().add_child(attack)
	
	if monolyth.animated_sprite_2d.material:
			var mat = monolyth.animated_sprite_2d.material
			mat.set_shader_parameter("glow_strength", 4.5)
			var new_color = Color.from_rgba8(181, 59, 53, 255)
			mat.set_shader_parameter("outline_color", new_color)
			mat.set_shader_parameter("outline_size", 1.0)
	
	monolyth.attack_cooldown_timer2.start()
	monolyth.play_main_animation("attack2")
	attack_1.play()
	attack_1.pitch_scale = 1.2

func end() -> void:
	monolyth.can_attack = true
	monolyth.attack_cooldown_timer2.stop()

func _on_attack_cooldown_timer_2_timeout() -> void:
	if monolyth.current_health <= 0:
		state_machine.change_to("Death2")
	elif monolyth.player:
		state_machine.change_to("Chasing2")
	else:
		state_machine.change_to("Idle2")
	if monolyth.animated_sprite_2d.material:
		monolyth.animated_sprite_2d.material.set_shader_parameter("glow_strength", 0.0)
