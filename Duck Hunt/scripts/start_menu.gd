extends CanvasLayer


func _on_play_button_pressed():
	
	# change the scene to the main
	get_tree().change_scene_to_file("res://scenes/main.tscn")


func _on_exit_button_pressed():
	
	# quit the game
	get_tree().quit()
