extends Area2D

# 이 함수는 다른 Area2D 노드가 이 노드의 충돌 영역에 들어왔을 때 호출됩니다.
func _on_area_entered(area):
	# 충돌한 area(다른 Area2D 노드)를 삭제합니다.
	area.queue_free()
