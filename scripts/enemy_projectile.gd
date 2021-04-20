extends Area2D
var speed = 750

func _physics_process(delta):
	position += transform.x * speed * delta
	$flying.play('moving')


func _on_impact(body):
	body.receive_damage(10)
	queue_free()


func _on_parry(area):
	var player=area.get_parent()
	player.increase_magic(20)
	queue_free()
