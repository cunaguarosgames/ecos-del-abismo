class_name Rippler extends EnemyBase

var speed: float = 75.0


@export var damage_melee: float = 5.0
var can_attack: bool = true 
var player: Node2D = null
var can_attack_player: Node2D = null


@export var furious_health_threshold: float = 0.5
@export var afraid_health_threshold: float = 0.25


@onready var attack_cooldown_timer: Timer = $AttackCooldownTimer
@onready var attack_area: Area2D = $AttackArea
@onready var detection_area: Area2D = $DetectionArea
@onready var main_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_animation_sprite: AnimatedSprite2D = $AttackAnimationSprite


func _ready() -> void:
	max_health = 60.0
	current_health = max_health
	state_machine = $StateMachine 
	progress_bar = $ProgressBar
	progress_bar.max_value = max_health
	progress_bar.value = max_health
	progress_bar.hide()
	
	main_sprite.animation_finished.connect(_on_main_sprite_animation_finished)

	attack_animation_sprite.hide()



func _physics_process(_delta: float) -> void:
	pass

func update_health() -> void:
	if progress_bar:
		progress_bar.value = current_health
		if progress_bar.value < max_health:
			progress_bar.show()


func play_main_animation(anim_name: String) -> void:
	main_sprite.play(anim_name)

func check_for_attack() -> void:
	
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
