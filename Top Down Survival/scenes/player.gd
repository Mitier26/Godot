extends CharacterBody2D

signal shoot

# 플레이어의 속도
const START_SPEED : int = 200
const BOOST_SPEED : int = 400
var speed : int
# 화면의 크기
var screen_size : Vector2

const NORMAL_SHOT : float = 0.5
const FAST_SHOT : float = 0.1
var can_shoot : bool

func _ready():
	# 보이는 화면의 크기를 가지고 온다.
	screen_size = get_viewport_rect().size
	reset()

func reset():
	# 화면의 중암에 배치 한다.
	position = screen_size /2
	# 속도를 지정한다.
	speed = START_SPEED
	$ShootTimer.wait_time = NORMAL_SHOT
	can_shoot = true

func get_input():
	# 입력을 받는데 한 번에 받을 수 있다.
	# 입력에 관한 신호는 프로젝트 세팅 > 입력맵에서 설정한다.
	var input_dir = Input.get_vector("left", "right", "up", "down")
	# velocity는 캐릭터바디에서 제공하는 것이다.
	# 지금 오즈젝트의 속도!!
	velocity = input_dir.normalized() * speed
	# 이것은 물리프로세스에서 작동되는 것 

	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and can_shoot:
		var dir = get_global_mouse_position() - position
		shoot.emit(position, dir)
		can_shoot = false
		$ShootTimer.start()

func _physics_process(_delta):
	get_input()
	move_and_slide()
	
	# 플레이어의 최대 이동 범위를 지정한다.
	# 벡터2로 한 번에 범위를 지정할 수 있다
	position = position.clamp(Vector2.ZERO, screen_size)
	
	# 마우스의 위치를 받는다.
	var mouse = get_local_mouse_position()
	# 마우스의 위치에 따라 8 방향으로 바라보는 것이다.
	# 이 것은 쉽게 알 수 있는 것이 아니다.
	# 이것에 관한 문서는
	# https://kidscancode.org/godot_recipes/4.x/2d/8_direction/
	var angle = snappedf(mouse.angle(), PI / 4) / (PI / 4)
	angle = wrapf(int(angle), 0, 8)
	
	$AnimatedSprite2D.animation = "walk" + str(angle)
	
	if velocity.length() != 0:
		$AnimatedSprite2D.play()
	else :
		$AnimatedSprite2D.stop()
		$AnimatedSprite2D.frame = 1


func boost():
	$BoostTimer.start()
	speed = BOOST_SPEED

func quick_fire():
	$FastFireTimer.start()
	$ShootTimer.wait_time = FAST_SHOT

func _on_shoot_timer_timeout():
	can_shoot = true


func _on_boost_timer_timeout():
	speed = START_SPEED


func _on_fast_fire_timer_timeout():
	$ShootTimer.wait_time = NORMAL_SHOT
