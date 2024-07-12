class_name MoveInputComponent
extends Node

@export var move_stats : MoveStats
@export var move_component: MoveComponent

func _input(event):
	# 좌우 입력을 받는다.
	var input_axis = Input.get_axis("ui_left", "ui_right")
	# 벡터를 새로 만들어 좌우 입력만 게산 하도록 한다.
	move_component.velocity = Vector2(input_axis * move_stats.speed, 0)
