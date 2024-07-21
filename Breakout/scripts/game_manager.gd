extends Node

@onready var score_label = $CanvasLayer/ScoreLabel
@onready var level_label = $CanvasLayer/LevelLabel


var score = 0
var level = 1


func addPoint(points):
	score += points


func _process(delta):
		score_label.text = str(score)
		level_label.text = "Level : " + str(level)
