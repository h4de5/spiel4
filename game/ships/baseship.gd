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
		global.properties.movement_speed_forward: 1000,
		global.properties.movement_speed_back: 850,
		global.properties.ship_rotation_speed: 7,
		global.properties.zoom_speed: 0.2,
		global.properties.health_max: 1000,
		global.properties.health: 1000,
		global.properties.body_scale: get_scale(),
		global.properties.body_scale_base: get_scale(), # Vector2(1,1),
	}

	set_mass(0.5)
	#set_inertia(0)
	#set_weight(500)
	set_friction(1)
	set_bounce(0.1)
	set_gravity_scale(0)
	# see moveable - will be reset on each frame
	set_linear_damp(3)
	set_angular_damp(30)

# called to reset a position, usually after initialize
func reset_position() :
	.reset_position()
	set_rotation(PI * rand_range(1,3)/2)
