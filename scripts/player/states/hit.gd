extends PlayerStateBase

@export var knockback_decay := 1000.0
var velocity: Vector2 = Vector2.ZERO

func start():
	player.can_attack = false
	player.animated_sprite_2d.play("hurt")

func setup_knockback(initial_velocity: Vector2):
	velocity = initial_velocity

func on_physics_process(delta: float) -> void:
	player.velocity = velocity
	player.move_and_slide()

	velocity = velocity.move_toward(Vector2.ZERO, knockback_decay * delta)
	print(velocity)
	if velocity.length() < 10.0:
		state_machine.change_to(player.states.Idle)

func end():
	player.can_attack = true
	player.animated_sprite_2d.play("hurt")
