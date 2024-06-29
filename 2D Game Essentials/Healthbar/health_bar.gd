extends ProgressBar

@export var character : CharacterBody2D

var has_health = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if has_variable(character, "health"):
		max_value = character.health
		value = character.health
		has_health = true
		print("The node has the variable: " + "health")
	else:
		has_health = false
		print("The node does not have the variable: " + "health")
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if has_health:
		value = character.health


func has_variable(node, var_name):
	if node != null:
		node.get(var_name)
		return true
	else :
		return false
