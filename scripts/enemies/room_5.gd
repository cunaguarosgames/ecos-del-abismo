extends Node2D

@onready var doorNextLevel = $DoorToNextLevel
@onready var Boss = $entities/buho 

func _ready() -> void:
	doorNextLevel.hide()
	_conectar_senales()
	

func _conectar_senales():
	if is_instance_valid(Boss):
		Boss.enemigo_derrotado.connect(_abrir_puerta)

func _abrir_puerta():
	doorNextLevel.show()
