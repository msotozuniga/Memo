extends KinematicBody2D


var lineal_vel = Vector2()
var speed
var gravity
var timer
var fly_mode
var fly_charge
var magics = []
var max_magic
var max_hp
var magic_meter setget set_mana
var health setget set_health
var facing_right

var has_fire = true
var has_electro = true
var has_ice = true

export var is_parrying: bool


onready var runCooldown = false
onready var runTimer = $runTimer


func set_mana(value):
	magic_meter = value
	$CanvasLayer/VBoxContainer/HBoxContainer2/pbmana.value = magic_meter
	
func set_health(value):
	if value > max_hp:
		value = max_hp
	health = value
	$CanvasLayer/VBoxContainer/HBoxContainer/pbarvida.value = health
	
func _ready():
	$animation.play("idle")
	lineal_vel =Vector2()
	speed = 500
	gravity = 25
	magic_meter=0
	max_magic=100
	max_hp = 100
	health=100
	magics.append(preload("res://scenes/p_related/fire_projectile.tscn"))
	magics.append(preload("res://scenes/p_related/fire_projectile.tscn"))
	magics.append(preload("res://scenes/p_related/fire_projectile.tscn"))
	timer = get_node("fly")
	timer.set_one_shot(true)
	timer.set_wait_time(1)
	fly_mode = false
	fly_charge = true
	facing_right = true
	$CanvasLayer/VBoxContainer/HBoxContainer/pbarvida.value = health
	$CanvasLayer/VBoxContainer/HBoxContainer2/pbmana.value=magic_meter
	
func _physics_process(_delta):
	lineal_vel = move_and_slide(lineal_vel,Vector2.UP)
	lineal_vel.y += gravity
	var in_floor= is_on_floor()
	# Movimiento lateral 
	var direction_x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	lineal_vel.x = lerp(lineal_vel.x,direction_x*speed,0.4)
	
	# Carrera
	if Input.is_action_just_pressed("run") and not runCooldown and has_fire:
		runCooldown = true
		runTimer.start()
		lineal_vel.x=lineal_vel.x*4
		speed = 700
		
	if Input.is_action_just_released("run"):
		
		speed = 500
	
	# Salto
	if Input.is_action_just_pressed("jump") and in_floor:
		lineal_vel.y= -500*1.6
	
	# Parry
	if Input.is_action_just_pressed("parry"):
		parry()
		
	# Magic
	if Input.is_action_just_pressed("magic") and (has_ice or has_fire or has_electro):
		throwMagic()
		
	
	# Vuelo
	if in_floor:
		fly_charge=true
	
	# Activar vuelo
	if Input.is_action_just_pressed("jump") and !is_on_floor() and fly_charge and has_electro:
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
		$shape.position.x = $shape.position.x-16.150
		facing_right=false
	if Input.is_action_just_pressed("move_right") and !facing_right:
		$shape.scale.x=$shape.scale.x*-1
		$shape.position.x = $shape.position.x+16.150
		facing_right=true
		
func parry():
	$animation.play("parry_sprite")
	pass
	
func freeze():
	pass
	
func throwMagic():
	if magic_meter==max_magic:
		var b = magics[0].instance()
		b.transform = self.transform
		b.rotation = (get_global_mouse_position()-self.global_position).angle()
		owner.add_child(b)
		set_mana(0)
	
func receive_damage(damage):
	self.set_health(health-damage)
	if health <1:
		queue_free()
		
func receive_hit(damage):
	if !is_parrying:
		receive_damage(damage)
	
func signal_parry():
	return
	
func increase_magic(amount):
	var temp=magic_meter+amount
	if temp>max_magic:
		temp = max_magic
	self.set_mana(temp)


func _on_runTimer_timeout():
	runCooldown = false
