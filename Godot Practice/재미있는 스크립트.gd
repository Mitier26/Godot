class_name 자동차클래스
extends Node

enum {AAA,BBB,CCC}
enum named {IDLE=12, RUN, JUMP}
var a = 1
const b = 3
var arr = ["a", "b", "c"]

var 최고속도 = 30
var 색상 = "파랑"

func 시동걸기():
	print("부릉")
	
func 시동끄기():
	print("꺼진다")

func 함수이름(input):
	print(input)
	print("한다")
	
func 다른함수() -> String:
	return "뭐냐?"

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Hello world")
	함수이름("이것")
	if false:
		pass
	elif a > b:
		print(a)
	else:
		print("알수 없음")
		
	match b:
		10:
			print("10이다")
		20:
			print("20이다")
		_:
			print("만족하지 않음")
	
	for 십부터십삼 in range(10,14):
		print(십부터십삼)
	
	for 숫자하나씩 in [1,2,3,4,5]:
		print(숫자하나씩)
	
	for 문자분해 in "Hello 문자 분해":
		if(문자분해 == "문"):
			continue
		print(문자분해)
		
	var 남은기름 = 10
	var 이동거리 = 0
	
	while 남은기름 > 0:
		이동거리 = 이동거리 + 1
		남은기름 = 남은기름 - 1
		print(남은기름)
		
		if(남은기름 < 3):
			break
	
	print("이동거리",이동거리);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
