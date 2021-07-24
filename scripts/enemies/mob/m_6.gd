extends "res://scripts/enemies/enemy_base.gd"


onready var tree = $BehaviorTree

func _ready():	
	hp = 200
	hp_max = 200
	parry_counter = 1
	parry_max = 1
	type = types_vars.EARTH
	dmg = 20
	is_facing_right = 1
	mode = RigidBody2D.MODE_STATIC
	projectiles.append(preload("res://scenes/enemies/enemy_parry_projectile.tscn"))
	
	
func _physics_process(delta):
	attack_vertical()
	tree.tick(self, blackboard)
	
func attack_vertical():
	var space = get_world_2d().direct_space_state
	var top = global_position
	top.y = top.y - 100000 
	var line_of_sight_obstacles = space.intersect_ray(global_position, top, [self], 2)
	if !line_of_sight_obstacles.empty():
		var object = line_of_sight_obstacles.collider
		object.receive_damage(object.max_hp)
		
	
func attack():
	.attack()
	var direction = (target.global_position - self.global_position).normalized()
	$FireTimer.start()
	var bullet = projectiles[0].instance()
	bullet.col_counters = 2
	bullet.dmg = self.dmg
	if direction.x < 0:
		bullet.transform = $spawner_l/shape.transform
	else:
		bullet.transform = $spawner_r/shape.transform
	bullet.linear_velocity = direction * 1000
	get_parent().add_child(bullet)
	var player_pos= target.global_position
	bullet.rotation = (player_pos-bullet.global_position).angle()


func wander():
	return
	
func perform_damage():
	.perform_damage()
	return
	
func _on_aggro_zone_body_entered(body):
	is_in_attack_range = true
	target = body
	
func _on_aggro_zone_body_exited(body):
	is_in_attack_range = false
	target = null
