extends ChipiStateBase

var played := false

func start() -> void:
	chipi.velocity = Vector2.ZERO
	chipi.play_main_animation("death")

func on_physics_process(_delta: float) -> void:
	if not played and chipi.animated_sprite_2d.frame == 3:
		played = true
		var tween := chipi.create_tween()

		tween.tween_property(chipi, "scale", chipi.scale * 0.75, 0.4)
		tween.tween_property(chipi, "modulate:a", 0.0, 0.3)

		await tween.finished
		
		var health = preload("res://scenes/items/health_item.tscn").instantiate()
		health.global_position = chipi.global_position
		get_parent().get_parent().get_parent().add_child(health)
		
		chipi.queue_free()
