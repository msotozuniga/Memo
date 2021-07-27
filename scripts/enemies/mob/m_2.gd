extends "res://scripts/enemies/enemy_base.gd"


export var unit_vector_multiplier = 1
var lvel = Vector2()

var attack_numer

var rotation_direction


onready var attack_range_low = 400
onready var attack_range_high = 500


onready var tree = $BehaviorTree
onready var rotate_timer = $RotationTimer
onready var attacTimer=$AttackTimer
 

# Called when the node enters the scene tree for the first time.
func _ready():
	hp = 50
	hp_max =50
	parry_counter = 1
	parry_max = 1
	dmg = 20
	type = types_vars.ICE
	attack_numer = 0
	rotation_direction = 0.02
	rotate_timer.start()
	projectiles.append(preload("res://scenes/enemies/enemy_projectile.tscn"))
	is_facing_right = -1
	
	
	
	
func _physics_process(delta):
	fixFacing()
	
	tree.tick(self,self.blackboard)
			
# Acciones
func fixFacing():
	if target != null:
		var old_facing = is_facing_right
		var dir = target.global_position - self.global_position
		if dir.x < 0:
			is_facing_right = 1
		else:
			is_facing_right = -1
		if is_facing_right != old_facing:
			$Sprite.scale.x *= -1
			$hitbox.scale.x *= -1
			
func attack_melee():
	print("melee")
	$attack.play("a_pattern")
	return
	
func attack_animation():
	var dir = (target.global_position-self.global_position).normalized()
	self.global_position = self.global_position + dir*unit_vector_multiplier
	
func attack_range():
	print("range")
	var bullet = projectiles[0].instance()
	bullet.transform = self.transform
	bullet.dmg = self.dmg
	get_parent().add_child(bullet)
	var player_pos= target.global_position
	bullet.rotation = (player_pos-bullet.global_position).angle()

func attack():
	.attack()
	attack_numer = randi()%2
	attacTimer.start()
	if attack_numer == 0:
		attack_melee()
	else:
		attack_range()
	
func circle_around():
	var point =target.global_position
	var current_angle = (global_position-point).angle()
	var new_angle = current_angle+rotation_direction
	self.global_position = point + Vector2(cos(new_angle),sin(new_angle))*300
	if is_attacking:
		attack_animation()
	look_at(point)
	


func wander():
	return
		
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
	


func _on_RotationTimer_timeout():
	if randi() % 2:
		rotation_direction = -0.02
	else:
		rotation_direction = 0.02
		
func _on_mob_body_entered(body):
	._on_mob_body_entered(body)
	var layer = body.get_collision_layer()
	if !is_flying:
		if layer == 1:
			rotation_direction = rotation_direction * -1
	return


