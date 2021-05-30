extends "res://addons/godot-behavior-tree-plugin/action.gd"

func tick(tick: Tick) -> int:
	#print("WANDERING")
	tick.actor.wander()
	return ERR_BUSY
