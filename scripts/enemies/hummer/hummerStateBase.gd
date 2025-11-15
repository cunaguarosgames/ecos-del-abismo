class_name hummerStateBase extends "res://utils/state_machine/state_base.gd"

var hummer:hummer:
	set (value):
		controlled_node = value
	get:
		return controlled_node
