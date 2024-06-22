extends Node

const opponent = preload("res://scene/opponent.tscn")

func _on_timer_timeout():
	var instance = opponent.instantiate()
	instance.position = Vector2(380 +randi() % 270, 0)
	add_child(instance)
