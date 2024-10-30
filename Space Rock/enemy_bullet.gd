extends Area2D

@export var speed = 1000
@export var damage = 15

# 적의 총알은 발사하는 방향이 있다. Player를 향해 발사
func start(_pos, _dir):
	position = _pos
	rotation = _dir.angle()
	
func _process(delta):
	position += transform.x * speed * delta
	
func _on_body_entered(body):
	if body.name == "Player":
		body.shield -= damage
	queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
