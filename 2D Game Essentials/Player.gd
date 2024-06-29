extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var health = 100
var max_health

var score = 0
var inventory

func _ready() -> void:
	max_health = health

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("damage"):
		take_damage(25.0)
		add_score(10)
	
	if Input.is_action_just_pressed("heal"):
		heal(25.0)
		minus_score(5)
		
func take_damage(amount: float):
	health -= amount
	health = clamp(health, 0, max_health)
	print(health)
	
func heal(amount: float):
	health += amount
	health = clamp(health, 0, max_health)
	print(health)

func minus_score(amount:int):
	score -= amount
	if score <= 0:
		score = 0

func add_score(amount:int):
	score += amount
