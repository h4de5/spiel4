extends Area2D

var properties
var properties_base = Dictionary()
var main_group
var scene_path

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

	collision_mask = collision_settings[1]
	collision_layer = collision_settings[0]

#	set_collision_mask(collision_settings[1])
#	set_layer_mask(collision_settings[0])

func destroy(destroyer):
	object_locator.free_object(self)

func collected(reason):
	object_locator.free_object(self)

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



remote func get_network_update():
	return [get_position()]

remote func set_network_update(packet):
	set_position(packet[0])