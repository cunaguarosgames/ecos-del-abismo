extends StalkerStateBase

@export var knockback_decay := 800.0

func start():
	stalker.can_attack = false
	stalker.main_sprite.play("hurt")

func on_physics_process(delta: float) -> void:
	stalker.velocity = stalker.velocity.move_toward(Vector2.ZERO, knockback_decay * delta)
	stalker.move_and_slide()
	
	if stalker.velocity.length() < 10.0:
		state_machine.change_to("Idle")

func end():
	stalker.can_attack = true
	stalker.main_sprite.play("hurt")
