extends Area2D
var speed = 1000

func _physics_process(delta):
	position += transform.x * speed * delta
	$flying.play('moving')