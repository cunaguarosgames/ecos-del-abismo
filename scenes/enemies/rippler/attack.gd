extends RipplerStateBase

@export var furious_speed_multiplier: float = 1.5

func start() -> void:
	rippler.play_main_animation("furious")
	rippler.velocity = Vector2.ZERO

func on_physics_process(_delta: float) -> void:
	if rippler.player:
		var direction = (rippler.player.position - rippler.position).normalized()
		rippler.velocity = direction * rippler.speed * furious_speed_multiplier
		
		if rippler.can_attack:
			rippler.check_for_attack()
	else:
		rippler.velocity = Vector2.ZERO
