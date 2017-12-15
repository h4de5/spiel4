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
		
		player = ship_locator.get_next_player( ownpos )
		if (player) :
			
			playerpos = player.get_pos()
			
			var obstaclepos = ownpos;
			var obstaclerot = ownrot;
			
			var forwardvec = Vector2(sin(ownrot), cos(ownrot))*-1
			var playervec = (playerpos - obstaclepos).normalized()
			
			var angle = playervec.angle_to(forwardvec)
			print("ai movment angle", angle)
			if (angle > 0.03) :
				parent.handle_action( global.actions.right, true )
				parent.handle_action( global.actions.fire, false )
			elif (angle < -0.03) :
				parent.handle_action( global.actions.left, true )
				parent.handle_action( global.actions.fire, false ) 
			else :
				parent.handle_action( global.actions.right, false )
				parent.handle_action( global.actions.left, false )
				parent.handle_action( global.actions.fire, true ) 
			
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

