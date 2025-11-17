extends hummerStateBase

func start() -> void:
	hummer.animSprite.play("die")
	hummer.animSprite.animation_finished.connect(hummer.queue_free, CONNECT_ONE_SHOT)
