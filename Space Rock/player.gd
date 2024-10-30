extends RigidBody2D

signal lives_changed
signal dead
signal shield_changed

var reset_pos = false
var lives = 0 : set = set_lives

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

# 실드관련
@export var max_shield = 100.0
@export var shield_regen = 5.0

var shield = 0 : set = set_shield

func set_shield(value):
	value = min(value, max_shield)
	shield = value
	shield_changed.emit(shield / max_shield)
	if shield <= 0:
		lives -= 1
		explode()
	

func _ready():
	# 보이는 화면의 크기를 가지고 온다
	screensize = get_viewport_rect().size
	gun_cooldown.wait_time = fire_rate
	change_state(ALIVE)
	
func change_state(new_state):
	
	match new_state:
		INIT:
			collision_shape_2d.set_deferred("disabled", true)
			$Sprite2D.modulate.a = 0.5
		ALIVE:
			collision_shape_2d.set_deferred("disabled", false)
			$Sprite2D.modulate.a = 1.0
		INVULNERABLE:
			collision_shape_2d.set_deferred("disabled", true)
			$Sprite2D.modulate.a = 0.5
			$InvulnerabilityTimer.start()
		DEAD:
			collision_shape_2d.set_deferred("disabled", true)
			$Sprite2D.hide()
			linear_velocity = Vector2.ZERO
			$EngineSound.stop()
			dead.emit()
	
	state = new_state

func _process(delta):
	shield += shield_regen * delta
	get_input()

func get_input():
	# 주기적으로 힘이 없는 상태로 시작
	thrust = Vector2.ZERO
	# 현재 상태가 DEAD 또는 INIT 이면
	if state in [DEAD, INIT]:
		return
	if Input.is_action_pressed("thrust"):
		thrust = transform.x * engine_power
		# 매 프레임마다 실행 되면 이상하다.
		if not $EngineSound.playing:
			$EngineSound.play()
	else:
		$EngineSound.stop()
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
	
	if reset_pos:
		physice_state.transform.origin = screensize /2
		reset_pos = false
	

func shoot():
	if state == INVULNERABLE:
		return
	can_shot = false
	gun_cooldown.start()
	var b = bullet_scene.instantiate()
	get_tree().root.add_child(b)
	b.start(muzzle.global_transform)
	$LaserSound.play()

func _on_gun_cooldown_timeout():
	can_shot = true

func set_lives(value):
	lives = value
	lives_changed.emit(lives)
	if lives <= 0:
		change_state(DEAD)
	else:
		change_state(INVULNERABLE)
	shield = max_shield


func reset():
	reset_pos = true
	$Sprite2D.show()
	lives = 3
	change_state(ALIVE)

# 시간 2초가 지나면 무적을 해제하고 ALIVE 상태가 된다.
func _on_invulnerability_timer_timeout():
	change_state(ALIVE)


func _on_body_entered(body):
	if body.is_in_group("rocks"):
		shield -= body.size * 25
		body.explode()
		#lives -= 1
		#explode()

func explode():
	# 보이지 않던 Explosion을 보이게 한다.
	$Explosion.show()
	# Explosion의 에니메이션을 출력한다.
	$Explosion/AnimationPlayer.play("explosion")
	# animation이 끝나길 기다린다
	await $Explosion/AnimationPlayer.animation_finished
	# animation이 끝나면 숨김다.
	$Explosion.hide()
