extends Area2D
var speed = 1000
var dmg


func _physics_process(delta):
	position += transform.x * speed * delta
	$flying.play('moving')


func _on_proyectile_enemy_entered(body):
	body.receive_hit(dmg)
	queue_free()
	
func _on_parry(area):
	var player=area.get_parent()
	player.increase_magic(20)
	queue_free()
