extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var target = null
onready var chase = false
onready var tree = $BehaviorTree
onready var blackboard = get_tree().get_root().get_node("Main/Blackboard")
onready var attack_range = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	tree.tick(self,self.blackboard)
	

func wander():
	pass
	
func move_to(target: Vector2, speed):
	var tvel = (target - global_position).normalized() * speed
	linear_velocity = tvel
	
func chase():
	var dir = (target.position - self.position).normalized()
	linear_velocity = dir * 100
	

func _on_aggro_zone_body_entered(body):
	target = body
	chase = true
