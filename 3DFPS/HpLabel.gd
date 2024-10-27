extends Label

var fmt = "HP %d"

#@onready var player = get_node("/root/Node3D/Player")
@onready var gameover = get_node("/root/Node3D/Gameover")
@onready var player = $"../Player"

func _ready():
	gameover.visible = false

func _process(delta):
	var hp = player.hp
	self.text = fmt % hp
	
	if hp <= 0:
		gameover.visible = true
		get_tree().paused = true
