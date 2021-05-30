extends RigidBody2D


var was_hit
var attacking
var target
var chase
var throw_state

var attack_numer

var rotation_direction

onready var facing = 1

onready var attack_range_low = 400
onready var attack_range_high = 500

onready var blocked=false
onready var hits = 2
onready var maxhits = 2
onready var speed = 2000
onready var tree = $BehaviorTree
onready var timer = $ThrowTime
onready var rotate_timer = $RotationTimer
onready var attacTimer=$AttackTimer
onready var blackboard = get_tree().get_root().get_node("Main/Blackboard")
onready var proyectile = preload("res://scenes/enemy_projectile.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	was_hit = false
	attacking = false
	chase = false
	target = null
	throw_state = false
	attack_numer = randi()%2
	rotation_direction = 0.02
	rotate_timer.start()
	
	
	
func _physics_process(delta):
	tree.tick(self,self.blackboard)
			
# Acciones
func attack_melee():
	pass
	
func attack_range():
	attacTimer.start()
	var bullet = proyectile.instance()
	bullet.global_position = self.global_position
	owner.add_child(bullet)
	var player_pos= target.global_position
	bullet.rotation = (player_pos-bullet.global_position).angle()

func attack():
	if not attacking:
		attacking=true
		if attack_numer == 0:
			attack_melee()
		else:
			attack_range()
		
func receive_damage():
	performDeath()
	self.queue_free()
	
	
func performDeath():
	return
	
func circle_around():
	var point =target.position
	var current_angle = (position-point).angle()
	var new_angle = current_angle+rotation_direction
	
	self.position = point + Vector2(cos(new_angle),sin(new_angle))*300
	look_at(point)
	
func wander():
	return
	
func throw():
	Engine.set_time_scale(0.1)
	if Input.is_action_just_pressed("parry"):
		var unit_vector= (get_global_mouse_position()-position).normalized()
		$hurtbox.disabled = true
		$pro_box/pro_shape.disabled = false
		$pro_box_wall/pro_shape.disabled = false
		linear_velocity = unit_vector * speed
		hits=maxhits
		slowTimeThrow()
		
func correct_range(move_away):
	return
	

# Señales
func slowTimeThrow():
	throw_state=false
	Engine.set_time_scale(1)
	
func _on_hitbox_player_entered(body):
	body.receive_damage(10)
	

func _on_hitbox_parry_entered(area):
	$hitbox/shape.disabled=true
	attacking=false
	throw_state=true
	
func _on_pro_box_enemy_entered(body):
	body.queue_free()
	queue_free()


func _on_pro_box_wall_wall_entered(body):
	queue_free()


func _on_chaseBox_body_entered(body):
	target = body
	chase=true

func _on_AttackTimer_timeout():
	attacking=false# Replace with function body.


func _on_RotationTimer_timeout():
	if randi() % 2:
		rotation_direction = -0.02
	else:
		rotation_direction = 0.02
