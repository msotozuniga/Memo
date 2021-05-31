extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var enemies = []
onready var was_hit =false
onready var health = 6


onready var mob_0 = preload("res://scenes/enemies/mobs/mob_0.tscn")
onready var mob_1 = preload("res://scenes/enemies/mobs/mob_1.tscn")
onready var mob_2 = preload("res://scenes/enemies/mobs/mob_2.tscn")
onready var mob_3 = preload("res://scenes/enemies/mobs/mob_3.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	$animation.play("startup")
	$spawnTimer.start()
	enemies.append(mob_0)
	enemies.append(mob_1)
	enemies.append(mob_2)
	enemies.append(mob_3)
	
func _physics_process(delta):
	if was_hit:
		receive_damage()
	return


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func spawnEnemy():
	var centerpos = $spawn_area/shape.global_position
	var size = $spawn_area/shape.shape.extents
	var positionInArea = Vector2()
	positionInArea.x = (randi() % int(size.x)) - (size.x/2) + centerpos.x
	positionInArea.y = (randi() % int(size.y)) - (size.y/2) + centerpos.y
	var mob_number = randi() % 4
	var spawn = enemies[mob_number].instance()
	spawn.position = positionInArea
	get_parent().add_child(spawn)
	
func receive_damage():
	was_hit = false
	health -= 1
	if health <= 0:
		self.queue_free()

func _on_spawnTimer_timeout():
	spawnEnemy()
