extends Node2D

@onready var ship = $Ship

func _ready():
	ship.tree_exited.connect(func():
		await get_tree().create_timer(1.0).timeout
		get_tree().change_scene_to_file("res://menus/game_over.tscn")
	)
