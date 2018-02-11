extends "res://game/bases/basearea.gd"


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
		global.properties.pickup_type: global.pickup_types.modifier,
		# pickup lasts seconds
		global.properties.pickup_duration: 30,
		# modifier lasts seconds
		global.properties.pickup_modifier_duration: 50,
	}

	# register to locator
	# add to group enemy
	register_object(global.groups.pickup)

	collectable = interface.is_collectable(self)

func collected(reason):
	.collected(reason)
	# free is called in collectable
	# spawn another pickup
	#get_node(global.scene_tree_game).spawn_pickup()

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

