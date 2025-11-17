extends babosaStateBase

func start() -> void:
	babosa.animSprite.play("explotion")
	babosa.animSprite.animation_finished.connect(babosa.queue_free, CONNECT_ONE_SHOT)
