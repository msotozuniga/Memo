extends RigidBody2D


var was_hit
var attacking
var target
var chase
var throw_state

onready var blocked=false
onready var hits = 2
onready var maxhits = 2
onready var speed = 2000
onready var tree = $BehaviorTree
onready var timer = $ThrowTime
onready var attacTimer=$AttackTimer
onready var blackboard = get_tree().get_root().get_node("Main/Blackboard")

# Called when the node enters the scene tree for the first time.
func _ready():
	was_hit = false
	attacking = false
	chase = false
	target = null
	throw_state = false
	
	
func _physics_process(delta):
	tree.tick(self,self.blackboard)
		
# Acciones
func attack():
	if not attacking:
		attacking=true
		hits=maxhits
		attacTimer.start()
		$attack.play("a_pattern")
		
func receive_damage():
	performDeath()
	self.queue_free()
	
	
func performDeath():
	return
	
func wander():
	return

func chase():
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
		throw_state = false
	

# Señales
func slowTimeThrow():
	throw_state=false
	Engine.set_time_scale(1)
	
func _on_hitbox_player_entered(body):
	body.receive_damage(10)
	

func _on_hitbox_parry_entered(area):
	$hitbox/shape.disabled=true
	hits-=1
	if hits <=0:
		$attack.stop(false)
		timer.start()
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


func _on_chaseBox_body_exited(body):
	target = null
	chase = false


func _on_AttackTimer_timeout():
	attacking=false# Replace with function body.
