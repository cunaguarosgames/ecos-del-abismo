class_name Rippler extends CharacterBody2D

# --------------------------
# PROPIEDADES DEL ENEMIGO
# --------------------------
var speed: float = 75.0
var current_health: float = 30.0
var max_health: float = 30.0

@export var damage_melee: float = 5.0
var can_attack: bool = true 
var player: Node2D = null
var can_attack_player: Node2D = null

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
	
	main_sprite.animation_finished.connect(_on_main_sprite_animation_finished)

	attack_animation_sprite.hide()
	# play_main_animation("walk") ya no se llama aquí, lo hace el estado inicial.


func _physics_process(_delta: float) -> void:
	pass

func take_damage(amount: float) -> void:
	current_health -= amount
	update_health()

func update_health() -> void:
	if progress_bar:
		progress_bar.value = current_health
		if progress_bar.value < max_health:
			progress_bar.show()

# ====================================================================
# FUNCIONES DE UTILIDAD (Deben ser llamadas por los Nodos de Estado)
# ====================================================================

# Función auxiliar llamada por los estados para reproducir la animación
func play_main_animation(anim_name: String) -> void:
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
				attack_animation_sprite.play("walk") 
				
				can_attack = false
				attack_cooldown_timer.start()
				
				return

# ====================================================================
# SEÑALES (Permanecen como funciones de Rippler)
# ====================================================================

func _on_main_sprite_animation_finished() -> void:
	if main_sprite.animation == "death":
		if current_health <= 0:

			queue_free()

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = body
		update_health() 

func _on_detection_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = null


func _on_attack_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		can_attack_player = body

func _on_attack_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		can_attack_player = null
