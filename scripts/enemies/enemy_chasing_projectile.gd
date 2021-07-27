extends Area2D

var speed = 400
var dmg = 0
var target: KinematicBody2D

func _physics_process(delta):
	var player_pos = null
	if target != null:
		player_pos = target.global_position
	if player_pos != null:
		self.rotation = (player_pos-self.global_position).angle()
		position += transform.x * speed * delta
	$flying.play('moving')


func _on_impact(body):
	body.receive_hit(dmg)
	queue_free()


func _on_parry(area):
	var player=area.get_parent()
	player.increase_magic(20)
	queue_free()
