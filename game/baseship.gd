extends RigidBody2D

# speed for acceleration and rotation and zoom
var multi_forward = 50
var multi_break = 3
var multi_rot = 2
var multi_zoom = 0.2

# current state and modificators
var position = Vector2()
# velocity.x = ship
var velocity = Vector2()
# rotation.x = ship, rotation.y = canon
var rotation = Vector2()
# torque.x = ship, torque.y = canon
var torque = Vector2()
var zoom = 1
var zoom_speed = 0

var health_obj

func _ready():
	set_fixed_process(true)
	set_max_contacts_reported(4)
	
	set_mass(0.1)
	set_weight(1)
	set_friction(1)
	set_bounce(0.5)
	set_gravity_scale(0)
	set_linear_damp(2)
	set_angular_damp(3)
	

func _fixed_process(delta):
	
	#var motion = velocity*delta
	#move(motion)
	
	if torque.x != 0 :
		set_angular_velocity(torque.x)
	
	# calculate vector from current rotation, if speed is set
	if velocity.x != 0 :
		var direction = Vector2(sin(get_rot()), cos(get_rot()))
		apply_impulse(Vector2(0,0), direction * delta * velocity.x)
		#get_node("Particles2D").set_emitting(true)
	#else :
		#get_node("Particles2D").set_emitting(false)
	
	
	"""
	if Input.is_action_pressed("ui_left"): rot -= delta*multi_rot
	if Input.is_action_pressed("ui_right"): rot += delta*multi_rot
	if Input.is_action_pressed("ui_up"): speed -= delta*multi_forward
	if Input.is_action_pressed("ui_down"): speed += delta*multi_forward
	if Input.is_action_pressed("ui_accept"): shoot("npc/missle")
	if Input.is_action_pressed("ui_page_down"): zoom = zoom-multi_zoom if zoom > 1 else 1
	if Input.is_action_pressed("ui_page_up"): zoom += multi_zoom
	"""
	
	#if old_zoom != zoom :
	#	get_node("Camera2D").set_zoom(Vector2(zoom, zoom));
	
	"""
	# rotate only if there is something to rotate
	if rot != 0 :
		set_angular_velocity(rot)
	"""
	

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

func handle_action(action, pressed):
	
	if pressed : 
		if action == global.actions.left: torque.x = -multi_rot
		elif action == global.actions.right: torque.x = multi_rot
		elif action == global.actions.accelerate: velocity.x = multi_forward
		elif action == global.actions.back: velocity.x = -multi_break
		
		elif action == global.actions.zoom_in: zoom_speed = -multi_zoom
		elif action == global.actions.zoom_out: zoom_speed = multi_zoom
			
		elif action == global.actions.shoot: shoot("npc/missle")
		elif action == global.actions.use: shoot("npc/missle")
		else:
			print ("unknown press action: ", action)
		
	else :
		if action == global.actions.left: torque.x = 0
		elif action == global.actions.right: torque.x = 0
		elif action == global.actions.accelerate: velocity.x = 0
		elif action == global.actions.back: velocity.x = 0
		
		elif action == global.actions.zoom_in: zoom_speed = 0
		elif action == global.actions.zoom_out: zoom_speed = 0
		else:
			print ("unknown release action: ", action)

	"""
	var speed = 0
	var rot = 0;
	var old_zoom = zoom
	
	# get input from keyboard
	if action == "ui_left": rot -= delta*multi_rot
	if action == "ui_right": rot += delta*multi_rot
	if action == "ui_up": speed -= delta*multi_forward
	if action == "ui_down": speed += delta*multi_forward
	if action == "ui_accept": shoot("npc/missle")
	if action == "ui_page_down": zoom = zoom-multi_zoom if zoom > 1 else 1
	if action == "ui_page_up": zoom += multi_zoom
	
	if old_zoom != zoom : 
		get_node("Camera2D").set_zoom(Vector2(zoom, zoom));
	
	# rotate only if there is something to rotate
	if rot != 0 :
		set_angular_velocity(rot)
	
	# calculate vecotr from current rotation, if speed is set
	if speed != 0 :
		var direction = Vector2(sin(get_rot()), cos(get_rot()))
		apply_impulse(Vector2(0,0), direction * multi_forward * delta * speed)
		get_node("Particles2D").set_emitting(true)
	else :
		get_node("Particles2D").set_emitting(false)
		
	"""
	
	
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
	
	"""
	func _input(event):
		var old_zoom = zoom
		
		if event.type == InputEvent.MOUSE_BUTTON:
			if event.button_index == BUTTON_WHEEL_UP: zoom += multi_zoom
			if event.button_index == BUTTON_WHEEL_DOWN: zoom = zoom-multi_zoom if zoom > 1 else 1
		
		if old_zoom != zoom : 
			get_node("Camera2D").set_zoom(Vector2(zoom, zoom))
	"""