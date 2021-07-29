extends "res://addons/godot-behavior-tree-plugin/condition.gd"


func tick(tick: Tick) -> int:
	var a = tick.actor.target.position.x
	var b = tick.actor.position.x
	var lenght = abs(a-b)
	if tick.actor.attack_range_high>abs(a-b) or abs(a-b)>tick.actor.attack_range_low:
		return OK
	return FAILED

