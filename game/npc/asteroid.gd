extends "res://game/bases/base.gd"

# baseship._ready > player.init > baseship.init > player._ready
func _ready():
	# only to be called in inherited classes
	fix_collision_shape()
	# merges properties from all sub-nodes
	properties = interface.collect_properties(self)

func initialize() :
	.initialize()
	properties_base = {
		global.properties.health_max: 2000,
		global.properties.health: 2000
	}

	set_mass(5000)
	set_weight(5000)
	set_friction(1)
	set_bounce(5.0)
	set_gravity_scale(0)
	set_linear_damp(0)
	set_angular_damp(0)

	# register to locator
	# add to group enemy
	register_object(global.groups.obstacle)
	# make the AI stear it
	#get_node('processor_selector').set_processor("AI")


# called to reset a position, usually after initialize
func reset_position() :
	set_pos(object_locator.get_random_pos(500, [self]))
	var x = rand_range(-90, 90)
	var y = rand_range(-90, 90)
	var r = rand_range(-2, 2)
	apply_impulse(Vector2(0,0), Vector2(x, y))
	set_angular_velocity(r)

func destroy(destroyer):
	#get_node("destroyable").destroy(destroyer)
	object_locator.free_ship(self)
	# free is called in destroyable
	get_node(global.scene_tree_game).spawn_object(global.scene_path_asteroid, "objects")
