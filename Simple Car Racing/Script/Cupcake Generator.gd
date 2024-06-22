extends Node

var cupcake = preload("res://scene/Cupcake.tscn")

func _on_timer_timeout():
	var instance = cupcake.instantiate()
	instance.position = Vector2(380 +randi() % 270, 0)
	add_child(instance)
