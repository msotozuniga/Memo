extends RigidBody2D

onready var types_vars = get_node("/root/Types")
onready var time_manage = get_node("/root/EngineTime")





var throw_timer 

const speed = 2000
# Enemy statistics
var hp_max
var hp
var parry_counter
var parry_max
var type
var dmg

# Enemy assets
var projectiles = []

# Enemy behavior
var target : KinematicBody2D
var blackboard

var is_hit
var is_attacking
var is_in_chase
var is_in_throw_state
var is_in_attack_range
var is_wandering
var is_stunned
var is_flying
export var is_facing_right : int

# Stats setters
func set_health(new_health):
	if new_health > hp_max:
		hp = hp_max
	else:
		hp = new_health
		
func change_health(delta):
	self.set_health(hp+delta)
	
	
func receive_damage(dmg, mode):
	if (self.type+1)%3 == mode:
		dmg=dmg*2
	self.change_health(-1*dmg)
	if hp <=0:
		performDeath()
	else:
		perform_damage()
	is_hit = true
	
func performDeath():
	is_hit = false
	var number = blackboard.get("enemies")
	blackboard.set("enemies",number-1)
	throw_stop_timestop()
	self.queue_free()
	return

# Time management

var is_timer_running = false

func throw_start_timestop():
	throw_timer = get_tree().create_timer(0.3)
	throw_timer.connect("timeout",self,"throw_stop_timestop")
	time_manage.slow_time_pace()
	if !is_timer_running:
		is_timer_running=true
	
func throw_stop_timestop():
	is_timer_running=false
	time_manage.recover_time_pace()
	is_in_throw_state = false

# Common signals
func _on_aggro_zone_body_entered(body):
	is_in_attack_range = true
	
func _on_aggro_zone_body_exited(body):
	is_in_attack_range = false

func _on_chaseBox_body_entered(body):
	target = body
	is_in_chase=true

func _on_chaseBox_body_exited(body):
	target = null
	is_in_chase = false
	
func _on_pro_box_enemy_entered(body):
	is_flying  = false
	if body != self:
		body.receive_damage(50, types_vars.NEUTRAL)
		self.receive_damage(50,types_vars.NEUTRAL)
		


func _on_pro_box_wall_wall_entered(body):
	is_flying = false
	self.receive_damage(50,types_vars.NEUTRAL)
	
func _on_mob_body_entered(body):
	var layer = body.get_collision_layer()
	if is_flying:
		if layer == 1:
			self._on_pro_box_wall_wall_entered(body)
		if layer == 4:
			self._on_pro_box_enemy_entered(body)
	return
	
func _on_hitbox_parry_entered(parry_area):
	parry_counter-=1
	if parry_counter<=0:
		is_attacking=false
		is_in_throw_state=true
		return true
	return false
	
func _on_hitbox_player_entered(body):
	if self.is_attacking:
		body.receive_hit(self.dmg)
		return true
	return false
	
func _on_AttackTimer_timeout():
	is_attacking=false
	
# Behavior basis
func attack():
	is_attacking = true
	
func perform_damage():
	is_hit = false
	return hp > 0

# Base configurations and functions
func _ready():
	blackboard = get_tree().get_root().get_node("Main/Blackboard")
	var enemies_number = blackboard.get("enemies")
	if enemies_number== null:
		blackboard.set("enemies",1)
	else:
		blackboard.set("enemies", enemies_number+1)
	self.contact_monitor = true
	self.contacts_reported = 1
	self.is_in_throw_state = false
	
func fixFacing():
	var old_facing = is_facing_right 
	var dir = 0
	if target != null:
		dir = (target.global_position - self.global_position).x
	else:
		dir = linear_velocity.x
	if dir < 0:
		is_facing_right = -1
	elif dir > 0:
		is_facing_right = 1
	return is_facing_right != old_facing
			
	
		
func throw(val):
	is_in_chase = false
	is_flying = true
	var smashed_against_wall = false
	var unit_vector= (get_global_mouse_position()-self.global_position).normalized()
	var space = get_world_2d().direct_space_state
	var line_of_sight_obstacles = space.intersect_ray(global_position, get_global_mouse_position(), [self], 1)
	if !line_of_sight_obstacles.empty():
		var object_position = line_of_sight_obstacles.position
		var radio = (global_position - object_position).abs()
		var temp = 0
		if radio.x >= radio.y:
			temp = radio.x
		else:
			temp = radio.y
		if temp < val:
			smashed_against_wall = true
	if smashed_against_wall:
		self._on_pro_box_wall_wall_entered(self)
	else:
		linear_velocity = unit_vector * speed
		parry_counter=parry_max
	
	
	
	

	

	
	








