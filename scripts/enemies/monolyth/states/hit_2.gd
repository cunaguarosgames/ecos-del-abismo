extends MonolythStateBase

@export var knockback_decay := 800.0

func start():
	monolyth.invulnerable = true
	monolyth.can_attack = false
	monolyth.play_main_animation("hurt2")

func on_physics_process(delta: float) -> void:
	monolyth.velocity = monolyth.velocity.move_toward(Vector2.ZERO, knockback_decay * delta)
	monolyth.move_and_slide()
	
	if monolyth.velocity.length() < 10.0:
		state_machine.change_to("Idle2")

func end():
	monolyth.invulnerable = true
	monolyth.can_attack = true
	monolyth.play_main_animation("hurt2")
