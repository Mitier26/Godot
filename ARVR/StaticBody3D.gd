extends StaticBody3D

@onready var sphere = $CSGSphere3D
@onready var mat = StandardMaterial3D.new()

var h = 0.0
var change = false

func _ready():
	# 초기 색상을 흰색
	mat.albedo_color = Color(1,1,1,1)
	sphere.material = mat
	
func _process(delta):
	# change 가 true 이면 색 변경
	if change :
		h += 0.01
	
	if h > 1.0:
		h = 0
		
	# 색을 HSB(색상, 채도, 명도)로 지정,
	mat.albedo_color = Color.from_hsv(h, 0.8, 0.9, 1)
	
func change_color():
	change != change
