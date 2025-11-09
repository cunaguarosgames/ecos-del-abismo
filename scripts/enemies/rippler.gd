extends CharacterBody2D

var speed = 25
var player_chase = false
var player = null
var health = 30
var current_health = 100.0
var max_health = 100.0

func _physics_process(delta: float) -> void:
	if player_chase and is_instance_valid(player):
		var direction = (player.position - position).normalized()
		velocity = direction * speed
	else:
		velocity = Vector2.ZERO
	move_and_slide()


func _on_detection_area_body_entered(body: Node2D) -> void:
	player = body
	player_chase = true 

func _on_detection_area_body_exited(body: Node2D) -> void:
	player = null
	player_chase = false
	
func get_damage(damage:int):
	health-=damage
	print(health)
	
func take_damage(amount : float):
	current_health -= amount
	
	if current_health <= 0:
		print("el personaje no tiene salud")
func update_health():
	pass
		
	
