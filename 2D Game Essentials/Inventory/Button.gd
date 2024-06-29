extends Button

@export var index := 0

@onready var inventory = $"../../.."

func _on_pressed() -> void:
	inventory.use_item(inventory.items[index])
