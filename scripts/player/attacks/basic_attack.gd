extends Area2D

@export var speed: float = 200.0
@export var lifetime: float = 2.0
@export var damage: int = 5
@export var target: String = "enemies"

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var direction: Vector2 = Vector2.RIGHT

func _ready() -> void:
	animated_sprite_2d.rotation = direction.angle()
	
	if animated_sprite_2d.material:
		animated_sprite_2d.material = animated_sprite_2d.material.duplicate()
		
	var new_color = Color.from_hsv(randf(), randf_range(0.5, 1.0), randf_range(0.7, 1.0))

	_set_color(0, new_color)
	
	await get_tree().create_timer(lifetime).timeout
	queue_free()

func _physics_process(delta: float) -> void:
	position += direction * speed * delta

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
			body.take_damage(damage)
		queue_free()
