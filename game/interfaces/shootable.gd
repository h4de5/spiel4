# interface to make a node shootable, needs bullet properties, and weapons node
extends "res://game/interfaces/isable.gd"

var shoot_repeat = 0
var shoot_wait = 0
var shoot_last_target_pos = null
var torque_weapon = 0
var weapon = null

func is_shootable():
	if activated:
		return self
	else:
		return null

func get_active_weapon():
	var weapons = get_children()
	for weapon in weapons:
		if weapon.is_activated():
			return weapon
	return null

# forward properties of active weapon to collect properties
func get_property(type):
	var weapon = get_active_weapon()
	if weapon :
		return weapon.get_property(type)
	else:
		return null

func _ready():
	required_properties = [
		global.properties.bullet_speed,
		global.properties.bullet_strength,
		global.properties.bullet_wait,
		global.properties.bullet_range,
		# TODO check if necessary?
		global.properties.weapon_rotation_speed,
		global.properties.clearance_rotation,
	]
	reset()
	#check_requirements()

	set_fixed_process(true)

# resets all values to default or off
func reset():
	shoot_repeat = 0
	shoot_wait = 0
	shoot_last_target_pos = null
	torque_weapon = 0
	weapon = get_active_weapon()

#	if parent and parent.has_node("weapons_selector"):
#		weapon = parent.get_node("weapons_selector").get_active_weapon()


func handle_mousemove(pos) :

	if not is_shootable():
		reset()
		return

	# save last mouse position - to stop turning weapon
	shoot_last_target_pos = pos

	var scope_pos
	var scope_rot
	var target_rot

	# TODO - cache weapon
	#weapon = parent.get_node("weapons_selector").get_active_weapon()
	weapon = get_active_weapon()

	if weapon:

		scope_pos = weapon.get_weapon_position()
		scope_rot = weapon.get_weapon_rotation()

		#target_rot = atan2(scope_pos.x, scope_pos.y) + PI

		target_rot = scope_pos.angle_to_point(shoot_last_target_pos)
		#			0rot
		# +PI/2 	[ship]	-PI/2
		#			+-PI
		#lerp()

		#print("mouse move pos - scope: ", scope_pos, " target: ", shoot_last_target_pos, )
		#print("mouse move rot - scope: ", scope_rot, " target: ", target_rot,
		#	" diff: ", (target_rot - scope_rot), " diff pi: ", (target_rot - scope_rot)/PI)

		var diff = target_rot - scope_rot;

		if (scope_rot > target_rot) :
			if diff < PI and diff > -PI:
				handle_action(global.actions.target_right, true)
			else:
				handle_action(global.actions.target_left, true)
		elif (scope_rot < target_rot) :
			if diff < PI and diff > -PI:
				handle_action(global.actions.target_left, true)
			else:
				handle_action(global.actions.target_right, true)
		else:
			handle_action(global.actions.target_left, false)
			handle_action(global.actions.target_right, false)


func handle_action(action, pressed):
	#if self.is_in_group("player"):
		#print ("new action: ", action, " ", pressed, " zoom speed: ", zoom_speed)

	if pressed :
		#weapon = parent.get_node("weapons_selector").get_active_weapon()
		weapon = get_active_weapon()

		if weapon :
			if action == global.actions.target_left: torque_weapon = parent.get_property(global.properties.weapon_rotation_speed)
			elif action == global.actions.target_right: torque_weapon = -parent.get_property(global.properties.weapon_rotation_speed)

			elif action == global.actions.fire:
				shoot_repeat = 1
				if shoot_wait <= 0 :
					shoot(parent, shoot_last_target_pos)
			elif action == global.actions.use:
				shoot_repeat = 1
				if shoot_wait <= 0 :
					shoot(parent, shoot_last_target_pos)
		else :
			print ("no weapon found in parent: ", parent)

	else :
		if action == global.actions.target_left: torque_weapon = 0
		elif action == global.actions.target_right: torque_weapon = 0

		elif action == global.actions.fire: shoot_repeat = 0
		elif action == global.actions.use: shoot_repeat = 0

func _fixed_process(delta) :

	# turning weapon - TODO, needs to change

	# TODO - cache weapon
	#var weapon = parent.get_node("weapons_selector").get_active_weapon()

	if torque_weapon != 0 and weapon:

		# to stop moving weapon towards target_pos

		if shoot_last_target_pos != null:
			var scope_rot = weapon.get_weapon_rotation()
			var target_rot = weapon.get_weapon_position().angle_to_point(shoot_last_target_pos)
			var clearance = parent.get_property(global.properties.clearance_rotation)

			var diff = target_rot - scope_rot;
			if diff < clearance and diff > -clearance:
				torque_weapon = 0

		if torque_weapon != 0 :
			weapon.set_weapon_rotation(
				weapon.get_weapon_rotation() +
				torque_weapon * delta )

	if weapon :
		if shoot_repeat != 0 and shoot_wait - delta <= 0 :
			shoot(parent, shoot_last_target_pos)
		elif shoot_wait > 0 :
			shoot_wait -= delta


# func shoot > moved to cannon / default weapon
func shoot(parent, target):
	if weapon:
		weapon.shoot(parent, shoot_last_target_pos)
	shoot_wait = parent.get_property(global.properties.bullet_wait)