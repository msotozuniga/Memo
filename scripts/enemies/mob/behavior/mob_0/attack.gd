extends "res://addons/godot-behavior-tree-plugin/action.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Leaf Node
func tick(tick: Tick) -> int:
	#print("ATTACKING")
	tick.actor.attack()
	return ERR_BUSY


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
