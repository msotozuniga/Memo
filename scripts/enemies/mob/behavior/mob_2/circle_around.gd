extends "res://addons/godot-behavior-tree-plugin/action.gd"


func tick(tick: Tick) -> int:
	#print("WANDERING")
	tick.actor.circle_around()
	return OK
