extends RigidBody2D

var proyectile
var player_in_agro
var blackboard
var player
var attacking
var was_hit

onready var startX : float = position.x
onready var targetX : float = position.x + 100
onready var facingRight = true
onready var tree = $BehaviorTree

# Called when the node enters the scene tree for the first time.
func _ready():
	linear_velocity.x=100
	blackboard = get_tree().get_root().get_node("Main/Blackboard")
	proyectile = preload("res://scenes/enemy_projectile.tscn")
	player_in_agro=false
	player=null
	attacking = false
	was_hit = false
	$FireTimer.connect("timeout",self,"fireTimerEnd")
	
func _process(delta):
	tree.tick(self,self.blackboard)
	
	
func fireTimerEnd():
	attacking = false
	
func attack():
	linear_velocity.x=0
	if not attacking:
		attacking=true
		$FireTimer.start()
		var bullet = proyectile.instance()
		bullet.global_position = self.global_position
		owner.add_child(bullet)
		var player_pos= player.global_position
		bullet.rotation = (player_pos-bullet.global_position).angle()

func wander():
	restartMovement()
	if position.x<startX:
		position.x=startX+1
		facingRight=true
	elif position.x>targetX:
		position.x=targetX-1
		facingRight=false
		
		
func restartMovement():
	if facingRight:
		linear_velocity.x=100
	else:
		linear_velocity.x=-100
		
		
		
func receive_damage():
	performDeath()
	self.queue_free()
	
func performDeath():
	return
	

# Actions
func _on_aggro_zone_body_entered(body):
	player_in_agro=true
	player = body
	
func _on_aggro_zone_body_exited(body):
	player_in_agro=false
	player=null
