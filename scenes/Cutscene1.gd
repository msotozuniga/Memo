extends VideoPlayer
onready var sound =get_node("/root/BgZone1")

func _ready():
	pass
	
func _on_VideoPlayer_finished():
	sound.play()
	get_tree().change_scene("res://scenes/Intro.tscn")
	
