extends CharacterBody3D

# 플레이어 충돌
signal dead

# 플레이어 연로 점수
signal score_changed
signal fuel_changed

# 비행기 회전
@export var pitch_speed = 1.1
@export var roll_speed = 2.5
@export var level_speed = 4.0

var roll_input = 0
var pitch_input = 0

# 비행기 속도
@export var forward_speed = 25

var max_alittude = 20

# 점수와 연로 변수
@export var fuel_burn = 1.0
var max_fuel = 10.0
var fuel = 10.0:
	set = set_fuel
var score = 0:
	set = set_score

func get_input(delta):
	# 비행기 회전 입력
	pitch_input = Input.get_axis("pitch_up", "pitch_down")
	roll_input = Input.get_axis("roll_left", "roll_right")
	
	# 비행기 고도 제한
	if position.y >= max_alittude and pitch_input > 0:
		position.y = max_alittude
		pitch_input = 0

func _physics_process(delta):
	# 자동으로 연료 감소
	fuel -= fuel_burn * delta
	
	get_input(delta)
	# 보간
	# var interpolated_value = lerpf(current_value, target_value, weight)
	# 천천히 회전하게 한다.
	rotation.x = lerpf(rotation.x, pitch_input, pitch_speed * delta)
	# 회전을 45도로 제한한다.
	rotation.x = clamp(rotation.x, deg_to_rad(-45), deg_to_rad(45))
	
	# 위와 회전하는 대상이 다르다는 것을 알아야 한다.
	# 메인 몸통이 히전하면 두 개의 각도가 변해 처음 각도로 돌아 가는 것이 힘들다.
	$cartoon_plane.rotation.z = lerpf($cartoon_plane.rotation.z, roll_input, roll_speed * delta)
	
	velocity = -transform.basis.z * forward_speed
	velocity += transform.basis.x * $cartoon_plane.rotation.z / deg_to_rad(45) * forward_speed / 2.0
	
	move_and_slide()
	
	if get_slide_collision_count() > 0:
		die()

func set_fuel(value):
	fuel= min(value, max_fuel)
	fuel_changed.emit(fuel)
	if fuel < 0:
		die()

func set_score(value):
	score = value
	score_changed.emit(score)

func die():
	set_physics_process(false)
	$cartoon_plane.hide()
	$Explosion.show()
	$Explosion.play("default")
	await $Explosion.animation_finished
	$Explosion.hide()
	dead.emit()
	#get_tree().reload_current_scene()
	#if score > Global.high_score:
		#Global.high_score = score
		#Global.save_score()
