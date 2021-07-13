extends "res://addons/godot-behavior-tree-plugin/action.gd"




func tick(tick: Tick) -> int:
	tick.actor.perform_damage()
	return OK
	
