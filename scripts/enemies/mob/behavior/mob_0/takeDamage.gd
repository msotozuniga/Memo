extends "res://addons/godot-behavior-tree-plugin/action.gd"




func tick(tick: Tick) -> int:
	tick.actor.receive_damage()
	#print("TAKING  DAMAGE")
	return OK
	
