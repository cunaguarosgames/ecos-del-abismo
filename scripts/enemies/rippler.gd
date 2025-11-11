extends CharacterBody2D

var speed: float = 80.0
var current_health: float = 30.0
var max_health: float = 30.0

@export var damage_melee: float = 5.0
var can_attack: bool = true # Control de cooldown simple

@export var furious_health_threshold: float = 0.5   # 50% de salud
@export var afraid_health_threshold: float = 0.25  # 25% de salud
var current_state: String = "walk"


var player: Node2D = null
var player_chase: bool = false
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var attack_cooldown_timer: Timer = $AttackCooldownTimer
@onready var attack_area: Area2D = $AttackArea
@onready var detection_area: Area2D = $DetectionArea
@onready var main_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_animation_sprite: AnimatedSprite2D = $AttackAnimationSprite


func _ready() -> void:
	progress_bar.max_value = max_health
	progress_bar.value = max_health
	progress_bar.hide()

	attack_cooldown_timer.timeout.connect(_on_attack_cooldown_timer_timeout)
	attack_animation_sprite.animation_finished.connect(_on_attack_animation_finished)
	main_sprite.animation_finished.connect(_on_main_sprite_animation_finished)
	
	attack_animation_sprite.hide()
	play_main_animation("walk")


func _physics_process(_delta: float) -> void:
	if player_chase and is_instance_valid(player):
		var direction = (player.position - position).normalized()
		velocity = direction * speed
		
		if main_sprite.animation != current_state and not attack_animation_sprite.is_playing():
			play_main_animation(current_state)

		if can_attack:
			check_for_attack()
		
	else:
		velocity = Vector2.ZERO
		if main_sprite.animation != current_state and not attack_animation_sprite.is_playing():
			play_main_animation(current_state)
		
	move_and_slide()


func take_damage(amount: float) -> void:
	current_health -= amount
	update_health() 
	
	if current_health <= 0:
		if current_state != "death":
			current_state = "death"
			play_main_animation("death")
			print("El Rippler está muriendo.")
		
func update_health() -> void:
	if progress_bar:
		progress_bar.value = current_health
		if progress_bar.value < max_health:
			progress_bar.show()
			
	var health_percentage = current_health / max_health

	if current_state != "death":
		var new_state = "walk"
		if health_percentage <= afraid_health_threshold:
			new_state = "afraid"
		elif health_percentage <= furious_health_threshold:
			new_state = "furious"

		if current_state != new_state:
			current_state = new_state
			play_main_animation(current_state) 

func _on_attack_cooldown_timer_timeout() -> void:
	can_attack = true

func check_for_attack() -> void:
	if current_state == "death":
		return
	
	if not can_attack:
		return
	
	var overlapping_bodies = attack_area.get_overlapping_bodies()
	
	for body in overlapping_bodies:
		if body.is_in_group("player"):
			if body.has_method("take_damage"):
				
				body.take_damage(damage_melee)
				
				# Animación de ataque/onda
				attack_animation_sprite.show()
				attack_animation_sprite.play(current_state)
				
				can_attack = false
				attack_cooldown_timer.start()
				
				return

func play_main_animation(anim_name: String) -> void:
	if main_sprite.animation != anim_name:
		main_sprite.play(anim_name)

func _on_attack_animation_finished() -> void:
	attack_animation_sprite.hide()
	play_main_animation(current_state) 
	
func _on_main_sprite_animation_finished() -> void:
	if main_sprite.animation == "death":
		if current_health <= 0:
			queue_free()


func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = body
		player_chase = true
		
		if can_attack:
			check_for_attack()

func _on_detection_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = null
		player_chase = false
