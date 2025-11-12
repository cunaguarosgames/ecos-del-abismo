extends RipplerStateBase

@export var speed_multiplier: float = 1.0

func start() -> void:
	rippler.play_main_animation("walk") 
	rippler.velocity = Vector2.ZERO

func on_physics_process(_delta: float) -> void:
	if rippler.player:
		var direction = (rippler.player.position - rippler.position).normalized()
		rippler.velocity = direction * rippler.speed * speed_multiplier
		
		if rippler.can_attack:
			rippler.check_for_attack()
	else:
		rippler.velocity = Vector2.ZERO
		
	if rippler.current_health <=0: 
		state_machine.change_to("Death")
