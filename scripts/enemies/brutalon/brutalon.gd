class_name Brutalon extends EnemyBase

@export var damage_melee: float = 5.0

@onready var attack_cooldown_timer: Timer = $AttackCooldownTimer
@onready var detection_area: Area2D = $DetectionArea
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var speed: float = 75.0
var direction := Vector2.ZERO
var can_attack: bool = true 
var player: Node2D = null
var attack_range = 150

func _ready() -> void:
	state_machine  = $StateMachine
	progress_bar = $HealthBar
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

func play_main_animation(anim_name: String) -> void:
	if direction.x != 0:
		animated_sprite_2d.flip_h = direction.x < 0
	
	animated_sprite_2d.play(anim_name)

func _on_attack_animation_finished() -> void:
	#attack_animation_sprite.hide()
	if current_health <= 0:
		state_machine.change_to("Death")
	elif player:
		state_machine.change_to("Chasing")
	else:
		state_machine.change_to("Idle")

func _on_main_sprite_animation_finished() -> void:
	if animated_sprite_2d.animation == "death":
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
