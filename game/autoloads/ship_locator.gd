extends Node

var ships = {}

var players = []

func _ready():
	
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

func get_next_ship( group, pos ):
	# return first ship of given group
	if (ships.has(group)) :
		return ships[group].front()
	else :
		return null
	
func get_next_player( pos ) :
	return get_next_ship("player", pos)
	# return players[0]