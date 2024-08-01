extends Timer

class_name SpawnTimer

@export var min_time = 5
@export var max_time = 10

func _ready():
	setup_timer()
	
func setup_timer():
	var random_time = randi_range(min_time, max_time)
	self.wait_time = random_time
	self.stop()
	self.start()

