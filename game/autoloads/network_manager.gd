extends Node

var connection_id

#var SERVER_IP = "127.0.0.1"
#var SERVER_IP = "82.149.113.37"
var SERVER_IP = "172.17.0.2"
var SERVER_PORT = 8910
var MAX_PLAYERS = 512

# Signals to let lobby GUI know what's going on

#  when a player has been added, or removed
signal peer_list_changed(player_pool_size, networkid, add_or_remove) # server only signal

# when the game is switched to client mode
signal start_client()
# when the game is switched to server mode
signal start_server()
# when the game is switched to offline mode
signal start_offline()

# when external ip address has been determined
signal determined_external_ip(ip)

# when the client is connected to the server
signal connected_as_client()



#signal connection_failed()
#signal connection_succeeded()
#signal game_ended()
#signal game_error(what)


# Connect all functions
func _ready():

	get_tree().connect("network_peer_connected", self, "network_peer_connected")
	get_tree().connect("network_peer_disconnected", self, "network_peer_disconnected")
	#get_tree().connect("peer_connected", self, "peer_connected")
	#get_tree().connect("peer_disconnected", self, "peer_disconnected")
	get_tree().connect("connected_to_server", self, "connected_to_server")
	get_tree().connect("connection_failed", self, "connection_failed")
	#get_tree().connect("connection_succeeded", self, "connection_succeeded")

	get_tree().connect("server_disconnected", self, "server_disconnected")

	set_physics_process(false)

	init_local_information()


# methods to check current status

func is_network_activated():
	return get_tree().has_meta("network_peer")

func is_offline():
	return not is_network_activated()

func is_server():
	if is_network_activated() and get_tree().is_network_server():
		return true
	else :
		return false

func is_master(node):
	if is_network_activated() and node.is_network_master():
		return true
	else :
		return false

func is_slave(node):
	if is_network_activated() and not node.is_network_master():
		return true
	else :
		return false


# send updates to other clients
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
var my_info = { }

var players_done = []

func resolved_external_address(result, response_code, headers, body, params = []):
	var response = http.on_request_completed(result, response_code, headers, body, params)
	if response and response.body:
		my_info['ip'].append(response.body)
		# my_info['ip'] += ','+ response.body
		print("added external IP to my info: ", my_info.ip)
		emit_signal("determined_external_ip", my_info.ip)


func resolve_external_address():
	http.send("http://ip.icb.at", "", "", "resolved_external_address", self)

func init_local_information():

	# get all local adresses
	var ip_all = IP.get_local_addresses()
	var ip_valid = []
	# only add valid ones (no localhost, no ipv6, no ms fallback
	for ip in ip_all:
		print("Found local IP: ", ip)
		if ip.find(':') != -1: continue
		elif ip.substr(0,4) == '127.': continue
		elif ip.substr(0,4) == '169.': continue
		else: ip_valid.append(ip)

#	my_info["ip"] = PoolStringArray(ip_valid).join(",")
	my_info["ip"] = ip_valid
	call_deferred("resolve_external_address")

	my_info["port"] = SERVER_PORT
	my_info["os"] = OS.get_name()
	my_info["device"] = OS.get_model_name()
	var username = OS.get_user_data_dir()

	# remove everything before first slash
	var pos = username.find("/")
	username = username.substr(pos+1, username.length() - pos)
	# remove /Users/ and /home/
	username = username.replacen("Users/", "").replacen("home/", "")
	# remove everything after next slash
	if username.find("/") > 0:
		username = username.substr(0, username.find("/"))
	my_info["username"] = username

	print("my infos: ", my_info)


# Will go unused, not useful here
func network_peer_connected(id):
	print ("network_peer_connected")
	emit_signal("peer_list_changed", player_info.size(), id, 1)

func network_peer_disconnected(id):
	print ("network_peer_disconnected")
	# Erase player from info
	player_info.erase(id)
	emit_signal("peer_list_changed", player_info.size(), id, -1)

func connected_to_server():
	print ("connected_to_server")
	emit_signal("connected_as_client")

	# Only called on clients, not server. Send my ID and info to all the other peers
	rpc("register_player", get_tree().get_network_unique_id(), my_info)

# Server kicked us, show error and abort
func server_disconnected():
	print ("server_disconnected")
	get_tree().set_meta("network_peer", null)
	emit_signal("start_offline")

# Could not even connect to server, abort
func connection_failed():
	print ("connection_failed")
	get_tree().set_meta("network_peer", null)
	emit_signal("start_offline")

func connection_succeeded():
	print ("connection_succeeded")
	#get_tree().set_meta("network_peer", null)
	#emit_signal("start_offline")


func disconnect_game():
	print ("disconnect_game")

	var peer = get_tree().get_meta("network_peer")
	if peer:
		peer.close_connection()

	get_tree().set_meta("network_peer", null)
	emit_signal("start_offline")

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

		emit_signal("peer_list_changed", player_info.size(), id, -1)

		# go through all game objects, and spawn them accordingly on the new peer
		for group in object_locator.objects_registered:
			for obj in object_locator.objects_registered[group]:
				get_node(global.scene_tree_game).rpc_id(id, "spawn_object", obj.scene_path, split_path(obj.get_path()))

		# Send the info of existing players
		# no in use
		for peer_id in player_info:
			rpc_id(id, "register_player", peer_id, player_info[peer_id])

		# Call function to update lobby UI here
		# called on all peers
		rpc("pre_configure_game")

remote func pre_configure_game():
	print ("pre_configure_game")

	# game is paused for now
	get_tree().set_pause(true) # Pre-pause
	# The rest is the same as in the code in the previous section (look above)
	var selfPeerID = get_tree().get_network_unique_id()

	# Tell server (remember, server is always ID=1) that this peer is done pre-configuring
	rpc_id(1, "done_preconfiguring", selfPeerID)


# waits until all clients sent "done"
remote func done_preconfiguring(who):
	print ("done_preconfiguring")

	# Here is some checks you can do, as example
	assert(get_tree().is_network_server())
	assert(who in player_info) # Exists
	assert(not who in players_done) # Was not added yet

	players_done.append(who)

	if (players_done.size() == player_info.size()):
		rpc("post_configure_game")

# .. then continues the game
remote func post_configure_game():
	print ("post_configure_game")
	get_tree().set_pause(false)
	# Game starts now!

#
func start_server():
	print ("starting server...")
	var peer = NetworkedMultiplayerENet.new()
	var status = peer.create_server(SERVER_PORT, MAX_PLAYERS)

	print ("status: ", status)

	if status == 0:

		get_tree().set_network_peer(peer)
		get_tree().set_meta("network_peer", peer)

		set_physics_process(true)

		emit_signal("start_server")
		http.send("https://dev.pauschenwein.net/spiel4/lobby.php",
			{"server": "start"}, my_info, "registered_server", self)

	else :
		print ("Starting Server failed: ", status)
		peer.close_connection()


func start_client():
	print ("connect to server..")
	var peer = NetworkedMultiplayerENet.new()
	peer.create_client(SERVER_IP, SERVER_PORT)
	get_tree().set_network_peer(peer)
	get_tree().set_meta("network_peer", peer)

	set_physics_process(false)

	# clearing is done via signals now - because cool
	emit_signal("start_client")


func registered_server(result, response_code, headers, body, params = []):
	print("registered_server: ", result)

	var response = http.on_request_completed(result, response_code, headers, body, params)
	if response and response.body:
		print("response Body: ", response.body)
