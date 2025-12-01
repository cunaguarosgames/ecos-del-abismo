class_name MonolythStateBase extends StateBase

var monolyth:Monolyth:
	set (value):
		controlled_node = value
	get:
		return controlled_node
