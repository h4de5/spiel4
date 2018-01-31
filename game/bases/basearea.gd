extends Area2D

var properties
var properties_base = Dictionary()
var main_group

func _ready():
	# merges properties from all sub-nodes
	properties = interface.collect_properties(self)
	initialize()

func initialize() :
	#set_max_contacts_reported(1)
	#connect("body_enter", self, "process_collision")
	reset_position()

# called to reset a position, usually after initialize
func reset_position() :
	set_position(object_locator.get_random_pos(800, [self]))

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
	# [1] .. is collision.layers (on which layer is the object)
	# [0] .. is collision.mask (with which layers can the object collide)
	#set_collision_mask(collision_settings[1])
	#set_layer_mask(collision_settings[0])

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


# see https://github.com/godotengine/godot/issues/2314
# and . https://github.com/godotengine/godot/issues/8103
func fix_collision_shape():
	for shape in get_children():
		#if not shape extends CollisionShape2D and not shape extends CollisionPolygon2D:
		if not shape is CollisionPolygon2D:
			continue
		if shape.has_meta("__registered") and shape.get_meta("__registered"):
			continue

		get_tree().set_editor_hint(true)

		remove_child(shape) # Make it pick up the editor hint
		add_child(shape)

		get_tree().set_editor_hint(false) # Unset quickly

		#if shape extends CollisionShape2D: # Now update parent is working, so just change the shape
		#	shape.set_shape(shape.get_shape())
		if shape is CollisionPolygon2D:
			shape.set_polygon(shape.get_polygon())

		remove_child(shape) # Reset its editor hint cache, just in case it was needed.. (you might drop this part if it bottlenecks)
		add_child(shape)

		shape.set_meta("__registered", true)