extends Skill

class_name SingleShot

func activate(scene_tree):
	shoot(scene_tree)

func shoot(scene_tree):
	if projectile_node == null:
		return
		
	var projectile = projectile_node.instantiate()
	
	projectile.position = indicator.spawn_point
	projectile.direction = indicator.direction
	
	scene_tree.current_scene.add_child(projectile)
	projectile.play(projectile_name)
