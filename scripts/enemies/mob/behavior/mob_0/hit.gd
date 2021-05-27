extends "res://addons/godot-behavior-tree-plugin/condition.gd"


func tick(tick: Tick) -> int:
	if tick.actor.was_hit:
		return OK
	return FAILED
