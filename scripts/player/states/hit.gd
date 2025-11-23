extends PlayerStateBase

@export var knockback_decay := 800.0

func start():
	player.can_attack = false
	player.animated_sprite_2d.play("hurt")

func on_physics_process(delta: float) -> void:
	player.velocity = player.velocity.move_toward(Vector2.ZERO, knockback_decay * delta)
	player.move_and_slide()
	
	if player.velocity.length() < 10.0:
		state_machine.change_to(player.states.Idle)

func end():
	player.can_attack = true
	player.animated_sprite_2d.play("hurt")
