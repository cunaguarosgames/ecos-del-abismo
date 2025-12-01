extends MonolythStateBase

var played := false

func start() -> void:
	monolyth.velocity = Vector2.ZERO
	monolyth.play_main_animation("death")

func on_physics_process(_delta: float) -> void:
	if not played and monolyth.animated_sprite_2d.frame == 3:
		played = true
		
		monolyth.dead = false
		monolyth.max_health *= 2
		monolyth.progress_bar.max_value = monolyth.max_health
		monolyth.current_health = monolyth.max_health
		monolyth.phase2 = true
		
		monolyth.update_health()
		state_machine.change_to("Idle2")
		monolyth.especial_attack_timer.start()
