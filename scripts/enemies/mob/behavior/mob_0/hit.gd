extends "res://addons/godot-behavior-tree-plugin/condition.gd"


func tick(tick: Tick) -> int:
	if tick.actor.is_hit:
		return OK
	return FAILED
