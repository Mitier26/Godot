extends Node2D

enum {HOVER, FALL, LAND, RISE}

var state = HOVER

@onready var star_position = global_position
@onready var timer = $Timer
@onready var ray_cast_2d = $RayCast2D
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var cpu_particles_2d = $CPUParticles2D

func _physics_process(delta):
	match state:
		HOVER: hover_state()
		FALL: fall_state(delta)
		LAND: land_state()
		RISE: rise_state(delta)

func hover_state():
	state = FALL
	
func fall_state(delta):
	animated_sprite_2d.play("Falling")
	global_position.y += 100 * delta
	if ray_cast_2d.is_colliding():
		var collision_point = ray_cast_2d.get_collision_point()
		global_position.y = collision_point.y
		state = LAND
		timer.start(1.0)
		cpu_particles_2d.emitting = true
		
func land_state():
	if timer.time_left == 0:
		state = RISE

func rise_state(delta):
	animated_sprite_2d.play("Rising")
	global_position.y = move_toward(global_position.y, star_position.y, 20 * delta)
	if global_position.y == star_position.y:
		state = HOVER
