extends CharacterBody2D


@onready var animation_player = $AnimationPlayer


func _ready():
	
	# connect the dog signal
	GameManager.connect("Dog", Move_Position)
	
	
func Move_Position():
	
	# play the bird animation
	animation_player.play("Bird_Animation")
