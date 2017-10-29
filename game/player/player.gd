extends "res://game/baseship.gd"

"""
# acceleration and rotation speed
var multi_forward = 60
var multi_rot = 0.05
var health_obj
var zoom = 1
var multi_zoom = 0.2
"""

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	
	#set_processor();
	
	#set_fixed_process(true)
	#set_process_input(true)
	set_max_contacts_reported(4)
	
	add_to_group("player")
	
	var screensize = Vector2(Globals.get("display/width"), Globals.get("display/height"))
	set_pos(screensize / 2)
	
	var health_scn = load(global.scene_path_healthbar)
	var health_node = health_scn.instance()
	
	get_parent().call_deferred("add_child", health_node, true)
	
	health_node.target_obj = self
	health_obj = health_node
	
	var camera_scn = load(global.scene_path_camera)
	var camera_node = camera_scn.instance()
	add_child(camera_node)
	
	connect("body_enter", self, "processCollision")
	

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

func shoot(object) :
	var shoot_scn = load("res://game/"+object+".tscn")
	var shoot_node = shoot_scn.instance()
	var player_pos = get_pos()
	
	get_parent().call_deferred("add_child", shoot_node, true)
	
	shoot_node.set_pos(player_pos)
	
