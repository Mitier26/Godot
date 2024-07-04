extends Area2D

@onready var main = get_node("/root/Main")
@onready var lives_label = get_node("/root/Main/HUD/LivesLabel")

# 0: 커피 , 1 : 체력, 2 : 총
var item_type : int

var coffee_box = preload("res://assets/items/coffee_box.png")
var health_box = preload("res://assets/items/health_box.png")
var gun_box = preload("res://assets/items/gun_box.png")

var textures = [coffee_box, health_box, gun_box]

func _ready():
	$Sprite2D.texture = textures[item_type]



func _on_body_entered(body):
	# 커피
	if item_type == 0:
		body.boost()
	elif item_type == 1:
		main.lives += 1
		lives_label.text = "X " + str(main.lives)
		# 이렇게 하지 않고 main에 함수를 만들어 하면 어떻게 될까?
	elif item_type == 2:
		body.quick_fire()
	queue_free()
