extends Control

@export var game_stats: GameStats

@onready var score_value = %ScoreValue
@onready var high_score_value = %HighScoreValue

func _ready():
	if game_stats.score > game_stats.highscore:
		game_stats.highscore = game_stats.score
	score_value.text = str(game_stats.score)
	high_score_value.text = str(game_stats.highscore)

func _process(delta):
	if Input.is_action_just_released("ui_accept"):
		game_stats.score = 0
		get_tree().change_scene_to_file("res://menus/menu.tscn")
