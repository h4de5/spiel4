# holds reference of players in the current game, spawn player on death
extends Node

var registered_devices = {
	"InputEventKey": [],
	"InputEventJoypadButton": [],
	"InputEventScreenTouch": []
}

var device_groups = {
	"InputEventKey": ["InputEventKey", "InputEventMouseMotion", "InputEventMouseButton" ],
	"InputEventJoypadButton": ["InputEventJoypadButton", "InputEventJoypadMotion"],
	"InputEventScreenTouch": ["InputEventScreenTouch", "InputEventScreenDrag"],
}

func _ready():
	#set_process_input(true)
	set_process_unhandled_input(true)

func unregister_device(inputtype, device):
	registered_devices[inputtype].erase(device)
	pass

# check all inputs
#func _input(event):
func _unhandled_input ( event ) :
	# if positive input event
	# FIXME check here if is_action_type is ok - otherwise check for .get_class()
	#print("event ", event)
	#print("is_action_type ", event.is_action_type())
	#print("event get_class: ", event.get_class())
	#print("event typeof: ", typeof(event))
	#print("InputEventMouseButton: ", InputEventMouseButton)
	#print("get_class: ", InputEventMouseButton.get_class())
	#print("typeof: ", typeof(InputEventMouseButton))
	
	if (event.device != null && event.is_action_type()):
		print("device input ", event.device, " with type ", event.is_action_type())
		var inputtype = null
		# see if we already have this device_group registered
		for device_group in device_groups :
			#if device_groups[device_group].has(event):
			if device_groups[device_group].has(event.get_class()):
				# if yes - remember device group
				inputtype = device_group
				break
		# if a new device group is was found, spawn a player with that device details
		if(inputtype != null && not registered_devices[inputtype].has(event.device)) :
			get_tree().set_input_as_handled()

			registered_devices[inputtype].append(event.device)
			print ("spawning new player from input..")
			get_node(global.scene_tree_game).spawn_player("Input",
				[event.device, device_groups[inputtype], inputtype])

