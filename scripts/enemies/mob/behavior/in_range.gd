extends "res://addons/godot-behavior-tree-plugin/condition.gd"


func tick(tick: Tick) -> int:
	var a = tick.actor.target.position.x
	var b = tick.actor.position.x
	if abs(a-b)>tick.actor.attack_range:
		return OK
	return FAILED
