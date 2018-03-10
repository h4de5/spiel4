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


func _on_BtnConnect_pressed():
	find_node("MarginList").show()
	get_node(global.scene_tree_set).set_pause_mode(PAUSE_MODE_PROCESS)
	# get_node(global.scene_tree_set).pause()

func _on_BtnServer_pressed():
	network_manager.start_server()

func _on_BtnUpdate_pressed():
	network_manager._single_process()

func _on_BtnDisconnect_pressed():
	network_manager.disconnect_game()

func _on_BtnConnectTo_pressed():
#	find_node("ServerList")
	var selindex = get_node("Control/MarginList/VBoxContainer/Serverlist").get_selected_items()
	var selitem = get_node("Control/MarginList/VBoxContainer/Serverlist").get_item_text(selindex[0])
	print("sel item: ", selitem)
	
	find_node("MarginList").hide()
	# get_node(global.scene_tree_set).pause(false)
	get_node(global.scene_tree_set).set_pause_mode(PAUSE_MODE_STOP)
	network_manager.start_client()
