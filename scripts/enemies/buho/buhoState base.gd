class_name buhoStateBase extends "res://utils/state_machine/state_base.gd"

var buho:buho:
	set (value):
		controlled_node = value
	get:
		return controlled_node
