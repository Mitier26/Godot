extends CharacterBody2D


var theta: float = 0.0

# 0 ~ 360 도 까지!!!
@export_range(0, 2 * PI) var alpha : float = 0.0

@export var bullet_node : PackedScene

var bullet_type : int = 0

func get_vactor(angle):
	theta = angle + alpha
	# 각도로 벡터를 구하는 법
	return Vector2(cos(theta), sin(theta))


func shoot(angle):
	var bullet = bullet_node.instantiate()
	
	bullet.position = global_position
	bullet.direction = get_vactor(angle)
	bullet.set_property(bullet_type)
	
	get_tree().current_scene.call_deferred("add_child", bullet)

func _on_speed_timeout():
	shoot(theta)
