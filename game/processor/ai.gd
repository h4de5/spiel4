# AI that controlls a ship by sending commands to moveable and shootable interface

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
		var moveable = interface.is_moveable(parent)
		var forwardvec
		var angle
		var playervec

		player = get_node(global.scene_tree_ship_locator).get_next_player( ownpos, ownrot )
		if (player) :

			playerpos = player.get_pos()
			playervec = (playerpos - ownpos).normalized()

			if moveable:
				forwardvec = Vector2(sin(ownrot), cos(ownrot))*-1
				angle = playervec.angle_to(forwardvec)

				#print("ai movment angle", angle)
				if (angle > parent.get_property(global.properties.clearance_rotation)) :
					moveable.handle_action( global.actions.right, true )
				elif (angle < -parent.get_property(global.properties.clearance_rotation)) :
					moveable.handle_action( global.actions.left, true )
				else :
					moveable.handle_action( global.actions.right, false )
					moveable.handle_action( global.actions.left, false )

			# if shootable
			var shootable = interface.is_shootable(parent)
			if shootable:

				# HACK TODO - AI should not call handle_mousemove
				shootable.handle_mousemove(playerpos)

				# stop accelerating if AI is too close
				if ownpos.distance_to(playerpos) < parent.get_property(global.properties.bullet_range) * 1/2:
					forwardvec = Vector2(0,0)

				var weapon = parent.get_node("weapons_selector").get_active_weapon()

				#var target_rot = parent.get_node("weaponscope").get_global_pos().angle_to_point(playerpos)
				var target_rot = weapon.get_weapon_rotation()
				var weaponvec = Vector2(sin(target_rot), cos(target_rot))*-1
				angle = playervec.angle_to(weaponvec)

				# weapon adjustment
				if (abs(angle) < parent.get_property(global.properties.clearance_rotation) and
					ownpos.distance_to(playerpos) < parent.get_property(global.properties.bullet_range)) :

					# shoot only when there is no other enemy in between
					# In code, for 2D spacestate, this code must be used:
					var space_state = parent.get_world_2d().get_direct_space_state()
					# use global coordinates, not local to node
					var raycast_hits = space_state.intersect_ray( ownpos, playerpos, [parent])
					if not raycast_hits.empty():
						#print ("raycast_hits ", raycast_hits.collider.get_name())
						if not raycast_hits.collider.is_in_group(global.groups.enemy) :
							shootable.handle_action( global.actions.fire, true )
				else :
					shootable.handle_action( global.actions.fire, false )

			if moveable:
				if (forwardvec != null and forwardvec != Vector2(0,0)) :
					moveable.handle_action( global.actions.accelerate, true )
				else :
					moveable.handle_action( global.actions.accelerate, false )

			#set_angular_velocity(angle)
			#apply_impulse(Vector2(0,0), forwardvec)
		elif moveable:
			moveable.handle_action( global.actions.accelerate, false )
			moveable.handle_action( global.actions.back, false )
			moveable.handle_action( global.actions.left, false )
			moveable.handle_action( global.actions.right, false )
			moveable.handle_action( global.actions.target_left, false )
			moveable.handle_action( global.actions.target_right, false )
			moveable.handle_action( global.actions.fire, false )

