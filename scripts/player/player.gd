class_name Player extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_timer: Timer = $AttackTimer

@export var speed: float = 120.0
@export var attack_cooldown: float = 0.4

@onready var progress_bar: ProgressBar = $ProgressBar

var states:PLayerStatesNames = PLayerStatesNames.new()

var direction := Vector2.ZERO
var deadzone = 0.2
var last_direction := Vector2.RIGHT
var can_attack: bool = true
var max_health: float = 25
var current_health: float = max_health
var dead = false

func _ready() -> void:
	progress_bar.max_value = max_health
	progress_bar.value = current_health
	

func play_directional_animation(base_name: String) -> void:
	if direction.x != 0:
		animated_sprite_2d.flip_h = direction.x < 0

	if direction == Vector2.ZERO and base_name:
		if animated_sprite_2d.animation.ends_with("_back"):
			animated_sprite_2d.play("idle_back")
		else:
			animated_sprite_2d.play("idle")
		return

	if abs(direction.y) < abs(direction.x):
		animated_sprite_2d.play("%s" % base_name)
	elif direction.y > 0:
		animated_sprite_2d.play("%s" % base_name)
	else:
		animated_sprite_2d.play("%s_back" % base_name)

func take_damage(amount: float):
	if dead : return
	current_health -= amount
	progress_bar.value = current_health
	if progress_bar.value < max_health:
		progress_bar.show()
	if current_health <= 0:
		animated_sprite_2d.play("dead")
		var tween = get_tree().create_tween()
		tween.tween_property(animated_sprite_2d, "modulate:a", 0, 1.25)
		dead = true
