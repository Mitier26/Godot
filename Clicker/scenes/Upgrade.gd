extends Button

@export var lvl : String = "1"

signal level(lvl)


func _on_button_up():
	level.emit(lvl)
	disabled = true
