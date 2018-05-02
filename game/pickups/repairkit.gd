extends "res://game/bases/basearea.gd"

var object_group = global.groups.pickup
var collectable = null

func _ready():
	# only to be called in inherited classes
	#fix_collision_shape()

	# generate random modifiers
	set_random_modifier()
	# merges properties from all sub-nodes
	properties = interface.collect_properties(self)

func initialize() :
	.initialize()
	properties_base = {
		# modifier, weapon, passenger, goods, bomb
		global.properties.pickup_type: global.pickup_types.goods,
		# pickup lasts seconds
		global.properties.pickup_duration: 30,
		# modifier lasts seconds
		global.properties.pickup_modifier_duration: 1,
	}

	# register to locator
	# add to group enemy
	register_object(object_group)

	collectable = interface.is_collectable(self)

func collected(reason):
	.collected(reason)
	# free is called in collectable
	# spawn another pickup
	get_node(global.scene_tree_game).spawn_object(global.scene_path_repairkit)

func set_random_modifier():
	randomize()
	var property_pool = [
		global.properties.health,
		global.properties.health_max,
	]
	var property_modifier_pool = [
		#global.properties.modifier_multi,
		global.properties.modifier_add,
	]

	var p_index = randi() % property_pool.size()
	var m_index = randi() % property_modifier_pool.size()

	var value;
	# randomize between 50 and 200
	value = (randi() % 4 + 1) * 50

	properties_base[property_modifier_pool[m_index]] = {
		property_pool[p_index]: value
	}

