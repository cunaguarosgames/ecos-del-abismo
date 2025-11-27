extends Area2D

@export var speed: float = 150.0
@export var lifetime: float = 1.0
@export var damage: int = 5
@export var target: String = "player"

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var direction: Vector2 = Vector2.RIGHT

func _ready() -> void:
	animated_sprite_2d.rotation = direction.angle()
	
	if animated_sprite_2d.material:
		animated_sprite_2d.material = animated_sprite_2d.material.duplicate()
		
	await get_tree().create_timer(lifetime).timeout
	queue_free()

func _physics_process(delta: float) -> void:
	position += direction * speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("map") or body.is_in_group(target):
		if body.has_method("take_damage"):
			body.take_damage(damage, global_position, 100)
		queue_free()
