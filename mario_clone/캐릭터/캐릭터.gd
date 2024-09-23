extends CharacterBody2D

@onready var animated_sprite_2d = $AnimatedSprite2D
@export var 중력가속도 = 500
@export var 점프속도 = -300
@export var 이동속도 = 200

func _physics_process(delta):
	# 캐릭터가 바닥에 있지 않은 경우에만 중력 적용
	if is_on_floor() == false:
		velocity.y += delta * 중력가속도
	
	# 캐릭터가 바닥에 있고, 점프 버튼을 눌렀을 때
	if is_on_floor() == true && Input.is_action_just_pressed("점프"):
		velocity.y = 점프속도
	
	# 좌, 우 이동
	if Input.is_action_pressed("좌"):
		velocity.x -= delta * 이동속도
		animated_sprite_2d.flip_h = true
	if Input.is_action_pressed("우"):
		velocity.x += delta * 이동속도
		animated_sprite_2d.flip_h = false
	
	if Input.is_action_pressed("좌") == false && Input.is_action_pressed("우") == false || Input.is_action_pressed("좌") == true && Input.is_action_pressed("우") == true:
		velocity.x = 0
		
	# 애니메이션
	# 캐릭터가 바닥에 있지 않을 때
	if is_on_floor() == false:
		if velocity.y > 0:
			animated_sprite_2d.play("점프")
		elif velocity.y < 0:
			animated_sprite_2d.play('추락')
	# 캐릭터가 바닥에 있을 때
	else:
		# 숨쉬거나 바로 달리기
		if velocity.x == 0:
			animated_sprite_2d.play("숨쉬기")
		else:
			animated_sprite_2d.play("달리기")
	move_and_slide()
