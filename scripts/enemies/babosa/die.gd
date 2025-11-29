extends babosaStateBase


func start() -> void:
	babosa.velocity = Vector2.ZERO
	babosa.animSprite.play("explotion")
	babosa.animSprite.animation_finished.connect(_on_animation_finished, CONNECT_ONE_SHOT)

func _on_animation_finished() -> void:
	var random_chance = randi_range(1, 100)
	explotion()       
	if random_chance <= 35:
		var health = preload("res://scenes/items/health_item.tscn").instantiate()
		health.global_position = babosa.global_position
		get_parent().get_parent().get_parent().add_child(health)
	babosa.queue_free()

func explotion() -> void: 
	if babosa.target and babosa.target.has_method("take_damage") and babosa.attack_area:
		babosa.target.take_damage(babosa.explotionDamage)
		print("daño inflijido: ", babosa.explotionDamage)
