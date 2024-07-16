extends CanvasLayer

# use control or command to drag and drop
@onready var label_3 = $Panel/Label3

func _ready():
	
	# check for highscore
	GameManager.Check_Highscore()
	
	# call all the bird in the group and delete them form the scene
	get_tree().call_group("Bird", "queue_free")
	
	# show the highscore
	label_3.text = str(GameManager.Highscore)


func _on_retry_button_pressed():
	# change the scene to the main scene
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_menu_button_pressed():
	# change the scene to the start menu
	get_tree().change_scene_to_file("res://scenes/start_menu.tscn")
