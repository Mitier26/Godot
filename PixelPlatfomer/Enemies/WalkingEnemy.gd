extends CharacterBody2D

var direction = Vector2.RIGHT

@onready var ledge_check_right = $LedgeCheckRight
@onready var ledge_check_2_left = $LedgeCheck2Left
@onready var animated_sprite_2d = $AnimatedSprite2D



func _physics_process(delta):
	
	animated_sprite_2d.play("Walking")
	var found_wall = is_on_wall()
	var found_ledge = not ledge_check_right.is_colliding() or not ledge_check_2_left.is_colliding()
	
	if found_wall or found_ledge:
		direction *= -1
	
	animated_sprite_2d.flip_h = direction.x > 0
	
	velocity = direction * 25
	move_and_slide()
