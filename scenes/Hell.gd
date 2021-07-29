extends Node2D

onready var sound =get_node("/root/BgZone1")

func _physics_process(delta):
	var jefe = get_node("Jefe")
	if jefe==null:
		sound.stop()
		get_tree().change_scene("res://scenes/Cutscene2.tscn")
