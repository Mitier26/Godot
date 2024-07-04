extends Node

# 적을 생성해도 화면에 보이기 위해서는 main에 적을 추가해야 한다.
@onready var main = get_node("/root/Main")

signal hit_p

# 고블린 씬을 가지고 온다.
# 유니티의 프리팹 같은 것, 유니티는 오브젝트 인데 고도는 씬이다.
var goblin_scene := preload("res://scenes/goblin.tscn")
# 소환 지점을 저장하기 위한 배열
var spawn_points := []

func _ready():
	# 게임이 실행되면 자식의 수만큼 반복한다.
	for i in get_children():
		# 반복하는 것이 마커이면
		if i  is Marker2D:
			# 배열에 추가한다.
			# 배열에 추가하는 것과, 메인에 추가하는 것을 잘 구분하자.
			spawn_points.append(i)
			

# 타이머의 노드 이벤트
# 타이머를 만들고 노드를 선택하면 time_out 이라는 것이 있다.
func _on_timer_timeout():
	var enemies = get_tree().get_nodes_in_group("enemies")
	if enemies.size() < get_parent().max_enemies:
		# 마커 중 하나를 선택해 위치를 지정한다.
		var spawn = spawn_points[randi() % spawn_points.size()]
		# 고블린 오브젝트를 생성한다.
		var goblin = goblin_scene.instantiate()
		# 고블린의 위치를 지정한다.
		goblin.position = spawn.position
		# 화면에 보이기 위해 매인의 자식으로 추가한다.
		goblin.hit_player.connect(hit)
		main.add_child(goblin)
		goblin.add_to_group("enemies")
	

func hit():
	hit_p.emit()
