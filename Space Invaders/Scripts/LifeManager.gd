extends Node

class_name LifeManager

signal life_lost(lifes_left : int)

@export var lifes = 3
@onready var player = $"../Player"
var player_scene = preload("res://Scenes/player.tscn")

func _ready():
	# 플레이어의 파괴되었다는 신호에 연결한다.
	(player as Player).player_destroy.connect(on_player_destroyed)
	

func on_player_destroyed():
	lifes -= 1
	# 생명이 줄어들었다는 신호를 보낸다.
	life_lost.emit(lifes)
	if lifes != 0:
		player = player_scene.instantiate() as Player
		player.global_position = Vector2(0,289)
		player.player_destroy.connect(on_player_destroyed)
		get_tree().root.get_node("main").add_child(player)
