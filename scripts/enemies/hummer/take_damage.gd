extends hummerStateBase

@export var friction = 15 # Valor para detener el knockback rápidamente (ajusta este valor)

func start():
	hummer.animSprite.play("hit")
	# NO ponemos la velocidad a cero aquí, ya que el hummer.take_damage() ya la estableció.
	
	hummer.animSprite.animation_finished.connect(on_hit_animation_finished)

func end():
	hummer.animSprite.animation_finished.disconnect(on_hit_animation_finished)

# Modificamos on_physics_process para aplicar la fricción/atenuación
func on_physics_process(delta: float):
	# La velocidad se reduce gradualmente por la fricción.
	# El enemigo seguirá deslizándose hasta que la animación de 'hit' termine.
	hummer.velocity = hummer.velocity.move_toward(Vector2.ZERO, friction * delta * 100)
	
	# Nota: El 'delta * 100' es un multiplicador para hacer la fricción más notoria.
	
func on_hit_animation_finished():
	# Una vez terminada la animación y el retroceso, la velocidad se reinicia.
	hummer.velocity = Vector2.ZERO 
	
	if hummer.target and hummer.target.is_in_group("player"):
		state_machine.change_to("follow")
	else:
		state_machine.change_to("patrol")
