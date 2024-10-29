extends RigidBody2D

# 상태 머신
enum {INIT, ALIVE, INVULNERABLE, DEAD}
var state = INIT

# 우주선의 가속도
@export var engine_power = 500
# 우주선의 회전 속도
@export var spin_power = 8000

# 엔진에 가하는 힘
var thrust = Vector2.ZERO
# 우주선의 방향
var rotation_dir = 0

var screensize = Vector2.ZERO

# 사격
@export var bullet_scene : PackedScene
@export var fire_rate = 0.25
var can_shot = true
@onready var gun_cooldown = $GunCooldown
@onready var muzzle = $Muzzle

@onready var collision_shape_2d = $CollisionShape2D

func _ready():
	# 보이는 화면의 크기를 가지고 온다
	screensize = get_viewport_rect().size
	gun_cooldown.wait_time = fire_rate
	change_state(ALIVE)
	
func change_state(new_state):
	
	match new_state:
		INIT:
			collision_shape_2d.set_deferred("disabled", true)
		ALIVE:
			collision_shape_2d.set_deferred("disabled", false)
		INVULNERABLE:
			collision_shape_2d.set_deferred("disabled", true)
		DEAD:
			collision_shape_2d.set_deferred("disabled", true)
	
	state = new_state

func _process(delta):
	get_input()

func get_input():
	# 주기적으로 힘이 없는 상태로 시작
	thrust = Vector2.ZERO
	# 현재 상태가 DEAD 또는 INIT 이면
	if state in [DEAD, INIT]:
		return
	if Input.is_action_pressed("thrust"):
		thrust = transform.x * engine_power
	rotation_dir = Input.get_axis("rotate_left","rotate_right")
	
	if Input.is_action_pressed("shoot") and can_shot:
		shoot()

func _physics_process(delta):
	# 앞으로 이동
	constant_force = thrust
	# 회전
	constant_torque = rotation_dir * spin_power
	# constant_force는 RigidBody2D 의 기본 기능
	
	if position.x > screensize.x :
		position.x = 0
	if position.x < 0:
		position.x = screensize.x
	if position.y > screensize.y:
		position.y = 0
	if position.y < 0:
		position.y = screensize.y
	
func _integrate_forces(physice_state):
	var xform = physice_state.transform
	xform.origin.x = wrapf(xform.origin.x, 0, screensize.x)
	xform.origin.y = wrapf(xform.origin.y, 0, screensize.y)
	physice_state.transform = xform
	

func shoot():
	if state == INVULNERABLE:
		return
	can_shot = false
	gun_cooldown.start()
	var b = bullet_scene.instantiate()
	get_tree().root.add_child(b)
	b.start(muzzle.global_transform)

func _on_gun_cooldown_timeout():
	can_shot = true
