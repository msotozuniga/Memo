extends "res://addons/godot-behavior-tree-plugin/action.gd"



func tick(tick: Tick) -> int:
	tick.actor.throw()
	#print("THROWING")
	return ERR_BUSY
	
