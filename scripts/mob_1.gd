extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var blocked=false
onready var hits = 2
onready var maxhits = 2
onready var speed = 2000

# Called when the node enters the scene tree for the first time.
func _ready():
	$attack.play("a_pattern")
	
	
func _physics_process(delta):
	if Input.is_action_just_pressed("parry") and hits<=0:
		var unit_vector= (get_global_mouse_position()-position).normalized()
		linear_velocity = unit_vector * speed
		hits=maxhits
		
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_hitbox_player_entered(body):
	body.receive_damage(10)
	


func _on_hitbox_parry_entered(area):
	$hitbox/shape.disabled=true
	hits-=1
	if hits <=0:
		$attack.stop(false)
	
