extends Area2D
var speed = 1000

onready var types = load("res://scripts/types.gd")

func _physics_process(delta):
	position += transform.x * speed * delta
	$flying.play('moving')


func _on_proyectile_enemy_entered(body):
	body.is_hit=true
	body.receive_damage(10, types.ELEC)
	queue_free()
