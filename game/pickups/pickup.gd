extends Area2D

var properties
var collectable = null

func _ready():
	#set_fixed_process(true)

	properties = {
		# weapon, modifier, passenger, goods, bomb
		global.properties.pickup_type: 1,
		# pickup lasts seconds
		global.properties.pickup_duration: 30,
		 # set, add, multiply
		global.properties.pickup_modifier_mode: 2,
		# modifier lasts seconds
		global.properties.pickup_modifier_duration: 10,

		global.properties.modifier_multi: {
			global.properties.movement_speed_forward: 2,
		}
	}

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
