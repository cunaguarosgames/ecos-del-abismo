class_name EnemyBase extends CharacterBody2D

@export var progress_bar: ProgressBar
@export var state_machine: StateMachine

var current_health: float = 30.0
var max_health: float = 30.0
var dead: bool = false
var invulnerable: bool = false


func _ready() -> void:
	progress_bar.max_value = max_health
	progress_bar.value = max_health
	progress_bar.hide()

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
		state_machine.change_to("Death")

func update_health() -> void:
	if progress_bar:
		progress_bar.value = current_health
		if progress_bar.value < max_health:
			progress_bar.show()
