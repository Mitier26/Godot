extends CanvasLayer

# 플레이어의 생명 아이콘으로 사용할 텍스처를 미리 로드
var life_texture = preload("res://Assets/Player/Player.png")

# UI 요소에 대한 노드 참조를 준비 상태에서 얻음
@onready var lifes_ui_container = $MarginContainer/HBoxContainer
@onready var points_label = $MarginContainer/Points

# 외부 매니저 노드들에 대한 참조를 준비 상태에서 얻음
@onready var points_counter = $"../PointsCounter" as PointsCounter
@onready var life_manager = $"../LifeManager" as LifeManager
@onready var invader_spawner = $"../InvaderSpawner" as Invader_spawner

# 게임 오버 UI 요소에 대한 참조
@onready var game_over_label = %GameOverLabel
@onready var game_over_button = %GameOverButton
@onready var game_over_container = $MarginContainer/GameOverContainer

# 노드가 준비될 때 호출되는 함수
func _ready():
	# 초기 점수 표시를 설정
	points_label.text = "SCORE : %d" % 0
	
	# 점수 증가 시 호출될 함수를 연결
	points_counter.on_points_increased.connect(points_increased)
	
	# 게임 종료(패배) 시 호출될 함수를 연결
	invader_spawner.game_lost.connect(on_game_lost)
	
	# 게임 승리 시 호출될 함수를 연결
	invader_spawner.game_won.connect(on_game_won)
	
	# 게임 재시작 버튼 클릭 시 호출될 함수를 연결
	game_over_button.pressed.connect(on_restart_button_pressed)
	
	# 생명 감소 시 호출될 함수를 연결
	life_manager.life_lost.connect(on_life_lost)
	
	# 초기 생명 수만큼 생명 아이콘을 UI에 추가
	for i in range(life_manager.lifes):
		var life_texture_rect = TextureRect.new()
		# 텍스처 크기를 유지하며 확장 모드를 설정
		life_texture_rect.expand_mode = TextureRect.EXPAND_KEEP_SIZE
		# 최소 크기를 설정
		life_texture_rect.custom_minimum_size = Vector2(40, 25)
		# 텍스처 필터링 모드를 설정
		life_texture_rect.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		# 텍스처를 설정
		life_texture_rect.texture = life_texture
		# 생명 아이콘을 컨테이너에 추가
		lifes_ui_container.add_child(life_texture_rect)
	
# 점수가 증가했을 때 호출되는 함수
func points_increased(points: int):
	points_label.text = "SCORE : %d" % points

# 게임이 종료(패배)되었을 때 호출되는 함수
func on_game_lost():
	game_over_container.visible = true
	
# 게임이 승리로 끝났을 때 호출되는 함수
func on_game_won():
	game_over_label.text = "YOU WON!"
	# 게임 승리 시 텍스트 색상을 초록색으로 변경
	game_over_label.add_theme_color_override("font_color", Color.GREEN)
	game_over_container.visible = true

# 재시작 버튼이 눌렸을 때 호출되는 함수
func on_restart_button_pressed():
	get_tree().reload_current_scene()
	
# 생명이 감소했을 때 호출되는 함수
func on_life_lost(lifes_left: int):
	# 남은 생명이 0이 아닐 경우, 생명 아이콘 제거
	if lifes_left != 0:
		var life_texture_rect = lifes_ui_container.get_child(lifes_left)
		life_texture_rect.queue_free()
	# 남은 생명이 0일 경우, 게임 종료 처리
	else:
		on_game_lost()
