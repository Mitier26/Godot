extends Skill
class_name MultiShot
 
var modified_direction : Vector2
var angle_of_rotation : float
 
@export var count : int = 3
 
func activate(scene_tree):
	radial_shot(scene_tree)
 
 
func radial_shot(scene_tree):
	angle_of_rotation = -45
	for i in range(count):
		modified_direction = indicator.direction.rotated(deg_to_rad(angle_of_rotation))
		shoot(scene_tree)
		angle_of_rotation += (90.0/(count-1))
 
 
func shoot(scene_tree):
	if projectile_node == null:
		return
 
	var projectile = projectile_node.instantiate()
 
	projectile.position = indicator.spawn_point
	projectile.direction = modified_direction
 
	scene_tree.current_scene.add_child(projectile)
	projectile.play(projectile_name)
 
