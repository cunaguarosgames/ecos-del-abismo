extends hummerStateBase

func _on_death(): 
	var random_chance = randi_range(1, 100)
	if random_chance <= 20:
		var health = preload("res://scenes/items/health_item.tscn").instantiate()
		health.global_position = hummer.global_position
		get_parent().get_parent().get_parent().add_child(health)
	hummer.queue_free()
	
func start() -> void:
	hummer.velocity = Vector2.ZERO
	hummer.animSprite.play("die")

	if not hummer.animSprite.animation_finished.is_connected(hummer.queue_free):
		hummer.animSprite.animation_finished.connect(_on_death, CONNECT_ONE_SHOT)
