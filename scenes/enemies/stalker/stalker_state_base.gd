class_name StalkerStateBase extends StateBase

var stalker:Stalker:
	set (value):
		controlled_node = value
	get:
		return controlled_node
