extends Area2D

@onready var animatedSprite = $AnimatedSprite2D

var active = true

func _on_body_entered(body):
	if not body is Player: return
	if not active: return
	active = false
	animatedSprite.play("Checked")
	Events.emit_signal("hit_checkpoint", global_position)
