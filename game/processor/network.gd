extends Node

var connection_id

var SERVER_IP = "127.0.0.1"
var SERVER_PORT = 32112
var MAX_PLAYERS = 512

func set_processor_details(device_details):
	connection_id = device_details


# Connect all functions
func _ready():
	
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_ok")
	get_tree().connect("connection_failed", self, "_connected_fail")
	get_tree().connect("server_disconnected", self, "_server_disconnected")
	
	#call_deferred("start_client")

# Player info, associate ID to data
var player_info = {}
# Info we send to other players
var my_info = { name = "Johnson Magenta", favorite_color = Color8(255, 0, 255) }

func _player_connected(id):
	print ("_player_connected")
	pass # Will go unused, not useful here

func _player_disconnected(id):
	print ("_player_disconnected")
	player_info.erase(id) # Erase player from info

func _connected_ok():
	print ("_connected_ok")
	# Only called on clients, not server. Send my ID and info to all the other peers
	rpc("register_player", get_tree().get_network_unique_id(), my_info)

func _server_disconnected():
	print ("_server_disconnected")
	pass # Server kicked us, show error and abort

func _connected_fail():
	print ("connnection failed")
	if get_tree():
		#var peer = get_tree().get_network_peer()
		#if not peer: 
		print ("starting server")
		start_server()
	
	pass # Could not even connect to server, abort


#remote func register_player(id, info):
func register_player(id, info):
	print ("register_player ", id  )
	# Store the info
	player_info[id] = info
	# If I'm the server, let the new guy know about existing players
	if (get_tree().is_network_server()):
	# Send my info to new player
		rpc_id(id, "register_player", 1, my_info)
		# Send the info of existing players
		for peer_id in player_info:
			rpc_id(id, "register_player", peer_id, player_info[peer_id])
		# Call function to update lobby UI here


func start_server():
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(SERVER_PORT, MAX_PLAYERS)
	get_tree().set_network_peer(peer)
	
	
func start_client():
	var peer = NetworkedMultiplayerENet.new()
	peer.create_client(SERVER_IP, SERVER_PORT)
	get_tree().set_network_peer(peer)
	
	

func _on_Button_pressed():
	start_client()
