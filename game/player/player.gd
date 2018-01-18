# player baseship, has Input processor
extends "res://game/ship/baseship.gd"

func _ready():
	print("ready player")
	# merges properties from all sub-nodes
#	properties = interface.collect_properties(self)

#	properties[global.properties.movement_speed_forward] *= 1.2
#	properties[global.properties.ship_rotation_speed] *= 2
#	#properties[global.properties.bullet_speed] *= 2
#	properties[global.properties.bullet_wait] /= 2
#	properties[global.properties.weapon_rotation_speed] *= 2


	fix_collision_shape()

func initialize() :
	print("initialize player")
	.initialize()

	properties_base[global.properties.modifier_add] = {
		global.properties.movement_speed_forward: 1000,
	}

	register_object(global.groups.player)
	# register to locator
	#object_locator.register_ship(self)

func destroy(destroyer):
	var player_manager = get_node(global.scene_tree_player_manager)

	if(has_node("processor_selector/Input")) :
		var input_processor = get_node("processor_selector/Input")
		player_manager.unregister_device(input_processor.input_group, input_processor.device_id)

	.destroy(destroyer)

