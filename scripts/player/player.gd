class_name Player extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_timer: Timer = $AttackTimer
@onready var skills_menu: Control = $SkillsMenu
@onready var first_skill_0: Label = $SkillsMenu/VBoxContainer/FirstSkill0
@onready var first_skill_1: Label = $SkillsMenu/VBoxContainer/FirstSkill1
@onready var first_skill_2: Label = $SkillsMenu/VBoxContainer/FirstSkill2
@onready var state_machine: StateMachine = $StateMachine

@export var speed: float = 120.0
@export var attack_cooldown: float = 0.4

@onready var progress_bar: ProgressBar = $ProgressBar

var states:PLayerStatesNames = PLayerStatesNames.new()
var player_attacks:PlayerAttacks = PlayerAttacks.new()

var direction := Vector2.ZERO
var deadzone = 0.2
var last_direction := Vector2.RIGHT
var can_attack: bool = true
var max_health: float = 100
var current_health: float = max_health
var dead = false
var invulnerable: bool = false

var current_first_skill: String = GameState.game_data.primary_skill
var primary_skills_list: Array = GameState.game_data.primary_skills_list

func _ready() -> void:
	progress_bar.max_value = max_health
	progress_bar.value = current_health
	current_first_skill = GameState.game_data.primary_skill

func update_skill_labels():
	var index = primary_skills_list.find(current_first_skill)
	if index == -1:
		index = 0

	var left  = primary_skills_list[(index - 1 + primary_skills_list.size()) % primary_skills_list.size()]
	var mid   = primary_skills_list[index]
	var right = primary_skills_list[(index + 1) % primary_skills_list.size()]

	first_skill_0.text = left
	first_skill_1.text = mid
	first_skill_2.text = right

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

func take_damage(amount: float, hit_from: Vector2 = global_position, force: float = 250):
	if dead : return
	if invulnerable: return
	current_health -= amount
	update_health()
	
	if not hit_from == global_position:
		var dir := (global_position - hit_from).normalized()
		velocity = dir * force
		
		state_machine.change_to("Hit")
	
	if current_health <= 0:
		dead = true
		state_machine.change_to("Die")

func update_health() -> void:
	if progress_bar:
		progress_bar.value = current_health
		if progress_bar.value < max_health:
			progress_bar.show()

func add_primary_skill(skill_name: String) -> void:
	if skill_name in primary_skills_list:
		return
	
	primary_skills_list.append(skill_name)
	
	GameState.game_data.primary_skills_list = primary_skills_list
	GameState.save_game()
