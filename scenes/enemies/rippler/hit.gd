extends RipplerStateBase
@export var knockback_decay := 800.0

func start():
	rippler.can_attack = false
	rippler.main_sprite.play("hurt")

func on_physics_process(delta: float) -> void:
	rippler.velocity = rippler.velocity.move_toward(Vector2.ZERO, knockback_decay * delta)
	rippler.move_and_slide()
	
	if rippler.velocity.length() < 10.0:
		state_machine.change_to("Idle")

func end():
	rippler.can_attack = true
	rippler.main_sprite.play("hurt")
