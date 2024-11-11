extends Node3D

var chunk = preload("res://chunk.tscn")

var title_screen = "res://title_screen.tscn"

var num_chunk = 1
var chunk_size = 200
var max_position = -100

func _process(delta):
	# 비행기가 한 구역 끝으로 가면
	if $Plane.position.z < max_position:
		num_chunk += 1
		# 새로운 청크를 만든다
		var new_chunk = chunk.instantiate()
		# 청크의 위치를 정한다.
		new_chunk.position.z = max_position - chunk_size / 2
		new_chunk.level = num_chunk / 4
		add_child(new_chunk)
		max_position -= chunk_size


func _on_plane_dead():
	get_tree().change_scene_to_file(title_screen)
