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

# call order:
# baseship._ready > player.init > baseship.init > player._ready

func _ready():
	initialize()
	

func initialize() :
	set_fixed_process(true)
	set_max_contacts_reported(4)
	
	set_mass(0.1)
	set_weight(1)
	set_friction(1)
	set_bounce(0.5)
	set_gravity_scale(0)
	set_linear_damp(2)
	set_angular_damp(3)
	
	set_max_contacts_reported(4)
	
	# Health bar
	var health_scn = load(global.scene_path_healthbar)
	var health_node = health_scn.instance()
	get_parent().call_deferred("add_child", health_node, true)
	health_node.target_obj = self
	health_obj = health_node

func _fixed_process(delta):
	
	#var motion = velocity*delta
	#move(motion)
	
	if torque.x != 0 :
		set_angular_velocity(torque.x)
	
	# calculate vector from current rotation, if speed is set
	if velocity.x != 0 :
		var direction = Vector2(sin(get_rot()), cos(get_rot()))
		apply_impulse(Vector2(0,0), direction * delta * velocity.x)
		get_node("Particles2D").set_emitting(true)
	else :
		get_node("Particles2D").set_emitting(false)
	
	if zoom_speed != 0 and get_node("Camera2D"):
		get_node("Camera2D").set_zoom(Vector2(zoom, zoom));

func handle_action(action, pressed):
	
	if pressed : 
		if action == global.actions.left: torque.x = -multi_rot
		elif action == global.actions.right: torque.x = multi_rot
		elif action == global.actions.accelerate: velocity.x = -multi_forward
		elif action == global.actions.back: velocity.x = multi_break
		
		elif action == global.actions.zoom_in: zoom_speed = -multi_zoom
		elif action == global.actions.zoom_out: zoom_speed = multi_zoom
			
		elif action == global.actions.fire: shoot(global.scene_path_missle)
		elif action == global.actions.use: shoot(global.scene_path_missle)
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

	if zoom_speed != 0: zoom = zoom + (zoom_speed if (zoom+zoom_speed) >= 1 else 0)
	
func shoot(path): 
	pass