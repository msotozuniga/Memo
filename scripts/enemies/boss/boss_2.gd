extends "res://scripts/enemies/enemy_base.gd"

onready var tree = $BehaviorTree

var activated = false
var rng = RandomNumberGenerator.new()

func _ready():	
	hp = 100
	hp_max = 100
	parry_counter = 1
	parry_max = 1
	type = types_vars.ELEC
	dmg = 10
	
	is_facing_right = -1
	mode = RigidBody2D.MODE_CHARACTER
	
	$Sprite/permanent.play("idle")
	
	projectiles.append(preload("res://scenes/enemies/enemy_chasing_projectile.tscn"))
	projectiles.append(preload("res://scenes/enemies/enemy_parry_projectile.tscn"))
	projectiles.append(preload("res://scenes/enemies/enemy_projectile.tscn"))
	
func _physics_process(delta):
	print(hp)
	tree.tick(self, blackboard)
	
func attack_base():
	var vector = target.global_position
	var direction = (vector - $projectile_spawn/shape.global_position).normalized()
	var bullet = projectiles[2].instance()
	bullet.dmg = self.dmg
	bullet.global_position = $projectile_spawn/shape.global_position
	get_parent().add_child(bullet)
	bullet.rotation = direction.angle()

	
func attack_chase():
	var bullet = projectiles[0].instance()
	bullet.dmg = self.dmg
	bullet.global_position = $projectile_spawn/shape.global_position
	bullet.target = target
	get_parent().add_child(bullet)
	var player_pos= target.global_position
	
func attack_parry():
	rng.randomize()
	var random_x= rng.randi_range(-10, 9)
	rng.randomize()
	var random_y= rng.randi_range(-10, 9)
	var vector = Vector2(random_x,random_y)
	var direction = vector.normalized()
	var bullet = projectiles[1].instance()
	bullet.col_counters = 10
	bullet.dmg = self.dmg
	bullet.global_position= $projectile_spawn/shape.global_position
	bullet.linear_velocity = direction * 1000
	get_parent().add_child(bullet)
	bullet.rotation = vector.angle()
	
	
	
func attack():
	.attack()
	rng.randomize()
	
	var projectile_type = randi() % 3
	print(projectile_type)
	$FireTimer.start()
	if projectile_type == 0:
		attack_chase()
	elif projectile_type ==1 :
		attack_parry()
	else:
		attack_base()
		
func activate():
	$FireTimer.start()
	activated = true
	rng.randomize()
	var random_x= rng.randi_range(-10, 9)
	rng.randomize()
	var random_y= rng.randi_range(-10, 9)
	var vector = Vector2(random_x,random_y).normalized()
	linear_velocity = vector * 200
	print(linear_velocity)
	
	
	
func perform_damage():
	.perform_damage()
	$animation.play("perf_damage")
	
func performDeath():
	$animation.stop()
	$Sprite/permanent.stop()
	is_flying = true
	$Sprite/permanent.play("mobs_death")
	yield($Sprite/permanent, "animation_finished")
	var pu_load = preload("res://scenes/p_related/fire_up.tscn")
	var pu = pu_load.instance()
	pu.global_position = self.global_position
	get_parent().add_child(pu)
	.performDeath()
	return
	
	
func _on_activation_trigger_body_entered(body):
	if !activated:
		target = body
		activate()
				
