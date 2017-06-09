extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	
	print ("reset everything - new game")
	
	var enemy_scn = load("res://Obstacle.tscn")
	var enemyhealth_scn = load("res://Health.tscn")
	
	var enemy_node = enemy_scn.instance()
	var enemyhealth_node = enemyhealth_scn.instance()
	add_child(enemyhealth_node, true)
	add_child(enemy_node, true)
	
	enemyhealth_node.target = get_path_to(enemy_node)
	enemy_node.health_label = get_path_to(enemyhealth_node)
	
	
	
	
	pass

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