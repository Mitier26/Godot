extends Skill
class_name  PointShot
 
func activate(scene_tree):
	shoot(scene_tree)
 
 
func shoot(scene_tree):
	if projectile_node == null:
		return
 
	var projectile = projectile_node.instantiate()
 
	projectile.position = indicator.spawn_point
	projectile.direction = Vector2.RIGHT
	projectile.speed = 0
 
	scene_tree.current_scene.add_child(projectile)
	projectile.play(projectile_name)
