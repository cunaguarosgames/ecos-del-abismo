class_name enemieBase extends CharacterBody2D

@export var health_bar: ProgressBar
@export var animSprite: AnimatedSprite2D
@export var navigation: NavigationAgent2D
@export var state_machine: StateMachine

@export var max_health := 10
@export var speed := 40
@export var attack := 5
@export var knockback_force := 150

var can_attack := false
var target = null
var current_health := 0

func _ready():
	current_health = max_health
	health_bar.hide()
	health_bar.max_value = max_health
	health_bar.value = max_health

	on_ready_extra()

func on_ready_extra(): pass


func take_damage(amount):
	print("current health: ", current_health)
	current_health -= amount

	if target and target.is_in_group("player"):
		var dir = (global_position - target.global_position).normalized()
		velocity = dir * knockback_force

	on_take_damage()
	update_health()

	if current_health <= 0:
		state_machine.change_to("dead")
	else:
		state_machine.change_to("takeDamage")

func on_take_damage(): pass

func update_health():
	if health_bar:
		health_bar.value = current_health
		if current_health < max_health:
			health_bar.show()
			
	on_update_health()

func on_update_health(): pass

func _physics_process(delta):
	if current_health <= 0:
		state_machine.change_to("dead")
	on_phisics_process_extra()
	move_and_slide()

func on_phisics_process_extra(): pass
