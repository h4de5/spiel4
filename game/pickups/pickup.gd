extends Area2D

var properties = {}
var properties_base = {
		# weapon, modifier, passenger, goods, bomb
		global.properties.pickup_type: 1,
		# pickup lasts seconds
		global.properties.pickup_duration: 30,
		# modifier lasts seconds
		global.properties.pickup_modifier_duration: 50,
	}
var collectable = null

func _ready():
	#set_fixed_process(true)

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

func reset_position():
	set_pos(get_node(global.scene_tree_ship_locator).get_random_pos(500, [self]))


func collected(reason):
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
		global.properties.modifier_add,
	]

	var p_index = randi() % property_pool.size()
	var m_index = randi() % property_modifier_pool.size()

	var value;
	if property_modifier_pool[m_index] == global.properties.modifier_multi:
		value = rand_range(0.8, 2.8)
	else:
		value = rand_range(-5, 5)

	properties_base[property_modifier_pool[m_index]] = {
		property_pool[p_index]: value
	}

