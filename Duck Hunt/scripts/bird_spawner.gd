extends Node

var Bird_Instance = preload("res://scenes/bird.tscn")

var Round_Speed = 0

func _ready():
	
	# connect next round to spawn the next bird
	GameManager.connect("Next_Round", Spawn_Bird)
	
	# connect the double spawn to spawn 2 next bird
	GameManager.connect("Double_Spawn", Double_Spawn)
	
	# spawn a bird at the start of the game
	Spawn_Bird()
	
func Spawn_Bird():
	
	# increase the round speed with every new bird been spawn
	Round_Speed += 1
	
	# create an instance of the bird scene
	var bird = Bird_Instance.instantiate()
	
	# multiply bird speed by the round speed to increase the bird speed
	# every new round 
	bird.Speed *= Round_Speed
	
	# set the bird position to a new random position
	bird.position = Vector2(randf_range(25, 1130), randf_range(35, 385))
	
	# add the bird
	get_tree().root.call_deferred("add_child", bird)
	

func Double_Spawn():
	
	# spawn an extra bird
	Spawn_Bird()
