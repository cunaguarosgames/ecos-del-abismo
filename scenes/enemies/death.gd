extends RipplerStateBase

func start() -> void:
	rippler.velocity = Vector2.ZERO
	rippler.play_main_animation("death")

func on_physics_process(_delta: float) -> void:
	pass
