extends PlayerStateBase

@export var dash_speed := 150.0
@export var dash_duration := 0.20

var dash_direction := Vector2.ZERO
var dash_timer := 0.0

func start():
	player.can_attack = false
	dash_timer = dash_duration
	dash_speed = 150.0
	
	dash_direction = player.direction
	if dash_direction == Vector2.ZERO:
		dash_direction = player.last_direction
		
	dash_direction = dash_direction.normalized()
	
	player.animated_sprite_2d.play("dash")
	
	if RhythmManager.is_on_beat():
		player.invulnerable = true
		dash_speed = 300.0
		if player.animated_sprite_2d.material:
			var mat = player.animated_sprite_2d.material
			mat.set_shader_parameter("glow_strength", 2.5)
			mat.set_shader_parameter("outline_color", Color(1, 1, 0.2))
			mat.set_shader_parameter("outline_size", 1.0)

func on_physics_process(delta: float) -> void:
	dash_timer -= delta

	player.velocity = dash_direction * dash_speed
	player.move_and_slide()

	if dash_timer <= 0:
		if player.direction != Vector2.ZERO:
			state_machine.change_to(player.states.Walk)
		else:
			state_machine.change_to(player.states.Idle)

func end():
	player.can_attack = true
	player.invulnerable = false
	
	if player.animated_sprite_2d.material:
		player.animated_sprite_2d.material.set_shader_parameter("glow_strength", 0.0)
