extends Node

var players = []

func _ready():
	
	
	
	pass

func register_player( player ) :
	players.append(player)
	

func get_next_player( pos) :
	
	return players[0]