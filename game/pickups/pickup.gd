extends Area2D

var properties

func _ready():

	"""
	properties = {
		global.properties.movement_speed_forward: 4000,
		global.properties.movement_speed_back: 2000,
		global.properties.ship_rotation_speed: 1,
		global.properties.zoom_speed: 0.2,
		global.properties.health_max: 1000,
		global.properties.health: 1000,
		global.properties.bullet_speed: 800,
		global.properties.bullet_strength: 50,
		global.properties.bullet_wait: 0.3,
		global.properties.bullet_range: 1000,
		global.properties.weapon_rotation_speed: 1.5,
		global.properties.clearance_rotation: 0.05,
	}
	"""

	properties = {
		# weapon, modifier
		global.properties.pickup_type: 1,
		 # set, add, multiply
		global.properties.pickup_modifier_mode: 2,
		# seconds
		global.properties.pickup_duration: 60
	}
