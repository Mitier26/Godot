extends CharacterBody2D

@onready var main = get_node("/root/Main")
# 플레이어의 위치를 알기 위해 플레이어를 가지고 온다.
@onready var player = get_node("/root/Main/Player")

# 아이템 씬을 가지고 온다.
var item_scene := preload("res://scenes/item.tscn")
# 폭발 이펙트
var explosion_scene := preload("res://scenes/explosion.tscn")

# 시그널!!!
# 이벤트 같은 것
signal hit_player

var alive : bool
var entered : bool			# 필드에 들어 왔는지 확인
var speed : int = 100		# 속도
var direction : Vector2		# 이동 방향
const DROP_CHANCE : float = 0.1

func _ready():
	# 보이는 화면의 상자를 가지고 온다.
	var screen_rect = get_viewport_rect()
	alive = true
	entered = false
	# 이동 방향을 구하기 위해 화면의 중앙에서 자신의 위치를 뺏다.
	var dist = screen_rect.get_center() - position
	
	# 좌우에서 등장하는지 위아래에서 등장하는지 확인한다.
	if abs(dist.x) > abs(dist.y):
		direction.x = dist.x
		direction.y = 0
	else :
		direction.x = 0
		direction.y = dist.y
		
func _physics_process(_delta):
	if alive:
		# run 애니메이션을 실행한다.
		$AnimatedSprite2D.animation = "run"
		# 화면에 들어 오면 플레이어를 추격한다.
		if entered:
			direction = (player.position - position)
		# 대각선 이동 속도를 일정하게 하기 위해 필요
		direction = direction.normalized()
		velocity = direction * speed
		move_and_slide()
		
		# 그림의 좌우를 변경하기 위해서다.
		if velocity.x != 0:
			$AnimatedSprite2D.flip_h = velocity.x < 0
	else:
		pass
		
func die():
	alive = false
	$AnimatedSprite2D.stop()
	$AnimatedSprite2D.animation = "dead"
	$Area2D/CollisionShape2D.set_deferred("disabled", true)
	
	if randf() < DROP_CHANCE:
		drop_item()
	var explosion = explosion_scene.instantiate()
	explosion.position = position
	main.add_child(explosion)
	# 여기에서는 call_deferred를 사용하지 않는다.
	# 폭발이펙트가 아무 동작을 하지 않기 때문이다.
	
	# 폭발이펙트가 게임이 멈추어도 작동되게 한다.
	explosion.process_mode = Node.PROCESS_MODE_ALWAYS
	
	
# 죽었을 때 아이템을 떨어뜨리는 함수
func drop_item():
	var item = item_scene.instantiate()
	item.position = position
	
	item.item_type = randi_range(0, 2)
	
	# call_deffered 가 무엇이냐
	# 동기화를 위한 것이다.
	# 지연이 있을 때 완료 되었을 경우 실행 되게 하는 것
	# main.add_child 도 있지만 main이 다른 곳에 있기 때문에
	# 이것을 사용한다.
	main.call_deferred("add_child", item)
	# 폭발 이펙트와 아이템의 차이는 
	# 아이템은 만들어 질 때 item 내부에서 스크립트가 동작한다.
	# 아이템의 타입에 따라 그림을 변경해주는 동작이다.
	# 이 동작을 기다려야한다.
	item.add_to_group("items")
	
	
	
func _on_entrance_timer_timeout():
	entered = true


func _on_area_2d_body_entered(_body):
	hit_player.emit()
