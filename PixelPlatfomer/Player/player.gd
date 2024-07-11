extends CharacterBody2D

class_name Player

enum { MOVE, CLIMB }

# 뒤에 as 를 써줌으로 자동완성이 가능해 졌다
# preload 가 없으면 as 는 작동하지 않는다.
@export var moveData : Resource = preload("res://Player/DefaultPlayerMovementData.tres") as PlayerMovementData

@onready var animatedSprite = $AnimatedSprite2D
@onready var ladderCheck = $LadderCheck
@onready var jumpBufferTimer = $JumpBufferTimer
@onready var coyoteJumpTimer = $CoyoteJumpTimer
@onready var audio_stream_player = $AudioStreamPlayer
@onready var remoteTransform2d = $RemoteTransform2D

var state = MOVE
var jump_count = 1
var bufferd_jump = false
var coyote_jump = false
var on_door = false

func _ready():
	animatedSprite.sprite_frames = preload("res://Player/playerGreenSkin.tres")

func powerup():
	moveData = load("res://scenes/FastPlayerMovementData.tres")

func _physics_process(delta):
	
	var input = Vector2.ZERO
	#input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input.x = Input.get_axis("ui_left","ui_right")
	input.y = Input.get_axis("ui_up", "ui_down")
	
	match state:
		MOVE: 
			move_state(input, delta)
		CLIMB: 
			climb_state(input, delta)
		
	

# 일반적인 이동
func move_state(input, delta):
	
	# 사다리에 있으면 상태를 사다리 상태로 변경한다.
	if is_on_ladder() and Input.is_action_pressed("ui_up"):
		state = CLIMB
		
	apply_gravity(delta)
	
	if not horizontal_move(input):
		apply_friction(delta)
	else:
		apply_acceleration(input.x, delta)

	if is_on_floor():
		reset_jump()
	else:
		animatedSprite.play("Jump")

	if can_jump():
		input_jump()
	else :
		# 소 점프
		input_jump_release()
		# 더플 점프
		input_double_jump()
		# 버퍼 점프
		buffer_jump()
		# 빠른 낙하
		fast_fall(delta)
			
	var was_on_air = not is_on_floor()
	var was_on_floor = is_on_floor()

	move_and_slide()

	if is_on_floor() and was_on_air:
		animatedSprite.animation = "Run"
		animatedSprite.frame = 1
	
	var just_left_round = not is_on_floor() and was_on_floor
	if just_left_round and velocity.y >= 0:
		coyote_jump = true
		coyoteJumpTimer.start()
	
func climb_state(input, delta):
	if not is_on_ladder():
		state = MOVE
	if input.length() != 0:
		animatedSprite.animation = "Run"
	else:
		animatedSprite.animation = "Idle"
		
	velocity = input * moveData.CLIMB_SPEED
	
	move_and_slide()

func input_jump_release():
	if Input.is_action_just_released("ui_up") and velocity.y < -70:
			velocity.y = moveData.JUMP_RELEASE_FORCE
	
func input_double_jump():
	if Input.is_action_just_pressed("ui_up") and jump_count > 0:
		SoundPlayer.play_sound(SoundPlayer.JUMP)
		velocity.y = moveData.JUMP_FORCE
		jump_count -= 1

func buffer_jump():
	if Input.is_action_just_pressed("ui_up"):
			bufferd_jump = true
			jumpBufferTimer.start()

func fast_fall(delta):
	if velocity.y > 10:
			velocity.y += moveData.ADDITIONAL_FALL_GRAVITY * delta

func player_die():
	SoundPlayer.play_sound(SoundPlayer.HURT)
	queue_free()
	#get_tree().reload_current_scene()
	Events.emit_signal("player_died")

func connect_camera(camera):
	var camera_path = camera.get_path()
	remoteTransform2d.remote_path = camera_path

func horizontal_move(input):
	return input.x != 0

func can_jump():
	return is_on_floor() or coyote_jump

func input_jump():
	if on_door: return
	if Input.is_action_just_pressed("ui_up") or bufferd_jump:
		SoundPlayer.play_sound(SoundPlayer.JUMP)
		velocity.y = moveData.JUMP_FORCE
		bufferd_jump = false

func reset_jump():
	jump_count = moveData.JUMP_COUNT

func is_on_ladder():
	if not ladderCheck.is_colliding():
		return false
	var collider = ladderCheck.get_collider()
	if not collider is Ladder:
		return false
	return true

func apply_gravity(delta):
	velocity.y += moveData.GRAVITY * delta
	velocity.y = min(velocity.y, 300)

func apply_friction(delta):
	velocity.x = move_toward(velocity.x, 0, moveData.FRICTION * delta)
	animatedSprite.play("Idle")
	
func apply_acceleration(amount, delta):
	velocity.x = move_toward(velocity.x, moveData.MAX_SPEED * amount, moveData.ACCELERATION * delta)
	animatedSprite.play("Run")
	if amount > 0:
		animatedSprite.flip_h = true
	elif amount < 0:
		animatedSprite.flip_h = false

func _on_jump_buffer_timer_timeout():
	bufferd_jump = false

func _on_coyote_jump_timer_timeout():
	coyote_jump = false
