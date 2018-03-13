extends Node

var connection_id

var MAX_PLAYERS = 512

# Player info, associate ID to data
var player_info = {}
# Info we send to other players
var my_info = { }

var players_done = []

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
signal resolved_external_address(ip)

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
		for group in object_locator.objects_registered:
			for obj in object_locator.objects_registered[group]:
				if obj.is_network_master():
					obj.rpc_unreliable("set_network_update", obj.get_network_update())


func resolved_external_address(result, response_code, headers, body, params = []):
	var response = http_manager.on_request_completed(result, response_code, headers, body, params)
	if response and response.body:
		my_info['ip'].append(response.body)
		# my_info['ip'] += ','+ response.body
		print("added external IP to my info: ", my_info.ip)
		emit_signal("resolved_external_address", my_info.ip)


func resolve_external_address():
	http_manager.send("http://ip.icb.at", "", "", "resolved_external_address", self)

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

	my_info["port"] = settings.game['server_default_port']
	my_info["os"] = OS.get_name()
	my_info["device"] = OS.get_model_name()
	var username = "User"

	# load username from environment
	if OS.has_environment( "LOGNAME" ):
		username = OS.get_environment( "LOGNAME" )
	elif OS.has_environment( "USERNAME" ):
		username = OS.get_environment( "USERNAME" )
	else :
		username = OS.get_user_data_dir()
		# remove everything before first slash
		var pos = username.find("/")
		username = username.substr(pos+1, username.length() - pos)
		print("username: ", username)
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
	# /root/game/set/objects/Asteroid2
	# > objects
	var parts = String(path).split("/", false)
	return parts[3]

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
	get_tree().paused = true #
	# get_tree().set_pause(true) # Pre-pause
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
	get_tree().paused = false
	# get_tree().set_pause(false)
	# Game starts now!


func start_server():
	print ("starting server...")
	var peer = NetworkedMultiplayerENet.new()
	var status = peer.create_server(settings.game['server_default_port'], MAX_PLAYERS)

	print ("status: ", status)

	if status == 0:
		get_tree().set_network_peer(peer)
		get_tree().set_meta("network_peer", peer)
		set_physics_process(true)
		emit_signal("start_server")
	else :
		print ("Starting Server failed: ", status)
		peer.close_connection()


func start_client(server_ip, server_port):
	print ("connect to server..")
	var peer = NetworkedMultiplayerENet.new()
	#peer.create_client(SERVER_IP, SERVER_PORT)
	peer.create_client(server_ip, server_port)
	get_tree().set_network_peer(peer)
	get_tree().set_meta("network_peer", peer)

	set_physics_process(false)

	# clearing is done via signals now - because cool
	emit_signal("start_client")

