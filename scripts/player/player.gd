class_name Player extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var primary_attack_timer: Timer = $PrimaryAttackTimer
@onready var secondary_attack_timer: Timer = $SecondaryAttackTimer

@onready var skills_menu: Control = $SkillsMenu
@onready var primary_skill_0: Label = $SkillsMenu/PrimaryContainer/PrimarySkill0
@onready var primary_skill_1: Label = $SkillsMenu/PrimaryContainer/PrimarySkill1
@onready var primary_skill_2: Label = $SkillsMenu/PrimaryContainer/PrimarySkill2
@onready var secondary_skill_0: Label = $SkillsMenu/SecondaryContainer/SecondarySkill0
@onready var secondary_skill_1: Label = $SkillsMenu/SecondaryContainer/SecondarySkill1
@onready var secondary_skill_2: Label = $SkillsMenu/SecondaryContainer/SecondarySkill2

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
var current_health: float = GameState.game_data.current_health
var dead = false
var invulnerable: bool = false

var current_primary_skill: String = GameState.game_data.primary_skill
var primary_skills_list: Array = GameState.game_data.primary_skills_list

var current_secondary_skill: String = GameState.game_data.secondary_skill
var secondary_skills_list: Array = GameState.game_data.secondary_skills_list

func _ready() -> void:
	progress_bar.max_value = max_health
	progress_bar.value = current_health
	
	if animated_sprite_2d.material:
		animated_sprite_2d.material.set_shader_parameter("glow_strength", 0.0)

func update_skill_labels():
	var index = primary_skills_list.find(current_primary_skill)
	if index == -1:
		index = 0

	var left  = primary_skills_list[(index - 1 + primary_skills_list.size()) % primary_skills_list.size()]
	var mid   = primary_skills_list[index]
	var right = primary_skills_list[(index + 1) % primary_skills_list.size()]

	primary_skill_0.text = left
	primary_skill_1.text = mid
	primary_skill_2.text = right
	
	index = secondary_skills_list.find(current_secondary_skill)
	if index == -1:
		index = 0

	left  = secondary_skills_list[(index - 1 + secondary_skills_list.size()) % secondary_skills_list.size()]
	mid   = secondary_skills_list[index]
	right = secondary_skills_list[(index + 1) % secondary_skills_list.size()]

	secondary_skill_0.text = left
	secondary_skill_1.text = mid
	secondary_skill_2.text = right

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

func add_secondary_skill(skill_name: String) -> void:
	if skill_name in secondary_skills_list:
		return
	
	secondary_skills_list.append(skill_name)
	
	GameState.game_data.secondary_skills_list = secondary_skills_list
	GameState.save_game()

func health_player(amount: float):
	if dead == false:
		current_health += amount
		if current_health >= max_health:
			current_health = max_health
		update_health()
