extends hummerStateBase

func on_process(delta: float) -> void:
	
	hummer.animSprite.play("idle")
	
	if hummer.target and  hummer.target.is_in_group("player"):
		state_machine.change_to("follow")
	
	if hummer.wait == false:
		state_machine.change_to("patrol")
	
		
	
