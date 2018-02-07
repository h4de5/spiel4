extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

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
