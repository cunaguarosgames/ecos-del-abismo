extends Area2D

@export var speed := 200
@onready var life_time = $Timer
@onready var animeteSprite = $AnimatedSprite2D
var target: Node2D = null
var damage := 0
var knockback_force := 0


func _on_timer_timeout() -> void:
	queue_free()

func _ready() -> void:
	life_time.timeout.connect(_on_timer_timeout)
	life_time.start()
	animeteSprite.play("default")

func _process(delta):
	if !target or !is_instance_valid(target):
		queue_free()
		return

	var direction = (target.global_position - global_position).normalized()

	# Rotar hacia el objetivo
	rotation = direction.angle()

	global_position += direction * speed * delta
	

func _on_body_entered(body):
	if body.is_in_group("player"):
		# Aplicar daño
		if body.has_method("take_damage"):
			body.take_damage(damage)

		# Aplicar knockback
		if body is CharacterBody2D:
			var dir = (body.global_position - global_position).normalized()
			body.velocity += dir * knockback_force

		queue_free()
