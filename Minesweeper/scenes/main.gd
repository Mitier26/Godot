extends Node

# 게임
const TOTAL_MINES : int = 40
var time_elapsed : float
var remaining_mines : int
var first_click : bool

func _ready():
	new_game()
	
func new_game():
	first_click = true
	time_elapsed = 0
	remaining_mines = TOTAL_MINES
	$TileMap.new_game()
	$GameOver.hide()
	get_tree().paused = false
	
func _process(delta):
	time_elapsed += delta
	$HUD.get_node("Stopwatch").text = str(int(time_elapsed))
	$HUD.get_node("MinesLabel").text = str(remaining_mines)


func _on_tile_map_flag_placed():
	remaining_mines -= 1

func _on_tile_map_flag_removed():
	remaining_mines += 1

func _on_tile_map_game_won():
	end_game(1)

func _on_tile_map_end_game():
	end_game(-1)
	
func end_game(result):
	get_tree().paused = true
	$GameOver.show()
	if result == 1:
		$GameOver.get_node("Label").text = "YOU WIN!"
	else:
		$GameOver.get_node("Label").text = "BOOM!"


func _on_game_over_restart():
	new_game()



