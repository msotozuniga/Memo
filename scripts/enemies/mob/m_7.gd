extends "res://scripts/enemies/enemy_base.gd"

onready var tree = $BehaviorTree

onready var attacTimer=$AttackTimer

export var has_guard_on: bool

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
	if .fixFacing():
		fix_sprite()
		$hitbox.scale.x *= -1
		$attackRange.scale.x *= -1
		
func fix_sprite():
	# Sprite scale = (0.548,0.518)
	$Sprite.scale.x *= -1
	if is_facing_right == -1:
		$Sprite.position = Vector2(-94.857, -29.507)
	elif is_facing_right == 1:
		$Sprite.position = Vector2(94.857,-29.507)
			
		
	
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
	if !has_guard_on:
		.receive_damage(dmg,mode)
	
func raise_guard():
	has_guard_on = true
	
func perform_damage():
	var temp = .perform_damage()
	if temp:
		$Sprite/permanent.play("mob_perf_dmg")
		yield($Sprite/permanent, "animation_finished")
	return temp
	
func performDeath():
	is_flying = true
	$attack.stop()
	$movement.stop()
	$Sprite/permanent.stop()
	$Sprite/permanent.play("mobs_death")
	yield($Sprite/permanent, "animation_finished")
	.performDeath()
	
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
		has_guard_on = false
		.throw(70)
		throw_stop_timestop()
		
		
	
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
	
