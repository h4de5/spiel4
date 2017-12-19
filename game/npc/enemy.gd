extends "res://game/ship/baseship.gd"

func _ready():
	
	reset_position()
	
	set_processor("AI")
	
	fix_collision_shape()

func destroy(destroyer):
	.destroy(destroyer)
	get_node(global.scene_tree_game).spawn_enemy()

func initialize() :
	
	# add to group player
	add_to_group(global.groups.enemy)
	
	# register to locator
	get_node(global.scene_tree_ship_locator).register_ship(self)
	
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
	properties[global.properties.ship_rotation_speed] = rand_range(1,3)
	
	
	#multi_forward = rand_range(300,550)
	#multi_break = rand_range(2,4)
	#multi_rot = rand_range(1,3)