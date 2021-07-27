extends "res://scripts/enemies/enemy_base.gd"

onready var tree = $BehaviorTree

onready var attacTimer=$AttackTimer

var has_guard_on

# Called when the node enters the scene tree for the first time.
func _ready():
	hp = 40
	hp_max = 40
	parry_counter = 3
	parry_max = 3
	type = types_vars.FIRE
	dmg = 10
	has_guard_on = true
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
	.attack()
	parry_counter=parry_max
	attacTimer.start()
	has_guard_on = false
	throw_timer = get_tree().create_timer(0.3)
	throw_timer.connect("timeout",self,"raise_guard")
	$attack.play("a_pattern")
	
func receive_damage(dmg, mode):
	print(hp)
	if !has_guard_on:
		.receive_damage(dmg,mode)
	
func raise_guard():
	has_guard_on = true
		
	
	
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
	linear_velocity.x = direction.x * 100
	
func throw(val):
	throw_start_timestop()
	if Input.is_action_just_pressed("parry"):
		.throw(40)
		throw_stop_timestop()
		has_guard_on = false
		
	
func _on_mob_body_entered(body):
	._on_mob_body_entered(body)
	has_guard_on = true

func _on_hitbox_parry_entered(area):
	var parried = ._on_hitbox_parry_entered(area)
	$hitbox/shape_1.disabled=true
	$hitbox/shape_2.disabled=true
	$hitbox/shape_3.disabled=true
	if parried:
		$attack.stop(false)
	return true
	
