extends Area2D

class_name Invader

@onready var sprite_2d = $Sprite2D
@onready var animation_player = $AnimationPlayer

var config : Resource

func _ready():
	sprite_2d.texture = config.sprite
	animation_player.play(config.animation_name)
