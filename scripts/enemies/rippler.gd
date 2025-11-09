extends CharacterBody2D

var speed: float = 80.0 
var health: float = 30.0 
var current_health: float = 30.0
var max_health: float = 30.0

@export var damage_melee: float = 5.0  
var can_attack: bool = true            


var player: Node2D = null              
var player_chase: bool = false         
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var attack_cooldown_timer: Timer = $AttackCooldownTimer
@onready var attack_area: Area2D = $AttackArea 
@onready var attack_sprite: AnimatedSprite2D = $AttackSprite


func _ready() -> void:
	progress_bar.max_value = max_health
	progress_bar.value = max_health
	progress_bar.hide() 



func _physics_process(delta: float) -> void:
	if player_chase and is_instance_valid(player):
		var direction = (player.position - position).normalized()
		velocity = direction * speed
		
		check_for_attack() 
		
	else:
		velocity = Vector2.ZERO
		
	move_and_slide()


func check_for_attack() -> void:
	
	if can_attack:
	
		var overlapping_bodies = attack_area.get_overlapping_bodies()
		
		for body in overlapping_bodies:
		
			if body.is_in_group("player"):
				
			
				if body.has_method("take_damage"):
					
				
					body.take_damage(damage_melee)
					attack_sprite.show()
					attack_sprite.play("run")
					
					
					can_attack = false
					attack_cooldown_timer.start()
					return



func _on_attack_cooldown_timer_timeout() -> void:
	can_attack = true


func take_damage(amount: float) -> void:
	current_health -= amount
	update_health()
	
	if current_health <= 0:
		print("El Rippler ha sido destruido.")
		queue_free()
		
func update_health() -> void:
	if progress_bar:
		progress_bar.value = current_health
		if progress_bar.value < max_health:
			progress_bar.show()

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = body
		player_chase = true

func _on_detection_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = null
		player_chase = false
