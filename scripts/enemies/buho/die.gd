extends buhoStateBase

func start() -> void:
	
	for t in buho.get_tree().get_nodes_in_group("timers"):
		t.stop()

	buho.velocity = Vector2.ZERO
	buho.animSprite.stop()

	# Reproducir anim de muerte
	buho.animSprite.play("die")

	await buho.animSprite.animation_finished
	buho.queue_free()
