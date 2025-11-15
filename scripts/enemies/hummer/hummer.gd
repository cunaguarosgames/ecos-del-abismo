class_name hummer  extends CharacterBody2D

@onready var health_bar = $ProgressBar
@onready var animSprite = $AnimatedSprite2D
@onready var detectionArea = $"detection-area"
@onready var attackArea = $"attack area"
@onready var attackTimer = $attackColdown
@onready var TimerFollow = $timerFollow
@onready var navigation = $NavigationAgent2D
@onready var recalculateTarget = $recalculateTarget

@export var speed = 60
@export var max_health = 50
@export var attack = 30
@export var waypoints: Array[Marker2D]


var current_index := 0
var current_health = max_health
var coldown = 0.7
var can_atack = false 
var dead = true
var target = null
var wait = false 


func _on_detection_area_body_entered(body: Node2D):
	if body.is_in_group("player"):
		recalculateTarget.start()
		target = body
		print("body detect:", body )

func _on_detection_area_body_exited(body: Node2D):
	if body == target:
		recalculateTarget.stop()
		target = null

func take_damage(amount: float) -> void:
	current_health -= amount
	update_health()

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


func _ready() -> void:
	TimerFollow.timeout.connect(_on_timerFollow_timeout)
	recalculateTarget.timeout.connect(_on_recalculateTarget_timeout)

	health_bar.hide()
	health_bar.max_value = max_health
	health_bar.value = max_health

	detectionArea.body_entered.connect(_on_detection_area_body_entered)
	detectionArea.body_exited.connect(_on_detection_area_body_exited)
	
	# Inicializar waypoint inicial
	if waypoints.size() > 0:
		current_index = 0
	
func _physics_process(delta: float) -> void:
	move_and_slide()
