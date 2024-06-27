extends CharacterBody2D

@export var speed : = 200

var target := Vector2.ZERO

func _ready():
	target = global_position
	
func _input(event):
	
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		target = event.position

func _physics_process(delta):
	velocity = position.direction_to(target) * speed
	
	if position.distance_to(target) > 10:
		move_and_slide()
