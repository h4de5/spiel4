extends Node2D

#	properties = {
#		global.properties.movement_speed_forward: 4000,
#		global.properties.movement_speed_back: 2000,
#		global.properties.ship_rotation_speed: 1,
#		global.properties.zoom_speed: 0.2,
#		global.properties.health_max: 1000,
#		global.properties.health: 1000,
#		global.properties.bullet_speed: 800,
#		global.properties.bullet_strength: 50,
#		global.properties.bullet_wait: 0.3,
#		global.properties.bullet_range: 1000,
#		global.properties.weapon_rotation_speed: 1.5,
#		global.properties.clearance_rotation: 0.05
#	}

var properties = {
	global.properties.modifier_add: {},
	global.properties.modifier_multi: {}
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


# if collectable was picket up and modifier runs out
func _on_timer_modifier_timeout():
	get_parent().remove_child(self)