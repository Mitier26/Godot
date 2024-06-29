extends Button

@onready var item = $Item
@onready var player = $"../Player"



func _on_pressed():
	player.inventory.add_item(item)
