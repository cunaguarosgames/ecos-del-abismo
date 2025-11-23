extends buhoStateBase

func start() -> void:
	#hummer.animSprite.play("die")
	#hummer.animSprite.animation_finished.connect(hummer.queue_free, CONNECT_ONE_SHOT)
	buho.queue_free()
