extends hummerStateBase

@export var friction = 15

func start():
	hummer.animSprite.play("hit")
	hummer.animSprite.animation_finished.connect(on_hit_animation_finished)

func end():
	hummer.animSprite.animation_finished.disconnect(on_hit_animation_finished)

func on_physics_process(delta: float):
	hummer.velocity = hummer.velocity.move_toward(Vector2.ZERO, friction * delta * 100)
	
func on_hit_animation_finished():
	hummer.velocity = Vector2.ZERO 
	
	if hummer.target and hummer.target.is_in_group("player"):
		state_machine.change_to("follow")
	else:
		state_machine.change_to("patrol")
