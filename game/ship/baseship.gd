# base class for all ships, has all interfaces and properties
extends "res://game/bases/base.gd"

# baseship._ready > player.init > baseship.init > player._ready
func _ready():
	#print("ready baseship")
	# merges properties from all sub-nodes
	properties = interface.collect_properties(self)

func initialize() :
	#print("initialize baseship")
	.initialize()
	properties_base = {
		global.properties.movement_speed_forward: 4000,
		global.properties.movement_speed_back: 2000,
		global.properties.ship_rotation_speed: 2,
		global.properties.zoom_speed: 0.2,
		global.properties.health_max: 1000,
		global.properties.health: 1000
	}

	set_mass(50)
	set_weight(50)
	set_friction(1)
	set_bounce(0.5)
	set_gravity_scale(0)
	set_linear_damp(2)
	set_angular_damp(4)

# called to reset a position, usually after initialize
func reset_position() :
	.reset_position()
	set_rot(PI * rand_range(1,3)/2)

func destroy(destroyer):
	#get_node("destroyable").destroy(destroyer)
	object_locator.free_ship(self)
	# free is called in destroyable