extends PlayerStateBase

@export var dash_speed := 200.0
@export var dash_duration := 0.25

var dash_direction := Vector2.ZERO
var dash_timer := 0.0

func start():
	player.can_attack = false
	player.invulnerable = true
	dash_timer = dash_duration

	dash_direction = player.direction
	if dash_direction == Vector2.ZERO:
		dash_direction = player.last_direction

	dash_direction = dash_direction.normalized()

	player.animated_sprite_2d.play("dash")

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
