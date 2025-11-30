extends Node

signal combo_changed(new_combo)
signal combo_reset()

@export var combo_timeout: float = 1.2

var combo: int = 0
var time_since_last_hit: float = 0.0

func _process(delta):
	if combo > 0:
		time_since_last_hit += delta
		if time_since_last_hit >= combo_timeout:
			reset_combo()

func add_hit():
	combo += 1
	time_since_last_hit = 0.0
	emit_signal("combo_changed", combo)

func reset_combo():
	if combo > 0:
		combo = 0
		time_since_last_hit = 0.0
		emit_signal("combo_reset")

func get_damage_multiplier() -> float:
	return 1.0 + (combo * 0.1)
