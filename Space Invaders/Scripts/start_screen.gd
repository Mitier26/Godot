extends CanvasLayer

# 변화가 있어야 하는 것을 변수로 받아 왔다.
# 고유이름으로 액세스를 하면 코드가 더 간결해진다.
# 단 이름이 같으면 안된다.
@onready var invader_1_texture = %Invader1Texture
@onready var invader_1_label = %Invader1Label
@onready var invader_2_texture = %Invader2Texture
@onready var invader_2_label = %Invader2Label
@onready var invader_3_texture = %Invader3Texture
@onready var invader_3_label = %Invader3Label

# 화며에 표시되는 노드의 부모는 Control 이다.
# 위에 있는 것을 담기 위한 배열
var control_array = []

@onready var timer = $Timer

func _ready():
	# 배열에 화면에 표시될 것을 추가한다.
	control_array = [invader_1_texture, invader_1_label, invader_2_texture, invader_2_label, invader_3_texture, invader_3_label]
	
	# 배열의 각 요소에 접근!
	for control in control_array:
		# visible를 이용해 요소들을 숨긴다.
		#(control as Control).visible = false
		# visible과 modulate의 차이!!
		# visible은 false로 하면 공간도 사라진다.
		# 그래서 아래있는 버튼은 위로 올라 가게된다.
		# 반면 modulate는 색을 투명하게 하는 것이여서
		# 공간을 차지하고 있다.
		(control as Control).modulate = Color.TRANSPARENT

func _on_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/main.tscn")


func _show_next_control():
	
	if control_array.size() > 0:
		var control = control_array.pop_front() as Control
		#control.visible = true
		control.modulate = Color.WHITE
	else:
		# 타이머를 종료하고 삭제한다.
		timer.stop()
		timer.queue_free()
