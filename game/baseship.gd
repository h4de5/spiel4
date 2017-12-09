extends RigidBody2D

# speed for acceleration and rotation and zoom
var multi_forward = 500
var multi_break = 3
var multi_rot = 1.5
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
	
	set_mass(10)
	set_weight(10)
	set_friction(1)
	set_bounce(0.5)
	set_gravity_scale(0)
	set_linear_damp(2)
	set_angular_damp(4)
	
	set_max_contacts_reported(4)
	
	# Health bar
	var health_scn = load(global.scene_path_healthbar)
	var health_node = health_scn.instance()
	get_parent().call_deferred("add_child", health_node, true)
	health_node.target_obj = self
	health_obj = health_node
	
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

# empty implementation of shoot
func shoot(path): 
	pass