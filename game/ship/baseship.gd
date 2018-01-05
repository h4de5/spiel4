# base class for all ships, has all interfaces and properties
extends RigidBody2D

export var properties = Dictionary()


# call order:
# baseship._ready > player.init > baseship.init > player._ready

func _ready():

	#print("baseship _ready - start ", get_name())
	properties = {
		global.properties.movement_speed_forward: 4000,
		global.properties.movement_speed_back: 2000,
		global.properties.ship_rotation_speed: 1,
		global.properties.zoom_speed: 0.2,
		global.properties.health_max: 1000,
		global.properties.health: 1000
	}

	# merges properties from all sub-nodes
	properties = interface.collect_properties(self)

	#print("found properties base ", properties)

	initialize()
	#print("baseship _ready - end ", get_name())

func initialize() :
	#set_fixed_process(true)
	set_max_contacts_reported(4)

	set_mass(50)
	set_weight(50)
	set_friction(1)
	set_bounce(0.5)
	set_gravity_scale(0)
	set_linear_damp(2)
	set_angular_damp(4)

	set_max_contacts_reported(4)
	connect("body_enter", self, "processCollision")

	reset_position()

# called to reset a position, usually after initialize
func reset_position() :
	randomize();

	#var screensize = Vector2(Globals.get("display/width"),Globals.get("display/height"))
	var box = get_node(global.scene_tree_ship_locator).get_bounding_box_all([self])
	if box != null:
		box = box.pos + box.size/2
	else :
		box = Vector2(0,0)
	var angle = rand_range(0, 2*PI)
	set_pos( box +  (Vector2(sin(angle), cos(angle)) * 200) )
	set_rot(angle - PI * rand_range(1,3)/2)



# get all different properties from this ship
func get_property(type):

	# if null, return all properties
	if (type == null):
		return properties

	if (type in properties) :
		return properties[type]
	else :
		return null

func set_property(type, value):
	if (type in properties) :
		properties[type] = value

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

func destroy(destroyer):
	#get_node("destroyable").destroy(destroyer)
	get_node(global.scene_tree_ship_locator).free_ship(self)
	# free is called in destroyable

func processCollision(obstacle):

	if(obstacle.is_in_group(global.groups.enemy) or obstacle.is_in_group(global.groups.player)) :
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