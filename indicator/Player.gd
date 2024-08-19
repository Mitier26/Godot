extends CharacterBody2D

@export var skill : Skill:
	set(value):
		if skill is Skill:
			skill.indicator.reset()
			
		skill = value

func _input(event):
	if skill != null:
		if event.is_action_pressed("ui_cancel"):
			skill.indicator.reset()
		if event.is_action_pressed("ui_select"):
			skill.indicator.set_reference(self)
		if event.is_action_pressed("activate") and skill.indicator.activated:
			skill.activate(get_tree())
			skill.indicator.reset()
			

func _physics_process(delta):
	velocity = Input.get_vector("left", "right", "up", "down") * 150
	move_and_slide()
	
	update(delta)

func update(delta):
	if skill != null:
		skill.indicator.update(self, get_global_mouse_position(), delta)
