extends ParallaxBackground

@onready var space_layer = %SpaceLayer
@onready var far_stars_layer = %FarStarsLayer
@onready var close_starts_layer = %CloseStartsLayer

func _process(delta):
	space_layer.motion_offset.y += 2 * delta
	far_stars_layer.motion_offset.y += 5 * delta
	close_starts_layer.motion_offset.y += 20 * delta
