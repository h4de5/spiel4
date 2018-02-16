extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here


	network_manager.connect("start_client", get_node("Control/MarginContainer/VBoxContainer/BtnConnect"), "hide")
	network_manager.connect("start_client", get_node("Control/MarginContainer/VBoxContainer/BtnServer"), "hide")
	network_manager.connect("start_client", get_node("Control/MarginContainer/VBoxContainer/BtnDisconnect"), "show")

	network_manager.connect("start_server", get_node("Control/MarginContainer/VBoxContainer/BtnConnect"), "hide")
	network_manager.connect("start_server", get_node("Control/MarginContainer/VBoxContainer/BtnServer"), "hide")
	network_manager.connect("start_server", get_node("Control/MarginContainer/VBoxContainer/BtnUpdate"), "show")
	network_manager.connect("start_server", get_node("Control/MarginContainer/VBoxContainer/BtnDisconnect"), "show")

	network_manager.connect("start_offline", get_node("Control/MarginContainer/VBoxContainer/BtnConnect"), "show")
	network_manager.connect("start_offline", get_node("Control/MarginContainer/VBoxContainer/BtnServer"), "show")
	network_manager.connect("start_offline", get_node("Control/MarginContainer/VBoxContainer/BtnDisconnect"), "hide")
	network_manager.connect("start_offline", get_node("Control/MarginContainer/VBoxContainer/BtnUpdate"), "hide")

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_BtnConnect_pressed():
	network_manager.start_client()

func _on_BtnServer_pressed():
	network_manager.start_server()

func _on_BtnUpdate_pressed():
	network_manager._single_process()


func _on_BtnDisconnect_pressed():
	network_manager.disconnect_game()

