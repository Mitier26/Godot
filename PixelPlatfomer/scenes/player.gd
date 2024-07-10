extends CharacterBody2D

class_name Player

enum { MOVE, CLIMB }

@export var moveData : Resource

@onready var animatedSprite = $AnimatedSprite2D
@onready var ladderCheck = $LadderCheck

var state = MOVE


func _ready():
	animatedSprite.sprite_frames = preload("res://scenes/playerGreenSkin.tres")

func powerup():
	moveData = load("res://scenes/FastPlayerMovementData.tres")

func _physics_process(delta):
	
	var input = Vector2.ZERO
	#input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input.x = Input.get_axis("ui_left","ui_right")
	input.y = Input.get_axis("ui_up", "ui_down")
	
	match state:
		MOVE: 
			move_state(input)
		CLIMB: 
			climb_state(input)
		
	

# 일반적인 이동
func move_state(input):
	
	# 사다리에 있으면 상태를 사다리 상태로 변경한다.
	if is_on_ladder() and input.y < 0:
		state = CLIMB
	
	apply_gravity()
	
	if input.x == 0:
		apply_friction()
	else:
		apply_acceleration(input.x)

	if is_on_floor():
		if Input.is_action_pressed("ui_up"):
			velocity.y = moveData.JUMP_FORCE
	else :
		animatedSprite.play("Jump")
		if Input.is_action_just_released("ui_up") and velocity.y < -70:
			velocity.y = moveData.JUMP_RELEASE_FORCE
			
		if velocity.y > 10:
			velocity.y += moveData.ADDITIONAL_FALL_GRAVITY
			
	var was_on_air = not is_on_floor()

	move_and_slide()

	if is_on_floor() and was_on_air:
		animatedSprite.animation = "Run"
		animatedSprite.frame = 1
	
func climb_state(input):
	if not is_on_ladder():
		state = MOVE
	if input.length() != 0:
		animatedSprite.animation = "Run"
	else:
		animatedSprite.animation = "Idle"
		
	velocity = input * 50
	
	move_and_slide()

func is_on_ladder():
	if not ladderCheck.is_colliding():
		return false
	var collider = ladderCheck.get_collider()
	if not collider is Ladder:
		return false
	return true
	

func apply_gravity():
	velocity.y += moveData.GRAVITY
	velocity.y = min(velocity.y, 300)

func apply_friction():
	velocity.x = move_toward(velocity.x, 0, moveData.FRICTION)
	animatedSprite.play("Idle")
	
func apply_acceleration(amount):
	velocity.x = move_toward(velocity.x, moveData.MAX_SPEED * amount, moveData.ACCELERATION)
	animatedSprite.play("Run")
	if amount > 0:
		animatedSprite.flip_h = true
	elif amount < 0:
		animatedSprite.flip_h = false
