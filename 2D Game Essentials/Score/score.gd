extends Label

@export var character : CharacterBody2D

var score

var has_score = false

func _ready():
	if has_variable(character, "score"):
		score = character.score
		
		has_score = true
		print("The node the variable: " + "score")
	else:
		has_score = false
		print("The node does not have the variable :" + "score")
		
func _process(delta):
	if has_score:
		score = character.score
		text = "SCORE: " + str(score)
		
func has_variable(node, var_name):
	if node != null:
		node.get(var_name)
		return true
	else:
		return false
		
