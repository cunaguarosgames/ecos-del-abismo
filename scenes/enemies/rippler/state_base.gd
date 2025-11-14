class_name StateBase extends Node

# Referencias automáticas establecidas por la StateMachine
# El 'owner' del StateMachine, que es el Rippler (CharacterBody2D)
var controlled_node: CharacterBody2D = null 
var state_machine: StateMachine = null

# --- Funciones de Ciclo de Vida del Estado ---

# Llamado una vez al entrar en este estado.
func start() -> void:
	# Lugar para iniciar la animación específica de este estado
	# controlled_node.play_main_animation(self.name.to_lower()) 
	pass 

# Llamado cada frame (si lo implementas).
func on_process(delta: float) -> void:
	pass

# Llamado cada tick de física (donde pones la lógica de movimiento).
func on_physics_process(delta: float) -> void:
	pass

# Llamado una vez al salir de este estado.
func end() -> void:
	pass
