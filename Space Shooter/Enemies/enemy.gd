extends Node2D

@onready var move_component = $MoveComponent
@onready var stats_component = $StatsComponent
@onready var visible_on_screen_notifier_2d = $VisibleOnScreenNotifier2D
@onready var scale_component = $ScaleComponent
@onready var flash_component = $FlashComponent


func _ready():
	visible_on_screen_notifier_2d.screen_exited.connect(queue_free)
	
	
