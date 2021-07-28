extends "res://scripts/enemies/enemy_base.gd"

onready var tree = $BehaviorTree

func _ready():	
	hp = 20
	hp_max = 20
	parry_counter = 1
	parry_max = 1
	type = types_vars.FIRE
	dmg = 10
	
	is_facing_right = 1
	
	projectiles.append(preload("res://scenes/enemies/enemy_projectile.tscn"))
	$Sprite/permanent.play("idle")
	
func _physics_process(delta):
	fixFacing()
	tree.tick(self, blackboard)
	
func fixFacing():
	if .fixFacing():
		$Sprite.scale.x *= -1
		$fire_spawn.scale.x *= -1
	
	
func attack():
	$animations.stop(false)
	.attack()
	$FireTimer.start()
	var bullet = projectiles[0].instance()
	bullet.dmg = self.dmg
	bullet.global_position = $fire_spawn/shape.global_position
	get_tree().current_scene.add_child(bullet)
	bullet.rotation = (target.global_position-self.global_position).angle()


func wander():
	$animations.play("wander")
	return
	
func perform_damage():
	var temp = .perform_damage()
	if temp:
		$Sprite/permanent.play("per_dmg")
		yield($Sprite/permanent, "animation_finished")
		$Sprite/permanent.play("idle")
	return temp
	
	
	
func performDeath():
	$Sprite/permanent.play("death")
	yield($Sprite/permanent, "animation_finished")
	.performDeath()
	
func _on_aggro_zone_body_entered(body):
	is_in_attack_range = true
	target = body
	
func _on_aggro_zone_body_exited(body):
	is_in_attack_range = false
	target = null
				

