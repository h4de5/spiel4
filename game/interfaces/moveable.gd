# interface for moving used in baseships, accepts orders from AI and input
extends "res://game/interfaces/isable.gd"

# current state and modificators
# velocity.x = ship
var velocity = 0
# torque.x = ship, torque.y = canon
var torque = 0
# for movement intentions
var intended_direction = Vector2()
# for movement target positions
var intended_target = Vector2()
var zoom = 1
var zoom_speed = 0
var handbreak = 2

func is_moveable():
	if activated:
		return self
	else:
		return null

func _ready():
	required_properties = [
		global.properties.movement_speed_forward,
		global.properties.movement_speed_back,
		global.properties.ship_rotation_speed,
		# TODO check if necessary?
		# moved to shootable
		#global.properties.weapon_rotation_speed,
		#global.properties.clearance_rotation,
	]
	#check_requirements()

	set_physics_process(true)

# resets all values to default or off
func reset():
	velocity = 0
	torque = 0
	intended_direction = Vector2()
	intended_target = Vector2()
	zoom = 1
	zoom_speed = 0

# set a position where the shop should turn to
func handle_target(target_position):
	print("Set new target: ", target_position)
	# move dead zone to input
	if target_position != Vector2(0,0):
		# TODO range lerp
		intended_target = target_position
	else:
		intended_target = Vector2(0,0)
		velocity = 0
		torque = 0

# set a direction where the shop should turn to
func handle_direction(target_direction):
	# if intended_direction.length_squared() > 0.2:
	# move dead zone to input
	if target_direction != Vector2(0,0):
		# TODO range lerp
		intended_direction = target_direction
	else:
		intended_direction = Vector2(0,0)
		velocity = 0
		torque = 0

# handle input, like turn actions
# pressed = false/0 ... means set torque and velocity to 0
# pressed = true/!=0 ... means set
func handle_action(action, pressed):
	#if self.is_in_group("player"):
		#print ("new action: ", action, " ", pressed, " zoom speed: ", zoom_speed)

	if not activated:
		reset()
		return

	# if event is just pressed, set it to 1
	if pressed is bool:
		if pressed == true:
			pressed = 1
		elif pressed == false:
			pressed = 0

	if pressed != 0:
		if action == global.actions.left: torque = -parent.get_property(global.properties.ship_rotation_speed) * pressed
		elif action == global.actions.right: torque = parent.get_property(global.properties.ship_rotation_speed) * pressed

		#elif action == global.actions.target_left: torque.y = -parent.get_property(global.properties.weapon_rotation_speed)
		#elif action == global.actions.target_right: torque.y = parent.get_property(global.properties.weapon_rotation_speed)

		elif action == global.actions.accelerate: velocity = parent.get_property(global.properties.movement_speed_forward) * pressed
		elif action == global.actions.back: velocity = -parent.get_property(global.properties.movement_speed_back) * pressed
		elif action == global.actions.stop: handbreak = 100

		elif action == global.actions.zoom_in: zoom_speed = -parent.get_property(global.properties.zoom_speed) * pressed
		elif action == global.actions.zoom_out: zoom_speed = parent.get_property(global.properties.zoom_speed) * pressed

	else :
		#print("action ", action, " unpressed")
		if action == global.actions.left: torque = 0
		elif action == global.actions.right: torque = 0

		elif action == global.actions.accelerate: velocity = 0
		elif action == global.actions.back: velocity = 0
		elif action == global.actions.stop: handbreak = 2

		elif action == global.actions.zoom_in: pass

	# cap zoom to >1
	if zoom_speed != 0:
		zoom = zoom + (zoom_speed if (zoom+zoom_speed) >= 0.99 else 0)

