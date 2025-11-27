extends BrutalonStateBase

var played := false

func start() -> void:
	brutalon.velocity = Vector2.ZERO
	brutalon.play_main_animation("death")

func on_physics_process(_delta: float) -> void:
	if not played and brutalon.animated_sprite_2d.frame == 5:
		played = true
		var tween := brutalon.create_tween()

		tween.tween_property(brutalon, "scale", brutalon.scale * 0.75, 0.4)
		tween.tween_property(brutalon, "modulate:a", 0.0, 0.3)

		await tween.finished
		brutalon.queue_free()
