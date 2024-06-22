extends Control

@onready var scoreText = $Label


func _process(delta):
	scoreText.text = "점수 : " + str(Global.score)
