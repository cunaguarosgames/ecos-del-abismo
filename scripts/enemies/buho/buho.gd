class_name buho
extends enemyBase

@onready var coldown_basic = $timers/coldown_bassic
@onready var coldown_area = $timers/coldown_area
@onready var coldown_long = $timers/coldown_long
@onready var recalculateTarget = $timers/reacalculate_postion
@onready var TimerFollow = $timers/TimerPatrol
@onready var animArea = $Area_attack

@export var attack_scene: PackedScene
@export var areaAttack = 20
@export var longAttack = 30
@export var waypoints: Array[Marker2D]

var wait = false
var attack_area = false
var bassic_attack = false
var long_attack = false
var current_index := 0
var shield = 0 

var secondFase =  false 

func _set_attack_mode(melee: bool, lng: bool, area: bool):
	bassic_attack = melee
	long_attack = lng
	attack_area = area

func set_melee_mode():
	_set_attack_mode(true, false, false)

func set_long_mode():
	_set_attack_mode(false, true, false)

func set_area_mode():
	_set_attack_mode(false, false, true)

func clear_attack_mode():
	_set_attack_mode(false, false, false)

func on_ready_extra() -> void:
	if waypoints.size() > 0:
		navigation.target_position = waypoints[current_index].global_position
		
	coldown_basic.timeout.connect(_on_coldown_bassic_timeout)
	coldown_area.timeout.connect(_on_coldown_area_timeout)
	coldown_long.timeout.connect(_on_coldown_long_timeout)
	

func on_update_health() -> void:
	if health_bar:
		health_bar.value = current_health
		if current_health < max_health:
			health_bar.show()

func _enter_second_phase():
	speed = 80
	shield = 1 
	update_health()

# bubo.gd
func take_damage(amount: float) -> void:
	var damage_to_pass = amount

	# 1. Lógica del Escudo
	if shield > 0:
		if damage_to_pass <= shield:
			shield -= damage_to_pass
			damage_to_pass = 0
		else:
			damage_to_pass -= shield
			shield = 0
	
	if damage_to_pass > 0:
		super.take_damage(damage_to_pass)
	
	if not secondFase and current_health <= max_health * 0.5:
		secondFase = true
		_enter_second_phase()
	
	if damage_to_pass == 0:
		update_health() 
	velocity = Vector2.ZERO

func try_attack():
	if can_attack:
		if bassic_attack or long_attack or attack_area:
			state_machine.change_to("attack")

func _on_mele_atack_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		target = body
		can_attack = true
		set_melee_mode()
		try_attack()

func _on_mele_atack_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		if body == target:
			target = null
		
		can_attack = false
		set_area_mode()
		if state_machine.is_current("attack"):
			state_machine.change_to("follow")


func _on_long_attack_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		target = body
		can_attack = true
		set_long_mode()
		try_attack()

func _on_long_attack_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		if body == target:
			target = null
		can_attack = false
		clear_attack_mode()
		if state_machine.is_current("attack"):
			state_machine.change_to("follow")


func _on_area_attack_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		target = body
		can_attack = true
		set_area_mode()
		if !secondFase:
			set_long_mode() 
			
		try_attack()

func _on_area_attack_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		if body == target:
			target = null
		can_attack = false
		set_long_mode()
		if state_machine.is_current("attack"):
			state_machine.change_to("follow")


func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		recalculateTarget.start()
		target = body

func _on_detection_area_body_exited(body: Node2D) -> void:
	if body == target:
		recalculateTarget.stop()
		target = null

func _on_reacalculate_postion_timeout() -> void:
	if target != null and target.is_in_group("player"):
		navigation.target_position = target.global_position


func _on_coldown_bassic_timeout() -> void:
	can_attack = true
	if bassic_attack:
		try_attack()
	else:
		state_machine.change_to("follow")

func _on_coldown_area_timeout() -> void:
	can_attack = true
	if attack_area:
		try_attack()
	else:
		state_machine.change_to("follow")

func _on_coldown_long_timeout() -> void:
	can_attack = true
	if long_attack:
		try_attack()
	else:
		state_machine.change_to("follow")

func _on_timer_patrol_timeout() -> void:
	wait = false
	navigation.target_position = waypoints[current_index].global_position

func get_next_waypoint():
	current_index += 1
	if current_index >= waypoints.size():
		current_index = 0
	return waypoints[current_index]
