extends Node

# export : 인스펙터에 보이게 하는 것
# 파이프가 오브젝트 같지만 씬이다
@export var pipe_scene : PackedScene

var game_running : bool			# 게임이 플레이 중이냐
var game_over : bool			# 게임이 끝났냐
var scroll						# 바닥의 이동 거리
var score						# 점수
const SCROLL_SPEED : int = 4	# 바닥의 이동속도, 게임속도
var screen_size : Vector2i		# 화면의 크기
var ground_height: int			# 바닥의 높이
var pipes : Array				# 파이프들
const PIPE_DELAY : int = 100	# 파이프 등장 대기
const PIPE_RANGE : int = 200	# 파이프 생성 높이 범위


func _ready():
	# 화면이 보디면 화면 크기를 저장한다.
	screen_size = get_window().size
	
	# 지면의 높이
	# Ground 오브젝트의 원 모습에서 Sprite2D 의 높이
	# 만들었던 Ground 씬에 가면 있다.
	ground_height = $Ground.get_node("Sprite2D").texture.get_height()
	
	new_game()

# 초기화 
func new_game():
	game_running = false
	game_over = false
	score = 0
	scroll = 0
	$ScoreLabel.text = "SCORE : " + str(score)
	$GameOver.hide()	# 다시 시작 버튼을 안보이게 한다
	# queue_free 삭제 하기
	# 그룹을 만들어 그룹 전체를 삭제한다.
	get_tree().call_group("pipes", "queue_free")
	pipes.clear()		# 배열을 초기하
	generate_pipes()	# 파이프 생성기 가동
	$Bird.reset()

# 입력 이벤트
func _input(event):
	# 게임이 종료되지 않았을 때
	if game_over == false:
		# 마우스의 이벤트가 왔는데
		if event is InputEventMouseButton:
			# 이벤트의 버튼이 마우스 왼쪽이고 클릭 되면
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
				# 게임이 실행 중이 아니면 게임을 실행한다.
				if game_running == false:
					start_game()
				# 게임이 실행 중이고
				else:
					# 새가 날고 있으면 
					if $Bird.flying:
						# 점프 한다.
						$Bird.flap()
						# 점프 할 때 위 범위를 벗어나는지 확인 한다.
						check_top()

# 게임의 시작
func start_game():
	game_running = true
	# 요런 식으로 외부 씬을 가지고 올 수 있다.
	$Bird.flying = true
	$Bird.flap()
	
	# 타이머를 시작한다.
	$PipeTimer.start()

# 매 프레임 마다 실행되는 것
func _process(delta):
	# 게임이 실행 중이면
	if game_running:
		# 스크롤 변수에 속도 값을 추가한다.
		scroll += SCROLL_SPEED
		
		# 화면의 크기 만큼 이동하면 
		# 0으로 초기화해 반복되게 만든다.
		if scroll >= screen_size.x:
			scroll = 0
			
		$Ground.position.x = -scroll
		
		for pipe in pipes:
			pipe.position.x -= SCROLL_SPEED

# Timer 에 있는 node를 추가
func _on_pipe_timer_timeout():
	generate_pipes()
	
func generate_pipes():
	# 파이프 씬을 생성하고 변수에 저장한다.
	var pipe = pipe_scene.instantiate()
	# 파이프의 등장 위치
	pipe.position.x = screen_size.x + PIPE_DELAY
	# 파이프의 등장 높이
	pipe.position.y = (screen_size.y - ground_height) / 2 + randi_range(-PIPE_RANGE, PIPE_RANGE)
	# 파이프의 히트 이벤트를 연결한다.
	pipe.hit.connect(bird_hit)
	# 뒤에 있는 것음 함수
	pipe.scored.connect(scored)
	
	# 이것 main 아래에 새로만든 파이프를 추가한다.
	add_child(pipe)
	# 배열에 생성한 파이프를 추가한다.
	pipes.append(pipe)

func scored():
	score += 1
	$ScoreLabel.text = "SCORE : " + str(score)

func check_top():
	if $Bird.position.y < 0:
		$Bird.falling = true
		stop_game()

func stop_game():
	$PipeTimer.stop()
	$GameOver.show()
	$Bird.flying = false
	game_running = false
	game_over = true

func bird_hit():
	$Bird.falling = true
	stop_game()


func _on_ground_hit():
	$Bird.falling = false
	stop_game()


func _on_game_over_restart():
	new_game()
