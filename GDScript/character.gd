class_name Character

extends Node

@export var profession : String
@export var health: int


func die():
	health = 0
	print(profession + " 죽음.")

var chest := Equipment.new()
var legs := Equipment.new()

func _ready():
	chest.armor = 20
	print(chest.armor)
	print(legs.weigth)

class Equipment:
	var armor := 10
	var weigth := 5
