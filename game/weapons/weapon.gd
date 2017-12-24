extends Node

var properties = {
	global.properties.bullet_speed: 800,
	global.properties.bullet_strength: 50,
	global.properties.bullet_wait: 0.3,
	global.properties.bullet_range: 1000,
	global.properties.weapon_rotation_speed: 3.5,
	global.properties.clearance_rotation: 0.05,
}

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