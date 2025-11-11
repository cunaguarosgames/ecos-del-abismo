extends PlayerStateBase

func on_physics_process(delta: float) -> void:
	player.animated_sprite_2d.play("idle")

func on_input(event: InputEvent) -> void:
	if Input.is_action_pressed("up") or Input.is_action_pressed("down") or Input.is_action_pressed("left") or Input.is_action_pressed("right"):
		state_machine.change_to("Walk")
