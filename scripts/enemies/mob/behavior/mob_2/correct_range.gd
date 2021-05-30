extends "res://addons/godot-behavior-tree-plugin/action.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


func tick(tick: Tick) -> int:
	#print("ATTACKING")
	var a = tick.actor.target.position.x
	var b = tick.actor.position.x
	var lenght = abs(a-b)
	if tick.actor.attack_range_high<abs(a-b):
		tick.actor.correct_range(true)
	if abs(a-b)<tick.actor.attack_range_low:
		tick.actor.correct_range(false)
	return ERR_BUSY
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
