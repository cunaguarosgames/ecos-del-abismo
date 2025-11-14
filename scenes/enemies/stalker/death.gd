extends StalkerStateBase

func start() -> void:
	stalker.velocity = Vector2.ZERO
	stalker.play_main_animation("death")

func on_physics_process(_delta: float) -> void:
	pass
