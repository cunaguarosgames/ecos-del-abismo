extends Area2D

@export_file("*.tscn") var scene

func change_scene():
	get_tree().change_scene_to_file(scene)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		GameState.game_data.last_entry = name
		GameState.game_data.current_health = body.current_health
		GameState.save_game()
		call_deferred("change_scene")
