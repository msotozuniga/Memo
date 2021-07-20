extends "res://scripts/enemies/enemy_base.gd"

onready var tree = $BehaviorTree

onready var attacTimer=$AttackTimer

onready var att_speed = 1500

# Called when the node enters the scene tree for the first time.
func _ready():
	hp = 50
	hp_max = 50
	parry_counter = 3
	parry_max = 3
	type = types_vars.EARTH
	dmg = 20
	
	is_facing_right = -1
	
	
func _physics_process(delta):
	fixFacing()
	print(is_in_throw_state)
	tree.tick(self,self.blackboard)
		
		
func fixFacing():
	if target != null:
		var old_facing = is_facing_right
		var dir = target.global_position - self.global_position
		if dir.x < 0:
			is_facing_right = -1
		else:
			is_facing_right = 1
		
		if is_facing_right != old_facing:
			$Sprite.scale.x *= -1
			$hitbox.scale.x *= -1
			$attackRange.scale.x *= -1
	
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
	
	
func performDeath():
	return
	
func wander():
	return
#
func chase():
	var direction = (target.global_position - self.global_position).normalized()
	linear_velocity.x = direction.x * 300
	
func throw():
	throw_start_timestop()
	if Input.is_action_just_pressed("parry"):
		.throw()
		throw_stop_timestop()
		
		
	


func _on_hitbox_parry_entered(area):
	var parried = ._on_hitbox_parry_entered(area)
	$hitbox/shape.disabled=true
	


func _on_mob_body_entered(body):
	
	var layer = body.get_collision_layer()
	if is_flying:
		if layer == 1:
			self._on_pro_box_wall_wall_entered(body)
		if layer == 4:
			self._on_pro_box_enemy_entered(body)
	return
	
