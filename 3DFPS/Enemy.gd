extends RigidBody3D

# 적 의 이동 속도
const SPEED = 0.5

# 저의 이동 경로를 지정
var path = []

#이동 경로의 재계산 간격을 세기 위한 변수
var count = 0

@onready var map = get_world_3d().get_navigation_map()
#@onready var player = $"../Player"
@onready var player = get_node("/root/Node3D/Player")

# 적의 체력
@export var hp = 10

# 쓰러뜨린 적의 수를 표시하는 라벨
@onready var killed_label = get_node("/root/Node3D/KilledLabel")

func _ready():
	# 불필요한 회전 억제
	self.gravity_scale = 0
	self.axis_lock_linear_x = true
	self.axis_lock_linear_y = true
	self.axis_lock_linear_z = true
	self.axis_lock_angular_x = true
	self.axis_lock_angular_y = true
	self.axis_lock_angular_z = true
	# 다른 객체와의 충돌 감지를 동시 3개까지 활성화
	self.contact_monitor = true
	self.max_contacts_reported = 3
	# 플레이어까지의 이동 경로를 취득
	path = NavigationServer3D.map_get_path(map, self.position, player.position, true)
	
func _process(delta):
	if self.hp <= 0:
		killed_label.killed += 1
		self.queue_free()
	
func _physics_process(delta):
	count += 1
	if count > 5:
		path = NavigationServer3D.map_get_path(map, self.position, player.position, true)
		count = 0
	
	if path.size() > 0:
		var step_size = delta * SPEED
		var destination = path[0]
		var direction = destination - self.position
		
		# 이동량보다 목적지가 가까우면 목적지에 도착한 것으로 판정
		if step_size > direction.length():
			path.remove_at(0)
			return
	
		# 이동 방향을 향해 이동한다.
		self.look_at(self.position - direction)
		self.position += direction.normalized() * step_size
			
	


func _on_enemy_body_entered(body):
	if body.name == "Player":
		body.hp -= 10
