extends Area2D

@export var speed: float = 200.0
@export var lifetime: float = 2.0
@export var damage: int = 5

var direction: Vector2 = Vector2.RIGHT

func _ready() -> void:
	await get_tree().create_timer(lifetime).timeout
	queue_free()

func _physics_process(delta: float) -> void:
	position += direction * speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("map") or body.is_in_group("enemies"):
		if body.has_method("take_damage"):
			body.take_damage(damage)
		queue_free()
