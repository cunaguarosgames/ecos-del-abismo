extends buhoStateBase

@export var friction := 800.0
var connected := false

func start():
	buho.animSprite.play("hit")

	if not connected:
		buho.animSprite.animation_finished.connect(on_hit_finished)
		connected = true

func end():
	if connected:
		buho.animSprite.animation_finished.disconnect(on_hit_finished)
		connected = false

func on_physics_process(delta: float):
	buho.velocity = buho.velocity.move_toward(Vector2.ZERO, friction * delta)

func on_hit_finished():
	buho.velocity = Vector2.ZERO
	if buho.target and buho.target.is_in_group("player"):
		state_machine.change_to("follow")
	else:
		state_machine.change_to("patrol")
