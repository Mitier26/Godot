extends CharacterBody2D


func _ready():
	
	# connect the game over signal
	GameManager.connect("Game_Over", Dog_Laughing)
	
	
func Dog_Laughing():
	
	# move the dog on the y axis
	Move_Position(Vector2(0, -80))
	

func Move_Position(pos):
	
	# create a tween
	var Position_Tween = get_tree().create_tween()
	
	# tween the position property and move it upwards by 1 second
	Position_Tween.tween_property(self, "position", position + pos, 1)
	
	# create a timer of 2 seconds and connect the timeout signal
	get_tree().create_timer(2).connect("timeout", Game_Over)
	
	
func Game_Over():
	
	# change the scene to game over scene
	get_tree().change_scene_to_file("res://scenes/game_over.tscn")
