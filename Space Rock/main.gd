extends Node

@export var rock_scene : PackedScene
@export var enemy_scene : PackedScene

var screensize = Vector2.ZERO
@onready var rock_path = $RockPath
@onready var rock_spawn = $RockPath/RockSpawn

# UI
var level = 0
var score = 0
var playing = false

func _ready():
	screensize = get_viewport().get_visible_rect().size
	for i in 3:
		spawn_rock(3)
		
func _process(delta):
	if not playing:
		return
	if get_tree().get_nodes_in_group("rocks").size() == 0:
		new_level()

# 입력이 있을 때 실행 되는 함수
func _input(event):
	# 입력이 pause ( p ) 일 경우
	if event.is_action_pressed("pause"):
		# 게임 실행 중이 아니면 작동 하지 않는다.
		if not playing:
			return
		# 일시 정지면 해제, 일시 정지가 아니면 일시 정지한다.
		get_tree().paused = not get_tree().paused
		var message = $HUD/VBoxContainer/Message
		if get_tree().paused:
			message.text = "Pause"
			message.show()
		else:
			message.text = "";
			message.hide()
		
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
	$ExplosionSound.play()
	if size <= 1:
		return
	for offset in [-1, 1]:
		var dir = $Player.position.direction_to(pos).orthogonal() * offset
		var newpos = pos + dir * radius
		var newvel = dir * vel.length() * 1.1
		spawn_rock(size -1, newpos, newvel)
	score += 10 * size

# 새로운 게임
func new_game():
	$Music.play()
	get_tree().call_group("rocks", "queue_free")
	level = 0
	score = 0
	$HUD.update_score(score)
	$HUD.show_message("Get Ready!")
	$Player.reset()
	await $HUD/Timer.timeout
	playing = true

func new_level():
	$LevelUpSound.play()
	level += 1
	$HUD.show_message("Wave %s" % level)
	for i in level:
		spawn_rock(3)
	# 적 생성 시간 랜덤 설정
	$EnemyTimer.start(randf_range(5, 10))

func game_over():
	$Music.stop()
	playing = false
	$HUD.game_over()

# 적 생성 타이머가 0 이 되면 작동
func _on_enemy_timer_timeout():
	# 적을 생성
	var e = enemy_scene.instantiate()
	# Main의 자식으로 추가
	add_child(e)
	# 공격 대상을 Player로
	e.target = $Player
	# 생성하면 다음 적을 생성 하는 시간
	$EnemyTimer.start(randf_range(20, 40))
