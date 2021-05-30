extends "res://addons/godot-behavior-tree-plugin/condition.gd"


func tick(tick: Tick) -> int:
	if tick.actor.chase:
		return OK
	return FAILED
