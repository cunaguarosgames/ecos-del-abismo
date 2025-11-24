extends buhoStateBase

func on_process(delta: float) -> void:
	if buho.current_health <= 0:
		return

	if buho.secondFase:
		buho.animSprite.play("idle_SF")
	else:
		buho.animSprite.play("idle")

	if buho.target and buho.target.is_in_group("player"):
		state_machine.change_to("follow")

	if buho.wait == false:
		state_machine.change_to("patrol")
