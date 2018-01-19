extends RigidBody2D

var properties
var properties_base = Dictionary()
var main_group

# call order:
# ready base
# initialize player from base
# initialize baseship from player
# initialize base from baseship
# ready baseship
# ready player
func _ready():
	print("ready base")
	# merges properties from all sub-nodes
	properties = interface.collect_properties(self)
	initialize()

func initialize() :
	print("initialize base")
	set_max_contacts_reported(4)
	connect("body_enter", self, "process_collision")
	reset_position()

# called to reset a position, usually after initialize
func reset_position() :
	set_pos(object_locator.get_random_pos(800, [self]))

# adds object to specific group, add its to the object_locator
# and sets collision layers and mask
func register_object(group):

	main_group = group
	# add to group player
	add_to_group(group)
	# register to locator
	object_locator.register_object(self)
	# returns array with mask and layer
	var collision_settings = global.collision_layer_masks[group]

	# missing documentation about those two methods
	# [0] .. should be collision.layers (on which layer is the object)
	# [1] .. should be collision.mask (with which layers can the object collide)
	set_collision_mask(collision_settings[0])
	set_layer_mask(collision_settings[1])

func destroy(destroyer):
	pass
func collected(reason):
	pass

# get all different properties from this ship
func get_property(type) :
	# if null, return all properties
	if (type == null) :
		return properties
	if (type in properties) :
		return properties[type]
	else :
		return null
func set_property(type, value):
	if (type in properties) :
		properties[type] = value

# not yet in use
func process_collision(obstacle):
	if(obstacle.is_in_group(global.groups.npc) or obstacle.is_in_group(global.groups.player)) :
		var obstacle_vel = obstacle.get_linear_velocity()
		var impact = get_linear_velocity().dot(obstacle_vel);
		#print("processCollision ", obstacle.get_name(), obstacle_vel, get_linear_velocity(), impact)
		#health_obj.changeHealth(-abs(impact) / 20000);

		#if health_obj.getHealth() <= 0:
		#	get_tree().change_scene(global.scene_path_gameover)
		# process impact on obstacle
		#obstacle.process_collision(impact)

		# now about where we hit it
		var player_pos = get_pos()
		var obstacle_pos = obstacle.get_pos()
		var hit_position = player_pos - obstacle_pos
		#print("hitpos: ", player_pos.normalized())

		"""
		var raycast = RayCast(obstacle_pos)

		raycast.set_cast_to(player_pos)
		if raycast.is_colliding() :
			print("get_collision_point: ", raycast.get_collision_point(), " get_collider: ", raycast.get_collider())
		"""

# see https://github.com/godotengine/godot/issues/2314
# and . https://github.com/godotengine/godot/issues/8103
func fix_collision_shape():
	for shape in get_children():
		#if not shape extends CollisionShape2D and not shape extends CollisionPolygon2D:
		if not shape extends CollisionPolygon2D:
			continue
		if shape.has_meta("__registered") and shape.get_meta("__registered"):
			continue

		get_tree().set_editor_hint(true)

		remove_child(shape) # Make it pick up the editor hint
		add_child(shape)

		get_tree().set_editor_hint(false) # Unset quickly

		#if shape extends CollisionShape2D: # Now update parent is working, so just change the shape
		#	shape.set_shape(shape.get_shape())
		if shape extends CollisionPolygon2D:
			shape.set_polygon(shape.get_polygon())

		remove_child(shape) # Reset its editor hint cache, just in case it was needed.. (you might drop this part if it bottlenecks)
		add_child(shape)

		shape.set_meta("__registered", true)