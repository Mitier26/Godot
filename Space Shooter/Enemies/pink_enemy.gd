extends Enemy

@onready var states = $States

@onready var move_down_state = %MoveDownStateComponent
@onready var move_side_state = %MoveSideStateComponent
@onready var pause_state = %PauseState
@onready var fire_state = $States/FireState

@onready var move_side_component = %MoveSideComponent

@onready var projectile_spawner_component = %ProjectileSpawnerComponent

func _ready():
	super()
	
	for state in states.get_children():
		state = state as StateComponent
		state.disable()
	
	move_side_component.velocity.x = [-20, 20].pick_random()
	
	move_down_state.state_finished.connect(move_side_state.enable)
	move_side_state.state_finished.connect(func():
		fire_state.enable()
		scale_component.tween_scale()
		projectile_spawner_component.spawn(global_position)
		fire_state.disable()
		fire_state.state_finished.emit()
	)
	fire_state.state_finished.connect(pause_state.enable)
	pause_state.state_finished.connect(move_down_state.enable)
	
	move_down_state.enable()
