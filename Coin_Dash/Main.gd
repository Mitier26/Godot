extends Node

@export var coin_scene : PackedScene
@export var power_scene : PackedScene
@export var playtime = 30

var level = 1;
var score = 0
var time_left = 0
var screensize = Vector2.ZERO
var playing = false

@onready var player = $Player
@onready var gametimer = $GameTimer
@onready var poweruptimer = $PowerupTimer
@onready var hud = $HUD
@onready var coin_sound = $CoinSound
@onready var level_sound = $LevelSound
@onready var end_sound = $EndSound
@onready var powerup_sound = $PowerupSound

func _ready():
	screensize = get_viewport().get_visible_rect().size
	player.screensize= screensize
	player.hide()

func _process(delta):
	if playing and get_tree().get_nodes_in_group("coins").size() == 0:
		level += 1
		time_left += 5
		spawn_coin()
		poweruptimer.wait_time = randi_range(5, 10)
		poweruptimer.start()
	
func new_game():
	playing = true
	level = 1
	score = 0
	time_left = playtime
	player.start()
	player.show()
	gametimer.start()
	spawn_coin()
	hud.update_score(score)
	hud.update_time(time_left)
	

func spawn_coin():
	for i in level + 4:
		var c = coin_scene.instantiate()
		add_child(c)
		c.screensize = screensize
		c.position = Vector2(randi_range(0, screensize.x), randi_range(0, screensize.y))
		level_sound.play()


func _on_game_timer_timeout():
	time_left -= 1
	hud.update_time(time_left)
	if time_left <= 0:
		game_over()

func _on_player_hurt():
	game_over()

func _on_player_pickup(type):
	match type:
		"coin":
			score += 1
			hud.update_score(score)
			coin_sound.play()
		"powerup":
			powerup_sound.play()
			time_left += 5
			hud.update_time(time_left)

func game_over():
	playing = false
	gametimer.stop()
	get_tree().call_group("coins", "queue_free")
	end_sound.play()
	hud.show_game_over()
	player.die()


func _on_hud_start_game():
	new_game()


func _on_powerup_timer_timeout():
	var p = power_scene.instantiate()
	add_child(p)
	p.screensize = screensize
	p.position = Vector2(randi_range(0, screensize.x), randi_range(0, screensize.y))
