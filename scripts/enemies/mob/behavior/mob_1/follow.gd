extends "res://addons/godot-behavior-tree-plugin/action.gd"


func tick(tick: Tick) -> int:
	tick.actor.chase()
	#print("FOLLOW")
	return OK
	
