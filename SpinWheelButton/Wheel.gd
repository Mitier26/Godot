extends Sprite2D

var spinning = false
var spin_velocity = 0
var friction = 0.98


# Called when the node enters the scene tree for the first time.
func _ready():
	self.centered = true
	
	var button_node = $"../Button"
	#button_node.connect("pressed", Callable(self,"on_button_pressed"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if spinning:
		if spin_velocity != 0:
			var current_angle = self.rotation
			current_angle += spin_velocity * delta
			spin_velocity *= friction
			if abs(spin_velocity) < 0.01:
				spin_velocity = 0;
				spinning = false
			self.rotation = current_angle

func on_button_pressed():
	spin_velocity = randf_range(200, 500)
	spinning = true


func _on_button_button_down():
	spin_velocity = randf_range(200, 500)
	spinning = true
