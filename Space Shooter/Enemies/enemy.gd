extends Node2D

@onready var move_component = $MoveComponent
@onready var stats_component = $StatsComponent
@onready var visible_on_screen_notifier_2d = $VisibleOnScreenNotifier2D
@onready var scale_component = $ScaleComponent
@onready var flash_component = $FlashComponent
@onready var shake_component = $ShakeComponent

@onready var hurtbox_component = $HurtboxComponent
@onready var hitbox_component = $HitboxComponent
@onready var destroyed_component = $DestroyedComponent


func _ready():
	visible_on_screen_notifier_2d.screen_exited.connect(queue_free)
	hurtbox_component.hurt.connect(func(hitbox: HitboxComponent):
			scale_component.tween_scale()
			flash_component.flash()
			shake_component.tween_shake()
	)
	
	stats_component.no_health.connect(queue_free)
	hitbox_component.hit_hurtbox.connect(destroyed_component.destroy.unbind(1))
