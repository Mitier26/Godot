extends Area2D

class_name Invader

@onready var sprite_2d = $Sprite2D

var config : Resource

func _ready():
	sprite_2d.texture = config.sprite
