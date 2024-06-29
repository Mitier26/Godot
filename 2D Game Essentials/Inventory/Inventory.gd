extends Control

@export var character : CharacterBody2D

var max_items
var items = []

var has_inventory = false

func _ready() -> void:
	max_items = $Panel/GridContainer.get_child_count()
	if has_variable(character, "inventory"):
		character.inventory = self
		has_inventory = true
		print("The node has the variable: " + "inventory")
	else:
		has_inventory = false
		print("The node does not have the variable: " + "inventory")
	
	update_inventory()
	

func has_variable(node, var_name):
	if node != null:
		node.get(var_name)
		return true
	else:
		return false

func add_item(item):
	if items.size() < max_items:
		items.append(item)
		print("inventory added")
		update_inventory()

func use_item(item):
	print("aaaaa")
	if item in items:
		if item.item_name == "potion":
			character.heal(30)
		if item.item_name == "sword":
			character.add_score(25)
			character.take_damage(15)
		remove_item(item)

func remove_item(item):
	if item in items:
		items.erase(item)
		update_inventory()

func update_inventory():
	for i in range($Panel/GridContainer.get_child_count()):
		var slot = $Panel/GridContainer.get_child(i)
		
		if i < items.size():
			slot.text = items[i].item_name
			slot.icon = load(items[i].icon)
			slot.disabled = false
		else:
			slot.text = ""
			slot.icon = null
			slot.disabled = true

func _process(delta):
	pass
