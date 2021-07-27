extends "res://addons/godot-behavior-tree-plugin/condition.gd"


func tick(tick: Tick) -> int:
	tick.actor.throw()
	return ERR_BUSY
