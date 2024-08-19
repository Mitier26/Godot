extends Indicator
class_name MovingIndicator
 
@export var cursor_texture : Texture2D
var cursor_reference = null
 
 
func update(source, mouse_position, delta):
	if indicator_reference != null:
		point(indicator_reference, mouse_position, delta)
	if cursor_reference != null:
		spawn_point = cursor_reference.global_position
		point(cursor_reference, source.global_position, delta)
 
 
	if cursor_reference != null:
		var length = (mouse_position - source.position).length()
		length = min(length, 150)
		#length = clamp(length,100,150)
		cursor_reference.global_position = source.position + length *(mouse_position - source.position).normalized()
 
 
func point(object, target, _delta):
	object.look_at(target)
 
 
func set_reference(source):
	if indicator_reference != null:
		return
 
	var sprite_reference = Sprite2D.new()
	sprite_reference.texture = texture
	indicator_reference = sprite_reference
	source.add_child(sprite_reference)
 
	var cursor = Sprite2D.new()
	cursor.texture = cursor_texture
	cursor_reference = cursor
	source.add_child(cursor)
 
	activated = true
 
func reset():
	if indicator_reference != null:
		indicator_reference.free()
	if cursor_reference != null:
		cursor_reference.free()
 
	activated = false
 
