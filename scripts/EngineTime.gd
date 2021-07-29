extends Node

var throw_timer

func slow_time_pace():
	throw_timer = get_tree().create_timer(1)
	throw_timer.connect("timeout",self,"recover_time_pace")
	Engine.set_time_scale(0.1)

	
func recover_time_pace():
	Engine.set_time_scale(1)
	
