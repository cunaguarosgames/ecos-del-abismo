extends PlayerStateBase

func on_physics_process(delta: float) -> void:
	player.animated_sprite_2d.play("walk")

func on_input(event: InputEvent) -> void:
	if not Input.is_action_pressed("up") and not Input.is_action_pressed("down") and not Input.is_action_pressed("left") and not Input.is_action_pressed("right"):
		state_machine.change_to("Idle")
