extends Area2D

var properties
var collectable = null

func _ready():
	#set_fixed_process(true)
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
		# weapon, modifier, passenger, goods, bomb
		global.properties.pickup_type: 1,
		# pickup lasts seconds
		global.properties.pickup_duration: 10,
		 # set, add, multiply
		global.properties.pickup_modifier_mode: 2,
		# modifier lasts seconds
		global.properties.pickup_modifier_duration: 60,
	}

	connect("body_enter", self, "process_collect")

	call_deferred("initialize")

func initialize():
	collectable = interface.is_collectable(self)

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

func process_collect(body):
	#print("something entered pickup body ", body)

	if collectable :
		collectable.collect(body)
	else :
		print ("pickup is not a collectable ", self)
