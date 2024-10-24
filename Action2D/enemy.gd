extends CharacterBody2D

@export var HP_DAMAGE = 1
@export var speed_scale = 1.0
@onready var HP = 100

func _ready():
	self.z_index=2
	
	var anim = get_node("CollisionShape2D/Enemy/AnimationPlayer")
	anim.set_current_animation("move")
	anim.set_speed_scale(speed_scale)
	
func _physics_process(delta):
	# move_and_collide : 다른 노드와 충돌을 감
	var collision = move_and_collide(Vector2(0, 0))
	if collision && collision.get_collider().name =="Player":
		collision.get_collider().hp_down(HP_DAMAGE)

func damaged(point):
	HP -= point
	if HP < 0:
		self.queue_free()
