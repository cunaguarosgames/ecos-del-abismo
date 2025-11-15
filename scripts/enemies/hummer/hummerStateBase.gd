class_name hummerStateBase extends "res://scenes/enemies/rippler/state_base.gd"

var hummer:hummer:
	set (value):
		controlled_node = value
	get:
		return controlled_node
