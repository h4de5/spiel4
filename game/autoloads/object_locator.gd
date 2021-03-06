# lists of all active ships in game, gets nearest ship, sets zoom to bounding box
extends Node2D

var objects_registered = {}

var camera_focus_on_group = [
	global.groups.player,
	global.groups.npc,
	#global.groups.pickup
]

func _ready():
	set_physics_process(true)
	#set_fixed_process(true)

func register_ship( ship ):
	register_object( ship )
func free_ship(ship) :
	free_object(ship)

func register_object( object ):

	#print("register_object ", object , " as ", object.get_groups())

	# returns first group of object
	#var group = object.get_groups().back()
	var object_groups = object.get_groups()
	var group
	for global_group in global.groups:
		if object_groups.has(global_group):
			group = global_group
			break
	if (group) :
		if (objects_registered.has(group)) :
			objects_registered[group].append(object)
		else :
			objects_registered[group] = [object]

func free_object(object) :
	var object_groups = object.get_groups()
	for group in global.groups:
		if object_groups.has(group):
			objects_registered[group].erase(object)
			break


func get_next_player( pos, rot ) :
	return get_next_ship(global.groups.player, pos, rot)

func get_next_ship( group, pos, rot ):
	return get_next_object( group, pos, rot)

func get_next_object( group, pos, rot ):
	# return first object of given group
	if (objects_registered.has(group)) and objects_registered[group].size() > 0:
		var dist = null
		var closest
		# where am i currently locking at
		var current_look_dir = Vector2(sin(rot + PI), cos(rot)).normalized()

		for object in objects_registered[group]:

			var direction_of_object = object.get_global_position() - pos
			# where should i look at
			var angle_diff = current_look_dir.angle_to(direction_of_object)
			#  the more the angle differs, the farer the target object is away ..
			var estimated_distance_for_turn = abs(angle_diff) * 0.1

			if dist == null or dist > pos.distance_to(object.get_global_position()) + estimated_distance_for_turn:
				dist = pos.distance_to(object.get_global_position()) + estimated_distance_for_turn
				closest = object

		return closest #objects_registered[group].front()
	else :
		return null


	# return players[0]

# todo - check if we move it in _process or _physics_process
func _process(delta):
	set_camera()

# Return a bound box that includes all objects_registered
func get_bounding_box(group, excludes = []) :
	var objectv
	var box

	if objects_registered.has(group):
		for object in objects_registered[group]:
			if excludes.has(object):
				continue
			objectv = object.get_position();
			if box != null:
				box = box.expand(objectv)
			else :
				box = Rect2(objectv, Vector2(1,1))
	return box

# Return a bound box that includes all objects_registered
func get_bounding_box_all(excludes = []) :
	var box
	var newbox

	for group in objects_registered:
		# only get bounding box for focused groups
		if group in camera_focus_on_group:
			newbox = get_bounding_box(group, excludes)
			if newbox != null :
				if box != null :
					box = box.merge(newbox)
				else :
					box = newbox
	return box


func set_camera(excludes =  []):
	#var bounding_box = get_bounding_box_all(excludes)
	var bounding_box = get_bounding_box(global.groups.player, excludes)

	if bounding_box != null :
		# set camera in the middle (*0.5) of the bounding box
		var camera = get_node(global.scene_tree_camera)
		camera.set_position(bounding_box.position + bounding_box.size*0.5)

		var window_size = get_viewport().get_visible_rect().size

		var zoom = bounding_box.size / window_size
		var zoom_max = max(max(zoom.x, zoom.y), 1)


		# check if bounding box (with all players) is visible in the camera screen,
		# if not - zoom out
		#print("zoom_max new: ", zoom_max, " window_size * zoom_max /2: ", window_size * zoom_max /2)
		# move camera screen center have of window size
		var camera_view_window = Rect2( camera.get_camera_screen_center() - window_size * zoom_max /2 , window_size * zoom_max )

		if !camera_view_window.has_point(bounding_box.position):
			#print("bounding_box: ", bounding_box, " camera_view_window: ", camera_view_window, " zoom_max: ", zoom_max)

			zoom_max *= camera_view_window.expand(bounding_box.position).size.length() / camera_view_window.size.length()

			#print("zoom_max new: ", zoom_max)
		#else:
		#	print("bounding_box: ", bounding_box, " camera_view_window: ", camera_view_window, " zoom_max: ", zoom_max)

		zoom_max *= 1.8

		# TODO - there is a zoom variable in moveable, that is not reset if zoom is set via set_camera
		# therefor its possible to use zoom keys and increase this variable, even zoom does not change

		#print("width ", d_width, " box size ", bounding_box.size, " zoomx ", zoomx, " zoomy ", zoomy)
		camera.set_zoom(Vector2(zoom_max, zoom_max))

func set_camera_zoom(zoom):
	var camera = get_node(global.scene_tree_camera)
	camera.set_zoom(Vector2(zoom, zoom));

func get_random_pos(distance = 400, excludes = []):

	randomize();
	var box = get_bounding_box_all(excludes)
	if box != null :
		box = box.position + box.size/2
	else :
		box = Vector2(0,0)
	var angle = rand_range(0, 2*PI)
	var pos = box +  (Vector2(sin(angle), cos(angle)) * distance)
	return pos
