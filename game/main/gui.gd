extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	
	
	network_manager.connect("start_client", get_node("Control/BtnConnect"), "hide")
	network_manager.connect("start_client", get_node("Control/BtnServer"), "hide")
	
	network_manager.connect("start_server", get_node("Control/BtnConnect"), "hide")
	network_manager.connect("start_server", get_node("Control/BtnServer"), "hide")
	network_manager.connect("start_server", get_node("Control/update"), "show")
	
	network_manager.connect("start_offline", get_node("Control/BtnConnect"), "show")
	network_manager.connect("start_offline", get_node("Control/BtnServer"), "show")

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_BtnConnect_pressed():
	network_manager.start_client()

func _on_BtnServer_pressed():
	network_manager.start_server()

func _on_update_pressed():
	network_manager._single_process()
