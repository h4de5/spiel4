extends Node

var connection_id

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func set_processor_details(device_details):
	connection_id = device_details