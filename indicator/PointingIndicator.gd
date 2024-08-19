extends Indicator

class_name PointingIndicator

func update(source, mouse_position, delta):
	spawn_point = source.global_position
	direction = (mouse_position - spawn_point).normalized()

	if indicator_reference != null:
		point(mouse_position, delta)

func point(terget, _delta):
	indicator_reference.look_at(terget)

func set_reference(source):
	if indicator_reference != null:
		return
	
	var sprite_reference = Sprite2D.new()
	sprite_reference.texture = texture
	indicator_reference = sprite_reference
	source.add_child(sprite_reference);

	activated = true
	
func reset():
	if indicator_reference != null:
		indicator_reference.free()
		
	activated = false
