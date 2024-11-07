extends CharacterBody2D

signal life_change
signal died

# 이동용
@export var gravity = 750
@export var run_speed = 150
@export var jump_speed = -300

# 이중점프
@export var max_jumps = 2
@export var double_jump_factor = 1.5

var jump_count = 0

# 사다리
@export var climb_speed = 50

var is_on_ladder = false

# 상태
enum {IDLE, RUN, JUMP, HURT, CLIMB, DEAD}
var state = IDLE

# 체력
var life = 3: set = set_life

# 세터: life값을 변경하려면 아래 함수를 이용해야 한다.
func set_life(value):
	life = value
	life_change.emit(life)

func _ready():
	change_state(IDLE)

func change_state(new_state):
	state = new_state
	match state:
		IDLE:
			$AnimationPlayer.play("idle")
		RUN:
			$AnimationPlayer.play("run")
		HURT:
			$AnimationPlayer.play("hurt")
			# 위로 날리고
			velocity.y = -200
			# 진행 방향의 반대로 날림
			velocity.x = -100 * sign(velocity.x)
			life -= 1
			# 0.5초 기다리고 IDLE 상태로 변경
			await get_tree().create_timer(0.5).timeout
			change_state(IDLE)
			if life <= 0:
				change_state(DEAD)
		JUMP:
			$AnimationPlayer.play("jump_up")
			jump_count = 1
		CLIMB:
			$AnimationPlayer.play("climb")
		DEAD:
			hide()

func _physics_process(delta):
	if state != CLIMB:
		velocity.y += gravity * delta
	get_input()
	
	move_and_slide()
	
	if state == HURT:
		return
		
	# 점프 재설정
	if state == JUMP and is_on_floor():
		change_state(IDLE)
		jump_count = 0
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider().is_in_group("danger"):
			hurt()
		if collision.get_collider().is_in_group("enemies"):
			if position.y < collision.get_collider().position.y:
				collision.get_collider().take_damage()
				velocity.y = -200
			else:
				hurt()

func get_input():
	# 상처 입으면 이동할 수 없다.
	if state == HURT:
		return
	var right = Input.is_action_pressed("right")
	var left = Input.is_action_pressed("left")
	var jump = Input.is_action_just_pressed("jump")
	var up = Input.is_action_pressed("up")
	var down = Input.is_action_pressed("down")
	
	# 모든 상태에서 일어나는 행동
	velocity.x = 0
	if right : 
		velocity.x += run_speed
		$Sprite2D.flip_h = false
	if left : 
		velocity.x -= run_speed
		$Sprite2D.flip_h = true
	
	# 이중 점프
	if jump and state == JUMP and jump_count < max_jumps and jump_count > 0:
		$AnimationPlayer.play("jump_up")
		velocity.y = jump_speed / double_jump_factor
		jump_count += 1
		
	# 땅에 있을 때만 점프 가능
	if jump and is_on_floor():
		change_state(JUMP)
		velocity.y = jump_speed
	# IDLE 에서 움직이면 RUN으로 변화
	if state == IDLE and velocity.x != 0:
		change_state(RUN)
	# RUN일때 가만히 있으면
	if state == RUN and velocity.x == 0:
		change_state(IDLE)
	# 공중에 있으면 JUMP로 변화
	if state in [IDLE, RUN] and !is_on_floor():
		change_state(JUMP)
	# 착지
	if state == JUMP and is_on_floor():
		change_state(IDLE)
		$Dust.emitting = true
	
	# 사다리
	if up and state != CLIMB and is_on_ladder:
		change_state(CLIMB)
	if state == CLIMB:
		if up:
			velocity.y = -climb_speed
			$AnimationPlayer.play("climb")
		elif down :
			velocity.y = climb_speed
			$AnimationPlayer.play("climb")
		else:
			velocity.y = 0
			$AnimationPlayer.stop()
	if state == CLIMB and not is_on_ladder:
		change_state(IDLE)
	
	# 떨어짐
	if state == JUMP and velocity.y > 0:
			$AnimationPlayer.play("jump_down")
			
# 초기화 함
func reset(_position):
	position = _position
	show()
	change_state(IDLE)

# 상처 입는 것
func hurt():
	if state != HURT:
		change_state(HURT)
