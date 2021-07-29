extends "res://scripts/enemies/enemy_base.gd"

onready var tree = $BehaviorTree

var activated = false
var rng = RandomNumberGenerator.new()
var is_att_close
var is_target_far
var wandering_direction : Vector2

func _ready():	
	hp = 600
	hp_max = 600
	parry_counter = 1
	parry_max = 1
	type = types_vars.FIRE
	dmg = 0
	is_att_close = false
	is_target_far = true
	
	is_facing_right = 1
	mode = RigidBody2D.MODE_CHARACTER

	projectiles.append(preload("res://scenes/enemies/fire_enemy_projectile.tscn"))
	projectiles.append(preload("res://scenes/enemies/ice_enemy_projectile.tscn"))
	
func _physics_process(delta):
	tree.tick(self, blackboard)
	
# Comportamiento
func activate():
	$FireTimer.start()
	$DirectionTimer.start()
	activated = true
	
func throw(val):
	throw_start_timestop()
	if Input.is_action_just_pressed("parry"):
		.throw(40)
		throw_stop_timestop()
		is_target_far = true
		is_att_close = false
		
func chase():
	var direction = (target.global_position - self.global_position)
	linear_velocity.x = direction.normalized().x * 600
	if direction.y < -50:
		linear_velocity.y = -500*1.6
	

	
func attack_push():
	.attack()
	var target_pos= target.global_position
	var dir = (target_pos - self.global_position).normalized()
	target.lineal_vel = dir * 10000
	target.receive_damage(10)
	is_att_close = false
	is_target_far = true
	$FireTimer.start()
	return
	

		
func wander():
	linear_velocity.x = (wandering_direction * 600).x
	var number = randi() % 50
	if number == 0:
		linear_velocity.y = (wandering_direction * 600).y
	return

func set_projectile_direction(bullet):
	var vector = target.global_position
	var direction = (vector - $projectile_spawn/shape.global_position).normalized()
	bullet.dmg = self.dmg
	bullet.global_position = $projectile_spawn/shape.global_position
	get_parent().add_child(bullet)
	bullet.rotation = direction.angle()
	return
	
func attack_base():
	var bullet = projectiles[0].instance()
	set_projectile_direction(bullet)
	
func attack_freeze():
	var bullet = projectiles[1].instance()
	set_projectile_direction(bullet)
	is_att_close = true
	
func attack():
	.attack()
	var projectile_type = randi() % 10
	$FireTimer.start()
	if projectile_type == 0:
		attack_freeze()
	else:
		attack_base()
		
func perform_damage():
	.perform_damage()
	$animation.play("perf_damage")
	
func performDeath():
	var pu_load = preload("res://scenes/p_related/fire_up.tscn")
	var pu = pu_load.instance()
	pu.global_position = self.global_position
	get_parent().add_child(pu)
	return
	
func check_side_walls():
	var is_touching_wall = false
	var space = get_world_2d().direct_space_state
	var left_ray= space.intersect_ray(global_position, global_position - Vector2(40,0), [self], 1)
	var right_ray = space.intersect_ray(global_position, global_position + Vector2(40,0), [self], 1)
	if !left_ray.empty() or !right_ray.empty():
		is_touching_wall = true
	return is_touching_wall
		
func change_wandering_direction():
	rng.randomize()
	var random_x= rng.randi_range(-10, 9)
	rng.randomize()
	var random_y= rng.randi_range(-10, 9)
	var vector = Vector2(random_x,random_y)
	wandering_direction = vector.normalized()
	
func _on_mob_body_entered(body):
	._on_mob_body_entered(body)
	var layer = body.get_collision_layer()
	if !is_flying:
		if layer == 1 and check_side_walls():
			wandering_direction = wandering_direction * -1
	return

	
	
func _on_activation_trigger_body_entered(body):
	if !activated:
		target = body
		activate()
				


func _on_physical_att_body_entered(body):
	if !is_flying:
		is_target_far = false
		
func _on_hitbox_parry_entered(parry_area):
	if is_att_close:
		._on_hitbox_parry_entered(parry_area)
	return
