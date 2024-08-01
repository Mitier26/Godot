extends Node2D

# 클래스 이름을 'Invader_spawner'로 설정하여 다른 스크립트에서 이 클래스를 사용할 수 있게 함
class_name Invader_spawner

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

# 외계인 장면을 미리 로드
var invader_scene = preload("res://Scenes/invader.tscn")

# 노드가 준비될 때 호출되는 함수
func _ready():
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
	var invader = invader_scene.instantiate() as Invader
	invader.config = invader_config
	invader.global_position = spawn_position
	add_child(invader)
