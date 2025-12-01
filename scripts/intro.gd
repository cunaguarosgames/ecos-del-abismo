extends CanvasLayer

@onready var black_rect: ColorRect = $ColorRect
@onready var logo: Sprite2D = $CunaguarosGames

func _ready() -> void:
	fade_in_logo()

func fade_in_logo() -> void:
	var t := create_tween()
	
	t.tween_property(black_rect, "modulate:a", 0.0, 1.5)
	
	t.tween_interval(3.0)
	
	t.tween_property(black_rect, "modulate:a", 1.0, 1.5)
	
	t.tween_callback(Callable(self, "_go_to_next_scene"))

func _go_to_next_scene():
	get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn")
