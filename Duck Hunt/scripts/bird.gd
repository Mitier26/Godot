extends CharacterBody2D


@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var animation_player = $AnimationPlayer
@onready var collision_shape_2d = $CollisionShape2D

var Fall_Speed = 250
var Speed = 50

func _ready():
	
	# connect the game over signal
	GameManager.connect("Game_Over", Disable_Input_Pickable)
	
	# allow mouse detection the bird
	input_pickable = true
	
	# set the bird velocity to random direction
	velocity = Random_Direction() * Speed
	
	
func Disable_Input_Pickable():
	
	# disable mouse detection on the bird
	input_pickable = false
	
	
func Random_Direction():
	
	# move the bird between a random degree fo 0 and 180
	var x = deg_to_rad(randf_range(0, 180))
	
	# return a vector2 using cos and sin angles to create half rotation movement
	return Vector2(cos(x), sin(x)).normalized()
	

func _physics_process(delta):
		
	# to detect collision during flight
	# in a variable
	var Collision = move_and_collide(velocity * delta)
	
	# check if there is a collision
	if Collision:
		
		# we bounce the bird with its normal
		velocity = velocity.bounce(Collision.get_normal())
		
	# check if the velocity is less than 0
	if velocity.x < 0:
		
		# turn the child to the left
		animated_sprite_2d.flip_h = true
	
	else :
		
		# turn the bird to the right
		animated_sprite_2d.flip_h = false
		

func _on_input_event(viewport, event, shape_idx):
	
	# check if the left mouse button is been pressed when in contact wit the bird
	if event.is_action_pressed("Fire"):
		
		# disable the velocity
		velocity = Vector2.ZERO
		
		# play the death animation
		animation_player.play("Death_Animation")
		
		# wait for the animation to finish play
		await animation_player.animation_finished
		
		# set thr velocity of the bird to start falling down
		velocity = Vector2.DOWN * Fall_Speed
		
		# disable the collision shape to avoid collision
		collision_shape_2d.disabled = true
		
		# emit next round signal
		GameManager.emit_signal("Next_Round")
		
		# emit signal to count score
		GameManager.emit_signal("Score_Increase")
		
		# emit signal to double spawn bird
		GameManager.emit_signal("Double_Spawn")


func _on_visible_on_screen_notifier_2d_screen_exited():
	
	# emit the dog signal
	GameManager.emit_signal("Dog")
	
	# deleta when out of the screen
	queue_free()
