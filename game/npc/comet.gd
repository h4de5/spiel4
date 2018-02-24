extends "res://game/bases/base.gd"

func _ready():
	# only to be called in inherited classes
	fix_collision_shape()
	# merges properties from all sub-nodes
	properties = interface.collect_properties(self)

func initialize() :
	.initialize()
	properties_base = {
		global.properties.health_max: 400,
		global.properties.health: 400
	}

	set_mass(2000)
	set_weight(2000)
	set_bounce(0.0)
	set_friction(0)
	set_gravity_scale(0)
	set_linear_damp(0.1)
	set_angular_damp(0)

	# register to locator
	# add to group enemy
	register_object(global.groups.obstacle)
	# make the AI stear it
	#get_node('processor_selector').set_processor("AI")


# called to reset a position, usually after initialize
func reset_position() :
	set_position(object_locator.get_random_pos(300, [self]))
	var x = rand_range(-90, 90)
	var y = rand_range(-90, 90)
	var r = rand_range(-2, 2)
	apply_impulse(Vector2(0,0), Vector2(x, y))
	set_angular_velocity(r)
	call_deferred("randomize_size")

func randomize_size():
	var resizeable = interface.is_resizeable(self)
	if resizeable: 
		var x = rand_range(0.8, 3)
		resizeable.resize_body_to(Vector2(x,x))

func destroy(destroyer):
	#get_node("destroyable").destroy(destroyer)
	object_locator.free_object(self)
	# free is called in destroyable
	#get_node(global.scene_tree_game).spawn_object(global.scene_path_asteroid, "objects")


