extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var target = null
onready var chase = false
onready var throw_state = false
onready var speed = 2000
onready var timer = $ThrowTime

onready var tree = $BehaviorTree
onready var blackboard = get_tree().get_root().get_node("Main/Blackboard")
onready var attack_range = 0

# Called when the node enters the scene tree for the first time.



func _physics_process(delta):
	tree.tick(self,self.blackboard)
	

func throw():
	Engine.set_time_scale(0.1)
	if Input.is_action_just_pressed("parry"):
		linear_velocity = Vector2(0,0)
		var unit_vector= (get_global_mouse_position()-position).normalized()
		$hurtbox.disabled = true
		$pro_box/shape.disabled = false
		$pro_box_wall/shape.disabled = false
		linear_velocity = unit_vector * speed
		slowTimeThrow()
		throw_state = false
		
		


func wander():
	pass
	
func chase():
	var dir = (target.position - self.position).normalized()
	linear_velocity = linear_velocity + dir * 20
	

func slowTimeThrow():
	throw_state=false
	Engine.set_time_scale(1)

func _on_aggro_zone_body_entered(body):
	target = body
	chase = true


func _on_hitbox_area_entered(area):
	$hitbox/shape.disabled=true
	throw_state=true


func _on_hitbox_body_entered(body):
	body.receive_damage(10)
	queue_free()


func _on_pro_box_body_entered(body):
	body.queue_free()
	queue_free()


func _on_pro_box_wall_body_entered(body):
	queue_free()
