extends "res://addons/godot-behavior-tree-plugin/condition.gd"


func tick(tick: Tick) -> int:
	if tick.actor.is_flying:
		return ERR_BUSY
	return FAILED
