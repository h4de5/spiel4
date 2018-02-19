extends Node

func _ready():

	network_manager.connect("determined_external_ip", self , "starting_server")


func starting_server(externalip):
	network_manager.start_server()
