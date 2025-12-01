extends ChipiStateBase

@onready var attack_1: AudioStreamPlayer = $"../../Attack1"

func start() -> void:
	chipi.can_attack = false
	
	attack_1.play()
	var base_dir := (chipi.player.global_position - chipi.global_position).normalized()

	var angles = [-30, 0, 30]

	for angle in angles:
		_spawn_bolt(base_dir.rotated(deg_to_rad(angle)))
	
	if chipi.animated_sprite_2d.material:
			var mat = chipi.animated_sprite_2d.material
			mat.set_shader_parameter("glow_strength", 2.5)
			var new_color = Color.from_rgba8(181, 59, 53, 255)
			mat.set_shader_parameter("outline_color", new_color)
			mat.set_shader_parameter("outline_size", 1.0)

	chipi.attack_cooldown_timer.start()
	chipi.play_main_animation("attack")

func _on_attack_cooldown_timer_timeout() -> void:
	if chipi.current_health <= 0:
		state_machine.change_to("Death")
	elif chipi.player:
		state_machine.change_to("Chasing")
	else:
		state_machine.change_to("Idle")

func _spawn_bolt(direction: Vector2):
	var attack = preload("res://scenes/enemies/chipi/attacks/chipi_bolt.tscn").instantiate()
	attack.global_position = chipi.global_position
	attack.direction = direction
	attack.target = "player"
	get_parent().add_child(attack)

func end() -> void:
	chipi.can_attack = true
	chipi.attack_cooldown_timer.stop()
	if chipi.animated_sprite_2d.material:
		chipi.animated_sprite_2d.material.set_shader_parameter("glow_strength", 0.0)
