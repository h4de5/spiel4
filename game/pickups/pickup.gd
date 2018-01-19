extends Area2D

var properties = {}
var properties_base = {
		# modifier, weapon, passenger, goods, bomb
		global.properties.pickup_type: global.pickup_types.modifier,
		# pickup lasts seconds
		global.properties.pickup_duration: 30,
		# modifier lasts seconds
		global.properties.pickup_modifier_duration: 50,
	}
var collectable = null

func _ready():
	#set_fixed_process(true)

	# add to correct group
	add_to_group(global.groups.pickup)

	set_random_modifier()
	# merges properties from all sub-nodes
	properties = interface.collect_properties(self)

	reset_position()
	call_deferred("initialize")


# get all different properties from this ship
func get_property(type) :
	# if null, return all properties
	if (type == null) :
		return properties
	if (type in properties) :
		return properties[type]
	else :
		return null


func initialize():
	collectable = interface.is_collectable(self)
	# register to locator
	object_locator.register_object(self)

	var collision_settings = global.collision_layer_masks[global.groups.pickup]

	# missing documentation about those two methods
	# [0] .. should be collision.layers (on which layer is the object)
	# [1] .. should be collision.mask (with which layers can the object collide)
	set_collision_mask(collision_settings[0])
	set_layer_mask(collision_settings[1])

func reset_position():
	set_pos(object_locator.get_random_pos(500, [self]))

func collected(reason):
	#get_node("destroyable").destroy(destroyer)
	object_locator.free_object(self)

	# free is called in collectable
	# spawn another pickup
	get_node(global.scene_tree_game).spawn_pickup()

func set_random_modifier():
	randomize()
	var property_pool = [
		global.properties.movement_speed_forward,
		global.properties.movement_speed_back,
		global.properties.ship_rotation_speed,
		global.properties.weapon_rotation_speed,
		global.properties.bullet_speed,
		global.properties.bullet_strength,
		global.properties.bullet_wait,
		global.properties.bullet_range,
	]
	var property_modifier_pool = [
		global.properties.modifier_multi,
		# problem: there is not validation range for possible values
		# will end up e.g. with rotation_speed < 0
		#global.properties.modifier_add,
	]

	var p_index = randi() % property_pool.size()
	var m_index = randi() % property_modifier_pool.size()

	var value;
	if property_modifier_pool[m_index] == global.properties.modifier_multi:
		value = rand_range(0.8, 2.0)
	else:
		value = rand_range(-5, 5)

	#this will recolor all progressbars -
	if(value < 1) :
		get_node("collectable/payload").revamp_progress(Color("#f86847"))
	#else:
	#	get_node("collectable/payload").revamp_progress(Color("#30f030"))

	properties_base[property_modifier_pool[m_index]] = {
		property_pool[p_index]: value
	}

