class_name hummer
extends CharacterBody2D

@onready var health_bar = $ProgressBar
@onready var animSprite = $AnimatedSprite2D
@onready var detectionArea = $"detection-area"
@onready var attackArea = $"attack area"
@onready var attackTimer = $attackColdown
@onready var TimerFollow = $timerFollow
@onready var navigation = $NavigationAgent2D
@onready var recalculateTarget = $recalculateTarget
@onready var state_machine: StateMachine = $StateMachine

@export var knockback_force = 150
@export var attack_scene: PackedScene
@export var speed = 60
@export var max_health = 50
@export var attack = 30
@export var waypoints: Array[Marker2D]

var current_index := 0
var current_health = max_health
var dead = true
var target: Node2D = null
var wait = false
var can_attack: bool = true


func _ready() -> void:
	TimerFollow.timeout.connect(_on_timerFollow_timeout)
	recalculateTarget.timeout.connect(_on_recalculateTarget_timeout)

	health_bar.hide()
	health_bar.max_value = max_health
	health_bar.value = max_health

	detectionArea.body_entered.connect(_on_detection_area_body_entered)
	detectionArea.body_exited.connect(_on_detection_area_body_exited)

	attackArea.body_entered.connect(_on_detection_area_attack_entered)
	attackArea.body_exited.connect(_on_detection_area_attack_exited)
	attackTimer.timeout.connect(_on_attack_cooldown_timeout)

	attackTimer.one_shot = true

	if waypoints.size() > 0:
		current_index = 0


func _on_detection_area_body_entered(body: Node2D):
	if body.is_in_group("player"):
		recalculateTarget.start()
		target = body
		print("body detect:", body)


func _on_detection_area_body_exited(body: Node2D):
	if body == target:
		recalculateTarget.stop()
		target = null


func _on_detection_area_attack_entered(body: Node2D):
	if body.is_in_group("player"):
		target = body

		if can_attack:
			state_machine.change_to("attack")


func _on_detection_area_attack_exited(body: Node2D):
	if body.is_in_group("player"):
		if body == target:
			target = null
		state_machine.change_to("follow")


func _on_attack_cooldown_timeout():
	print("attack")
	can_attack = true


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


func update_health() -> void:
	if health_bar:
		health_bar.value = current_health
		if health_bar.value < max_health:
			health_bar.show()


func _on_timerFollow_timeout():
	wait = false
	navigation.target_position = waypoints[current_index].global_position


func get_next_waypoint():
	current_index += 1
	if current_index >= waypoints.size():
		current_index = 0
	return waypoints[current_index]


func _on_recalculateTarget_timeout() -> void:
	if target != null and target.is_in_group("player"):
		navigation.target_position = target.global_position


func _physics_process(delta: float) -> void:
	move_and_slide()
