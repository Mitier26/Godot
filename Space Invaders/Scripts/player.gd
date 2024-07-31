extends Area2D

@export var speed = 200
var direction = Vector2.ZERO

@onready var collision_rect = $CollisionShape2D

func _process(delta):
	var input = Input.get_axis("move_left","move_right")
	
	if input > 0:
		direction = Vector2.RIGHT
	elif input < 0 :
		direction = Vector2.LEFT
	else:
		direction =  Vector2.ZERO
		
	var delta_movement = direction * speed * delta
	
	position.x += delta_movement.x
	
