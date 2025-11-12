extends StateBase

@export var afraid_speed_multiplier: float = 0.8 # Huye un poco más lento

func start() -> void:
	# 1. Inicia la animación de "afraid"
	controlled_node.play_main_animation("afraid")

func on_physics_process(_delta: float) -> void:
	# Lógica de movimiento: Huye del jugador
	if controlled_node.player:
		# Dirección OPUESTA: (Posición del Rippler - Posición del jugador)
		var direction = (controlled_node.position - controlled_node.player.position).normalized()
		controlled_node.velocity = direction * controlled_node.speed * afraid_speed_multiplier
		
		# Nota: El Rippler en este estado podría no atacar, por lo que no llamamos a check_for_attack()
	else:
		# Si pierde al jugador, vuelve a Walk/Idle
		controlled_node.velocity = Vector2.ZERO
