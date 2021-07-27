extends "res://scripts/enemies/enemy_base.gd"

onready var tree = $BehaviorTree

onready var attacTimer=$AttackTimer

# Called when the node enters the scene tree for the first time.
func _ready():
	hp = 40
	hp_max = 40
	parry_counter = 2
	parry_max = 2
	type = types_vars.ICE
	dmg = 10
	
	is_facing_right = -1
	
	
func _physics_process(delta):
	fixFacing()
	tree.tick(self,self.blackboard)
		
		
func fixFacing():
	var old_facing = is_facing_right 
	if target != null:
		var dir = target.global_position - self.global_position
		if dir.x < 0:
			is_facing_right = -1
		else:
			is_facing_right = 1
		
		if is_facing_right != old_facing:
			$Sprite.scale.x *= -1
			$hitbox.scale.x *= -1
			$attackRange.scale.x *= -1
	else:
		var dir = linear_velocity.x
		if dir < 0:
			is_facing_right = -1
		elif dir > 0:
			is_facing_right = 1
		
		if is_facing_right != old_facing:
			$Sprite.scale.x *= -1
			$hitbox.scale.x *= -1
			$attackRange.scale.x *= -1
			
		
	
# Acciones
func attack():
	is_attacking=true
	parry_counter=parry_max
	attacTimer.start()
	$attack.play("a_pattern")
		
	
	
func performDeath():
	is_hit = false
	return
	
func wander():
	$movement.play("wander")
	return
#
func chase():
	$movement.stop(true)
	var direction = (target.global_position - self.global_position).normalized()
	linear_velocity.x = direction.x * 200
	
func throw(val):
	throw_start_timestop()
	if Input.is_action_just_pressed("parry"):
		.throw(40)
		throw_stop_timestop()
		
	


func _on_hitbox_parry_entered(area):
	var parried = ._on_hitbox_parry_entered(area)
	$hitbox/shape.disabled=true
	if parried:
		$attack.stop(false)
	return true
	
