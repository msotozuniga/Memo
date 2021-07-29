extends "res://scripts/enemies/enemy_base.gd"

onready var tree = $BehaviorTree

func _ready():	
	hp = 50
	hp_max = 50
	parry_counter = 1
	parry_max = 1
	type = types_vars.ELEC
	dmg = 20
	
	is_facing_right = 1
	
	projectiles.append(preload("res://scenes/enemies/enemy_projectile.tscn"))
	
func _physics_process(delta):
	fixFacing()
	tree.tick(self, blackboard)

func fixFacing():
	if target != null:
		var dir = (target.global_position - self.global_position).angle()
		$base/muzzle.rotation = dir
	
	
func attack():
	.attack()
	$AttackTimer.start()
	var player_pos= target.global_position
	for i in range(3):
		var bullet = projectiles[0].instance()
		bullet.dmg = self.dmg
		bullet.transform = self.transform
		get_parent().add_child(bullet)
		bullet.rotation = (player_pos-bullet.global_position).angle()
		yield(get_tree().create_timer(0.1), "timeout")

func wander():
	return
	
func perform_damage():
	var temp = .perform_damage()
	if temp:
		$base/permanent.play("mob_perf_dmg")
		yield($base/permanent, "animation_finished")
	return temp
	
	
	
func performDeath():
	$base/permanent.play("mobs_death")
	yield($base/permanent, "animation_finished")
	.performDeath()
	
func _on_aggro_zone_body_entered(body):
	
	is_in_attack_range = true
	target = body
	
func _on_aggro_zone_body_exited(body):
	
	is_in_attack_range = false
	target = null
				
