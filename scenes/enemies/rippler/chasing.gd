extends RipplerStateBase

var current_speed = 0
var nav_agent: NavigationAgent2D

func start() -> void:
	if rippler.has_node("NavigationAgent2D"):
		nav_agent = rippler.get_node("NavigationAgent2D")
		nav_agent.path_desired_distance = 10.0
		nav_agent.target_desired_distance = 30.0
		
	rippler.play_main_animation("run")
	rippler.velocity = Vector2.ZERO

func on_physics_process(_delta: float) -> void:
	if rippler.current_health <= 0:
		state_machine.change_to("Death")
		return
	
	if rippler.current_health > rippler.max_health / 2:
		rippler.play_main_animation("walk") 
	if rippler.current_health <= rippler.max_health / 2 and rippler.current_health > rippler.max_health / 4 : 
		rippler.play_main_animation("furious") 
	if rippler.current_health <= rippler.max_health / 4: 
		rippler.play_main_animation("afraid")
	
	if rippler.current_health > rippler.max_health / 2:
		current_speed = rippler.speed
	if rippler.current_health <= rippler.max_health / 2 and rippler.current_health > rippler.max_health / 4 : 
		current_speed = rippler.speed * 1.5
	if rippler.current_health <= rippler.max_health / 4: 
		current_speed = rippler.speed * 0.5
	
	if not rippler.player:
		state_machine.change_to("Idle")
		return
	
	nav_agent.target_position = rippler.player.global_position
	
	if not nav_agent.is_target_reached():
		var next_path_position = nav_agent.get_next_path_position()
		var direction_vector = (next_path_position - rippler.global_position).normalized()
		rippler.velocity = direction_vector * (current_speed)
	else:
		rippler.velocity = Vector2.ZERO
	
	rippler.move_and_slide()
	
