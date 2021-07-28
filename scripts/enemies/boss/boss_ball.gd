extends "res://scripts/enemies/enemy_base.gd"




onready var tree = $BehaviorTree
onready var init_post = self.global_position
onready var outside_of_init = false
onready var activated = false
onready var phase_two = false
# Called when the node enters the scene tree for the first time.



func _ready():
	hp = 10
	hp_max = 10
	parry_counter = 2
	parry_max = 2
	type = types_vars.NEUTRAL
	dmg = 10
	mode = RigidBody2D.MODE_CHARACTER
	
	projectiles.append(preload("res://scenes/enemies/enemy_projectile.tscn"))
	projectiles.append(preload("res://scenes/enemies/enemy_chasing_projectile.tscn"))
	
	is_facing_right = -1

func _physics_process(delta):
	tree.tick(self,self.blackboard)
	
func activate(body):
	activated = true
	target = body
	

func throw(val):
	throw_start_timestop()
	if Input.is_action_just_pressed("parry"):
		.throw(40)
		throw_stop_timestop()
		
func throw_projectile(angle):
	var bullet = projectiles[0].instance()
	bullet.dmg = self.dmg
	bullet.global_position = global_position
	get_tree().current_scene.add_child(bullet)
	bullet.rotation = angle
	return
	
func summon_following():
	var bullet = projectiles[1].instance()
	bullet.dmg = self.dmg
	bullet.global_position = global_position
	bullet.target = target
	get_tree().current_scene.add_child(bullet)
	return
	
func att_one():
	if phase_two:
		throw_projectile(0.5)
		throw_projectile(1)
		throw_projectile(1.5)
	else:
		throw_projectile(1)
		
func att_two(second):
	if (second and phase_two) or !second:
		summon_following()
	return
	

func attack():
	.attack()
	$AttackTimer.start()
	var att_number = randi() % 2
	if att_number == 1:
		$attacks.play("att_1")
	else:
		$attacks.play("att_2")
	return
	
func go_to_origin():
	var vertical_fix = global_position.y < (init_post.y + 40) and global_position.y > (init_post.y - 40)
	var horizontal_fix = global_position.x < (init_post.x + 40) and global_position.x > (init_post.x - 40)
	if vertical_fix and horizontal_fix:
		linear_velocity = Vector2(0,0)
		outside_of_init = false
	else:
		var dir = (init_post - global_position).normalized()
		linear_velocity = dir * 400

	
func wander():
	return
		
		
func receive_damage(dmg, mode):
	return

func _on_mob_body_entered(body):
	if is_flying:
		outside_of_init = true
	._on_mob_body_entered(body)

func _on_hitbox_parry_entered(area):
	var parried = ._on_hitbox_parry_entered(area)
	if parried:
		$attacks.stop()
		$hitbox/shape.disabled = true
		
	
func _on_hitbox_player_entered(body):
	var it_hit = ._on_hitbox_player_entered(body)
	if it_hit:
		self.receive_damage(self.hp,types_vars.NEUTRAL)
		


