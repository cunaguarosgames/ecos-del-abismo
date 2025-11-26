class_name hummer
extends enemyBase

@onready var detectionArea = $"detection-area"
@onready var attackArea = $"attack area"
@onready var attackTimer = $attackColdown
@onready var TimerFollow = $timerFollow
@onready var recalculateTarget = $recalculateTarget

@export var attack_scene: PackedScene
@export var waypoints: Array[Marker2D]

var current_index := 0
var dead = true
var wait = false
var attack_area = false 

func on_ready_extra() -> void:
	TimerFollow.timeout.connect(_on_timerFollow_timeout)
	recalculateTarget.timeout.connect(_on_recalculateTarget_timeout)

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
		
		if state_machine.current_state.name == "patrol" or state_machine.current_state.name == "idle":
			state_machine.change_to("follow")

func _on_detection_area_body_exited(body: Node2D):
	if body == target:
		recalculateTarget.stop()
		target = null

func _on_beat(beat_count):
	if state_machine.current_state.name == "follow":
		if target != null and attack_area and can_attack:
			state_machine.change_to("attack")


func _on_detection_area_attack_entered(body: Node2D):
	if body.is_in_group("player"):
		attack_area = true
		target = body


func _on_detection_area_attack_exited(body: Node2D):
	if body.is_in_group("player"):
		attack_area = false 
		if state_machine.current_state.name == "attack":
			state_machine.change_to("follow")


func _on_attack_cooldown_timeout():
	print('ataca')
	can_attack = true

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
