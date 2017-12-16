extends Node

var ships = {}


func _ready():
	
	set_fixed_process(true)
	pass

func free_ship(ship) :
	# returns first group of ship
	var group
	group = ship.get_groups().front()
	
	for g in ships:
		ships[g].erase(ship)
	
func register_player( player ) :
	#players.append(player)
	register_ship(player)

func register_ship( ship ):
	
	# returns first group of ship
	var group
	group = ship.get_groups().front()
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
		return ships[group].front()
	else :
		return null
	
func get_next_player( pos, rot) :
	return get_next_ship("player", pos, rot)
	# return players[0]

func _fixed_process(delta):
	set_camera()
	

# Return a bound box that includes all player ships
func get_bounding_box(group) :
	#var minv = Vector2(0,0);
	#var maxv = Vector2(0,0);
	var shipv
	var box
	
	for ship in ships[group]:
		shipv = ship.get_pos();
		if box != null:
			box = box.expand(shipv)
		else :
			box = Rect2(shipv, Vector2(1,1))
		
		#minv.x = min(minv.x, shipv.x)
		#minv.y = min(minv.y, shipv.y)
		#maxv.x = max(maxv.x, shipv.x)
		#maxv.y = max(maxv.y, shipv.y)
	return box

# Return a bound box that includes all ships
func get_bounding_box_all() :
	var box
	var newbox
	
	for group in ships:
		newbox = get_bounding_box(group)
		if newbox != null :
			if box != null :
				box = box.merge(newbox)
			else :
				box = newbox
			
	return box

func set_camera():
	var bounding_box = get_bounding_box_all()
	
	if bounding_box != null :
		var camera = get_node("/root/Game/Camera")
		camera.set_pos(bounding_box.pos + bounding_box.size*0.5)
	
	# TODO - set zoom of camera correctly!
	
	#Globals.get("display/width")
	#Globals.get("display/height")
	
	#camera.set_zoom()
	
	#print("rect pos")
	#print(bounding_box)
	
	#var viewport = Viewport.new()
	#viewport.set_rect(bounding_box)
	#camera.set_viewport(viewport)

func set_camera_zoom(zoom):
	var camera = get_node("/root/Game/Camera")
	camera.set_zoom(Vector2(zoom, zoom));
	