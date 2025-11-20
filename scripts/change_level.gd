extends Area2D

@export var new_level: PackedScene
@export var spawn_name := "SpawnPoint"

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		var level = new_level.instantiate()
		
		get_tree().current_scene.remove_child(body)
		get_tree().current_scene.queue_free()
		
		get_tree().root.add_child(level)
		
		var spawn = level.get_node_or_null(spawn_name)
		if spawn:
			body.global_position = spawn.global_position
		
		var entities = level.get_node_or_null("entities")
		if entities:
			entities.call_deferred("add_child", body)
		else:
			level.call_deferred("add_child", body)

		get_tree().current_scene = level
