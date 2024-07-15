class_name GameStats

extends Resource


@export var score : int = 0 :
	set(value):
		score = value
		score_change.emit(score)
		
@export var highscore : int = 0

signal score_change(new_score)
