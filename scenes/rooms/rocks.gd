extends StaticBody2D

@onready var rocks: Sprite2D = $Rocks
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	rocks.visible = true
	collision_shape_2d.set_deferred("disabled", false)
