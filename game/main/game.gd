# main node to start game with, holds background, does ship spawing
extends Node2D

func _ready():
	print ("reset everything - new game")

	var camera_scn = load(global.scene_path_camera)
	var camera_node = camera_scn.instance()
	add_child(camera_node, true)

	#for i in range(1): spawn_enemy()

	#for i in range(2): spawn_tower()

	for i in range(2): spawn_pickup()

	for i in range(2): spawn_object(global.scene_path_asteroid, "objects")


	# Background node
	# player_manager node

func spawn_player(processor, device_details):
	var player_scn = load(global.scene_path_player)
	var player_node = player_scn.instance()
	get_node("ships").add_child(player_node, true)

	player_node.get_node("processor_selector").set_processor(processor)
	player_node.get_node("processor_selector").set_processor_details(device_details)

func spawn_enemy():
	var scn = load(global.scene_path_enemy)
	var node = scn.instance()
	get_node("ships").add_child(node, true)

func spawn_tower():
	var scn = load(global.scene_path_tower)
	var node = scn.instance()
	get_node("ships").add_child(node, true)

func spawn_pickup():
	var scn = load(global.scene_path_pickup)
	var node = scn.instance()
	get_node("objects").add_child(node, true)

func spawn_object(scnpath, group):
	var scn = load(scnpath)
	var node = scn.instance()
	get_node(group).add_child(node, true)

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