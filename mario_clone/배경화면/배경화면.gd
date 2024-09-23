extends ParallaxBackground

@export var 배경이미지:CompressedTexture2D
@onready var sprite_2d = $ParallaxLayer/Sprite2D
@export var 스크롤속도X = 10
@export var 스크롤속도Y = 10


# Called when the node enters the scene tree for the first time.
func _ready():
	sprite_2d.texture = 배경이미지


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#sprite_2d.region_rect.position.x += delta * 스크롤속도X
	#sprite_2d.region_rect.position.y += delta * 스크롤속도Y
	
	sprite_2d.region_rect.position += delta * Vector2(스크롤속도X, 스크롤속도Y)
	
	if sprite_2d.region_rect.position.x >= 1024 || sprite_2d.region_rect.position.y >= 1024 || sprite_2d.region_rect.position.x <= -1024 || sprite_2d.region_rect.position.y <= -1024:
		sprite_2d.region_rect.position = Vector2.ZERO
