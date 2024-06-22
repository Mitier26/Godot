extends CharacterBody2D

const moveSpeed = 400

func _physics_process(delta):
	
	if Input.is_action_pressed("Up"):
		velocity.y = -moveSpeed
	if Input.is_action_pressed("Down"):
		velocity.y = moveSpeed
	if Input.is_action_pressed("Left"):
		velocity.x = -moveSpeed
	if Input.is_action_pressed("Right"):
		velocity.x = moveSpeed
	
	if Input.is_action_just_released("Up"):
		velocity.y = 0
	if Input.is_action_just_released("Down"):
		velocity.y = 0
	if Input.is_action_just_released("Left"):
		velocity.x = 0
	if Input.is_action_just_released("Right"):
		velocity.x = 0
	
	if position.x < 380:
		position.x= 380
	if position.x > 650:
		position.x = 650
	if position.y < 33:
		position.y = 33
	if position.y > 990:
		position.y = 990
	
	move_and_slide()
