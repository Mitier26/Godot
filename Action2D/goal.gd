extends Area2D

func goal(body):
	if body.name == "Player":
		print("Goal")
		var gameclear = $"../Gameclear"
		gameclear.z_index = 100
		gameclear.visible = true
		get_tree().paused = true
