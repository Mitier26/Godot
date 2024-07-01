extends CharacterBody2D

const GRAVITY : int = 1000	# 중력 속도
const MAX_VEL : int = 600	# 떨어지는 최대 속도
const FLAP_SPEED : int = -500	# 점프 속도 -가 위
var flying : bool = false	# 날고 있니?
var falling : bool = false	# 떨어지고 있니?
const START_POS = Vector2(100, 400) # 시작 위치


# 화면이 시작되면 시작되는 함수
func _ready():
	# 초기화
	reset()

# 초기화 함수, 게임 다시 하기에 사용, 재사용을 위해 함수화
func reset():
	falling = false
	flying = false
	position = START_POS
	set_rotation(0)

# 매 프레임 마다 실행되는 함수
func _physics_process(delta):
	# 새가 날거나 떨어질 때
	if flying or falling:
		# 새는 지속적으로 중력의 영향을 받는다.
		velocity.y += GRAVITY * delta
		
		# 새의 속도가 중력의 영향으로 계속 증가하는데
		# 속도가 일정 속도 이상 되지 않게 한다.
		if velocity.y > MAX_VEL:
			velocity.y = MAX_VEL
		
		# 애니메이션과 각도 조절을 위한 것 
		if flying:
			# 속도에 따라 각도를 변경하게 한다.
			# 날 때는 속도가 - 된다
			set_rotation(deg_to_rad(velocity.y * 0.05))
			$AnimatedSprite2D.play()
		elif falling:
			set_rotation(PI/2)
			# 날아가는 것 같은 동작을 멈춘다.
			$AnimatedSprite2D.stop()
		
		move_and_collide(velocity * delta)
	else:
		$AnimatedSprite2D.stop()

# 점프
func flap():
	velocity.y = FLAP_SPEED
