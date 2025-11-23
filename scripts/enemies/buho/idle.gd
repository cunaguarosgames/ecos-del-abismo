extends buhoStateBase

func on_process(delta: float) -> void:

	if buho.target and buho.target.is_in_group("player"):
		state_machine.change_to("follow")
		return
	else: 
		state_machine.change_to("patrol")
		
	buho.animSprite.play("idle")
