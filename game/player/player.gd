extends "res://game/ship/baseship.gd"

func _ready():

	properties[global.properties.movement_speed_forward] *= 1.2
	properties[global.properties.ship_rotation_speed] *= 5
	properties[global.properties.bullet_speed] *= 1.2

	fix_collision_shape()

func initialize() :

	# add to group player
	add_to_group(global.groups.player)

	# register to locator
	get_node(global.scene_tree_ship_locator).register_ship(self)

	# call baseship init
	.initialize()

func destroy(destroyer):

	var player_manager = get_node(global.scene_tree_player_manager)

	if(has_node("Processors/Input")) :
		var input_processor = get_node("Processors/Input")
		player_manager.unregister_device(input_processor.input_group, input_processor.device_id)

	.destroy(destroyer)


func reset_position():
	var screensize = Vector2(Globals.get("display/width"), Globals.get("display/height"))
	set_pos(screensize / 2)