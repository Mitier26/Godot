extends ParallaxBackground

const scrollSpeed = 200

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	scroll_offset.y += scrollSpeed * delta
