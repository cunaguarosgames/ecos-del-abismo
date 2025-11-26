extends Area2D

@export var speed: float = 200.0
@export var arc_height: float = 200.0
@export var fall_gravity: float = 600.0
@export var damage: int = 20
@export var target: String = "enemies"

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var direction: Vector2 = Vector2.RIGHT
var vertical_velocity := 0.0
var vertical_offset := 0.0
var has_exploded := false

func _ready() -> void:
	vertical_velocity = arc_height
	animated_sprite_2d.rotation = direction.angle()
	
	if animated_sprite_2d.material:
		animated_sprite_2d.material = animated_sprite_2d.material.duplicate()
		
	var new_color = Color.from_hsv(randf(), randf_range(0.5, 1.0), randf_range(0.9, 1.0))
	_set_color(0, new_color)
	
	new_color.v = 0.5
	_set_color(1, new_color)

func _physics_process(delta: float) -> void:
	if animated_sprite_2d.animation == "explode" and animated_sprite_2d.frame == 3:
		queue_free()
	
	if animated_sprite_2d.animation == "explode":
		return
	
	position += direction * speed * delta

	vertical_velocity -= fall_gravity * delta
	vertical_offset += vertical_velocity * delta

	if vertical_offset <= 0.0:
		vertical_offset = 0.0
		if vertical_velocity < 0.0 and not has_exploded:
			explode()

	animated_sprite_2d.position.y = -vertical_offset

func _set_color(idx: int, new_color: Color) -> void:
	var mat: ShaderMaterial = animated_sprite_2d.material
	if mat:
		var colors: Array = mat.get_shader_parameter("to_palette")
		if idx >= 0 and idx < colors.size():
			colors[idx] = new_color
			mat.set_shader_parameter("to_palette", colors)

func explode() -> void:
	has_exploded = true
	_do_damage()
	animated_sprite_2d.play("explode")

func _do_damage() -> void:
	for body in get_overlapping_bodies():
		if body.is_in_group(target) and body.has_method("take_damage"):
			body.take_damage(damage, global_position, 200)
