extends Node2D

# 클래스 이름을 'Invader_spawner'로 설정하여 다른 스크립트에서 이 클래스를 사용할 수 있게 함
class_name Invader_spawner

signal invader_destroyed(points : int)
signal game_won
signal game_lost

# 외계인 배치의 행 수와 열 수를 정의
const ROWS = 5
const COLUMNS = 11

# 외계인 간의 가로 및 세로 간격을 정의
const HORIZONTAL_SPACING = 32
const VERTICAL_SPACING = 32

# 외계인의 높이와 초기 Y 위치를 정의
const INVADER_HEIGHT = 24
const START_Y_POSITION = -50

# 외계인이 이동할 때 X 및 Y 위치의 증분 값
const INVADER_POSITION_X_INCREMENT = 10
const INVADER_POSITION_Y_INCREMENT = 20

# 외계인의 이동 방향. 1은 오른쪽, -1은 왼쪽을 의미
var movement_direction = 1

# 외계인를 파괴한 수
var invader_destroyed_count = 0
# 총 외계인의 수
var invader_total_count = ROWS * COLUMNS

# 타이머 노드 참조를 위한 변수 선언
@onready var movement_timer = $MovementTimer
@onready var shoot_timer = $ShootTimer

# 외계인과 외계인 탄환의 장면을 미리 로드
var invader_scene = preload("res://Scenes/invader.tscn")
var invader_shot_scene = preload("res://Scenes/invader_shot.tscn")

# 노드가 준비될 때 호출되는 함수
func _ready():
	# 타이머 신호에 move_invasers 함수 연결
	movement_timer.timeout.connect(move_invasers)
	# 타이머 신호에 on_invader_shoot 함수 연결
	shoot_timer.timeout.connect(on_invader_shoot)
	
	# 외계인 각 타입에 대한 리소스를 미리 로드
	var invader_1_res = preload("res://Resources/invader_1.tres")
	var invader_2_res = preload("res://Resources/invader_2.tres")
	var invader_3_res = preload("res://Resources/invader_3.tres")
	
	var invader_config
	
	# 행(row)의 수만큼 외계인 생성
	for row in ROWS:
		# 첫 번째 행은 invader_1_res를 사용
		if row == 0:
			invader_config = invader_1_res
		# 두 번째와 세 번째 행은 invader_2_res를 사용
		elif row == 1 or row == 2:
			invader_config = invader_2_res
		# 네 번째와 다섯 번째 행은 invader_3_res를 사용
		elif row == 3 or row == 4:
			invader_config = invader_3_res
		
		# 각 행의 가로 길이 계산
		var row_width = (COLUMNS * invader_config.width * 3) + ((COLUMNS - 1) * HORIZONTAL_SPACING)
		# 시작 X 위치를 계산하여 외계인들이 중앙에 정렬되도록 함
		var start_x = (position.x - row_width) / 2
		
		# 열(column)의 수만큼 외계인 생성
		for col in COLUMNS:
			# 각 외계인의 X 및 Y 위치 계산
			var x = start_x + (col * invader_config.width * 3) + (col * HORIZONTAL_SPACING)
			var y = START_Y_POSITION + (row * INVADER_HEIGHT) + (row * VERTICAL_SPACING)
			var spawn_position = Vector2(x, y)
			
			# 외계인을 생성하고 배치하는 함수 호출
			spawn_invader(invader_config, spawn_position)
			
# 외계인을 생성하고 설정하는 함수
func spawn_invader(invader_config, spawn_position: Vector2):
	# invader_scene에서 새로운 외계인 인스턴스를 생성
	var invader = invader_scene.instantiate() as Invader
	# 생성된 외계인에 대한 설정값을 적용
	invader.config = invader_config
	# 외계인의 위치를 지정
	invader.global_position = spawn_position
	# 외계인을 생성할 때 시그널을 연결한다.
	invader.invader_destroyed.connect(on_invader_destroyed)
	# 생성된 외계인을 이 노드의 자식으로 추가
	add_child(invader)
	
# 외계인들이 이동하는 함수
func move_invasers():
	# 외계인들이 현재 이동 방향에 따라 X 축으로 이동
	position.x += INVADER_POSITION_X_INCREMENT * movement_direction

# 외계인이 발사하는 함수
func on_invader_shoot():
	# 자식 노드들 중 Invader 클래스의 인스턴스만 필터링하고 그 위치를 리스트로 만듦
	var random_child_position = get_children().filter(func (child): return child is Invader).map(func (invader) : return invader.global_position).pick_random()
	
	# invader_shot_scene에서 새로운 탄환 인스턴스를 생성
	var invader_shot = invader_shot_scene.instantiate() as InvaderShot
	# 탄환의 위치를 랜덤하게 선택된 외계인의 위치로 설정
	invader_shot.global_position = random_child_position
	# 생성된 탄환을 씬의 루트에 추가하여 게임에 등장시킴
	get_tree().root.add_child(invader_shot)

# 외계인이 왼쪽 벽에 도달했을 때 호출되는 함수
func _on_left_wall_area_entered(area):
	# 왼쪽으로 이동 중일 때만 아래로 이동하고 방향을 반대로 바꿈
	if movement_direction == -1:
		position.y += INVADER_POSITION_Y_INCREMENT
		movement_direction *= -1

# 외계인이 오른쪽 벽에 도달했을 때 호출되는 함수
func _on_right_wall_area_entered(area):
	# 오른쪽으로 이동 중일 때만 아래로 이동하고 방향을 반대로 바꿈
	if movement_direction == 1:
		position.y += INVADER_POSITION_Y_INCREMENT
		movement_direction *= -1

func on_invader_destroyed(points: int):
	invader_destroyed.emit(points)
	invader_destroyed_count += 1
	
	if invader_destroyed_count > invader_total_count:
		game_won.emit()
		shoot_timer.stop()
		movement_timer.stop()


func _on_bottom_wall_area_entered(area):
	game_lost.emit()
	movement_timer.stop()
	movement_direction = 0
