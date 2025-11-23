extends hummerStateBase

func start() -> void:
	hummer.velocity = Vector2.ZERO
	hummer.animSprite.play("die")

	if not hummer.animSprite.animation_finished.is_connected(hummer.queue_free):
		hummer.animSprite.animation_finished.connect(hummer.queue_free, CONNECT_ONE_SHOT)
