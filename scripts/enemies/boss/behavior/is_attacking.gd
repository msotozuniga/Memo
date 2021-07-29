extends "res://addons/godot-behavior-tree-plugin/condition.gd"


func tick(tick: Tick) -> int:
	if tick.actor.is_attacking or tick.actor.outside_of_init:
		return FAILED
	return OK
