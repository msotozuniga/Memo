extends MarginContainer

onready var seleccion_uno = $CenterContainer2/VBoxContainer/CenterContainer2/moptions/CenterContainer/HBoxContainer/moption
onready var seleccion_dos = $CenterContainer2/VBoxContainer/CenterContainer2/moptions/CenterContainer2/HBoxContainer2/moption
onready var sound =get_node("/root/BgZone1")

var current_selection = 0;

func _ready():
	set_current_seleccion(0)
	
func _process(delta):
	if Input.is_action_just_pressed("ui_down") and current_selection<1:
		current_selection+=1;
		set_current_seleccion(current_selection)
	if Input.is_action_just_pressed("ui_up") and current_selection>0:
		current_selection-=1;
		set_current_seleccion(current_selection)	
	if Input.is_action_just_pressed("ui_accept"):
		handle_selection(current_selection)

func handle_selection(_current_selection):
	if _current_selection==0:
		sound.stop()
		get_tree().change_scene("res://scenes/Cutscene1.tscn")
	if _current_selection==1:
		get_tree().quit()
	

func set_current_seleccion(_current_seleccion):
	seleccion_uno.text = ""
	seleccion_dos.text = ""
	if _current_seleccion == 0:
		seleccion_uno.text=">"
	elif _current_seleccion == 1:
		seleccion_dos.text=">"
	

