extends Area2D

@onready var animation_player = $AnimationPlayer

var direction : Vector2 = Vector2.RIGHT
var speed : float = 300

func _physics_process(delta):
	position += direction * speed * delta
	rotation = direction.angle()

func play(animation_name):
	animation_player.play(animation_name)

func _on_screen_exited():
	queue_free()


func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(0)
