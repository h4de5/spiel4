extends Node

var connection_id

var SERVER_IP = "127.0.0.1"
var SERVER_PORT = 32112
var MAX_PLAYERS = 512

# Signals to let lobby GUI know what's going on
#signal player_list_changed()
#signal connection_failed()
#signal connection_succeeded()
#signal game_ended()
#signal game_error(what)


# Connect all functions
func _ready():
	
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_ok")
	get_tree().connect("connection_failed", self, "_connected_fail")
	get_tree().connect("server_disconnected", self, "_server_disconnected")
	
func network_activated():
	if get_tree().has_meta("network_peer"):
		return true
	else :
		return false
		
func is_server():
	if network_activated() and get_tree().is_network_server():
		return true
	else :
		return false
		
func is_master(node):
	if network_activated() and node.is_network_master():
		return true
	else :
		return false

func is_slave(node):
	if network_activated() and not node.is_network_master():
		return true
	else :
		return false

	# Called every time the node is added to the scene.
#	network_manager.connect("connection_failed", self, "_on_connection_failed")
#	network_manager.connect("connection_succeeded", self, "_on_connection_success")
#	network_manager.connect("player_list_changed", self, "refresh_lobby")
#	network_manager.connect("game_ended", self, "_on_game_ended")
#	network_manager.connect("game_error", self, "_on_game_error")

func _physics_process(delta):
	_single_process() 
	
func _single_process():
	if (get_tree().has_meta("network_peer") and get_tree().is_network_server()):
		#print ("sending network update..")
		for group in object_locator.objects_registered:
			for obj in object_locator.objects_registered[group]:
				if obj.is_network_master():
					obj.rpc_unreliable("set_network_update", obj.get_network_update())
	
	
# Player info, associate ID to data
var player_info = {}
# Info we send to other players
var my_info = { name = "Johnson Magenta", favorite_color = Color8(255, 0, 255) }

var players_done = []
	

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
	get_tree().set_meta("network_peer", null)
	pass # Server kicked us, show error and abort

func _connected_fail():
	print ("connection failed")
	get_tree().set_meta("network_peer", null)
	pass # Could not even connect to server, abort

func split_path(path):
	# /root/game/objects/Asteroid2
	# > objects
	var parts = String(path).split("/", false)
	return parts[2]
	

#remote func register_player(id, info):
remote func register_player(id, info):
	print ("register_player ", id , ' info ', info )
	# Store the info
	player_info[id] = info
	# If I'm the server, let the new guy know about existing players
	if (get_tree().is_network_server()):
		# Send my info to new player
		rpc_id(id, "register_player", 1, my_info)
		#rpc_id(id, "init_objects", object_locator.objects_registered)
		
		for group in object_locator.objects_registered:
			for obj in object_locator.objects_registered[group]:
				get_node(global.scene_tree_game).rpc_id(id, "spawn_object", obj.scene_path, split_path(obj.get_path()))
		
		
		# Send the info of existing players
		for peer_id in player_info:
			rpc_id(id, "register_player", peer_id, player_info[peer_id])
		# Call function to update lobby UI here
		
		rpc("pre_configure_game")

remote func init_objects(objects) :
	print ("init_objects")
	object_locator.objects_registered = objects
	
	
	
remote func pre_configure_game():
	print ("pre_configure_game")
	
	get_tree().set_pause(true) # Pre-pause
	# The rest is the same as in the code in the previous section (look above)
	
	var selfPeerID = get_tree().get_network_unique_id()
	
	# Load world
	#var world = load(which_level).instance()
	#get_node("/root").add_child(world)
	
	# Load my player
	#var my_player = preload("res://player.tscn").instance()
	#my_player.set_name(str(selfPeerID))
	#my_player.set_network_master(selfPeerID) # Will be explained later
	#get_node("/root/world/players").add_child(my_player)
	
	# Load other players
#	for p in player_info:
#		var player_node = get_node(global.scene_tree_game).spawn_player("Network", [p, player_info[p]])
#		player_node.set_name(player_node.get_name() +" "+ str(p))
	
	# Tell server (remember, server is always ID=1) that this peer is done pre-configuring
	rpc_id(1, "done_preconfiguring", selfPeerID)


remote func done_preconfiguring(who):
	print ("done_preconfiguring")
	
	# Here is some checks you can do, as example
	assert(get_tree().is_network_server())
	assert(who in player_info) # Exists
	assert(not who in players_done) # Was not added yet
	
	players_done.append(who)
	
	if (players_done.size() == player_info.size()):
		rpc("post_configure_game")

remote func post_configure_game():
	print ("post_configure_game")
	
	get_tree().set_pause(false)
	# Game starts now!



func start_server():
	print ("start server")
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(SERVER_PORT, MAX_PLAYERS)
	get_tree().set_network_peer(peer)
	get_tree().set_meta("network_peer", peer)
	
	set_physics_process(true)
	
	
func start_client():
	print ("connect to server..")
	var peer = NetworkedMultiplayerENet.new()
	peer.create_client(SERVER_IP, SERVER_PORT)
	get_tree().set_network_peer(peer)
	get_tree().set_meta("network_peer", peer)
	
	get_node(global.scene_tree_game).clear_game()
	
