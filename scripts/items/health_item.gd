extends Area2D

@export var amount: float = 20

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	if animated_sprite_2d.material:
		animated_sprite_2d.material = animated_sprite_2d.material.duplicate()
		
	var new_color = Color.from_hsv(randf(), randf_range(0.5, 1.0), randf_range(0.9, 1.0))
	_set_color(0, new_color)
	new_color.v = 0.5
	_set_color(1, new_color)

func _set_color(idx: int, new_color: Color) -> void:
	var mat: ShaderMaterial = animated_sprite_2d.material
	if mat:
		var colors: Array = mat.get_shader_parameter("to_palette")
		if idx >= 0 and idx < colors.size():
			colors[idx] = new_color
			mat.set_shader_parameter("to_palette", colors)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if body.has_method("health_player"):
			body.health_player(amount)
		queue_free()
