extends "res://addons/godot-behavior-tree-plugin/condition.gd"



func tick(tick: Tick) -> int:
	if tick.actor.player_in_agro:
		return OK
	else:
		return FAILED
