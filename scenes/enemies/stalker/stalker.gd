class_name Stalker extends CharacterBody2D

var speed: float = 75.0
var current_health: float = 30.0
var max_health: float = 30.0

@export var damage_melee: float = 5.0
var can_attack: bool = true 
var player: Node2D = null
var attack_range = 100


@onready var state_machine: StateMachine = $StateMachine
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var attack_cooldown_timer: Timer = $AttackCooldownTimer
@onready var attack_area: Area2D = $AttackArea
@onready var detection_area: Area2D = $DetectionArea
@onready var main_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_animation_sprite: AnimatedSprite2D = $AttackAnimationSprite


func _ready() -> void:
	progress_bar.max_value = max_health
	progress_bar.value = max_health
	progress_bar.hide()

	attack_cooldown_timer.timeout.connect(_on_attack_cooldown_timer_timeout)
	attack_animation_sprite.animation_finished.connect(_on_attack_animation_finished)
	main_sprite.animation_finished.connect(_on_main_sprite_animation_finished)
	
	attack_animation_sprite.hide()
	
	RhythmManager.connect("beat_signal", Callable(self, "_on_beat"))

func _physics_process(_delta: float) -> void:
	pass

func take_damage(amount: float) -> void:
	current_health -= amount
	update_health()

func update_health() -> void:
	if progress_bar:
		progress_bar.value = current_health
		if progress_bar.value < max_health:
			progress_bar.show()


func play_main_animation(anim_name: String) -> void:
	main_sprite.play(anim_name)

func _on_attack_cooldown_timer_timeout() -> void:
	can_attack = true

func _on_attack_animation_finished() -> void:
	attack_animation_sprite.hide()
	if current_health <= 0:
		state_machine.change_to("Death")
	elif player:
		state_machine.change_to("Chasing")
	else:
		state_machine.change_to("Idle")

	
func _on_main_sprite_animation_finished() -> void:
	if main_sprite.animation == "death":
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
	
	if state_machine.current_state.name == "Chasing":
		if player and can_attack:
			var distance_to_player = global_position.distance_to(player.global_position)
			if distance_to_player <= attack_range:
				state_machine.change_to("Attack")
