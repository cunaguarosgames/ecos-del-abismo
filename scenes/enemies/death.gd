extends StateBase

func start() -> void:
	# 1. Detiene todo movimiento
	controlled_node.velocity = Vector2.ZERO
	
	# 2. Inicia la animación de "death"
	controlled_node.play_main_animation("death")

func on_physics_process(_delta: float) -> void:
	# El personaje no se mueve en el estado de muerte.
	pass
