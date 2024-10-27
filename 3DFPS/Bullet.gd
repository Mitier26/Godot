extends RigidBody3D

# 총탄을 날려 보내는 힘
var power = 2000

#@onready var hit_enemy_audio = $HitEnemyAudio
#@onready var hit_obstacle_audio = $HitObstacleAudio
@onready var hit_enemy_audio = get_node("/root/Node3D/HitEnemyAudio")
@onready var hit_obstacle_audio = get_node("/root/Node3D/HitObstacleAudio")


func _ready():
	# 중력의 영향을 비활성화
	self.gravity_scale = 0
	# 충돌감지 활성화
	self.contact_monitor = true
	self.max_contacts_reported = 1
	
	# 총알이 남지 않게 0.5초 후 삭제
	var timer = Timer.new()
	self.add_child(timer)
	timer.connect("timeout", self.queue_free)
	timer.set_wait_time(0.5)
	timer.start()
	
	# 힘을 가해 총알 발사
	add_constant_central_force(power * global_transform.basis.z)
	
func _on_Bullet_body_entered(body):
	if body.name == "Player":
		return
	
	for g in body.get_groups():
		if g == "enemy":
			body.hp -= 1
			hit_enemy_audio.play()
			break
		else :
			hit_obstacle_audio.play()
			break
			
	self.queue_free()
