extends Node2D

signal score_changed

var item_scene = load("res://Items/item.tscn")
var door_scene = load("res://Items/door.tscn")

var score = 0: set = set_score

func _ready():
	$Items.hide()
	$Player.reset($SpawnPoint.position)
	set_camera_limits()
	spawn_items()
	create_ladder()
	# 플레이어의 life_change에 연결한다.
	$Player.life_change.connect($CanvasLayer/HUD.update_life)
	score_changed.connect($CanvasLayer/HUD.update_score)

# 플레이어에게 붙어 있는 카메라가 맵의 크기를 벗어 나지 않게 한다.
func set_camera_limits():
	var map_size = $World.get_used_rect()
	var cell_size = $World.tile_set.tile_size
	$Player/Camera2D.limit_left = (map_size.position.x - 5) * cell_size.x
	$Player/Camera2D.limit_right = (map_size.end.x + 5) * cell_size.x

func spawn_items():
	var item_cells = $Items.get_used_cells(0)
	for cell in item_cells:
		var data = $Items.get_cell_tile_data(0, cell)
		var type = data.get_custom_data("type")
		if type == "door":
			var door = door_scene.instantiate()
			add_child(door)
			door.position = $Items.map_to_local(cell)
			door.boyd_enterd.connect(_on_door_entered)
		else :
			var item = item_scene.instantiate()
			add_child(item)
			item.init(type, $Items.map_to_local(cell))
			item.picked_up.connect(self._on_item_picked_up)

func _on_item_picked_up():
	score += 1
	
func set_score(value):
	score = value
	score_changed.emit(score)
	
func create_ladder():
	var cells = $World.get_used_cells(0)
	for cell in cells:
		var data = $World.get_cell_tile_data(0, cell)
		if data.get_custom_data("special") == "ladder":
			var c = CollisionShape2D.new()
			$Ladders.add_child(c)
			c.position = $World.map_to_local(cell)
			var s = RectangleShape2D.new()
			s.size = Vector2(8,16)
			c.shape = s

func _on_player_died():
	GameState.restart()

func _on_door_entered(body):
	GameState.next_level()


func _on_ladder_body_entered(body):
	body.is_on_ladder = true

func _on_ladder_body_exited(body):
	body.is_on_ladder = false
