extends hummerStateBase

@export var friction := 800.0

var connected := false

func start():
	
	hummer.animSprite.play("hit")

	if not connected:
		hummer.animSprite.animation_finished.connect(on_hit_animation_finished)
		connected = true


func end():
	if connected:
		hummer.animSprite.animation_finished.disconnect(on_hit_animation_finished)
		connected = false


func on_physics_process(delta: float):
	hummer.velocity = hummer.velocity.move_toward(Vector2.ZERO, friction * delta)


func on_hit_animation_finished():
	hummer.velocity = Vector2.ZERO
	if hummer.target and hummer.target.is_in_group("player"):
		state_machine.change_to("follow")
	else:
		state_machine.change_to("patrol")
