extends Node2D

@export var game_stats : GameStats

@onready var ship = $Ship
@onready var score_label = $ScoreLabel

func _ready():
	
	update_score_label(game_stats.score)
	game_stats.score_change.connect(update_score_label)
	
	ship.tree_exited.connect(func():
		await get_tree().create_timer(1.0).timeout
		get_tree().change_scene_to_file("res://menus/game_over.tscn")
	)

func update_score_label(new_score):
	score_label.text = "SCORE: " + str(new_score)

# no health signal
# score component -> set the score
# signal score chnage
# update the score label
