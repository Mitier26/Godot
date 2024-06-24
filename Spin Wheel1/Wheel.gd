extends Sprite2D

var dragging = false
var previous_mouse_position = Vector2.ZERO
var current_angle = 0
var spin_velocity = 0
var friction = 0.98

# Called when the node enters the scene tree for the first time.
func _ready():
	self.centered = true


func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				if self.get_rect().has_point(self.to_local(event.position)):
					dragging = true
					previous_mouse_position = event.position
					spin_velocity = 0
			else:
				dragging = false
	elif event is InputEventMouseMotion:
		if dragging:
			var delta = event.position - previous_mouse_position
			var angle_delta = delta.length() / (event.position - self.global_position).length()
			current_angle += angle_delta * sign(delta.cross(Vector2.UP))
			spin_velocity = delta.length() * 1
			previous_mouse_position = event.position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if dragging:
		self.rotation = current_angle
	else:
		if spin_velocity != 0:
			current_angle += spin_velocity * delta
			spin_velocity *= friction
			if abs(spin_velocity) < 0.01:
				spin_velocity = 0
			self.rotation = current_angle
