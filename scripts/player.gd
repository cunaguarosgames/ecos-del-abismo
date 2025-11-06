extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export var speed: float = 120.0

var direction := Vector2.ZERO

func _physics_process(delta: float) -> void:
	handle_input()
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

func animate() -> void:
	if direction.x != 0:
		animated_sprite_2d.flip_h = direction.x < 0
