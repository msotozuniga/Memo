extends "res://scripts/enemies/enemy_base.gd"

onready var tree = $BehaviorTree

func _ready():	
	hp = 40
	hp_max = 40
	parry_counter = 1
	parry_max = 1
	type = types_vars.FIRE
	dmg = 10
	
	is_facing_right = 1
	
	projectiles.append(preload("res://scenes/enemies/enemy_chasing_projectile.tscn"))
	
func _physics_process(delta):
	tree.tick(self, blackboard)
	
	
func attack():
	$animations.stop(false)
	.attack()
	$FireTimer.start()
	var bullet = projectiles[0].instance()
	bullet.dmg = self.dmg
	bullet.transform = self.transform
	get_parent().add_child(bullet)
	var player_pos= target.global_position
	bullet.rotation = (player_pos-bullet.global_position).angle()


func wander():
	$animations.play("wander")
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
				

