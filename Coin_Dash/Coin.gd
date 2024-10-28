extends Area2D

var screensize = Vector2.ZERO

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var collision_shape = $CollisionShape2D
@onready var timer = $Timer

func _ready():
	timer.start(randf_range(0, 1))

func pickup():
	collision_shape.set_deferred("disabled", true)
	var tw = create_tween().set_parallel().set_trans(Tween.TRANS_QUAD)
	tw.tween_property(self, "scale", scale * 3, 0.3)
	tw.tween_property(self, "modulate:a", 0.0, 0.3)
	await tw.finished
	queue_free()


func _on_timer_timeout():
	animated_sprite_2d.frame = 0
	animated_sprite_2d.play()


func _on_area_entered(area):
	if area.is_in_group("obstacles"):
		position = Vector2(randi_range(0, screensize.x), randi_range(0, screensize.y))
