# main node to start game with, holds background, does ship spawing
extends Node2D

func _ready():
	print ("reset everything - new game")

	# set screen width
	OS.window_size = Vector2(settings.game['display_width'], settings.game['display_height'])

	
	for group in global.groups:
		var node = Node.new()
		node.name = group
		get_node("set").add_child(node)
	# add camera
#	var camera_scn = load(global.scene_path_camera)
#	var camera_node = camera_scn.instance()
#	add_child(camera_node, true)

	call_deferred("initialize")
	
		



	# when client starts, clear the game
	network_manager.connect("connected_as_client", self , "clear_game")

	#get_node(global.scene_tree_game).clear_game()

func initialize():
	for i in range(1): spawn_enemy()

	for i in range(0): spawn_tower()

	for i in range(2): spawn_pickup()

	for i in range(2): spawn_object(global.scene_path_asteroid)
	for i in range(4): spawn_object(global.scene_path_comet)



	# Background node
	# player_manager node

# client > spawn_player(input) > spawn_object > rpc spawn_player(network)
#												 server spawn_object > rpc spawn_object
#																		client spawn_object


remote func spawn_player(processor, device_details):
	print ("game > spawn_player > ", processor)
#	if get_tree().has_meta("network_peer") and processor == "Network" and device_details[0] == get_tree().get_network_unique_id():
#		print("skip this? processor: ", processor , " networkid: ", get_tree().get_network_unique_id())

	var player_node = spawn_object(global.scene_path_player, "", processor != "Network")

	print ("playername ", player_node.get_name())

	player_node.get_node("processor_selector").set_processor(processor)
	player_node.get_node("processor_selector").set_processor_details(device_details)


	if get_tree().has_meta("network_peer"):
		# only local players are net_work_masters
		if processor == 'Input':
			var selfPeerID = get_tree().get_network_unique_id()
			#player_node.set_name(player_node.get_name() +" "+ str(selfPeerID))
			player_node.set_network_master(selfPeerID) # Will be explained later
			if !get_tree().is_network_server():
				print ("game > spawn_player > not master!")
				rpc("spawn_player", "Network", [selfPeerID, player_node.get_name()])
		elif processor == 'Network':
			player_node.set_network_master(device_details[0]) # Will be explained later

	return player_node

func spawn_enemy():
	return spawn_object(global.scene_path_enemy)

func spawn_tower():
	return spawn_object(global.scene_path_tower)

func spawn_pickup():
	return spawn_object(global.scene_path_pickup)

# spawns an object in to the game
# can be path or packedScene
remote func spawn_object(scn, name = "", propagate = true):
	
	var scn_instance
	var scn_path
#	if not scn is PackedScene:
	scn_instance = load(scn)
	scn_path = scn
#	else:
#		scn_instance = scn
#		scn_path = scn.resource_path


	var node = scn_instance.instance()
	var group = node.object_group
	print ("spawn_object ", scn, " in " , group)
	
	# name should only be set, when propagete is false
	if name != "":
		node.set_name(name)
	get_node("set/" + group).add_child(node, true)
	node.scene_path = scn_path

	if(propagate):
		if network_manager.is_server():
			rpc("spawn_object", scn_path, node.get_name())

	return node


func clear_game():
	for group in object_locator.objects_registered:
		for i in range(object_locator.objects_registered[group].size()-1, -1, -1):
			var obj = object_locator.objects_registered[group][i]
		#for obj in object_locator.objects_registered[group]:
			#var obj = object_locator.objects_registered[group][o]
			#print ("objects_registered - group: ", group, " i ", i, " val ",  object_locator.objects_registered[group])
			var destroyable = interface.is_destroyable(obj)
			object_locator.free_object(obj)
			if destroyable :
				destroyable.destroy(null, true)
			else:
				obj.queue_free()


	# http://www.gamefromscratch.com/post/2015/02/23/Godot-Engine-Tutorial-Part-6-Multiple-Scenes-and-Global-Variables.aspx
#
#	func _ready():
#	   #On load set the current scene to the last scene available
#	   currentScene = get_tree().get_root().get_child(get_tree().get_root().get_child_count() -1)
#	   #Demonstrate setting a global variable.
#	   Globals.set("MAX_POWER_LEVEL",9000)
#
#	# create a function to switch between scenes
#	func setScene(scene):
#	   #clean up the current scene
#	   currentScene.queue_free()
#	   #load the file passed in as the param "scene"
#	   var s = ResourceLoader.load(scene)
#	   #create an instance of our scene
#	   currentScene = s.instance()
#	   # add scene to root
#	   get_tree().get_root().add_child(currentScene)
#