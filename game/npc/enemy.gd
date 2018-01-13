# enemy baseship, controlled by AI processor
extends "res://game/ship/baseship.gd"

func _ready():

	reset_position()

	get_node('processor_selector').set_processor("AI")

	fix_collision_shape()

	#print("found properties enemy ", properties)

func destroy(destroyer):
	.destroy(destroyer)
	get_node(global.scene_tree_game).spawn_enemy()

func initialize() :

	# add to group enemy
	add_to_group(global.groups.enemy)

	# register to locator
	get_node(global.scene_tree_ship_locator).register_ship(self)

	# call baseship init
	.initialize()

func reset_position():
	.reset_position()

	# randomize speed and rotation
	#properties_base[global.properties.movement_speed_forward] *= rand_range(0.7,1.2)
	#properties_base[global.properties.movement_speed_back] *= rand_range(0.7,1.2)
	#properties_base[global.properties.ship_rotation_speed] *= rand_range(0.8,1.2)
	#properties_base[global.properties.weapon_rotation_speed] *= rand_range(0.5,1.0)