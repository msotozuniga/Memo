extends "res://addons/godot-behavior-tree-plugin/action.gd"


func tick(tick: Tick) -> int:
	if tick.actor.is_attacking:
		return ERR_BUSY
	tick.actor.attack()
	return OK
