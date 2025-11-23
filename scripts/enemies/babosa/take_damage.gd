extends babosaStateBase

@export var friction = 15

func start():
	if babosa.current_health <= babosa.max_health / 2:
		babosa.animSprite.play("hit W_S") 
	else: 
		babosa.animSprite.play("hit")
		
	babosa.animSprite.animation_finished.connect(on_hit_animation_finished)

func end():
	babosa.animSprite.animation_finished.disconnect(on_hit_animation_finished)

func on_physics_process(delta: float):
	babosa.velocity = babosa.velocity.move_toward(Vector2.ZERO, friction * delta * 100)
	
func on_hit_animation_finished():
	babosa.velocity = Vector2.ZERO 
	
	if babosa.target and babosa.target.is_in_group("player"):
		state_machine.change_to("follow")
	else:
		state_machine.change_to("idle")
