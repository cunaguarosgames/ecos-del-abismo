extends MonolythStateBase

@export var knockback_decay := 800.0

func start():
	brutalon.can_attack = false
	brutalon.play_main_animation("hurt")

func on_physics_process(delta: float) -> void:
	brutalon.velocity = brutalon.velocity.move_toward(Vector2.ZERO, knockback_decay * delta)
	brutalon.move_and_slide()
	
	if brutalon.velocity.length() < 10.0:
		state_machine.change_to("Idle")

func end():
	brutalon.can_attack = true
	brutalon.play_main_animation("hurt")
