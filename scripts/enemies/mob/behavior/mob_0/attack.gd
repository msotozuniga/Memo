extends "res://addons/godot-behavior-tree-plugin/action.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Leaf Node
func tick(tick: Tick) -> int:
	if tick.actor.is_attacking:
		return ERR_BUSY
	tick.actor.attack()
	return OK


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
