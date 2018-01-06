# lists of all active ships in game, gets nearest ship, sets zoom to bounding box
extends Node

var ships = {}


func _ready():

	set_fixed_process(true)
	pass

func free_ship(ship) :
	# returns first group of ship
	#var group = ship.get_groups().front()
	var ship_groups = ship.get_groups()
	for group in  global.groups:
		if ship_groups.has(group):
			ships[group].erase(ship)
			break

	#for g in ships:


func register_player( player ) :
	#players.append(player)
	register_ship(player)

func register_ship( ship ):

	# returns first group of ship
	#var group = ship.get_groups().back()
	var ship_groups = ship.get_groups()
	var group
	for global_group in  global.groups:
		if ship_groups.has(global_group):
			group = global_group
			break

	if (group) :
		if (ships.has(group)) :
			ships[group].append(ship)
		else :
			#ships.append(group)
			ships[group] = [ship]
			#ships[group].append(ship)

func get_next_ship( group, pos, rot):
	# return first ship of given group
	if (ships.has(group)) and ships[group].size() > 0:
		var dist = null
		var closest
		for ship in ships[group]:
			if dist == null or dist > pos-ship.get_pos():
				dist = pos-ship.get_pos()
				closest = ship

		return closest #ships[group].front()
	else :
		return null

func get_next_player( pos, rot) :
	return get_next_ship(global.groups.player, pos, rot)
	# return players[0]

func _fixed_process(delta):
	set_camera()


# Return a bound box that includes all player ships
func get_bounding_box(group, excludes = []) :
	#var minv = Vector2(0,0);
	#var maxv = Vector2(0,0);
	var shipv
	var box

	for ship in ships[group]:
		if excludes.has(ship):
			continue
		shipv = ship.get_pos();
		if box != null:
			box = box.expand(shipv)
		else :
			box = Rect2(shipv, Vector2(1,1))
	return box

# Return a bound box that includes all ships
func get_bounding_box_all(excludes = []) :
	var box
	var newbox

	for group in ships:
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


#		var d_width = window_size.x
#		var d_height = window_size.y
#		print("width: ", d_width, " height: ", d_height,
#		" size: ", window_size, " bounding_box: ", bounding_box.size,
#		" div: ", window_size / bounding_box.size)
#
#
#		var zoomx = bounding_box.size.x / d_width
#		var zoomy = bounding_box.size.y / d_height
#		zoomx = max(zoomx, zoomy)
#		if(zoomx < 1) :
#			zoomx = 1
#
#		zoomx *= 1.3
#		#print("width ", d_width, " box size ", bounding_box.size, " zoomx ", zoomx, " zoomy ", zoomy)
#		camera.set_zoom(Vector2(zoomx,zoomx))

func set_camera_zoom(zoom):
	var camera = get_node(global.scene_tree_camera)
	camera.set_zoom(Vector2(zoom, zoom));
