extends "res://scripts/enemies/enemy_base.gd"


onready var enemies = []

onready var mob_1 = preload("res://scenes/enemies/mobs/mob_1.tscn")
onready var mob_2 = preload("res://scenes/enemies/mobs/mob_3.tscn")

onready var tree = $BehaviorTree

var base_enemies
var enemies_spawned

var activated = false



# Called when the node enters the scene tree for the first time.
func _ready():
	hp = 50
	hp_max = 50
	enemies.append(mob_1)
	enemies.append(mob_2)
	type = types_vars.ICE
	dmg = 20
	mode = RigidBody2D.MODE_STATIC
	projectiles.append(preload("res://scenes/enemies/enemy_projectile.tscn"))
	projectiles.append(preload("res://scenes/enemies/enemy_parry_projectile.tscn"))
	
func _physics_process(delta):
	tree.tick(self, blackboard)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func spawnEnemy():
	var centerpos = $spawn_area/shape.global_position
	var size = $spawn_area/shape.shape.extents
	var positionInArea = Vector2()
	positionInArea.x = (randi() % int(size.x)) - (size.x/2) + centerpos.x
	positionInArea.y = (randi() % int(size.y)) - (size.y/2) + centerpos.y
	var mob_number = randi() % 2
	var spawn = enemies[mob_number].instance()
	spawn.global_position = positionInArea
	get_parent().add_child(spawn)
	print(spawn.global_position)
	
func attack():
	.attack()
	$FireTimer.start()
	var bullet = projectiles[0].instance()
	bullet.dmg = self.dmg
	bullet.global_position= $projectile_spawn/shape.global_position
	get_parent().add_child(bullet)
	var player_pos= target.global_position
	bullet.rotation = (player_pos-bullet.global_position).angle()
	
func activate():
	$spawnTimer.start()
	$FireTimer.start()
	$Sprite.frame = 4
	activated = true
	
	
func perform_damage():
	$animation.play("perf_damage")
	.perform_damage()
	
func performDeath():
	var pu_load = preload("res://scenes/p_related/fire_up.tscn")
	var pu = pu_load.instance()
	pu.tglobal_position = self.global_position
	get_parent().add_child(pu)
	return


func _on_spawnTimer_timeout():
	spawnEnemy()


func _on_activation_trigger_body_entered(body):
	if !activated:
		target = body
		$animation.play("startup")


func _on_animation_finished(anim_name):
	if anim_name == "startup":
		activate()
