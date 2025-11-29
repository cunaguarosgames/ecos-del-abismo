extends MonolythStateBase

var played := false

func start() -> void:
	brutalon.velocity = Vector2.ZERO
	brutalon.play_main_animation("death")

func on_physics_process(_delta: float) -> void:
	if not played and brutalon.animated_sprite_2d.frame == 3:
		played = true
		
		brutalon.dead = false
		brutalon.max_health *= 2
		brutalon.progress_bar.max_value = brutalon.max_health
		brutalon.current_health = brutalon.max_health
		brutalon.phase2 = true
		
		brutalon.update_health()
		state_machine.change_to("Idle2")
