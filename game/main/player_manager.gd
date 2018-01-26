# holds reference of players in the current game, spawn player on death
extends Node

var registered_devices = {
	InputEvent.KEY: [],
	InputEvent.JOYSTICK_BUTTON: []
}

var device_groups = {
	InputEvent.KEY: [InputEvent.KEY, InputEvent.MOUSE_MOTION, InputEvent.MOUSE_BUTTON ],
	InputEvent.JOYSTICK_BUTTON: [InputEvent.JOYSTICK_BUTTON, InputEvent.JOYSTICK_MOTION]
}

func _ready():
	#set_process_input(true)
	set_process_unhandled_input(true)

func unregister_device(inputtype, device):
	registered_devices[inputtype].erase(device)

# check all inputs
#func _input(event):
func _unhandled_input ( event ) :
	# if positive input event
	if (event.device != null && event.type != InputEvent.NONE) :
		#print("device input ", event.device, " with type ", event.type)
		var inputtype = null
		# see if we already have this device_group registered
		for device_group in device_groups :
			if device_groups[device_group].has(event.type):
				# if yes - remember device group
				inputtype = device_group
				break
		# if a new device group is was found, spawn a player with that device details
		if(inputtype != null && not registered_devices[inputtype].has(event.device)) :
			get_tree().set_input_as_handled()

			registered_devices[inputtype].append(event.device)
			get_node(global.scene_tree_game).spawn_player("Input",
				[event.device, device_groups[inputtype], inputtype])

