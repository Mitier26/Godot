extends Area2D

# 클래스 이름을 'Laser'로 설정하여 다른 스크립트에서 이 클래스를 사용할 수 있게 함
class_name Laser

# 레이저의 이동 속도를 저장하는 변수. 에디터에서 설정할 수 있도록 @export 속성 부여
@export var speed := 300

# 매 프레임마다 호출되는 함수로, 물리 연산과 관련된 처리를 수행
func _physics_process(delta):
	# 레이저를 위쪽으로 이동시킴
	# speed와 delta(프레임 간의 시간 간격)를 곱하여 프레임 독립적인 움직임을 구현
	position.y -= speed * delta
