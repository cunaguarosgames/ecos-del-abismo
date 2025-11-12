class_name RipplerStateBase extends StateBase

var rippler:Rippler:
	set (value):
		controlled_node = value
	get:
		return controlled_node
