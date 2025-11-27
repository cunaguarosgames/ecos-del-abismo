class_name ChipiStateBase extends StateBase

var chipi:Chipi:
	set (value):
		controlled_node = value
	get:
		return controlled_node
