extends babosaStateBase

func on_process(delta: float) -> void:
	if babosa.current_health <= babosa.max_health/2 : 
		babosa.animSprite.play("idle W_S") 
	else:	
		babosa.animSprite.play("idle")
	
	if babosa.current_health <= 0 :
		state_machine.change_to("dead")
	
	if babosa.target and babosa.target.is_in_group("player"):
		state_machine.change_to("follow")
	
	
		
