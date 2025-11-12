extends StateBase

@export var run_speed_multiplier: float = 1.2

func start() -> void:
	controlled_node.play_main_animation("run") 
	controlled_node.velocity = Vector2.ZERO

func on_physics_process(_delta: float) -> void:
	if controlled_node.player:
		var direction = (controlled_node.player.position - controlled_node.position).normalized()
		controlled_node.velocity = direction * controlled_node.speed * run_speed_multiplier
		
		if controlled_node.can_attack:
			controlled_node.check_for_attack()
	else:
		controlled_node.velocity = Vector2.ZERO
