@tool
extends Path2D

enum ANIMATION_TYPE {
	LOOP,
	BOUNCE
}
@onready var animation_player = $AnimationPlayer

@export var speed : int :
	set = set_speed
	
@export var animation_type : ANIMATION_TYPE :
	set = set_animation_type
	

func set_speed(value):
	speed = value
	var ap = find_child("AnimationPlayer")
	if ap: ap.speed_scale = speed

func set_animation_type(value):
	animation_type = value
	var ap = find_child("AnimationPlayer")
	if ap: play_update_animation(ap)

func _ready():
	play_update_animation(animation_player)

func play_update_animation(ap):
	match animation_type:
		ANIMATION_TYPE.LOOP:
			ap.play("MoveAlongPathLoop")
		ANIMATION_TYPE.BOUNCE:
			ap.play("MoveAlongPathBounce")
