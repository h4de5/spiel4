#extends "res://game/ship/baseship.gd"
extends RigidBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var delta_count = 0
var delta_max = 0.2
var speed = 1
#export (NodePath) var health_label
var health_obj

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_fixed_process(true)
	randomize();
	speed = rand_range(2,5)
	add_to_group("enemy")
	
	var screensize = Vector2(Globals.get("display/width"),Globals.get("display/height"))
	var angle = rand_range(0, 2*PI)
	set_pos((screensize / 2) +  (Vector2(sin(angle), cos(angle)) * 200) )
	set_rot(angle - PI * rand_range(1,3)/2)
	
	var health_scn = load(global.scene_path_healthbar)
	var health_node = health_scn.instance()
	get_parent().call_deferred("add_child", health_node, true)
	
	health_node.target_obj = self
	health_obj = health_node
	
	#print ("lerp", lerp(2, 5, speed))
	#get_node("Sprite").set_modulate(Color(lerp(2, 5, speed), 0, 0))

func _fixed_process(delta):
	processMovement(delta)

func processMovement(delta):
	
	delta_count += delta
	if delta_count > delta_max :
		var tree = get_tree()
		var scene = tree.get_current_scene()
		var player 
		var playerpos
		
		player = ship_locator.get_next_player( get_pos() )
		if (player) : 
			playerpos = player.get_pos()
		
			var obstaclepos = get_pos();
			var obstaclerot = get_rot();
			
			var forwardvec = Vector2(sin(get_rot()), cos(get_rot()))*-1 * speed/5
			var playervec = (playerpos - obstaclepos).normalized()
			
			var angle = playervec.angle_to(forwardvec)
			set_angular_velocity(angle)
			apply_impulse(Vector2(0,0), forwardvec)

	#add_force( get_pos(), movevector )
	#apply_impulse(Vector2(0,0), movevector)


func processCollision(impact):
	
	#print("processCollision ", obstacle.get_name(), obstacle_vel, get_linear_velocity(), impact)
	#if health_label != "" and get_node(health_label) != null: 
	#	get_node(health_label).changeHealth(-abs(impact) / 30000);
	#	if get_node(health_label).getHealth() <= 0 :
	#		free()
	if health_obj != null: 
		health_obj.changeHealth(-abs(impact) / 30000);
		if health_obj.getHealth() <= 0 :
			free()
	
	