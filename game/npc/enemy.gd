extends "res://game/baseship.gd"

func _ready():
	properties[global.properties.movement_speed_forward] = rand_range(300,550)
	properties[global.properties.movement_speed_back] = rand_range(2,4)
	properties[global.properties.rotation_speed] = rand_range(1,3)
	
	#connect("body_enter", self, "processCollision")
	
	get_node("Processors").set_processor("AI")
	get_node("Processors").get_processor().set_parent(self)
	
	fix_collision_shape()


func initialize() :
	
	# add to group player
	add_to_group("enemy")
	
	# register to locator
	ship_locator.register_ship(self)
	
	# call baseship init
	.initialize()

func reset_position():
	randomize();
	
	var screensize = Vector2(Globals.get("display/width"),Globals.get("display/height"))
	var angle = rand_range(0, 2*PI)
	set_pos((screensize / 2) +  (Vector2(sin(angle), cos(angle)) * 200) )
	set_rot(angle - PI * rand_range(1,3)/2)

	# randomize speed and rotation
	properties[global.properties.movement_speed_forward] = rand_range(300,550)
	properties[global.properties.movement_speed_back] = rand_range(2,4)
	properties[global.properties.rotation_speed] = rand_range(1,3)
	
	
	#multi_forward = rand_range(300,550)
	#multi_break = rand_range(2,4)
	#multi_rot = rand_range(1,3)