# check current rotation, and set torque and velocity accordingly
func process_direction(direction, power):

	var object_rot = parent.global_rotation

	var model_modifier = -PI/2 # alles verdreht
	model_modifier = PI # oben, unten: ok, link,rechts vetauscht
	model_modifier = 0 # oben, unten: vertauscht, link,rechts ok

	# var current_look_dir = Vector2(sin(object_rot + model_modifier + PI), cos(object_rot + model_modifier)).normalized()
	var current_look_dir = Vector2(cos(parent.get_global_rotation()+ PI/2), sin(parent.get_global_rotation()+ PI/2) )
	#print("current_look_dir: ", current_look_dir)
	var angle_diff = current_look_dir.angle_to(direction)
	#print("angle_diff: ", angle_diff)

	#var perfect_rotation = atan2(direction.y, direction.x) - model_modifier
	#print("perfect_rotation: ", perfect_rotation)

	# we do not set rotation, we set rotation speed
	#torque = clamp(angle_diff, -parent.get_property(global.properties.ship_rotation_speed), parent.get_property(global.properties.ship_rotation_speed))
	# multiply torque with length, to allow smoother turns
	if angle_diff > 0:
		torque = parent.get_property(global.properties.ship_rotation_speed) * direction.length()
	elif angle_diff < 0:
		torque = -parent.get_property(global.properties.ship_rotation_speed) * direction.length()
	else:
		torque = 0
	#print("current_look_dir: ", current_look_dir," angle_diff: ", angle_diff, " direction: ", direction, " torque: ", torque)

	# if set, here, we can move the ship with the direction, so we can not do backwards
	# otherwise, we need a separate button for accelerating
	if power != Vector2(0,0):
		velocity = parent.get_property(global.properties.movement_speed_forward) * power.length()

# check current rotation and position, and set torque and velocity accordingly
func process_target(target, power):

	print("get_global_position(): ", get_global_position(), " target: ", target, " length: ", ((parent.get_global_position() - target).length()) )
	if( (parent.get_global_position() - target).length() > 10):
		print ("moving to:", target, " power: ", power)
		process_direction(target.clamped(1), power)
	else:
		print ("Reset target")
		handle_target(Vector2(0,0))

func _physics_process(delta) :
	if intended_target != Vector2(0,0):
		process_target(intended_target, intended_target.clamped(1))
	elif intended_direction != Vector2(0,0):
		process_direction(intended_direction.clamped(1), intended_direction.clamped(1))

	# turning vehicle
	if torque != 0 :
		# TODO check why not use apply_torque_impulse instead of set_angular_velocity
		parent.set_angular_velocity(torque)

	parent.set_linear_damp(handbreak)

	# calculate vector from current rotation, if speed is set
	if velocity != 0 :

		var direction = Vector2(cos(parent.get_global_rotation()+ PI/2), sin(parent.get_global_rotation()+ PI/2) )

		# print("moving to ", direction * velocity * -1, " velocity: ", velocity)
		parent.apply_impulse(Vector2(0,0), direction * velocity * delta * -1)
		# parent.add_force( Vector2(0,0), direction * velocity * -1)

		# particles only work when they are available
		if velocity > 0 and has_node("particle_forward") :
			get_node("particle_forward").set_emitting(true)
			get_node("particle_forward/Light2D").show()
		if velocity < 0 and has_node("particle_backward") :
			get_node("particle_backward").set_emitting(true)
			get_node("particle_forward/Light2D").show()
	else :
		# particles only work when they are available
		if has_node("particle_forward") :
			get_node("particle_forward").set_emitting(false)
			get_node("particle_forward/Light2D").hide()
		if has_node("particle_backward") :
			get_node("particle_backward").set_emitting(false)
			get_node("particle_forward/Light2D").hide()

	# zoom can only change if camera2d is available
	# NO LONGER IN USE - DONE IN ship_locator
	if zoom_speed != 0:
		object_locator.set_camera_zoom(zoom)
		zoom_speed = 0

	if (get_tree().has_meta("network_peer") and parent.is_network_master()):

		parent.rpc_unreliable("set_network_update", parent.get_network_update())

