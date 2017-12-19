extends Control

# class member variables go here, for example:
# var a = 2
# var b 	= "textvar"


func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	var restart_button = get_node("Restart")
	restart_button.connect("pressed", self, "buttonPressed", [restart_button])
	


func buttonPressed(target):
	#print ("pressed button: ", target.get_name())
	get_tree().change_scene(global.scene_path_game)
	#var newgame = get_tree().
	#newgame.get_node("/root/Game/Player").set_pos(Vector2(0, 0))
	#newgame.get_node("/root/Game/PlayerHealth").resetHealth()
	#newgame.get_node("/root/Game/ObstacleHealth").resetHealth()
	
	#get_node("/root/Game/Player").set_pos(Vector2(0, 0))
	#get_node("/root/Game/PlayerHealth").resetHealth()
	#get_node("/root/Game/ObstacleHealth").resetHealth()
	
	