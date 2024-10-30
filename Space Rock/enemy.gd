extends Area2D

# 적이 발사할 총알
@export var bullet_scene : PackedScene
# 적의 이동 속도
@export var speed = 150
# 적의 회전 속도
@export var rotation_speed = 120
# 적의 체력
@export var health = 3

# 적이 따라갈 경로에 있을 판
var follow = PathFollow2D.new()
# 판에 있는 progress의 진행도 = 경로 위치

# 적이 공겨할 대상
var target = null
# 총알의 속도
@export var bullet_spread = 0.2

func _ready():
	# 적의 그림을 정한다 그림 3개였다
	$Sprite2D.frame = randi() % 3
	# 적의 경로를 정한다.
	var path = $EnemyPaths.get_children()[randi() % $EnemyPaths.get_child_count()]
	# 경로의 자식으로 판을 추가한다.
	path.add_child(follow)
	follow.loop = false

func _process(delta):
	rotation += deg_to_rad(rotation_speed) * speed
	# 경로에서의 이동 속도
	follow.progress += speed * delta
	
	position = follow.global_position
	# progress는 길이를 알아야 하지만 progress_ratio느 0 ~ 1 까지 이다
	if follow.progress_ratio >= 1:
		# 경로의 끝에 가면 사라진다.
		queue_free()

# 타이머가 끝나면 총알을 발사
func _on_gun_cooldown_timeout():
	#shoot()
	shoot_pulse(3, 0.15)

# 총알을 발사하는 함수
func shoot():
	# 자신의 위치에서 목표의 방향, target는 main에서 적을 생성할 때 입력
	var dir = global_position.direction_to(target.global_position)
	# 방향에서 0.2씩 랜덤으로 각도를 조절
	dir = dir.rotated(randf_range(-bullet_spread, bullet_spread))
	var b = bullet_scene.instantiate()
	get_tree().root.add_child(b)
	b.start(global_position, dir)
	$ShootSound.play()
	
func shoot_pulse(n, delay):
	for i in n:
		shoot()
		await get_tree().create_timer(delay).timeout
		
func take_damage(amount):
	health -= amount
	$AnimationPlayer.play("flash")
	if health <= 0:
		exploed()
		
func exploed():
	$ExplosionSound.play()
	speed = 0
	$GunCooldown.stop()
	$CollisionShape2D.set_deferred("disabled", true)
	$Sprite2D.hide()
	$Explosion.show()
	$Explosion/AnimationPlayer.play("explosion")
	await $Explosion/AnimationPlayer.animation_finished
	queue_free()


func _on_body_entered(body):
	if body.is_in_group("rocks"):
		return
	exploed()
	body.shield -= 50
