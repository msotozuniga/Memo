extends KinematicBody2D


var lineal_vel = Vector2()
var speed
var gravity
var timer
var fly_mode
var fly_charge
var proyectile
var max_magic
var magic_meter
var health
var facing_right

# Called when the node enters the scene tree for the first time.
func _ready():
	lineal_vel =Vector2()
	speed = 500
	gravity = 25
	magic_meter=0
	max_magic=100
	health=100
	proyectile = preload("res://scenes/fire_projectile.tscn")
	timer = get_node("fly")
	timer.set_one_shot(true)
	timer.set_wait_time(1)
	fly_mode = false
	fly_charge = true
	facing_right = true
	
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
		
	# Magic
	if Input.is_action_just_pressed("magic"):
		throwMagic()
		
	
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
	
	if Input.is_action_just_pressed("move_left") and facing_right:
		$shape.scale.x=$shape.scale.x*-1
		facing_right=false
	if Input.is_action_just_pressed("move_right") and !facing_right:
		$shape.scale.x=$shape.scale.x*-1
		facing_right=true
		
func parry():
	$animation.play("parry_sprite")
	pass
	
func throwMagic():
	if magic_meter==max_magic:
		var b = proyectile.instance()
		b.global_position = self.global_position
		b.rotation = (get_global_mouse_position()-b.global_position).angle()
		owner.add_child(b)
		magic_meter=0
	
func receive_damage(damage):
	health -= damage
	print("health :"+str(health))
	if health <1:
		queue_free()
		
func increase_magic(amount):
	magic_meter+=amount
	if magic_meter>max_magic:
		magic_meter = max_magic
	print("magic: "+ str(magic_meter))
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
