extends Node

@export var rock_scene : PackedScene

var screensize = Vector2.ZERO
@onready var rock_path = $RockPath
@onready var rock_spawn = $RockPath/RockSpawn

func _ready():
	screensize = get_viewport().get_visible_rect().size
	for i in 3:
		spawn_rock(3)
		
func spawn_rock(size, pos=null, vel=null):
	if pos == null:
		rock_spawn.progress = randi()
		pos = rock_spawn.position
	if vel == null:
		vel = Vector2.RIGHT.rotated(randf_range(0, TAU)) * randf_range(50, 125)
	
	var r = rock_scene.instantiate()
	r.screensize = screensize
	r.start(pos, vel, size)
	call_deferred("add_child", r)
	# r = 바위
	# 바위에는 exploded 라는 signal이 있다.
	# 하지만 바위에서 메인에 연결할 수 없다.
	# 처음 시작하면 바위는 없기 때문이다.
	# 그래서 바위를 생성할 때 signal을 연결해 주어야한다.
	r.exploded.connect(self._on_rock_exploded)
	# 바위의 exploded 신호에 자신에 있는 _on_rock_exploded를 연결한다.
	# 바위가 총알에 맞아 신호를 내면 main에 있는 것이 실행된다.

func _on_rock_exploded(size, radius, pos, vel):
	if size <= 1:
		return
	for offset in [-1, 1]:
		var dir = $Player.position.direction_to(pos).orthogonal() * offset
		var newpos = pos + dir * radius
		var newvel = dir * vel.length() * 1.1
		spawn_rock(size -1, newpos, newvel)
