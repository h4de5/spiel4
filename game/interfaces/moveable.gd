# interface for moving used in baseships, accepts orders from AI and input
extends "res://game/interfaces/isable.gd"

# current state and modificators
# velocity.x = ship
var velocity = Vector2()
# torque.x = ship, torque.y = canon
var torque = Vector2()
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

	set_fixed_process(true)

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
		if action == global.actions.left: torque.x = -get_property(global.properties.ship_rotation_speed)
		elif action == global.actions.right: torque.x = get_property(global.properties.ship_rotation_speed)

		#elif action == global.actions.target_left: torque.y = -get_property(global.properties.weapon_rotation_speed)
		#elif action == global.actions.target_right: torque.y = get_property(global.properties.weapon_rotation_speed)

		elif action == global.actions.accelerate: velocity.x = -get_property(global.properties.movement_speed_forward)
		elif action == global.actions.back: velocity.x = get_property(global.properties.movement_speed_back)

		elif action == global.actions.zoom_in: zoom_speed = -get_property(global.properties.zoom_speed)
		elif action == global.actions.zoom_out: zoom_speed = get_property(global.properties.zoom_speed)

	else :
		if action == global.actions.left: torque.x = 0
		elif action == global.actions.right: torque.x = 0

		elif action == global.actions.accelerate: velocity.x = 0
		elif action == global.actions.back: velocity.x = 0

		elif action == global.actions.zoom_in: pass

	if zoom_speed != 0:
		zoom = zoom + (zoom_speed if (zoom+zoom_speed) >= 1 else 0)


func _fixed_process(delta) :

	# turning vehicle
	if torque.x != 0 :
		parent.set_angular_velocity(torque.x)

	# calculate vector from current rotation, if speed is set
	if velocity.x != 0 :
		var direction = Vector2(sin(parent.get_rot()), cos(parent.get_rot()))
		parent.apply_impulse(Vector2(0,0), direction * delta * velocity.x)

		# particles only work when they are available
		if parent.has_node("Particles2D") :
			parent.get_node("Particles2D").set_emitting(true)
	else :
		# particles only work when they are available
		if parent.has_node("Particles2D") :
			parent.get_node("Particles2D").set_emitting(false)

	# zoom can only change if camera2d is available
	if zoom_speed != 0:
		parent.get_node(global.scene_tree_ship_locator).set_camera_zoom(zoom)
		zoom_speed = 0