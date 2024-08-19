extends Button

@export var player : CharacterBody2D
@export var skill : Skill



func _on_pressed():
	player.skill = skill
	skill.indicator.set_reference(player)
