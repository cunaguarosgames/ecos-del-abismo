extends buhoStateBase

func start() -> void:
	buho.velocity = Vector2.ZERO
	buho.animSprite.play("die")

	if not buho.animSprite.animation_finished.is_connected(buho.queue_free):
		buho.animSprite.animation_finished.connect(buho.queue_free, CONNECT_ONE_SHOT)
