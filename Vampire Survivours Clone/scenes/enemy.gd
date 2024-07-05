extends CharacterBody2D


@export var hp = 10
@export var movement_speed = 20.0
@export var knockback_recovery = 3.5
@export var experience = 1
var knockback = Vector2.ZERO

@onready var player = get_tree().get_first_node_in_group("player")

@onready var anim = $AnimationPlayer
@onready var snd_hit = $snd_hit

@onready var loot_base = get_tree().get_first_node_in_group("loot")

var death_anim = preload("res://scenes/explosion.tscn")
var exp_gem = preload("res://scenes/experience_gem.tscn")

signal remove_from_array(object)

func _ready():
	anim.play("walk")

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, knockback_recovery)
	var direction = global_position.direction_to(player.global_position)
	
	velocity = direction * movement_speed
	velocity += knockback
	move_and_slide()
	
	$Sprite2D.flip_h = direction.x > 0

func death():
	emit_signal("remove_from_array", self)
	var enemy_death = death_anim.instantiate()
	enemy_death.scale = $Sprite2D.scale
	enemy_death.global_position = global_position
	get_parent().call_deferred("add_child", enemy_death)
	var new_gem = exp_gem.instantiate()
	new_gem.global_position = global_position
	new_gem.experience = experience
	loot_base.call_deferred("add_child", new_gem)
	queue_free()
	

func _on_hurt_box_hurt(damage, angle, knockback_amount):
	hp -= damage
	knockback = angle * knockback_amount
	if hp <= 0:
		death()
	else:
		snd_hit.play()
