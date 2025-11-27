extends Area2D

@export var damage: int = 20
@export var target: String = "player"
@export var new_gravity: float = 1000.0
@export var apex_height: float = 80.0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var target_position: Vector2
var velocity: Vector2
var has_exploded := false

func _ready() -> void:
	if animated_sprite_2d.material:
		animated_sprite_2d.material = animated_sprite_2d.material.duplicate()

	var new_color = Color.from_hsv(randf(), randf_range(0.5, 1.0), randf_range(0.9, 1.0))
	_set_color(0, new_color)
	new_color.v = 0.5
	_set_color(1, new_color)

	_calculate_arc()

func _physics_process(delta: float) -> void:
	if has_exploded:
		scale += Vector2(delta * 4, delta * 4)
		_do_damage()

	if animated_sprite_2d.animation == "explode" and animated_sprite_2d.frame == 3:
		queue_free()

	if has_exploded:
		return

	velocity.y += new_gravity * delta
	position += velocity * delta

	if global_position.y >= target_position.y and velocity.y > 0 and not has_exploded:
		explode()

func explode() -> void:
	has_exploded = true
	animated_sprite_2d.play("explode")

func _do_damage() -> void:
	for body in get_overlapping_bodies():
		if body is Player and body.invulnerable:
			return
		if body.is_in_group(target) and body.has_method("take_damage"):
			body.take_damage(damage, global_position, 200)

func _set_color(idx: int, new_color: Color) -> void:
	var mat: ShaderMaterial = animated_sprite_2d.material
	if mat:
		var colors: Array = mat.get_shader_parameter("to_palette")
		if idx >= 0 and idx < colors.size():
			colors[idx] = new_color
			mat.set_shader_parameter("to_palette", colors)

func _calculate_arc() -> void:
	var displacement := target_position - global_position
	var height : float = apex_height + abs(displacement.x) * 0.3
	var vy := -sqrt(2 * new_gravity * height)
	var t := (vy * -1 + sqrt(vy * vy + 2 * new_gravity * (height + displacement.y))) / new_gravity
	var vx := displacement.x / t
	velocity = Vector2(vx, vy)
