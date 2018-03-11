extends Node

func _ready():
	network_manager.connect("resolved_external_address", self , "starting_server")

func starting_server(externalip):
	network_manager.start_server()
