extends CharacterBody2D

@export var speed = 50
@export var gravity = 900

var facing = 1

func _physics_process(delta):
	velocity.y += gravity * delta
	velocity.x = facing * speed
	$Sprite2D.flip_h = velocity.x > 0
	
	move_and_slide()
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider().name == "Player":
			collision.get_collider().hurt
		# 이동하는 방향의 법선벡터에 무엇인가 있다면 방향을 바꾼다.
		if collision.get_normal().x != 0:
			facing = sign(collision.get_normal().x)
			velocity.y = -100
		
		if position.y > 1000:
			queue_free()
			
func take_damage():
	$AnimationPlayer.play("death")
	$CollisionShape2D.set_deferred("disabled", true)
	set_physics_process(false)

# AnimationPlayer의 시그널을 연결한다.
# 에니메이션이 종료되면 실행
func _on_animation_player_animation_finished(anim_name):
	if anim_name == "death":
		queue_free()
