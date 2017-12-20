extends "res://game/interfaces/isable.gd"

# current state and modificators
# velocity.x = ship
var velocity = Vector2()
# torque.x = ship, torque.y = canon
var torque = Vector2()
var zoom = 1
var zoom_speed = 0

var shoot_repeat = 0
var shoot_wait = 0
var target_last_pos

func is_moveable():
	return true


func _ready():
	required_properties = [
		global.properties.movement_speed_forward,
		global.properties.movement_speed_back,
		global.properties.ship_rotation_speed,
		# TODO check if necessary?
		global.properties.weapon_rotation_speed,
		global.properties.clearance_rotation,
	]
	check_requirements()
	
	set_fixed_process(true)


func get_property(prop): 
	return parent.get_property(prop)
func shoot(scene):
	shoot_wait = get_property(global.properties.bullet_wait)
	parent.shoot(scene)

func handle_action(action, pressed):
	#if self.is_in_group("player"):
		#print ("new action: ", action, " ", pressed, " zoom speed: ", zoom_speed)
	
	if pressed : 
		if action == global.actions.left: torque.x = -get_property(global.properties.ship_rotation_speed)
		elif action == global.actions.right: torque.x = get_property(global.properties.ship_rotation_speed)
		
		elif action == global.actions.target_left: torque.y = -get_property(global.properties.weapon_rotation_speed)
		elif action == global.actions.target_right: torque.y = get_property(global.properties.weapon_rotation_speed)
		
		elif action == global.actions.accelerate: velocity.x = -get_property(global.properties.movement_speed_forward)
		elif action == global.actions.back: velocity.x = get_property(global.properties.movement_speed_back)
		
		elif action == global.actions.zoom_in: zoom_speed = -get_property(global.properties.zoom_speed)
		elif action == global.actions.zoom_out: zoom_speed = get_property(global.properties.zoom_speed)
			
		elif action == global.actions.fire: 
			shoot_repeat = 1
			if shoot_wait <= 0 :
				shoot(global.scene_path_bullet)
		elif action == global.actions.use: 
			shoot_repeat = 1
			if shoot_wait <= 0 :
				shoot(global.scene_path_bullet)
		
		else:
			print ("unknown press action: ", action)
		
	else :
		if action == global.actions.left: torque.x = 0
		elif action == global.actions.right: torque.x = 0
		elif action == global.actions.target_left: torque.y = 0
		elif action == global.actions.target_right: torque.y = 0
		
		elif action == global.actions.accelerate: velocity.x = 0
		elif action == global.actions.back: velocity.x = 0
		
		elif action == global.actions.zoom_in: pass
		elif action == global.actions.zoom_out: pass
		
		elif action == global.actions.fire: shoot_repeat = 0
		elif action == global.actions.use: shoot_repeat = 0
		else:
			print ("unknown release action: ", action)

	if zoom_speed != 0: 
		#print ("zoom speed ", zoom_speed)
		zoom = zoom + (zoom_speed if (zoom+zoom_speed) >= 1 else 0)



func handle_mousemove(pos) :
	
	# save last mouse position - to stop turning weapon
	target_last_pos = pos
	
	#var scope_pos = pos
	var scope_rot
	var target_rot
	
	#scope_pos -= get_node("weaponscope").get_global_pos()
	scope_rot = parent.get_node("weaponscope").get_global_rot()
	#target_rot = atan2(scope_pos.x, scope_pos.y) + PI
	
	target_rot = parent.get_node("weaponscope").get_global_pos().angle_to_point(target_last_pos)
	#lerp()
	
	#print("mouse move ", pos, scope_pos, scope_rot, target_rot)
	
	if (scope_rot < target_rot) :
		handle_action(global.actions.target_right, true)
	elif (scope_rot > target_rot) :
		handle_action(global.actions.target_left, true)
	else:
		handle_action(global.actions.target_left, false)
		handle_action(global.actions.target_right, false)
	"""
	get_node("weaponscope").set_global_rot(atan2(dir.x, dir.y) -  PI)
	
	handle_action(global.actions.target_left, true)
	handle_action(global.actions.target_right, true)
	handle_action(global.actions.target_right, false)
	"""
	
	#print("handle mouse");
	#print(pos)



func _fixed_process(delta) :
	
	# turning vehicle
	if torque.x != 0 :
		parent.set_angular_velocity(torque.x)
	
	# turning weapon - TODO, needs to change
	if torque.y != 0 and parent.has_node("weaponscope"):
		
		if target_last_pos != null:
			var target_rot = parent.get_node("weaponscope").get_global_pos().angle_to_point(target_last_pos)
			
			if (abs(abs(target_rot) - 
				abs(parent.get_node("weaponscope").get_global_rot())) 
				< get_property(global.properties.clearance_rotation)) :
				torque.y = 0
			
		if torque.y != 0 :
			parent.get_node("weaponscope").set_rot(
				parent.get_node("weaponscope").get_rot() + 
				torque.y * delta )
	
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
		#print("new zoom", zoom)
		#get_node("Camera2D").set_zoom(Vector2(zoom, zoom));
		parent.get_node(global.scene_tree_ship_locator).set_camera_zoom(zoom)
		zoom_speed = 0
	
	# TODO - shooting stuff out of moving stuff
	if shoot_repeat != 0 and shoot_wait - delta <= 0 :
		shoot(global.scene_path_bullet)
	elif shoot_wait > 0 :
		shoot_wait -= delta