extends Node

var collectibles = { 
	"babosa": 0
}

func add_collectible(name):
	if collectibles.has(name):
		collectibles[name] += 1
		print("añadido coleccionable: ", collectibles[name])
	else: 
		return
