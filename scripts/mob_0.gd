extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var maxdelay
var timer
var proyectile

# Called when the node enters the scene tree for the first time.
func _ready():
	maxdelay =1
	timer = maxdelay
	proyectile = preload("res://scenes/enemy_projectile.tscn")
	
func _process(delta):
	
	if timer <0:
		var bullet = proyectile.instance()
		bullet.global_position = self.global_position
		owner.add_child(bullet)
		var player = get_node("/root/Main/Player")
		var player_pos= player.global_position
		bullet.rotation = (player_pos-bullet.global_position).angle()
		timer = maxdelay
	else:
		timer -= 1*delta


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
