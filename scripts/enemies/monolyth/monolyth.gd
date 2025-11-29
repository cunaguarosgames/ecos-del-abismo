class_name Monolyth extends CharacterBody2D

@export var damage_melee: float = 5.0

@onready var attack_cooldown_timer: Timer = $AttackCooldownTimer
@onready var attack_cooldown_timer2: Timer = $AttackCooldownTimer2
@onready var detection_area: Area2D = $DetectionArea
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var progress_bar: ProgressBar = $HealthBar
@onready var state_machine: StateMachine = $StateMachine

var current_health: float = 30.0
var max_health: float = 30.0
var dead: bool = false
var invulnerable: bool = false

var speed: float = 75.0
var direction := Vector2.ZERO
var can_attack: bool = true 
var player: Node2D = null
var attack_range = 150
var phase2 = false

func _ready() -> void:
	max_health = 30.0
	current_health = max_health
	
	progress_bar.max_value = max_health
	progress_bar.value = max_health
	progress_bar.hide()
	
	RhythmManager.connect("beat_signal", Callable(self, "_on_beat"))

func _physics_process(_delta: float) -> void:
	pass

func update_health() -> void:
	if progress_bar:
		progress_bar.value = current_health
		if progress_bar.value < max_health:
			progress_bar.show()

func take_damage(amount: float, hit_from: Vector2 = global_position, force: float = 250):
	if dead : return
	if invulnerable: return
	current_health -= amount
	update_health()
	
	if not hit_from == global_position:
		var dir := (global_position - hit_from).normalized()
		velocity = dir * force
		
		if phase2:
			state_machine.change_to("Hit2")
			return
		state_machine.change_to("Hit")
	
	if current_health <= 0:
		dead = true
		
		if phase2:
			state_machine.change_to("Death2")
			return
		state_machine.change_to("Death")

func play_main_animation(anim_name: String) -> void:
	if direction.x != 0:
		animated_sprite_2d.flip_h = direction.x < 0
	
	animated_sprite_2d.play(anim_name)

func _on_attack_animation_finished() -> void:
	if phase2:
		if current_health <= 0:
			state_machine.change_to("Death2")
		elif player:
			state_machine.change_to("Chasing2")
		else:
			state_machine.change_to("Idle2")
		return
	if current_health <= 0:
		state_machine.change_to("Death")
	elif player:
		state_machine.change_to("Chasing")
	else:
		state_machine.change_to("Idle")

func _on_main_sprite_animation_finished() -> void:
	if animated_sprite_2d.animation == "death2":
		if current_health <= 0:
			queue_free()

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = body
		update_health() 

func _on_detection_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = null
		
func _on_beat(beat_count):
	if current_health <= 0:
		return
	
	if state_machine.current_state.name == "Chasing" or state_machine.current_state.name == "Chasing2":
		if player and can_attack:
			var distance_to_player = global_position.distance_to(player.global_position)
			if distance_to_player <= attack_range:
				if phase2:
					state_machine.change_to("Attack2")
					return
				state_machine.change_to("Attack")
