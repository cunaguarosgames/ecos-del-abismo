extends ChipiStateBase

@export var knockback_decay := 800.0

func start():
	chipi.can_attack = false
	chipi.play_main_animation("hurt")

func on_physics_process(delta: float) -> void:
	chipi.velocity = chipi.velocity.move_toward(Vector2.ZERO, knockback_decay * delta)
	chipi.move_and_slide()
	
	if chipi.velocity.length() < 10.0:
		state_machine.change_to("Idle")

func end():
	chipi.can_attack = true
	chipi.play_main_animation("hurt")
