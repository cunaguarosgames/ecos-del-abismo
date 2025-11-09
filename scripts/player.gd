extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export var speed: float = 120.0
@export var attack_cooldown: float = 0.4

@onready var progress_bar: ProgressBar = $ProgressBar

var direction := Vector2.ZERO
var deadzone = 0.2
var last_direction := Vector2.RIGHT
var can_attack: bool = true
var max_health: float = 100
var current_health: float = 100
var dead = false

func _ready() -> void:
	progress_bar.max_value = max_health
	progress_bar.value = current_health
	
func _physics_process(delta: float) -> void:
	if dead : return
	handle_input()
	handle_attacks()
	velocity = direction * speed
	move_and_slide()
	animate()
	
func handle_input() -> void:
	direction = Vector2.ZERO
	
	direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	direction.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	
	if direction.length() < deadzone:
		direction = Vector2.ZERO
	else:
		direction = direction.normalized() * min(direction.length(), 1.0)
		
	direction = direction.normalized()
	
func handle_attacks() -> void:
	if direction != Vector2.ZERO:
		last_direction = direction.normalized()
		
	if Input.is_action_just_pressed("attack") and can_attack:
		can_attack = false
		var attack = preload("res://scenes/attacks/basic_attack.tscn").instantiate()
		attack.global_position = global_position
		attack.direction = last_direction
		get_parent().add_child(attack)
		
		await get_tree().create_timer(attack_cooldown).timeout
		can_attack = true
	
	if Input.is_action_just_pressed("x") and can_attack:
		can_attack = false
		var attack = preload("res://scenes/attacks/area_attack.tscn").instantiate()
		attack.global_position = global_position
		attack.direction = last_direction
		get_parent().add_child(attack)
		
		await get_tree().create_timer(attack_cooldown).timeout
		can_attack = true

func animate() -> void:
	if direction.x != 0:
		animated_sprite_2d.flip_h = direction.x < 0
	
	if direction == Vector2.ZERO:
		if animated_sprite_2d.animation != "walk_back" and animated_sprite_2d.animation != "idle_back":
			animated_sprite_2d.play("idle")
			return
		animated_sprite_2d.play("idle_back")
		return
		
	if abs(direction.y) < abs(direction.x):
		animated_sprite_2d.play("walk")
		return
		
	if direction.y > 0:
		animated_sprite_2d.play("walk")
		return
	animated_sprite_2d.play("walk_back")

func take_damage(amount: float):
	current_health -= amount
	progress_bar.value = current_health
	if progress_bar.value < max_health:
		progress_bar.show()
	if current_health <= 0:
		var tween = get_tree().create_tween()
		tween.tween_property(animated_sprite_2d, "modulate:a", 0, 0.5)
		dead = true
