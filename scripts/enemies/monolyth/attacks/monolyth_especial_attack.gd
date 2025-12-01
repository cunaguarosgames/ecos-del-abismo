extends Area2D

@export var damage: int = 20
@export var target: String = "player"
@export var explode_delay: float = 3.0

var variant: String = "Damage"        # Set por el padre
var color_variant: String = "Light"   # Set por el padre

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var timer := 0.0
var exploded := false

func _ready() -> void:
	animated_sprite_2d.play("default")

	if animated_sprite_2d.material:
		animated_sprite_2d.material = animated_sprite_2d.material.duplicate()

	_apply_color_variant()

func _physics_process(delta: float) -> void:
	if exploded:
		return
	
	timer += delta
	if timer >= explode_delay:
		explode()

func explode() -> void:
	if exploded:
		return
	exploded = true

	var tween := create_tween()

	var target_scale := Vector2(0.5, 0.5) # daño
	if variant == "NoDamage":
		target_scale = Vector2(1.5, 1.5) # sin daño

	tween.tween_property(self, "scale", target_scale, 0.3)

	tween.finished.connect(func():
		if variant == "Damage":
			do_damage()
		queue_free()
	)

func _set_color(idx: int, new_color: Color) -> void:
	var mat: ShaderMaterial = animated_sprite_2d.material
	if mat:
		var colors: Array = mat.get_shader_parameter("to_palette")
		if idx >= 0 and idx < colors.size():
			colors[idx] = new_color
			mat.set_shader_parameter("to_palette", colors)

func _apply_color_variant() -> void:
	if color_variant == "Dark":
		_set_color(0, Color(0.05, 0.05, 0.05, 1))
		_set_color(1, Color(0.12, 0.12, 0.12, 1))
		_set_color(2, Color(0.25, 0.25, 0.25, 1))
	else:
		_set_color(0, Color(0.9, 0.9, 0.9, 1))
		_set_color(1, Color(0.75, 0.75, 0.75, 1))
		_set_color(2, Color(0.6, 0.6, 0.6, 1))

	
func do_damage() -> void:
	for body in get_overlapping_bodies():
		if body.is_in_group(target) and body.has_method("take_damage"):
			body.take_damage(damage, global_position, 0)
			queue_free()
