class_name babosa extends enemieBase

@onready var coldown_attack = $timers/coldown_attack
@onready var coldown_explotion = $timers/coldown_explotion
@onready var recalculateTarget = $timers/recalculate_target
@onready var follow_area = $follow_area
@onready var attackArea = $attack_area
@export var followSpeed = 65
@export var explotionDamage = 30

var sleep = true 
var attack_area = false  

func on_ready_extra() -> void: 
	
	recalculateTarget.timeout.connect(_on_recalculateTarget_timeout)
	coldown_attack.timeout.connect(_on_cooldown_attack_timeout)
	
	follow_area.body_entered.connect(_on_detection_area_body_entered)
	follow_area.body_exited.connect(_on_detection_area_body_exited)
	
	attackArea.body_entered.connect(_on_area_attack_entered)
	attackArea.body_exited.connect(_on_area_attack_exited)

	
func _on_detection_area_body_entered(body: Node2D):
	if body.is_in_group("player"):
		recalculateTarget.start()
		target = body

func _on_detection_area_body_exited(body: Node2D):
	if body == target:
		recalculateTarget.stop()
		target = null

func try_attack():
	if attack_area and can_attack:
		state_machine.change_to("attack")

func _on_area_attack_entered(body: Node2D):
	if body.is_in_group("player"):
		attack_area = true
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
	
