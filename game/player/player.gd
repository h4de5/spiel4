extends "res://game/baseship.gd"

func _ready():
	
	connect("body_enter", self, "processCollision")
	
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
	
	#var camera_scn = load(global.scene_path_camera)
	#var camera_node = camera_scn.instance()
	#add_child(camera_node)

func reset_position():
	var screensize = Vector2(Globals.get("display/width"), Globals.get("display/height"))
	set_pos(screensize / 2)

func processCollision(obstacle):
	
	if(obstacle.is_in_group('enemy') or obstacle.is_in_group('player')) :
		var obstacle_vel = obstacle.get_linear_velocity()
		var impact = get_linear_velocity().dot(obstacle_vel);
		#print("processCollision ", obstacle.get_name(), obstacle_vel, get_linear_velocity(), impact)
		health_obj.changeHealth(-abs(impact) / 20000);
		
		if health_obj.getHealth() <= 0: 
			get_tree().change_scene(global.scene_path_gameover)
		# process impact on obstacle
		obstacle.processCollision(impact)
		
		# now about where we hit it
		var player_pos = get_pos()
		var obstacle_pos = obstacle.get_pos()
		var hit_position = player_pos - obstacle_pos
		print("hitpos: ", player_pos.normalized())
		
		"""
		var raycast = RayCast(obstacle_pos)
		
		raycast.set_cast_to(player_pos)
		if raycast.is_colliding() : 
			print("get_collision_point: ", raycast.get_collision_point(), " get_collider: ", raycast.get_collider())
		"""

func shoot(path) :
	
	print("pos: ", get_pos())
	print("global pos: ", get_global_pos())
	
	#var shoot_scn = load("res://game/"+object+".tscn")
	var shoot_scn = load(path)
	var shoot_node = shoot_scn.instance()
	var player_pos = get_pos()
	
	#get_parent().call_deferred("add_child", shoot_node, true)
	get_parent().add_child(shoot_node)
	
	
	shoot_node.set_pos(player_pos)
	
