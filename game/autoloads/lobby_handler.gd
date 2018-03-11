extends Node


# lobby ids for when run as a server
var own_lobby_ids = []
# node link to the heartbeat server when run as a server
var heartbeat_timer


# when the game is registered to the lobby web server
signal registered_server()

func _ready():
	# when server is startet, register it to the lobby
	network_manager.connect("start_server", self, "register_server")
	
	# once server is offline, stop timer
	network_manager.connect("start_offline", self, "unregister_server")

	# make own quit function	
	get_tree().set_auto_accept_quit(false)


# when quit request is send to game
func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		print ("Got quit request")
		# unregister from lobby - if registered 
		unregister_server()
		call_deferred("quit")

func quit():
	print ("Good Bye!")
	get_tree().quit() # default behavior

func register_server():
	http_manager.send(global.lobby_server_url,
		{"server": "start"}, network_manager.my_info, "registered_server", self)

func registered_server(result, response_code, headers, body, params = []):
	print("registered_server: ", result)

	var response = http_manager.on_request_completed(result, response_code, headers, body, params)
	if response and response.body_parsed:
		print("response Body: ", response.body_parsed)
		own_lobby_ids = response.body_parsed
		
		# server is now successfully registered to the lobby server
		emit_signal("registered_server")
		
		# Create a timer node
		heartbeat_timer = Timer.new()
		# Set timer interval
		heartbeat_timer.set_wait_time(30.0)
		# Set it as repeat
		heartbeat_timer.set_one_shot(false)
		# Connect its timeout signal to the function you want to repeat
		heartbeat_timer.connect("timeout", self, "send_heartbeat")
		# Add to the tree as child of the current node
		add_child(heartbeat_timer)
		heartbeat_timer.start()

func unregister_server():
	if heartbeat_timer:
		print ("Stopping heartbeat..")
		heartbeat_timer.stop()
		heartbeat_timer = null
		
	if own_lobby_ids:
		print ("Closing servers..")
		http_manager.send(global.lobby_server_url,
			{"server": "close"}, {"id": own_lobby_ids})
		own_lobby_ids = []
		
		
func send_heartbeat():
	http_manager.send(global.lobby_server_url,
		{"server": "ping"}, {"id": own_lobby_ids})

