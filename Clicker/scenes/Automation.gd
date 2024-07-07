extends Button

@onready var timer = %Timer


func _on_pressed():
	timer.start()
	disabled = true
