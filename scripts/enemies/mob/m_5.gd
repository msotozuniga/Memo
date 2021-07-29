extends "res://scripts/enemies/enemy_base.gd"

onready var tree = $BehaviorTree

onready var attacTimer=$AttackTimer

onready var att_speed = 1500

# Called when the node enters the scene tree for the first time.
func _ready():
	hp = 60
	hp_max = 60
	parry_counter = 3
	parry_max = 3
	type = types_vars.FIRE
	dmg = 20
	
	is_facing_right = -1
	
	$Sprite/permanent.play("idle")
	
	
func _physics_process(delta):
	fixFacing()
	tree.tick(self,self.blackboard)
		
		
func fixFacing():
	if target != null:
		look_at(target.global_position)
	else:
		.fixFacing()
	
# Acciones
func lunge(player):
	$hitbox/shape.disabled = false
	if player != null:
		var dir = (player.global_position-self.global_position).normalized()
		self.linear_velocity = dir*att_speed
		
func attack():
	is_attacking=true
	parry_counter=parry_max
	attacTimer.start()
	var player = target
	yield(get_tree().create_timer(0.1), "timeout")
	lunge(player)
	yield(get_tree().create_timer(1), "timeout")
	lunge(player)
	yield(get_tree().create_timer(1), "timeout")
	lunge(player)
	yield(get_tree().create_timer(1), "timeout")
	$hitbox/shape.disabled = true
	
	
func perform_damage():
	var temp = .perform_damage()
	if temp:
		$Sprite/permanent.play("mob_perf_dmg")
		yield($Sprite/permanent, "animation_finished")
		$Sprite/permanent.play("idle")
	return temp
	
func performDeath():
	$Sprite/permanent.play("mobs_death")
	yield($Sprite/permanent, "animation_finished")
	.performDeath()
	
func wander():
	return
#
func chase():
	var direction = (target.global_position - self.global_position).normalized()
	linear_velocity.x = direction.x * 300
	
func throw(val):
	var sheep = $hurtbox.shape.radius
	throw_start_timestop()
	if Input.is_action_just_pressed("parry"):
		.throw(val+50)
		throw_stop_timestop()
		
		
	
# TODO agregar lineofsight para que solo vaya por el jugador ssi puede verlo

func _on_hitbox_parry_entered(area):
	var parried = ._on_hitbox_parry_entered(area)
	$hitbox/shape.disabled=true
	



