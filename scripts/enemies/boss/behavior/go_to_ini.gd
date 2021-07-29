extends "res://addons/godot-behavior-tree-plugin/action.gd"


func tick(tick: Tick) -> int:
	tick.actor.go_to_origin()
	return ERR_BUSY
