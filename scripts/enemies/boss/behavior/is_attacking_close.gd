extends "res://addons/godot-behavior-tree-plugin/condition.gd"


func tick(tick: Tick) -> int:
	if tick.actor.is_att_close:
		return OK
	return FAILED
