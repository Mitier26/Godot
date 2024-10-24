extends CharacterBody2D

# 걷기 속도
@export var WALK_SPEED = 250
# 자식 노드의 AnimationSprite2D
@onready var sprite = $AnimatedSprite2D
# 이동 방향을 (0, 0)으로 초기화
@onready var direction = Vector2(0, 0);
# 중력과 점프력
@export var GRAVITY = 15
@export var JUMP_POWER = 450

# 지면과 접촉 판정에 사용하는 RayCast2D
@onready var raycast2d = $RayCast2D

# HP
@onready var hp = 100

func _ready():
	# 다른 객체보다 앞에 표시한다.
	self.z_index = 20
	
func _physics_process(delta):
	
	if Input.is_action_pressed("ui_right"):
		# 오른쪽 방향 화살표 키가 눌렀을 때 
		direction.x = WALK_SPEED
		sprite.flip_h = false
		sprite.play("walk")
	elif Input.is_action_pressed("ui_left"):
		direction.x = -WALK_SPEED
		sprite.flip_h = false
		sprite.play("walk")
	else:
		direction.x = 0
		sprite.play("idle")
		
	# 중력을 적용
	direction.y += GRAVITY
	if raycast2d.is_colliding():
		direction.y = 0
		if Input.is_action_pressed("ui_up"):
			direction.y = -JUMP_POWER
	
	self.velocity = direction
	self.move_and_slide()
	
func hp_up(point):
	print("HP recovery : + ", point)
	hp += point
	if hp > 100:
		hp = 100

func gameover():
	print("Game Over")

func hp_down(point):
	print("HP decrease : -", point)
	hp -= point
	if hp < 0:
		gameover()
