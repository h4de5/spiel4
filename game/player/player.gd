extends "res://game/baseship.gd"

func _ready():
	
	properties = {
		global.properties.movement_speed_forward: 700,
		global.properties.movement_speed_back: 3,
		global.properties.rotation_speed: 1.5,
		global.properties.bullet_speed: 1000,
		global.properties.bullet_strength: 50,
		global.properties.health: 1000
	}
	
	get_node("Processors").set_processor("Input")
	get_node("Processors").get_processor().set_parent(self)
	
	fix_collision_shape()

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