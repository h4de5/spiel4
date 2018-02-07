extends "res://game/processor/processor.gd"

var peer_id
var info

func set_processor_details(device_details):
	peer_id = device_details[0]
	info = device_details[1]

