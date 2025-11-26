extends Area2D

@export var lifetime: float = 0.25
@export var damage: int = 5
@export var target: String = "enemies"
@export var arc_angle: float = 90.0   # grados que cubre el arco

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var direction: Vector2 = Vector2.RIGHT
var offset_distance: float= 32
var position_from_center: Vector2
var elapsed: float= 0.0

func _ready() -> void:
	position_from_center = global_position

	position += direction.normalized() * offset_distance

	if animated_sprite_2d.material:
		animated_sprite_2d.material = animated_sprite_2d.material.duplicate()

	var new_color = Color.from_hsv(randf(), randf_range(0.5, 1.0), randf_range(0.9, 1.0))
	_set_color(0, new_color)
	
	new_color.v = 0.5
	_set_color(1, new_color)

	await get_tree().create_timer(lifetime).timeout
	queue_free()

func _physics_process(delta: float) -> void:
	elapsed += delta
	var t := elapsed / lifetime

	# Ángulo inicial-final en radianes
	var start_angle := direction.angle() - deg_to_rad(arc_angle / 2)
	var end_angle := direction.angle() + deg_to_rad(arc_angle / 2)

	# Ángulo interpolado
	var current_angle: float= lerp(start_angle, end_angle, t)

	# Posición en arco
	position = position_from_center + Vector2.RIGHT.rotated(current_angle) * offset_distance

	# Rotar sprite según el arco
	rotation = current_angle


func _set_color(idx: int, new_color: Color) -> void:
	var mat: ShaderMaterial = animated_sprite_2d.material
	if mat:
		var colors: Array = mat.get_shader_parameter("to_palette")
		if idx >= 0 and idx < colors.size():
			colors[idx] = new_color
			mat.set_shader_parameter("to_palette", colors)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("map") or body.is_in_group(target):
		if body.has_method("take_damage"):
			body.take_damage(damage, global_position, 300)
