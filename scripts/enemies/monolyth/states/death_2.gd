extends MonolythStateBase

var played := false

func start() -> void:
	monolyth.velocity = Vector2.ZERO
	monolyth.play_main_animation("death2")

func on_physics_process(_delta: float) -> void:
	if not played and monolyth.animated_sprite_2d.frame == 0:
		played = true
		var tween := monolyth.create_tween()

		tween.tween_property(monolyth, "scale", monolyth.scale * 0.75, 0.4)
		tween.tween_property(monolyth, "modulate:a", 0.0, 0.3)

		await tween.finished
		
		var health = preload("res://scenes/items/health_item.tscn").instantiate()
		health.global_position = monolyth.global_position
		get_parent().get_parent().get_parent().add_child(health)
		
		monolyth.queue_free()
