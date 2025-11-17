class_name babosa extends CharacterBody2D

@onready var animSprite = $AnimatedSprite2D
@onready var health_bar = $ProgressBar
@onready var coldown_attack = $timers/coldown_attack
@onready var coldown_explotion = $timers/coldown_explotion
@onready var recalculateTarget = $timers/recalculate_target
@onready var follow_area = $follow_area
@onready var navigation = $NavigationAgent2D
@onready var state_machine: StateMachine = $StateMachine
@onready var attackArea = $attack_area
@export var max_health: float = 10.0
@export var speed = 30 
@export var followSpeed = 65
@export var attack = 5
@export var explotionDamage = 30
@export var knockback_force = 150

var current_health = 0 
var target = null 
var can_attack = true 
var sleep = true 
var attack_area = false  

func _ready() -> void: 
	health_bar.hide()
	health_bar.max_value = max_health 
	health_bar.value = max_health
	current_health = max_health
	
	recalculateTarget.timeout.connect(_on_recalculateTarget_timeout)
	coldown_attack.timeout.connect(_on_cooldown_attack_timeout)
	
	follow_area.body_entered.connect(_on_detection_area_body_entered)
	follow_area.body_exited.connect(_on_detection_area_body_exited)
	
	attackArea.body_entered.connect(_on_area_attack_entered)
	attackArea.body_exited.connect(_on_area_attack_exited)

func update_health() -> void:
	if health_bar:
		health_bar.value = current_health
		if health_bar.value < max_health:
			health_bar.show()

func take_damage(amount: float) -> void:
	current_health -= amount

	if target !=null and target.is_in_group("player"):
		var knockback_source = target.global_position 
		var knockback_direction = (global_position - knockback_source).normalized()
		velocity = knockback_direction * knockback_force
	else:
		velocity = Vector2.ZERO

	update_health()

	if current_health <= 0:
		velocity = Vector2.ZERO
		state_machine.change_to("dead")
	elif not state_machine.is_current("takeDamage"):
		state_machine.change_to("takeDamage")

	
func _on_detection_area_body_entered(body: Node2D):
	if body.is_in_group("player"):
		recalculateTarget.start()
		target = body
		print("body detect:", body)

func _on_detection_area_body_exited(body: Node2D):
	if body == target:
		recalculateTarget.stop()
		target = null

func try_attack():
	if attack_area and can_attack:
		state_machine.change_to("attack")

func _on_area_attack_entered(body: Node2D):
	print(body.is_in_group("player"))
	if body.is_in_group("player"):
		
		attack_area = true
		print("cambio de attack area: ", attack_area)
		try_attack()

func _on_area_attack_exited(body: Node2D):
	if body.is_in_group("player"):
		attack_area = false
		if state_machine.is_current("attack"):
			state_machine.change_to("follow")

func _on_cooldown_attack_timeout() -> void:
	can_attack = true
	if attack_area:
		try_attack()
	else:
		state_machine.change_to("follow")

func _on_recalculateTarget_timeout() -> void:
	if target != null and target.is_in_group("player"):
		navigation.target_position = target.global_position
	
func _process(delta: float) -> void:
	move_and_slide()
