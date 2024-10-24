extends Area2D

# 아이템을 취득 했을 때 회복량
@export var HP_RECOVERY = 10

func _ready():
	self.z_index = 1
	
func player_hp_up(body):
	if body.name == "Player":
		body.hp_up(HP_RECOVERY)
		self.queue_free()
