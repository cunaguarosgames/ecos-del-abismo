extends Area2D

@export var speed: float = 200.0
@export var lifetime: float = 1.0
@export var damage: int = 10
@export var target: String = "enemies"

var direction: Vector2 = Vector2.RIGHT

func _ready() -> void:
	await get_tree().create_timer(lifetime).timeout
	queue_free()

func _physics_process(delta: float) -> void:
	scale += Vector2(delta * 4, delta * 4)
	
func _on_body_entered(body: Node2D) -> void:
	print("COLLISION WITH: ", body)
	print("GROUPS: ", body.get_groups())
	if body.is_in_group("map") or body.is_in_group(target):
		if body.has_method("take_damage"):
			body.take_damage(damage)
		queue_free()
