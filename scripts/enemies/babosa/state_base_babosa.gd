class_name babosaStateBase extends "res://utils/state_machine/state_base.gd"


var babosa:babosa:
	set (value):
		controlled_node = value
	get:
		return controlled_node
