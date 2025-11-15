extends RipplerStateBase

func start() -> void:
	rippler.play_main_animation("afraid") 
	rippler.velocity = Vector2.ZERO

func on_physics_process(_delta: float) -> void:
	if not rippler.player:
		state_machine.change_to("Walk")
		return
	
	# Cálculo de la dirección y distancia
	var direction_vector = (rippler.player.position - rippler.position)
	var distance = direction_vector.length()
	var safe_distance = 150 
	
	# Lógica de Huida (Moverse en dirección opuesta al jugador)
	if distance < safe_distance:
		# Si está muy cerca, huye (dirección opuesta) a velocidad reducida
		rippler.velocity = direction_vector.normalized() * (rippler.speed / 2) * -1 
	else:
		# Si ya está lo suficientemente lejos, se detiene o camina lentamente
		rippler.velocity = Vector2.ZERO
	
	if rippler.can_attack:
		rippler.check_for_attack()
	
	rippler.move_and_slide()
	
	# Transiciones de Salud
	if rippler.current_health <= 0:
		state_machine.change_to("Death")
		return
	
	if rippler.current_health <= rippler.max_health / 2 and rippler.current_health > rippler.max_health / 4 :
		state_machine.change_to("Furious")
	
	if rippler.current_health > rippler.max_health / 2:
		state_machine.change_to("Run")
