extends RigidBody2D

var multi_forward = 50;
var multi_rot = 200;
export (NodePath) var health;

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_fixed_process(true)
	set_max_contacts_reported(1)
	
	connect("body_enter", self, "processCollision")
	pass

func _fixed_process(delta):
	#print("_fixed_process", get_colliding_bodies())
	processInput(delta)

func processCollision(obstacle):
	print("processCollision ", obstacle.get_name())

func processInput(delta):
	var speed = 0
	var rot = 0;
	
	# get input from keyboard
	if Input.is_action_pressed("ui_left"): rot -= delta*multi_rot
	if Input.is_action_pressed("ui_right"): rot += delta*multi_rot
	if Input.is_action_pressed("ui_up"): speed -= delta*multi_forward
	if Input.is_action_pressed("ui_down"): speed += delta*multi_forward
	
	# rotate only if there is something to rotate
	if rot != 0 :
		set_angular_velocity(rot)
	
	# calculate vecotr from current rotation, if speed is set
	if speed != 0 :
		var direction = Vector2(sin(get_rot()), cos(get_rot()))
		apply_impulse(Vector2(0,0), direction * multi_forward * delta * speed)
	
	
	"""
	var movevector = Vector2(0,0)
	if Input.is_action_pressed("ui_left"): movevector.x -= delta*multi
	if Input.is_action_pressed("ui_right"): movevector.x += delta*multi
	if Input.is_action_pressed("ui_up"): movevector.y -= delta*multi
	if Input.is_action_pressed("ui_down"): movevector.y += delta*multi
	
	if(movevector != Vector2(0,0)):
		#add_force( get_pos(), movevector )
		apply_impulse(Vector2(0,0), movevector)
	"""
