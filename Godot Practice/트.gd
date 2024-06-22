extends 자동차클래스

var 인스턴스 = 자동차클래스.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	print("최고속도:", 최고속도)
	print("색상", 색상)
	시동걸기()
	시동끄기()
	인스턴스.시동걸기()
	print(인스턴스.최고속도)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func 시동걸기():
	print("턱털털")
