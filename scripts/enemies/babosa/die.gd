extends babosaStateBase

func start() -> void:
	babosa.animSprite.play("explotion")
	babosa.animSprite.animation_finished.connect(_on_animation_finished, CONNECT_ONE_SHOT)

func _on_animation_finished() -> void:
	explotion()       
	babosa.queue_free()

func explotion() -> void: 
	if babosa.target and babosa.target.has_method("take_damage") and babosa.attack_area:
		babosa.target.take_damage(babosa.explotionDamage)
		print("daño inflijido: ", babosa.explotionDamage)
