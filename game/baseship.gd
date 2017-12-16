extends RigidBody2D

# speed for acceleration and rotation and zoom
#var multi_forward = 500
#var multi_break = 3
#var multi_rot = 1.5
#var multi_zoom = 0.2

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
var shoot_repeat = 0
var shoot_last = 0
var target_last_pos
var rot_impreciseness = 0.05

var properties = {
	global.properties.movement_speed_forward: 500,
	global.properties.movement_speed_back: 400,
	global.properties.ship_rotation_speed: 0.5,
	global.properties.weapon_rotation_speed: 3.5,
	global.properties.zoom_speed: 0.2,
	global.properties.bullet_speed: 800,
	global.properties.bullet_strength: 50,
	global.properties.bullet_wait: 0.2,
	global.properties.health_max: 1000,
	global.properties.health: 1000
	
}

# health bar
var health_obj

# call order:
# baseship._ready > player.init > baseship.init > player._ready

func _ready():
	initialize()

func initialize() :
	set_fixed_process(true)
	set_max_contacts_reported(4)
	
	set_mass(10)
	set_weight(10)
	set_friction(1)
	set_bounce(0.5)
	set_gravity_scale(0)
	set_linear_damp(2)
	set_angular_damp(4)
	
	set_max_contacts_reported(4)
	
	connect("body_enter", self, "processCollision")
	
	# Health bar
	var health_scn = load(global.scene_path_healthbar)
	var health_node = health_scn.instance()
	#get_parent().add_child(health_node)
	get_parent().call_deferred("add_child", health_node, true)
	health_node.set_owner(self)
	
	"""
	var health_scn = load(global.scene_path_healthbar)
	var health_node = health_scn.instance()
	get_parent().call_deferred("add_child", health_node, true)
	health_node.target_obj = self
	health_obj = health_node
	"""
	reset_position()
	
# called to reset a position, usually after initialize
func reset_position() :
	pass

# see https://github.com/godotengine/godot/issues/2314
# and . https://github.com/godotengine/godot/issues/8103
func fix_collision_shape():
	for shape in get_children():
		if not shape extends CollisionShape2D and not shape extends CollisionPolygon2D: 
			continue
		if shape.has_meta("__registered") and shape.get_meta("__registered"):
			continue
		
		get_tree().set_editor_hint(true)
		
		remove_child(shape) # Make it pick up the editor hint
		add_child(shape)
		
		get_tree().set_editor_hint(false) # Unset quickly
		
		if shape extends CollisionShape2D: # Now update parent is working, so just change the shape
			shape.set_shape(shape.get_shape())
		elif shape extends CollisionPolygon2D:
			shape.set_polygon(shape.get_polygon())
		
		remove_child(shape) # Reset its editor hint cache, just in case it was needed.. (you might drop this part if it bottlenecks)
		add_child(shape)
		
		shape.set_meta("__registered", true)

func _fixed_process(delta) :
	if torque.x != 0 :
		set_angular_velocity(torque.x)
	if torque.y != 0 :
		
		var target_rot = get_node("weaponscope").get_global_pos().angle_to_point(target_last_pos)
		
		if (abs(abs(target_rot) - abs(get_node("weaponscope").get_global_rot())) < rot_impreciseness) :
			torque.y = 0
		else :
			get_node("weaponscope").set_rot(
				get_node("weaponscope").get_rot() + 
				torque.y * delta )
	
	# calculate vector from current rotation, if speed is set
	if velocity.x != 0 :
		var direction = Vector2(sin(get_rot()), cos(get_rot()))
		apply_impulse(Vector2(0,0), direction * delta * velocity.x)
		
		# particles only work when they are available
		if get_node("Particles2D") :
			get_node("Particles2D").set_emitting(true)
	else :
		# particles only work when they are available
		if get_node("Particles2D") :
			get_node("Particles2D").set_emitting(false)
	
	# zoom can only change if camera2d is available
	if zoom_speed != 0:
		#print("new zoom", zoom)
		#get_node("Camera2D").set_zoom(Vector2(zoom, zoom));
		ship_locator.set_camera_zoom(zoom)
		zoom_speed = 0
	
	if shoot_repeat != 0 and (shoot_last + delta) >= get_property(global.properties.bullet_wait) :
		shoot(global.scene_path_bullet)
		shoot_last = 0
	elif shoot_repeat != 0 :
		#print("shoot repeat: ", shoot_last, get_property(global.properties.bullet_wait))
		shoot_last += delta

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
			
		elif action == global.actions.fire: shoot_repeat = 1
		elif action == global.actions.use: shoot_repeat = 1
		
		else:
			print ("unknown press action: ", action)
		
	else :
		if action == global.actions.left: torque.x = 0
		elif action == global.actions.right: torque.x = 0
		elif action == global.actions.target_left: torque.y = 0
		elif action == global.actions.target_right: torque.y = 0
		
		elif action == global.actions.accelerate: velocity.x = 0
		elif action == global.actions.back: velocity.x = 0
		
		#elif action == global.actions.zoom_in: zoom_speed = 0
		#elif action == global.actions.zoom_out: zoom_speed = 0
		
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
	scope_rot = get_node("weaponscope").get_global_rot()
	#target_rot = atan2(scope_pos.x, scope_pos.y) + PI
	
	target_rot = get_node("weaponscope").get_global_pos().angle_to_point(target_last_pos)
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
	

# get all different properties from this ship
func get_properties():
	return properties

func get_property(type):
	#if (properties.has_index(type)) :
	if (type in properties) :
		return properties[type]
	else :
		return null

func set_property(type, value):
	if (type in properties) :
		properties[type] = value

# empty implementation of shoot
func shoot(path): 
	
	#var shoot_scn = load("res://game/"+object+".tscn")
	var shoot_scn = load(path)
	var shoot_node = shoot_scn.instance()
	#get_tree().get_current_scene().add_child(shoot_scn)
	get_parent().add_child(shoot_node)
	shoot_node.set_owner(self)
	

func can_destroy():
	return true

func destroy(destroyer):
	print(self, "was destroyed by", destroyer)
	ship_locator.free_ship(self)
	queue_free()

func hit(power, hitter):
	var health
	health = get_property(global.properties.health) - power
	set_property(global.properties.health, health)
	
	# update healthbar
	#health_obj.changeHealth(-power);
	
	if (health <= 0):
		destroy(hitter)
		#get_node("anim").play("explode")
		#destroyed=true


func processCollision(obstacle):
	
	if(obstacle.is_in_group('enemy') or obstacle.is_in_group('player')) :
		var obstacle_vel = obstacle.get_linear_velocity()
		var impact = get_linear_velocity().dot(obstacle_vel);
		#print("processCollision ", obstacle.get_name(), obstacle_vel, get_linear_velocity(), impact)
		#health_obj.changeHealth(-abs(impact) / 20000);
		
		#if health_obj.getHealth() <= 0: 
		#	get_tree().change_scene(global.scene_path_gameover)
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