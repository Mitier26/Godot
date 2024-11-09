extends Node3D

enum {AIM, SET_POWER, SHOOT, WIN}

@export var power_speed = 100
@export var angle_speed = 1.1

var angle_change = 1
var power = 0
var power_change = 1
var shots = 0
var state = AIM

# 호 그리기
var hole_dir

# 마우스 겨냥
@export var mouse_sensitivity = 150

# 다음 홀
@export var next_hole : PackedScene

func _ready():
	$Arrow.hide()
	$Ball.position = $Tee.position
	# 마우스 포획
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	change_state(AIM)
	$UI.show_message("Get Ready!")
	
func change_state(new_state):
	state = new_state
	match state:
		AIM:
			$Arrow.position = $Ball.position
			$Arrow.show()
			set_start_angle()
		SET_POWER:
			power = 0
		SHOOT:
			$Arrow.hide()
			$Ball.shoot($Arrow.rotation.y, power / 15)
			shots += 1
			$UI.update_shots(shots)
		WIN:
			$Ball.hide()
			$Arrow.hide()
			$UI.show_message("Win!")
			await get_tree().create_timer(1).timeout
			if next_hole:
				get_tree().change_scene_to_packed(next_hole)
			
func _input(event):
	# 화면을 클릭하면 다시 마우스 포획모드가 된다.
	if event.is_action_pressed("click"):
		if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			return
		match state:
			AIM:
				change_state(SET_POWER)
			SET_POWER:
				change_state(SHOOT)
	if event is InputEventMouseMotion:
		if state == AIM:
			$Arrow.rotation.y -= event.relative.x / mouse_sensitivity
	# 마우스 포획을 풀기, 메뉴 사용시 필요
	if event.is_action_pressed("ui_cancel") and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _process(delta):
	# 마우스가 보이면 에니메이션을 출력하지 않는다.
	if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
		return
		
	if state != WIN:
		$CameraGimbal.position = $Ball.position
	
	match state:
		AIM:
			animate_arrow(delta)
		SET_POWER:
			animate_power(delta)
		SHOOT:
			pass

func animate_arrow(delta):
	$Arrow.rotation.y += angle_speed * angle_change * delta
	# 기본
	#if $Arrow.rotation.y > PI / 2:
		#angle_change = -1
	#if $Arrow.rotation.y < -PI / 2:
		#angle_change = 1
	# 호
	if $Arrow.rotation.y > hole_dir + PI / 2:
		angle_change = -1
	if $Arrow.rotation.y < hole_dir - PI / 2:
		angle_change = 1

func animate_power(delta):
	power += power_speed * power_change * delta
	if power >= 100:
		power_change = -1
	if power <= 0:
		power_change = 1
	$UI.update_power_bar(power)


# 겨냥 호 그리기
func set_start_angle():
	var hole_position = Vector2($Hole.position.z, $Hole.position.x)
	var ball_position = Vector2($Ball.position.z, $Ball.position.x)
	hole_dir = (ball_position - hole_position).angle()
	$Arrow.rotation.y = hole_dir

func _on_hole_body_entered(body):
	if body.name == "Ball":
		print("Win")
		change_state(WIN)


func _on_ball_stopped():
	if state == SHOOT:
		change_state(AIM)
