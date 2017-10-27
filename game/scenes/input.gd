extends Node

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_fixed_process(true)
	set_process_input(true)

func _input(event):
	var old_zoom = zoom

	if event.type == InputEvent.MOUSE_BUTTON:
		if event.button_index == BUTTON_WHEEL_UP: zoom += multi_zoom
		if event.button_index == BUTTON_WHEEL_DOWN: zoom = zoom-multi_zoom if zoom > 1 else 1

	if old_zoom != zoom :
		get_node("Camera2D").set_zoom(Vector2(zoom, zoom))

func processInput(delta):
	var speed = 0
	var rot = 0;
	var old_zoom = zoom

	# get input from keyboard
	if Input.is_action_pressed("ui_left"): rot -= delta*multi_rot
	if Input.is_action_pressed("ui_right"): rot += delta*multi_rot
	if Input.is_action_pressed("ui_up"): speed -= delta*multi_forward
	if Input.is_action_pressed("ui_down"): speed += delta*multi_forward
	if Input.is_action_pressed("ui_accept"): shoot("npc/missle")
	if Input.is_action_pressed("ui_page_down"): zoom = zoom-multi_zoom if zoom > 1 else 1
	if Input.is_action_pressed("ui_page_up"): zoom += multi_zoom

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
	var movevector = Vector2(0,0)
	if Input.is_action_pressed("ui_left"): movevector.x -= delta*multi
	if Input.is_action_pressed("ui_right"): movevector.x += delta*multi
	if Input.is_action_pressed("ui_up"): movevector.y -= delta*multi
	if Input.is_action_pressed("ui_down"): movevector.y += delta*multi

	if(movevector != Vector2(0,0)):
		#add_force( get_pos(), movevector )
		apply_impulse(Vector2(0,0), movevector)
	"""