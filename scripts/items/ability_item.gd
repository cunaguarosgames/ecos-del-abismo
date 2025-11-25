extends Area2D

@export var ability_name: String = "Normal"
@export var first_color: Color =  Color.DARK_VIOLET
@export var second_color: Color =  Color.BLACK

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	if animated_sprite_2d.material:
		animated_sprite_2d.material = animated_sprite_2d.material.duplicate()
		
	_set_color(0, first_color)
	_set_color(1, second_color)

func _set_color(idx: int, new_color: Color) -> void:
	var mat: ShaderMaterial = animated_sprite_2d.material
	if mat:
		var colors: Array = mat.get_shader_parameter("to_palette")
		if idx >= 0 and idx < colors.size():
			colors[idx] = new_color
			mat.set_shader_parameter("to_palette", colors)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if body.has_method("add_primary_skill"):
			body.add_primary_skill(ability_name)
		if body.has_method("add_secondary_skill"):
			body.add_secondary_skill(ability_name)
		queue_free()
