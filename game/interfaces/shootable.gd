extends "res://game/interfaces/isable.gd"

var shoot_repeat = 0
var shoot_wait = 0
var shoot_last_target_pos = null
var torque_weapon = Vector2()

func is_shootable():
	return activated

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
	torque_weapon = Vector2()

func handle_mousemove(pos) :

	if not is_shootable():
		reset()
		return

	# save last mouse position - to stop turning weapon
	shoot_last_target_pos = pos

	#var scope_pos = pos
	var scope_rot
	var target_rot

	#scope_pos -= get_node("weapon").get_global_pos()
	scope_rot = parent.get_node("weapon").get_global_rot()
	#target_rot = atan2(scope_pos.x, scope_pos.y) + PI

	target_rot = parent.get_node("weapon").get_global_pos().angle_to_point(shoot_last_target_pos)
	#lerp()

	#print("mouse move ", pos, scope_pos, scope_rot, target_rot)

	if (scope_rot < target_rot) :
		handle_action(global.actions.target_right, true)
	elif (scope_rot > target_rot) :
		handle_action(global.actions.target_left, true)
	else:
		handle_action(global.actions.target_left, false)
		handle_action(global.actions.target_right, false)


func handle_action(action, pressed):
	#if self.is_in_group("player"):
		#print ("new action: ", action, " ", pressed, " zoom speed: ", zoom_speed)

	if pressed :
		if action == global.actions.target_left: torque_weapon.x = -get_property(global.properties.weapon_rotation_speed)
		elif action == global.actions.target_right: torque_weapon.x = get_property(global.properties.weapon_rotation_speed)

		elif action == global.actions.fire:
			shoot_repeat = 1
			if shoot_wait <= 0 :
				shoot(global.scene_path_bullet)
		elif action == global.actions.use:
			shoot_repeat = 1
			if shoot_wait <= 0 :
				shoot(global.scene_path_bullet)

	else :
		if action == global.actions.target_left: torque_weapon.x = 0
		elif action == global.actions.target_right: torque_weapon.x = 0

		elif action == global.actions.fire: shoot_repeat = 0
		elif action == global.actions.use: shoot_repeat = 0

func _fixed_process(delta) :

	# turning weapon - TODO, needs to change
	if torque_weapon.x != 0 and parent.has_node("weapon"):

		if shoot_last_target_pos != null:
			var target_rot = parent.get_node("weapon").get_global_pos().angle_to_point(shoot_last_target_pos)

			if (abs(abs(target_rot) -
				abs(parent.get_node("weapon").get_global_rot()))
				< get_property(global.properties.clearance_rotation)) :
				torque_weapon.x = 0

		if torque_weapon.x != 0 :
			parent.get_node("weapon").set_rot(
				parent.get_node("weapon").get_rot() +
				torque_weapon.x * delta )

	if shoot_repeat != 0 and shoot_wait - delta <= 0 :
		shoot(global.scene_path_bullet)
	elif shoot_wait > 0 :
		shoot_wait -= delta


func shoot(scene):

	#var shoot_scn = load("res://game/"+object+".tscn")
	var shoot_scn = load(scene)
	var shoot_node = shoot_scn.instance()
	#get_tree().get_current_scene().add_child(shoot_scn)
	parent.get_parent().add_child(shoot_node)
	shoot_node.set_owner(parent)
	shoot_node.set_pos(parent.get_node("weapon").get_node("muzzle").get_global_pos())
	shoot_wait = get_property(global.properties.bullet_wait)
