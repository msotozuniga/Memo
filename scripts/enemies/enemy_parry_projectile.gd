extends RigidBody2D


var dmg
var shot_by_enemy
var col_counters
var is_stopped
var is_in_throw

var hold_velocity

onready var types_vars = get_node("/root/Types")
onready var time_manage = get_node("/root/EngineTime")

func _ready():
	shot_by_enemy =true
	contact_monitor = true
	contacts_reported = 1
	$Sprite/permanent.play("summon")
	
func _physics_process(delta):
	if is_stopped:
		throw()
	

func throw_start_timestop():
	get_tree().create_timer(0.3).connect("timeout",self,"throw_stop_timestop")
	time_manage.slow_time_pace()
	
func throw_stop_timestop():
	time_manage.recover_time_pace()
	if is_stopped:
		linear_velocity = hold_velocity
		is_stopped = false
		shot_by_enemy = true

func consume():
	throw_stop_timestop()
	queue_free()

func throw():
	if Input.is_action_just_pressed("parry"):
		is_stopped = false
		var smashed_against_wall = false
		var unit_vector= (get_global_mouse_position()-self.global_position).normalized()
		print(unit_vector)
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
			if temp < 40:
				smashed_against_wall = true
		if smashed_against_wall:
			self.consume()
		else:
			linear_velocity = unit_vector * 1000
		throw_stop_timestop()
		

func collision_with_wall():
	col_counters = col_counters - 1
	if col_counters == 0:
		return self.consume()
	shot_by_enemy = true
	return
	
func collision_with_player(player):
	if shot_by_enemy:
		player.receive_hit(dmg)
		consume()
	return

func collision_with_enemy(enemy):
	if !shot_by_enemy:
		enemy.receive_damage(dmg, types_vars.NEUTRAL)
		consume()
	return


func _on_body_body_entered(body):
	var layer = body.get_collision_layer()
	if layer == 1:
		collision_with_wall()
	elif layer == 2:
		collision_with_player(body)
	return


func _on_parry_area_entered(area):
	area.get_parent().signal_parry()
	hold_velocity = linear_velocity
	linear_velocity = Vector2(0,0)
	throw_start_timestop()
	is_stopped = true
	shot_by_enemy=false


func _on_parry_body_entered(body):
	collision_with_enemy(body)
