extends "res://scripts/enemies/enemy_base.gd"

onready var tree = $BehaviorTree
onready var activated
onready var phase_two = false

onready var enemies = []


func _ready():	
	hp = 50
	hp_max = 500
	parry_counter = 1
	parry_max = 1
	type = types_vars.NEUTRAL
	dmg = 1
	
	enemies.append(preload("res://scenes/enemies/mobs/mob_1.tscn"))
	enemies.append(preload("res://scenes/enemies/mobs/mob_7.tscn"))
	enemies.append(preload("res://scenes/enemies/mobs/mob_1.tscn"))
	
	is_facing_right = 1
	mode = RigidBody2D.MODE_STATIC
	
	
func _physics_process(delta):
	tree.tick(self, blackboard)
	
func activate():
	activated = true
	$timer_l.start()
	$timer_r.start()
	
func spawn_enemy(side: bool):
	var enemy_to_spawn = randi() % 3
	var enemy = enemies[enemy_to_spawn].instance()
	if side:
		enemy.global_position = $spawner_r/shape.global_position
	else:
		enemy.global_position = $spawner_l/shape.global_position
	get_tree().current_scene.add_child(enemy)
	return
	
	
func receive_damage(dmg, mode):
	.receive_damage(dmg,mode)
	if hp <= hp_max/2:
		$ball/ball.phase_two = true
	return
	

	

func perform_damage():
	.perform_damage()
	$animation.play("perf_damage")
	
func performDeath():
	var pu_load = preload("res://scenes/p_related/fire_up.tscn")
	var pu = pu_load.instance()
	pu.global_position = self.global_position
	get_parent().add_child(pu)
	$animation.stop()
	$Sprite/permanent.stop()
	is_flying = true
	$Sprite/permanent.play("mobs_death")
	yield($Sprite/permanent, "animation_finished")
	.performDeath()
	return
	
func _on_activation_trigger_body_entered(body):
	if !activated:
		$ball/ball.activate(body)
		
		activate()
