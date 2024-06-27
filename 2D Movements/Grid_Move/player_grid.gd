extends CharacterBody2D


@export var speed := 300
@export var grid_size = 64
var target_position = Vector2.ZERO
var moving = false

func _ready():
	target_position = position
	
func _physics_process(delta):
	if not moving:
		var direction = Vector2.ZERO
		
		if Input.is_action_just_pressed('ui_right'):
			direction = Vector2.RIGHT
		elif Input.is_action_just_pressed('ui_left'):
			direction = Vector2.LEFT
		elif Input.is_action_just_pressed('ui_down'):
			direction = Vector2.DOWN
		elif Input.is_action_just_pressed('ui_up'):
			direction = Vector2.UP
		
		if direction != Vector2.ZERO:
			target_position += direction * grid_size
			moving = true

	if moving:
		
		position = position.move_toward(target_position, speed * delta)
		
		if position.distance_to(target_position) < speed * delta:
			position = target_position
			moving = false
