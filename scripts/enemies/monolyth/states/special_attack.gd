extends MonolythStateBase

var nav_agent: NavigationAgent2D
var target_position: Vector2
var reached_target: bool = false

func start() -> void:
	monolyth.invulnerable = true
	reached_target = false
	monolyth.can_attack = false
	monolyth.velocity = Vector2.ZERO

	# Seleccionar variante del outline: Light o Dark
	monolyth.outline_variant = ["Light", "Dark"].pick_random()
	print("VARIANTE: ", monolyth.outline_variant)
	# Aplicar color según la variante
	if monolyth.animated_sprite_2d.material:
		var mat = monolyth.animated_sprite_2d.material
		if monolyth.outline_variant == "Dark":
			mat.set_shader_parameter("outline_color", Color(0.05, 0.05, 0.05, 1))
		else:
			mat.set_shader_parameter("outline_color", Color(0.9, 0.9, 0.9, 1))

	# Obtener NavigationAgent2D
	if monolyth.has_node("NavigationAgent2D"):
		nav_agent = monolyth.get_node("NavigationAgent2D")
		nav_agent.path_desired_distance = 10.0
		nav_agent.target_desired_distance = 5.0

	# Buscar AttackPoint
	var attack_point_node = get_tree().get_root().get_node_or_null("Room29/AttackPoint")
	if attack_point_node:
		target_position = attack_point_node.global_position
		print("AttackPoint encontrado")
	else:
		target_position = get_viewport().size / 2
		print("No se encontró AttackPoint, usando centro")

	if nav_agent:
		nav_agent.target_position = target_position

	monolyth.especial_attack_timer.stop()

func _physics_process(_delta: float) -> void:
	if not nav_agent:
		return

	if not reached_target:
		if nav_agent.is_target_reached():
			reached_target = true
			monolyth.velocity = Vector2.ZERO
			execute_attack()
		else:
			var next_path_position = nav_agent.get_next_path_position()
			var direction_vector = (next_path_position - monolyth.global_position).normalized()
			monolyth.velocity = direction_vector * monolyth.speed
			monolyth.direction = direction_vector
			monolyth.play_main_animation("walk2")

	monolyth.move_and_slide()

func execute_attack() -> void:
	monolyth.play_main_animation("attack2")

	var cell_size := 128
	var center := monolyth.global_position

	# ======== NUEVA GRID 5x5 =========
	var offsets: Array[Vector2] = []
	for y in range(-2, 3):  # -2, -1, 0, 1, 2
		for x in range(-2, 3):
			offsets.append(Vector2(x * cell_size, y * cell_size))
	# ==================================

	for i in range(offsets.size()):
		var attack = preload("res://scenes/enemies/monolyth/attacks/monolyth_especial_attack.tscn").instantiate()

		# Alternar color Light/Dark del ataque
		if i % 2 == 0:
			attack.color_variant = "Light"
		else:
			attack.color_variant = "Dark"

		# Hacen daño solo si coincide con el outline del enemigo
		if attack.color_variant == monolyth.outline_variant:
			attack.variant = "Damage"
		else:
			attack.variant = "NoDamage"

		attack.global_position = center + offsets[i]
		get_parent().add_child(attack)

	# Glow temporal
	if monolyth.animated_sprite_2d.material:
		var mat = monolyth.animated_sprite_2d.material
		mat.set_shader_parameter("glow_strength", 4.5)
		mat.set_shader_parameter("outline_size", 2.0)

	monolyth.especial_attack_cooldown_timer.start()

func end() -> void:
	monolyth.invulnerable = false
	monolyth.can_attack = true
	monolyth.especial_attack_cooldown_timer.stop()
	monolyth.especial_attack_timer.start()
	
	if monolyth.animated_sprite_2d.material:
		monolyth.animated_sprite_2d.material.set_shader_parameter("glow_strength", 0.0)
	
	var health = preload("res://scenes/items/health_item.tscn").instantiate()
	health.global_position = monolyth.global_position
	get_parent().get_parent().get_parent().add_child(health)

func _on_especial_attack_cooldown_timer_timeout() -> void:
	if monolyth.player:
		state_machine.change_to("Chasing2")
	else:
		state_machine.change_to("Idle2")
