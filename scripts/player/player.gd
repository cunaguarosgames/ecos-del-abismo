class_name Player extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_timer: Timer = $AttackTimer
@onready var skills_menu: Control = $SkillsMenu
@onready var first_skill: Label = $SkillsMenu/FirstSkill

@export var speed: float = 120.0
@export var attack_cooldown: float = 0.4

@onready var progress_bar: ProgressBar = $ProgressBar

var states:PLayerStatesNames = PLayerStatesNames.new()

var direction := Vector2.ZERO
var deadzone = 0.2
var last_direction := Vector2.RIGHT
var can_attack: bool = true
var max_health: float = 100
var current_health: float = max_health
var dead = false

var basic_attack_dict = {name = 'Basic', file = "res://scenes/player/attacks/basic_attack.tscn"}
var second_attack_dict = {name = 'Basic2', file = "res://scenes/player/attacks/area_attack.tscn"}
var current_first_skill: Dictionary = basic_attack_dict

func _ready() -> void:
	progress_bar.max_value = max_health
	progress_bar.value = current_health

func show_skills_menu():
	if Input.is_action_just_pressed("menu"):
		first_skill.text = current_first_skill.name
		skills_menu.show()
	if skills_menu.visible and Input.is_action_just_pressed("down"):
		current_first_skill = second_attack_dict
		first_skill.text = current_first_skill.name
	if Input.is_action_just_released("menu"):
		skills_menu.hide()

func play_directional_animation(base_name: String) -> void:
	if direction.x != 0:
		animated_sprite_2d.flip_h = direction.x < 0
	
	if direction == Vector2.ZERO:
		if last_direction.y >= 0:
			animated_sprite_2d.play(base_name)
		else:
			animated_sprite_2d.play("%s_back" % base_name)
	
	if direction.y >= 0:
		animated_sprite_2d.play(base_name)
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
