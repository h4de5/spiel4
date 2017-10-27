extends RigidBody2D

# acceleration and rotation speed
var multi_forward = 60
var multi_rot = 100
var health_obj
var zoom = 1
var multi_zoom = 0.2

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_fixed_process(true)
	set_process_input(true)
	set_max_contacts_reported(4)
	
	add_to_group("player")
	
	var screensize = Vector2(Globals.get("display/width"), Globals.get("display/height"))
	set_pos(screensize / 2)
	
	var health_scn = load("res://game/gui/health.tscn")
	var health_node = health_scn.instance()
	
	get_parent().call_deferred("add_child", health_node, true)
	
	health_node.target_obj = self
	health_obj = health_node
	
	var camera_scn = load("res://game/scenes/camera.tscn")
	var camera_node = camera_scn.instance()
	add_child(camera_node)
	
	connect("body_enter", self, "processCollision")
	pass

func _fixed_process(delta):
	#print("_fixed_process", get_colliding_bodies())
	processInput(delta)
	
	
func _input(event):
	var old_zoom = zoom
	
	if event.type == InputEvent.MOUSE_BUTTON:
		if event.button_index == BUTTON_WHEEL_UP: zoom += multi_zoom
		if event.button_index == BUTTON_WHEEL_DOWN: zoom = zoom-multi_zoom if zoom > 1 else 1
	
	if old_zoom != zoom : 
		get_node("Camera2D").set_zoom(Vector2(zoom, zoom))


func processCollision(obstacle):
	
	if(obstacle.is_in_group('enemy') or obstacle.is_in_group('player')) :
		var obstacle_vel = obstacle.get_linear_velocity()
		var impact = get_linear_velocity().dot(obstacle_vel);
		#print("processCollision ", obstacle.get_name(), obstacle_vel, get_linear_velocity(), impact)
		health_obj.changeHealth(-abs(impact) / 20000);
		
		if health_obj.getHealth() <= 0: 
			get_tree().change_scene("res://games/scenes/gameover.tscn")
		# process impact on obstacle
		obstacle.processCollision(impact)
		
		# now about where we hit it
		var player_pos = get_pos()
		var obstacle_pos = obstacle.get_pos()
		var hit_position = player_pos - obstacle_pos
		print("hitpos: ", player_pos.normalized())
		
		"""
		var raycast = RayCast(obstacle_pos)
		
		raycast.set_cast_to(player_pos)
		if raycast.is_colliding() : 
			print("get_collision_point: ", raycast.get_collision_point(), " get_collider: ", raycast.get_collider())
		"""

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
func shoot(object) :
	var shoot_scn = load("res://game/"+object+".tscn")
	var shoot_node = shoot_scn.instance()
	var player_pos = get_pos()
	
	get_parent().call_deferred("add_child", shoot_node, true)
	
	shoot_node.set_pos(player_pos)
	
