extends "res://addons/godot-behavior-tree-plugin/condition.gd"


func tick(tick: Tick) -> int:
	print(tick.actor.throw_state)
	if tick.actor.throw_state:
		return OK
	return FAILED
