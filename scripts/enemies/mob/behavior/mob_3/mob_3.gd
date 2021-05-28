extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var target = null
onready var chase = false
onready var tree = $BehaviorTree

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func wander():
	pass
	
func chase():
	pass

func _on_aggro_zone_body_entered(body):
	target = body
	chase = true
