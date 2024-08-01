extends Node2D

# 레이저 장면을 저장하는 변수. 에디터에서 설정할 수 있도록 @export 속성 부여
@export var laser_scene: PackedScene

# 플레이어가 레이저를 발사할 수 있는지 여부를 나타내는 변수
var can_player_shoot = true

# 입력 이벤트를 처리하는 함수
func _input(event):
	# "shoot" 액션이 눌리고 플레이어가 레이저를 발사할 수 있는 상태일 때
	if Input.is_action_just_pressed("shoot") && can_player_shoot:
		# 한 번 발사하면 연속 발사를 막기 위해 false로 설정
		can_player_shoot = false
		
		# 레이저 장면을 인스턴스화하여 레이저 객체 생성
		var laser = laser_scene.instantiate() as Laser
		
		# 레이저의 위치를 현재 위치(ShootOrigkn)에서 약간 위로 설정
		laser.global_position = get_parent().global_position - Vector2(0,20)
		
		# 레이저 객체를 씬 트리의 루트 노드 아래 "main" 노드에 추가
		# 이것이 있어야 화면에 보임
		get_tree().root.get_node("main").add_child(laser)
		
		# 레이저가 씬 트리에서 제거될 때 on_laser_destroyed 함수를 호출하도록 연결
		laser.tree_exited.connect(on_laser_destroyed)
		
# 레이저가 파괴되었을 때 호출되는 함수
func on_laser_destroyed():
	# 레이저를 다시 발사할 수 있도록 설정
	can_player_shoot = true
