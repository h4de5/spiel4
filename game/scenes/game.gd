extends Node2D

func _ready():
	print ("reset everything - new game")

	var enemy_scn = load(global.scene_path_enemy)
	var player_scn = load(global.scene_path_player)
	#var enemyhealth_scn = load("res://Health.tscn")

	var player_node = player_scn.instance()
	add_child(player_node, true)

	var enemy_node = enemy_scn.instance()
	add_child(enemy_node, true)
	enemy_node = enemy_scn.instance()
	add_child(enemy_node, true)

	# http://www.gamefromscratch.com/post/2015/02/23/Godot-Engine-Tutorial-Part-6-Multiple-Scenes-and-Global-Variables.aspx
	"""
	func _ready():
	   #On load set the current scene to the last scene available
	   currentScene = get_tree().get_root().get_child(get_tree().get_root().get_child_count() -1)
	   #Demonstrate setting a global variable.
	   Globals.set("MAX_POWER_LEVEL",9000)

	# create a function to switch between scenes
	func setScene(scene):
	   #clean up the current scene
	   currentScene.queue_free()
	   #load the file passed in as the param "scene"
	   var s = ResourceLoader.load(scene)
	   #create an instance of our scene
	   currentScene = s.instance()
	   # add scene to root
	   get_tree().get_root().add_child(currentScene)
	   """