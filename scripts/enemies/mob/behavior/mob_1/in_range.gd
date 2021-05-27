extends "res://addons/godot-behavior-tree-plugin/condition.gd"


func tick(tick: Tick) -> int:
	if abs(tick.actor.target.position.x -tick.actor.position.x)>300:
		return OK
	return FAILED
