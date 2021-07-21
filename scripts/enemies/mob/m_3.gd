extends "res://scripts/enemies/enemy_base.gd"




onready var tree = $BehaviorTree

# Called when the node enters the scene tree for the first time.

func _ready():
	hp = 10
	hp_max = 10
	parry_counter = 1
	parry_max = 1
	type = types_vars.ICE
	dmg = 10
	
	is_facing_right = -1

func _physics_process(delta):
	tree.tick(self,self.blackboard)
	

func throw(val):
	throw_start_timestop()
	if Input.is_action_just_pressed("parry"):
		.throw(40)
		throw_stop_timestop()
		
		
	
	
func performDeath():
	return

func wander():
	return
	
func chase():
	var dir = (target.global_position - self.global_position).normalized()
	linear_velocity = linear_velocity + dir * 20
	

func _on_aggro_zone_body_entered(body):
	target = body
	is_in_chase = true
	is_attacking = true


func _on_hitbox_parry_entered(area):
	var parried = ._on_hitbox_parry_entered(area)
	print(parried)
	if parried:
		$hitbox/shape.disabled=true
	
func _on_hitbox_player_entered(body):
	var it_hit = ._on_hitbox_player_entered(body)
	if it_hit:
		self.receive_damage(self.hp,types_vars.NEUTRAL)

