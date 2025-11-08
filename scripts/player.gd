extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export var speed: float = 120.0
@export var attack_cooldown: float = 0.4

var direction := Vector2.ZERO
var last_direction := Vector2.RIGHT
var can_attack: bool = true

func _physics_process(delta: float) -> void:
	handle_input()
	handle_attacks()
	velocity = direction * speed
	move_and_slide()
	animate()

func handle_input() -> void:
	direction = Vector2.ZERO
	
	if Input.is_action_pressed("right"):
		direction.x += 1
	elif Input.is_action_pressed("left"):
		direction.x -= 1
	
	if Input.is_action_pressed("down"):
		direction.y += 1
	elif Input.is_action_pressed("up"):
		direction.y -= 1
	
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

func animate() -> void:
	if direction.x != 0:
		animated_sprite_2d.flip_h = direction.x < 0
