# interface for moving used in baseships, accepts orders from AI and input
extends "res://game/interfaces/isable.gd"

# current state and modificators
# velocity.x = ship
var velocity = 0
# torque.x = ship, torque.y = canon
var torque = 0
var zoom = 1
var zoom_speed = 0

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
	velocity = Vector2()
	torque = Vector2()
	zoom = 1
	zoom_speed = 0

func handle_action(action, pressed):
	#if self.is_in_group("player"):
		#print ("new action: ", action, " ", pressed, " zoom speed: ", zoom_speed)

	if not activated:
		reset()
		return

	if pressed :
		if action == global.actions.left: torque = -parent.get_property(global.properties.ship_rotation_speed)
		elif action == global.actions.right: torque = parent.get_property(global.properties.ship_rotation_speed)

		#elif action == global.actions.target_left: torque.y = -parent.get_property(global.properties.weapon_rotation_speed)
		#elif action == global.actions.target_right: torque.y = parent.get_property(global.properties.weapon_rotation_speed)

		elif action == global.actions.accelerate: velocity = parent.get_property(global.properties.movement_speed_forward)
		elif action == global.actions.back: velocity = -parent.get_property(global.properties.movement_speed_back)

		elif action == global.actions.zoom_in: zoom_speed = -parent.get_property(global.properties.zoom_speed)
		elif action == global.actions.zoom_out: zoom_speed = parent.get_property(global.properties.zoom_speed)

	else :
		if action == global.actions.left: torque = 0
		elif action == global.actions.right: torque = 0

		elif action == global.actions.accelerate: velocity = 0
		elif action == global.actions.back: velocity = 0

		elif action == global.actions.zoom_in: pass

	if zoom_speed != 0:
		zoom = zoom + (zoom_speed if (zoom+zoom_speed) >= 1 else 0)


func _physics_process(delta) :

	# turning vehicle
	if torque != 0 :
		parent.set_angular_velocity(torque)

	# calculate vector from current rotation, if speed is set
	if velocity != 0 :
		var direction = Vector2(sin(parent.get_rotation()), cos(parent.get_rotation()))
		parent.apply_impulse(Vector2(0,0), direction * delta * velocity * -1)
		#parent.add_force( Vector2(0,0), direction * delta * velocity * -1)

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

