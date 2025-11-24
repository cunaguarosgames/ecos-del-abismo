extends PlayerStateBase

func start() -> void:
	player.velocity = Vector2.ZERO
	player.play_directional_animation("death")

func on_physics_process(_delta: float) -> void:
	if player.animated_sprite_2d.animation == "death" and player.animated_sprite_2d.frame == 3:
		get_tree().reload_current_scene()
