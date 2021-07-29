extends "res://addons/godot-behavior-tree-plugin/condition.gd"



func tick(tick: Tick) -> int:
	if tick.actor.is_in_attack_range:
		return OK
	else:
		return FAILED
