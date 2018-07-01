extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here


	network_manager.connect("start_client", find_node("BtnConnect"), "hide")
	network_manager.connect("start_client", find_node("BtnServer"), "hide")
	network_manager.connect("start_client", find_node("BtnDisconnect"), "show")

	network_manager.connect("start_server", find_node("BtnConnect"), "hide")
	network_manager.connect("start_server", find_node("BtnServer"), "hide")
	network_manager.connect("start_server", find_node("BtnUpdate"), "show")
	network_manager.connect("start_server", find_node("BtnDisconnect"), "show")

	network_manager.connect("start_offline", find_node("BtnConnect"), "show")
	network_manager.connect("start_offline", find_node("BtnServer"), "show")
	network_manager.connect("start_offline", find_node("BtnDisconnect"), "hide")
	network_manager.connect("start_offline", find_node("BtnUpdate"), "hide")

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func serverlist_returned(result, response_code, headers, body, params = []):
	var serverlist = find_node("Serverlist")
	serverlist.clear()

	var response = http_manager.on_request_completed(result, response_code, headers, body, params)
	if response and response.body:
		#var serverlist = get_node("Control/MarginList/VBoxContainer/Serverlist")

		var server_string = ""
		if response.body_parsed:
			for server in response.body_parsed:
				server_string = str(server.IP, ":", server.PORT, " (", server.ADDRESS_TYPE ,") - by ", server.USERNAME)
				serverlist.add_item(server_string)
		else:
			find_node("Serverlist").add_item("Could not find any active server :(", null, false)
	else:
		find_node("Serverlist").add_item("Connection to lobby server failed!", null, false)

func serverlist_refresh():
	find_node("Serverlist").clear()
	find_node("Serverlist").add_item("Loading...", null, false)

	http_manager.send(settings.game['client_lobby_url'],
		{"server": "list"}, "", "serverlist_returned", self)

func _on_BtnConnect_pressed():
	find_node("MarginList").show()
	#get_node(global.scene_tree_set).set_pause_mode(PAUSE_MODE_PROCESS)
	get_node("/root/game/gui").set_pause_mode(PAUSE_MODE_PROCESS)
	get_tree().paused = true
	# get_node(global.scene_tree_set).pause()

	serverlist_refresh()

func _on_BtnServer_pressed():
	network_manager.start_server()

func _on_BtnUpdate_pressed():
	network_manager._single_process()

func _on_BtnDisconnect_pressed():
	network_manager.disconnect_game()

func _on_BtnConnectTo_pressed():

	var server_data

	var selindex = find_node("Serverlist").get_selected_items()
	if selindex.size() > 0:
		var selitem = find_node("Serverlist").get_item_text(selindex[0])
		var itemdata = selitem.split(" ", false, 1)
		server_data = itemdata[0].split(":", false, 1)
		#print("sel item: ", selitem, " data: ", itemdata, " server: ", server_data)

	find_node("MarginList").hide()
	# get_node(global.scene_tree_set).pause(false)
	#get_node(global.scene_tree_set).set_pause_mode(PAUSE_MODE_STOP)
	get_node("/root/game/gui").set_pause_mode(PAUSE_MODE_INHERIT)
	get_tree().paused = false

	if server_data.size() > 0:
		# todo - add ip and port number
		network_manager.start_client(server_data[0], int(server_data[1]))

func _on_BtnRefresh_pressed():
	serverlist_refresh()

func _on_BtnCancel_pressed():
	find_node("MarginList").hide()
	get_node("/root/game/gui").set_pause_mode(PAUSE_MODE_INHERIT)
	get_tree().paused = false
