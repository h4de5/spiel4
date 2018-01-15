extends RigidBody2D

var properties
var properties_base = {
	global.properties.health_max: 2000,
	global.properties.health: 2000
}

func _ready():
	properties = interface.collect_properties(self)
	initialize()
	get_node('processor_selector').set_processor("AI")
	# only to be called in inherited classes
	#fix_collision_shape()

# get all different properties from this ship
func get_property(type) :
	# if null, return all properties
	if (type == null) :
		return properties
	if (type in properties) :
		return properties[type]
	else :
		return null

func set_property(type, value):
	if (type in properties) :
		properties[type] = value

func initialize() :
	set_fixed_process(true)
	set_max_contacts_reported(4)

	set_mass(500)
	set_weight(500)
	set_friction(1)
	set_bounce(1.0)
	set_gravity_scale(0)
	set_linear_damp(5)
	set_angular_damp(4)

	set_max_contacts_reported(4)
	connect("body_enter", self, "processCollision")

	reset_position()

	# add to group enemy
	add_to_group(global.groups.enemy)

	# register to locator
	object_locator.register_ship(self)

# called to reset a position, usually after initialize
func reset_position() :
	object_locator.get_random_pos(300, [self])

# see https://github.com/godotengine/godot/issues/2314
# and . https://github.com/godotengine/godot/issues/8103
func fix_collision_shape():
	for shape in get_children():
		if not shape extends CollisionShape2D and not shape extends CollisionPolygon2D:
			continue
		if shape.has_meta("__registered") and shape.get_meta("__registered"):
			continue

		get_tree().set_editor_hint(true)

		remove_child(shape) # Make it pick up the editor hint
		add_child(shape)

		get_tree().set_editor_hint(false) # Unset quickly

		if shape extends CollisionShape2D: # Now update parent is working, so just change the shape
			shape.set_shape(shape.get_shape())
		elif shape extends CollisionPolygon2D:
			shape.set_polygon(shape.get_polygon())

		remove_child(shape) # Reset its editor hint cache, just in case it was needed.. (you might drop this part if it bottlenecks)
		add_child(shape)

		shape.set_meta("__registered", true)

func destroy(destroyer):
	#get_node("destroyable").destroy(destroyer)
	object_locator.free_ship(self)
	# free is called in destroyable
	get_node(global.scene_tree_game).spawn_tower()
