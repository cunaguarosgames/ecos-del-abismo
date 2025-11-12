class_name Rippler extends CharacterBody2D

# --------------------------
# PROPIEDADES DEL ENEMIGO
# --------------------------
var speed: float = 80.0
var current_health: float = 30.0
var max_health: float = 30.0

@export var damage_melee: float = 5.0
var can_attack: bool = true 
var player: Node2D = null

# --------------------------
# LÓGICA DE ESTADO
# --------------------------
@export var furious_health_threshold: float = 0.5
@export var afraid_health_threshold: float = 0.25

# --------------------------
# REFERENCIAS DE NODOS
# --------------------------
@onready var state_machine: StateMachine = $StateMachine # <--- Referencia al nodo FSM
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var attack_cooldown_timer: Timer = $AttackCooldownTimer
@onready var attack_area: Area2D = $AttackArea
@onready var detection_area: Area2D = $DetectionArea
@onready var main_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_animation_sprite: AnimatedSprite2D = $AttackAnimationSprite


func _ready() -> void:
	# ... inicializaciones ...
	progress_bar.max_value = max_health
	progress_bar.value = max_health
	progress_bar.hide()

	# Conexiones de señales
	attack_cooldown_timer.timeout.connect(_on_attack_cooldown_timer_timeout)
	attack_animation_sprite.animation_finished.connect(_on_attack_animation_finished)
	main_sprite.animation_finished.connect(_on_main_sprite_animation_finished)
	
	attack_animation_sprite.hide()
	# play_main_animation("walk") ya no se llama aquí, lo hace el estado inicial.


func _physics_process(_delta: float) -> void:
	# La FSM se encarga de llamar al on_physics_process del estado actual.
	# Simplemente movemos el cuerpo con la velocidad establecida por el estado.
	move_and_slide() 
	

# ====================================================================
# LÓGICA DE DAÑO Y TRANSICIÓN DE ESTADO (CONTROLADOR DE LA FSM)
# ====================================================================

func take_damage(amount: float) -> void:
	current_health -= amount
	
		
func update_health_and_change_state() -> void:
	if progress_bar:
		progress_bar.value = current_health
		if progress_bar.value < max_health:
			progress_bar.show()
			
	var health_percentage = current_health / max_health
	
	# Si ya estamos en la animación de Muerte, no cambiamos de estado
	if state_machine.current_state.name == "Death":
		return

	var target_state_name: String = "Walk" # Estado base para Walk/Idle

	if health_percentage <= afraid_health_threshold:
		target_state_name = "Afraid"
	elif health_percentage <= furious_health_threshold:
		target_state_name = "Furious"
	
	# Cambiamos de estado solo si es diferente al actual
	if state_machine.current_state.name != target_state_name:
		state_machine.change_to(target_state_name)


# ====================================================================
# FUNCIONES DE UTILIDAD (Deben ser llamadas por los Nodos de Estado)
# ====================================================================

# Función auxiliar llamada por los estados para reproducir la animación
func play_main_animation(anim_name: String) -> void:
	if not attack_animation_sprite.is_playing() and main_sprite.animation != anim_name:
		main_sprite.play(anim_name)

# Función auxiliar llamada por los estados para verificar el ataque
func check_for_attack() -> void:
	# Si la FSM está funcionando correctamente, este chequeo ya no es necesario
	# if state_machine.current_state.name == "Death": return 
	
	if not can_attack: return
	
	var overlapping_bodies = attack_area.get_overlapping_bodies()
	
	for body in overlapping_bodies:
		if body.is_in_group("player"):
			if body.has_method("take_damage"):
				
				body.take_damage(damage_melee)
				
				attack_animation_sprite.show()
				# Asegúrate de que este nombre de animación sea correcto
				attack_animation_sprite.play("impact_wave") 
				
				can_attack = false
				attack_cooldown_timer.start()
				
				return

# ====================================================================
# SEÑALES (Permanecen como funciones de Rippler)
# ====================================================================

func _on_attack_cooldown_timer_timeout() -> void:
	can_attack = true

func _on_attack_animation_finished() -> void:
	attack_animation_sprite.hide()
	# Vuelve a reproducir la animación del estado actual después del ataque
	play_main_animation(state_machine.current_state.name.to_lower()) 
	
func _on_main_sprite_animation_finished() -> void:
	# Solo el estado de Muerte debe manejar esto
	if main_sprite.animation == "death":
		if current_health <= 0:
			# Aquí podríamos querer notificar a la FSM o al estado Death
			# Por ahora, mantendremos el queue_free aquí por simplicidad.
			queue_free()

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = body
		# Al detectar, inmediatamente evaluamos si debe estar Furious o Walk
		update_health_and_change_state() 
		
		if can_attack:
			check_for_attack()

func _on_detection_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = null
		# Si se va, volvemos al estado base de Walk
		state_machine.change_to("Walk")
