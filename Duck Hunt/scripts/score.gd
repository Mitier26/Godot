extends CanvasLayer


# use control or command to drag and drop
@onready var score_label = $ScoreLabel
@onready var round_label = $RoundLabel
@onready var bullet_label = $BulletLabel
@onready var hit_label = $HitLabel

var score = 0
var round = 1
var bullet = 4

func _ready():
	GameManager.connect("Score_Increase", Score_Manager)

func Score_Manager():
	
	bullet = 4
	
	bullet_label.text = str(bullet)
	
	# show that the bird was hit
	hit_label.visible = true
	
	# increase the score
	score += 100
	
	
	# display the score
	score_label.text = str(score)
	
	# increase the round
	round += 1
	
	# show the current round
	round_label.text = str(round)
	

func _on_timer_timeout():
	
	# after the time out signal hide display
	hit_label.visible = false
	
func _input(event):
	
	# check if there is an input
	if Input.is_action_just_released("Fire"):
		
		# reduce the bullet
		bullet -= 1
		
		# show the current bullet
		bullet_label.text = str(bullet)
		
	# check if the bullet is less than or equal 0
	if bullet <= 0:
		
		# disable the input precess
		set_process_input(false)
		
		# set the bullet to 0 avoid it diaplaying a negative number
		bullet_label.text = str(0)
		
		# emit the game over signal
		GameManager.emit_signal("Game_Over")
