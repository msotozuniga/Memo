extends "res://addons/godot-behavior-tree-plugin/action.gd"



func tick(tick: Tick) -> int:
	tick.actor.throw()
	return ERR_BUSY
	
