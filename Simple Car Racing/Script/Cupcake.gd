extends Area2D

const scrollSpeed = 200

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.y += scrollSpeed * delta


func _on_body_entered(body):
	if body.name == "Car":
		Global.score += 10
		self.queue_free()
