# AI that controlls a ship by sending commands to moveable and shootable interface

extends "res://game/processor/processor.gd"

var delta_count = 0
var delta_max = 1
var weapon = null

# TODO: make different AI modes
# follow: using minimal and maximal proximity
# guard: fly around a given point or object
# flee: try to flee from a predator object
# make it possible to switch between those modes

func _ready() :
	set_physics_process(true)

func initialize():
	.initialize()
	if shootable :
		weapon = shootable.get_active_weapon()

func _physics_process(delta) :
	delta_count += delta
	if delta_count > delta_max :

		# current object position
		var ownpos = parent.get_position();
		var ownrot = parent.get_rotation();
		# TODO check if this and targetangle def change have worked
		var ownvec = Vector2(sin(ownrot), cos(ownrot))*-1
		# moving vector according to rotation
		#var ownvec = Vector2(sin(ownrot), cos(ownrot))

		# target position, rotation and vector
		# node
		var target_moveto
		# node
		var target_shootat
		# vector2
		var targetpos
		# where should the current not be moved to
		# vector2
		var moving_vector

		if moveable :
			target_moveto = find_target_moveto( ownpos, ownrot )

		if shootable:
			target_shootat = find_target_shootat( ownpos, ownrot )

		if target_moveto :

			# get target position
			targetpos = target_moveto.get_position()
			# own position to target vector2
			# if set,
			moving_vector = (targetpos - ownpos).normalized()

			# moved after clearance check
#			if moving_vector != null :
#				moveable.handle_action( global.actions.accelerate, true )
#			elif moveable:
#				moveable.handle_action( global.actions.accelerate, false )

			# where do i have to turn to?
			var targetangle = moving_vector.angle_to(ownvec)
			#var targetangle = ownvec.angle_to(moving_vector)

			#print("ai movment angle", angle)
			if (targetangle > parent.get_property(global.properties.clearance_rotation)) :
				moveable.handle_action( global.actions.right, true )
			elif (targetangle < -parent.get_property(global.properties.clearance_rotation)) :
				moveable.handle_action( global.actions.left, true )
			else :
				moveable.handle_action( global.actions.right, false )
				moveable.handle_action( global.actions.left, false )
				# only accelerate if ship is directed towards user,
				# prevent never ending spiral
				moveable.handle_action( global.actions.accelerate, true )

		elif moveable:
			moveable.handle_action( global.actions.accelerate, false )
			moveable.handle_action( global.actions.back, false )
			moveable.handle_action( global.actions.left, false )
			moveable.handle_action( global.actions.right, false )

		if target_shootat :

			var bulletrange = parent.get_property(global.properties.bullet_range)

			# get target position
			targetpos = target_shootat.get_position()

			# get projected position of player
			# add velocity
			#targetpos = targetpos + target_shootat.get_linear_velocity()

			# correcting distance and bullet speed
			# je weiter weg und je langsamer die kugel
			# desto höher muss der anpassungsvector sein
			var bulletspeed = parent.get_property(global.properties.bullet_speed)
			var targetdistance = ownpos.distance_to(targetpos)
			var adjustmentvec = target_shootat.get_linear_velocity()
			adjustmentvec = adjustmentvec * targetdistance / bulletspeed
			targetpos = targetpos + adjustmentvec
			# make target visible
			#target_shootat.get_node("projected").set_global_pos(targetpos)

			# own position to target vector2
			var shooting_vector = (targetpos - ownpos).normalized()

			# HACK TODO - AI should not call handle_mousemove
			shootable.handle_mousemove(targetpos)

			# stop accelerating if AI is too close
			# only when moving and shooting target are the same
			if (moving_vector != null and
				target_moveto == target_shootat and
				ownpos.distance_to(targetpos) < bulletrange * 2/3):

				moving_vector = null
				moveable.handle_action( global.actions.accelerate, false )

			#var weapon = parent.get_node("weapons_selector").get_active_weapon()

			var weaponrot = weapon.get_weapon_rotation()

			var weaponvec = Vector2(sin(weaponrot), cos(weaponrot))*-1
			var targetangle = shooting_vector.angle_to(weaponvec)
			#var weaponvec = Vector2(sin(weaponrot), cos(weaponrot))
			#var targetangle = weaponvec.angle_to(shooting_vector)

			var shoot = false

			# weapon adjustment
			if (abs(targetangle) < parent.get_property(global.properties.clearance_rotation) and
				ownpos.distance_to(targetpos) < bulletrange) :

				# shoot only when there is no other enemy in between
				# In code, for 2D spacestate, this code must be used:
				var space_state = parent.get_world_2d().get_direct_space_state()
				# use global coordinates, not local to node
				# 7 .. layer 1, 2 and 3 (binary 1+2+4)

				var collision_settings = global.collision_layer_masks[parent.main_group]
				var raycast_hits = space_state.intersect_ray( ownpos, targetpos, [parent], collision_settings[1])

				#draw_line.update_line(parent, ownpos, targetpos)

				if not raycast_hits.empty():
					#print ("raycasts ", raycast_hits)

					#if not raycast_hits.collider.is_in_group(global.groups.npc) :
					if raycast_hits.collider.is_in_group(global.groups.player) :
						shoot = true
					#print ("raycast from ", parent.get_name(), " would hit ", raycast_hits.collider.get_name(), " in groups ", raycast_hits.collider.get_groups(), " shoot ", shoot)
				else:
					shoot = true

			if shoot :
				shootable.handle_action( global.actions.fire, true)
			else:
				shootable.handle_action( global.actions.fire, false )

		elif shootable:
			shootable.handle_action( global.actions.target_left, false )
			shootable.handle_action( global.actions.target_right, false )
			shootable.handle_action( global.actions.fire, false )


func find_target_moveto( ownpos, ownrot ):
	var pickup
	pickup = object_locator.get_next_object( global.groups.pickup, ownpos, ownrot )

	# if there is a pickup nearby, go there
	if pickup and ownpos.distance_to(pickup.get_position()) < 400:
		return pickup

	var player
	# only go for players in range
	player = object_locator.get_next_player( ownpos, ownrot )
	if player and ownpos.distance_to(player.get_position()) < 2000:
		return player

func find_target_shootat( ownpos, ownrot ):
	var player
	# only go for players in range
	player = object_locator.get_next_player( ownpos, ownrot )
	if player and ownpos.distance_to(player.get_position()) < 1500:
		return player