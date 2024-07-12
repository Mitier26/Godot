extends Node2D

@onready var left_muzzle: Marker2D = $LeftMuzzle
@onready var right_muzzle: Marker2D = $RightMuzzle
@onready var spawner_component = $SpawnerComponent
@onready var fire_rate_timer = $FireRateTimer
@onready var scale_component = $ScaleComponent

func _ready() -> void:
	fire_rate_timer.timeout.connect(fire_lasers)

func fire_lasers() -> void:
	spawner_component.spawn(left_muzzle.global_position)
	spawner_component.spawn(right_muzzle.global_position)
	scale_component.tween_scale()
