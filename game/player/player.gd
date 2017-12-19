extends "res://game/baseship.gd"

func _ready():
	
	properties[global.properties.movement_speed_forward] *= 1.2
	properties[global.properties.ship_rotation_speed] *= 1.2
	properties[global.properties.bullet_speed] *= 1.2
	
	fix_collision_shape()

func initialize() :
	
	# add to group player
	add_to_group("player")
	
	# register to locator
	ship_locator.register_ship(self)
	
	# call baseship init
	.initialize()
	
func destroy(destroyer):
	
	var player_manager = get_node("/root/Game/player_manager")
	var input_processor = get_node("Processors/Input")
	
	if(input_processor != null) :
		player_manager.unregister_device(input_processor.input_group, input_processor.device_id)
	
	.destroy(destroyer)
	

func reset_position():
	var screensize = Vector2(Globals.get("display/width"), Globals.get("display/height"))
	set_pos(screensize / 2)