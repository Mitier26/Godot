extends Node3D

# 적의 씬을 취득한다.
const enemy = preload("res://enemy.tscn")
# 적을 생성할 위치
@onready var points = self.get_children()
# 적을 생성하는 간격
@export var interval = 10

func _ready():
	var timer = Timer.new()
	timer.set_wait_time(interval)
	timer.set_one_shot(false)
	timer.connect("timeout", self.generate)
	add_child(timer)
	timer.start()
	
func generate():
	# position3D에서 적의 초기위치를 무작위로 선택
	var random = RandomNumberGenerator.new()
	random.randomize()
	var i = random.randi_range(0, points.size() -1)
	# 적을 생성한다
	var new_enemy = enemy.instantiate()
	new_enemy.position = points[i].position
	get_node("/root").add_child(new_enemy)
