extends "res://game/baseship.gd"

func _ready():
	
	properties[global.properties.movement_speed_forward] = 700
	properties[global.properties.ship_rotation_speed] = 1.5
	properties[global.properties.bullet_speed] = 1000
	
	fix_collision_shape()
	
func set_processor(processor):
	get_node("Processors").set_processor(processor)
	get_node("Processors").get_processor().set_parent(self)

func set_processor_details(device_details):
	get_node("Processors").get_processor().set_processor_details(device_details)
	
	

func initialize() :
	
	# add to group player
	add_to_group("player")
	
	# register to locator
	ship_locator.register_ship(self)
	
	# call baseship init
	.initialize()
	

func reset_position():
	var screensize = Vector2(Globals.get("display/width"), Globals.get("display/height"))
	set_pos(screensize / 2)