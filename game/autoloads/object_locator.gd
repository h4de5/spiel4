# lists of all active ships in game, gets nearest ship, sets zoom to bounding box
extends Node

var objects_registered = {}

var camera_focus_on_group = [
	global.groups.player,
	global.groups.enemy,
	#global.groups.pickup
]

func _ready():
	set_fixed_process(true)

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


func get_next_player( pos, rot) :
	return get_next_ship(global.groups.player, pos, rot)

func get_next_ship( group, pos, rot):
	return get_next_object( group, pos, rot)

func get_next_object( group, pos, rot):
	# return first object of given group
	if (objects_registered.has(group)) and objects_registered[group].size() > 0:
		var dist = null
		var closest
		for object in objects_registered[group]:
			if dist == null or dist > pos-object.get_pos():
				dist = pos-object.get_pos()
				closest = object

		return closest #objects_registered[group].front()
	else :
		return null


	# return players[0]

func _fixed_process(delta):
	set_camera()

# Return a bound box that includes all objects_registered
func get_bounding_box(group, excludes = []) :
	var objectv
	var box

	for object in objects_registered[group]:
		if excludes.has(object):
			continue
		objectv = object.get_pos();
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

func set_camera(excludes = []):
	var bounding_box = get_bounding_box_all(excludes)

	if bounding_box != null :
		# set camera in the middle (*0.5) of the bounding box
		var camera = get_node(global.scene_tree_camera)
		camera.set_pos(bounding_box.pos + bounding_box.size*0.5)

		var window_size = get_viewport().get_rect().size

		var zoom = bounding_box.size / window_size
		var zoom_max = max(max(zoom.x, zoom.y), 1)
		zoom_max *= 1.3

		#print("width ", d_width, " box size ", bounding_box.size, " zoomx ", zoomx, " zoomy ", zoomy)
		camera.set_zoom(Vector2(zoom_max, zoom_max))

func set_camera_zoom(zoom):
	var camera = get_node(global.scene_tree_camera)
	camera.set_zoom(Vector2(zoom, zoom));

func get_random_pos(distance = 400, excludes = []):

	randomize();
	var box = get_bounding_box_all(excludes)
	if box != null :
		box = box.pos + box.size/2
	else :
		box = Vector2(0,0)
	var angle = rand_range(0, 2*PI)
	var pos = box +  (Vector2(sin(angle), cos(angle)) * distance)
	return pos
