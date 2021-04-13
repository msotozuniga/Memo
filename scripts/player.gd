extends KinematicBody2D


var lineal_vel = Vector2()
var speed
var gravity
var timer
var fly_mode
var fly_charge

# Called when the node enters the scene tree for the first time.
func _ready():
	lineal_vel =Vector2()
	speed = 500
	gravity = 25
	timer = get_node("vuelo")
	timer.set_one_shot(true)
	timer.set_wait_time(1)
	#timer.connect("timeout",self,"_fin_vuelo")
	fly_mode = false
	fly_charge = true
	
func _physics_process(_delta):
	lineal_vel = move_and_slide(lineal_vel,Vector2.UP)
	lineal_vel.y += gravity
	var in_floor= is_on_floor()
	
	# Movimiento lateral 
	var direction_x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	lineal_vel.x = lerp(lineal_vel.x,direction_x*speed,0.4)
	
	# Salto
	if Input.is_action_just_pressed("jump") and in_floor:
		lineal_vel.y= -speed*1.6
	
	# Parry
	if Input.is_action_just_pressed("parry"):
		parry()
		
	
	# Vuelo
	if in_floor:
		fly_charge=true
	
	# Activar vuelo
	if Input.is_action_just_pressed("jump") and !is_on_floor() and fly_charge:
		timer.start(0.5)
		gravity = 0
		lineal_vel.y=0
		fly_mode=true
		fly_charge = false
	
	# Vuelo vertical	
	if fly_mode:
		var direction_y = Input.get_action_strength("fly_down") - Input.get_action_strength("fly_up")
		lineal_vel.y = lerp(lineal_vel.y,direction_y*speed,0.4)
		
	
	# Terminar vuelo 
	if timer.is_stopped() or is_on_floor():
		gravity = 25
		fly_mode = false
		
func parry():
	$animation.play("parry_sprite")
	print("parry")
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
