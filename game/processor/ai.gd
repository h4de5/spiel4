extends "res://game/processor/processor.gd"

var delta_count = 0
var delta_max = 0.2

func _ready() :
	set_fixed_process(true)

func set_parent(p) :
	parent = p

func _fixed_process(delta) :
	delta_count += delta
	if delta_count > delta_max :
		
		var player
		var playerpos
		var ownpos = parent.get_pos();
		var ownrot = parent.get_rot();
		
		player = get_node(global.scene_tree_ship_locator).get_next_player( ownpos, ownrot )
		if (player) :
			
			playerpos = player.get_pos()
			
			# HACK TODO - AI should not call handle_mousemove
			parent.handle_mousemove(playerpos)
			
			var obstaclepos = ownpos;
			var obstaclerot = ownrot;
			
			var forwardvec = Vector2(sin(ownrot), cos(ownrot))*-1
			var playervec = (playerpos - obstaclepos).normalized()
			var angle = playervec.angle_to(forwardvec)
			
			
			#print("ai movment angle", angle)
			if (angle > parent.rot_impreciseness) :
				parent.handle_action( global.actions.right, true )
			elif (angle < -parent.rot_impreciseness) :
				parent.handle_action( global.actions.left, true )
			else :
				parent.handle_action( global.actions.right, false )
				parent.handle_action( global.actions.left, false )
			
			
			#var target_rot = parent.get_node("weaponscope").get_global_pos().angle_to_point(playerpos)
			var target_rot = parent.get_node("weaponscope").get_global_rot()
			forwardvec = Vector2(sin(target_rot), cos(target_rot))*-1
			angle = playervec.angle_to(forwardvec)
			
			#print("angle", angle)
			if (abs(angle) < parent.rot_impreciseness and 
				ownpos.distance_to(playerpos) < parent.get_property(global.properties.bullet_range)) :
				parent.handle_action( global.actions.fire, true )
			else :
				parent.handle_action( global.actions.fire, false )
			
			if (forwardvec != Vector2(0,0)) :
				parent.handle_action( global.actions.accelerate, true )
			else :
				parent.handle_action( global.actions.accelerate, false )
			
			#set_angular_velocity(angle)
			#apply_impulse(Vector2(0,0), forwardvec)
		else :
			parent.handle_action( global.actions.accelerate, false )
			parent.handle_action( global.actions.back, false )
			parent.handle_action( global.actions.left, false )
			parent.handle_action( global.actions.right, false )
			parent.handle_action( global.actions.target_left, false )
			parent.handle_action( global.actions.target_right, false )
			parent.handle_action( global.actions.fire, false )

