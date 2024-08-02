extends Area2D

class_name Player

# 플레이어 파괴되었을 때 보낼 신호
signal player_destroy

# 이동 속도 변수
@export var speed := 200
# 이동 방향을 나타내는 벡터
var direction := Vector2.ZERO

# 충돌 영역 노드를 저장하는 변수
@onready var collision_rect := $CollisionShape2D
@onready var animation_player = $AnimationPlayer

# 충돌 박스의 가로 크기와 화면 경계 값들을 저장할 변수
var bounding_size_x := 0.0
var start_bound := 0.0
var end_bound := 0.0

func _ready():
	# 충돌 박스의 실제 가로 크기 계산
	# transform.get_scale().x는 충돌 박스의 스케일을 고려하여 실제 크기를 계산함
	bounding_size_x = collision_rect.shape.get_rect().size.x * transform.get_scale().x
	
	# 현재 뷰포트의 화면 영역과 카메라 위치 계산
	# get_visible_rect()는 현재 뷰포트의 크기를 반환
	# get_camera_2d()는 현재 카메라를 가져옴
	var viewport_rect = get_viewport().get_visible_rect()
	var camera = get_viewport().get_camera_2d()
	
	# 카메라 중심을 기준으로 시작과 끝 경계를 설정
	# start_bound는 화면의 왼쪽 경계를 나타내고,
	# end_bound는 화면의 오른쪽 경계를 나타냄
	start_bound = camera.position.x - viewport_rect.size.x / 2
	end_bound = camera.position.x + viewport_rect.size.x / 2

func _physics_process(delta):
	# 입력에 따른 방향 설정
	# "ui_left"와 "ui_right"는 입력 액션 이름으로,
	# Input.get_axis()는 두 입력 간의 값을 반환하여 방향을 결정함
	var input = Input.get_axis("move_left", "move_right")
	direction = Vector2(input, 0)

	# 이동 거리 계산
	# 속도, 방향, delta(프레임 간 시간)를 사용하여 이동 거리를 계산함
	var delta_movement = direction.x * speed * delta

	# 이동 가능 범위 확인
	# 플레이어가 화면의 경계를 넘어가지 않도록 체크함
	# start_bound와 end_bound는 각각 왼쪽과 오른쪽 경계를 의미하며,
	# bounding_size_x / 2를 빼고 더하여 충돌 박스의 절반 크기를 고려
	if (position.x + delta_movement - bounding_size_x / 2 < start_bound or 
		position.x + delta_movement + bounding_size_x / 2 > end_bound):
		return
	
	# 이동 가능 범위 내에서 플레이어의 위치 업데이트
	position.x += delta_movement

func on_player_destroyed():
	speed = 0
	animation_player.play("destroy")

# 플레이어 에니메이션이 종료될 때 실행 되는 함수
func _on_animation_player_animation_finished(anim_name):
	# 종료되는 에니메이션이 destroy면
	if anim_name == 'destroy':
		# 1초되에 아래 줄을 실행한다.
		await get_tree().create_timer(1).timeout
		# 사용자 정의 시그널
		# 플레이어가 파괴되었다는 신호를 보낸다.
		player_destroy.emit()
		queue_free()
